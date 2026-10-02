/*
Thema: Zeilenversionierung mit RCSI und Snapshot Isolation.
Inhalt: Aktivieren von READ_COMMITTED_SNAPSHOT und ALLOW_SNAPSHOT_ISOLATION.
Erklaerung: Leser koennen committed Versionen statt aktuell gesperrter Zeilen
sehen; Versionen beanspruchen Speicher in der Versionsablage.
Praxistipps: tempdb bzw. die konfigurierte Versionsablage beobachten und
Anwendung auf Snapshot-Konflikte testen.
Hinweis: Das Skript aendert Einstellungen von NwindBig und setzt passende Rechte voraus.
*/

--Standardm��g werden bei Transactions der reihe nach Datens�tze Tabellen Seiten Partitionen gesperrt
--Das Sperrniveau ist sehr starlk von der IX Qualit�t abh�ngig. Wie finde ich den DS?
--SQL hebt allerdings das SPerrniveau, wenn viele Einzelsperren zu teuer werden

--Alternativen Locks zu umgehen
--bessere Indizes
--READ UNCOMMITTED.. Lesen des gerade sich ver�ndernden DS
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


RCSI (Statement-Level): Jede Abfrage sieht den committed Stand zum Start der Abfrage. Liest du in einer Transaktion zweimal dieselbe Zeile, kann sie sich dazwischen �ndern (Non-Repeatable Read). Keine Code-�nderung in Apps n�tig.

Snapshot Isolation (Transaction-Level): Die gesamte Transaktion sieht starr den Stand zum Start der Transaktion. Doppeltes Lesen liefert garantiert dasselbe Ergebnis. Erfordert explizites SET TRANSACTION ISOLATION LEVEL SNAPSHOT und erzeugt Update-Konflikte (Fehler 3960) bei gleichzeitigen Schreibzugriffen auf dieselbe Zeile.

