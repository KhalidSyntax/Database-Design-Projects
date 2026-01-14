/*
05 - Online Store
Create Tables Script (SQL Server)

How to run:
1) (Optional) Create DB:
   CREATE DATABASE OnlineStoreDB;
   GO
   USE OnlineStoreDB;
   GO
2) Run this script.
*/

SET NOCOUNT ON;
GO

/* =========================
   Drop tables (safe re-run)
   Order: child -> parent
   ========================= */
IF OBJECT_ID('dbo.Reviews','U')        IS NOT NULL DROP TABLE dbo.Reviews;
IF OBJECT_ID('dbo.ProductImages','U')  IS NOT NULL DROP TABLE dbo.ProductImages;
IF OBJECT_ID('dbo.Shippings','U')      IS NOT NULL DROP TABLE dbo.Shippings;
IF OBJECT_ID('dbo.Payments','U')       IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.OrderItems','U')     IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders','U')         IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.ProductCatalog','U') IS NOT NULL DROP TABLE dbo.ProductCatalog;
IF OBJECT_ID('dbo.ProductCategory','U')IS NOT NULL DROP TABLE dbo.ProductCategory;
IF OBJECT_ID('dbo.Customers','U')      IS NOT NULL DROP TABLE dbo.Customers;
GO

/* =========================
   1) Customers
   (CustomerID int PK)
   ========================= */
CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    [Name]     NVARCHAR(100) NOT NULL,
    Email      NVARCHAR(100) NOT NULL,
    Phone      NVARCHAR(20)  NOT NULL,
    [Address]  NVARCHAR(200) NOT NULL,
    Username   NVARCHAR(100) NOT NULL,
    [Password] NVARCHAR(100) NOT NULL
);
GO

/* =========================
   2) ProductCategory
   ========================= */
CREATE TABLE dbo.ProductCategory (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);
GO

/* =========================
   3) ProductCatalog
   ========================= */
CREATE TABLE dbo.ProductCatalog (
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    ProductName     NVARCHAR(100) NOT NULL,
    [Description]   NVARCHAR(500) NOT NULL,
    Price           SMALLMONEY NOT NULL,
    QuantityInStock INT NOT NULL,
    ImageURL        NVARCHAR(200) NULL,
    CategoryID      INT NOT NULL,

    CONSTRAINT FK_ProductCatalog_ProductCategory
        FOREIGN KEY (CategoryID)
        REFERENCES dbo.ProductCategory(CategoryID)
);
GO

/* =========================
   4) ProductImages
   (ID int PK, ProductID FK)
   ========================= */
CREATE TABLE dbo.ProductImages (
    ID         INT IDENTITY(1,1) PRIMARY KEY,
    ImageURL   NVARCHAR(200) NOT NULL,
    ImageOrder SMALLINT NOT NULL,
    ProductID  INT NOT NULL,

    CONSTRAINT FK_ProductImages_ProductCatalog
        FOREIGN KEY (ProductID)
        REFERENCES dbo.ProductCatalog(ProductID)
        ON DELETE CASCADE
);
GO

/* =========================
   5) Orders
   ========================= */
CREATE TABLE dbo.Orders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    OrderDate   DATETIME NOT NULL,
    TotalAmount SMALLMONEY NOT NULL,
    [Status]    NVARCHAR(50) NOT NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);
GO

/* =========================
   6) OrderItems
   ========================= */
CREATE TABLE dbo.OrderItems (
    OrderItemID     INT IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT NOT NULL,
    ProductID       INT NOT NULL,
    Quantity        INT NOT NULL,
    UnitPrice       SMALLMONEY NOT NULL,
    TotalItemsPrice SMALLMONEY NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
        ON DELETE CASCADE,

    CONSTRAINT FK_OrderItems_ProductCatalog
        FOREIGN KEY (ProductID)
        REFERENCES dbo.ProductCatalog(ProductID)
);
GO

/* =========================
   7) Payments
   ========================= */
CREATE TABLE dbo.Payments (
    PaymentID       INT IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT NOT NULL,
    Amount          SMALLMONEY NOT NULL,
    PaymentMethod   NVARCHAR(50) NOT NULL,
    TransactionDate DATETIME NOT NULL,

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
);
GO

/* =========================
   8) Shippings
   ========================= */
CREATE TABLE dbo.Shippings (
    ShippingID            INT IDENTITY(1,1) PRIMARY KEY,
    OrderID               INT NOT NULL,
    CarrierName           NVARCHAR(100) NOT NULL,
    TrackingNumber        NVARCHAR(50) NOT NULL,
    ShippingStatus        NVARCHAR(50) NOT NULL,
    EstimatedDeliveryDate DATETIME NOT NULL,
    ActualDeliveryDate    DATETIME NULL,

    CONSTRAINT FK_Shippings_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
);
GO

/* =========================
   9) Reviews
   ========================= */
CREATE TABLE dbo.Reviews (
    ReviewID    INT IDENTITY(1,1) PRIMARY KEY,
    ProductID   INT NOT NULL,
    CustomerID  INT NOT NULL,
    ReviewText  NVARCHAR(500) NULL,
    Rating      DECIMAL(2,1) NOT NULL,
    ReviewDate  DATETIME NOT NULL,

    CONSTRAINT FK_Reviews_ProductCatalog
        FOREIGN KEY (ProductID)
        REFERENCES dbo.ProductCatalog(ProductID),

    CONSTRAINT FK_Reviews_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);
GO

/* =========================
   Helpful Indexes
   ========================= */
CREATE INDEX IX_ProductCatalog_CategoryID ON dbo.ProductCatalog(CategoryID);
CREATE INDEX IX_ProductImages_ProductID   ON dbo.ProductImages(ProductID);

CREATE INDEX IX_Orders_CustomerID         ON dbo.Orders(CustomerID);
CREATE INDEX IX_OrderItems_OrderID        ON dbo.OrderItems(OrderID);
CREATE INDEX IX_OrderItems_ProductID      ON dbo.OrderItems(ProductID);

CREATE INDEX IX_Payments_OrderID          ON dbo.Payments(OrderID);
CREATE INDEX IX_Shippings_OrderID         ON dbo.Shippings(OrderID);

CREATE INDEX IX_Reviews_ProductID         ON dbo.Reviews(ProductID);
CREATE INDEX IX_Reviews_CustomerID        ON dbo.Reviews(CustomerID);
GO