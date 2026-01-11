/*
02 - Library System (SQL Server)
Insert Sample Data (LARGE DATASET)

Run AFTER: Create_Tables.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Clean existing data
   ========================= */
DELETE FROM dbo.Fines;
DELETE FROM dbo.Reservations;
DELETE FROM dbo.BorrowingRecords;
DELETE FROM dbo.BookCopies;
DELETE FROM dbo.Books;
DELETE FROM dbo.Users;
DELETE FROM dbo.Settings;
GO

/* Reseed identities */
DBCC CHECKIDENT ('dbo.Fines', RESEED, 0);
DBCC CHECKIDENT ('dbo.Reservations', RESEED, 0);
DBCC CHECKIDENT ('dbo.BorrowingRecords', RESEED, 0);
DBCC CHECKIDENT ('dbo.BookCopies', RESEED, 0);
DBCC CHECKIDENT ('dbo.Books', RESEED, 0);
DBCC CHECKIDENT ('dbo.Users', RESEED, 0);
GO

/* =========================
   1) Settings (single row)
   ========================= */
INSERT INTO dbo.Settings (DefaultBorrowDays, DefaultFinePerDay)
VALUES (14, 1);
GO

/* =========================
   2) Users (50)
   ========================= */
;WITH N AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Users (Name, Phone, Email, LibraryCardNumber)
SELECT
    CONCAT(
        CASE WHEN n % 4 = 0 THEN 'Khalid'
             WHEN n % 4 = 1 THEN 'Aisha'
             WHEN n % 4 = 2 THEN 'Omar'
             ELSE 'Sara' END,
        ' User ', n
    ) AS [Name],
    CONCAT('05', RIGHT(CONCAT('00000000', 30000000 + n), 8)) AS Phone,
    CONCAT('user', n, '@example.com') AS Email,
    CONCAT('LCN', RIGHT(CONCAT('0000', 1000 + n), 4)) AS LibraryCardNumber
FROM N;
GO

/* =========================
   3) Books (80)
   ========================= */
;WITH N AS (
    SELECT TOP (80) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Books (Author, Title, ISBN, PublicationDate, Genre, AdditionalDetails)
SELECT
    CONCAT('Author ', ((n - 1) % 20) + 1),
    CONCAT('Book Title ', n),
    CONCAT('978', RIGHT(CONCAT('0000000000', 1000000000 + n), 10)),
    DATEADD(DAY, -(n * 120), CAST('2025-01-01' AS DATE)),
    CASE (n % 7)
        WHEN 0 THEN 'Programming'
        WHEN 1 THEN 'Databases'
        WHEN 2 THEN 'Algorithms'
        WHEN 3 THEN 'Literature'
        WHEN 4 THEN 'History'
        WHEN 5 THEN 'Science'
        ELSE 'Business'
    END,
    CASE WHEN n % 6 = 0 THEN 'Edition notes and extra details' ELSE NULL END
FROM N;
GO

/* =========================
   4) BookCopies (200)
   Availability mixed
   ========================= */
;WITH N AS (
    SELECT TOP (200) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.BookCopies (BookID, AvailabilityStatus)
SELECT
    ((n - 1) % 80) + 1 AS BookID,
    CASE WHEN n % 5 = 0 THEN 0 ELSE 1 END AS AvailabilityStatus
FROM N;
GO

/* =========================
   5) BorrowingRecords (320)
   DueDate uses Settings
   Some returned, some not, some late
   ========================= */
DECLARE @BorrowDays TINYINT;
SELECT TOP (1) @BorrowDays = DefaultBorrowDays FROM dbo.Settings;

;WITH N AS (
    SELECT TOP (320) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.BorrowingRecords (UserID, CopyID, BorrowingDate, DueDate, ActualReturnDate)
SELECT
    ((n - 1) % 50) + 1 AS UserID,
    ((n - 1) % 200) + 1 AS CopyID,
    DATEADD(DAY, n, CAST('2024-01-01' AS DATE)) AS BorrowingDate,
    DATEADD(DAY, @BorrowDays, DATEADD(DAY, n, CAST('2024-01-01' AS DATE))) AS DueDate,
    CASE
        WHEN n % 6 = 0 THEN NULL -- still borrowed
        WHEN n % 8 = 0 THEN DATEADD(DAY, @BorrowDays + 4, DATEADD(DAY, n, CAST('2024-01-01' AS DATE))) -- late
        ELSE DATEADD(DAY, @BorrowDays - 1, DATEADD(DAY, n, CAST('2024-01-01' AS DATE))) -- on time
    END AS ActualReturnDate
FROM N;
GO

/* =========================
   6) Reservations (140)
   ========================= */
;WITH N AS (
    SELECT TOP (140) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Reservations (UserID, CopyID, ReservationDate)
SELECT
    ((n - 1) % 50) + 1 AS UserID,
    ((n - 1) % 200) + 1 AS CopyID,
    DATEADD(DAY, 450 + n, CAST('2024-01-01' AS DATE)) AS ReservationDate
FROM N;
GO

/* =========================
   7) Fines (generated for late returns only)
   ========================= */
DECLARE @FinePerDay TINYINT;
SELECT TOP (1) @FinePerDay = DefaultFinePerDay FROM dbo.Settings;

INSERT INTO dbo.Fines (UserID, BorrowingRecordID, NumberOfLateDays, FineAmount, PaymentStatus)
SELECT
    br.UserID,
    br.BorrowingRecordID,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) AS LateDays,
    CAST(DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) * @FinePerDay AS DECIMAL(10,2)) AS FineAmount,
    CASE WHEN br.BorrowingRecordID % 3 = 0 THEN 1 ELSE 0 END AS PaymentStatus
FROM dbo.BorrowingRecords br
WHERE br.ActualReturnDate IS NOT NULL
  AND br.ActualReturnDate > br.DueDate;
GO