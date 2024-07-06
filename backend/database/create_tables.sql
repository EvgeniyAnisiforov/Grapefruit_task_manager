CREATE EXTENSION pgcrypto;
DROP TABLE Users
CREATE TABLE Users
(
	id_user SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL,
	login VARCHAR(60) NOT NULL UNIQUE,
	hash_passwd VARCHAR(60) NOT NULL 
)
DROP TABLE Status
CREATE TABLE Status
(
	id_status SERIAL PRIMARY KEY,
	status VARCHAR(30) NOT NULL,
	CONSTRAINT ch_status
	CHECK(status IN ('задачи','в работе','выполнено','переходное состояние'))
)
INSERT INTO Status VALUES (-1, 'переходное состояние')
SELECT * FROM STATUS
DROP TABLE Kanban
CREATE TABLE Kanban
(
	id_kanban SERIAL PRIMARY KEY,
	id_user INTEGER NOT NULL,
	task TEXT NOT NULL,
	status INTEGER NOT NULL DEFAULT 1,
	level CHAR(1) NOT NULL DEFAULT '1',
	ord INTEGER NOT NULL DEFAULT -1,
	CONSTRAINT fk_status
	FOREIGN KEY(status) REFERENCES Status(id_status),
	CONSTRAINT u_ord_status 
	UNIQUE(ord,status),
	CONSTRAINT ch_status
	CHECK(status BETWEEN 1 AND 3),
	CONSTRAINT ch_level
	CHECK(level BETWEEN '1' AND '5'),
	CONSTRAINT fk_id_user
	FOREIGN KEY(id_user) REFERENCES Users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
)
ALTER TABLE Kanban ADD COLUMN ord INTEGER UNIQUE NOT NULL DEFAULT -1
ALTER TABLE Kanban DROP CONSTRAINT kanban_ord_key
ALTER TABLE Kanban ADD CONSTRAINT u_ord_status UNIQUE(ord,status)
ALTER TABLE Status DROP CONSTRAINT ch_status
ALTER TABLE Kanban ADD CONSTRAINT ch_status CHECK((status BETWEEN 1 AND 3) OR status = -1)
ALTER TABLE Status ALTER COLUMN status DROP DEFAULT TYPE VARCHAR(30)
ALTER TABLE Status ADD CONSTRAINT ch_status CHECK(status IN ('задачи','в работе','выполнено','переходное состояние'))

DROP TABLE Matrix
CREATE TABLE Matrix 
(
	id_matrix SERIAL PRIMARY KEY,
	id_user INTEGER NOT NULL,
	task TEXT NOT NULL,
	status VARCHAR(25) NOT NULL,
	CONSTRAINT ch_status 
	CHECK(status IN('срочно и важно','срочно и не важно','не срочно но важно','не срочно не важно')),
	CONSTRAINT fk_id_user
	FOREIGN KEY(id_user) REFERENCES Users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
)
DROP TABLE Stickers
CREATE TABLE Stickers
(
	id_sticker SERIAL PRIMARY KEY,
	id_user INTEGER NOT NULL,
	task TEXT NOT NULL,
	last_time TIMESTAMP NOT NULL,
	CONSTRAINT fk_id_user
	FOREIGN KEY(id_user) REFERENCES Users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
	
)
DROP TABLE Tracker
CREATE TABLE Tracker
(
	id_tracker SERIAL PRIMARY KEY,
	id_user INTEGER NOT NULL,
	task TEXT NOT NULL,
	last_time TIMESTAMP NOT NULL,
	CONSTRAINT fk_id_user
	FOREIGN KEY(id_user) REFERENCES Users(id_user) ON DELETE CASCADE ON UPDATE CASCADE
	
)
