/*
04 - Car Rental System (SQL Server)
Insert Sample Data (REALISTIC SIMULATION)

Run AFTER: Create_Tables.sql
*/

SET NOCOUNT ON;
GO

/* =========================
   Clean data
   ========================= */
DELETE FROM dbo.RentalTransaction;
DELETE FROM dbo.VehicleReturns;
DELETE FROM dbo.RentalBooking;
DELETE FROM dbo.Maintenance;
DELETE FROM dbo.Vehicle;
DELETE FROM dbo.Customer;
DELETE FROM dbo.FuelTypes;
DELETE FROM dbo.VehicleCategories;
GO

DBCC CHECKIDENT ('dbo.RentalTransaction', RESEED, 0);
DBCC CHECKIDENT ('dbo.VehicleReturns', RESEED, 0);
DBCC CHECKIDENT ('dbo.RentalBooking', RESEED, 0);
DBCC CHECKIDENT ('dbo.Maintenance', RESEED, 0);
DBCC CHECKIDENT ('dbo.Vehicle', RESEED, 0);
DBCC CHECKIDENT ('dbo.Customer', RESEED, 0);
DBCC CHECKIDENT ('dbo.FuelTypes', RESEED, 0);
DBCC CHECKIDENT ('dbo.VehicleCategories', RESEED, 0);
GO

/* =========================
   1) Lookups
   ========================= */
INSERT INTO dbo.VehicleCategories (CategoryName)
VALUES
(N'Economy'), (N'Sedan'), (N'SUV'), (N'Truck'), (N'Luxury'), (N'Van');
GO

INSERT INTO dbo.FuelTypes (FuelType)
VALUES
(N'Petrol'), (N'Diesel'), (N'Hybrid'), (N'Electric');
GO

/* =========================
   2) Customers (realistic names + contacts)
   - ContactInformation: phone or email (simple)
   - DriverLicenseNumber: simulated, unique-looking
   ========================= */
INSERT INTO dbo.Customer ([Name], ContactInformation, DriverLicenseNumber)
VALUES
(N'Khaled Fahad',        N'0552233345', N'DL-SA-914302'),
(N'Aisha Al-Noor',       N'0501234567', N'DL-SA-120583'),
(N'Omar Saleh',          N'0569876543', N'DL-SA-778214'),
(N'Sara Khaled',         N'0531122334', N'DL-SA-340911'),
(N'Fahad Al-Otaibi',     N'0552200119', N'DL-SA-611502'),
(N'Noura Al-Harbi',      N'0507788991', N'DL-SA-292014'),
(N'Abdullah Nasser',     N'0544445566', N'DL-SA-508773'),
(N'Maha Al-Qahtani',     N'0591010101', N'DL-SA-980145'),
(N'Yousef Al-Zahrani',   N'0556677889', N'DL-SA-145902'),
(N'Reem Al-Shehri',      N'0509090909', N'DL-SA-703611'),
(N'Ahmed Al-Salem',      N'0533332211', N'DL-SA-332890'),
(N'Layla Saeed',         N'0551112233', N'DL-SA-445210'),
(N'Saleh Al-Ghamdi',     N'0502223344', N'DL-SA-612334'),
(N'Hanan Al-Mutairi',    N'0561011121', N'DL-SA-908114'),
(N'Turki Al-Dosari',     N'0557070707', N'DL-SA-116920'),
(N'Razan Al-Farsi',      N'0505656565', N'DL-SA-771503'),
(N'Bader Al-Anazi',      N'0543219876', N'DL-SA-500771'),
(N'Dania Al-Shammari',   N'0534567890', N'DL-SA-204881'),
(N'Hassan Khalid',       N'0503333444', N'DL-SA-310442'),
(N'Nouf Al-Yami',        N'0558889990', N'DL-SA-902771'),
(N'Sultan Al-Malki',     N'0562221100', N'DL-SA-661420'),
(N'Wafa Al-Saadi',       N'0504444555', N'DL-SA-330118'),
(N'Mohammed Al-Hazmi',   N'0550001122', N'DL-SA-448002'),
(N'Raghad Al-Subaie',    N'0539090910', N'DL-SA-702319'),
(N'Faisal Al-Rashid',    N'0569090901', N'DL-SA-119772'),
(N'Nojood Al-Shahrani',  N'0507770011', N'DL-SA-880120'),
(N'Yara Al-Ahmed',       N'0551212121', N'DL-SA-661115'),
(N'Khalid Al-Johani',    N'0532323232', N'DL-SA-991300'),
(N'Rami Al-Balawi',      N'0509898989', N'DL-SA-451220'),
(N'Huda Al-Tamimi',      N'0565656566', N'DL-SA-201004');
GO

