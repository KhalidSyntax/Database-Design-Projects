/*
01 - Simple Clinic System (SQL Server)
Insert Sample Data (LARGE DATASET)

Run AFTER: Create_Tables.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Clean existing data
   ========================= */
DELETE FROM dbo.Prescriptions;
DELETE FROM dbo.Appointments;
DELETE FROM dbo.Payments;
DELETE FROM dbo.MedicalRecords;
DELETE FROM dbo.Doctors;
DELETE FROM dbo.Patients;
DELETE FROM dbo.Persons;
GO

/* Reseed identities (recommended) */
DBCC CHECKIDENT ('dbo.Prescriptions', RESEED, 0);
DBCC CHECKIDENT ('dbo.Appointments', RESEED, 0);
DBCC CHECKIDENT ('dbo.Payments', RESEED, 0);
DBCC CHECKIDENT ('dbo.MedicalRecords', RESEED, 0);
DBCC CHECKIDENT ('dbo.Doctors', RESEED, 0);
DBCC CHECKIDENT ('dbo.Patients', RESEED, 0);
DBCC CHECKIDENT ('dbo.Persons', RESEED, 0);
GO

/* =========================
   1) Persons (120)
   - Persons 1..80 => Patients
   - Persons 81..92 => Doctors (12)
   - Remaining persons are unused (still realistic for future expansion)
   ========================= */
