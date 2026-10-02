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

 --set transaction isolation level read uncommitted (Lesen trotz update)
 --                                     repeatable read (nur lesen, kein Update, aber insert
 --                                     Serializable  (kein Insert)   
Begin tran
UPDATE Products 
WITH (Rowlock)  
SET Unitprice = Unitprice * 1.10  
WHERE ProductID between 1 and 5;  
rollback

Begin tran
UPDATE Products 
WITH (tablock)  
SET Unitprice = Unitprice * 1.10  
WHERE ProductID between 1 and 5;  
rollback


Begin tran
UPDATE Products 
WITH (pagLock)  
SET Unitprice = Unitprice * 1.10  
WHERE ProductID between 1 and 5;  
rollback

Begin tran
UPDATE Products 
WITH (Nowait)  
SET Unitprice = Unitprice * 1.10  
WHERE ProductID between 1 and 5;  
rollback


Begin tran
UPDATE Products 
WITH (Holdlock)  
SET Unitprice = Unitprice * 1.10  
WHERE ProductID between 1 and 5;  
rollback



Begin tran
select * from Products 
WITH (readuncommitted)  
WHERE ProductID between 1 and 5;  
rollback

