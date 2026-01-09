## Simple Clinic System

This database represents a simple clinic used to practice
relational database design and SQL.

The system is designed to manage:
- Patients and doctors as different roles of the same `Persons` entity
- Appointments between patients and doctors
- Medical records created from appointments
- Prescriptions linked to medical records
- Payments linked to appointments

The design uses:
- 1:1 relationships between Persons ↔ Patients and Persons ↔ Doctors
- 1:N relationships between Patients ↔ Appointments and Doctors ↔ Appointments
- 1:N relationships between MedicalRecords ↔ Prescriptions

This project is meant for learning and practice, not production use.