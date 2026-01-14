# **05 — Online Store Database (SQL Server)**

This project is part of a personal learning repository for **relational database design and SQL practice**.

It models a simple **online store** including:

* Products and categories
* Customers
* Orders and order items
* Payments
* Shipping tracking
* Product images
* Customer reviews

The goal is to practice:

* One-to-many and many-to-many relationships
* E-commerce transaction modeling
* Querying real-world scenarios using SQL

---

## **Folder Structure**

```
05-Online-Store/
│
├── ERD/
│   └── OnlineStore_ERD.png
│
├── Database/
│   ├── Create_Tables.sql
│   └── Insert_Sample_Data.sql
│   └── Queries_Test.sql
│
└── Description.md
```

---

## **How to Run (SQL Server)**

1. (Optional) Create the database:

```sql
CREATE DATABASE OnlineStoreDB;
GO
USE OnlineStoreDB;
GO
```

2. Run the scripts in this order:

```
Database/Create_Tables.sql
Database/Insert_Sample_Data.sql
Queries/Queries_Test.sql
```

---

## **Main Tables**

| Table           | Description                               |
| --------------- | ----------------------------------------- |
| Customers       | Stores customer accounts and contact info |
| ProductCategory | Product categories                        |
| ProductCatalog  | Products for sale                         |
| ProductImages   | Multiple images per product               |
| Orders          | Customer orders                           |
| OrderItems      | Products inside each order                |
| Payments        | Payments per order                        |
| Shippings       | Shipping and delivery tracking            |
| Reviews         | Customer product reviews                  |

---

## **Order Status Examples**

* Pending
* Paid
* Shipped
* Delivered
* Cancelled

---

## **Shipping Status Examples**

* Processing
* In Transit
* Out for Delivery
* Delivered

---

## **Notes & Assumptions**

* Each order belongs to **one customer**
* Each order has **one payment**
* Each order may have **one shipping record**
* Each product belongs to **one category**
* A product can have **multiple images and reviews**
* Reviews must be linked to **both a customer and a product**

---

## **Purpose**

This project simulates a **realistic online store database** to practice:

* Writing joins
* Aggregations
* Filtering by business rules
* Testing real-world e-commerce scenarios

---