/*
Thema: Datenbankoptionen fuer Northwind.
Inhalt: Statistiken, Datums-Korrelation, verzoegerte Dauerhaftigkeit, MAXDOP,
Query-Optimizer-Hotfixes und Zeilenversionierung.
Erklaerung: Die Optionen beeinflussen Planung, Parallelitaet, Commit-Verhalten
und die Isolation lesender Transaktionen.
Praxistipps: Auswirkungen in einer Testdatenbank messen und insbesondere
verzoegerte Dauerhaftigkeit fachlich freigeben lassen.
Hinweis: Das Skript aendert die Datenbankkonfiguration. Datenbankname,
Berechtigungen und SQL-Server-Version vorher pruefen.
*/

use [master];
GO

ALTER DATABASE [Northwind] 
	SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = ON)

--update statistics [dbo].[Record] idx_record_name with resample on partitions (1);
--A robust on-demand incremental statistics update process on partitioned tables will boost performance stability, 
--reduce resource consumption (I/O and CPU) and significantly shrink the maintenance window for very large tables.


ALTER DATABASE [Northwind] 
	SET DATE_CORRELATION_OPTIMIZATION ON WITH NO_WAIT
--Gibt es Abh�ngigkeiten zwischen Datumsfeldern..?
--Etwa immer 14 nach Termin1 , dann Termin2
--SQL Server kann die Korrelation erkennen und entsprechen 
--mit geeigneten Statistiken die Daten effizienter holen
--da Plan auch exakter wird
GO


ALTER DATABASE [Northwind] 
	SET DELAYED_DURABILITY = ALLOWED WITH NO_WAIT
GO
--Client bekommt Commit, obwohl TX noch nicht in LOG
--festgeschrieben
--verz�gert: evtl Datenverlust, aber f�r den Client schneller
--verz�gert: Latenzzeit des Datentr�ger verringert sich
--da Batchweise zur�ckgeschrieben wird
--weniger Datentr�gerkonflikte bei gleichzeitigen TX
-->Arbeitsauslastungen weisen eine hohe Konfliktrate auf.
-->Bei Schreibvorg�ngen in das Transaktionsprotokoll treten Engp�sse auf.
-->Datenverluste sind in gewissem Umfang vertretbar.
 --Wegschreiben ins Log: EXECUTE sys.sp_flush_log  

 --Ght allerdings nicht �berall:
 --

ALTER DATABASE 
	SCOPED CONFIGURATION SET MAXDOP = 4;
GO
ALTER DATABASE 
	SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = On;
--this will work same as enabling the Trace Flag 4199 in your SQL Server.

-----------------------------------------
ALTER DATABASE [Northwind] 
	SET ALLOW_SNAPSHOT_ISOLATION ON
GO

ALTER DATABASE [Northwind] 
	SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT

--Ein �ndern eines Datensatzes hindert nicht mehr den Zugriff der anderen
--aber: es werden Versionen in die tempdb kopiert
--evtl massive Last auf tempdb


ALTER DATABASE SCOPED CONFIGURATION 
CLEAR PROCEDURE_CACHE ;
-- vs dbcc freeproccache leert den gesamten Planspeicher des SQL Server

