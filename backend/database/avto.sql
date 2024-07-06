--1 variant
DROP FUNCTION authorization(_login VARCHAR(60),_passwd VARCHAR(60))

CREATE OR REPLACE FUNCTION authorization(_login VARCHAR(60),_passwd VARCHAR(60))
									
RETURNS RECORD AS $$
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
$$ LANGUAGE plpgsql; 

SELECT authorization('ilia4','python')  



SELECT * FROM Users
