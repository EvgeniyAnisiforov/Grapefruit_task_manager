--1 variant
DROP FUNCTION authorization(_login VARCHAR(60),_passwd VARCHAR(60))

CREATE OR REPLACE FUNCTION authorization(_login VARCHAR(60),_passwd VARCHAR(60),
										OUT id_user INT, OUT name VARCHAR(50), OUT surname VARCHAR(50))
RETURNS SETOF RECORD AS $$
BEGIN
	RETURN QUERY
	SELECT us.id_user, us.name, us.surname FROM Users AS us WHERE us.login = _login AND
	us.hash_passwd = crypt(_passwd,us.hash_passwd);
	
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;	
END;
$$ LANGUAGE plpgsql; 

SELECT authorization('ilia2','python')  

--2 variant
CREATE OR REPLACE FUNCTION authorization(_login VARCHAR(60),_passwd VARCHAR(60))
RETURNS TABLE(id_user INT, name VARCHAR(50), surname VARCHAR(50)) AS $$
BEGIN
	RETURN QUERY
	SELECT us.id_user, us.name, us.surname FROM Users AS us WHERE us.login = _login AND
	us.hash_passwd = crypt(_passwd,us.hash_passwd);
	
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;	
	RETURN NEXT NULL;
END;
$$ LANGUAGE plpgsql; 


SELECT * FROM Users


--если не вернет null
	IF NOT FOUND 
	THEN
	_id_user =-1;
	END IF;