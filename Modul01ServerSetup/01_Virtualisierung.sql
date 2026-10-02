/*
Thema: SQL Server in virtualisierten Umgebungen.
Inhalt: CPU-, NUMA-, Arbeitsspeicher- und Datentraegerzuordnung.
Erklaerung: Die Beispiele verdeutlichen, dass eine VM dieselben Ressourcen-
engpaesse wie ein physischer Server haben kann und Host und Gast zusammenwirken.
Praxistipps: Genug RAM fuer das Gastbetriebssystem reservieren und Datentraeger-
Durchsatz sowie NUMA-Zuordnung pruefen.
Hinweis: Die Beispielwerte sind keine allgemeingueltige Dimensionierung.
*/

/*
Fragen , die man sich stellen sollte:

Hat die VM auch die Ressourcen
, die sie auch ohne Virtualisierung h�tte?
 


Ziel Nr 1 (neben genug RAM)		 

HDD!!!!!! optimieren. 

IO reduzieren!!! IO schneller machen


jeweniger IO desto weniger...RAM und desto weniger CPU
IO-->CPU

Virtualisierung--> Konsolidierung--> genug HDD Power?

Goldene Regel:

Trenne Log von Daten physikalisch! ..und das pro DB !

CPU

! Bilde in der VM die reale Umgebung ab..

NUMA: 
NUMA Architektur...zu jedem RAM Sockel (Knoten) geh�rt ein bestimmter Prozessor
	Vorteil der ZUgriff ist sehr schnell
	Zugriff auf RAM eines anderen Sockel h�here Latenzzeit
      
Was, wenn die Architekur in VM was anderes sieht
, als es in der realit�t ist..
Ausnahme: Lizenzgr�nde: SQL Express 1 Sockel 4 Kerne
					    Standard 4 Sockel 24 Kerne


RAMVERTEILUNG bei VMs
Beachte immer das Gast OS! Mind 4 GB gedanklich reservieren..

Aktuelle Ausstattung
16 GB RAM 1 Socket 1 CPU mit 2 Kernen und 4 log Prozessoren

F�r das vorreservieren: 4 GB

16-4GB= 12GB zu verteilen

HV-DC:   dynamischer Speicher 1024 als Startwert bis max 2048 MB  2 CPU

12GB-2GB= 10GB

HV-SQL1: fixer Speicher im Fall von SQL Server 6 GB  4 CPUs

10-2048-6 = 4GB

HV-SQL2: fixer Speicher 4 GB    4 CPUs


NUMA Zuweisung beachten


*/