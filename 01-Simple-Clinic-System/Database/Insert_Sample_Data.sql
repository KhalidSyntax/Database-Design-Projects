/*
01 - Simple Clinic System - Sample Data
Inserts the same rows from your screenshots.
Prescriptions.Frequency + SpecialInstructions are converted to English.
*/

SET NOCOUNT ON;
GO

-- Clean existing data (optional)
DELETE FROM dbo.Prescriptions;
DELETE FROM dbo.Appointments;
DELETE FROM dbo.Payments;
DELETE FROM dbo.MedicalRecords;
DELETE FROM dbo.Doctors;
DELETE FROM dbo.Patients;
DELETE FROM dbo.Persons;
GO

/* ======================
   Persons (IDs 1..4)
   ====================== */
SET IDENTITY_INSERT dbo.Persons ON;

INSERT INTO dbo.Persons (PersonID, [Name], DateOfBirth, Gender, PhoneNumber, Email, [Address]) VALUES
(1, N'Ali Ahmed',  '1990-03-15', N'M', N'0501112233', N'ali@example.com',  N'Jeddah'),
(2, N'Sara Khaled','1985-07-10', N'F', N'0502223344', N'sara@example.com', N'Riyadh'),
(3, N'Omar Nasser','1992-12-01', N'M', N'0503334455', N'omar@example.com', N'Dammam'),
(4, N'Layla Saeed','1998-05-22', N'F', N'0504445566', N'layla@example.com',N'Jazan');

SET IDENTITY_INSERT dbo.Persons OFF;
GO

/* ======================
   Patients (IDs 1..4)
   ====================== */
SET IDENTITY_INSERT dbo.Patients ON;

INSERT INTO dbo.Patients (PatientID, PersonID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

SET IDENTITY_INSERT dbo.Patients OFF;
GO

/* ======================
   Doctors (IDs 1..2)
   ====================== */
SET IDENTITY_INSERT dbo.Doctors ON;

INSERT INTO dbo.Doctors (DoctorID, PersonID, Specialization) VALUES
(1, 2, N'Dermatologist'),
(2, 3, N'Cardiologist');

SET IDENTITY_INSERT dbo.Doctors OFF;
GO

/* ======================
   MedicalRecords (IDs 1..4)
   ====================== */
SET IDENTITY_INSERT dbo.MedicalRecords ON;

INSERT INTO dbo.MedicalRecords (MedicalRecordID, VisitDescription, Diagnosis, AdditionalNotes) VALUES
(1, N'Routine check-up and blood test', N'Normal results', N'Follow-up in 6 months'),
(2, N'Sore throat and mild fever',      N'Tonsillitis',    N'Antibiotics prescribed'),
(3, N'Headache and dizziness',          N'Migraine',       N'Avoid stress and get proper sleep'),
(4, N'Chest pain during exercise',      N'Angina',         N'Refer to cardiology for further tests');

SET IDENTITY_INSERT dbo.MedicalRecords OFF;
GO

/* ======================
   Payments (IDs 1..4)
   ====================== */
SET IDENTITY_INSERT dbo.Payments ON;

INSERT INTO dbo.Payments (PaymentID, PaymentDate, PaymentMethod, AmountPaid, AdditionalNotes) VALUES
(1, '2025-11-06', N'Cash',     200, N'Paid in full'),
(2, '2025-11-06', N'Card',     150, N'Partial payment'),
(3, '2025-11-06', N'Transfer', 300, N'Online bank transfer'),
(4, '2025-11-06', N'Cash',     250, N'Follow-up session payment');

SET IDENTITY_INSERT dbo.Payments OFF;
GO

/* ======================
   Appointments (IDs 1..10)
   ====================== */
SET IDENTITY_INSERT dbo.Appointments ON;

INSERT INTO dbo.Appointments
(AppointmentID, PatientID, DoctorID, AppointmentDateTime, AppointmentStatus, MedicalRecordID, PaymentID)
VALUES
(1,  1, 1, '2025-11-06T09:00:00', 0, NULL, NULL),
(2,  2, 2, '2025-11-06T09:30:00', 1, 1,    1),
(3,  3, 1, '2025-11-06T10:00:00', 0, NULL, NULL),
(4,  4, 2, '2025-11-06T10:30:00', 2, NULL, NULL),
(5,  1, 1, '2025-11-06T11:00:00', 3, NULL, NULL),
(6,  2, 2, '2025-11-06T11:30:00', 1, 2,    2),
(7,  3, 1, '2025-11-06T12:00:00', 0, NULL, NULL),
(8,  4, 2, '2025-11-06T12:30:00', 1, 3,    3),
(9,  1, 1, '2025-11-06T13:00:00', 2, NULL, NULL),
(10, 2, 2, '2025-11-06T13:30:00', 0, 4,    4);

SET IDENTITY_INSERT dbo.Appointments OFF;
GO

/* ======================
   Prescriptions (IDs 1..5)  -- English only
   ====================== */
SET IDENTITY_INSERT dbo.Prescriptions ON;

INSERT INTO dbo.Prescriptions
(PrescriptionID, MedicalRecordID, MedicationName, Dosage, Frequency, StartDate, EndDate, SpecialInstructions)
VALUES
(1, 1, N'Paracetamol',  N'500 mg',  N'Twice daily after meals',                 '2025-01-10', '2025-01-17', N'Do not exceed the prescribed dose'),
(2, 2, N'Amoxicillin',  N'250 mg',  N'Three times daily',                       '2025-02-01', '2025-02-10', N'Shake well before use'),
(3, 3, N'Ibuprofen',    N'400 mg',  N'As needed (maximum 3 times daily)',       '2025-03-05', '2025-03-12', N'Take after food only'),
(4, 1, N'Vitamin D',    N'1000 IU', N'Once daily',                              '2025-01-15', '2025-02-15', N'Sun exposure is beneficial'),
(5, 4, N'Metformin',    N'850 mg',  N'Twice daily',                             '2025-03-01', '2025-06-01', N'Drink plenty of water');

SET IDENTITY_INSERT dbo.Prescriptions OFF;
GO