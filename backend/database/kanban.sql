CREATE INDEX indx_odr_kabnan ON Kanban USING BTREE(ord); -- надо
CREATE INDEX indx_odr_status_kabnan ON Kanban USING BTREE(ord,status); -- надо
SET enable_seqscan = OFF; -- не надо!

--select
--выводиться в порядке составленным пользователем!
DROP FUNCTION get_kanban_info(_id_user INT)

CREATE OR REPLACE FUNCTION get_kanban_info(_id_user INT, 
										   OUT id_kanban INT, OUT task TEXT, 
										   OUT VARCHAR(9), OUT level CHAR(1))
RETURNS SETOF RECORD AS $$
BEGIN 
RETURN QUERY
SELECT k.id_kanban, k.task,
(SELECT s.status FROM Status as s WHERE s.id_status = k.status),
k.level FROM Kanban AS k WHERE k.id_user = _id_user ORDER BY k.status ASC, k.ord ASC;
END;
$$ LANGUAGE plpgsql

SELECT get_kanban_info(19)


--insert
CREATE OR REPLACE FUNCTION add_new_task(_id_user INT, _task TEXT, _level CHAR(1) DEFAULT '1')
RETURNS INT AS $$
DECLARE 
	res INT;
BEGIN
	INSERT INTO Kanban(id_user, task,level) VALUES(_id_user, _task, _level) RETURNING id_kanban INTO res;
	IF NOT FOUND THEN  
	RAISE EXCEPTION 'смотрите документацию';
	END IF;
	RETURN res;
EXCEPTION 
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql

SELECT add_new_task(-1,'TEA OF DARK','4')
SELECT * FROM KANBAN

CREATE OR REPLACE FUNCTION func_before_insert_kanban()
RETURNS TRIGGER AS $$ 
BEGIN 
--WHERE status = NEW.status очень важно оставить возможны случаи когда макс будет в другой категории
	SELECT COALESCE(MAX(ord)+1, 1) INTO NEW.ord FROM Kanban WHERE status = NEW.status;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_kanban
BEFORE INSERT ON Kanban
FOR EACH ROW
EXECUTE FUNCTION func_before_insert_kanban();

--delete 

CREATE OR REPLACE FUNCTION delete_task(_id_kanban INT)
RETURNS BOOL AS $$
BEGIN
	DELETE FROM Kanban WHERE id_kanban = _id_kanban ;
	IF NOT FOUND THEN  
	RAISE EXCEPTION 'Задачи не существует';
	END IF;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$ LANGUAGE plpgsql

SELECT delete_task(5)
SELECT * FROM KANBAN

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



--update task
CREATE OR REPLACE FUNCTION update_task(_id_kanban INTEGER, _task TEXT DEFAULT NULL , _level CHAR(1) DEFAULT NULL )
RETURNS BOOLEAN AS $$
BEGIN
	UPDATE Kanban SET task = COALESCE(_task, task), level= COALESCE (_level, level) WHERE id_kanban = _id_kanban;
	IF NOT FOUND THEN  
	RAISE EXCEPTION 'Задачи не существует';
	END IF;
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$
LANGUAGE plpgsql

--update при перетаскивании
--отлично удалось избежать необходимости нумеровать task на фронте, мне нужны только id_kanban
--в postgesql нельзя использовать сортировку вместе с обновлением 
--hear
DROP FUNCTION replace_task(_id_kanban_old INT, _id_kanban_new INT )

CREATE OR REPLACE FUNCTION replace_task(_id_kanban_old INT, _id_kanban_new INT )
RETURNS BOOL AS $$
DECLARE 
	old_ord INT = (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_old);
	old_status INT = (SELECT status FROM Kanban WHERE id_kanban = _id_kanban_old);
	new_ord INT = (SELECT ord FROM Kanban WHERE id_kanban = _id_kanban_new);	
	new_status INT = (SELECT status FROM Kanban WHERE id_kanban = _id_kanban_new);
	_flag INT = 1;
	cursor_update REFCURSOR;
	cursor_value RECORD;
	cursor_update2 REFCURSOR;
	cursor_value2 RECORD;
BEGIN
	CASE
		WHEN _id_kanban_new < 0 THEN 
			_flag = -1;
			new_status = ABS(_id_kanban_new);
			IF ABS(new_status - old_status) > 1 THEN
				RAISE EXCEPTION 'нарушение логики';
			END IF;			
			new_ord = COALESCE((SELECT MAX(ord) FROM Kanban WHERE status = new_status ), 1);
			OPEN cursor_update FOR
			SELECT id_kanban FROM Kanban WHERE (status = old_status AND ord > old_ord) ORDER BY ord ASC;	
			UPDATE Kanban SET ord = -1, status = -1 WHERE id_kanban = _id_kanban_old; --переходная позиция для изменяемого ord
			
		WHEN (old_status!= new_status) THEN
			IF ABS(new_status - old_status) > 1 THEN
				RAISE EXCEPTION 'нарушение логики';
			ELSE 
				OPEN cursor_update FOR 
				SELECT id_kanban FROM Kanban WHERE (status = old_status AND ord > old_ord) ORDER BY ord ASC;
				OPEN cursor_update2 FOR 
				SELECT id_kanban FROM Kanban WHERE (status = new_status AND ord >= new_ord) ORDER BY ord DESC;
			END IF;	
			
			UPDATE Kanban SET ord = -1, status = -1 WHERE id_kanban = _id_kanban_old; --переходная позиция для изменяемого ord
	
			LOOP
				FETCH NEXT FROM cursor_update2 INTO cursor_value2;
				EXIT WHEN NOT FOUND;
				UPDATE Kanban SET ord = ord + _flag WHERE id_kanban = cursor_value2.id_kanban;
			END LOOP;
			CLOSE cursor_update2;
			_flag = -1;
			
		WHEN old_ord > new_ord THEN 
			OPEN cursor_update FOR SELECT id_kanban FROM Kanban
			WHERE ord >= new_ord AND ord < old_ord AND status = old_status  
			ORDER BY ord DESC;
			UPDATE Kanban SET ord = -1 WHERE id_kanban = _id_kanban_old; --переходная позиция для изменяемого ord
			
		WHEN old_ord < new_ord THEN
			_flag = -1;
			OPEN cursor_update FOR SELECT id_kanban FROM Kanban
			WHERE ord > old_ord AND ord <= new_ord AND status = old_status 
			ORDER BY ord ASC;
			UPDATE Kanban SET ord = -1 WHERE id_kanban = _id_kanban_old; --переходная позиция для изменяемого ord
			
		ELSE 
			RETURN true; --попытка перетащить в то же место
	END CASE;
	
	LOOP
		FETCH NEXT FROM cursor_update INTO cursor_value;
		EXIT WHEN NOT FOUND;
		UPDATE Kanban SET ord = ord + _flag WHERE id_kanban = cursor_value.id_kanban;
	END LOOP;
	
	CLOSE cursor_update;
	
	UPDATE Kanban SET ord = new_ord, status = new_status WHERE id_kanban = _id_kanban_old;
	RETURN TRUE;
	
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$$ language plpgsql




SELECT replace_task(10,-1)

EXPLAIN ANALYZE INSERT INTO Kanban(id_user,task) VALUES(19,'ТРИГГЕР НА ВСТАВКУ');
SELECT * FROM kanban ORDER BY STATUS, ORD
SELECT func_change_category(20,23);
DELETE FROM KANBAN WHERE id_kanban=30
EXPLAIN ANALYZE SELECT get_kanban_info(18)
SELECT MAX(ord)+1 FROM Kanban

