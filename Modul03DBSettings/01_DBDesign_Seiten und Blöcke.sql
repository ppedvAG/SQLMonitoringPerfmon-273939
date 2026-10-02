/*
Thema: SQL-Server-Seiten, Extents und Datensatzspeicherung.
Inhalt: Grundbegriffe der physischen Speicherung sowie Beispiele zu Seiten-
verbrauch und Fragmentierung.
Erklaerung: SQL Server liest Daten in 8-KB-Seiten; Extents gruppieren acht
Seiten. Zeilenbreite und Seitennutzung beeinflussen die benoetigten I/O.
Praxistipps: Speicherwerte mit passenden DMVs pruefen und Testtabellen nur in
einer dafuer vorgesehenen Datenbank anlegen.
Hinweis: Die Beispiele erstellen gleichnamige Tabellen und sind nicht idempotent.
*/

----Seiten und Bl�cke

--Seiten und Bl�cke

/*
1  Seiten = 8192bytes
max 8072 bytes Datenvolumen
1 DS mit fixen L�ngen max 8060byts und muss in Seite passen
max 700 DS pro Seite

8 zusammenh�ngende Seiten = Block

Seite = Page
Block = Extent

SQL kann mur mit einem Thread eine Seite lesen.
Zwei Zugriffe ergeben einen Latch oder auch Spinocks
Latch = supended, Spinlocks sind aktiv

dbcc showcontig('Tabelle')

*/

use northwind;
GO


create table t1 (id int identity, spx char(4100));
GO


insert into t1
select 'XY'
GO 20000
--Zeit Messen


dbcc showcontig('')


--besser w�re der hier.. kommt aber sp�ter nochmal...
select * from sys.dm_db_index_physical_stats(db_id(), object_id(''), NULL, NULL, 'detailed')
GO



use northwind;
GO


create table t1 (id int identity, spx char(4100));
GO


insert into t1
select 'XY'
GO 20000
--Zeit Messen





--Warum hat die Tabelle t1 160MB , bei ca 80MB Daten
--Warum liest man aus der Tabelle KU 57000, wenn der dbcc nur 41000 Seiten angibt

--Weil die Seiten wg char(4100) nicht voller gemacht werden k�nnen...