/* =========================
   3) Vehicles (real makes/models, varied categories/fuel)
   - PlateNumber must be UNIQUE
   ========================= */
INSERT INTO dbo.Vehicle
(Make, Model, [Year], Mileage, FuelTypeID, PlateNumber, CarCategoryID, RentalPricePerDay, IsAvailableForRent)
VALUES
(N'Toyota',   N'Yaris',        2022,  38000, 1, N'KSA-1042', 1, 120.00, 1),
(N'Toyota',   N'Corolla',      2023,  22000, 1, N'KSA-1188', 2, 160.00, 1),
(N'Toyota',   N'Camry',        2022,  41000, 1, N'KSA-2331', 2, 220.00, 1),
(N'Toyota',   N'RAV4',         2021,  52000, 1, N'KSA-4407', 3, 260.00, 1),
(N'Toyota',   N'Land Cruiser', 2020,  76000, 1, N'KSA-9001', 3, 480.00, 1),

(N'Hyundai',  N'Elantra',      2022,  46000, 1, N'KSA-3012', 2, 170.00, 1),
(N'Hyundai',  N'Sonata',       2021,  61000, 1, N'KSA-3129', 2, 210.00, 1),
(N'Hyundai',  N'Tucson',       2023,  28000, 1, N'KSA-7007', 3, 255.00, 1),

(N'Kia',      N'Rio',          2021,  59000, 1, N'KSA-2210', 1, 115.00, 1),
(N'Kia',      N'K5',           2022,  37000, 1, N'KSA-5522', 2, 205.00, 1),
(N'Kia',      N'Sportage',     2022,  43000, 1, N'KSA-7844', 3, 250.00, 1),

(N'Nissan',   N'Sunny',        2022,  48000, 1, N'KSA-1140', 1, 125.00, 1),
(N'Nissan',   N'Altima',       2021,  65000, 1, N'KSA-1808', 2, 210.00, 1),
(N'Nissan',   N'X-Trail',      2022,  51000, 1, N'KSA-6110', 3, 245.00, 1),
(N'Nissan',   N'Patrol',       2020,  82000, 1, N'KSA-9900', 3, 520.00, 1),

(N'Honda',    N'City',         2022,  42000, 1, N'KSA-1717', 1, 135.00, 1),
(N'Honda',    N'Accord',       2021,  68000, 1, N'KSA-6060', 2, 230.00, 1),
(N'Honda',    N'CR-V',         2022,  49000, 1, N'KSA-8088', 3, 275.00, 1),

(N'Ford',     N'Territory',    2023,  24000, 1, N'KSA-4321', 3, 260.00, 1),
(N'Ford',     N'Explorer',     2021,  69000, 1, N'KSA-7777', 3, 360.00, 1),
(N'Ford',     N'Ranger',       2022,  54000, 2, N'KSA-8585', 4, 310.00, 1),

(N'Tesla',    N'Model 3',      2023,  21000, 4, N'KSA-E303', 5, 520.00, 1),
(N'Tesla',    N'Model Y',      2022,  33000, 4, N'KSA-E404', 5, 580.00, 1),

(N'Lexus',    N'ES 350',       2022,  35000, 1, N'KSA-LE35', 5, 520.00, 1),
(N'BMW',      N'520i',         2021,  58000, 1, N'KSA-B520', 5, 610.00, 1),

(N'Mercedes', N'E 200',        2022,  44000, 1, N'KSA-ME20', 5, 650.00, 1),

