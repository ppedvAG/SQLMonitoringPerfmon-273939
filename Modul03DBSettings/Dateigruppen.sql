/*
Zweck: Anlegen von Dateigruppen und Datendateien fuer eine Beispieldatenbank.
Die T-SQL-Anweisungen legen die Dateigruppen HOT und ARCHIV sowie zugehoerige Dateien in der Datenbank Monitoring an. Passe Datenbanknamen und Dateipfade an und stelle sicher, dass die Verzeichnisse fuer den SQL-Server-Dienst erreichbar sind.
*/
-- Die Verwaltungsanweisungen werden in master ausgefuehrt.
USE [master]
GO
ALTER DATABASE [Monitoring]
    ADD FILEGROUP [HOT];
GO

-- Die Dateien muessen in einem fuer den SQL-Server-Dienst erreichbaren Verzeichnis liegen.
ALTER DATABASE [Monitoring]
    ADD FILE
    (
        NAME = N'hotdate',
        FILENAME = N'C:\_SQLDATA\hotdate.ndf',
        SIZE = 8192KB,
        FILEGROWTH = 65536KB
    )
    TO FILEGROUP [HOT];
GO

ALTER DATABASE [Monitoring]
    ADD FILEGROUP [ARCHIV];
GO

ALTER DATABASE [Monitoring]
    ADD FILE
    (
        NAME = N'stammdaten',
        FILENAME = N'C:\_SQLDATA\stammdaten.ndf',
        SIZE = 8192KB,
        FILEGROWTH = 65536KB
    )
    TO FILEGROUP [ARCHIV];
GO

-- Beispiel: Tabelle auf einer zuvor angelegten Dateigruppe platzieren.
CREATE TABLE dbo.tabelle1
(
    id int
)
ON Dateigruppe;

-- Beispiel fuer eine Tabelle in der Dateigruppe ARCHIV.
CREATE TABLE dbo.Archivtabelle
(
    id int
)
ON [ARCHIV];
