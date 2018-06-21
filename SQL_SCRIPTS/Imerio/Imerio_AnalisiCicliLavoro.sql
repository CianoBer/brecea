

--**********************************************************
--* CICLI CON FASI AVENTI TEMPO RISORSA (TEMPO MACCHINA) = 0
--*	IMERIO 11/07/2011
--**********************************************************
select tp.codciclo, rp.operazione, rp.dscoperazione 
from righecicloprod rp
inner join  testacicloprod tp on rp.progressivo = tp.progressivo
where rp.calcolotempomacchina = '0'
and codciclo > '1000000'



--****************************************************
--* DATA UNA DISTINTA ESTRAE I COMPONENTI DI
--* PRIMO LIVELLO DOTATI DI CICLO E NE VISUALIZZA
--* LE FASI CON I TEMPI ASSEGNATI
--*	IMERIO 13/07/2011
--****************************************************
select tp.codciclo, db.descrizione, rp.operazione, rp.dscoperazione, 
rp.calcolotemposetup as setup, rp.calcolotempomacchina as risorsa, rp.calcolotempouomo as manodopera 
from righecicloprod rp
inner join  testacicloprod tp on rp.progressivo = tp.progressivo
left join distintabase db on tp.codciclo = db.codartcomponente
left join distintaartcomposti da on db.rifprogressivo = da.progressivo
where da.artcomposto = '00y0835' -- CODICE DISTINTA
--and operazione in ('12501', '12601','12701','13001') --solo operazioni di montaggio meccanico/elettrico
order by db.seqassemblaggio, tp.codciclo


--****************************************************
--* DATA UNA DISTINTA ESTRAE I COMPONENTI DI
--* PRIMO LIVELLO NON DOTATI DI CICLO 
--*	IMERIO 13/07/2011
--****************************************************
select db.codartcomponente, DB.DESCRIZIONE 
FROM distintabase db
left join distintaartcomposti da on db.rifprogressivo = da.progressivo
where (select codciclo from testacicloprod where codartcomponente = codciclo) is null  -- non c'è ciclo associato
and da.artcomposto = '00y0835' -- CODICE DISTINTA
order by db.seqassemblaggio, db.codartcomponente


--****************************************************
--* DATO UN CICLO DI LAVORO ESTRAE 
--* LE FASI CHE LO COMPONGONO 
--*	IMERIO 04/11/2011
--****************************************************
SELECT     tc.codciclo, NUMEROFASE, operazione, dscoperazione, operazione, cdlavoro
FROM         RIGHECICLOPROD rc
left join testacicloprod tc on rc.progressivo = tc.progressivo
WHERE     tc.codciclo = '_ciclo_A35'
order by operazione


--****************************************************
--* CONTROLLA SE IN UN CICLO SONO STATE MODIFICATE LE 
--* DESCRIZIONI DELLE FASI RISPETTO ALLE DESCRIZIONI
--* ORIGINALI DELLE OPERAZIONI (QUESTO PUO' FALSARE
--* LE RISORSE ASSEGNATE ALL'OPERAZIONE STESSA) 
--*	IMERIO 21/02/2012
--****************************************************
SELECT     tc.codciclo, NUMEROFASE, operazione, dscoperazione, ti.descrizione as descr_originale, 
			cdlavoro, cdl.descrizione, macchina, tm.descrizione
FROM         RIGHECICLOPROD rc
left join testacicloprod tc on rc.progressivo = tc.progressivo
left join tabellaoperazioni ti on rc.operazione = ti.codice
left join tabellacdlavoro cdl on cdl.codice = rc.cdlavoro
left join tabellamacchine tm on tm.codice = rc.macchina
WHERE     (codciclo like '00Y%' or codciclo like '00bm%')
and dscoperazione <> ti.descrizione
--and dscoperazione = 'preparazione trasferta'
order by codciclo, numerofase



--************************************************
--* AZZERA LA QUANTITA ORDINATA IN UNA FASE
--* A FRONTE DELLA CANCELLAZIONE DELL'ORDINE
--* DI CONTO LAVORO
--* (l'anno e il nr di bolla si legge nella stampa della
--* Bolla di Lavorazione o in Metodo
--* entrando nella CPI alla sezione Lavorazioni di Fase)
--* IMERIO 19/03/2014
--*************************************************

--update righecicloordine set qtaterzista = 0 where numerobolla = 6602 and annobolla = 2014



--********************************************************
--* CERCA CICLI CON DETERMINATO FORNITORE DI FASE E 
--* DETERMINATA FASE
--* IMERIO 21/10/2015
--********************************************************

select tp.progressivo, tp.codciclo, rcp.numerofase, rcp.operazione, rcp.dscoperazione, tfc.codforn 
from TESTACICLOPROD tp
inner join righecicloprod rcp on rcp.progressivo = tp.progressivo
inner join tabfornitoriciclo tfc on tfc.progressivo = rcp.progressivo and tfc.numerofase=rcp.numerofase
where tfc.codforn = 'F  1390' --and operazione = '12002'


--*** SOSTITUZIONE FORNITORE NELLE FASI
select * from tabfornitoriciclo where codforn = 'F   374'
--update tabfornitoriciclo set codforn = 'F  1390' where codforn = 'F   374'

--*** CANCELLAZIONE FASE
select * from righecicloprod where operazione = '12002' and progressivo in (31551, 33037)
--delete righecicloprod where operazione = '12002' and progressivo in (31551, 33037)

--* CANCELLARE FASI CHE RISPONDONO A DETERMINATI REQUISITI (ES. FORNITORE DI FASE E CODICE OPERAZIONE DI FASE)
select tp.progressivo, tp.codciclo, rcp.numerofase, rcp.operazione, rcp.dscoperazione, tfc.codforn
from TESTACICLOPROD tp
left join righecicloprod rcp on rcp.progressivo = tp.progressivo
left join tabfornitoriciclo tfc on tfc.progressivo = rcp.progressivo and tfc.numerofase=rcp.numerofase
where tp.codciclo in(
select tp.codciclo
from TESTACICLOPROD tp
left join righecicloprod rcp on rcp.progressivo = tp.progressivo
left join tabfornitoriciclo tfc on tfc.progressivo = rcp.progressivo and tfc.numerofase=rcp.numerofase
where tfc.codforn = 'F  1390')
and rcp.operazione = '12002'

--delete righecicloprod
--where progressivo in (
--select tp.progressivo
--from TESTACICLOPROD tp
--left join righecicloprod rcp on rcp.progressivo = tp.progressivo
--left join tabfornitoriciclo tfc on tfc.progressivo = rcp.progressivo and tfc.numerofase=rcp.numerofase
--where tfc.codforn = 'F  1390')
--and operazione = '12002'