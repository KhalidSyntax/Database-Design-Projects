/*
05 - Online Store (SQL Server)
Insert Sample Data (Realistic Simulation)

Run AFTER: Create_Tables.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Clean (child -> parent)
   ========================= */
DELETE FROM dbo.Reviews;
DELETE FROM dbo.ProductImages;
DELETE FROM dbo.Shippings;
DELETE FROM dbo.Payments;
DELETE FROM dbo.OrderItems;
DELETE FROM dbo.Orders;
DELETE FROM dbo.ProductCatalog;
DELETE FROM dbo.ProductCategory;
DELETE FROM dbo.Customers;
GO

/* Reseed identity tables */
DBCC CHECKIDENT ('dbo.Reviews', RESEED, 0);
DBCC CHECKIDENT ('dbo.ProductImages', RESEED, 0);
DBCC CHECKIDENT ('dbo.Shippings', RESEED, 0);
DBCC CHECKIDENT ('dbo.Payments', RESEED, 0);
DBCC CHECKIDENT ('dbo.OrderItems', RESEED, 0);
DBCC CHECKIDENT ('dbo.Orders', RESEED, 0);
DBCC CHECKIDENT ('dbo.ProductCatalog', RESEED, 0);
DBCC CHECKIDENT ('dbo.ProductCategory', RESEED, 0);
DBCC CHECKIDENT ('dbo.Customers', RESEED, 0);
GO

/* =========================
   1) ProductCategory
   ========================= */
INSERT INTO dbo.ProductCategory (CategoryName)
VALUES
(N'Electronics'),
(N'Home & Kitchen'),
(N'Books'),
(N'Beauty & Care'),
(N'Sports'),
(N'Office Supplies');
GO

/* =========================
   2) ProductCatalog
   (Includes ImageURL nullable)
   ========================= */
INSERT INTO dbo.ProductCatalog
(ProductName, [Description], Price, QuantityInStock, ImageURL, CategoryID)
VALUES
(N'Logitech MX Master 3S Wireless Mouse',
 N'Ergonomic wireless mouse with quiet clicks and fast scrolling.',
 349.00, 55, N'https://example.com/img/mxmaster3s-main.jpg', 1),

(N'Anker 65W USB-C Charger',
 N'Fast charger with USB-C Power Delivery for laptops and phones.',
 179.00, 80, N'https://example.com/img/anker65w-main.jpg', 1),

(N'Samsung T7 Portable SSD 1TB',
 N'High-speed external SSD with USB-C and encryption support.',
 399.00, 40, N'https://example.com/img/samsungt7-main.jpg', 1),

(N'Philips Air Fryer 4.1L',
 N'Air fryer for healthier frying with less oil.',
 499.00, 25, N'https://example.com/img/airfryer-main.jpg', 2),

(N'Tefal Non-Stick Pan 28cm',
 N'Durable non-stick pan for everyday cooking.',
 139.00, 60, N'https://example.com/img/tefalpan-main.jpg', 2),

(N'Atomic Habits (Arabic Edition)',
 N'Practical guide for building good habits (Arabic).',
 49.00, 120, N'https://example.com/img/atomichabits-ar-main.jpg', 3),

(N'Clean Code',
 N'A Handbook of Agile Software Craftsmanship.',
 129.00, 35, N'https://example.com/img/cleancode-main.jpg', 3),

(N'CeraVe Hydrating Cleanser 236ml',
 N'Gentle cleanser for normal to dry skin.',
 89.00, 70, N'https://example.com/img/cerave-main.jpg', 4),

(N'La Roche-Posay Anthelios SPF50+',
 N'High protection sunscreen for daily use.',
 119.00, 45, N'https://example.com/img/anthelios-main.jpg', 4),

(N'Adidas Training Mat',
 N'Non-slip mat for home workouts and stretching.',
 99.00, 50, N'https://example.com/img/trainingmat-main.jpg', 5),

(N'Dumbbell Set 2x5kg',
 N'Pair of dumbbells for strength training.',
 179.00, 30, N'https://example.com/img/dumbbells-main.jpg', 5),

(N'A4 Copy Paper 500 sheets',
 N'Office copy paper, 80gsm.',
 22.00, 200, N'https://example.com/img/a4paper-main.jpg', 6);
GO

/* =========================
   3) ProductImages
   (Multiple images per product)
   ========================= */
INSERT INTO dbo.ProductImages (ImageURL, ImageOrder, ProductID)
VALUES
(N'https://example.com/img/mxmaster3s-1.jpg', 1, 1),
(N'https://example.com/img/mxmaster3s-2.jpg', 2, 1),

(N'https://example.com/img/anker65w-1.jpg', 1, 2),

(N'https://example.com/img/samsungt7-1.jpg', 1, 3),
(N'https://example.com/img/samsungt7-2.jpg', 2, 3),

