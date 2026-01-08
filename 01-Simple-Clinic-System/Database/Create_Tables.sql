/*
01 - Simple Clinic System
Create Tables Script (SQL Server)

How to use:
1) Create a new database (optional):
   CREATE DATABASE SimpleClinicDB;
   GO
   USE SimpleClinicDB;
   GO
2) Run this script.
*/

-- Safety (re-run friendly)
IF OBJECT_ID('dbo.Prescriptions','U') IS NOT NULL DROP TABLE dbo.Prescriptions;
IF OBJECT_ID('dbo.Appointments','U') IS NOT NULL DROP TABLE dbo.Appointments;
IF OBJECT_ID('dbo.Payments','U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.MedicalRecords','U') IS NOT NULL DROP TABLE dbo.MedicalRecords;
IF OBJECT_ID('dbo.Patients','U') IS NOT NULL DROP TABLE dbo.Patients;
IF OBJECT_ID('dbo.Doctors','U') IS NOT NULL DROP TABLE dbo.Doctors;
IF OBJECT_ID('dbo.Persons','U') IS NOT NULL DROP TABLE dbo.Persons;
GO

CREATE TABLE dbo.Persons (
    PersonID        INT IDENTITY(1,1) PRIMARY KEY,
    [Name]          NVARCHAR(100) NOT NULL,
    DateOfBirth     DATE          NULL,
    Gender          NVARCHAR(10)  NULL,
    PhoneNumber     NVARCHAR(20)  NULL,
    Email           NVARCHAR(100) NULL,
    [Address]       NVARCHAR(200) NULL
);
GO

CREATE TABLE dbo.Patients (
    PatientID   INT IDENTITY(1,1) PRIMARY KEY,
    PersonID    INT NOT NULL UNIQUE,
    CONSTRAINT FK_Patients_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID)
        ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Doctors (
    DoctorID        INT IDENTITY(1,1) PRIMARY KEY,
    PersonID        INT NOT NULL UNIQUE,
    Specialization  NVARCHAR(100) NULL,
    CONSTRAINT FK_Doctors_Persons
        FOREIGN KEY (PersonID) REFERENCES dbo.Persons(PersonID)
        ON DELETE CASCADE
);
GO

CREATE TABLE dbo.MedicalRecords (
    MedicalRecordID     INT IDENTITY(1,1) PRIMARY KEY,
    VisitDescription    NVARCHAR(200) NULL,
    Diagnosis           NVARCHAR(200) NULL,
    AdditionalNotes     NVARCHAR(200) NULL
);
GO

CREATE TABLE dbo.Payments (
    PaymentID        INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate      DATE          NULL,
    PaymentMethod    NVARCHAR(50)  NULL,
    AmountPaid       DECIMAL(10,2) NULL,
    AdditionalNotes  NVARCHAR(200) NULL
);
GO

/*
AppointmentStatus suggested values (from requirements):
1 Pending
2 Confirmed
3 Completed
4 Canceled
5 Rescheduled
6 No-Show
*/
CREATE TABLE dbo.Appointments (
    AppointmentID      INT IDENTITY(1,1) PRIMARY KEY,
    PatientID          INT NOT NULL,
    DoctorID           INT NOT NULL,
    AppointmentDate    DATE NOT NULL,
    AppointmentTime    TIME(0) NOT NULL,
    AppointmentStatus  TINYINT NOT NULL,
    MedicalRecordID    INT NULL,
    PaymentID          INT NULL,

    CONSTRAINT FK_Appointments_Patients
        FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID),
    CONSTRAINT FK_Appointments_Doctors
        FOREIGN KEY (DoctorID) REFERENCES dbo.Doctors(DoctorID),
    CONSTRAINT FK_Appointments_MedicalRecords
        FOREIGN KEY (MedicalRecordID) REFERENCES dbo.MedicalRecords(MedicalRecordID),
    CONSTRAINT FK_Appointments_Payments
        FOREIGN KEY (PaymentID) REFERENCES dbo.Payments(PaymentID),

    CONSTRAINT CK_Appointments_Status CHECK (AppointmentStatus BETWEEN 1 AND 6)
);
GO

CREATE TABLE dbo.Prescriptions (
    PrescriptionID        INT IDENTITY(1,1) PRIMARY KEY,
    MedicalRecordID       INT NOT NULL,
    MedicationName        NVARCHAR(100) NOT NULL,
    Dosage                NVARCHAR(50)  NULL,
    Frequency             NVARCHAR(50)  NULL,
    StartDate             DATE          NULL,
    EndDate               DATE          NULL,
    SpecialInstructions   NVARCHAR(200) NULL,

    CONSTRAINT FK_Prescriptions_MedicalRecords
        FOREIGN KEY (MedicalRecordID) REFERENCES dbo.MedicalRecords(MedicalRecordID)
        ON DELETE CASCADE
);
GO

-- Helpful indexes
CREATE INDEX IX_Appointments_PatientID ON dbo.Appointments(PatientID);
CREATE INDEX IX_Appointments_DoctorID  ON dbo.Appointments(DoctorID);
CREATE INDEX IX_Prescriptions_MedicalRecordID ON dbo.Prescriptions(MedicalRecordID);
GO
