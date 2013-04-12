CREATE TABLE Person(
UserID NUMBER(8),
Uname VARCHAR2(30) NOT NULL,
Name VARCHAR2(100),
Password VARCHAR2(50) NOT NULL,
NumOfBooksOwned NUMBER(4) DEFAULT 0 NOT NULL,
NumOfBooksBorrowed NUMBER(4) DEFAULT 0 NOT NULL,
City VARCHAR2(25),
State CHAR(2),
Country VARCHAR2(30),
AvgRating NUMBER(2) DEFAULT -1,
CONSTRAINT person_pk PRIMARY KEY (UserID),
CONSTRAINT person_uname_unq UNIQUE (Uname));

CREATE TABLE Owner(
LenderID NUMBER(8),
CONSTRAINT owner_pk PRIMARY KEY (LenderID),
CONSTRAINT owner_fk FOREIGN KEY (LenderID) REFERENCES Person (UserID)
    ON DELETE CASCADE);

CREATE TABLE Borrower(
BorrowerID NUMBER(8),
CONSTRAINT borr_pk PRIMARY KEY (BorrowerID),
CONSTRAINT borr_fk FOREIGN KEY (BorrowerID) REFERENCES Person (UserID)
    ON DELETE CASCADE);

CREATE TABLE Books(
BookID NUMBER(10),
ISBN NUMBER(13) NOT NULL,
OwnerID NUMBER(8) NOT NULL,
Title VARCHAR2(50) NOT NULL,
Author VARCHAR2(50) NOT NULL,
Genre VARCHAR2(15),
AvgRate NUMBER(2) DEFAULT -1,
NumOfPages NUMBER(4),
NumOfTimesBorrowed NUMBER(4) DEFAULT 0,
CONSTRAINT books_pk PRIMARY KEY (BookID),
CONSTRAINT books_fk FOREIGN KEY (OwnerID) REFERENCES Owner (LenderID)
    ON DELETE CASCADE);

/* If a borrower "disappears," their account cannot be deleted until the
** book is returned */
CREATE TABLE Lends(
LenderID NUMBER(8) NOT NULL,
BorrowerID NUMBER(8) NOT NULL,
BookID NUMBER(10),
DateBorrowed DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT lends_pk PRIMARY KEY (BookID),
CONSTRAINT lends_book_fk FOREIGN KEY (BookID) REFERENCES Books (BookID)
    ON DELETE CASCADE,
CONSTRAINT lends_lend_fk FOREIGN KEY (LenderID) REFERENCES Owner (LenderID)
    ON DELETE CASCADE,
CONSTRAINT lends_borr_fk FOREIGN KEY (BorrowerID) REFERENCES Borrower (BorrowerID));

CREATE TABLE Library(
BookID NUMBER(10) NOT NULL,
LenderID NUMBER(8) NOT NULL,
BorrowerID NUMBER(8),
CurrentAvail CHAR(1) DEFAULT 'Y',
DateBorrowed DATE,
CONSTRAINT libr_pk PRIMARY KEY (BookID, LenderID),
CONSTRAINT libr_book_fk FOREIGN KEY (BookID) REFERENCES Books(BookID)
    ON DELETE CASCADE,
CONSTRAINT libr_lend_fk FOREIGN KEY (LenderID) REFERENCES Owner(LenderID)
    ON DELETE SET NULL,
CONSTRAINT libr_borr_fk FOREIGN KEY (BorrowerID) REFERENCES Borrower(BorrowerID));

/* Technically, we never manually add anything to History. Entries are generated
** when rows are deleted from the Lends table. */
CREATE TABLE History(
LenderID NUMBER(8),
BorrowerID NUMBER(8),
BookID NUMBER(10),
DateBorrowed DATE,
DateReturned DATE);

CREATE TABLE BookRatings(
UserID NUMBER(8) NOT NULL,
BookID NUMBER(10) NOT NULL,
ISBN NUMBER(13) NOT NULL,
NumRating NUMBER(2) NOT NULL,
TxtRating VARCHAR2(1000),
CONSTRAINT bookRat_pk PRIMARY KEY (UserID, BookID),
CONSTRAINT bookRat_user_fk FOREIGN KEY (UserID) REFERENCES Person (UserID)
    ON DELETE CASCADE);

