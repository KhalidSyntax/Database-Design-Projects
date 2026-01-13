# **04 — Car Rental System (Database Design)**

This project is part of a personal learning repository for **relational database design**.

It models a **real-world car rental business**, including:

* Customers and their bookings
* Vehicles with categories, fuel types, and availability
* Rental transactions and returns
* Maintenance history
* Pricing, mileage, and charges

The goal is to practice designing **normalized relational schemas** and running **realistic queries** on meaningful data.

---

## **Folder Structure**

```
04-Car-Rental/
│
├── ERD/
│   └── CarRental_ERD.png
│
├── Database/
│   ├── Create_Tables.sql
│   ├── Insert_Sample_Data.sql
│   └── Queries_Test.sql
│
└── Description.md
```

---

## **How to Run (SQL Server)**

1. (Optional) Create a database:

```sql
CREATE DATABASE CarRentalDB;
GO
USE CarRentalDB;
GO
```

2. Run the scripts in this order:

* `Database/Create_Tables.sql`
* `Database/Insert_Sample_Data.sql`
* `Database/Queries_Test.sql`

---

## **Main Entities**

* **Customer** – stores renter information
* **Vehicle** – cars available for rent
* **VehicleCategories** – SUV, Sedan, etc.
* **FuelTypes** – Petrol, Diesel, Hybrid, Electric
* **RentalBooking** – rental requests
* **RentalTransaction** – payments and balances
* **VehicleReturns** – actual return data
* **Maintenance** – service and repair records

---

## **What You Can Practice**

Using this database, you can practice:

* Joins across multiple related tables
* Tracking availability of cars
* Calculating rental revenue
* Finding late returns and extra charges
* Summarizing maintenance costs
* Customer rental history

---

## **Design Notes**

* A **Customer** can have many **Bookings**
* A **Vehicle** can have many **Bookings** and **Maintenance** records
* Each **Booking** produces one **Transaction**
* A **Transaction** may have a **Return** record
* Vehicle availability is stored directly in `Vehicle.IsAvailableForRent`

---