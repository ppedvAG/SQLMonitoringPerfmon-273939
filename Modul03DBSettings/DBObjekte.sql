						  /*
wir können mit Hilfe veschiedener Objekte diesseleben Ergennisse bekommen
Aber was ist schneller: F() , Porz , Adhoc oder Sicht

--Was kann man dort falsch machen?

--Gerüchte sagen: Prozedur ist schnell.. aber warum?.. Angeblich kompiliert
--Funktionen sind schnell, nö... langsam.. nun was denn?
--Sichten sind langsam, da sie erst einn "Umweg" nehmen müssen
--adhoc .. nicht so besonders schnell

--Antwort: es kommt darauf an: Die gerüchte sind schon richtig, aber nur 
--wenn:
		--die Rahmenbedingungen passen




*/

--use northwind

select * from customers

--customerid = nchar(5)

--a) Proz  b) Sicht c) adhoc d) F()

---------------------schnell
--c --> b --> d --> a

--d   ---> c|b    --> a
--a                           --> d --> c|b

exec gpKDSuche 'ALFKI' -- 1 DS
exec gpKDSuche 'A' -- 4 DS
exec gpKDSuche -- alle 91 DS


--customerid = nchar(5)


create proc gpKDSuche  @kdid varchar(5)='%'
as
select * from customers where customerid like @kdid +'%'   

exec gpKdSuche 

--Robert:
create
--alter
procedure gpKDSuche
(
    @key varchar(5) = null
)
--with recompile
as begin
    select * from customers
    where (len(@key) = 5 and customerid = @key)
    or (len(rtrim(@key)) < 5 and customerid like @key + '%')
    or @key is null
end
go



--beide schlecht..Lösung siehe unten



--Sicht 

create table slf (id int identity, stadt int, land int);
GO

--Eine Sicht, die alle Spalten der tabelle slf zurückgibt
--Sichtname: vslf

create view vslf
as
select id, stadt, land from slf


create view vslf
as
select * from slf


select * from vslf

insert into slf 
select 10,100
UNION ALL
select 20,200
UNION ALL
select 30,300

select * from vslf

--neue Spalte FLuss
alter table slf add fluss int

update slf set fluss = id * 1000

select * from slf

select * from vslf
 --kein Fluss: Sicht merkt sich Ausgabeschema

 alter table slf drop column Land

 select * from vslf
--Die Werte von Fluss erscheinen in der nicht vorhanden Spalte Land
--das darf nicht passieren

--Idee schemabinding: zwingt zum genauen arbeiten
-- * verboten
--Pflicht: Angabe des Schema
--abhängige Objekte kann man nicht merh verändern

drop table slf
drop view vslf

create view vslf with schemabinding
as
select id, stadt, land from dbo.slf


select * from vslf

insert into slf 
select 10,100
UNION ALL
select 20,200
UNION ALL
select 30,300

select * from vslf

--neue Spalte FLuss
alter table slf add fluss int

update slf set fluss = id * 1000

select * from slf

select * from vslf
 --kein Fluss: Sicht merkt sich Ausgabeschema

 --nicht mehr möglich
 /*
 Sichten . .. besser mit schemabinding
	müssen korrekt verarbeitet werden

		nicht zweckentfremden: wenn Sicht 65 Joins hat , 
			aber Abfrage braucht nur 2 Tabellen
 
 */
 
 alter table slf drop column Land





 select * from vslf


 ---schemabinding schärfere Kontrolle


 --Sichte schneller oder langsamer
 --grundsätzlich egal: identisch wie adhoc.. gleich schnell, aber was wenn


 select top 3 * from kundeumsatz
 --wir suchen alle Kunden aus Frankreich die weniger als 30 Frachtkosten hatten


 --Sicht nicht zweckentfremden
 ---wenn die 5 tabellen joined ,dann wird sie das immer tun
 select distinct companyname 
 from kundeumsatz where Country = 'France' and freight < 30
 set statistics time on

 select distinct  companyname from customers c inner join orders o
				on o.CustomerID=c.CustomerID
				where country = 'France' and Freight< 30



select * from orders Where orderid = 300000




