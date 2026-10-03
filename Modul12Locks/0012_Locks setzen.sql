/*
Zweck: Demonstration von Sperrhinweisen und deren Auswirkungen auf T-SQL-Abfragen.
Die Beispiele vergleichen unter anderem ROWLOCK, TABLOCK, PAGLOCK, NOWAIT und HOLDLOCK; Aenderungen werden jeweils zurueckgerollt. Fuehre die Beispiele nur in einer geeigneten Testdatenbank aus und beachte, dass Sperrhinweise keine allgemeine Leistungsoptimierung darstellen.
*/
----
-- LOCKS
-- UPDLOCK, TABLOCKX
-- PAGLOCK, ROWLOCK, TABLOCK
-- HOLDLOCK   
 --NOLOCK   
 --NOWAIT  
 --READCOMMITTED
 --READUNCOMMITTED

 ---

-- READ UNCOMMITTED erlaubt Dirty Reads; REPEATABLE READ verhindert Updates,
-- aber nicht alle Inserts. SERIALIZABLE schuetzt auch den gelesenen Wertebereich.

-- Fordert Zeilensperren an; der Rollback verwirft die Beispielaenderung.
BEGIN TRANSACTION;
UPDATE Products WITH (ROWLOCK)
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;

-- Fordert eine Tabellensperre an.
BEGIN TRANSACTION;
UPDATE Products WITH (TABLOCK)
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;

-- Fordert Seitensperren an.
BEGIN TRANSACTION;
UPDATE Products WITH (PAGLOCK)
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;

-- NOWAIT bricht die Anweisung sofort ab, falls eine inkompatible Sperre besteht.
BEGIN TRANSACTION;
UPDATE Products WITH (NOWAIT)
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;

-- HOLDLOCK behaelt die Sperren bis zum Ende der Transaktion.
BEGIN TRANSACTION;
UPDATE Products WITH (HOLDLOCK)
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;

-- READUNCOMMITTED liest ohne gemeinsam genutzte Sperren und kann Dirty Reads liefern.
BEGIN TRANSACTION;
SELECT *
FROM Products WITH (READUNCOMMITTED)
WHERE ProductID BETWEEN 1 AND 5;
ROLLBACK;