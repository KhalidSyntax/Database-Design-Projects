## Overview

This project represents a simplified **Car Rental System** designed for learning
relational database modeling and SQL.

It simulates how a real car rental business operates:
from booking a vehicle, to returning it, to final payment and revenue tracking.

A realistic dataset is included to allow meaningful SQL queries and reporting.

---

## Main Entities

- **Customer** – people who rent vehicles  
- **Vehicle** – cars available for rent  
- **VehicleCategories** – Economy, Sedan, SUV, etc.  
- **FuelTypes** – Petrol, Diesel, Hybrid, Electric  
- **RentalBooking** – initial rental agreement  
- **VehicleReturns** – actual return details  
- **RentalTransaction** – payments, balances, and refunds  
- **Maintenance** – service and repair records  

---

## Design Highlights

- Bookings store **initial rental estimates** (days and price).  
- Returns store **actual rental results** (days, mileage, extra charges).  
- Transactions link bookings to returns and handle payments.  
- Vehicles can have multiple bookings and maintenance records.  
- Availability is tracked using `Vehicle.IsAvailableForRent`.  

This database is designed for **learning, practice, and portfolio demonstration**.