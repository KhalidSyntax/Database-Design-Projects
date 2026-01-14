## Overview

This project represents a simplified **Online Store** database designed for learning
relational database modeling and SQL.

It simulates how a real e-commerce system works, from browsing products, to placing orders,
to payment processing, shipping, and customer reviews.

A realistic dataset is included to allow meaningful SQL queries and reporting.

---

## Main Entities

- **Customers** — registered users who place orders  
- **ProductCategory** — product grouping (Electronics, Books, etc.)  
- **ProductCatalog** — products available for sale  
- **ProductImages** — multiple images per product  
- **Orders** — customer purchase orders  
- **OrderItems** — products inside each order  
- **Payments** — payment records for orders  
- **Shippings** — delivery tracking information  
- **Reviews** — customer feedback and ratings  

---

## Design Highlights

- Products are grouped into categories and can have multiple images.
- Orders store high-level purchase information, while `OrderItems` store line-item details.
- Payments and shipping are linked to orders to track fulfillment.
- Customers can leave reviews for products they purchased.
- Status fields are stored as text to make the data easy to read and understand.

This database is designed for **learning, practice, and portfolio demonstration**.