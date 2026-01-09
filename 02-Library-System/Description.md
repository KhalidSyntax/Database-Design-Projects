## Overview

This project represents a simple **Library Management System** designed for learning and practicing
relational database modeling and SQL.

It focuses on:
- managing users with library cards
- tracking books and their physical copies
- recording borrowing and returning activity
- handling reservations
- calculating and storing fines
- using system-wide settings for business rules

---

## Main Entities

- **Users**
- **Books**
- **BookCopies**
- **BorrowingRecords**
- **Reservations**
- **Fines**
- **Settings**

---

## Design Highlights

- Each book can have multiple physical copies (`BookCopies`).
- Each copy can be borrowed or reserved.
- Borrowing activity is tracked in `BorrowingRecords`.
- Late returns generate fines stored in the `Fines` table.
- System rules (borrow days and fine per day) are stored in the `Settings` table, making the system configurable without changing code.

This project is for learning purposes and represents a simplified version of a real library system.