/*
03 - Karate Club System - Insert Sample Data (SQL Server)
Run AFTER: Create_Tables.sql
*/

/* =========================
   Clean existing data (optional)
   ========================= */
DELETE FROM dbo.SubscriptionPeriods;
DELETE FROM dbo.BeltTests;
DELETE FROM dbo.MemberInstructors;
DELETE FROM dbo.Payments;
DELETE FROM dbo.Members;
DELETE FROM dbo.Instructors;
DELETE FROM dbo.BeltRanks;
DELETE FROM dbo.Persons;
GO

/* =========================
   Persons (50)
   ========================= */


INSERT INTO dbo.Persons (PersonID, [Name], [Address], ContactInfo) VALUES
(1,'Fahad Alharbi','Riyadh, Saudi Arabia','0501000001'),
(2,'Saad Alotaibi','Riyadh, Saudi Arabia','0501000002'),
(3,'Nasser Alqahtani','Jeddah, Saudi Arabia','0501000003'),
(4,'Majed Alshammari','Dammam, Saudi Arabia','0501000004'),
(5,'Yousef Alghamdi','Madinah, Saudi Arabia','0501000005'),
(6,'Abdullah Almutairi','Mecca, Saudi Arabia','0501000006'),
(7,'Hamad Alzahrani','Taif, Saudi Arabia','0501000007'),
(8,'Omar Alsubaie','Abha, Saudi Arabia','0501000008'),
(9,'Ali Albalawi','Tabuk, Saudi Arabia','0501000009'),
(10,'Khalid Alenazi','Jazan, Saudi Arabia','0501000010'),

(11,'Ahmed Saleh','Riyadh, Saudi Arabia','0502000011'),
(12,'Mohammed Nasser','Jeddah, Saudi Arabia','0502000012'),
(13,'Hassan Saeed','Dammam, Saudi Arabia','0502000013'),
(14,'Abdulrahman Omar','Madinah, Saudi Arabia','0502000014'),
(15,'Sultan Ahmed','Mecca, Saudi Arabia','0502000015'),
(16,'Faisal Khalid','Taif, Saudi Arabia','0502000016'),
(17,'Bader Abdullah','Abha, Saudi Arabia','0502000017'),
(18,'Turki Fahad','Tabuk, Saudi Arabia','0502000018'),
(19,'Rayan Saad','Jazan, Saudi Arabia','0502000019'),
(20,'Yasir Majed','Riyadh, Saudi Arabia','0502000020'),

(21,'Aisha Noor','Jeddah, Saudi Arabia','0502000021'),
(22,'Sara Khaled','Dammam, Saudi Arabia','0502000022'),
(23,'Layla Hassan','Madinah, Saudi Arabia','0502000023'),
(24,'Maha Abdulrahman','Mecca, Saudi Arabia','0502000024'),
(25,'Huda Sultan','Taif, Saudi Arabia','0502000025'),
(26,'Noura Faisal','Abha, Saudi Arabia','0502000026'),
(27,'Reem Bader','Tabuk, Saudi Arabia','0502000027'),
(28,'Maryam Turki','Jazan, Saudi Arabia','0502000028'),
(29,'Dania Rayan','Riyadh, Saudi Arabia','0502000029'),
(30,'Wafa Yasir','Jeddah, Saudi Arabia','0502000030'),

(31,'Salem Ahmad','Dammam, Saudi Arabia','0502000031'),
(32,'Mansour Mohammed','Madinah, Saudi Arabia','0502000032'),
(33,'Tariq Hassan','Mecca, Saudi Arabia','0502000033'),
(34,'Nawaf Abdulrahman','Taif, Saudi Arabia','0502000034'),
(35,'Ziyad Sultan','Abha, Saudi Arabia','0502000035'),
(36,'Rami Faisal','Tabuk, Saudi Arabia','0502000036'),
(37,'Kareem Bader','Jazan, Saudi Arabia','0502000037'),
(38,'Hani Turki','Riyadh, Saudi Arabia','0502000038'),
(39,'Bilal Rayan','Jeddah, Saudi Arabia','0502000039'),
(40,'Adel Yasir','Dammam, Saudi Arabia','0502000040'),

(41,'Fahad Ibrahim','Madinah, Saudi Arabia','0503000041'),
(42,'Saad Hamza','Mecca, Saudi Arabia','0503000042'),
(43,'Nasser Salman','Taif, Saudi Arabia','0503000043'),
(44,'Majed Samir','Abha, Saudi Arabia','0503000044'),
(45,'Yousef Karim','Tabuk, Saudi Arabia','0503000045'),
(46,'Abdullah Taha','Jazan, Saudi Arabia','0503000046'),
(47,'Hamad Walid','Riyadh, Saudi Arabia','0503000047'),
(48,'Omar Rami','Jeddah, Saudi Arabia','0503000048'),
(49,'Ali Zaid','Dammam, Saudi Arabia','0503000049'),
(50,'Khalid Ammar','Madinah, Saudi Arabia','0503000050');
GO

/* =========================
   BeltRanks (5)
   ========================= */


