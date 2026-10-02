/*
Thema: Dateigruppen fuer aktive und archivierte Daten.
Inhalt: Anlegen von Dateigruppen und Dateien sowie Zuordnen von Tabellen.
Erklaerung: Dateigruppen organisieren Datenbankdateien und koennen die
Platzierung und Wartung von Daten erleichtern.
Praxistipps: Dateien auf vorhandene Datentraegerpfade legen und Kapazitaet,
Backup und Wiederherstellung zusammen planen.
Hinweis: Datenbankname und Windows-Pfade vor dem Ausfuehren anpassen.
*/

--Dateigruppen
USE [master];
GO

ALTER DATABASE [Monitoring]
    ADD FILEGROUP [HOT];
GO

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


--verteile Daten auf versch Datentr�ger (HOT and Cold Data)

USE [Monitoring];
GO

CREATE TABLE dbo.tabelle1
(
    id INT
)
ON [HOT];


--_Dateigruppe: eine weitere Datendatei (.ndf)   Dateigruppe synonym f�r Pfad und Dateiname:  c:\prgramme....\..ndf

CREATE TABLE dbo.Archivtabelle
(
    id INT
)
ON [ARCHIV];
