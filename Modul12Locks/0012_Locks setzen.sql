/*
Thema: SQL-Server-Sperren und Tabellenhinweise.
Inhalt: Beispiele mit verschiedenen Lock-Hints und expliziten Transaktionen.
Erklaerung: Sperrhinweise beeinflussen das Sperrverhalten und koennen Blockierungen
oder Nebenwirkungen ausloesen; sie ersetzen keine geeignete Isolation.
Praxistipps: Nur in einer Testdatenbank ausfuehren und jede Beispieltransaktion
mit ROLLBACK beenden.
Hinweis: Die Beispiele aktualisieren Preise und greifen auf die Tabelle Products zu.
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

 -- Isolation levels and lock hints address different concurrency problems.

 BEGIN TRANSACTION;
 UPDATE dbo.Products WITH (ROWLOCK)
 SET UnitPrice = UnitPrice * 1.10
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;

 BEGIN TRANSACTION;
 UPDATE dbo.Products WITH (TABLOCK)
 SET UnitPrice = UnitPrice * 1.10
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;

 BEGIN TRANSACTION;
 UPDATE dbo.Products WITH (PAGLOCK)
 SET UnitPrice = UnitPrice * 1.10
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;

 BEGIN TRANSACTION;
 UPDATE dbo.Products WITH (NOWAIT)
 SET UnitPrice = UnitPrice * 1.10
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;

 BEGIN TRANSACTION;
 UPDATE dbo.Products WITH (HOLDLOCK)
 SET UnitPrice = UnitPrice * 1.10
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;

 BEGIN TRANSACTION;
 SELECT *
 FROM dbo.Products WITH (READUNCOMMITTED)
 WHERE ProductID BETWEEN 1 AND 5;
 ROLLBACK TRANSACTION;
