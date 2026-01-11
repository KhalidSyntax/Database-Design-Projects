/*
03 - Karate Club System
Queries_Test.sql (Simple Version)
Run AFTER:
- Create_Tables.sql
- Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) Show all members with their names and status */
SELECT
    m.MemberID,
    p.[Name] AS MemberName,
    m.IsActive
FROM dbo.Members m
JOIN dbo.Persons p ON p.PersonID = m.PersonID
ORDER BY m.MemberID;
GO

/* 2) Show all instructors with their names */
SELECT
    i.InstructorID,
    p.[Name] AS InstructorName,
    i.Qualification
FROM dbo.Instructors i
JOIN dbo.Persons p ON p.PersonID = i.PersonID
ORDER BY i.InstructorID;
GO

/* 3) Show member → instructor assignments */
SELECT
    mi.ID,
    pm.[Name] AS MemberName,
    pi.[Name] AS InstructorName,
    mi.AssignDate
FROM dbo.MemberInstructors mi
JOIN dbo.Members m ON m.MemberID = mi.MemberID
JOIN dbo.Persons pm ON pm.PersonID = m.PersonID
JOIN dbo.Instructors i ON i.InstructorID = mi.InstructorID
JOIN dbo.Persons pi ON pi.PersonID = i.PersonID
ORDER BY mi.AssignDate;
GO

/* 4) Show all payments with member name */
SELECT
    pay.PaymentID,
    p.[Name] AS MemberName,
    pay.Amount,
    pay.[Date]
FROM dbo.Payments pay
JOIN dbo.Members m ON m.MemberID = pay.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
ORDER BY pay.[Date];
GO

/* 5) Total paid per member */
SELECT
    m.MemberID,
    p.[Name] AS MemberName,
    SUM(pay.Amount) AS TotalPaid
FROM dbo.Payments pay
JOIN dbo.Members m ON m.MemberID = pay.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
GROUP BY m.MemberID, p.[Name]
ORDER BY TotalPaid DESC;
GO

/* 6) List subscription periods */
SELECT
    sp.PeriodID,
    p.[Name] AS MemberName,
    sp.StartDate,
    sp.EndDate,
    sp.Fees,
    sp.Paid
FROM dbo.SubscriptionPeriods sp
JOIN dbo.Members m ON m.MemberID = sp.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
ORDER BY sp.StartDate;
GO

/* 7) Unpaid subscription periods */
SELECT
    sp.PeriodID,
    p.[Name] AS MemberName,
    sp.Fees,
    sp.StartDate,
    sp.EndDate
FROM dbo.SubscriptionPeriods sp
JOIN dbo.Members m ON m.MemberID = sp.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
WHERE sp.Paid = 0
ORDER BY sp.EndDate;
GO

/* 8) List belt tests with member + rank */
SELECT
    bt.TestID,
    p.[Name] AS MemberName,
    br.RankName,
    bt.Result,
    bt.[Date]
FROM dbo.BeltTests bt
JOIN dbo.Members m ON m.MemberID = bt.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
JOIN dbo.BeltRanks br ON br.RankID = bt.RankID
ORDER BY bt.[Date];
GO

/* 9) Failed belt tests */
SELECT
    bt.TestID,
    p.[Name] AS MemberName,
    br.RankName,
    bt.[Date]
FROM dbo.BeltTests bt
JOIN dbo.Members m ON m.MemberID = bt.MemberID
JOIN dbo.Persons p ON p.PersonID = m.PersonID
JOIN dbo.BeltRanks br ON br.RankID = bt.RankID
WHERE bt.Result = 0
ORDER BY bt.[Date];
GO

/* 10) Count members by belt rank */
SELECT
    br.RankName,
    COUNT(*) AS MembersCount
FROM dbo.Members m
JOIN dbo.BeltRanks br ON br.RankID = m.LastBeltRank
GROUP BY br.RankName
ORDER BY MembersCount DESC;
GO