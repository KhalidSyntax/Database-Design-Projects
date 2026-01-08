/*
02 - Library Management System (Simple)
Sample Data Script (optional)
Run AFTER Create_Tables.sql
*/

-- Users
INSERT INTO dbo.LibraryUsers (FullName, PhoneNumber, Email, Address, LibraryCardNo) VALUES
(N'Ahmed Ali', N'0500000001', N'ahmed@example.com', N'Riyadh', N'CARD-0001'),
(N'Sara Omar', N'0500000002', N'sara@example.com',  N'Jazan',  N'CARD-0002');

-- Authors
INSERT INTO dbo.Authors (AuthorName) VALUES
(N'Author One'),
(N'Author Two');

-- Books
INSERT INTO dbo.Books (Title, ISBN, PublicationDate, Genre, AdditionalDetails) VALUES
(N'Learning SQL Basics', N'978000000001', '2020-01-01', N'Tech', N'Intro to SQL'),
(N'Database Design Fundamentals', N'978000000002', '2021-06-15', N'Tech', N'ERD and normalization');

-- BookAuthors (many-to-many)
INSERT INTO dbo.BookAuthors (BookID, AuthorID) VALUES
(1, 1),
(2, 1),
(2, 2);

-- Copies
INSERT INTO dbo.BookCopies (BookID, CopyCode, IsAvailable) VALUES
(1, N'COPY-001-A', 1),
(1, N'COPY-001-B', 1),
(2, N'COPY-002-A', 1);

-- Loans (borrow one copy)
INSERT INTO dbo.Loans (CopyID, UserID, BorrowDate, DueDate, ReturnDate, LoanStatus) VALUES
(1, 1, '2026-01-01', '2026-01-10', NULL, 1);

-- Mark the borrowed copy as not available
UPDATE dbo.BookCopies SET IsAvailable = 0 WHERE CopyID = 1;

-- Reservation (user reserves the same book)
INSERT INTO dbo.Reservations (BookID, UserID, RequestDate, QueuePosition, ReservationStatus) VALUES
(1, 2, '2026-01-02', 1, 1);

-- Fine example (late return)
INSERT INTO dbo.Fines (LoanID, UserID, FineDate, Amount, IsPaid, PaidDate) VALUES
(1, 1, '2026-01-12', 25.00, 0, NULL);
