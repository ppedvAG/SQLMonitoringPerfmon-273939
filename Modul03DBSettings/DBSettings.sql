/*
Thema: Groesse und Konfiguration von SQL-Server-Datenbanken.
Inhalt: Datenbankwachstum, Statistiken, Wiederherstellungsmodell und weitere
Konfigurationsoptionen.
Erklaerung: Eine passende Anfangsgroesse und kontrolliertes Wachstum koennen
unnnoetige Dateivergroesserungen und damit verbundene I/O reduzieren.
Praxistipps: Wachstum anhand der erwarteten Auslastung dimensionieren, Auto-
Shrink vermeiden und Aenderungen mit Wiederherstellungszielen abstimmen.
Hinweis: Die enthaltenen Beispieloptionen konfigurieren die Datenbank Northwind.
*/

	   /*

Eine Datenbank beginnt mit rel geringen Gr��en
und einer geringen Wachstumsrate!

Wir wollen IO reduzieren oder sogar vermeiden.
Also: Gib einer DB eine gute Startgr��e um unn�tiges IO zu vermeiden

F�r Vergr��erungsraten empfiehlt sich zB 1024 MB. Selten , aber nicht aufwendig ist das Motto.

Kontrolle:
Berichte der Datenbank: Datentr�gerverwendung.
Am besten w�re keine automatischen Vergr��erungen oder wenige.
Schlecht w�re: viele in einer Sekunde.


DB k�nnen ausserdem einige n�tzliche Settings besitzten, 
die es lohnt zu kontrolieren: 

Statistiken automatisch erstellen true
Statsitiken automatisch aktualisieren true
DB verkeinern False
Wiederherstellungsmodel: ? Simple / Full / False
*/

select SOUNDEX('Meyr'), formsof
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

