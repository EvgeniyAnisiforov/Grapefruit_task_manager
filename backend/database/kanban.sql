
CREATE INDEX indx_odr_kabnan ON Kanban USING BTREE(ord); -- надо
SET enable_seqscan = OFF; -- не надо!

--select
--выводиться в порядке составленным пользователем, отдавать фронту в порядке "очередь"
CREATE OR REPLACE FUNCTION get_kanban_info(_id_user INT, 
										   OUT id_kanban INT, OUT task TEXT, 
										   OUT status VARCHAR(9), OUT level CHAR(1))
RETURNS SETOF RECORD AS $$
BEGIN 
RETURN QUERY
SELECT k.id_kanban, k.task, k.status, k.level FROM Kanban AS k WHERE k.id_user = _id_user ORDER BY ord ASC;
END;
$$ LANGUAGE plpgsql

--insert
CREATE OR REPLACE FUNCTION add_new_task(_id_user INT, _task TEXT, _level CHAR(1) DEFAULT '1')
RETURNS INT AS $$
DECLARE 
	res INT;
BEGIN
	INSERT INTO Kanban(id_user, task,level) VALUES(_id_user, _task, _level) RETURNING id_kanban INTO res;
	RETURN res;
EXCEPTION 
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN res;
END;
$$ LANGUAGE plpgsql

SELECT add_new_task(1,'help me','4')
SELECT * FROM USERS

CREATE OR REPLACE FUNCTION func_before_insert_kanban()
RETURNS TRIGGER AS $$ 
BEGIN 
	SELECT COALESCE(MAX(ord)+1, 1) INTO NEW.ord FROM Kanban WHERE status = NEW.status;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_kanban
BEFORE INSERT ON Kanban
FOR EACH ROW
EXECUTE FUNCTION func_before_insert_kanban();

--delete 
--после удаления посылать новый запрос к бд
CREATE OR REPLACE FUNCTION delete_task(_id_kanban INT)
RETURNS BOOL AS $$
BEGIN
	DELETE FROM Kanban WHERE id_kanban = _id_kanban;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION func_after_delete_kanban()
RETURNS TRIGGER AS $$
BEGIN
UPDATE Kanban SET ord = ord - 1 WHERE ord > OLD.ord AND status = OLD.status;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_delete_kanban
AFTER DELETE ON Kanban
FOR EACH ROW
EXECUTE FUNCTION func_after_delete_kanban();

--update при перетаскивании
--отлично удалось избежать необходимости нумеровать task на фронте, мне нужны только id_kanban
--в postgesql нельзя использовать сортировку вместе с обновлением 
CREATE OR REPLACE FUNCTION func_update_kanban_ord(_id_kanban_old INT, _id_kanban_new INT)
RETURNS BOOLEAN AS $$
DECLARE 
	old_ord INT = (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_old);
	new_ord INT= (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_new);	
	cur_status VARCHAR(9) = (SELECT status FROM Kanban WHERE id_kanban = _id_kanban_old);
	cursor_update REFCURSOR;
	cur_cursor_value RECORD;
	_flag INT = 1;
BEGIN
	CASE
		WHEN old_ord > new_ord THEN 
			OPEN cursor_update FOR SELECT id_kanban FROM Kanban
			WHERE ord >= new_ord AND ord < old_ord AND status = cur_status  
			ORDER BY ord DESC;
		WHEN old_ord < new_ord THEN
			_flag = -1;
			OPEN cursor_update FOR SELECT id_kanban FROM Kanban
			WHERE ord > old_ord AND ord <= new_ord AND status = cur_status 
			ORDER BY ord ASC;
		ELSE 
			RETURN true; --попытка перетащить в тоже место
	END CASE;	
	UPDATE Kanban SET ord = -1 WHERE id_kanban = _id_kanban_old; --переходная позиция для изменяемого ord
	LOOP
		FETCH NEXT FROM cursor_update INTO cur_cursor_value;
		EXIT WHEN NOT FOUND;
		UPDATE Kanban SET ord = ord + _flag WHERE id_kanban = cur_cursor_value.id_kanban;
	END LOOP;
	CLOSE cursor_update;
	UPDATE Kanban SET ord = new_ord WHERE id_kanban = _id_kanban_old;
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql;


SELECT func_update_kanban_ord(21,18)
SELECT * FROM Kanban ORDER BY ord

--update task
CREATE OR REPLACE FUNCTION update_task(_id_kanban INTEGER, _task TEXT, _level CHAR(1) DEFAULT '1' )
RETURNS BOOLEAN AS $$
BEGIN
	UPDATE Kanban SET task = _task, level=_level WHERE id_kanban = _id_kanban;
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$
LANGUAGE plpgsql

SELECT update_task(22,'update task','2')

--update при перетаскивании в другую категорию
CREATE OR REPLACE FUNCTION func_change_category(_id_kanban_old INT, _id_kanban_new INT DEFAULT NULL)
RETURNS BOOL AS $$
DECLARE
	old_ord INT = (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_old);
	new_ord INT= (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_new);	
	old_status VARCHAR(9) = (SELECT status FROM Kanban WHERE id_kanban = _id_kanban_old);
	new_status VARCHAR(9); 
	debag VARCHAR(9) ;
	cursor_update REFCURSOR;
	cur_cursor_value RECORD;
BEGIN
	--здесь должны быть ограничения, но для этого нужно транспонировать таблицу.
	CASE 
		WHEN old_status = 'задачи' THEN new_status = 'в работе';
		WHEN old_status = 'в работе' THEN new_status = 'выполнено';
	END CASE;
	
	UPDATE Kanban SET status = new_status, ord = COALESCE((SELECT MAX(ord)+1 FROM Kanban WHERE status = new_status ), 1)
	WHERE id_kanban = _id_kanban_old;
	debag = (SELECT status FROM Kanban WHERE id_kanban = _id_kanban_old);
	
	OPEN cursor_update FOR SELECT id_kanban FROM Kanban WHERE ord > old_ord AND status = old_status ORDER BY ord ASC;
	LOOP
		FETCH NEXT FROM cursor_update INTO cur_cursor_value;
		EXIT WHEN NOT FOUND;
		UPDATE Kanban SET ord = ord -1 WHERE id_kanban = cur_cursor_value.id_kanban;
	END LOOP;
	CLOSE cursor_update;
	RAISE NOTICE 'Возникло исключение: %',debag ;
	
	IF _id_kanban_new IS NOT NULL THEN 
		RETURN func_update_kanban_ord(_id_kanban_old, _id_kanban_new);
	ELSE 
		RETURN TRUE;
	END IF;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql



EXPLAIN ANALYZE INSERT INTO Kanban(id_user,task) VALUES(19,'ТРИГГЕР НА ВСТАВКУ');
SELECT * FROM kanban
SELECT func_change_category(20,23);
DELETE FROM KANBAN WHERE id_kanban=30
EXPLAIN ANALYZE SELECT get_kanban_info(18)
SELECT MAX(ord)+1 FROM Kanban

