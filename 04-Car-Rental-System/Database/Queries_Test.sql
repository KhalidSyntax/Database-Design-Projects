/*
04 - Car Rental System
Queries_Test.sql (Simple - 10 queries)
Run AFTER:
- Create_Tables.sql
- Insert_Sample_Data.sql
*/

SET NOCOUNT ON;
GO

/* 1) Customers list */
SELECT TOP (50)
    CustomerID, [Name], ContactInformation, DriverLicenseNumber
FROM dbo.Customer
ORDER BY CustomerID;
GO

/* 2) Vehicles with category + fuel type */
SELECT TOP (50)
    v.VehicleID, v.Make, v.Model, v.[Year], v.Mileage,
    vc.CategoryName, ft.FuelType,
    v.RentalPricePerDay, v.IsAvailableForRent, v.PlateNumber
FROM dbo.Vehicle v
JOIN dbo.VehicleCategories vc ON vc.CategoryID = v.CarCategoryID
JOIN dbo.FuelTypes ft ON ft.ID = v.FuelTypeID
ORDER BY v.VehicleID;
GO

/* 3) Available vehicles only */
SELECT
    v.VehicleID, v.Make, v.Model, v.PlateNumber, v.RentalPricePerDay
FROM dbo.Vehicle v
WHERE v.IsAvailableForRent = 1
ORDER BY v.RentalPricePerDay;
GO

/* 4) Bookings with customer + vehicle */
SELECT TOP (50)
    rb.BookingID,
    c.[Name] AS CustomerName,
    v.Make, v.Model, v.PlateNumber,
    rb.RentalStartDate, rb.RentalEndDate,
    rb.InitialRentalDays, rb.RentalPricePerDay,
    rb.InitialTotalDueAmount
FROM dbo.RentalBooking rb
JOIN dbo.Customer c ON c.CustomerID = rb.CustomerID
JOIN dbo.Vehicle v ON v.VehicleID = rb.VehicleID
ORDER BY rb.BookingID DESC;
GO

/* 5) Booking count per customer */
SELECT
    c.[Name] AS CustomerName,
    COUNT(*) AS TotalBookings
FROM dbo.RentalBooking rb
JOIN dbo.Customer c ON c.CustomerID = rb.CustomerID
GROUP BY c.[Name]
ORDER BY TotalBookings DESC;
GO

/* 6) Transactions summary */
SELECT TOP (50)
    t.TransactionID,
    t.BookingID,
    t.ReturnID,
    t.PaymentDetails,
    t.PaidInitialTotalDueAmount,
    t.ActualTotalDueAmount,
    t.TotalRemaining,
    t.TotalRefundedAmount,
    t.TransactionDate
FROM dbo.RentalTransaction t
ORDER BY t.TransactionID DESC;
GO

/* 7) Ongoing rentals (no return yet) */
SELECT
    t.TransactionID,
    rb.BookingID,
    c.[Name] AS CustomerName,
    v.PlateNumber,
    rb.RentalStartDate,
    rb.RentalEndDate
FROM dbo.RentalTransaction t
JOIN dbo.RentalBooking rb ON rb.BookingID = t.BookingID
JOIN dbo.Customer c ON c.CustomerID = rb.CustomerID
JOIN dbo.Vehicle v ON v.VehicleID = rb.VehicleID
WHERE t.ReturnID IS NULL
ORDER BY t.TransactionID DESC;
GO

/* 8) Returns: show extra charges (if any) */
SELECT TOP (50)
    vr.ReturnID,
    vr.ActualReturnDate,
    vr.ActualRentalDays,
    vr.ConsumedMileage,
    vr.AdditionalCharges,
    vr.ActualTotalDueAmount
FROM dbo.VehicleReturns vr
ORDER BY vr.ReturnID DESC;
GO

/* 9) Maintenance costs per vehicle (top) */
SELECT TOP (20)
    v.PlateNumber,
    COUNT(*) AS MaintenanceCount,
    SUM(m.Cost) AS TotalMaintenanceCost
FROM dbo.Maintenance m
JOIN dbo.Vehicle v ON v.VehicleID = m.VehicleID
GROUP BY v.PlateNumber
ORDER BY TotalMaintenanceCost DESC;
GO

/* 10) Total revenue (simple) */
SELECT
    SUM(t.ActualTotalDueAmount - t.TotalRefundedAmount) AS TotalRevenue
FROM dbo.RentalTransaction t;
GO