CREATE TABLE PersonRatings(
RaterID NUMBER(8) NOT NULL,
RateeID NUMBER(8) NOT NULL,
NumRating NUMBER(2) NOT NULL,
TxtRating VARCHAR2(1000) NOT NULL,
CONSTRAINT perRat_pk PRIMARY KEY (RaterID, RateeID),
CONSTRAINT perRat_rater_fk FOREIGN KEY (RaterID) REFERENCES Person (UserID)
    ON DELETE CASCADE,
CONSTRAINT perRat_ratee_fk FOREIGN KEY (RateeID) REFERENCES Person (UserID)
    ON DELETE CASCADE);

/* Entries should only be created so long as they are not triggered by
** the CASCADE action of user deletion */
CREATE OR REPLACE TRIGGER make_history AFTER DELETE ON Lends
FOR EACH ROW
DECLARE
    own_count NUMBER(1) := 0;
    borr_count NUMBER(1) := 0;
    num_borr NUMBER(4) := 0;
BEGIN
    SELECT count(*) INTO own_count FROM (
        SELECT UserID FROM Person p
            WHERE p.UserID = :old.LenderID )
    ;
    SELECT count(*) INTO borr_count FROM (
        SELECT UserID FROM Person p
            WHERE p.UserID = :old.BorrowerID )
    ;
    IF borr_count > 0 THEN
        SELECT NumOfBooksBorrowed INTO num_borr FROM (
            SELECT NumOfBooksBorrowed FROM Person p
                WHERE p.UserID = :old.BorrowerID )
        ;
        num_borr := num_borr - 1;
        UPDATE Person
            SET NumOfBooksBorrowed = num_borr
            WHERE UserID = :old.BorrowerID
        ;
    END IF;
    INSERT INTO History VALUES (
        :old.LenderID,
        :old.BorrowerID,
        :old.BookID,
        :old.DateBorrowed,
        SYSDATE )
    ;
    IF own_count > 0 THEN
        UPDATE Library
            SET CurrentAvail = 'Y',
                DateBorrowed = NULL
                BorrowerID = NULL
            WHERE BookID = :old.BookID
        ;
    END IF;
    
END;
/

CREATE OR REPLACE TRIGGER book_ratings AFTER INSERT ON BookRatings
FOR EACH ROW
DECLARE
    new_avg NUMBER(2);
BEGIN
    SELECT AVG(NumRating) INTO new_avg FROM (
        SELECT NumRating FROM BookRatings b WHERE :new.ISBN = b.ISBN )
    ;
    UPDATE Books
        SET AvgRate = new_avg
        WHERE ISBN = :new.ISBN
    ;
END;
/

CREATE OR REPLACE TRIGGER person_ratings AFTER INSERT ON PersonRatings
FOR EACH ROW
DECLARE
    new_avg NUMBER(2);
BEGIN
    SELECT AVG(NumRating) INTO new_avg FROM (
        SELECT NumRating FROM PersonRatings p WHERE :new.RateeID = p.RateeID )
    ;
    UPDATE Person
        SET AvgRating = new_avg
        WHERE UserID = :new.RateeID
    ;
END;
/

-- The user ID sequence, for automatically assigning UserIDs
CREATE SEQUENCE uid_seq
    MINVALUE 0
    START WITH 0
    INCREMENT BY 1
    MAXVALUE 99999999;

-- The book ID sequence, for automatically assigning BookIDs
CREATE SEQUENCE bid_seq
    MINVALUE 0
    START WITH 0
    INCREMENT BY 1
    MAXVALUE 9999999999;

-- The trigger for inserting UserIDs
CREATE OR REPLACE TRIGGER ins_uid BEFORE INSERT ON Person
FOR EACH ROW
BEGIN
    SELECT uid_seq.nextval INTO :new.UserID FROM dual;
END;
/

