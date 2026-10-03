/*
Zweck: Ueberblick ueber die SQL-Server-Systemdatenbanken.
Die Notizen beschreiben Aufgaben und Sicherungsbedarf von master, model, msdb und tempdb sowie die Folgen von Aenderungen an model. Sie sind Lernmaterial und enthalten kein vollstaendiges Administrationsskript.
*/
/*
Systemdatenbanken

master speichert unter anderem Logins, Datenbanken und Serverkonfigurationen.
Sichere master regelmaessig und nach relevanten Aenderungen.

model dient als Vorlage fuer neu erstellte Datenbanken. Aenderungen an model
wirken sich auf danach angelegte Datenbanken aus.

msdb speichert SQL-Agent-Jobs, Zeitplaene, Warnungen, Proxykonten,
Datenbank-E-Mail, Wartungsplaene und SSIS-Metadaten. Sichere msdb regelmaessig.

tempdb enthaelt temporaere Objekte und Arbeitsdaten, darunter Zeilenversionen.
SQL Server erstellt tempdb beim Start neu; sie wird nicht gesichert.

Weitere Systemdatenbanken sind distribution (bei Replikation) und die
ausgeblendete, schreibgeschuetzte Resource-Datenbank.

Sicherungsbeispiel:
Plane regelmaessige vollstaendige Sicherungen der Systemdatenbanken.
Pruefe Integritaet, verwende nach Moeglichkeit Komprimierung und Checksummen
und richte eine Fehlerbenachrichtigung ein. Das Beispiel unten verwendet
TestDb und lokale Dateipfade; passe es vor der Ausfuehrung an.
*/

-- Vollstaendige Datenbanksicherung.
BACKUP DATABASE [TestDb]
TO DISK = N'C:\_SQLBACKUP\TestDb1.bak'
WITH
    NOFORMAT,
    NOINIT,
    NAME = N'TestDb-Voll',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO
-- Sicherungen koennen beispielsweise als SQL-Agent-Auftrag geplant werden.

-- Differenzielle Sicherung seit der letzten vollstaendigen Sicherung.
BACKUP DATABASE [TestDb]
TO DISK = N'C:\_SQLBACKUP\TestDb.bak'
WITH
    DIFFERENTIAL,
    NOFORMAT,
    NOINIT,
    NAME = N'TestDb-Diff',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO

-- Transaktionsprotokollsicherung; setzt ein passendes Wiederherstellungsmodell voraus.
BACKUP LOG [TestDb]
TO DISK = N'C:\_SQLBACKUP\TestDb.bak'
WITH
    NOFORMAT,
    NOINIT,
    NAME = N'TestDb-Tlog',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO
