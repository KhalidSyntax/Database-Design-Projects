/* 
01 - Simple Clinic System (LARGE DATASET)
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

/* =========================
   1) Persons (100)
   Gender: M/F
   ========================= */
;WITH N AS (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Persons (PersonID, Name, DateOfBirth, Gender, PhoneNumber, Email, Address)
SELECT
    n AS PersonID,
    CONCAT(CASE WHEN n % 2 = 0 THEN 'Ali' ELSE 'Sara' END, ' Person ', n) AS [Name],
    DATEADD(DAY, -(7000 + n*17), CAST('2025-01-01' AS DATE)) AS DateOfBirth,
    CASE WHEN n % 2 = 0 THEN 'M' ELSE 'F' END AS Gender,
    CONCAT('05', RIGHT(CONCAT('00000000', 10000000 + n), 8)) AS PhoneNumber,
    CONCAT('person', n, '@example.com') AS Email,
    CONCAT(CASE (n % 6)
        WHEN 0 THEN 'Riyadh'
        WHEN 1 THEN 'Jeddah'
        WHEN 2 THEN 'Dammam'
        WHEN 3 THEN 'Madinah'
        WHEN 4 THEN 'Mecca'
        ELSE 'Abha'
    END, ', Saudi Arabia') AS [Address]
FROM N;
GO

/* =========================
   2) Patients (60) => Persons 1..60
   ========================= */
;WITH N AS (
    SELECT TOP (60) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Patients (PatientID, PersonID)
SELECT
    n AS PatientID,
    n AS PersonID
FROM N;
GO

/* =========================
   3) Doctors (12) => Persons 61..72
   ========================= */
;WITH N AS (
    SELECT TOP (12) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Doctors (DoctorID, PersonID, Specialization)
SELECT
    n AS DoctorID,
    60 + n AS PersonID,
    CASE (n % 6)
        WHEN 0 THEN 'Dermatologist'
        WHEN 1 THEN 'Cardiologist'
        WHEN 2 THEN 'Pediatrician'
        WHEN 3 THEN 'Orthopedic'
        WHEN 4 THEN 'ENT'
        ELSE 'General Physician'
    END AS Specialization
FROM N;
GO

/* =========================
   4) MedicalRecords (140)
   ========================= */
;WITH N AS (
    SELECT TOP (140) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.MedicalRecords (MedicalRecordID, VisitDescription, Diagnosis, AdditionalNotes)
SELECT
    n AS MedicalRecordID,
    CONCAT('Visit #', n, ' - checkup and follow-up') AS VisitDescription,
    CASE (n % 7)
        WHEN 0 THEN 'Flu'
        WHEN 1 THEN 'Migraine'
        WHEN 2 THEN 'Allergy'
        WHEN 3 THEN 'Hypertension'
        WHEN 4 THEN 'Tonsillitis'
        WHEN 5 THEN 'Back Pain'
        ELSE 'General Check'
    END AS Diagnosis,
    CASE
        WHEN n % 4 = 0 THEN 'Recommended rest and hydration'
        WHEN n % 4 = 1 THEN 'Follow-up in 2 weeks'
        WHEN n % 4 = 2 THEN 'Lab tests requested'
        ELSE 'Lifestyle advice provided'
    END AS AdditionalNotes
FROM N;
GO

/* =========================
   5) Payments (160)
   ========================= */
;WITH N AS (
    SELECT TOP (160) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Payments (PaymentID, PaymentDate, PaymentMethod, AmountPaid, AdditionalNotes)
SELECT
    n AS PaymentID,
    DATEADD(DAY, n*3, CAST('2024-01-01' AS DATE)) AS PaymentDate,
    CASE (n % 3)
        WHEN 0 THEN 'Cash'
        WHEN 1 THEN 'Card'
        ELSE 'Transfer'
    END AS PaymentMethod,
    CAST((50 + (n % 10)*25) AS DECIMAL(18,0)) AS AmountPaid,
    CASE WHEN n % 5 = 0 THEN 'Paid in full' ELSE '—' END AS AdditionalNotes
FROM N;
GO

/* =========================
   6) Appointments (300)
   AppointmentStatus: 0..3
   MedicalRecordID & PaymentID: sometimes NULL
   ========================= */
;WITH N AS (
    SELECT TOP (300) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Appointments
(
    AppointmentID,
    PatientID,
    DoctorID,
    AppointmentDateTime,
    AppointmentStatus,
    MedicalRecordID,
    PaymentID
)
SELECT
    n AS AppointmentID,
    ((n - 1) % 60) + 1 AS PatientID,
    ((n - 1) % 12) + 1 AS DoctorID,
    DATEADD(MINUTE, (n % 12) * 30,
        DATEADD(DAY, n, CAST('2024-02-01' AS DATETIME))) AS AppointmentDateTime,
    (n % 4) AS AppointmentStatus,
    CASE WHEN n % 3 = 0 THEN NULL ELSE ((n - 1) % 140) + 1 END AS MedicalRecordID,
    CASE WHEN n % 4 = 0 THEN NULL ELSE ((n - 1) % 160) + 1 END AS PaymentID
FROM N;
GO

/* =========================
   7) Prescriptions (220)
   Frequency & SpecialInstructions in English
   ========================= */
;WITH N AS (
    SELECT TOP (220) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Prescriptions
(
    PrescriptionID,
    MedicalRecordID,
    MedicationName,
    Dosage,
    Frequency,
    StartDate,
    EndDate,
    SpecialInstructions
)
SELECT
    n AS PrescriptionID,
    ((n - 1) % 140) + 1 AS MedicalRecordID,
    CASE (n % 8)
        WHEN 0 THEN 'Paracetamol'
        WHEN 1 THEN 'Amoxicillin'
        WHEN 2 THEN 'Ibuprofen'
        WHEN 3 THEN 'Vitamin D'
        WHEN 4 THEN 'Metformin'
        WHEN 5 THEN 'Cetirizine'
        WHEN 6 THEN 'Omeprazole'
        ELSE 'Azithromycin'
    END AS MedicationName,
    CASE (n % 5)
        WHEN 0 THEN '500 mg'
        WHEN 1 THEN '250 mg'
        WHEN 2 THEN '400 mg'
        WHEN 3 THEN '1000 IU'
        ELSE '850 mg'
    END AS Dosage,
    CASE (n % 4)
        WHEN 0 THEN 'Twice daily after meals'
        WHEN 1 THEN 'Three times daily'
        WHEN 2 THEN 'As needed (max 3/day)'
        ELSE 'Once daily'
    END AS Frequency,
    DATEADD(DAY, n, CAST('2024-03-01' AS DATE)) AS StartDate,
    DATEADD(DAY, n + (3 + (n % 10)), CAST('2024-03-01' AS DATE)) AS EndDate,
    CASE (n % 4)
        WHEN 0 THEN 'Do not exceed the prescribed dose'
        WHEN 1 THEN 'Shake well before use'
        WHEN 2 THEN 'Take with food'
        ELSE 'Drink plenty of water'
    END AS SpecialInstructions
FROM N;
GO