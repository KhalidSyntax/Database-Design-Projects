/*
02 - Library System
Queries_Test.sql
Uses Settings table for business rules (borrow days & fines)
*/

SET NOCOUNT ON;
GO

/* =========================================
1) Show system settings
========================================= */
SELECT * FROM Settings;
GO

/* =========================================
2) List all users
========================================= */
SELECT *
FROM Users
ORDER BY UserID;
GO

/* =========================================
3) List all books
========================================= */
SELECT
    BookID,
    Title,
    Author,
    Genre,
    ISBN,
    PublicationDate
FROM Books
ORDER BY Title;
GO

/* =========================================
4) Show all book copies with availability
========================================= */
SELECT
    bc.CopyID,
    b.Title,
    bc.AvailabilityStatus
FROM BookCopies bc
JOIN Books b ON b.BookID = bc.BookID
ORDER BY bc.CopyID;
GO

/* =========================================
5) Show current borrowed books
========================================= */
SELECT
    br.BorrowingRecordID,
    u.Name AS UserName,
    b.Title,
    br.BorrowingDate,
    br.DueDate,
    br.ActualReturnDate
FROM BorrowingRecords br
JOIN Users u ON u.UserID = br.UserID
JOIN BookCopies bc ON bc.CopyID = br.CopyID
JOIN Books b ON b.BookID = bc.BookID
WHERE br.ActualReturnDate IS NULL;
GO

/* =========================================
6) Calculate due date using Settings
========================================= */
DECLARE @BorrowDate DATE = '2025-12-01';

SELECT
    @BorrowDate AS BorrowDate,
    DATEADD(DAY, s.DefaultBorrowDays, @BorrowDate) AS CalculatedDueDate
FROM Settings s;
GO

/* =========================================
7) Show late returns and late days
========================================= */
SELECT
    br.BorrowingRecordID,
    u.Name AS UserName,
    b.Title,
    br.DueDate,
    br.ActualReturnDate,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) AS LateDays
FROM BorrowingRecords br
JOIN Users u ON u.UserID = br.UserID
JOIN BookCopies bc ON bc.CopyID = br.CopyID
JOIN Books b ON b.BookID = bc.BookID
WHERE br.ActualReturnDate > br.DueDate;
GO

/* =========================================
8) Calculate fines using Settings
========================================= */
SELECT
    br.BorrowingRecordID,
    u.Name AS UserName,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) AS LateDays,
    s.DefaultFinePerDay,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) * s.DefaultFinePerDay AS FineAmount
FROM BorrowingRecords br
JOIN Users u ON u.UserID = br.UserID
CROSS JOIN Settings s
WHERE br.ActualReturnDate > br.DueDate;
GO

/* =========================================
9) Compare calculated fines with stored fines
========================================= */
SELECT
    f.FineID,
    u.Name AS UserName,
    f.NumberOfLateDays,
    f.FineAmount AS StoredFine,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) * s.DefaultFinePerDay AS CalculatedFine
FROM Fines f
JOIN BorrowingRecords br ON br.BorrowingRecordID = f.BorrowingRecordID
JOIN Users u ON u.UserID = f.UserID
CROSS JOIN Settings s;
GO

/* =========================================
10) Show unpaid fines
========================================= */
SELECT
    f.FineID,
    u.Name AS UserName,
    f.FineAmount,
    f.PaymentStatus
FROM Fines f
JOIN Users u ON u.UserID = f.UserID
WHERE f.PaymentStatus = 0;
GO