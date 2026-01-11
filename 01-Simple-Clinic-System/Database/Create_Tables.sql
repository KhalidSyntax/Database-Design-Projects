/*
01 - Simple Clinic System (SQL Server)
Create Tables Script

Run this first, then run Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Drop tables (re-run safe)
   ========================= */
IF OBJECT_ID('dbo.Prescriptions','U') IS NOT NULL DROP TABLE dbo.Prescriptions;
IF OBJECT_ID('dbo.Appointments','U') IS NOT NULL DROP TABLE dbo.Appointments;
IF OBJECT_ID('dbo.Payments','U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.MedicalRecords','U') IS NOT NULL DROP TABLE dbo.MedicalRecords;
IF OBJECT_ID('dbo.Doctors','U') IS NOT NULL DROP TABLE dbo.Doctors;
IF OBJECT_ID('dbo.Patients','U') IS NOT NULL DROP TABLE dbo.Patients;
IF OBJECT_ID('dbo.Persons','U') IS NOT NULL DROP TABLE dbo.Persons;
GO

/* =========================
   1) Persons
   ========================= */
CREATE TABLE dbo.Persons
(
    PersonID     INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       NVARCHAR(100) NOT NULL,
    DateOfBirth  DATE NULL,
    Gender       NVARCHAR(1) NOT NULL,
    PhoneNumber  NVARCHAR(20) NOT NULL,
    Email        NVARCHAR(100) NULL,
    [Address]    NVARCHAR(200) NULL,

    CONSTRAINT CK_Persons_Gender CHECK (Gender IN ('M','F'))
);
GO

/* =========================
   2) Patients
   ========================= */
CREATE TABLE dbo.Patients
(
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    PersonID  INT NOT NULL,

    CONSTRAINT UQ_Patients_PersonID UNIQUE (PersonID),
    CONSTRAINT FK_Patients_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID)
);
GO

/* =========================
   3) Doctors
   ========================= */
CREATE TABLE dbo.Doctors
(
    DoctorID       INT IDENTITY(1,1) PRIMARY KEY,
    PersonID       INT NOT NULL,
    Specialization NVARCHAR(100) NULL,

    CONSTRAINT UQ_Doctors_PersonID UNIQUE (PersonID),
    CONSTRAINT FK_Doctors_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID)
);
GO

/* =========================
   4) MedicalRecords
   ========================= */
CREATE TABLE dbo.MedicalRecords
(
    MedicalRecordID  INT IDENTITY(1,1) PRIMARY KEY,
    VisitDescription NVARCHAR(200) NULL,
    Diagnosis        NVARCHAR(200) NULL,
    AdditionalNotes  NVARCHAR(200) NULL
);
GO

/* =========================
   5) Payments
   ========================= */
CREATE TABLE dbo.Payments
(
    PaymentID       INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate     DATE NOT NULL,
    PaymentMethod   NVARCHAR(50) NULL,
    AmountPaid      DECIMAL(18,0) NOT NULL,
    AdditionalNotes NVARCHAR(200) NULL
);
GO

/* =========================
   6) Appointments
   AppointmentStatus values used in your data: 0..3
   ========================= */
CREATE TABLE dbo.Appointments
(
    AppointmentID       INT IDENTITY(1,1) PRIMARY KEY,
    PatientID           INT NOT NULL,
    DoctorID            INT NOT NULL,
    AppointmentDateTime DATETIME NOT NULL,
    AppointmentStatus   TINYINT NOT NULL,
    MedicalRecordID     INT NULL,
    PaymentID           INT NULL,

    CONSTRAINT FK_Appointments_Patients
        FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID),

    CONSTRAINT FK_Appointments_Doctors
        FOREIGN KEY (DoctorID) REFERENCES dbo.Doctors(DoctorID),

    CONSTRAINT FK_Appointments_MedicalRecords
        FOREIGN KEY (MedicalRecordID) REFERENCES dbo.MedicalRecords(MedicalRecordID),

    CONSTRAINT FK_Appointments_Payments
        FOREIGN KEY (PaymentID) REFERENCES dbo.Payments(PaymentID),

    CONSTRAINT CK_Appointments_Status CHECK (AppointmentStatus BETWEEN 0 AND 3)
);
GO

/* =========================
   7) Prescriptions
   ========================= */
CREATE TABLE dbo.Prescriptions
(
    PrescriptionID      INT IDENTITY(1,1) PRIMARY KEY,
    MedicalRecordID     INT NOT NULL,
    MedicationName      NVARCHAR(100) NOT NULL,
    Dosage              NVARCHAR(50) NOT NULL,
    Frequency           NVARCHAR(50) NOT NULL,
    StartDate           DATE NOT NULL,
    EndDate             DATE NOT NULL,
    SpecialInstructions NVARCHAR(200) NULL,

    CONSTRAINT FK_Prescriptions_MedicalRecords
        FOREIGN KEY (MedicalRecordID) REFERENCES dbo.MedicalRecords(MedicalRecordID)
);
GO

/* =========================
   Helpful indexes
   ========================= */
CREATE INDEX IX_Patients_PersonID ON dbo.Patients(PersonID);
CREATE INDEX IX_Doctors_PersonID ON dbo.Doctors(PersonID);

CREATE INDEX IX_Appointments_PatientID ON dbo.Appointments(PatientID);
CREATE INDEX IX_Appointments_DoctorID  ON dbo.Appointments(DoctorID);
CREATE INDEX IX_Appointments_DateTime  ON dbo.Appointments(AppointmentDateTime);

CREATE INDEX IX_Prescriptions_MedicalRecordID ON dbo.Prescriptions(MedicalRecordID);
GO