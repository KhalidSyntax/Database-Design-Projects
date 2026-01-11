/*
02 - Library System
Queries_Test.sql (Simple)
Run AFTER:
- Create_Tables.sql
- Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) Show system settings */
SELECT * FROM dbo.Settings;
GO

/* 2) List users */
SELECT
    UserID,
    [Name],
    Phone,
    Email,
    LibraryCardNumber
FROM dbo.Users
ORDER BY UserID;
GO

/* 3) List books */
SELECT
    BookID,
    Title,
    Author,
    Genre,
    ISBN,
    PublicationDate
FROM dbo.Books
ORDER BY Title;
GO

/* 4) Show copies with book title */
SELECT
    bc.CopyID,
    b.Title,
    bc.AvailabilityStatus
FROM dbo.BookCopies bc
JOIN dbo.Books b ON b.BookID = bc.BookID
ORDER BY bc.CopyID;
GO

/* 5) Borrowing records with user + book title */
SELECT
    br.BorrowingRecordID,
    u.[Name] AS UserName,
    b.Title,
    br.BorrowingDate,
    br.DueDate,
    br.ActualReturnDate
FROM dbo.BorrowingRecords br
JOIN dbo.Users u ON u.UserID = br.UserID
JOIN dbo.BookCopies bc ON bc.CopyID = br.CopyID
JOIN dbo.Books b ON b.BookID = bc.BookID
ORDER BY br.BorrowingDate;
GO

/* 6) Currently borrowed (not returned yet) */
SELECT
    br.BorrowingRecordID,
    u.[Name] AS UserName,
    br.CopyID,
    br.BorrowingDate,
    br.DueDate
FROM dbo.BorrowingRecords br
JOIN dbo.Users u ON u.UserID = br.UserID
WHERE br.ActualReturnDate IS NULL
ORDER BY br.DueDate;
GO

/* 7) Late returns (simple) */
SELECT
    br.BorrowingRecordID,
    u.[Name] AS UserName,
    br.DueDate,
    br.ActualReturnDate,
    DATEDIFF(DAY, br.DueDate, br.ActualReturnDate) AS LateDays
FROM dbo.BorrowingRecords br
JOIN dbo.Users u ON u.UserID = br.UserID
WHERE br.ActualReturnDate IS NOT NULL
  AND br.ActualReturnDate > br.DueDate
ORDER BY LateDays DESC;
GO

/* 8) Show fines with user names */
SELECT
    f.FineID,
    u.[Name] AS UserName,
    f.NumberOfLateDays,
    f.FineAmount,
    f.PaymentStatus
FROM dbo.Fines f
JOIN dbo.Users u ON u.UserID = f.UserID
ORDER BY f.FineAmount DESC;
GO

/* 9) Unpaid fines */
SELECT
    f.FineID,
    u.[Name] AS UserName,
    f.FineAmount
FROM dbo.Fines f
JOIN dbo.Users u ON u.UserID = f.UserID
WHERE f.PaymentStatus = 0
ORDER BY f.FineAmount DESC;
GO

/* 10) Reservations list */
SELECT
    r.ReservationID,
    u.[Name] AS UserName,
    r.CopyID,
    r.ReservationDate
FROM dbo.Reservations r
JOIN dbo.Users u ON u.UserID = r.UserID
ORDER BY r.ReservationDate;
GO