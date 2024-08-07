PGDMP      ;                |            task_manager    16.2    16.2 p    ]           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ^           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            _           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            `           1262    41372    task_manager    DATABASE     �   CREATE DATABASE task_manager WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE task_manager;
                db_admin    false                        3079    41457    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            a           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                       1255    41635    add_new_task(text, character)    FUNCTION     H  CREATE FUNCTION public.add_new_task(_task text, _level character DEFAULT '1'::bpchar) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Kanban(task,level) VALUES(task,level) RETURNING id_kanban;
EXCEPTION 
	WHEN OTHERS THEN
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN -1;
END;
$$;
 A   DROP FUNCTION public.add_new_task(_task text, _level character);
       public          sonia    false                       1255    41636 &   add_new_task(integer, text, character)    FUNCTION     �  CREATE FUNCTION public.add_new_task(_id_user integer, _task text, _level character DEFAULT '1'::bpchar) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 S   DROP FUNCTION public.add_new_task(_id_user integer, _task text, _level character);
       public          sonia    false            b           0    0    FUNCTION armor(bytea)    ACL     3   GRANT ALL ON FUNCTION public.armor(bytea) TO ilia;
          public          postgres    false    273            c           0    0 %   FUNCTION armor(bytea, text[], text[])    ACL     C   GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO ilia;
          public          postgres    false    274                       1255    41710 3   authorization(character varying, character varying)    FUNCTION     Q  CREATE FUNCTION public."authorization"(_login character varying, _passwd character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE 
	res RECORD;
BEGIN
	SELECT us.id_user, us.name, us.surname INTO res FROM Users AS us WHERE us.login = _login AND
	us.hash_passwd = crypt(_passwd,us.hash_passwd);
	IF NOT FOUND THEN  
	RAISE EXCEPTION 'Пользователь с указанными логином и паролем не найден';
	END IF;
	RETURN res;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;	
	RETURN NULL;
END;
$$;
 [   DROP FUNCTION public."authorization"(_login character varying, _passwd character varying);
       public          sonia    false            d           0    0    FUNCTION crypt(text, text)    ACL     8   GRANT ALL ON FUNCTION public.crypt(text, text) TO ilia;
          public          postgres    false    234            e           0    0    FUNCTION dearmor(text)    ACL     4   GRANT ALL ON FUNCTION public.dearmor(text) TO ilia;
          public          postgres    false    275            f           0    0 $   FUNCTION decrypt(bytea, bytea, text)    ACL     B   GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO ilia;
          public          postgres    false    238            g           0    0 .   FUNCTION decrypt_iv(bytea, bytea, bytea, text)    ACL     L   GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO ilia;
          public          postgres    false    240                       1255    41637    delete_task(integer)    FUNCTION     }  CREATE FUNCTION public.delete_task(_id_kanban integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;
 6   DROP FUNCTION public.delete_task(_id_kanban integer);
       public          sonia    false            h           0    0    FUNCTION digest(bytea, text)    ACL     :   GRANT ALL ON FUNCTION public.digest(bytea, text) TO ilia;
          public          postgres    false    231            i           0    0    FUNCTION digest(text, text)    ACL     9   GRANT ALL ON FUNCTION public.digest(text, text) TO ilia;
          public          postgres    false    230            j           0    0 $   FUNCTION encrypt(bytea, bytea, text)    ACL     B   GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO ilia;
          public          postgres    false    237            k           0    0 .   FUNCTION encrypt_iv(bytea, bytea, bytea, text)    ACL     L   GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO ilia;
          public          postgres    false    239                       1255    41626    func_after_delete_kanban()    FUNCTION     �   CREATE FUNCTION public.func_after_delete_kanban() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE Kanban SET ord = ord - 1 WHERE ord > OLD.ord AND status = OLD.status;
RETURN OLD;
END;
$$;
 1   DROP FUNCTION public.func_after_delete_kanban();
       public          sonia    false            �            1255    41618    func_before_insert_kanban()    FUNCTION     w  CREATE FUNCTION public.func_before_insert_kanban() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
--WHERE status = NEW.status очень важно оставить возможны случаи когда макс будет в другой категории
	SELECT COALESCE(MAX(ord)+1, 1) INTO NEW.ord FROM Kanban WHERE status = NEW.status;
	RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.func_before_insert_kanban();
       public          sonia    false                       1255    41641 &   func_change_category(integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_change_category(_id_kanban_old integer, _id_kanban_new integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;
 [   DROP FUNCTION public.func_change_category(_id_kanban_old integer, _id_kanban_new integer);
       public          sonia    false                       1255    41630 (   func_update_kanban_ord(integer, integer)    FUNCTION     �  CREATE FUNCTION public.func_update_kanban_ord(_id_kanban_old integer, _id_kanban_new integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;
 ]   DROP FUNCTION public.func_update_kanban_ord(_id_kanban_old integer, _id_kanban_new integer);
       public          sonia    false            l           0    0 "   FUNCTION gen_random_bytes(integer)    ACL     @   GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO ilia;
          public          postgres    false    241            m           0    0    FUNCTION gen_random_uuid()    ACL     8   GRANT ALL ON FUNCTION public.gen_random_uuid() TO ilia;
          public          postgres    false    242            n           0    0    FUNCTION gen_salt(text)    ACL     5   GRANT ALL ON FUNCTION public.gen_salt(text) TO ilia;
          public          postgres    false    235            o           0    0     FUNCTION gen_salt(text, integer)    ACL     >   GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO ilia;
          public          postgres    false    236                       1255    41741    get_kanban_info(integer)    FUNCTION     �  CREATE FUNCTION public.get_kanban_info(_id_user integer, OUT id_kanban integer, OUT task text, OUT character varying, OUT level character) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
BEGIN 
RETURN QUERY
SELECT k.id_kanban, k.task,
(SELECT s.status FROM Status as s WHERE s.id_status = k.status),
k.level FROM Kanban AS k WHERE k.id_user = _id_user ORDER BY k.status ASC, k.ord ASC;
END;
$$;
 �   DROP FUNCTION public.get_kanban_info(_id_user integer, OUT id_kanban integer, OUT task text, OUT character varying, OUT level character);
       public          sonia    false            p           0    0 !   FUNCTION hmac(bytea, bytea, text)    ACL     ?   GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO ilia;
          public          postgres    false    233            q           0    0    FUNCTION hmac(text, text, text)    ACL     =   GRANT ALL ON FUNCTION public.hmac(text, text, text) TO ilia;
          public          postgres    false    232            r           0    0 >   FUNCTION pgp_armor_headers(text, OUT key text, OUT value text)    ACL     \   GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO ilia;
          public          postgres    false    276            s           0    0    FUNCTION pgp_key_id(bytea)    ACL     8   GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO ilia;
          public          postgres    false    272            t           0    0 &   FUNCTION pgp_pub_decrypt(bytea, bytea)    ACL     D   GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO ilia;
          public          postgres    false    266            u           0    0 ,   FUNCTION pgp_pub_decrypt(bytea, bytea, text)    ACL     J   GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO ilia;
          public          postgres    false    268            v           0    0 2   FUNCTION pgp_pub_decrypt(bytea, bytea, text, text)    ACL     P   GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO ilia;
          public          postgres    false    270            w           0    0 ,   FUNCTION pgp_pub_decrypt_bytea(bytea, bytea)    ACL     J   GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO ilia;
          public          postgres    false    267            x           0    0 2   FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text)    ACL     P   GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO ilia;
          public          postgres    false    269            y           0    0 8   FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text)    ACL     V   GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO ilia;
          public          postgres    false    271            z           0    0 %   FUNCTION pgp_pub_encrypt(text, bytea)    ACL     C   GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO ilia;
          public          postgres    false    255            {           0    0 +   FUNCTION pgp_pub_encrypt(text, bytea, text)    ACL     I   GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO ilia;
          public          postgres    false    263            |           0    0 ,   FUNCTION pgp_pub_encrypt_bytea(bytea, bytea)    ACL     J   GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO ilia;
          public          postgres    false    262            }           0    0 2   FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text)    ACL     P   GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO ilia;
          public          postgres    false    265            ~           0    0 %   FUNCTION pgp_sym_decrypt(bytea, text)    ACL     C   GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO ilia;
          public          postgres    false    247                       0    0 +   FUNCTION pgp_sym_decrypt(bytea, text, text)    ACL     I   GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO ilia;
          public          postgres    false    253            �           0    0 +   FUNCTION pgp_sym_decrypt_bytea(bytea, text)    ACL     I   GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO ilia;
          public          postgres    false    248            �           0    0 1   FUNCTION pgp_sym_decrypt_bytea(bytea, text, text)    ACL     O   GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO ilia;
          public          postgres    false    254            �           0    0 $   FUNCTION pgp_sym_encrypt(text, text)    ACL     B   GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO ilia;
          public          postgres    false    243            �           0    0 *   FUNCTION pgp_sym_encrypt(text, text, text)    ACL     H   GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO ilia;
          public          postgres    false    245            �           0    0 +   FUNCTION pgp_sym_encrypt_bytea(bytea, text)    ACL     I   GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO ilia;
          public          postgres    false    244            �           0    0 1   FUNCTION pgp_sym_encrypt_bytea(bytea, text, text)    ACL     O   GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO ilia;
          public          postgres    false    246            �            1255    41602 X   registration(character varying, character varying, character varying, character varying)    FUNCTION       CREATE FUNCTION public.registration(_login character varying, _hash_passwd character varying, _name character varying, _surname character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Users(login,hash_passwd,name,surname) VALUES(_login,crypt(_hash_passwd,gen_salt('md5')),_name,_surname);	
	IF NOT FOUND THEN  
	RAISE EXCEPTION 'Логин занят';
	END IF;
	RETURN TRUE;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN FALSE;	
END;
$$;
 �   DROP FUNCTION public.registration(_login character varying, _hash_passwd character varying, _name character varying, _surname character varying);
       public          sonia    false            �           0    0 �   FUNCTION registration(_login character varying, _hash_passwd character varying, _name character varying, _surname character varying)    ACL     �   GRANT ALL ON FUNCTION public.registration(_login character varying, _hash_passwd character varying, _name character varying, _surname character varying) TO ilia;
          public          sonia    false    228                       1255    41759    replace_task(integer, integer)    FUNCTION       CREATE FUNCTION public.replace_task(_id_kanban_old integer, _id_kanban_new integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;
 S   DROP FUNCTION public.replace_task(_id_kanban_old integer, _id_kanban_new integer);
       public          sonia    false                       1255    41632 %   update_task(integer, text, character)    FUNCTION       CREATE FUNCTION public.update_task(_id_kanban integer, _task text DEFAULT NULL::text, _level character DEFAULT NULL::bpchar) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;
 T   DROP FUNCTION public.update_task(_id_kanban integer, _task text, _level character);
       public          sonia    false            �            1259    41712    kanban    TABLE     �  CREATE TABLE public.kanban (
    id_kanban integer NOT NULL,
    id_user integer NOT NULL,
    task text NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    level character(1) DEFAULT '1'::bpchar NOT NULL,
    ord integer DEFAULT '-1'::integer NOT NULL,
    CONSTRAINT ch_level CHECK (((level >= '1'::bpchar) AND (level <= '5'::bpchar))),
    CONSTRAINT ch_status CHECK ((((status >= 1) AND (status <= 3)) OR (status = '-1'::integer)))
);
    DROP TABLE public.kanban;
       public         heap    sonia    false            �            1259    41711    kanban_id_kanban_seq    SEQUENCE     �   CREATE SEQUENCE public.kanban_id_kanban_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.kanban_id_kanban_seq;
       public          sonia    false    227            �           0    0    kanban_id_kanban_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.kanban_id_kanban_seq OWNED BY public.kanban.id_kanban;
          public          sonia    false    226            �            1259    41559    matrix    TABLE     �  CREATE TABLE public.matrix (
    id_matrix integer NOT NULL,
    id_user integer NOT NULL,
    task text NOT NULL,
    status character varying(25) NOT NULL,
    CONSTRAINT ch_status CHECK (((status)::text = ANY ((ARRAY['срочно и важно'::character varying, 'срочно и не важно'::character varying, 'не срочно но важно'::character varying, 'не срочно не важно'::character varying])::text[])))
);
    DROP TABLE public.matrix;
       public         heap    sonia    false            �           0    0    TABLE matrix    ACL     -   GRANT SELECT ON TABLE public.matrix TO ilia;
          public          sonia    false    219            �            1259    41558    matrix_id_matrix_seq    SEQUENCE     �   CREATE SEQUENCE public.matrix_id_matrix_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.matrix_id_matrix_seq;
       public          sonia    false    219            �           0    0    matrix_id_matrix_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.matrix_id_matrix_seq OWNED BY public.matrix.id_matrix;
          public          sonia    false    218            �            1259    41643    status    TABLE     e  CREATE TABLE public.status (
    id_status integer NOT NULL,
    status character varying(30) NOT NULL,
    CONSTRAINT ch_status CHECK (((status)::text = ANY ((ARRAY['задачи'::character varying, 'в работе'::character varying, 'выполнено'::character varying, 'переходное состояние'::character varying])::text[])))
);
    DROP TABLE public.status;
       public         heap    sonia    false            �            1259    41642    status_id_status_seq    SEQUENCE     �   CREATE SEQUENCE public.status_id_status_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.status_id_status_seq;
       public          sonia    false    225            �           0    0    status_id_status_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.status_id_status_seq OWNED BY public.status.id_status;
          public          sonia    false    224            �            1259    41574    stickers    TABLE     �   CREATE TABLE public.stickers (
    id_sticker integer NOT NULL,
    id_user integer NOT NULL,
    task text NOT NULL,
    last_time timestamp without time zone NOT NULL
);
    DROP TABLE public.stickers;
       public         heap    sonia    false            �           0    0    TABLE stickers    ACL     /   GRANT SELECT ON TABLE public.stickers TO ilia;
          public          sonia    false    221            �            1259    41573    stickers_id_sticker_seq    SEQUENCE     �   CREATE SEQUENCE public.stickers_id_sticker_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.stickers_id_sticker_seq;
       public          sonia    false    221            �           0    0    stickers_id_sticker_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.stickers_id_sticker_seq OWNED BY public.stickers.id_sticker;
          public          sonia    false    220            �            1259    41588    tracker    TABLE     �   CREATE TABLE public.tracker (
    id_tracker integer NOT NULL,
    id_user integer NOT NULL,
    task text NOT NULL,
    last_time timestamp without time zone NOT NULL
);
    DROP TABLE public.tracker;
       public         heap    sonia    false            �           0    0    TABLE tracker    ACL     .   GRANT SELECT ON TABLE public.tracker TO ilia;
          public          sonia    false    223            �            1259    41587    tracker_id_tracker_seq    SEQUENCE     �   CREATE SEQUENCE public.tracker_id_tracker_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.tracker_id_tracker_seq;
       public          sonia    false    223            �           0    0    tracker_id_tracker_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.tracker_id_tracker_seq OWNED BY public.tracker.id_tracker;
          public          sonia    false    222            �            1259    41532    users    TABLE     �   CREATE TABLE public.users (
    id_user integer NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    login character varying(60) NOT NULL,
    hash_passwd character varying(60) NOT NULL
);
    DROP TABLE public.users;
       public         heap    sonia    false            �           0    0    TABLE users    ACL     ,   GRANT SELECT ON TABLE public.users TO ilia;
          public          sonia    false    217            �            1259    41531    users_id_user_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_id_user_seq;
       public          sonia    false    217            �           0    0    users_id_user_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;
          public          sonia    false    216            �           2604    41715    kanban id_kanban    DEFAULT     t   ALTER TABLE ONLY public.kanban ALTER COLUMN id_kanban SET DEFAULT nextval('public.kanban_id_kanban_seq'::regclass);
 ?   ALTER TABLE public.kanban ALTER COLUMN id_kanban DROP DEFAULT;
       public          sonia    false    226    227    227            �           2604    41562    matrix id_matrix    DEFAULT     t   ALTER TABLE ONLY public.matrix ALTER COLUMN id_matrix SET DEFAULT nextval('public.matrix_id_matrix_seq'::regclass);
 ?   ALTER TABLE public.matrix ALTER COLUMN id_matrix DROP DEFAULT;
       public          sonia    false    218    219    219            �           2604    41646    status id_status    DEFAULT     t   ALTER TABLE ONLY public.status ALTER COLUMN id_status SET DEFAULT nextval('public.status_id_status_seq'::regclass);
 ?   ALTER TABLE public.status ALTER COLUMN id_status DROP DEFAULT;
       public          sonia    false    225    224    225            �           2604    41577    stickers id_sticker    DEFAULT     z   ALTER TABLE ONLY public.stickers ALTER COLUMN id_sticker SET DEFAULT nextval('public.stickers_id_sticker_seq'::regclass);
 B   ALTER TABLE public.stickers ALTER COLUMN id_sticker DROP DEFAULT;
       public          sonia    false    220    221    221            �           2604    41591    tracker id_tracker    DEFAULT     x   ALTER TABLE ONLY public.tracker ALTER COLUMN id_tracker SET DEFAULT nextval('public.tracker_id_tracker_seq'::regclass);
 A   ALTER TABLE public.tracker ALTER COLUMN id_tracker DROP DEFAULT;
       public          sonia    false    223    222    223            �           2604    41535    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          sonia    false    216    217    217            Z          0    41712    kanban 
   TABLE DATA           N   COPY public.kanban (id_kanban, id_user, task, status, level, ord) FROM stdin;
    public          sonia    false    227   \�       R          0    41559    matrix 
   TABLE DATA           B   COPY public.matrix (id_matrix, id_user, task, status) FROM stdin;
    public          sonia    false    219   ��       X          0    41643    status 
   TABLE DATA           3   COPY public.status (id_status, status) FROM stdin;
    public          sonia    false    225   ݛ       T          0    41574    stickers 
   TABLE DATA           H   COPY public.stickers (id_sticker, id_user, task, last_time) FROM stdin;
    public          sonia    false    221   L�       V          0    41588    tracker 
   TABLE DATA           G   COPY public.tracker (id_tracker, id_user, task, last_time) FROM stdin;
    public          sonia    false    223   i�       P          0    41532    users 
   TABLE DATA           K   COPY public.users (id_user, name, surname, login, hash_passwd) FROM stdin;
    public          sonia    false    217   ��       �           0    0    kanban_id_kanban_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.kanban_id_kanban_seq', 14, true);
          public          sonia    false    226            �           0    0    matrix_id_matrix_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.matrix_id_matrix_seq', 1, false);
          public          sonia    false    218            �           0    0    status_id_status_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.status_id_status_seq', 1, false);
          public          sonia    false    224            �           0    0    stickers_id_sticker_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.stickers_id_sticker_seq', 1, false);
          public          sonia    false    220            �           0    0    tracker_id_tracker_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.tracker_id_tracker_seq', 1, false);
          public          sonia    false    222            �           0    0    users_id_user_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_id_user_seq', 30, true);
          public          sonia    false    216            �           2606    41724    kanban kanban_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.kanban
    ADD CONSTRAINT kanban_pkey PRIMARY KEY (id_kanban);
 <   ALTER TABLE ONLY public.kanban DROP CONSTRAINT kanban_pkey;
       public            sonia    false    227            �           2606    41567    matrix matrix_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.matrix
    ADD CONSTRAINT matrix_pkey PRIMARY KEY (id_matrix);
 <   ALTER TABLE ONLY public.matrix DROP CONSTRAINT matrix_pkey;
       public            sonia    false    219            �           2606    41650    status status_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id_status);
 <   ALTER TABLE ONLY public.status DROP CONSTRAINT status_pkey;
       public            sonia    false    225            �           2606    41581    stickers stickers_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.stickers
    ADD CONSTRAINT stickers_pkey PRIMARY KEY (id_sticker);
 @   ALTER TABLE ONLY public.stickers DROP CONSTRAINT stickers_pkey;
       public            sonia    false    221            �           2606    41595    tracker tracker_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.tracker
    ADD CONSTRAINT tracker_pkey PRIMARY KEY (id_tracker);
 >   ALTER TABLE ONLY public.tracker DROP CONSTRAINT tracker_pkey;
       public            sonia    false    223            �           2606    41726    kanban u_ord_status 
   CONSTRAINT     U   ALTER TABLE ONLY public.kanban
    ADD CONSTRAINT u_ord_status UNIQUE (ord, status);
 =   ALTER TABLE ONLY public.kanban DROP CONSTRAINT u_ord_status;
       public            sonia    false    227    227            �           2606    41539    users users_login_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_login_key;
       public            sonia    false    217            �           2606    41537    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            sonia    false    217            �           1259    41737    indx_odr_kabnan    INDEX     A   CREATE INDEX indx_odr_kabnan ON public.kanban USING btree (ord);
 #   DROP INDEX public.indx_odr_kabnan;
       public            sonia    false    227            �           1259    41744    indx_odr_status_kabnan    INDEX     P   CREATE INDEX indx_odr_status_kabnan ON public.kanban USING btree (ord, status);
 *   DROP INDEX public.indx_odr_status_kabnan;
       public            sonia    false    227    227            �           2620    41743    kanban trg_after_delete_kanban    TRIGGER     �   CREATE TRIGGER trg_after_delete_kanban AFTER DELETE ON public.kanban FOR EACH ROW EXECUTE FUNCTION public.func_after_delete_kanban();
 7   DROP TRIGGER trg_after_delete_kanban ON public.kanban;
       public          sonia    false    278    227            �           2620    41742    kanban trg_before_insert_kanban    TRIGGER     �   CREATE TRIGGER trg_before_insert_kanban BEFORE INSERT ON public.kanban FOR EACH ROW EXECUTE FUNCTION public.func_before_insert_kanban();
 8   DROP TRIGGER trg_before_insert_kanban ON public.kanban;
       public          sonia    false    227    229            �           2606    41568    matrix fk_id_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.matrix
    ADD CONSTRAINT fk_id_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.matrix DROP CONSTRAINT fk_id_user;
       public          sonia    false    217    219    4778            �           2606    41582    stickers fk_id_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.stickers
    ADD CONSTRAINT fk_id_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.stickers DROP CONSTRAINT fk_id_user;
       public          sonia    false    4778    217    221            �           2606    41596    tracker fk_id_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.tracker
    ADD CONSTRAINT fk_id_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE;
 <   ALTER TABLE ONLY public.tracker DROP CONSTRAINT fk_id_user;
       public          sonia    false    223    217    4778            �           2606    41732    kanban fk_id_user    FK CONSTRAINT     �   ALTER TABLE ONLY public.kanban
    ADD CONSTRAINT fk_id_user FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.kanban DROP CONSTRAINT fk_id_user;
       public          sonia    false    217    227    4778            �           2606    41727    kanban fk_status    FK CONSTRAINT     v   ALTER TABLE ONLY public.kanban
    ADD CONSTRAINT fk_status FOREIGN KEY (status) REFERENCES public.status(id_status);
 :   ALTER TABLE ONLY public.kanban DROP CONSTRAINT fk_status;
       public          sonia    false    227    4786    225            Z   T   x���4��quT�wSpq��4�4�4�24�祖���F\� ~ZfQq	XĘ�$��F .$�|<�=B��&@�1z\\\ ۈ�      R      x������ � �      X   _   x�˱�0D�:��@
��0	QP�J@���0+�7�(�<ߏ2
������O��3T�oxa��@y&m�P}��
m<�J��wRe?v"��?       T      x������ � �      V      x������ � �      P   �   x�e��R�0�3y��-?��-�4ô�@b/��Ƣ�Dӧ/Uo�����.��䫳��BeT����~�[N{�ۼ\�d� pd;V���:��i�da��8-��$�J�wudI��C>22a��+Xq�=|/���3���g��~|�����������pu��+�-Ȯ�MX�R��7���ͯ�MhZd�j�n�aW����ǌ��.z�A]  V     