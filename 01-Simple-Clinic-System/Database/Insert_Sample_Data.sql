/*
01 - Simple Clinic System
Sample Data Script (optional)
Run AFTER Create_Tables.sql
*/

-- Persons (Patients + Doctors)
INSERT INTO dbo.Persons ([Name], DateOfBirth, Gender, PhoneNumber, Email, [Address]) VALUES
(N'Ahmed Ali',  '1998-03-12', N'Male',   N'0500000001', N'ahmed@example.com',  N'Jazan'),
(N'Sara Omar',  '2001-11-05', N'Female', N'0500000002', N'sara@example.com',   N'Riyadh'),
(N'Dr. Khalid', '1985-02-20', N'Male',   N'0500000100', N'khalid.doc@example.com', N'Riyadh'),
(N'Dr. Mona',   '1990-07-08', N'Female', N'0500000101', N'mona.doc@example.com',   N'Jeddah');

-- Patients
INSERT INTO dbo.Patients (PersonID)
SELECT PersonID FROM dbo.Persons WHERE [Name] IN (N'Ahmed Ali', N'Sara Omar');

-- Doctors
INSERT INTO dbo.Doctors (PersonID, Specialization)
SELECT PersonID, N'General' FROM dbo.Persons WHERE [Name] = N'Dr. Khalid';
INSERT INTO dbo.Doctors (PersonID, Specialization)
SELECT PersonID, N'Dermatology' FROM dbo.Persons WHERE [Name] = N'Dr. Mona';

-- Payments
INSERT INTO dbo.Payments (PaymentDate, PaymentMethod, AmountPaid, AdditionalNotes) VALUES
('2026-01-01', N'Cash', 150.00, N'Initial visit'),
('2026-01-02', N'Card', 200.00, N'Follow-up');

-- Medical Records
INSERT INTO dbo.MedicalRecords (VisitDescription, Diagnosis, AdditionalNotes) VALUES
(N'General checkup', N'Normal', N'No issues'),
(N'Skin rash evaluation', N'Allergic dermatitis', N'Prescribed topical cream');

-- Appointments
DECLARE @AhmedPatientID INT = (SELECT p.PatientID FROM dbo.Patients p
                               JOIN dbo.Persons pe ON pe.PersonID=p.PersonID
                               WHERE pe.[Name]=N'Ahmed Ali');

DECLARE @SaraPatientID INT = (SELECT p.PatientID FROM dbo.Patients p
                              JOIN dbo.Persons pe ON pe.PersonID=p.PersonID
                              WHERE pe.[Name]=N'Sara Omar');

DECLARE @DrKhalidID INT = (SELECT d.DoctorID FROM dbo.Doctors d
                           JOIN dbo.Persons pe ON pe.PersonID=d.PersonID
                           WHERE pe.[Name]=N'Dr. Khalid');

DECLARE @DrMonaID INT = (SELECT d.DoctorID FROM dbo.Doctors d
                         JOIN dbo.Persons pe ON pe.PersonID=d.PersonID
                         WHERE pe.[Name]=N'Dr. Mona');

INSERT INTO dbo.Appointments
(PatientID, DoctorID, AppointmentDate, AppointmentTime, AppointmentStatus, MedicalRecordID, PaymentID)
VALUES
(@AhmedPatientID, @DrKhalidID, '2026-01-01', '10:00', 3, 1, 1),
(@SaraPatientID,  @DrMonaID,   '2026-01-02', '12:30', 2, 2, 2);

-- Prescriptions (linked to MedicalRecordID=2)
INSERT INTO dbo.Prescriptions
(MedicalRecordID, MedicationName, Dosage, Frequency, StartDate, EndDate, SpecialInstructions)
VALUES
(2, N'Topical Cream', N'Apply thin layer', N'Twice daily', '2026-01-02', '2026-01-09', N'Avoid sunlight if irritation occurs');
