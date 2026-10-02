/*
Thema: Wichtige Windows- und SQL-Server-Perfmon-Leistungsindikatoren.
Inhalt: CPU, Datentraeger, Arbeitsspeicher, Buffer Cache, Plan Cache, Kompilierungen,
Batchanforderungen, Sperren und Latches.
Erklaerung: Leistungsindikatoren liefern Trends und helfen, moegliche Engpaesse
zwischen Betriebssystem und SQL Server einzugrenzen.
Praxistipps: Werte ueber Zeit korrelieren und hostspezifische Baselines bilden,
statt starre Einzelgrenzwerte isoliert anzuwenden.
Hinweis: Viele Kennzahlen sind workloadspezifisch; insbesondere Cache- und
Seitenlebensdauerwerte muessen im Kontext interpretiert werden.
*/

/*

andreasr@ppedv.de

Prozessor: Prozessorzeit
Diese sollte nat�rlich nicht auf Dauer allzu hoch sein. Messunen
�ber 50% bis 60%, sollten abgekl�rt werden (Auslagerungen, Kompilierungen etc)

PhysicalDisk: AverageDiskQueueLength
Dieser Wert sollte auf Dauer nicht �ber 2 sein. Punktuell �ber einen k�rzeren Zeitraum kann ein Wert
von bspw 200 auch normal sein...
Der Wert gibt n�mlich an, ob der physik. Datentr�ger Daten schnell genug wegschreiben kann.

Speicher: Seiten/sec
Seiten, die entweder vom Speicher auf den Datentr�ger geschrieben werden oder davon gelesen und in den Sepicher geschrieben werden. Der Wert sollte auf Dauer kleiner als 20 sein.

BufferManager: BufferCacheHitRatio
Die %-Quote gibt an, wieviel der angefragten Daten (Seiten) aus dem Speichercache
geholt werden k�nnen. Der Wert sollte gr��er 90% sein. Dadurch,
dass der SQL Server jede Menge �Read Ahead Vorg�nge erzeugt,
ist der Wert nicht allzuaussagekr�ftig. Bereits nach Start des SQL Dienstes
weist er einen Wert von kanpp unter 100% aus� obwohl noch keine Daten abgefragt wurden??!!

Plan Cache: Trefferquote
Jede Frage ben�tigt einen Ausf�hrungsplan. Im g�nstigsten Fall liegt dieser bereits vor.
Falls nicht, muss ein neuer Plan erstellt und kompiliert werden.
Das kostet Prozessorzeit.
Falls also die Prozessorleistung sehr hoch ist, sollten sie diesen Wert und
Transactions / sec untersuchen. Die Trefferquote sollte so hoch wie m�glich sein.

GenerelStatitics:
User Connections
Anzahl der Benutzerverbindungen
Blockierte Prozesse
Anzahl der Benutzerverbindungen

SQL Memory Manger:
Freier Speicher
Zielspeicher ist �brgens bei MAX Memory aus den Serversettings

Puffer Manager: Page Life Expectancy  mind 300ssek lt MS
Seiten werden in den Speicher geladen, um die Requests der Clients schnell
bedienen zu k�nnen. Die gecachten Seiten k�nnen aufgrund von zu wenig Platz
zugunsten anderer Seiten aus dem Cache entfernt werden.
Der Wert sollte nicht unter 300 liegen. Sonst haben Sie zu wenig Hauptspeicher
Ein S�gezhanmuster nach Neustart des SQL Servs ist durchaus normal.
Neue Daten senken den Schnitt..


SQL Statistics: Kompilierungen /sec
Ausf�hrungspl�ne bed�rfen einer kompilierung und evtl auch einer Recompilierung.
Diese f�hrt zu einer h�heren CPU Last. Sollte dieser Wert sich erh�hen, k�nnen Sie evtl durch paramtriesierung ihrer Abfragen eine Verbesserung erreichen.

SQL Statistics: Recompilierungen /sec
Dieser Wert steigt, sobald kompilierte Pl�ne durch verschiedene SET Einstellungen erneut kompiliert werden m�ssen.

SQL Statistics:
Batchanforderungen pro Sekunde
Was muss der SQL Server aktuell leisten ..bei wieviel Usern

SQL Benutzerdefinierbar: User Counter 1 (bis 10)
Ein Indikator der mir pers�nlich sehr gut gef�llt. �bergibt man der sp_Usercounter1 eine ganze Zahl  so wird diese sofort im Systemmonitor dargestellt. SO lie�e sich z.B. der Tagesumsatz im Verh�ltnis zur CPU oder Speicher darstellen. In Worten: Ab einem bestimmten  Umsatz proTag braucht man eine besser CPU.

SQL Locks: durschnittliche Wartezeit (ms)

SQL Latches:
Durchschnittliche Wartezeit (ms)
Greift ein Thread auf eine Seite zu, dann muss ein anderer Prozess,
der auf die gleiche Seite zugreifen m�chte, auf diesen Warten.
Man k�nnte sie auch Systemlocks nennen..:-)

SQL
*/