(N'https://example.com/img/airfryer-1.jpg', 1, 4),
(N'https://example.com/img/airfryer-2.jpg', 2, 4),

(N'https://example.com/img/tefalpan-1.jpg', 1, 5),

(N'https://example.com/img/atomichabits-ar-1.jpg', 1, 6),

(N'https://example.com/img/cleancode-1.jpg', 1, 7),

(N'https://example.com/img/cerave-1.jpg', 1, 8),

(N'https://example.com/img/anthelios-1.jpg', 1, 9),

(N'https://example.com/img/trainingmat-1.jpg', 1, 10),

(N'https://example.com/img/dumbbells-1.jpg', 1, 11),

(N'https://example.com/img/a4paper-1.jpg', 1, 12);
GO

/* =========================
   4) Customers (Realistic)
   ========================= */
INSERT INTO dbo.Customers
([Name], Email, Phone, [Address], Username, [Password])
VALUES
(N'Khaled Al-Amri',    N'khaled.amri@example.com',    N'0551231234', N'Jazan, Saudi Arabia',    N'khaled_amri',    N'Pass@123'),
(N'Aisha Al-Noor',     N'aisha.noor@example.com',     N'0501234567', N'Riyadh, Saudi Arabia',   N'aisha_noor',     N'Pass@123'),
(N'Omar Saleh',        N'omar.saleh@example.com',     N'0569876543', N'Dammam, Saudi Arabia',   N'omar_saleh',     N'Pass@123'),
(N'Sara Khaled',       N'sara.khaled@example.com',    N'0531122334', N'Jeddah, Saudi Arabia',   N'sara_khaled',    N'Pass@123'),
(N'Fahad Al-Otaibi',   N'fahad.ot@example.com',       N'0552200119', N'Riyadh, Saudi Arabia',   N'fahad_ot',       N'Pass@123'),
(N'Noura Al-Harbi',    N'noura.harbi@example.com',    N'0507788991', N'Madinah, Saudi Arabia',  N'noura_harbi',    N'Pass@123'),
(N'Abdullah Nasser',   N'abdullah.n@example.com',     N'0544445566', N'Abha, Saudi Arabia',     N'abdullah_n',     N'Pass@123'),
(N'Layla Saeed',       N'layla.saeed@example.com',    N'0551112233', N'Jeddah, Saudi Arabia',   N'layla_saeed',    N'Pass@123'),
(N'Yousef Al-Zahrani', N'yousef.z@example.com',       N'0556677889', N'Taif, Saudi Arabia',     N'yousef_z',       N'Pass@123'),
(N'Reem Al-Shehri',    N'reem.shehri@example.com',    N'0509090909', N'Riyadh, Saudi Arabia',   N'reem_shehri',    N'Pass@123'),
(N'Ahmed Al-Salem',    N'ahmed.salem@example.com',    N'0533332211', N'Dammam, Saudi Arabia',   N'ahmed_salem',    N'Pass@123'),
(N'Maha Al-Qahtani',   N'maha.q@example.com',         N'0591010101', N'Riyadh, Saudi Arabia',   N'maha_q',         N'Pass@123');
GO

/* =========================
   5) Orders
   Status (string):
   'Pending', 'Paid', 'Shipped', 'Delivered', 'Canceled'
   ========================= */
INSERT INTO dbo.Orders (CustomerID, OrderDate, TotalAmount, [Status])
VALUES
(1,  '2025-10-02 10:15:00', 0, N'Paid'),
(2,  '2025-10-05 18:20:00', 0, N'Shipped'),
(3,  '2025-10-06 12:05:00', 0, N'Pending'),
(4,  '2025-10-10 09:40:00', 0, N'Delivered'),
(5,  '2025-10-12 20:10:00', 0, N'Paid'),
(6,  '2025-10-15 14:30:00', 0, N'Shipped'),
(7,  '2025-10-18 11:00:00', 0, N'Paid'),
(8,  '2025-10-21 16:45:00', 0, N'Pending'),
(9,  '2025-10-25 19:25:00', 0, N'Delivered'),
(10, '2025-10-28 08:50:00', 0, N'Shipped'),
(11, '2025-11-01 21:05:00', 0, N'Paid'),
(12, '2025-11-03 13:10:00', 0, N'Paid');
GO

/* =========================
   6) OrderItems
   - UnitPrice from ProductCatalog.Price
   - TotalItemsPrice can be NULL (but we will fill it)
   ========================= */
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice, TotalItemsPrice)
VALUES
(1,  1, 1, 349.00, NULL),
(1, 12, 2, 22.00,  NULL),

(2,  4, 1, 499.00, NULL),
(2,  5, 1, 139.00, NULL),

(3,  2, 1, 179.00, NULL),
(3,  6, 1, 49.00,  NULL),

