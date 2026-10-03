/*
Zweck: Demonstration von Parallelitaet und MAXDOP in SQL Server.
Das Skript vergleicht Laufzeit- und I/O-Statistiken, zeigt Abfragehinweise und die datenbankbezogene MAXDOP-Konfiguration. Es verwendet Northwind-Objekte; pruefe die Auswirkungen einer Konfigurationsaenderung vor dem Einsatz auf einem produktiven Server.
*/
/*
MAXDOP legt die Obergrenze fuer Prozessoren fest, die eine Abfrage parallel
verwenden darf. Mehr Prozessoren koennen die verstrichene Zeit verkuerzen,
erhoehen aber auch den CPU-Verbrauch; der Effekt muss mit der konkreten
Workload gemessen werden.

Ein Parallelplan wird unter anderem anhand der Kostenabschaetzung und des
Kosten-Schwellenwerts fuer Parallelitaet gewaehlt. MAXDOP kann auf Server-,
Datenbank- oder Abfrageebene festgelegt werden; eine Abfrageoption kann die
uebergeordneten Einstellungen beeinflussen.
*/


-- I/O-Statistiken zeigen Seitenzugriffe; die Zeitstatistiken zeigen CPU- und Laufzeit.
SET STATISTICS IO, TIME ON;

-- Abfrage mit explizitem MAXDOP; die Messwerte haengen von Daten und Systemlast ab.
SELECT
    ShipCountry,
    ShipCity,
    SUM(Freight) AS TotalFreight
FROM dbo.KU
GROUP BY ShipCountry, ShipCity
OPTION (MAXDOP 6);

-- Beispielwerte aus einer Messung (CPU-Zeit / verstrichene Zeit):
-- MAXDOP 8: 923 ms / 144 ms; MAXDOP 1: 406 ms / 419 ms; MAXDOP 4: 625 ms / 166 ms.

-- CX*-Wait-Types koennen Hinweise auf parallel ausgefuehrte Abfragen geben.
SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE N'CX%';

-- Der Abfragehinweis ueberschreibt in diesem Beispiel die hoehere Einstellung.
SELECT
    Country,
    City,
    SUM(Freight) AS TotalFreight
FROM dbo.KU
GROUP BY Country, City
OPTION (MAXDOP 8);

-- Fuer die konkrete Workload messen und server- bzw. datenbankweite
-- Einstellungen vor einer Aenderung pruefen.

USE [master]
GO

USE [Northwind]
GO
-- Beispiel fuer die datenbankweite Obergrenze paralleler Abfrageprozessoren.
ALTER DATABASE SCOPED CONFIGURATION
    SET MAXDOP = 4;
GO
