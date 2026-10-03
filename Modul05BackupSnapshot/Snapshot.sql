/*
Zweck: Erstellen und Wiederherstellen eines Datenbank-Snapshots.
Das Skript enthaelt eine Vorlage und ein Northwind-Beispiel. Ersetze logische Dateinamen und Dateipfade durch passende Werte; Snapshots benoetigen ausreichend Speicher und sind kein Ersatz fuer unabhaengige Sicherungen. Die Beispiele aendern Daten und koennen die Datenbank wiederherstellen; beende dafuer vorher alle Verbindungen. Fuehre sie nur in einer Testumgebung aus.
*/
USE [master]
GO
ALTER DATABASE [Northwind]
   SET MULTI_USER WITH NO_WAIT;
GO

-- =============================================
-- Create Database Snapshot Template
-- =============================================
USE [master]
GO

-- Vorlage: Namen, logischen Dateinamen und Pfad an die Quelldatenbank anpassen.
CREATE DATABASE [SnapshotDBName]
   ON
   (
       NAME = [logNamederOrgDatendatei],
       FILENAME = N'PfadundDateiname der Snapshotdatendatei.mdf'
   )
   AS SNAPSHOT OF [OrgDb];
GO

-- Snapshot der Northwind-Beispieldatenbank erstellen.
CREATE DATABASE [nw_1616]
   ON
(
   NAME = N'Northwind', -- Logischer Name der Quelldatendatei.
   FILENAME = N'C:\_SQLDATA\nw_1616.mdf' -- Speicherort der Snapshot-Datei.
)
AS SNAPSHOT OF [Northwind];
GO

USE [Northwind];
GO

-- Beispielaenderung: Die Snapshot-Kopie behaelt den vorherigen Datenstand.
UPDATE dbo.Customers
SET City = N'XXX'
WHERE CustomerID = N'ALFKI';

SELECT *
FROM dbo.Customers;


-- Weitere Snapshot-Abfragen und Restore-Beispiele.

-- Fuer eine Datenbank koennen mehrere Snapshots erstellt werden.

-- Ein Datenbank-Snapshot kann nicht wie eine regulaere Datenbank gesichert werden.

-- Die Quelldatenbank kann weiterhin regulaer gesichert werden.

-- Zeigt Zeilen, die sich zwischen Quelldatenbank und Snapshot unterscheiden.
SELECT *
FROM Northwind.dbo.Customers
EXCEPT
SELECT *
FROM [nw_1616].dbo.Customers;


-- Ein Snapshot wird nicht mit dem regulaeren RESTORE-Befehl wiederhergestellt.

-- Die Quelldatenbank kann auf den Snapshot-Stand zurueckgesetzt werden.
-- Vor einem regulaeren Restore muessen die Snapshots geloescht werden.

-- Vor dem Zuruecksetzen muessen Verbindungen zur Quelldatenbank beendet sein.
USE [master];
GO

-- Beispiel zum Ermitteln der Sitzungen, die vor dem Restore zu beenden sind.
SELECT *
FROM sysprocesses
WHERE spid > 50
  AND dbid IN (DB_ID(N'Northwind'), DB_ID(N'nw_1616'));

-- Alternativ nur Sitzungen der Quelldatenbank und des Snapshots anzeigen.
SELECT *
FROM sysprocesses
WHERE spid > 50
  AND dbid IN (DB_ID(N'Northwind'), DB_ID(N'nw_1616'));

-- Beende Sitzungen nur nach Pruefung ihrer Zugehoerigkeit und Auswirkungen:
-- KILL <Sitzungs-ID>;

-- Setzt Northwind auf den Snapshot-Stand zurueck; alle Verbindungen muessen
-- vorher beendet sein. Fuehre dies nur aus, wenn das Zuruecksetzen beabsichtigt ist.
RESTORE DATABASE [Northwind]
FROM DATABASE_SNAPSHOT = [nw_1616];