(4,  3, 1, 399.00, NULL),
(4, 10, 1, 99.00,  NULL),

(5,  8, 2, 89.00,  NULL),
(5,  9, 1, 119.00, NULL),

(6, 11, 1, 179.00, NULL),
(6, 10, 1, 99.00,  NULL),

(7,  7, 1, 129.00, NULL),
(7, 12, 5, 22.00,  NULL),

(8,  1, 1, 349.00, NULL),

(9,  4, 1, 499.00, NULL),
(9,  2, 1, 179.00, NULL),

(10, 6, 2, 49.00,  NULL),
(10,12, 3, 22.00,  NULL),

(11, 3, 1, 399.00, NULL),
(11, 2, 1, 179.00, NULL),

(12, 5, 2, 139.00, NULL);
GO

/* Fill TotalItemsPrice */
UPDATE dbo.OrderItems
SET TotalItemsPrice = Quantity * UnitPrice
WHERE TotalItemsPrice IS NULL;
GO

/* Update Orders.TotalAmount */
UPDATE o
SET o.TotalAmount = x.SumItems
FROM dbo.Orders o
JOIN (
    SELECT OrderID, SUM(TotalItemsPrice) AS SumItems
    FROM dbo.OrderItems
    GROUP BY OrderID
) x ON x.OrderID = o.OrderID;
GO

/* =========================
   7) Payments (for Paid/Shipped/Delivered)
   ========================= */
INSERT INTO dbo.Payments (OrderID, Amount, PaymentMethod, TransactionDate)
SELECT
    o.OrderID,
    o.TotalAmount,
    CASE (o.OrderID % 3)
        WHEN 0 THEN N'Card'
        WHEN 1 THEN N'Transfer'
        ELSE N'Cash'
    END,
    DATEADD(MINUTE, 20, o.OrderDate)
FROM dbo.Orders o
WHERE o.[Status] IN (N'Paid', N'Shipped', N'Delivered');
GO

/* =========================
   8) Shippings (for Paid/Shipped/Delivered)
   ShippingStatus (string):
   'Preparing', 'Shipped', 'Delivered'
   ========================= */
INSERT INTO dbo.Shippings
(OrderID, CarrierName, TrackingNumber, ShippingStatus, EstimatedDeliveryDate, ActualDeliveryDate)
SELECT
    o.OrderID,
    CASE (o.OrderID % 3)
        WHEN 0 THEN N'SMSA'
        WHEN 1 THEN N'Aramex'
        ELSE N'SPL'
    END,
    CONCAT(N'TRK-', RIGHT(CONCAT('000000', 510000 + o.OrderID), 6)),
    CASE
        WHEN o.[Status] = N'Paid'      THEN N'Preparing'
        WHEN o.[Status] = N'Shipped'   THEN N'Shipped'
        WHEN o.[Status] = N'Delivered' THEN N'Delivered'
        ELSE N'Preparing'
    END,
    DATEADD(DAY, 3, o.OrderDate),
    CASE WHEN o.[Status] = N'Delivered' THEN DATEADD(DAY, 3, o.OrderDate) ELSE NULL END
FROM dbo.Orders o
WHERE o.[Status] IN (N'Paid', N'Shipped', N'Delivered');
GO

/* =========================
   9) Reviews
   ProductID & CustomerID NOT NULL
   ReviewText can be NULL
   Rating DECIMAL(2,1)
   ========================= */
INSERT INTO dbo.Reviews (ProductID, CustomerID, ReviewText, Rating, ReviewDate)
VALUES
(1,  1, N'Comfortable and very precise. Great for work.', 5.0, '2025-10-12 12:00:00'),
(2,  2, N'Fast charging and compact. Highly recommended.', 5.0, '2025-10-20 09:30:00'),
(3,  4, N'Excellent speed and reliable storage.', 5.0, '2025-10-18 19:15:00'),
(4,  9, N'Cooks evenly and easy to clean.', 4.5, '2025-10-29 15:10:00'),
(6,  1, N'Practical book, easy to apply daily.', 5.0, '2025-10-25 08:40:00'),
(7,  7, N'Must-read for developers.', 5.0, '2025-10-30 22:00:00'),
(8,  5, N'Gentle and effective for sensitive skin.', 4.5, '2025-11-02 10:05:00'),
(10, 6, NULL, 4.0, '2025-11-01 16:00:00'); -- example of NULL ReviewText
GO

/* =========================
   10) Optional: reduce stock based on sold quantity
   (simple simulation)
   ========================= */
UPDATE p
SET p.QuantityInStock = p.QuantityInStock - x.SoldQty
FROM dbo.ProductCatalog p
JOIN (
    SELECT ProductID, SUM(Quantity) AS SoldQty
    FROM dbo.OrderItems
    GROUP BY ProductID
) x ON x.ProductID = p.ProductID;
GO