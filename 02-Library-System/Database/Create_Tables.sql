/*
02 - Library Management System (Simple)
Create Tables Script (SQL Server)

How to use:
1) (Optional) create a database:
   CREATE DATABASE SimpleLibraryDB;
   GO
   USE SimpleLibraryDB;
   GO
2) Run this script.
*/

-- Safety (re-run friendly)
IF OBJECT_ID('dbo.Reservations','U') IS NOT NULL DROP TABLE dbo.Reservations;
IF OBJECT_ID('dbo.Fines','U') IS NOT NULL DROP TABLE dbo.Fines;
IF OBJECT_ID('dbo.Loans','U') IS NOT NULL DROP TABLE dbo.Loans;
IF OBJECT_ID('dbo.BookCopies','U') IS NOT NULL DROP TABLE dbo.BookCopies;
IF OBJECT_ID('dbo.BookAuthors','U') IS NOT NULL DROP TABLE dbo.BookAuthors;
IF OBJECT_ID('dbo.Authors','U') IS NOT NULL DROP TABLE dbo.Authors;
IF OBJECT_ID('dbo.Books','U') IS NOT NULL DROP TABLE dbo.Books;
IF OBJECT_ID('dbo.LibraryUsers','U') IS NOT NULL DROP TABLE dbo.LibraryUsers;
GO

CREATE TABLE dbo.LibraryUsers (
    UserID          INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100) NOT NULL,
    PhoneNumber     NVARCHAR(20)  NULL,
    Email           NVARCHAR(100) NULL,
    Address         NVARCHAR(200) NULL,
    LibraryCardNo   NVARCHAR(30)  NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.Books (
    BookID              INT IDENTITY(1,1) PRIMARY KEY,
    Title               NVARCHAR(200) NOT NULL,
    ISBN                NVARCHAR(20)  NULL,
    PublicationDate     DATE          NULL,
    Genre               NVARCHAR(50)  NULL,
    AdditionalDetails   NVARCHAR(200) NULL,
    CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN)
);
GO

CREATE TABLE dbo.Authors (
    AuthorID    INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName  NVARCHAR(150) NOT NULL
);
GO

-- Many-to-many: Books ↔ Authors
CREATE TABLE dbo.BookAuthors (
    BookID   INT NOT NULL,
    AuthorID INT NOT NULL,
    CONSTRAINT PK_BookAuthors PRIMARY KEY (BookID, AuthorID),
    CONSTRAINT FK_BookAuthors_Books FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID) ON DELETE CASCADE,
    CONSTRAINT FK_BookAuthors_Authors FOREIGN KEY (AuthorID) REFERENCES dbo.Authors(AuthorID) ON DELETE CASCADE
);
GO

-- Multiple copies per book
CREATE TABLE dbo.BookCopies (
    CopyID          INT IDENTITY(1,1) PRIMARY KEY,
    BookID          INT NOT NULL,
    CopyCode        NVARCHAR(30) NOT NULL UNIQUE,  -- human-friendly copy identifier
    IsAvailable     BIT NOT NULL CONSTRAINT DF_BookCopies_IsAvailable DEFAULT (1),
    CONSTRAINT FK_BookCopies_Books FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID) ON DELETE CASCADE
);
GO

/*
LoanStatus suggested values:
1 Borrowed
2 Returned
3 Lost
4 Damaged
*/
CREATE TABLE dbo.Loans (
    LoanID      INT IDENTITY(1,1) PRIMARY KEY,
    CopyID      INT NOT NULL,
    UserID      INT NOT NULL,
    BorrowDate  DATE NOT NULL,
    DueDate     DATE NOT NULL,
    ReturnDate  DATE NULL,
    LoanStatus  TINYINT NOT NULL CONSTRAINT CK_Loans_Status CHECK (LoanStatus BETWEEN 1 AND 4),

    CONSTRAINT FK_Loans_Copies FOREIGN KEY (CopyID) REFERENCES dbo.BookCopies(CopyID),
    CONSTRAINT FK_Loans_Users  FOREIGN KEY (UserID) REFERENCES dbo.LibraryUsers(UserID)
);
GO

/*
ReservationStatus suggested values:
1 Waiting
2 Fulfilled
3 Canceled
*/
CREATE TABLE dbo.Reservations (
    ReservationID     INT IDENTITY(1,1) PRIMARY KEY,
    BookID            INT NOT NULL,
    UserID            INT NOT NULL,
    RequestDate       DATE NOT NULL,
    QueuePosition     INT NOT NULL,
    ReservationStatus TINYINT NOT NULL CONSTRAINT CK_Reservations_Status CHECK (ReservationStatus BETWEEN 1 AND 3),

    CONSTRAINT FK_Reservations_Books FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID) ON DELETE CASCADE,
    CONSTRAINT FK_Reservations_Users FOREIGN KEY (UserID) REFERENCES dbo.LibraryUsers(UserID) ON DELETE CASCADE,
    CONSTRAINT UQ_Reservations_Book_User UNIQUE (BookID, UserID)
);
GO

CREATE TABLE dbo.Fines (
    FineID      INT IDENTITY(1,1) PRIMARY KEY,
    LoanID      INT NOT NULL UNIQUE,  -- one fine per loan (simple model)
    UserID      INT NOT NULL,
    FineDate    DATE NOT NULL,
    Amount      DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    IsPaid      BIT NOT NULL CONSTRAINT DF_Fines_IsPaid DEFAULT (0),
    PaidDate    DATE NULL,

    CONSTRAINT FK_Fines_Loans FOREIGN KEY (LoanID) REFERENCES dbo.Loans(LoanID) ON DELETE CASCADE,
    CONSTRAINT FK_Fines_Users FOREIGN KEY (UserID) REFERENCES dbo.LibraryUsers(UserID) ON DELETE CASCADE
);
GO

-- Helpful indexes
CREATE INDEX IX_Loans_UserID ON dbo.Loans(UserID);
CREATE INDEX IX_Loans_CopyID ON dbo.Loans(CopyID);
CREATE INDEX IX_Copies_BookID ON dbo.BookCopies(BookID);
CREATE INDEX IX_Reservations_BookID ON dbo.Reservations(BookID);
GO
