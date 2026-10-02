/*
Thema: Zeilenversionierung mit RCSI und Snapshot Isolation.
Inhalt: Aktivieren von READ_COMMITTED_SNAPSHOT und ALLOW_SNAPSHOT_ISOLATION.
Erklaerung: Leser koennen committed Versionen statt aktuell gesperrter Zeilen
sehen; Versionen beanspruchen Speicher in der Versionsablage.
Praxistipps: tempdb bzw. die konfigurierte Versionsablage beobachten und
Anwendung auf Snapshot-Konflikte testen.
Hinweis: Das Skript aendert Einstellungen von NwindBig und setzt passende Rechte voraus.
*/

-- Transaktionen sperren je nach Zugriff Zeilen, Seiten oder Bereiche.
-- Die gewaehlte Granularitaet haengt unter anderem von Indizes und Auslastung ab.
-- Alternativen sind passende Indizes und zeilenbasierte Versionierung.
-- Versionierung entlastet Leser, verursacht aber Arbeit und Speicherbedarf
-- in der Versionsablage (tempdb bei den hier verwendeten Einstellungen).

USE [master]
GO
ALTER DATABASE [NwindBig] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [NwindBig] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO
ALTER DATABASE [NwindBig] SET ALLOW_SNAPSHOT_ISOLATION ON
GO

/*
RCSI (Anweisungsisolation): Jede Abfrage sieht den committed Stand zum Start
dieser Abfrage. Mehrere Lesevorgaenge innerhalb einer Transaktion koennen
unterschiedliche committed Werte sehen.

Snapshot Isolation (Transaktionsisolation): Die gesamte Transaktion sieht den
Stand zu ihrem Beginn. Sie muss mit SET TRANSACTION ISOLATION LEVEL SNAPSHOT
aktiviert werden und kann bei konkurrierenden Schreibzugriffen Fehler 3960
ausloesen.
*/
