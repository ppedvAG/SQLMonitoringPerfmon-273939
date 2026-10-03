/*
Zweck: Anlegen von Dateigruppen und Datendateien fuer eine Beispieldatenbank.
Die T-SQL-Anweisungen legen die Dateigruppen HOT und ARCHIV sowie zugehoerige Dateien in der Datenbank Monitoring an. Passe Datenbanknamen und Dateipfade an und stelle sicher, dass die Verzeichnisse fuer den SQL-Server-Dienst erreichbar sind.
*/
--Dateigruppen
USE [master]
GO
ALTER DATABASE [Monitoring] ADD FILEGROUP [HOT]
GO

ALTER DATABASE [Monitoring] ADD FILE ( NAME = N'hotdate',
 FILENAME = N'C:\_SQLDATA\hotdate.ndf' , SIZE = 8192KB , 
FILEGROWTH = 65536KB ) TO FILEGROUP [HOT]
GO
ALTER DATABASE [Monitoring] ADD FILEGROUP [ARCHIV]
GO

ALTER DATABASE [Monitoring] ADD FILE ( NAME = N'stammdaten', 
FILENAME = N'C:\_SQLDATA\stammdaten.ndf' , SIZE = 8192KB , 
FILEGROWTH = 65536KB ) TO FILEGROUP [ARCHIV]
GO


--verteile Daten auf versch Datenträger (HOT and Cold Data)

create table tabelle1 (id int) ON Dateigruppe


--_Dateigruppe: eine weitere Datendatei (.ndf)   Dateigruppe synonym für Pfad und Dateiname:  c:\prgramme....\..ndf

create table Archivtabelle (id int) on ARCHIV
