/*
Zweck: Erlaueterung der Momentaufnahmeisolation und zeilenversionierter Lesezugriffe.
Die Notizen behandeln Sperren, READ UNCOMMITTED, Snapshot Isolation und moegliche Belastung von tempdb. Die enthaltenen Datenbankoptionen aendern das Laufzeitverhalten und muessen vor dem Einsatz mit Anwendungen und Speicherbedarf abgestimmt werden.
*/
--Standardmäßg werden bei Transactions der reihe nach Datensätze Tabellen Seiten Partitionen gesperrt
--Das Sperrniveau ist sehr starlk von der IX Qualität abhängig. Wie finde ich den DS?
--SQL hebt allerdings das SPerrniveau, wenn viele Einzelsperren zu teuer werden

--Alternativen Locks zu umgehen
--bessere Indizes
--READ UNCOMMITTED.. Lesen des gerade sich verändernden DS
--Zeilenversionierung
--man liest den Wert , wie er vor beein tran war bis ein commit einsetzt

--!!!!! Die DS werden in tempdb kopiert --> hohe TRaffice evtl..

--Aktivieren der Momenaufnahmenisolation

USE [master]
GO
ALTER DATABASE [NwindBig] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [NwindBig] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO
ALTER DATABASE [NwindBig] SET ALLOW_SNAPSHOT_ISOLATION ON
GO


RCSI (Statement-Level): Jede Abfrage sieht den committed Stand zum Start der Abfrage. Liest du in einer Transaktion zweimal dieselbe Zeile, kann sie sich dazwischen ändern (Non-Repeatable Read). Keine Code-Änderung in Apps nötig.

Snapshot Isolation (Transaction-Level): Die gesamte Transaktion sieht starr den Stand zum Start der Transaktion. Doppeltes Lesen liefert garantiert dasselbe Ergebnis. Erfordert explizites SET TRANSACTION ISOLATION LEVEL SNAPSHOT und erzeugt Update-Konflikte (Fehler 3960) bei gleichzeitigen Schreibzugriffen auf dieselbe Zeile.