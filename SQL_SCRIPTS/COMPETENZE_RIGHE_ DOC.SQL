if exists (select 1 from sysobjects where name='_aaa_')
      drop table _aaa_
go

select
	rd.IDTESTA,
	rd.IDRIGA,
	td.tipodoc,
	td.numerodoc,
	td.datarifdoc,
	year(td.datarifdoc) as AnnoDoc,
	month(td.datarifdoc) as MeseDoc,
	rd.annofinecomp,
	rd.mesefinecomp
into
      _aaa_
from 
      testedocumenti td left outer join righedocumenti rd on td.progressivo=rd.idtesta 
      left outer join parametridoc pd on td.tipodoc=pd.codice
where 
	(right('00000'+cast(year(td.datarifdoc) as varchar),5)+right('00000'+cast(month(td.datarifdoc) as varchar),5))<>
	(right('00000'+cast(rd.annofinecomp as varchar),5)+(right('00000'+cast(rd.mesefinecomp as varchar),5))) and
	td.esercizio=2009 and
	pd.tipo in ('F','B') and
	rd.TIPORIGA in ('N','V') and datadoc>='08/03/2009'
go

-- salvo la tabella righedocumenti per backup
if exists (select 1 from sysobjects where name='_righedoc_')
      drop table _righedoc_
go
select * into _righedoc_ from righedocumenti
go

--aggiorno i campi
update righedocumenti set annofinecomp=_aaa_.AnnoDoc
      from righedocumenti inner join _aaa_ on RIGHEDOCUMENTI.IDTESTA=_aaa_.idtesta and RIGHEDOCUMENTI.IDRIGA=_aaa_.idriga
go

update righedocumenti set mesefinecomp=_aaa_.MeseDoc
      from righedocumenti inner join _aaa_ on RIGHEDOCUMENTI.IDTESTA=_aaa_.idtesta and RIGHEDOCUMENTI.IDRIGA=_aaa_.idriga
go
select * from _aaa_ order by datarifdoc desc




