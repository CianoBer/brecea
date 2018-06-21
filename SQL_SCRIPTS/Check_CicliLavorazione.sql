
-- Controlla integrità referenziale delle tabelle macchine, centri di lavoro e operazioni, 
-- nelle righe dei cicli di lavorazione

-- TABELLAMACCHINE
select tcp.codciclo, aa.descrizione,  rcp.macchina, rcp.dscoperazione from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	inner join anagraficaarticoli aa on tcp.codciclo = aa.codice
	left outer join TABELLAMACCHINE TMA on rcp.macchina = tma.codice
	where tma.codice is null
order by rcp.macchina

select distinct rcp.macchina from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	left outer join TABELLAMACCHINE TMA on rcp.macchina = tma.codice
	where tma.codice is null
order by rcp.macchina

-- from TABELLACDLAVORO
select tcp.codciclo, aa.descrizione, rcp.cdlavoro, rcp.dscoperazione from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	inner join anagraficaarticoli aa on tcp.codciclo = aa.codice
	left outer join TABELLACDLAVORO CDL on rcp.cdlavoro = cdl.codice
	where cdl.codice is null
order by rcp.cdlavoro

select distinct  rcp.cdlavoro from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	left outer join TABELLACDLAVORO CDL on rcp.cdlavoro = cdl.codice
	where cdl.codice is null
order by rcp.cdlavoro

-- TABELLAOPERAZIONI
select tcp.codciclo, aa.descrizione, rcp.operazione, rcp.dscoperazione from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	left outer join TABELLAOPERAZIONI OPE on rcp.operazione = ope.codice
	inner join anagraficaarticoli aa on tcp.codciclo = aa.codice
	where ope.codice is null
order by rcp.operazione

select distinct rcp.operazione from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	left outer join TABELLAOPERAZIONI OPE on rcp.operazione = ope.codice
	where ope.codice is null
order by rcp.operazione

-- CHECK OPERAZIONI SENZA CENTRO DI LAVORO
select codice, descrizione from tabellaoperazioni where CODICECDL is null

select tcp.codciclo, aa.descrizione, rcp.operazione, rcp.dscoperazione from RIGHECICLOPROD RCP
	inner join TESTACICLOPROD TCP on rcp.progressivo = tcp.progressivo
	inner join anagraficaarticoli aa on tcp.codciclo = aa.codice
	where rcp.cdlavoro = '' or rcp.cdlavoro is null
order by rcp.operazione