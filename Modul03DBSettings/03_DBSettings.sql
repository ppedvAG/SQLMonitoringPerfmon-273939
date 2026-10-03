/*
Zweck: Beispiele fuer Datenbankoptionen und Statistikeinstellungen.
Das Skript zeigt Einstellungen fuer inkrementelle automatische Statistiken und DATE_CORRELATION_OPTIMIZATION und erlaeutert deren moeglichen Einfluss auf Abfrageplaene. Die Beispiele verwenden Northwind und sollten an die jeweilige Datenbank angepasst werden.
*/
USE [master];
GO

-- Automatische Statistiken aktivieren; inkrementelle Statistiken sind fuer
-- partitionierte Tabellen relevant.
ALTER DATABASE [Northwind]
    SET AUTO_CREATE_STATISTICS ON (INCREMENTAL = ON);

-- Beispiel: Eine Partition einer Statistik mit einer vorhandenen Stichprobe aktualisieren.
-- UPDATE STATISTICS [dbo].[Record] [idx_record_name] WITH RESAMPLE ON PARTITIONS (1);


-- Diese Option kann korrelierte Datumswerte in Abfragen beruecksichtigen.
ALTER DATABASE [Northwind]
    SET DATE_CORRELATION_OPTIMIZATION ON WITH NO_WAIT;
GO

-- Erlaubt verzögertes Schreiben des Transaktionsprotokolls; bei einem Ausfall
-- koennen bestaetigte Transaktionen verloren gehen.
ALTER DATABASE [Northwind]
    SET DELAYED_DURABILITY = ALLOWED WITH NO_WAIT;
GO

USE [Northwind];
GO

-- Datenbankbezogene Optionen gelten fuer die aktuelle Datenbank.
ALTER DATABASE SCOPED CONFIGURATION
    SET MAXDOP = 4;
GO

ALTER DATABASE SCOPED CONFIGURATION
    SET QUERY_OPTIMIZER_HOTFIXES = ON;
GO

-- Zeilenversionierung kann Leser und Schreiber entkoppeln, beansprucht aber tempdb.
ALTER DATABASE [Northwind]
    SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

ALTER DATABASE [Northwind]
    SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT;
GO

-- Leert den Plancache nur fuer die aktuelle Datenbank.
ALTER DATABASE SCOPED CONFIGURATION
    CLEAR PROCEDURE_CACHE;