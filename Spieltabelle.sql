/*
Thema: Beispielansicht fuer Kundenumsatzdaten.
Inhalt: Verknuepft Kunden, Bestellungen, Bestelldetails, Produkte und Mitarbeiter.
Erklaerung: Die Sicht stellt Felder aus mehreren Northwind-Tabellen fuer
Abfragen und Demonstrationen gemeinsam bereit.
Praxistipps: Spaltenqualifizierungen beibehalten und benoetigte Spalten gezielt
abfragen, statt bei grossen Datenmengen SELECT * zu verwenden.
Hinweis: Voraussetzung sind das Northwind-Schema und passende CREATE VIEW-Rechte.
*/

CREATE VIEW [dbo].[KundenUmsatz]
AS
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.ContactTitle,
        c.City,
        c.Country,
        o.OrderDate,
        o.Freight,
        o.ShipCity,
        o.ShipCountry,
        e.LastName,
        e.FirstName,
        od.OrderID,
        od.ProductID,
        od.UnitPrice,
        od.Quantity,
        p.ProductName,
        p.UnitsInStock
    FROM dbo.Customers AS c
    INNER JOIN dbo.Orders AS o
        ON c.CustomerID = o.CustomerID
    INNER JOIN dbo.[Order Details] AS od
        ON o.OrderID = od.OrderID
    INNER JOIN dbo.Products AS p
        ON od.ProductID = p.ProductID
    INNER JOIN dbo.Employees AS e
        ON o.EmployeeID = e.EmployeeID;
GO