/*
02 - Library System (SQL Server) - Create Tables
*/

SET NOCOUNT ON;
GO

/* =========================
   DROP TABLES (re-run safe)
   ========================= */
IF OBJECT_ID('dbo.Fines','U')            IS NOT NULL DROP TABLE dbo.Fines;
IF OBJECT_ID('dbo.Reservations','U')     IS NOT NULL DROP TABLE dbo.Reservations;
IF OBJECT_ID('dbo.BorrowingRecords','U') IS NOT NULL DROP TABLE dbo.BorrowingRecords;
IF OBJECT_ID('dbo.BookCopies','U')       IS NOT NULL DROP TABLE dbo.BookCopies;
IF OBJECT_ID('dbo.Books','U')            IS NOT NULL DROP TABLE dbo.Books;
IF OBJECT_ID('dbo.Users','U')            IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Settings','U')         IS NOT NULL DROP TABLE dbo.Settings;
GO

/* =========================
   1) Settings
   (single-row config table)
   ========================= */
CREATE TABLE dbo.Settings
(
    DefaultBorrowDays  TINYINT NOT NULL,
    DefaultFinePerDay  TINYINT NOT NULL
);
GO

/* =========================
   2) Users
   ========================= */
CREATE TABLE dbo.Users
(
    UserID            INT IDENTITY(1,1) PRIMARY KEY,
    [Name]            NVARCHAR(100) NOT NULL,
    Phone             NVARCHAR(50)  NOT NULL,
    Email             NVARCHAR(50)  NOT NULL,
    LibraryCardNumber NVARCHAR(50)  NOT NULL,
    CONSTRAINT UQ_Users_LibraryCardNumber UNIQUE (LibraryCardNumber)
);
GO

/* =========================
   3) Books
   ========================= */
CREATE TABLE dbo.Books
(
    BookID            INT IDENTITY(1,1) PRIMARY KEY,
    Author            NVARCHAR(255) NOT NULL,
    Title             NVARCHAR(255) NOT NULL,
    ISBN              NVARCHAR(50)  NOT NULL,
    PublicationDate   DATE          NOT NULL,
    Genre             NVARCHAR(50)  NOT NULL,
    AdditionalDetails NVARCHAR(MAX) NULL,
    CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN)
);
GO

/* =========================
   4) BookCopies
   ========================= */
CREATE TABLE dbo.BookCopies
(
    CopyID             INT IDENTITY(1,1) PRIMARY KEY,
    BookID             INT NOT NULL,
    AvailabilityStatus BIT NOT NULL,

    CONSTRAINT FK_BookCopies_Books
        FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID)
);
GO

/* =========================
   5) BorrowingRecords
   ========================= */
CREATE TABLE dbo.BorrowingRecords
(
    BorrowingRecordID INT IDENTITY(1,1) PRIMARY KEY,
    UserID            INT NOT NULL,
    CopyID            INT NOT NULL,
    BorrowingDate     DATE NOT NULL,
    DueDate           DATE NOT NULL,
    ActualReturnDate  DATE NULL,

    CONSTRAINT FK_BorrowingRecords_Users
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),

    CONSTRAINT FK_BorrowingRecords_BookCopies
        FOREIGN KEY (CopyID) REFERENCES dbo.BookCopies(CopyID)
);
GO

/* =========================
   6) Reservations
   ========================= */
CREATE TABLE dbo.Reservations
(
    ReservationID   INT IDENTITY(1,1) PRIMARY KEY,
    UserID          INT NOT NULL,
    CopyID          INT NOT NULL,
    ReservationDate DATE NOT NULL,

    CONSTRAINT FK_Reservations_Users
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),

    CONSTRAINT FK_Reservations_BookCopies
        FOREIGN KEY (CopyID) REFERENCES dbo.BookCopies(CopyID)
);
GO

/* =========================
   7) Fines
   ========================= */
CREATE TABLE dbo.Fines
(
    FineID            INT IDENTITY(1,1) PRIMARY KEY,
    UserID            INT NOT NULL,
    BorrowingRecordID INT NOT NULL,
    NumberOfLateDays  SMALLINT NOT NULL,
    FineAmount        DECIMAL(10,2) NOT NULL,
    PaymentStatus     BIT NOT NULL,

    CONSTRAINT FK_Fines_Users
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),

    CONSTRAINT FK_Fines_BorrowingRecords
        FOREIGN KEY (BorrowingRecordID) REFERENCES dbo.BorrowingRecords(BorrowingRecordID)
);
GO

/* =========================
   Helpful indexes
   ========================= */
CREATE INDEX IX_BookCopies_BookID ON dbo.BookCopies(BookID);

CREATE INDEX IX_BorrowingRecords_UserID ON dbo.BorrowingRecords(UserID);
CREATE INDEX IX_BorrowingRecords_CopyID ON dbo.BorrowingRecords(CopyID);

CREATE INDEX IX_Reservations_UserID ON dbo.Reservations(UserID);
CREATE INDEX IX_Reservations_CopyID ON dbo.Reservations(CopyID);

CREATE INDEX IX_Fines_UserID ON dbo.Fines(UserID);
CREATE INDEX IX_Fines_BorrowingRecordID ON dbo.Fines(BorrowingRecordID);
GO