/*
Thema: Weitergeleitete Datensaetze in Heap-Tabellen.
Inhalt: Diagnose mit DBCC SHOWCONTIG und sys.dm_db_index_physical_stats.
Erklaerung: Wachsen Zeilen in einem Heap und passen nicht mehr auf ihre Seite,
kann SQL Server sie verschieben und einen Forwarded Record hinterlassen.
Praxistipps: forwarded_record_count regelmaessig im Kontext der Workload pruefen
und eine Heap-Umwandlung nur nach Abwaegung der Folgen erwägen.
Hinweis: DBCC SHOWCONTIG ist veraltet; die DMV benoetigt geeignete Rechte.
*/

-- Beispiel: Vorwaertsverweise in einem Heap nach Zeilenveraenderungen untersuchen.

DBCC SHOWCONTIG ('ku'); -- 42186.


-- DBCC SHOWCONTIG ist veraltet; die DMV liefert die aktuellen Indexmetriken.

SELECT *
FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    OBJECT_ID('ku'),
    NULL,
    NULL,
    'DETAILED'
);

-- Ein niedriger Wert ist wuenschenswert; Clustered Indexes haben keine
-- forwarded records, da die Zeilenposition ueber den Index bestimmt wird.
-- Vor dem Erstellen eines Clustered Indexes die Auswirkungen auf Schema,
-- Speicherbedarf und Workload abwaegen.
