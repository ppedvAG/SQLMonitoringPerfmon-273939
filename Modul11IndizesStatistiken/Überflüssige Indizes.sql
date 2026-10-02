/*
Thema: Kandidaten fuer ungenutzte oder ueberfluessige Indexe ermitteln.
Inhalt: Abfrage der Index-Nutzungszaehler fuer Benutzertabellen.
Erklaerung: Indexe verursachen Pflegekosten, waehrend Nutzungszaehler nur
Aktivitaet seit dem letzten Neustart oder Zuruecksetzen abbilden.
Praxistipps: Beobachtungszeitraum, seltene Wartungsjobs und Geschaeftszyklen
beruecksichtigen, bevor Indexe entfernt werden.
Hinweis: Fehlende DMV-Zeilen bedeuten nicht automatisch, dass ein Index ungenutzt ist.
*/

SELECT
   OBJECT_NAME(i.object_id) AS TableName,
   i.type_desc,
   i.name,
   us.user_seeks,
   us.user_scans,
   us.user_lookups,
   us.user_updates,
   us.last_user_scan,
   us.last_user_update
FROM sys.indexes AS i
LEFT JOIN sys.dm_db_index_usage_stats AS us
   ON i.index_id = us.index_id
  AND i.object_id = us.object_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1;
GO

-- Nutzungszaehler gelten seit dem letzten Neustart oder Zuruecksetzen.
-- Niedrige Werte allein sind kein ausreichender Grund, einen Index zu loeschen.

-- Fuer eine umfassendere Analyse kann ein Index-Analysewerkzeug helfen.