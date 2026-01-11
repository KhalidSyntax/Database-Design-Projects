## Overview

This project represents a simplified **Karate Club Management System** designed for learning
relational database modeling and SQL.

It focuses on managing:
- people as shared identities
- members and instructors as roles
- belt ranks and belt tests
- payments and subscriptions
- instructor assignments

A large sample dataset is included to allow realistic querying, aggregation, and reporting.

---

## Main Entities

- **Persons** — shared personal information
- **Members** — karate club members
- **Instructors** — certified trainers
- **MemberInstructors** — assignment of instructors to members
- **BeltRanks** — belt levels and test fees
- **BeltTests** — belt exams taken by members
- **Payments** — money paid by members
- **SubscriptionPeriods** — membership periods (paid or unpaid)

---

## Design Highlights

- Personal data is stored once in `Persons` and reused by both members and instructors.
- Members reference their current belt using `LastBeltRank`.
- Instructor assignments are tracked over time using `MemberInstructors`.
- Payments are recorded per member and may be linked to:
  - belt tests
  - subscription periods
- Nullable `PaymentID` fields allow unpaid or pending transactions.
- The dataset is intentionally large to simulate a real club and support meaningful SQL analysis.

This database is designed for **learning and portfolio use**, and represents a simplified structure of a real karate club system.