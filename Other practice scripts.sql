use bookeeping;
CREATE TABLE teachers
(	ID INT NOT NULL,
	LastName VARCHAR(255),
	FirstName VARCHAR(255) NOT NULL,
	PK_Student CHAR(255),
	PRIMARY KEY (ID, FirstName)
   );

CREATE TABLE Library (
LibraryID INT,
FirstName VARCHAR(250),
LastName VARCHAR(250),
Reg_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Library
ADD CONSTRAINT Primary Key (LibraryID);

ALTER TABLE Library
MODIFY LibraryID INT AUTO_INCREMENT PRIMARY KEY;


CREATE TABLE Students (
   ID INT NOT NULL,
   Name VARCHAR(255),
   LibraryID INT,
   PRIMARY KEY (ID),
   FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
   );

DESC Library;
DESC Students;

INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(1,"ALEX","DOBRE");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(2,"Silviu","DOBRE");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(3,"Antonio","DOBRE");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(4,"Anisoara","Manolache");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(5,"Ioan","Manolache");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(6,"Elena","Manolache");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(7,"Ecaterina","Manolache");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(8,"Maria","Manolache");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(9,"Aurelian","Filip");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(10,"Leonard","Filip");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(11,"Iulia","Filip");
INSERT INTO library(LibraryID, FirstName, LastName) VALUES
(12,"Christofer","DOBRE");


USE bookeeping;
SELECT * FROM library;

USE ig_clone;
SELECT * FROM comments;

SELECT u.id, c.comment_text, c.photo_id FROM users u
JOIN comments c ON u.id = c.id;

SELECT f.follower_id, ufollower.username follower_username, f.followee_id, ufollowee.username followee_username
FROM follows f
JOIN users ufollowee ON f.followee_id = ufollowee.id
JOIN users ufollower ON f.follower_id = ufollower.id;

CREATE index SQNCE
	ON follows (follower_id);
    
SELECT * FROM follows;

USE ig_clone;
SHOW COLUMNS FROM follows;

USE bookeeping;
SHOW TABLES;