IF OBJECT_ID('Books') IS NOT NULL DROP TABLE Books;
CREATE TABLE Books (BookId BIGINT IDENTITY(1,1) PRIMARY KEY, BookCode NVARCHAR(100), Author NVARCHAR(255), Title NVARCHAR(255), Genre NVARCHAR(255), PublishDate DATE, Price MONEY, Description TEXT, NrOfPages BIGINT, CreatedDate DATETIME DEFAULT GETDATE())	

TRUNCATE TABLE Books
INSERT INTO Books (BookCode, Author, Title) VALUES ('bk999', 'SomeDude', 'Dude!')
INSERT INTO Books (BookCode, Author, Title) VALUES ('bk998', 'SomeOtherDude', 'WUT?')

MERGE Books b
USING Books x
ON b.BookCode = x.BookCode + 'x'
WHEN NOT MATCHED THEN
	INSERT (BookCode, Author, Title, Genre, PublishDate, Price, Description)
	VALUES (x.BookCode+'x', x.Author, x.Title, x.Genre, x.PublishDate, x.Price, x.Description);

SELECT * FROM Books	