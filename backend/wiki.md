Вот бд конфиг:
database: grapefruit
host: localhost
port: 5432
username: ilia
password: ilia
Вот скрипты:
-- Table: public.kanban

-- DROP TABLE IF EXISTS public.kanban;

CREATE TABLE IF NOT EXISTS public.kanban
(
    id_kanban integer NOT NULL DEFAULT nextval('kanban_id_kanban_seq'::regclass),
    id_user integer NOT NULL,
    task text COLLATE pg_catalog."default" NOT NULL,
    status character varying(9) COLLATE pg_catalog."default" NOT NULL DEFAULT 'задачи'::character varying,
    level character(1) COLLATE pg_catalog."default" NOT NULL DEFAULT '1'::bpchar,
    ord integer NOT NULL DEFAULT '-1'::integer,
    CONSTRAINT kanban_pkey PRIMARY KEY (id_kanban),
    CONSTRAINT u_ord_status UNIQUE (ord, status),
    CONSTRAINT fk_id_user FOREIGN KEY (id_user)
        REFERENCES public.users (id_user) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ch_level CHECK (level >= '1'::bpchar AND level <= '5'::bpchar),
    CONSTRAINT ch_status CHECK (status::text = ANY (ARRAY['задачи'::character varying::text, 'в работе'::character varying::text, 'выполнено'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.kanban
    OWNER to sonia;

REVOKE ALL ON TABLE public.kanban FROM ilia;

GRANT SELECT ON TABLE public.kanban TO ilia;

GRANT ALL ON TABLE public.kanban TO sonia;
-- Index: indx_odr_kabnan

-- DROP INDEX IF EXISTS public.indx_odr_kabnan;

CREATE INDEX IF NOT EXISTS indx_odr_kabnan
    ON public.kanban USING btree
    (ord ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: trg_after_delete_kanban

-- DROP TRIGGER IF EXISTS trg_after_delete_kanban ON public.kanban;

CREATE OR REPLACE TRIGGER trg_after_delete_kanban
    AFTER DELETE
    ON public.kanban
    FOR EACH ROW
    EXECUTE FUNCTION public.func_after_delete_kanban();

-- Trigger: trg_before_insert_kanban

-- DROP TRIGGER IF EXISTS trg_before_insert_kanban ON public.kanban;

CREATE OR REPLACE TRIGGER trg_before_insert_kanban
    BEFORE INSERT
    ON public.kanban
    FOR EACH ROW
    EXECUTE FUNCTION public.func_before_insert_kanban();

-- Table: public.matrix

-- DROP TABLE IF EXISTS public.matrix;

CREATE TABLE IF NOT EXISTS public.matrix
(
    id_matrix integer NOT NULL DEFAULT nextval('matrix_id_matrix_seq'::regclass),
    id_user integer NOT NULL,
    task text COLLATE pg_catalog."default" NOT NULL,
    status character varying(25) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT matrix_pkey PRIMARY KEY (id_matrix),
    CONSTRAINT fk_id_user FOREIGN KEY (id_user)
        REFERENCES public.users (id_user) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ch_status CHECK (status::text = ANY (ARRAY['срочно и важно'::character varying::text, 'срочно и не важно'::character varying::text, 'не срочно но важно'::character varying::text, 'не срочно не важно'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.matrix
    OWNER to sonia;

REVOKE ALL ON TABLE public.matrix FROM ilia;

GRANT SELECT ON TABLE public.matrix TO ilia;

GRANT ALL ON TABLE public.matrix TO sonia;

-- Table: public.matrix

-- DROP TABLE IF EXISTS public.matrix;

CREATE TABLE IF NOT EXISTS public.matrix
(
    id_matrix integer NOT NULL DEFAULT nextval('matrix_id_matrix_seq'::regclass),
    id_user integer NOT NULL,
    task text COLLATE pg_catalog."default" NOT NULL,
    status character varying(25) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT matrix_pkey PRIMARY KEY (id_matrix),
    CONSTRAINT fk_id_user FOREIGN KEY (id_user)
        REFERENCES public.users (id_user) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ch_status CHECK (status::text = ANY (ARRAY['срочно и важно'::character varying::text, 'срочно и не важно'::character varying::text, 'не срочно но важно'::character varying::text, 'не срочно не важно'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.matrix
    OWNER to sonia;

REVOKE ALL ON TABLE public.matrix FROM ilia;

GRANT SELECT ON TABLE public.matrix TO ilia;

GRANT ALL ON TABLE public.matrix TO sonia;

-- Table: public.tracker

-- DROP TABLE IF EXISTS public.tracker;

CREATE TABLE IF NOT EXISTS public.tracker
(
    id_tracker integer NOT NULL DEFAULT nextval('tracker_id_tracker_seq'::regclass),
    id_user integer NOT NULL,
    task text COLLATE pg_catalog."default" NOT NULL,
    last_time timestamp without time zone NOT NULL,
    CONSTRAINT tracker_pkey PRIMARY KEY (id_tracker),
    CONSTRAINT fk_id_user FOREIGN KEY (id_user)
        REFERENCES public.users (id_user) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tracker
    OWNER to sonia;

REVOKE ALL ON TABLE public.tracker FROM ilia;

GRANT SELECT ON TABLE public.tracker TO ilia;

GRANT ALL ON TABLE public.tracker TO sonia;

-- Table: public.users

-- DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    id_user integer NOT NULL DEFAULT nextval('users_id_user_seq'::regclass),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    surname character varying(50) COLLATE pg_catalog."default" NOT NULL,
    login character varying(60) COLLATE pg_catalog."default" NOT NULL,
    hash_passwd character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id_user),
    CONSTRAINT users_login_key UNIQUE (login)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to sonia;

REVOKE ALL ON TABLE public.users FROM ilia;

GRANT SELECT ON TABLE public.users TO ilia;

GRANT ALL ON TABLE public.users TO sonia;


-- FUNCTION: public.add_new_task(integer, text, character)

-- DROP FUNCTION IF EXISTS public.add_new_task(integer, text, character);

CREATE OR REPLACE FUNCTION public.add_new_task(
	_id_user integer,
	_task text,
	_level character DEFAULT '1'::bpchar)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.add_new_task(integer, text, character)
    OWNER TO sonia;



-- FUNCTION: public.add_new_task(text, character)

-- DROP FUNCTION IF EXISTS public.add_new_task(text, character);

CREATE OR REPLACE FUNCTION public.add_new_task(
	_task text,
	_level character DEFAULT '1'::bpchar)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	INSERT INTO Kanban(task,level) VALUES(task,level) RETURNING id_kanban;
EXCEPTION 
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN -1;
END;
$BODY$;

ALTER FUNCTION public.add_new_task(text, character)
    OWNER TO sonia;


-- FUNCTION: public.authorization(character varying, character varying)

-- DROP FUNCTION IF EXISTS public."authorization"(character varying, character varying);

CREATE OR REPLACE FUNCTION public."authorization"(
	_login character varying,
	_passwd character varying,
	OUT id_user integer,
	OUT name character varying,
	OUT surname character varying)
    RETURNS SETOF record 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
	RETURN QUERY
	SELECT us.id_user, us.name, us.surname FROM Users AS us WHERE us.login = _login AND
	us.hash_passwd = crypt(_passwd,us.hash_passwd);
	
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;	
END;
$BODY$;

ALTER FUNCTION public."authorization"(character varying, character varying)
    OWNER TO sonia;



-- FUNCTION: public.func_change_category(integer, integer)

-- DROP FUNCTION IF EXISTS public.func_change_category(integer, integer);

CREATE OR REPLACE FUNCTION public.func_change_category(
	_id_kanban_old integer,
	_id_kanban_new integer DEFAULT NULL::integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.func_change_category(integer, integer)
    OWNER TO sonia;


-- FUNCTION: public.func_update_kanban_ord(integer, integer)

-- DROP FUNCTION IF EXISTS public.func_update_kanban_ord(integer, integer);

CREATE OR REPLACE FUNCTION public.func_update_kanban_ord(
	_id_kanban_old integer,
	_id_kanban_new integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.func_update_kanban_ord(integer, integer)
    OWNER TO sonia;


-- FUNCTION: public.delete_task(integer)

-- DROP FUNCTION IF EXISTS public.delete_task(integer);

CREATE OR REPLACE FUNCTION public.delete_task(
	_id_kanban integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	DELETE FROM Kanban WHERE id_kanban = _id_kanban;
	RETURN TRUE;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$BODY$;

ALTER FUNCTION public.delete_task(integer)
    OWNER TO sonia;


-- FUNCTION: public.func_change_category(integer, integer)

-- DROP FUNCTION IF EXISTS public.func_change_category(integer, integer);

CREATE OR REPLACE FUNCTION public.func_change_category(
	_id_kanban_old integer,
	_id_kanban_new integer DEFAULT NULL::integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.func_change_category(integer, integer)
    OWNER TO sonia;
-- FUNCTION: public.func_update_kanban_ord(integer, integer)

-- DROP FUNCTION IF EXISTS public.func_update_kanban_ord(integer, integer);

CREATE OR REPLACE FUNCTION public.func_update_kanban_ord(
	_id_kanban_old integer,
	_id_kanban_new integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.func_update_kanban_ord(integer, integer)
    OWNER TO sonia;
-- FUNCTION: public.get_kanban_info(integer)

-- DROP FUNCTION IF EXISTS public.get_kanban_info(integer);

CREATE OR REPLACE FUNCTION public.get_kanban_info(
	_id_user integer,
	OUT id_kanban integer,
	OUT task text,
	OUT status character varying,
	OUT level character)
    RETURNS SETOF record 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN 
RETURN QUERY
SELECT k.id_kanban, k.task, k.status, k.level FROM Kanban AS k WHERE k.id_user = _id_user ORDER BY ord ASC;
END;
$BODY$;

ALTER FUNCTION public.get_kanban_info(integer)
    OWNER TO sonia;


-- FUNCTION: public.registration(character varying, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS public.registration(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.registration(
	_login character varying,
	_hash_passwd character varying,
	_name character varying,
	_surname character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	INSERT INTO Users(login,hash_passwd,name,surname) VALUES(_login,crypt(_hash_passwd,gen_salt('md5')),_name,_surname);
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;	
END;
$BODY$;

ALTER FUNCTION public.registration(character varying, character varying, character varying, character varying)
    OWNER TO sonia;

GRANT EXECUTE ON FUNCTION public.registration(character varying, character varying, character varying, character varying) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.registration(character varying, character varying, character varying, character varying) TO ilia;

GRANT EXECUTE ON FUNCTION public.registration(character varying, character varying, character varying, character varying) TO sonia;

-- FUNCTION: public.update_task(integer, text, character)

-- DROP FUNCTION IF EXISTS public.update_task(integer, text, character);

CREATE OR REPLACE FUNCTION public.update_task(
	_id_kanban integer,
	_task text,
	_level character DEFAULT '1'::bpchar)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	UPDATE Kanban SET task = _task, level=_level WHERE id_kanban = _id_kanban;
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;
END;
$BODY$;

ALTER FUNCTION public.update_task(integer, text, character)
    OWNER TO sonia;