(N'Toyota',   N'Hiace',        2021,  88000, 2, N'KSA-V101', 6, 300.00, 1),
(N'Hyundai',  N'Staria',       2023,  26000, 1, N'KSA-V202', 6, 340.00, 1),

(N'Toyota',   N'Hilux',        2022,  72000, 2, N'KSA-TK22', 4, 330.00, 1),
(N'Nissan',   N'Navara',       2021,  79000, 2, N'KSA-TN21', 4, 320.00, 1);
GO

/* =========================
   4) Maintenance (realistic entries)
   ========================= */
INSERT INTO dbo.Maintenance (VehicleID, [Description], MaintenanceDate, Cost)
VALUES
(1,  N'Oil & filter change',          '2025-02-10', 220.00),
(2,  N'Tire rotation & balancing',    '2025-03-05', 180.00),
(3,  N'Brake pads replacement',       '2025-04-12', 650.00),
(4,  N'AC service and gas refill',    '2025-05-20', 320.00),
(5,  N'Full inspection (10k km)',     '2025-06-15', 450.00),
(10, N'Battery replacement',          '2025-07-01', 520.00),
(15, N'Engine oil + air filter',      '2025-07-18', 280.00),
(20, N'Wheel alignment',              '2025-08-03', 150.00),
(21, N'Brake inspection',             '2025-08-21', 120.00),
(22, N'Software update / check',      '2025-09-02', 90.00),
(27, N'General service',              '2025-10-10', 260.00),
(28, N'Oil change',                   '2025-11-05', 210.00);
GO

/* =========================
   5) Generate Bookings (120) - realistic locations and notes
   - Uses existing Customers/Vehicles
   ========================= */
DECLARE @Pickup TABLE (Loc NVARCHAR(100));
INSERT INTO @Pickup (Loc)
VALUES (N'Riyadh Branch'), (N'Jeddah Branch'), (N'Dammam Branch'), (N'Madinah Branch'), (N'Abha Branch'), (N'Mecca Branch');

;WITH N AS
(
    SELECT TOP (120) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.RentalBooking
(
    CustomerID, VehicleID,
    RentalStartDate, RentalEndDate,
    PickupLocation, DropoffLocation,
    InitialRentalDays, RentalPricePerDay,
    InitialTotalDueAmount, InitialCheckNotes
)
SELECT
    ((n - 1) % (SELECT COUNT(*) FROM dbo.Customer)) + 1 AS CustomerID,
    ((n - 1) % (SELECT COUNT(*) FROM dbo.Vehicle)) + 1 AS VehicleID,
    DATEADD(DAY, n, CAST('2025-01-10' AS DATE)) AS RentalStartDate,
    DATEADD(DAY, n + (2 + (n % 6)), CAST('2025-01-10' AS DATE)) AS RentalEndDate,
    (SELECT TOP 1 Loc FROM @Pickup ORDER BY NEWID()) AS PickupLocation,
    (SELECT TOP 1 Loc FROM @Pickup ORDER BY NEWID()) AS DropoffLocation,
    CAST(2 + (n % 6) AS TINYINT) AS InitialRentalDays,
    CAST((SELECT v.RentalPricePerDay FROM dbo.Vehicle v WHERE v.VehicleID = (((n - 1) % (SELECT COUNT(*) FROM dbo.Vehicle)) + 1)) AS SMALLMONEY),
    CAST((2 + (n % 6)) * (SELECT v.RentalPricePerDay FROM dbo.Vehicle v WHERE v.VehicleID = (((n - 1) % (SELECT COUNT(*) FROM dbo.Vehicle)) + 1)) AS SMALLMONEY),
    CASE (n % 6)
        WHEN 0 THEN N'Customer inspected vehicle, photos taken'
        WHEN 1 THEN N'Full tank at pickup, no visible damages'
        WHEN 2 THEN N'Small scratch on rear bumper noted'
        WHEN 3 THEN N'Interior clean, documents verified'
        WHEN 4 THEN N'Tires checked, spare available'
        ELSE       N'Customer requested child seat (not included)'
    END
FROM N;
GO

/* =========================
   6) Returns (90) - not all bookings returned yet
   ========================= */
;WITH B AS
(
    SELECT TOP (90) BookingID, RentalStartDate, InitialRentalDays, InitialTotalDueAmount
    FROM dbo.RentalBooking
    ORDER BY BookingID
),
N AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY BookingID) AS rn, *
    FROM B
)
INSERT INTO dbo.VehicleReturns
(
    ActualReturnDate,
    ActualRentalDays,
    Mileage,
    ConsumedMileage,
    FinalCheckNotes,
    AdditionalCharges,
    ActualTotalDueAmount
)
SELECT
    DATEADD(HOUR, (rn % 10), DATEADD(DAY, InitialRentalDays + (rn % 2), CAST(RentalStartDate AS DATETIME))) AS ActualReturnDate,
    CAST(InitialRentalDays + (rn % 2) AS TINYINT) AS ActualRentalDays,
    CAST(120 + (rn % 200) AS SMALLINT) AS Mileage,
    CAST(35 + (rn % 90) AS SMALLINT) AS ConsumedMileage,
    CASE (rn % 5)
        WHEN 0 THEN N'Vehicle returned clean, no issues'
        WHEN 1 THEN N'Late by a few hours, customer informed'
        WHEN 2 THEN N'Fuel below expected level'
        WHEN 3 THEN N'Minor scratch confirmed (as noted)'
        ELSE       N'Car wash needed'
    END AS FinalCheckNotes,
    CAST(CASE (rn % 6)
            WHEN 0 THEN 0
            WHEN 1 THEN 50
            WHEN 2 THEN 80
            WHEN 3 THEN 100
            ELSE 0
         END AS SMALLMONEY) AS AdditionalCharges,
    CAST(InitialTotalDueAmount + CASE (rn % 6)
            WHEN 1 THEN 50
            WHEN 2 THEN 80
            WHEN 3 THEN 100
            ELSE 0
         END AS SMALLMONEY) AS ActualTotalDueAmount