-- Adds the ISBN for the specified book to the BookRatings table
CREATE OR REPLACE TRIGGER ins_bookRat_isbn BEFORE INSERT ON BookRatings
FOR EACH ROW
BEGIN
    SELECT ISBN INTO :new.ISBN FROM Books;
END;
/

CREATE OR REPLACE TRIGGER add_to_owner_and_increment
BEFORE INSERT ON Books
FOR EACH ROW
DECLARE
-- We'll use counter to make sure that the person is not already in Owner
	counter NUMBER(4) := 0;
BEGIN
    -- Add the BookID
    SELECT bid_seq.nextval INTO :new.BookID FROM dual;
    SELECT count(*) INTO counter FROM (
        SELECT LenderID FROM Owner o WHERE o.LenderID = :new.OwnerID )
    ;
    IF counter = 0 THEN
        INSERT INTO Owner VALUES (
            :new.OwnerID
        );
    END IF;
    -- Add one more book to the number of books owned for this user
    SELECT NumOfBooksOwned INTO counter FROM (
        SELECT NumOfBooksOwned FROM Person p WHERE p.UserID = :new.OwnerID )
    ;
    counter := counter + 1;
    UPDATE Person
        SET NumOfBooksOwned = counter
        WHERE UserID = :new.OwnerID
    ;
END;
/

CREATE OR REPLACE TRIGGER add_to_lib
AFTER INSERT ON Books
FOR EACH ROW
BEGIN
	INSERT INTO Library
	(   BookID,
        LenderID
	)
	VALUES
	(   :new.BookID,
        :new.OwnerID
	);

END;
/

/* A suite of actions to be completed when an insertion occurs in Lends.
** Does via PL/SQL everything that would otherwise require manual UPDATES. */
CREATE OR REPLACE TRIGGER lending_actions BEFORE INSERT ON Lends
FOR EACH ROW
DECLARE
    per_num_borr NUMBER(4) := 0;
    borr_exist NUMBER(1) := 0;
    book_num_borr NUMBER(4) := 0;
BEGIN
    -- First, make sure this person exists in the Borrower table.
    SELECT count(*) INTO borr_exist FROM (
        SELECT BorrowerID FROM Borrower b WHERE b.BorrowerID = :new.BorrowerID )
    ;
    -- IF count(*) is 0, then this user does not exist, so we should add them
    IF borr_exist = 0 THEN
        INSERT INTO Borrower VALUES (:new.BorrowerID);
    END IF;
    -- Mark in the library that this book is not available
    UPDATE Library
        SET CurrentAvail = 'N',
            DateBorrowed = :new.DateBorrowed
        WHERE BookID = :new.BookID
    ;
    -- Increment the number of times the book has been borrowed
    SELECT NumOfTimesBorrowed INTO book_num_borr FROM (
        SELECT NumOfTimesBorrowed FROM Books b WHERE b.BookID = :new.BookID )
    ;
    book_num_borr := book_num_borr + 1;
    UPDATE Books
        SET NumOfTimesBorrowed = book_num_borr
        WHERE BookID = :new.BookID
    ;
    -- Increment the number of times this user has borrowed books
    SELECT NumOfBooksBorrowed INTO per_num_borr FROM (
        SELECT NumOfBooksBorrowed FROM Person p WHERE p.UserID = :new.BorrowerID )
    ;
    per_num_borr := per_num_borr + 1;
    UPDATE Person
        SET NumOfBooksBorrowed = per_num_borr
        WHERE UserID = :new.BorrowerID
    ;
END;
/

-- We need to decrement the number of books owned by the user
CREATE OR REPLACE TRIGGER book_deletion AFTER DELETE ON Books
FOR EACH ROW
DECLARE
    num_own NUMBER(4);
BEGIN
    SELECT NumOfBooksOwned INTO num_own FROM (
        SELECT NumOfBooksOwned FROM Person p WHERE p.UserID = :old.OwnerID )
    ;
    num_own := num_own - 1;
    UPDATE Person
        SET NumOfBooksOwned = num_own
        WHERE UserID = :old.OwnerID
    ;
END;
/
