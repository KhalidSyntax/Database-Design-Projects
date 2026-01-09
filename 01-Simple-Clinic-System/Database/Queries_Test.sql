/*
01 - Simple Clinic System
Queries_Test.sql
Run AFTER:
- Create_Tables.sql
- Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) Show all persons */
SELECT *
FROM dbo.Persons
ORDER BY PersonID;
GO

/* 2) List patients with their personal info */
SELECT
    p.PatientID,
    pe.PersonID,
    pe.[Name],
    pe.Gender,
    pe.DateOfBirth,
    pe.PhoneNumber,
    pe.Email,
    pe.[Address]
FROM dbo.Patients p
JOIN dbo.Persons pe ON pe.PersonID = p.PersonID
ORDER BY p.PatientID;
GO

/* 3) List doctors with their personal info */
SELECT
    d.DoctorID,
    pe.PersonID,
    pe.[Name] AS DoctorName,
    d.Specialization,
    pe.PhoneNumber,
    pe.Email
FROM dbo.Doctors d
JOIN dbo.Persons pe ON pe.PersonID = d.PersonID
ORDER BY d.DoctorID;
GO

/* 4) Appointments details (patient name + doctor name) */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    a.AppointmentStatus,
    pat.PatientID,
    patPe.[Name] AS PatientName,
    doc.DoctorID,
    docPe.[Name] AS DoctorName,
    doc.Specialization,
    a.MedicalRecordID,
    a.PaymentID
FROM dbo.Appointments a
JOIN dbo.Patients pat ON pat.PatientID = a.PatientID
JOIN dbo.Persons  patPe ON patPe.PersonID = pat.PersonID
JOIN dbo.Doctors  doc ON doc.DoctorID = a.DoctorID
JOIN dbo.Persons  docPe ON docPe.PersonID = doc.PersonID
ORDER BY a.AppointmentDateTime;
GO

/* 5) Appointments for a specific day (example: 2025-11-06) */
DECLARE @Day DATE = '2025-11-06';

SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    a.AppointmentStatus,
    patPe.[Name] AS PatientName,
    docPe.[Name] AS DoctorName
FROM dbo.Appointments a
JOIN dbo.Patients pat ON pat.PatientID = a.PatientID
JOIN dbo.Persons  patPe ON patPe.PersonID = pat.PersonID
JOIN dbo.Doctors  doc ON doc.DoctorID = a.DoctorID
JOIN dbo.Persons  docPe ON docPe.PersonID = doc.PersonID
WHERE CAST(a.AppointmentDateTime AS DATE) = @Day
ORDER BY a.AppointmentDateTime;
GO

/* 6) Appointments without medical record (NULL MedicalRecordID) */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    patPe.[Name] AS PatientName,
    docPe.[Name] AS DoctorName
FROM dbo.Appointments a
JOIN dbo.Patients pat ON pat.PatientID = a.PatientID
JOIN dbo.Persons  patPe ON patPe.PersonID = pat.PersonID
JOIN dbo.Doctors  doc ON doc.DoctorID = a.DoctorID
JOIN dbo.Persons  docPe ON docPe.PersonID = doc.PersonID
WHERE a.MedicalRecordID IS NULL
ORDER BY a.AppointmentDateTime;
GO

/* 7) Appointments with payments (join Payments) */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    patPe.[Name] AS PatientName,
    pay.PaymentID,
    pay.PaymentDate,
    pay.PaymentMethod,
    pay.AmountPaid
FROM dbo.Appointments a
JOIN dbo.Patients pat ON pat.PatientID = a.PatientID
JOIN dbo.Persons  patPe ON patPe.PersonID = pat.PersonID
JOIN dbo.Payments pay ON pay.PaymentID = a.PaymentID
ORDER BY a.AppointmentDateTime;
GO

/* 8) Total paid amount per patient */
SELECT
    pat.PatientID,
    patPe.[Name] AS PatientName,
    SUM(pay.AmountPaid) AS TotalPaid
FROM dbo.Appointments a
JOIN dbo.Patients pat ON pat.PatientID = a.PatientID
JOIN dbo.Persons patPe ON patPe.PersonID = pat.PersonID
JOIN dbo.Payments pay ON pay.PaymentID = a.PaymentID
GROUP BY pat.PatientID, patPe.[Name]
ORDER BY TotalPaid DESC;
GO

/* 9) Medical records with their prescriptions */
SELECT
    mr.MedicalRecordID,
    mr.VisitDescription,
    mr.Diagnosis,
    pr.PrescriptionID,
    pr.MedicationName,
    pr.Dosage,
    pr.Frequency,
    pr.StartDate,
    pr.EndDate,
    pr.SpecialInstructions
FROM dbo.MedicalRecords mr
LEFT JOIN dbo.Prescriptions pr ON pr.MedicalRecordID = mr.MedicalRecordID
ORDER BY mr.MedicalRecordID, pr.PrescriptionID;
GO

/* 10) Count appointments per doctor */
SELECT
    d.DoctorID,
    docPe.[Name] AS DoctorName,
    COUNT(*) AS AppointmentsCount
FROM dbo.Appointments a
JOIN dbo.Doctors d ON d.DoctorID = a.DoctorID
JOIN dbo.Persons docPe ON docPe.PersonID = d.PersonID
GROUP BY d.DoctorID, docPe.[Name]
ORDER BY AppointmentsCount DESC;
GO