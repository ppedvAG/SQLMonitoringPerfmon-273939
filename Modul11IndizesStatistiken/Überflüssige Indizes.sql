/*
Thema: Kandidaten fuer ungenutzte oder ueberfluessige Indexe ermitteln.
Inhalt: Abfrage der Index-Nutzungszaehler fuer Benutzertabellen.
Erklaerung: Indexe verursachen Pflegekosten, waehrend Nutzungszaehler nur
Aktivitaet seit dem letzten Neustart oder Zuruecksetzen abbilden.
Praxistipps: Beobachtungszeitraum, seltene Wartungsjobs und Geschaeftszyklen
beruecksichtigen, bevor Indexe entfernt werden.
Hinweis: Fehlende DMV-Zeilen bedeuten nicht automatisch, dass ein Index ungenutzt ist.
*/

--�berfl�ssige Indizes identifizieren

--kosten Performance bei INSERT / DELETE

--Systemsichten
-- select * from sys.dm_db_index_physical_Stats verkn�pft mikt sys.indexes


select object_name(i.object_id) as TableName
      ,i.type_desc,i.name
      ,us.user_seeks, us.user_scans
      ,us.user_lookups,us.user_updates
      ,us.last_user_scan, us.last_user_update
  from sys.indexes as i
       left outer join sys.dm_db_index_usage_stats as us
                    on i.index_id=us.index_id
                   and i.object_id=us.object_id
 where objectproperty(i.object_id, 'IsUserTable') = 1
go

--Optimierer entscheidet sich f�r Index-scan , wenn die der g�nstiger als Table-scan ist
-- user_scan, index_scan  ..nie gebrauchte Indizes evtl l�schen
-- user_scan, index_scan  .. besser als table scan


-- Brent Ozar SP_blitzIndex

