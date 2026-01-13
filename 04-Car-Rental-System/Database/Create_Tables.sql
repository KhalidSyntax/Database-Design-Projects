/*
04 - Car Rental System (SQL Server)
Create Tables Script

Run this first, then run Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   DROP TABLES (re-run safe)
   ========================= */
IF OBJECT_ID('dbo.RentalTransaction','U')   IS NOT NULL DROP TABLE dbo.RentalTransaction;
IF OBJECT_ID('dbo.VehicleReturns','U')      IS NOT NULL DROP TABLE dbo.VehicleReturns;
IF OBJECT_ID('dbo.RentalBooking','U')       IS NOT NULL DROP TABLE dbo.RentalBooking;
IF OBJECT_ID('dbo.Maintenance','U')         IS NOT NULL DROP TABLE dbo.Maintenance;
IF OBJECT_ID('dbo.Vehicle','U')             IS NOT NULL DROP TABLE dbo.Vehicle;
IF OBJECT_ID('dbo.Customer','U')            IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID('dbo.FuelTypes','U')           IS NOT NULL DROP TABLE dbo.FuelTypes;
IF OBJECT_ID('dbo.VehicleCategories','U')   IS NOT NULL DROP TABLE dbo.VehicleCategories;
GO

/* =========================
   1) Lookups
   ========================= */
CREATE TABLE dbo.VehicleCategories
(
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.FuelTypes
(
    ID       INT IDENTITY(1,1) PRIMARY KEY,
    FuelType NVARCHAR(20) NOT NULL
);
GO

/* =========================
   2) Core tables
   ========================= */
CREATE TABLE dbo.Customer
(
    CustomerID          INT IDENTITY(1,1) PRIMARY KEY,
    [Name]              NVARCHAR(100) NOT NULL,
    ContactInformation  NVARCHAR(100) NOT NULL,
    DriverLicenseNumber NVARCHAR(20)  NOT NULL
);
GO

CREATE TABLE dbo.Vehicle
(
    VehicleID          INT IDENTITY(1,1) PRIMARY KEY,
    Make               NVARCHAR(50) NOT NULL,
    Model              NVARCHAR(50) NOT NULL,
    [Year]             INT NOT NULL,
    Mileage            INT NOT NULL,
    FuelTypeID         INT NOT NULL,
    PlateNumber        NVARCHAR(20) NOT NULL,
    CarCategoryID      INT NOT NULL,
    RentalPricePerDay  DECIMAL(10,2) NOT NULL,
    IsAvailableForRent BIT NOT NULL CONSTRAINT DF_Vehicle_IsAvailable DEFAULT (1),

    CONSTRAINT UQ_Vehicle_Plate UNIQUE (PlateNumber),
    CONSTRAINT CK_Vehicle_Year CHECK ([Year] BETWEEN 1990 AND 2025),
    CONSTRAINT CK_Vehicle_Mileage CHECK (Mileage >= 0),

    CONSTRAINT FK_Vehicle_FuelTypes
        FOREIGN KEY (FuelTypeID) REFERENCES dbo.FuelTypes(ID),

    CONSTRAINT FK_Vehicle_VehicleCategories
        FOREIGN KEY (CarCategoryID) REFERENCES dbo.VehicleCategories(CategoryID)
);
GO

CREATE TABLE dbo.Maintenance
(
    MaintenanceID   INT IDENTITY(1,1) PRIMARY KEY,
    VehicleID       INT NOT NULL,
    [Description]   NVARCHAR(300) NOT NULL,
    MaintenanceDate DATE NOT NULL,
    Cost            DECIMAL(10,2) NOT NULL,

    CONSTRAINT CK_Maintenance_Cost CHECK (Cost >= 0),
    CONSTRAINT FK_Maintenance_Vehicle
        FOREIGN KEY (VehicleID) REFERENCES dbo.Vehicle(VehicleID)
);
GO

/* =========================
   3) Rental flow
   ========================= */
CREATE TABLE dbo.RentalBooking
(
    BookingID            INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID           INT NOT NULL,
    VehicleID            INT NOT NULL,
    RentalStartDate      DATE NOT NULL,
    RentalEndDate        DATE NOT NULL,
    PickupLocation       NVARCHAR(100) NOT NULL,
    DropoffLocation      NVARCHAR(100) NOT NULL,
    InitialRentalDays    TINYINT NOT NULL,
    RentalPricePerDay    SMALLMONEY NOT NULL,
    InitialTotalDueAmount SMALLMONEY NOT NULL,
    InitialCheckNotes    NVARCHAR(500) NULL,

    CONSTRAINT CK_Booking_Dates CHECK (RentalEndDate >= RentalStartDate),
    CONSTRAINT CK_Booking_Days CHECK (InitialRentalDays > 0),
    CONSTRAINT CK_Booking_Price CHECK (RentalPricePerDay >= 0),
    CONSTRAINT CK_Booking_InitialTotal CHECK (InitialTotalDueAmount >= 0),

    CONSTRAINT FK_RentalBooking_Customer
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID),

    CONSTRAINT FK_RentalBooking_Vehicle
        FOREIGN KEY (VehicleID) REFERENCES dbo.Vehicle(VehicleID)
);
GO