INSERT INTO dbo.BeltRanks (RankID, RankName, TestFees) VALUES
(1,'White Belt',0.00),
(2,'Yellow Belt',50.00),
(3,'Green Belt',75.00),
(4,'Blue Belt',100.00),
(5,'Black Belt',150.00);
GO

/* =========================
   Instructors (10) using PersonID 1..10
   ========================= */


INSERT INTO dbo.Instructors (InstructorID, PersonID, Qualification) VALUES
(1,1,'Certified Black Belt 2nd Dan'),
(2,2,'Certified Black Belt 3rd Dan'),
(3,3,'Certified Black Belt 1st Dan'),
(4,4,'Certified Black Belt 4th Dan'),
(5,5,'Certified Black Belt 2nd Dan'),
(6,6,'Certified Black Belt 3rd Dan'),
(7,7,'Certified Black Belt 1st Dan'),
(8,8,'Certified Black Belt 2nd Dan'),
(9,9,'Certified Black Belt 3rd Dan'),
(10,10,'Certified Black Belt 4th Dan');
GO

/* =========================
   Members (30) using PersonID 11..40
   LastBeltRank distributed, IsActive mostly 1
   ========================= */


;WITH M AS (
    SELECT TOP (30)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS MemberID,
        (10 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS PersonID
    FROM sys.all_objects
)
INSERT INTO dbo.Members (MemberID, PersonID, EmergencyContactInfo, LastBeltRank, IsActive)
SELECT
    MemberID,
    PersonID,
    CONCAT('055', RIGHT(CONCAT('0000000', MemberID * 777), 7)) AS EmergencyContactInfo,
    CASE
        WHEN MemberID <= 8  THEN 1
        WHEN MemberID <= 16 THEN 2
        WHEN MemberID <= 23 THEN 3
        WHEN MemberID <= 28 THEN 4
        ELSE 5
    END AS LastBeltRank,
    CASE WHEN MemberID % 10 = 0 THEN 0 ELSE 1 END AS IsActive
FROM M;
GO

/* =========================
   Payments (70)
   - First 60 payments will be used by SubscriptionPeriods (PaymentID 1..60)
   - Remaining 10 are extra payments
   ========================= */


;WITH N AS (
    SELECT TOP (70) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Payments (PaymentID, Amount, [Date], MemberID)
SELECT
    n AS PaymentID,
    CASE
        WHEN n % 6 = 0 THEN 300.00
        WHEN n % 6 = 1 THEN 150.00
        WHEN n % 6 = 2 THEN 200.00
        WHEN n % 6 = 3 THEN 250.00
        WHEN n % 6 = 4 THEN 350.00
        ELSE 180.00
    END AS Amount,
    DATEADD(DAY, n * 7, CAST('2024-01-01' AS DATE)) AS [Date],
    ((n - 1) % 30) + 1 AS MemberID
FROM N;
GO

/* =========================
   MemberInstructors (40 assignments)
   ========================= */


;WITH A AS (
    SELECT TOP (40) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.MemberInstructors (ID, MemberID, InstructorID, AssignDate)
SELECT
    n AS ID,
    ((n - 1) % 30) + 1 AS MemberID,
    ((n - 1) % 10) + 1 AS InstructorID,
    DATEADD(DAY, n * 10, CAST('2024-02-01' AS DATETIME)) AS AssignDate
FROM A;
GO

/* =========================
   SubscriptionPeriods (60)
   - Paid is mostly 1, some 0
   - PaymentID linked for Paid=1 (uses Payments 1..60)
   ========================= */


;WITH S AS (
    SELECT TOP (60) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.SubscriptionPeriods
(PeriodID, StartDate, EndDate, Fees, Paid, MemberID, PaymentID)
SELECT
    n AS PeriodID,
    DATEADD(DAY, n * 15, CAST('2024-01-01' AS DATETIME)) AS StartDate,
    DATEADD(DAY, n * 15 + 89, CAST('2024-01-01' AS DATETIME)) AS EndDate,
    CASE
        WHEN n % 4 = 0 THEN 300.00
        WHEN n % 4 = 1 THEN 150.00
        WHEN n % 4 = 2 THEN 200.00
        ELSE 250.00
    END AS Fees,
    CASE WHEN n % 9 = 0 THEN 0 ELSE 1 END AS Paid,
    ((n - 1) % 30) + 1 AS MemberID,
    CASE WHEN n % 9 = 0 THEN NULL ELSE n END AS PaymentID
FROM S;
GO

/* =========================
   BeltTests (80)
   - PaymentID linked for first 50 tests (1..50), then NULL
   - Result: mostly pass, some fail
   ========================= */


;WITH T AS (
    SELECT TOP (80) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.BeltTests
(TestID, MemberID, RankID, Result, [Date], TestedByInstructorID, PaymentID)
SELECT
    n AS TestID,
    ((n - 1) % 30) + 1 AS MemberID,
    ((n - 1) % 5) + 1 AS RankID,
    CASE WHEN n % 7 = 0 THEN 0 ELSE 1 END AS Result,
    DATEADD(DAY, n * 11, CAST('2024-03-01' AS DATE)) AS [Date],
    ((n - 1) % 10) + 1 AS TestedByInstructorID,
    CASE WHEN n <= 50 THEN n ELSE NULL END AS PaymentID
FROM T;
GO