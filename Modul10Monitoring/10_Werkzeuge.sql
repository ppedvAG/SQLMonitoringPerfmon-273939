/*
Thema: Werkzeuge fuer SQL-Server- und Betriebssystem-Monitoring.
Inhalt: Aktivitaetsmonitor, DMVs, Profiler, Perfmon, Systemfunktionen,
Extended Events und Database Tuning Advisor.
Erklaerung: Die Werkzeuge unterscheiden sich bei Detailgrad, Historie und
Systemlast; die Wahl richtet sich nach Diagnoseziel und Umgebung.
Praxistipps: Extended Events fuer neue Trace-Szenarien bevorzugen und
Empfehlungen des Tuning Advisors vor einer Umsetzung pruefen.
Hinweis: Historische Werte koennen nach Neustarts fehlen; wichtige Daten
gezielt und mit begrenztem Overhead sammeln.
*/

/*
1. Aktivit�tsmonitor
Wann einsetzen:
Schnelle Ad-hoc-Diagnose, wenn z. B. eine Anwendung �h�ngt� oder pl�tzliche Performanceprobleme auftreten.
Um Live-�bersicht zu Sessions, Sperren, Ausf�hrungspl�nen und Ressourcennutzung zu bekommen.

Vorteile:
Sofort verf�gbar, visuell, einfach zu bedienen.
Gut f�r Einsteiger oder schnelle Checks.

Nachteile:
Erh�ht leicht den Overhead auf dem Server.
Kein Logging �ber l�ngere Zeit.
Eingeschr�nkte Detailtiefe.

2. Dynamische Verwaltungssichten (DMVs)
Wann einsetzen:
F�r detaillierte Analysen direkt in T-SQL.
Bei Performance Tuning (z. B. Abfrage-Statistiken, Index-Nutzung, Wait-Statistiken).
F�r eigene Monitoring-Skripte oder Berichte.
Vorteile:
Sehr granular, flexibel kombinierbar.
Kein oder kaum sp�rbarer Overhead.
Nachteile:
Erfordert SQL-Know-how.
Viele Werte sind Momentaufnahmen oder werden beim Server-Neustart zur�ckgesetzt.

3. Ablaufverfolgung & SQL Server Profiler
(Legacy � heute eher XEvents bevorzugen)
Wann einsetzen:
Wenn �ltere Skripte oder Prozesse zwingend Profiler nutzen.
F�r zielgerichtete Nachverfolgung einzelner Abfragen oder Events in Testumgebungen.
Vorteile:
Einfach einzurichten, sofortige Live-Anzeige.
Nachteile:
Hoher Overhead in produktiven Systemen.
Microsoft stuft es als veraltet ein � f�r neue Szenarien besser XEvents nutzen.

4. Windows Systemmonitor (Perfmon)
Wann einsetzen:
Wenn SQL Server- und OS-Metriken gemeinsam betrachtet werden m�ssen (CPU, RAM, Disk-I/O, Netzwerk).
F�r Langzeitaufzeichnungen und historische Performance-Analysen.
Vorteile:
Betriebssystem- und SQL-Leistungsindikatoren in einem Tool.
Sehr geringe Systemlast, ideal f�r Dauerlogging.
Nachteile:
Weniger tiefe SQL-spezifische Details.
Auswertung kann sperrig sein (CSV-Export/Analyse n�tig).

5. Statistische Systemfunktionen
Wann einsetzen:
F�r schnelle Einzelwerte oder Ad-hoc-Abfragen innerhalb von Skripten.
Wenn DMVs zu �schwer� erscheinen und nur ein konkreter Wert gebraucht wird (z. B. @@CPU_BUSY, @@IO_BUSY, @@PACK_RECEIVED).
Vorteile:
Extrem schnell, keine Zusatzlast.
Leicht in Skripte integrierbar.
Nachteile:
Sehr begrenzte Aussagekraft.
Keine Historie oder Korrelation mit anderen Daten.

6. Extended Events (XEvents)
Wann einsetzen:
F�r moderne, flexible und performante Event-Nachverfolgung.
Um lang laufende Abfragen, Deadlocks, Wait-Events oder bestimmte Fehler pr�zise zu loggen.
Wenn Profiler-Funktionalit�t ben�tigt wird � aber effizienter.
Vorteile:
Geringer Overhead, auch produktiv nutzbar.
Sehr granular konfigurierbar.
Speicherung im Ring-Buffer oder Datei m�glich.
Nachteile:
Einarbeitung n�tig (GUI in SSMS oder T-SQL-Definitionen).


7. Datenbankoptimierungsratgeber

Der Datenbankoptimierungsratgeber (Database Tuning Advisor, DTA) ist ein Tool 
, das Empfehlungen zur Verbesserung der Abfrageleistung gibt. 
Der Query Store (QS) ist eine Funktion, die Verlaufsdaten zu Abfragen 
und Ausf�hrungspl�nen aufzeichnet und es Ihnen erm�glicht, 
Leistungs�nderungen zu �berwachen und Probleme zu diagnostizieren.


Der Datenbankoptimierungsratgeber (DTA) ist im Wesentlichen ein Analyse- 
und Empfehlungstool. Sie "f�ttern" ihn mit einer Sammlung von SQL-Abfragen 
(einer "Workload"), und der DTA analysiert diese Workload im Kontext 
Ihres aktuellen Datenbankschemas (Tabellen, vorhandene Indizes usw.).

Basierend auf dieser Analyse gibt der DTA konkrete Empfehlungen ab, 
um die Gesamtleistung dieser Workload zu optimieren.

Die Hauptaufgaben und Empfehlungen des DTA sind:

Index-Empfehlungen: Dies ist die h�ufigste Verwendung. 
Der DTA schl�gt vor:

Neue Indizes zu erstellen (geclustert, nicht geclustert, 
gefiltert und Columnstore).

Bestehende Indizes zu l�schen, die redundant sind 
oder nicht verwendet werden.

Indizierte Sichten zu erstellen, um komplexe Aggregationen 
oder Joins zu beschleunigen.

Statistiken: Er kann das Erstellen oder Aktualisieren 
von Spaltenstatistiken empfehlen, um dem Abfrageoptimierer 
bessere Informationen f�r die Planerstellung zu geben.

Partitionierung: Bei sehr gro�en Tabellen kann der DTA Strategien 
zur horizontalen Partitionierung vorschlagen.

Der DTA kann den Query Store als direkte Workload-Quelle verwenden. 
Anstatt m�hsam eine Trace-Datei zu erstellen, k�nnen Sie dem DTA 
einfach sagen, er soll die "Top 1000" teuersten Abfragen direkt
aus dem Query Store analysieren. Dies ist oft der effizienteste Weg, 
um die realen, aktuellen Leistungsprobleme Ihrer Datenbank zu finden 
und zu beheben.


1 .QueryStore als Quelle w�hlen.
2. Auslastungs DB w�hlen , um Ergbnisse des DTA zu zwischenspeichern
3. DB ausw�hlen und alle Tabelle angeben
4. Alle Indizes w�hlen evtl auch gefiltert und Columnstore
   Tipp:: Erweiterte optionen. Max empfohlenen Speicherplatz aktivieren
			und Wert �bernehmen 
5. Analyse starten
6. nie abbrechen!
7. Empfehlungen untersuchen (Berichte und SQL Skripte generieren)
*/
