/*
02 - Library System - Insert Sample Data (SQL Server)
Run AFTER: Create_Tables.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Clean existing data (optional)
   ========================= */
DELETE FROM dbo.Fines;
DELETE FROM dbo.Reservations;
DELETE FROM dbo.BorrowingRecords;
DELETE FROM dbo.BookCopies;
DELETE FROM dbo.Books;
DELETE FROM dbo.Users;
DELETE FROM dbo.Settings;
GO

/* =========================
   Settings (single row)
   ========================= */
INSERT INTO dbo.Settings (DefaultBorrowDays, DefaultFinePerDay)
VALUES (14, 1);
GO

/* =========================
   Users (IDs 1..3)
   ========================= */
SET IDENTITY_INSERT dbo.Users ON;

INSERT INTO dbo.Users (UserID, [Name], Email, Phone, LibraryCardNumber) VALUES
(1, N'Khalid Amri', N'khaled.amri@example.com', N'0554940259', N'LCN1001'),
(2, N'Aisha Noor',  N'aisha.noor@example.com',  N'0501234567', N'LCN1002'),
(3, N'Omar Saleh',  N'omar.saleh@example.com',  N'0569876543', N'LCN1003');

SET IDENTITY_INSERT dbo.Users OFF;
GO

/* =========================
   Books (IDs 1..5)
   ========================= */
SET IDENTITY_INSERT dbo.Books ON;

INSERT INTO dbo.Books
(BookID, Author, Title, ISBN, PublicationDate, Genre, AdditionalDetails)
VALUES
(1, N'Robert C. Martin', N'Clean Code', N'9780132350884', '2008-08-01', N'Programming', N'A Handbook of Agile Software Craftsmanship'),
(2, N'Silberschatz',     N'Database System Concepts', N'9780073523323', '2010-01-15', N'Databases',   N'Fundamentals of database systems'),
(3, N'CLRS',             N'Introduction to Algorithms', N'9780262033848', '2009-07-31', N'Algorithms', N'CLRS - Third Edition'),
(4, N'Unknown',          N'Selected Arabic Literature', N'9781234567001', '2015-05-10', N'Literature', N'Arabic stories and critiques'),
(5, N'Alan Beaulieu',    N'Learning SQL', N'9780596520830', '2013-03-20', N'Databases', N'Practical guide to SQL');

SET IDENTITY_INSERT dbo.Books OFF;
GO

/* =========================
   BookCopies (IDs 1..8)
   ========================= */
SET IDENTITY_INSERT dbo.BookCopies ON;

INSERT INTO dbo.BookCopies (CopyID, BookID, AvailabilityStatus) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 2, 0),
(4, 2, 1),
(5, 3, 1),
(6, 4, 1),
(7, 5, 1),
(8, 5, 1);

SET IDENTITY_INSERT dbo.BookCopies OFF;
GO

/* =========================
   BorrowingRecords (IDs 1..3)
   ========================= */
SET IDENTITY_INSERT dbo.BorrowingRecords ON;

INSERT INTO dbo.BorrowingRecords
(BorrowingRecordID, UserID, CopyID, BorrowingDate, DueDate, ActualReturnDate)
VALUES
(1, 1, 2, '2025-10-01', '2025-10-15', '2025-10-14'),
(2, 2, 3, '2025-10-20', '2025-11-03', NULL),
(3, 3, 5, '2025-11-01', '2025-11-15', '2025-11-16');

SET IDENTITY_INSERT dbo.BorrowingRecords OFF;
GO

/* =========================
   Reservations (IDs 1..2)
   ========================= */
SET IDENTITY_INSERT dbo.Reservations ON;

INSERT INTO dbo.Reservations (ReservationID, UserID, CopyID, ReservationDate) VALUES
(1, 1, 4, '2025-11-20'),
(2, 2, 1, '2025-11-21');

SET IDENTITY_INSERT dbo.Reservations OFF;
GO

/* =========================
   Fines (IDs 1..2)
   ========================= */
SET IDENTITY_INSERT dbo.Fines ON;

INSERT INTO dbo.Fines
(FineID, UserID, BorrowingRecordID, NumberOfLateDays, FineAmount, PaymentStatus)
VALUES
(1, 3, 3, 1, 5.00, 0),
(2, 2, 2, 0, 0.00, 0);

SET IDENTITY_INSERT dbo.Fines OFF;
GO