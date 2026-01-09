
# 02 — Library Management System

This project is part of a personal learning repository for **relational database design**.

It models a simple library system with:
- Users with library card numbers
- Books and their physical copies
- Borrowing and returning records
- Reservations
- Fines for late returns
- System settings for borrow rules and fine calculation

---

## 📁 Folder Structure
- `ERD/` — the ERD image
- `Database/`
  - `Create_Tables.sql` — schema (tables, keys, constraints)
  - `Insert_Sample_Data.sql` — sample data based on the actual dataset
  - `Queries_Test.sql` — practice and verification queries
  - `README.md` — how to run the database scripts
- `Description.md` — design notes and assumptions

---

## ▶ How to Run (SQL Server)

1. **Create a database (optional)**
   ```sql
   CREATE DATABASE SimpleLibraryDB;
   GO
   USE SimpleLibraryDB;
   GO
````

2. **Create tables**

   * Run: `Database/Create_Tables.sql`

3. **Insert sample data**

   * Run: `Database/Insert_Sample_Data.sql`

4. **Test and practice**

   * Run: `Database/Queries_Test.sql`

---

## 🧠 Notes / Assumptions

* Each book can have multiple copies.
* Fines are stored per borrowing record.
* System rules (borrow days and fine per day) are stored in the `Settings` table and used in queries for calculations.
* This project is designed for learning and SQL practice.