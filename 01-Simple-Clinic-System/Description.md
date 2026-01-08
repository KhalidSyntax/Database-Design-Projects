## Overview
A simplified clinic database to practice:
- translating requirements into entities/relationships
- applying primary keys, foreign keys, and constraints
- writing sample SQL queries on a realistic schema

## Entities
- **Persons**: shared personal information (name, DOB, gender, contact).
- **Patients**: clinic patients (linked 1:1 to Persons).
- **Doctors**: clinic doctors (linked 1:1 to Persons) + specialization.
- **Appointments**: link patient ↔ doctor with date/time/status.
- **MedicalRecords**: visit description, diagnosis, notes.
- **Prescriptions**: medication details linked to a medical record.
- **Payments**: payment details (per appointment in this version).

## Requirements Source
The requirements and ERD were taken from the provided course material (Project 1: Simple Clinic). 
