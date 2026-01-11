# 03 — Karate Club System (Database Design)

This project is part of a personal learning repository for **relational database design**.

It models a simple **karate club management system** with:
- Members and instructors
- Shared personal information (`Persons`)
- Belt ranks and belt tests
- Payments
- Subscription periods
- Instructor assignments

A large sample dataset is included to allow realistic SQL practice and reporting.

---

## 📁 Folder Structure

- `ERD/` — the ERD image  
- `Database/`
  - `Create_Tables.sql` — database schema (tables, keys, constraints)
  - `Insert_Sample_Data.sql` — large realistic sample dataset
  - `Queries_Test.sql` — simple practice and verification queries
  - `README.md` — how to run the database scripts
- `Description.md` — design notes and assumptions

---

## ▶ How to Run (SQL Server)

1. **Create a database (optional)**
   ```sql
   CREATE DATABASE KarateClubDB;
   GO
   USE KarateClubDB;
   GO
````

2. **Create tables**
   Run:

   ```
   Database/Create_Tables.sql
   ```

3. **Insert sample data**
   Run:

   ```
   Database/Insert_Sample_Data.sql
   ```

4. **Run test queries**
   Run:

   ```
   Database/Queries_Test.sql
   ```

---

## 🧠 Notes

* `Persons` stores shared identity data for both members and instructors.
* Members reference their current belt using `LastBeltRank`.
* Payments can be linked to:

  * `SubscriptionPeriods`
  * `BeltTests`
* Some subscriptions and tests may not have payments yet (`PaymentID` is nullable).
* The dataset is intentionally large to support meaningful SQL practice.

---

This project is designed for **learning and portfolio demonstration**.

````
