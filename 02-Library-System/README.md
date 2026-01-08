# 02 — Library Management System (Simple)

This project is part of a personal learning repository for **relational database design**.

It models a simple library with:
- Books (with multiple authors)
- Multiple copies per book + availability tracking
- Users with library card numbers
- Borrowing/return records (loans)
- Reservations (holds) with queue order
- Fines with paid/unpaid status

## Folder Structure
- `ERD/` — the ERD image
- `Database/`
  - `Create_Tables.sql` — schema (tables, keys, constraints)
  - `Insert_Sample_Data.sql` — optional sample rows to test queries
- `Description.md` — quick notes and assumptions

## How to Run (SQL Server)
1. (Optional) create a database:
   ```sql
   CREATE DATABASE SimpleLibraryDB;
   GO
   USE SimpleLibraryDB;
   GO
   ```
2. Run:
   - `Database/Create_Tables.sql`
   - `Database/Insert_Sample_Data.sql` (optional)

## Notes / Assumptions (Simple Version)
- Fines are modeled as **one fine per loan** (simple and easy for learning).
- Reservations are tracked **per book** (not per copy) with `QueuePosition`.
- Copy availability is stored in `BookCopies.IsAvailable` for quick checks.
