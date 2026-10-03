/*
Zweck: Grundlagen und Beispiele zu Wiederherstellungsmodellen, Sicherungen und Restore.
Die Notizen vergleichen vollstaendige, differenzielle und Transaktionsprotokollsicherungen und skizzieren typische Wiederherstellungsfaelle. Die Beispiele verwenden Northwind und lokale Pfade; passe sie an eine gepruefte Sicherungsstrategie an und teste Wiederherstellungen regelmaessig.
*/
/*
Wiederherstellungsmodelle

SIMPLE: Das Transaktionsprotokoll wird nach einem Checkpoint wiederverwendbar.
Transaktionsprotokollsicherungen und Wiederherstellungen zu einem Zeitpunkt
sind in diesem Modell nicht moeglich.

BULK_LOGGED: Bestimmte Massenvorgaenge werden minimal protokolliert. Regelmaessige
Protokollsicherungen bleiben erforderlich; die Wiederherstellung zu einem
Zeitpunkt innerhalb einer Protokollsicherung mit minimal protokollierten
Vorgaengen kann eingeschraenkt sein.

FULL: Transaktionen werden vollstaendig protokolliert. Zusammen mit einer
durchgaengigen Sicherungskette aus Transaktionsprotokollsicherungen ist eine
Wiederherstellung zu einem Zeitpunkt moeglich.

Sicherungsarten

Vollstaendig (V): Sichert die Datenbank zum Sicherungszeitpunkt.
Differenziell (D): Enthaelt die seit der letzten vollstaendigen Sicherung
geaenderten Daten.
Transaktionsprotokoll (T): Sichert Protokollinformationen seit der letzten
Protokollsicherung und haelt die Sicherungskette aufrecht.

Planung und Wiederherstellung

Lege Sicherungsintervalle anhand des maximal tolerierbaren Datenverlusts und
der maximalen Wiederherstellungszeit fest. Differenzielle Sicherungen koennen
die Anzahl der erforderlichen Schritte beim Restore reduzieren. Uebe
Wiederherstellungen regelmaessig und dokumentiere die Reihenfolge.

Typische Wiederherstellungsfaelle sind ein Serverausfall, beschaedigte
Datenbankdateien oder versehentlich geaenderte Daten. Abhaengig vom Fehler
werden Sicherungen auf demselben oder einem anderen Server wiederhergestellt;
bei versehentlichen Aenderungen kann eine separate Wiederherstellung unter
einem anderen Datenbanknamen die Datenrettung ermoeglichen.
*/

-- Vollstaendige Datenbanksicherung.
BACKUP DATABASE [Northwind]
TO DISK = N'C:\_SQLBACKUP\northwind.bak'
WITH
    NOFORMAT,
    NOINIT,
    NAME = N'Northwind-Vollstaendig',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO

-- Differenzielle Sicherung seit der letzten vollstaendigen Sicherung.
BACKUP DATABASE [Northwind]
TO DISK = N'C:\_SQLBACKUP\northwind.bak'
WITH
    DIFFERENTIAL,
    NOFORMAT,
    NOINIT,
    NAME = N'Northwind-Differenziell',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO

-- Transaktionsprotokollsicherung; Northwind muss FULL oder BULK_LOGGED verwenden.
BACKUP LOG [Northwind]
TO DISK = N'C:\_SQLBACKUP\northwind.bak'
WITH
    NOFORMAT,
    NOINIT,
    NAME = N'Northwind-Tlog',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10;
GO


/*
Beispiel einer Sicherungsfolge: Vollsicherung um 06:00 Uhr, danach
regelmaessige Transaktionsprotokollsicherungen. Bei einem Fehler um 10:34 Uhr
ist der erreichbare Wiederherstellungspunkt vom Zustand der Sicherungskette
und einer moeglichen Protokollfragmentsicherung abhaengig.

Fuer eine Wiederherstellung unter einem anderen Namen muessen auch die
Dateipfade angepasst werden. Bei einer Wiederherstellung der vorhandenen
Datenbank muessen Verbindungen getrennt und die passenden Restore-Optionen
verwendet werden. Pruefe die genaue Vorgehensweise vor dem Notfall.
*/

-- Vorlage fuer einen Datenbank-Snapshot; Werte an die Quelldatenbank anpassen.
USE [master];
GO

CREATE DATABASE [SnapshotDBName]
    ON
    (
        NAME = [OrigDB],
        FILENAME = N'C:\_SQLDB\SnapshotDBName.mdf'
    )
    AS SNAPSHOT OF [OrigDB];
GO

-- Snapshot der Northwind-Beispieldatenbank.
CREATE DATABASE [SN_Northwind_1152]
    ON
    (
        NAME = N'Northwind',
        FILENAME = N'C:\_SQLDB\SN_Northwind_1152.mdf'
    )
    AS SNAPSHOT OF [Northwind];
GO


-- Stellt Northwind auf den Stand des Snapshots zurueck.
RESTORE DATABASE [Northwind]
FROM DATABASE_SNAPSHOT = [SN_Northwind_1152];





		