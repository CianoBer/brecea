if exists (select 1 from sysobjects where name='_aaa_')
      drop table _aaa_
go

select 
      RIGHEDOCUMENTI.IDTESTA,
      RIGHEDOCUMENTI.IDRIGA,
      datadoc,
      year(datadoc) as AnnoDoc,
      month(datadoc) as MeseDoc,
      righedocumenti.annoiniziocomp,
      righedocumenti.meseiniziocomp
into
      _aaa_
from 
      testedocumenti left outer join righedocumenti on
      testedocumenti.progressivo=righedocumenti.idtesta left outer join parametridoc on
      testedocumenti.tipodoc=parametridoc.codice
where 
      year(datadoc)<>righedocumenti.annoiniziocomp and 
      month(datadoc)<>righedocumenti.meseiniziocomp and
      testedocumenti.esercizio=2009 and
      parametridoc.tipo in ('F','B') and
      RIGHEDOCUMENTI.TIPORIGA in ('N','V')
go

-- salvo la tabella righedocumenti per backup
if exists (select 1 from sysobjects where name='_righedoc_')
      drop table _righedoc_
go
select * into _righedoc_ from righedocumenti
go

--aggiorno i campi
update righedocumenti set annoiniziocomp=_aaa_.AnnoDoc
      from righedocumenti inner join _aaa_ on RIGHEDOCUMENTI.IDTESTA=_aaa_.idtesta and RIGHEDOCUMENTI.IDRIGA=_aaa_.idriga
go

update righedocumenti set meseiniziocomp=_aaa_.MeseDoc
      from righedocumenti inner join _aaa_ on RIGHEDOCUMENTI.IDTESTA=_aaa_.idtesta and RIGHEDOCUMENTI.IDRIGA=_aaa_.idriga
go
