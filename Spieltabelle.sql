CREATE VIEW [dbo].[KundenUmsatz]
AS
SELECT        dbo.Customers.CustomerID, dbo.Customers.CompanyName, dbo.Customers.ContactName, dbo.Customers.ContactTitle, dbo.Customers.City, dbo.Customers.Country, dbo.Orders.OrderDate, dbo.Orders.Freight, 
                         dbo.Orders.ShipCity, dbo.Orders.ShipCountry, dbo.Employees.LastName, dbo.Employees.FirstName, dbo.[Order Details].OrderID, dbo.[Order Details].ProductID, dbo.[Order Details].UnitPrice, dbo.[Order Details].Quantity, 
                         dbo.Products.ProductName, dbo.Products.UnitsInStock
FROM            dbo.Customers INNER JOIN
                         dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID INNER JOIN
                         dbo.[Order Details] ON dbo.Orders.OrderID = dbo.[Order Details].OrderID INNER JOIN
                         dbo.Products ON dbo.[Order Details].ProductID = dbo.Products.ProductID INNER JOIN
                         dbo.Employees ON dbo.Orders.EmployeeID = dbo.Employees.EmployeeID
GO