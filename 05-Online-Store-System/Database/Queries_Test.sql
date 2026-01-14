/*
05 - Online Store
10 Simple Practice Queries (SQL Server)

Run AFTER:
- Database/Create_Tables.sql
- Database/Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) List all categories */
SELECT
    CategoryID,
    CategoryName
FROM dbo.ProductCategory
ORDER BY CategoryName;
GO

/* 2) List all products with category name */
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Price,
    p.QuantityInStock
FROM dbo.ProductCatalog p
JOIN dbo.ProductCategory c ON c.CategoryID = p.CategoryID
ORDER BY c.CategoryName, p.ProductName;
GO

/* 3) Show products that are low in stock (<= 20) */
SELECT
    ProductID,
    ProductName,
    QuantityInStock
FROM dbo.ProductCatalog
WHERE QuantityInStock <= 20
ORDER BY QuantityInStock ASC, ProductName;
GO

/* 4) Show product images (top 2 images per product) */
SELECT
    p.ProductName,
    i.ImageOrder,
    i.ImageURL
FROM dbo.ProductCatalog p
JOIN dbo.ProductImages i ON i.ProductID = p.ProductID
WHERE i.ImageOrder <= 2
ORDER BY p.ProductName, i.ImageOrder;
GO

/* 5) List customers (basic contact info) */
SELECT
    CustomerID,
    [Name],
    Email,
    Phone,
    [Address]
FROM dbo.Customers
ORDER BY [Name];
GO

/* 6) Show orders with customer name and status */
SELECT
    o.OrderID,
    c.[Name] AS CustomerName,
    o.OrderDate,
    o.TotalAmount,
    o.[Status]
FROM dbo.Orders o
JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;
GO

/* 7) Show order details: items per order */
SELECT
    oi.OrderID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    oi.TotalItemsPrice
FROM dbo.OrderItems oi
JOIN dbo.ProductCatalog p ON p.ProductID = oi.ProductID
ORDER BY oi.OrderID, p.ProductName;
GO

/* 8) Total amount per customer (sum of all orders) */
SELECT
    c.CustomerID,
    c.[Name] AS CustomerName,
    SUM(o.TotalAmount) AS TotalSpent
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.[Name]
ORDER BY TotalSpent DESC;
GO

/* 9) Show paid orders with payment info */
SELECT
    o.OrderID,
    o.[Status],
    p.Amount,
    p.PaymentMethod,
    p.TransactionDate
FROM dbo.Orders o
JOIN dbo.Payments p ON p.OrderID = o.OrderID
WHERE o.[Status] IN (N'Paid', N'Shipped', N'Delivered')
ORDER BY p.TransactionDate DESC;
GO

/* 10) Average rating per product (only products with reviews) */
SELECT
    pr.ProductID,
    pr.ProductName,
    AVG(r.Rating) AS AvgRating,
    COUNT(*) AS ReviewsCount
FROM dbo.ProductCatalog pr
JOIN dbo.Reviews r ON r.ProductID = pr.ProductID
GROUP BY pr.ProductID, pr.ProductName
ORDER BY AvgRating DESC, ReviewsCount DESC, pr.ProductName;
GO