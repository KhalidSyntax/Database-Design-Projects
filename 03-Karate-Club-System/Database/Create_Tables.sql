/*
03 - Karate Club System (SQL Server) - Create Tables
*/

SET NOCOUNT ON;
GO

/* =========================
   DROP TABLES (re-run safe)
   ========================= */
IF OBJECT_ID('dbo.SubscriptionPeriods','U') IS NOT NULL DROP TABLE dbo.SubscriptionPeriods;
IF OBJECT_ID('dbo.BeltTests','U')           IS NOT NULL DROP TABLE dbo.BeltTests;
IF OBJECT_ID('dbo.MemberInstructors','U')   IS NOT NULL DROP TABLE dbo.MemberInstructors;
IF OBJECT_ID('dbo.Payments','U')            IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.Members','U')             IS NOT NULL DROP TABLE dbo.Members;
IF OBJECT_ID('dbo.Instructors','U')         IS NOT NULL DROP TABLE dbo.Instructors;
IF OBJECT_ID('dbo.BeltRanks','U')           IS NOT NULL DROP TABLE dbo.BeltRanks;
IF OBJECT_ID('dbo.Persons','U')             IS NOT NULL DROP TABLE dbo.Persons;
GO

/* =========================
   1) Persons
   ========================= */
CREATE TABLE dbo.Persons
(
    PersonID     INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       VARCHAR(100) NOT NULL,
    [Address]    VARCHAR(100) NULL,
    ContactInfo  VARCHAR(100) NOT NULL
);
GO

/* =========================
   2) BeltRanks
   ========================= */
CREATE TABLE dbo.BeltRanks
(
    RankID    INT IDENTITY(1,1) PRIMARY KEY,
    RankName  VARCHAR(50) NOT NULL,
    TestFees  SMALLMONEY NOT NULL
);
GO

/* =========================
   3) Instructors
   ========================= */
CREATE TABLE dbo.Instructors
(
    InstructorID  INT IDENTITY(1,1) PRIMARY KEY,
    PersonID      INT NOT NULL,
    Qualification VARCHAR(100) NULL,

    CONSTRAINT FK_Instructors_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID)
);
GO

/* =========================
   4) Members
   ========================= */
CREATE TABLE dbo.Members
(
    MemberID              INT IDENTITY(1,1) PRIMARY KEY,
    PersonID              INT NOT NULL,
    EmergencyContactInfo  VARCHAR(100) NOT NULL,
    LastBeltRank          INT NOT NULL,
    IsActive              BIT NOT NULL,

    CONSTRAINT FK_Members_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID),

    CONSTRAINT FK_Members_BeltRanks
        FOREIGN KEY (LastBeltRank) REFERENCES dbo.BeltRanks(RankID)
);
GO

/* =========================
   5) Payments
   ========================= */
CREATE TABLE dbo.Payments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    Amount    DECIMAL(10,2) NOT NULL,
    [Date]    DATE NOT NULL,
    MemberID  INT NOT NULL,

    CONSTRAINT FK_Payments_Members
        FOREIGN KEY (MemberID) REFERENCES dbo.Members(MemberID)
);
GO

/* =========================
   6) MemberInstructors
   ========================= */
CREATE TABLE dbo.MemberInstructors
(
    ID           INT IDENTITY(1,1) PRIMARY KEY,
    MemberID     INT NOT NULL,
    InstructorID INT NOT NULL,
    AssignDate   DATETIME NOT NULL,

    CONSTRAINT FK_MemberInstructors_Members
        FOREIGN KEY (MemberID) REFERENCES dbo.Members(MemberID),

    CONSTRAINT FK_MemberInstructors_Instructors
        FOREIGN KEY (InstructorID) REFERENCES dbo.Instructors(InstructorID)
);
GO

/* =========================
   7) BeltTests
   ========================= */
CREATE TABLE dbo.BeltTests
(
    TestID              INT IDENTITY(1,1) PRIMARY KEY,
    MemberID            INT NOT NULL,
    RankID              INT NOT NULL,
    Result              BIT NOT NULL,
    [Date]              DATE NOT NULL,
    TestedByInstructorID INT NOT NULL,
    PaymentID           INT NULL,

    CONSTRAINT FK_BeltTests_Members
        FOREIGN KEY (MemberID) REFERENCES dbo.Members(MemberID),

    CONSTRAINT FK_BeltTests_BeltRanks
        FOREIGN KEY (RankID) REFERENCES dbo.BeltRanks(RankID),

    CONSTRAINT FK_BeltTests_Instructors
        FOREIGN KEY (TestedByInstructorID) REFERENCES dbo.Instructors(InstructorID),

    CONSTRAINT FK_BeltTests_Payments
        FOREIGN KEY (PaymentID) REFERENCES dbo.Payments(PaymentID)
);
GO

/* =========================
   8) SubscriptionPeriods
   ========================= */
CREATE TABLE dbo.SubscriptionPeriods
(
    PeriodID   INT IDENTITY(1,1) PRIMARY KEY,
    StartDate  DATETIME NOT NULL,
    EndDate    DATETIME NOT NULL,
    Fees       SMALLMONEY NOT NULL,
    Paid       BIT NOT NULL,
    MemberID   INT NOT NULL,
    PaymentID  INT NULL,

    CONSTRAINT FK_SubscriptionPeriods_Members
        FOREIGN KEY (MemberID) REFERENCES dbo.Members(MemberID),

    CONSTRAINT FK_SubscriptionPeriods_Payments
        FOREIGN KEY (PaymentID) REFERENCES dbo.Payments(PaymentID)
);
GO

/* =========================
   Helpful indexes
   ========================= */
CREATE INDEX IX_Instructors_PersonID ON dbo.Instructors(PersonID);

CREATE INDEX IX_Members_PersonID ON dbo.Members(PersonID);
CREATE INDEX IX_Members_LastBeltRank ON dbo.Members(LastBeltRank);

CREATE INDEX IX_Payments_MemberID ON dbo.Payments(MemberID);

CREATE INDEX IX_MemberInstructors_MemberID ON dbo.MemberInstructors(MemberID);
CREATE INDEX IX_MemberInstructors_InstructorID ON dbo.MemberInstructors(InstructorID);

CREATE INDEX IX_BeltTests_MemberID ON dbo.BeltTests(MemberID);
CREATE INDEX IX_BeltTests_RankID ON dbo.BeltTests(RankID);
CREATE INDEX IX_BeltTests_TestedByInstructorID ON dbo.BeltTests(TestedByInstructorID);
CREATE INDEX IX_BeltTests_PaymentID ON dbo.BeltTests(PaymentID);

CREATE INDEX IX_SubscriptionPeriods_MemberID ON dbo.SubscriptionPeriods(MemberID);
CREATE INDEX IX_SubscriptionPeriods_PaymentID ON dbo.SubscriptionPeriods(PaymentID);
GO