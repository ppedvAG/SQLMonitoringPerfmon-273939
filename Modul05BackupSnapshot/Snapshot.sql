/*
Thema: SQL-Server-Datenbanksnapshots.
Inhalt: Erstellen, Abfragen und Zuruecksetzen eines Snapshots.
Erklaerung: Ein Snapshot stellt einen schreibgeschuetzten, platzsparenden
Zustand einer Quelldatenbank zu einem Zeitpunkt bereit.
Praxistipps: Snapshots sind kein Ersatz fuer Sicherungen; freie Kapazitaet,
Lebensdauer und Schreiblast der Quelldatenbank beobachten.
Hinweis: Vor dem Ausfuehren logische Dateinamen, Dateipfade und aktive
Verbindungen pruefen. RESTORE aus Snapshot verwirft spaetere Aenderungen.
*/

USE [master];
GO

ALTER DATABASE [Northwind]
    SET MULTI_USER WITH NO_WAIT;
GO

-- =============================================
-- Create Database Snapshot Template
-- =============================================
USE [master];
GO

-- Create the database snapshot
CREATE DATABASE [SnapshotDBName]
ON
(
    NAME = [logNamederOrgDatendatei],
    FILENAME = N'PfadundDateiname der Snapshotdatendatei.mdf'
)
AS SNAPSHOT OF [OrgDb];
GO

CREATE DATABASE [nw_1616]
ON
(
    NAME = N'Northwind', -- Logischer Name der Datendatei.
    FILENAME = N'C:\_SQLDATA\nw_1616.mdf' -- Beispielpfad anpassen.
)
AS SNAPSHOT OF [Northwind];
GO

USE [Northwind];
GO

UPDATE dbo.Customers
SET City = N'XXX'
WHERE CustomerID = N'ALFKI';
GO

SELECT *
FROM dbo.Customers;
GO


--Snapshot-----------------TSQL

--Kann man mehrere SN machen?
--ja

--Kann man einen SN backupen?
--N�

--Kann man die OrgDB backupen?
--Ja klar

SELECT *
FROM [Northwind].dbo.Customers
EXCEPT
SELECT *
FROM [nw_1616].dbo.Customers;


--kann man den SN restoren?
--n�

--kann man die OrgDB restoren?
--jein--kein normaler restore
--f�r den normal restore m�ssen alle SN gel�scht werden
--Restore von SN m�glich

--alle user m�ssen von allen DBs (northwind und Snapshot) verscheucht werden
USE [master];
GO

--der Restore geht nur, wenn alle Connections beendet wurden

RESTORE DATABASE [Northwind]
FROM DATABASE_SNAPSHOT = N'nw_1616';
GO


SELECT *
FROM sys.sysprocesses
WHERE spid > 50
  AND dbid IN (DB_ID(N'Northwind'), DB_ID(N'nw_1616'));

SELECT DB_ID(N'nw_1616');

-- KILL <SPID>; -- Nur nach Pruefung der Sitzung und des Datenbankkontexts ausfuehren.


--oder so 

--alle laufenden Prozesse der Benutzer
SELECT *
FROM sys.sysprocesses
WHERE spid > 50
  AND dbid IN (DB_ID(N'Northwind'), DB_ID(N'nw_1616'));


-- KILL <SPID>; -- Nur nach Pruefung der Sitzung und des Datenbankkontexts ausfuehren.
