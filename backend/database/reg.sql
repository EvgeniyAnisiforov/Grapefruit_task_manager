DROP FUNCTION registration(character varying,character varying,character varying,character varying)

CREATE OR REPLACE FUNCTION registration(_login VARCHAR(60),_hash_passwd VARCHAR(60),
										_name VARCHAR(50), _surname VARCHAR(50))
RETURNS BOOLEAN AS $$
DECLARE 
	success BOOLEAN = false;
BEGIN
	INSERT INTO Users(login,hash_passwd,name,surname) VALUES(_login,crypt(_hash_passwd,gen_salt('md5')),_name,_surname);
	success = true;
	RETURN success;
EXCEPTION 
	WHEN others THEN 
	RAISE NOTICE 'Возникло исключение: %', SQLERRM;
	RETURN success;
		
END;
$$ LANGUAGE plpgsql; 

unique_violation,

SELECT registration('ilia2','python','ilia','osipov');
SELECT * FROM Users