;WITH N AS
(
    SELECT TOP (120) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Persons (Name, DateOfBirth, Gender, PhoneNumber, Email, Address)
SELECT
    CONCAT(
        CASE WHEN n % 4 = 0 THEN 'Ali'
             WHEN n % 4 = 1 THEN 'Sara'
             WHEN n % 4 = 2 THEN 'Omar'
             ELSE 'Maha' END,
        ' ',
        CASE WHEN n % 5 = 0 THEN 'Ahmed'
             WHEN n % 5 = 1 THEN 'Khalid'
             WHEN n % 5 = 2 THEN 'Saleh'
             WHEN n % 5 = 3 THEN 'Nasser'
             ELSE 'Hassan' END,
        ' #', n
    ) AS [Name],
    DATEADD(DAY, -(6500 + n * 11), CAST('2025-01-01' AS DATE)) AS DateOfBirth,
    CASE WHEN n % 2 = 0 THEN 'M' ELSE 'F' END AS Gender,
    CONCAT('05', RIGHT(CONCAT('00000000', 10000000 + n), 8)) AS PhoneNumber,
    CONCAT('person', n, '@example.com') AS Email,
    CONCAT(
        CASE (n % 7)
            WHEN 0 THEN 'Riyadh'
            WHEN 1 THEN 'Jeddah'
            WHEN 2 THEN 'Dammam'
            WHEN 3 THEN 'Madinah'
            WHEN 4 THEN 'Mecca'
            WHEN 5 THEN 'Taif'
            ELSE 'Abha'
        END,
        ', Saudi Arabia'
    ) AS [Address]
FROM N;
GO

/* =========================
   2) Patients (80) => Persons 1..80
   ========================= */
;WITH N AS
(
    SELECT TOP (80) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Patients (PersonID)
SELECT n FROM N;
GO

/* =========================
   3) Doctors (12) => Persons 81..92
   ========================= */
;WITH N AS
(
    SELECT TOP (12) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Doctors (PersonID, Specialization)
SELECT
    80 + n,
    CASE (n % 6)
        WHEN 0 THEN 'Dermatologist'
        WHEN 1 THEN 'Cardiologist'
        WHEN 2 THEN 'Pediatrician'
        WHEN 3 THEN 'Orthopedic'
        WHEN 4 THEN 'ENT'
        ELSE 'General Physician'
    END
FROM N;
GO

/* =========================
   4) MedicalRecords (220)
   ========================= */
;WITH N AS
(
    SELECT TOP (220) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.MedicalRecords (VisitDescription, Diagnosis, AdditionalNotes)
SELECT
    CONCAT('Visit #', n, ' - consultation') AS VisitDescription,
    CASE (n % 10)
        WHEN 0 THEN 'Flu'
        WHEN 1 THEN 'Migraine'
        WHEN 2 THEN 'Allergy'
        WHEN 3 THEN 'Hypertension'
        WHEN 4 THEN 'Tonsillitis'
        WHEN 5 THEN 'Back Pain'
        WHEN 6 THEN 'Gastritis'
        WHEN 7 THEN 'Diabetes Follow-up'
        WHEN 8 THEN 'Skin Rash'
        ELSE 'General Check'
    END AS Diagnosis,
    CASE (n % 5)
        WHEN 0 THEN 'Follow-up in 2 weeks'
        WHEN 1 THEN 'Lab tests requested'
        WHEN 2 THEN 'Lifestyle advice provided'
        WHEN 3 THEN 'Prescription provided'
        ELSE 'Referred to specialist if needed'
    END AS AdditionalNotes
FROM N;
GO

/* =========================
   5) Payments (260)
   ========================= */
;WITH N AS
(
    SELECT TOP (260) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Payments (PaymentDate, PaymentMethod, AmountPaid, AdditionalNotes)
SELECT
    DATEADD(DAY, n * 2, CAST('2024-01-01' AS DATE)) AS PaymentDate,
    CASE (n % 3)
        WHEN 0 THEN 'Cash'
        WHEN 1 THEN 'Card'
        ELSE 'Transfer'
    END AS PaymentMethod,
    CAST(100 + (n % 12) * 25 AS DECIMAL(18,0)) AS AmountPaid,
    CASE WHEN n % 6 = 0 THEN 'Paid in full'
         WHEN n % 6 = 1 THEN 'Partial payment'
         ELSE NULL
    END AS AdditionalNotes
FROM N;
GO

/* =========================
   6) Appointments (450)
   - PatientID: 1..80
   - DoctorID : 1..12
   - Status: 0..3
   - MedicalRecordID sometimes NULL
   - PaymentID sometimes NULL
   ========================= */
;WITH N AS
(
    SELECT TOP (450) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Appointments
(
    PatientID,
    DoctorID,
    AppointmentDateTime,
    AppointmentStatus,
    MedicalRecordID,
    PaymentID
)
SELECT
    ((n - 1) % 80) + 1 AS PatientID,
    ((n - 1) % 12) + 1 AS DoctorID,
    DATEADD(MINUTE, (n % 16) * 30,
        DATEADD(DAY, n, CAST('2024-02-01' AS DATETIME))) AS AppointmentDateTime,
    (n % 4) AS AppointmentStatus,
    CASE WHEN n % 3 = 0 THEN NULL ELSE ((n - 1) % 220) + 1 END AS MedicalRecordID,
    CASE WHEN n % 4 = 0 THEN NULL ELSE ((n - 1) % 260) + 1 END AS PaymentID
FROM N;
GO

/* =========================
   7) Prescriptions (350)
   - Frequency + instructions in English
   ========================= */
;WITH N AS
(
    SELECT TOP (350) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Prescriptions
(
    MedicalRecordID,
    MedicationName,
    Dosage,
    Frequency,
    StartDate,
    EndDate,
    SpecialInstructions
)
SELECT
    ((n - 1) % 220) + 1 AS MedicalRecordID,
    CASE (n % 10)
        WHEN 0 THEN 'Paracetamol'
        WHEN 1 THEN 'Amoxicillin'
        WHEN 2 THEN 'Ibuprofen'
        WHEN 3 THEN 'Vitamin D'
        WHEN 4 THEN 'Metformin'
        WHEN 5 THEN 'Cetirizine'
        WHEN 6 THEN 'Omeprazole'
        WHEN 7 THEN 'Azithromycin'
        WHEN 8 THEN 'Salbutamol'
        ELSE 'Loratadine'
    END AS MedicationName,
    CASE (n % 6)
        WHEN 0 THEN '500 mg'
        WHEN 1 THEN '250 mg'
        WHEN 2 THEN '400 mg'
        WHEN 3 THEN '1000 IU'
        WHEN 4 THEN '850 mg'
        ELSE '10 mg'
    END AS Dosage,
    CASE (n % 4)
        WHEN 0 THEN 'Twice daily after meals'
        WHEN 1 THEN 'Three times daily'
        WHEN 2 THEN 'Once daily'
        ELSE 'As needed (max 3/day)'
    END AS Frequency,
    DATEADD(DAY, n, CAST('2024-03-01' AS DATE)) AS StartDate,
    DATEADD(DAY, n + (3 + (n % 12)), CAST('2024-03-01' AS DATE)) AS EndDate,
    CASE (n % 5)
        WHEN 0 THEN 'Do not exceed the prescribed dose'
        WHEN 1 THEN 'Take with food'
        WHEN 2 THEN 'Drink plenty of water'
        WHEN 3 THEN 'Avoid driving if drowsy'
        ELSE 'Shake well before use'
    END AS SpecialInstructions
FROM N;
GO