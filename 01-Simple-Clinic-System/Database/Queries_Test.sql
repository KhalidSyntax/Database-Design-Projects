/*
01 - Simple Clinic System
Queries_Test.sql (Simple)
Run AFTER:
- Create_Tables.sql
- Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) List patients with their personal info */
SELECT
    pa.PatientID,
    pe.PersonID,
    pe.[Name],
    pe.Gender,
    pe.PhoneNumber,
    pe.Email,
    pe.[Address]
FROM dbo.Patients pa
JOIN dbo.Persons pe ON pe.PersonID = pa.PersonID
ORDER BY pa.PatientID;
GO

/* 2) List doctors with their personal info */
SELECT
    d.DoctorID,
    pe.PersonID,
    pe.[Name] AS DoctorName,
    d.Specialization,
    pe.PhoneNumber
FROM dbo.Doctors d
JOIN dbo.Persons pe ON pe.PersonID = d.PersonID
ORDER BY d.DoctorID;
GO

/* 3) Show appointments with patient + doctor names */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    a.AppointmentStatus,
    pat.[Name] AS PatientName,
    doc.[Name] AS DoctorName
FROM dbo.Appointments a
JOIN dbo.Patients p  ON p.PatientID = a.PatientID
JOIN dbo.Persons pat ON pat.PersonID = p.PersonID
JOIN dbo.Doctors d   ON d.DoctorID = a.DoctorID
JOIN dbo.Persons doc ON doc.PersonID = d.PersonID
ORDER BY a.AppointmentDateTime;
GO

/* 4) Appointments count per doctor */
SELECT
    doc.[Name] AS DoctorName,
    COUNT(*) AS AppointmentsCount
FROM dbo.Appointments a
JOIN dbo.Doctors d   ON d.DoctorID = a.DoctorID
JOIN dbo.Persons doc ON doc.PersonID = d.PersonID
GROUP BY doc.[Name]
ORDER BY AppointmentsCount DESC;
GO

/* 5) Show appointments that have no payment yet */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    pat.[Name] AS PatientName,
    doc.[Name] AS DoctorName
FROM dbo.Appointments a
JOIN dbo.Patients p  ON p.PatientID = a.PatientID
JOIN dbo.Persons pat ON pat.PersonID = p.PersonID
JOIN dbo.Doctors d   ON d.DoctorID = a.DoctorID
JOIN dbo.Persons doc ON doc.PersonID = d.PersonID
WHERE a.PaymentID IS NULL
ORDER BY a.AppointmentDateTime;
GO

/* 6) Show appointments that have no medical record yet */
SELECT
    a.AppointmentID,
    a.AppointmentDateTime,
    pat.[Name] AS PatientName,
    doc.[Name] AS DoctorName
FROM dbo.Appointments a
JOIN dbo.Patients p  ON p.PatientID = a.PatientID
JOIN dbo.Persons pat ON pat.PersonID = p.PersonID
JOIN dbo.Doctors d   ON d.DoctorID = a.DoctorID
JOIN dbo.Persons doc ON doc.PersonID = d.PersonID
WHERE a.MedicalRecordID IS NULL
ORDER BY a.AppointmentDateTime;
GO

/* 7) Total paid amount per patient (based on payments linked to appointments) */
SELECT
    pat.[Name] AS PatientName,
    SUM(pay.AmountPaid) AS TotalPaid
FROM dbo.Appointments a
JOIN dbo.Patients p  ON p.PatientID = a.PatientID
JOIN dbo.Persons pat ON pat.PersonID = p.PersonID
JOIN dbo.Payments pay ON pay.PaymentID = a.PaymentID
GROUP BY pat.[Name]
ORDER BY TotalPaid DESC;
GO

/* 8) Medical records with prescriptions count */
SELECT
    mr.MedicalRecordID,
    mr.Diagnosis,
    COUNT(pr.PrescriptionID) AS PrescriptionsCount
FROM dbo.MedicalRecords mr
LEFT JOIN dbo.Prescriptions pr ON pr.MedicalRecordID = mr.MedicalRecordID
GROUP BY mr.MedicalRecordID, mr.Diagnosis
ORDER BY PrescriptionsCount DESC;
GO

/* 9) Show prescriptions (sample) */
SELECT TOP (50)
    pr.PrescriptionID,
    pr.MedicalRecordID,
    pr.MedicationName,
    pr.Dosage,
    pr.Frequency,
    pr.StartDate,
    pr.EndDate
FROM dbo.Prescriptions pr
ORDER BY pr.PrescriptionID;
GO

/* 10) Count appointments by status */
SELECT
    a.AppointmentStatus,
    COUNT(*) AS CountByStatus
FROM dbo.Appointments a
GROUP BY a.AppointmentStatus
ORDER BY a.AppointmentStatus;
GO