CREATE TABLE dbo.VehicleReturns
(
    ReturnID            INT IDENTITY(1,1) PRIMARY KEY,
    ActualReturnDate    DATETIME NOT NULL,
    ActualRentalDays    TINYINT NOT NULL,
    Mileage             SMALLINT NOT NULL,
    ConsumedMileage     SMALLINT NOT NULL,
    FinalCheckNotes     NVARCHAR(500) NOT NULL,
    AdditionalCharges   SMALLMONEY NOT NULL,
    ActualTotalDueAmount SMALLMONEY NOT NULL,

    CONSTRAINT CK_Return_Days CHECK (ActualRentalDays > 0),
    CONSTRAINT CK_Return_Mileage CHECK (Mileage >= 0 AND ConsumedMileage >= 0),
    CONSTRAINT CK_Return_Charges CHECK (AdditionalCharges >= 0),
    CONSTRAINT CK_Return_Total CHECK (ActualTotalDueAmount >= 0)
);
GO

CREATE TABLE dbo.RentalTransaction
(
    TransactionID             INT IDENTITY(1,1) PRIMARY KEY,
    BookingID                 INT NOT NULL,
    ReturnID                  INT NULL,
    PaymentDetails            NVARCHAR(100) NOT NULL,
    PaidInitialTotalDueAmount SMALLMONEY NOT NULL,
    ActualTotalDueAmount      SMALLMONEY NOT NULL,
    TotalRemaining            SMALLMONEY NOT NULL,
    TotalRefundedAmount       SMALLMONEY NOT NULL,
    TransactionDate           DATETIME NOT NULL,
    UpdatedTransactionDate    DATETIME NULL,

    CONSTRAINT CK_Trans_Amounts CHECK (
        PaidInitialTotalDueAmount >= 0 AND
        ActualTotalDueAmount >= 0 AND
        TotalRemaining >= 0 AND
        TotalRefundedAmount >= 0
    ),

    CONSTRAINT FK_RentalTransaction_Booking
        FOREIGN KEY (BookingID) REFERENCES dbo.RentalBooking(BookingID),

    CONSTRAINT FK_RentalTransaction_Return
        FOREIGN KEY (ReturnID) REFERENCES dbo.VehicleReturns(ReturnID)
);
GO

/* =========================
   Indexes (helpful)
   ========================= */
CREATE INDEX IX_Vehicle_Category ON dbo.Vehicle(CarCategoryID);
CREATE INDEX IX_Vehicle_FuelType ON dbo.Vehicle(FuelTypeID);
CREATE INDEX IX_Maintenance_VehicleID ON dbo.Maintenance(VehicleID);

CREATE INDEX IX_Booking_CustomerID ON dbo.RentalBooking(CustomerID);
CREATE INDEX IX_Booking_VehicleID  ON dbo.RentalBooking(VehicleID);
CREATE INDEX IX_Booking_StartDate  ON dbo.RentalBooking(RentalStartDate);

CREATE INDEX IX_Trans_BookingID ON dbo.RentalTransaction(BookingID);
CREATE INDEX IX_Trans_ReturnID  ON dbo.RentalTransaction(ReturnID);
GO