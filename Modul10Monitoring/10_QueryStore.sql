/*
Thema: Query Store zur Analyse der Abfrageleistung.
Inhalt: Gespeicherte Abfragen, Plaene, Laufzeitstatistiken und Plan-Forcing.
Erklaerung: Der Query Store bewahrt Leistungsdaten in der Datenbank auf und
ermoeglicht den Vergleich von Abfrageplaenen ueber die Zeit.
Praxistipps: Aufbewahrungsdauer und Speicherlimit passend setzen; Plan-Forcing
beobachten und nicht als Ersatz fuer die Ursachenanalyse verwenden.
Hinweis: Funktionen und Optionen unterscheiden sich je nach SQL-Server-Version.
*/

/*
Funktionen des Query Stores:
Verfolgen von Abfrageleistung im Zeitverlauf:

Der Query Store speichert sowohl die Ausf�hrungspl�ne als auch die Laufzeitstatistiken von Abfragen im Zeitverlauf. Dies erlaubt es, Leistungsprobleme nachzuvollziehen und ihre Entwicklung zu analysieren.
Plan Regressionsanalyse:

Es kann vorkommen, dass der SQL Server aus unbekannten Gr�nden einen weniger effizienten Ausf�hrungsplan verwendet. Der Query Store erm�glicht das Zur�cksetzen auf fr�here, effizientere Pl�ne, um die Leistung wiederherzustellen.
Automatisches Plan-Forcing:

Wenn der Server einen schlechteren Plan w�hlt, kann der Query Store so konfiguriert werden, dass er automatisch zu einem besseren Plan zur�ckkehrt, ohne dass der Administrator eingreifen muss.
Abfrageleistungs-Diagnose:

Durch das Sammeln von Informationen wie Ausf�hrungszeiten, CPU- und Speicherverbrauch sowie Anzahl der gelesenen und geschriebenen Seiten ist es einfacher, problematische Abfragen zu identifizieren und zu optimieren.
Verlaufsspeicherung:

Der Query Store speichert Daten �ber mehrere Datenbankneustarts hinweg und bietet so eine konsistente Sicht auf die Performance-Daten.
Architektur:
Richtiger Speicherort: Der Query Store speichert seine Daten in der Datenbank selbst.
Datenquellen: Es gibt zwei Hauptkategorien von Daten:
Query Text: Der SQL-Text der Abfragen.
Execution Plans: Die Ausf�hrungspl�ne, die der Server f�r die jeweilige Abfrage erstellt hat.
Laufzeitstatistiken: Informationen wie die Ausf�hrungsdauer, CPU- und Speicherverbrauch.
Konfiguration und Nutzung:
Der Query Store kann auf Datenbankebene aktiviert und konfiguriert werden. Dabei k�nnen bestimmte Parameter festgelegt werden, wie z.B. wie lange Abfragedaten aufbewahrt werden sollen oder wie viel Speicherplatz f�r die gesammelten Daten zur Verf�gung steht.

Ein typischer Workflow mit dem Query Store sieht so aus:

Aktivierung des Query Stores auf einer Datenbank.
Sammeln und Analysieren von Leistungsdaten �ber einen Zeitraum.
Identifizierung von regressiven Ausf�hrungspl�nen oder Abfragen mit schlechter Leistung.
Optimierung dieser Abfragen oder Erzwingen besserer Pl�ne durch Plan-Forcing.
Vorteile:
Langfristige �berwachung: Es werden nicht nur aktuelle, sondern auch historische Leistungsdaten gesammelt.
Transparenz: Der Query Store gibt Einblick in die Arbeitsweise des SQL Servers und macht es einfacher, Leistungsengp�sse zu identifizieren und zu beheben.
Problembehebung ohne Unterbrechung: Durch Plan-Forcing k�nnen Probleme oft behoben werden, ohne dass die Datenbank neu gestartet oder andere invasive Ma�nahmen ergriffen werden m�ssen.
Zusammengefasst ist der Query Store ein unverzichtbares Werkzeug f�r das Performance-Tuning und die Diagnose von Abfragen in SQL Server-Datenbanken.
*/