FROM N;
GO

/* =========================
   7) Transactions (120)
   - First 90 link to returns
   - Remaining 30 ongoing rentals (ReturnID = NULL)
   ========================= */
;WITH N AS
(
    SELECT TOP (120) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.RentalTransaction
(
    BookingID,
    ReturnID,
    PaymentDetails,
    PaidInitialTotalDueAmount,
    ActualTotalDueAmount,
    TotalRemaining,
    TotalRefundedAmount,
    TransactionDate,
    UpdatedTransactionDate
)
SELECT
    n AS BookingID,
    CASE WHEN n <= 90 THEN n ELSE NULL END AS ReturnID,
    CASE (n % 3)
        WHEN 0 THEN N'Card'
        WHEN 1 THEN N'Cash'
        ELSE       N'Transfer'
    END AS PaymentDetails,
    (SELECT rb.InitialTotalDueAmount FROM dbo.RentalBooking rb WHERE rb.BookingID = n),
    CASE
        WHEN n <= 90 THEN (SELECT vr.ActualTotalDueAmount FROM dbo.VehicleReturns vr WHERE vr.ReturnID = n)
        ELSE (SELECT rb.InitialTotalDueAmount FROM dbo.RentalBooking rb WHERE rb.BookingID = n)
    END AS ActualTotalDueAmount,
    /* remaining: sometimes 0, sometimes small amount */
    CASE
        WHEN n <= 90 THEN CASE WHEN n % 12 = 0 THEN 50 ELSE 0 END
        ELSE (SELECT rb.InitialTotalDueAmount FROM dbo.RentalBooking rb WHERE rb.BookingID = n)
    END AS TotalRemaining,
    /* refunded: rare */
    CASE WHEN n % 40 = 0 THEN 30 ELSE 0 END AS TotalRefundedAmount,
    DATEADD(DAY, n, CAST('2025-01-12' AS DATETIME)) AS TransactionDate,
    DATEADD(DAY, n, CAST('2025-01-12' AS DATETIME)) AS UpdatedTransactionDate
FROM N;
GO