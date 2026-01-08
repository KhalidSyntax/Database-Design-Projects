# 01 — Simple Clinic System (Database Design)

This project is part of a personal learning repository for **relational database design**.

It models a simple clinic with:
- Patients and Doctors (as roles linked to a shared `Persons` table)
- Appointments with statuses
- Medical records created for attended appointments
- Prescriptions linked to medical records
- Payments (per appointment)

## Folder Structure
- `ERD/` — the ERD image
- `Database/`
  - `Create_Tables.sql` — schema (tables, keys, constraints)
  - `Insert_Sample_Data.sql` — optional sample rows to test queries
- `Description.md` — quick notes and assumptions

## How to Run (SQL Server)
1. Create a database (optional):
   ```sql
   CREATE DATABASE SimpleClinicDB;
   GO
   USE SimpleClinicDB;
   GO
   ```
2. Run:
   - `Database/Create_Tables.sql`
   - `Database/Insert_Sample_Data.sql` (optional)

## Appointment Status Values
1. Pending
2. Confirmed
3. Completed
4. Canceled
5. Rescheduled
6. No-Show

## Notes / Assumptions
- `Patients` and `Doctors` are separated tables that reference a shared `Persons` table (1:1) to avoid duplicated personal data.
- `Appointments` can optionally reference a `MedicalRecord` and a `Payment` (nullable foreign keys).
- You can extend the model later by adding:
  - multiple payments per appointment
  - multiple prescriptions per medical record
  - audit fields (CreatedAt / UpdatedAt)
