/*
Thema: Weitergeleitete Datensaetze in Heap-Tabellen.
Inhalt: Diagnose mit DBCC SHOWCONTIG und sys.dm_db_index_physical_stats.
Erklaerung: Wachsen Zeilen in einem Heap und passen nicht mehr auf ihre Seite,
kann SQL Server sie verschieben und einen Forwarded Record hinterlassen.
Praxistipps: forwarded_record_count regelmaessig im Kontext der Workload pruefen
und eine Heap-Umwandlung nur nach Abwaegung der Folgen erwägen.
Hinweis: DBCC SHOWCONTIG ist veraltet; die DMV benoetigt geeignete Rechte.
*/

--Design Ph�nomene

--forward Record Counts
--kommt durch Hinzuf�gen von Spalten zu bestehenden Tabellen
--14000 Seiten mehr als Tabelle hat???

--Alter  !!

--Table Scan 56000

dbcc showcontig('ku')--42186


--der dbcc ist veraltet.. hier hilft der Befehl 

select * from sys.dm_db_index_physical_stats
		(db_id(), object_id('ku'),null,null,'detailed')

--forwarded_record_count immer NUll oder 0 sein

-- der forwardRecordCount sollte immer NULL oder 0 sein

-- im Falle von Clustered Indizes wird es immer NULL sein

--sond forwardrecordcounts vorhanden--> CL IX erstellen
--und falls der nicht erw�nscht ist wieder l�schen
:-)

--TRIGGER: INS UP DEL   DML

--DDL: CR ALTER DROP

