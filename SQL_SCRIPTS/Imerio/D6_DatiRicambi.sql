--* INSERIRE I FILE IN G:\STI\S&S\Ricambi\Analisi\Statistica\2014

-- **************************************
-- * ESTRAE DATI TESTE DOCUMENTI PER ANALISI QUALITA' SERVIZIO
-- * METTERE ORX E OFX IN DUE CARTELLE DELLO STESSO FOGLIO EXCEL
-- * E CALCOLARE IN EXCEL PER CIASCUNA IL RITARDO_RISPOSTA.
-- * ESTRARRE POI DUE PIVOT RAGGRUPPATE PER PAESE
-- * SI VEDA ESEMPIO IN CED/PROGETTO ERP/RICAMBI_QUALITA SERVZIO.XLXS
-- * STAMPA PERIODICA PER SORA
-- * Imerio 01/02/2011
-- **************************************
set dateformat dmy
select aa.codclifor, TN.DESCRIZIONE as PAESE, AC.dscconto1 as NOMECLIENTE, aa.esercizio, aa.tipodoc, AA.NUMERODOC, convert(varchar, AA.DATARIFDOC, 105) AS DATA_INVIO_RICH, AA.NUMRIFDOC,
convert(varchar,AA.DATADOC,105) AS DATA_INVIO_RISP --, CONVERT (REAL,(AA.DATADOC-AA.DATARIFDOC)) AS RITARDO_RISPOSTA, AA.UTENTEMODIFICA, 
--CONVERT (MONEY,AA.TOTIMPONIBILE) AS TOTALEIMPONIBILE
from testedocumenti aa
INNER JOIN ANAGRAFICACF AC ON aa.codclifor = AC.codconto             -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF 
LEFT JOIN TABNAZIONI TN ON AC.CODNAZIONE = TN.CODICE                 -- allinea le tabella TABNAZIONI e ANAGRAFICACF 
where 
-- SELEZIONA CLIENTE
--AA.CODCLIFOR = 'C   256'
AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
--AND aa.tipodoc IN ('OR1', 'OR2')
AND aa.tipodoc IN ('OF1', 'OF2')

--and aa.esercizio = '2009'
and aa.DATADOC > '01/01/2017' AND aa.DATADOC <= '31/08/2017'
order by aa.CODCLIFOR, AA.NUMERODOC


-- **************************************
-- * FORNISCE RIGHE DEI DOCUMENTI
-- * PER ANALISI QUALITA' SERVIZIO
-- * STAMPA PERIODICA PER CUDIFERRO (NON RICHIESTO DA SORA)
-- * Imerio 01/02/2011
-- **************************************
SET DATEFORMAT DMY
SELECT RD.RIFCOMMCLI, AM.OGGETTO, aa.codclifor, TN.DESCRIZIONE as PAESE, AC.dscconto1 AS NOMECLIENTE, RD.CODART, RD.DESCRIZIONEART, convert(integer,RD.QTAGEST) as QTA, RD.TIPODOC, RD.NUMERODOC, 
convert(varchar,AA.DATADOC, 105) as DATADOCUMENTO, convert(real,rd.scontoriga) as sconto, CONVERT(MONEY,TOTNETTORIGAEURO) AS TOTALERIGA
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI AA ON RD.IDTESTA = AA.PROGRESSIVO
INNER JOIN ANAGRAFICACF AC ON aa.codclifor = AC.codconto             -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF 
LEFT JOIN TABNAZIONI TN ON AC.CODNAZIONE = TN.CODICE                 -- allinea le tabella TABNAZIONI e ANAGRAFICACF 
LEFT JOIN AnagraficaCommesse AM ON RD.RIFCOMMCLI = AM.RIFCOMM
where 
RD.CODART <>''	-- Solo righe con articoli

-- SELEZIONA CLIENTE
--AA.CODCLIFOR = 'C   256'
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('OR1', 'OR2')
--AND aa.tipodoc IN ('OF1', 'OF2')

--and aa.esercizio = '2009'
and aa.DATADOC > '01/01/2014' --AND aa.DATADOC <= '31/01/2013'
order by AA.DATADOC




--*************************************************************************
--* SORA: ANALISI SERVIZIO RICAMBI (ON TIME DELIVERY) 14/05/2012
--* 1) ORDINI RICAMBI IN UN DATO ESERCIZIO FISCALE CHE HANNO AVUTO ALMENO UNA RIGA PRELEVATA

SELECT convert(varchar,CAST(PROGRESSIVO AS VARCHAR(6))+ CODART) AS IDORDINE, PROGRESSIVO, CONVERT (varchar,TD.DATADOC, 105) AS DATACONFORDINE, TD.TIPODOC, TD.NUMERODOC, RD.CODART, 
CONVERT (varchar, RD.dataconsegna, 105) as DATACONSPREVISTA  --, RD.CODART, CONVERT(REAL,RD.QTAGEST) AS QTA, CONVERT(MONEY, TOTNETTORIGAEURO) AS TOTRIGA
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE
TD.ESERCIZIO = YEAR(GETDATE())
AND RD.QTAGEST <> 0
AND CODART <>''
AND TD.TIPODOC IN ('OR1', 'OR2') --AND TD.NUMERODOC = '1126'
AND RD.IDTESTA IN (SELECT IDTESTARP FROM RIGHEDOCUMENTI) -- WHERE ESERCIZIO = '2011')-- AND TIPODOC = 'BCF' AND NUMERODOC = '3')
AND RD.IDRIGA IN (SELECT IDRIGARP FROM RIGHEDOCUMENTI) --WHERE ESERCIZIO = '2011')-- AND TIPODOC = 'BCF' AND NUMERODOC = '3')
ORDER BY PROGRESSIVO, TD.TIPODOC, TD.NUMERODOC

--*************************************************************************
--* 2) ELENCO BOLLE CHE HANNO PRELEVATO RIGHE IN DOCUMENTI IN UN DETERMINATO ESERCIZIO FISCALE

SELECT convert(varchar,CAST(IDTESTARP AS VARCHAR(6))+ CODART) AS IDBOLLA, IDTESTARP, TD.TIPODOC, TD.NUMERODOC, CONVERT(VARCHAR,TD.DATADOC, 105) AS DATABOLLA,  CODART 
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE 
TD.TIPODOC IN ('DR1','DR2', 'PB1', 'PB2')
AND QTAGEST <> 0
AND CODART <>''
AND IDTESTARP IN (SELECT PROGRESSIVO FROM TESTEDOCUMENTI WHERE ESERCIZIO = YEAR(GETDATE())) --ATTENZIONE: INDICARE STESSO ESERCIZIO DELLA QUERY 1
ORDER BY IDTESTARP, TD.TIPODOC 

--*************************************************************************
--* 3) INCROCIARE (EXCELL - CERCAVERTICALE ) I RISULTATI DI 1 CON 2
--* DOVE IDORDINE = IDBOLLA. NELLA CARTELLA DEGLI ORDINI CALCOLARE COLONNE
--* "DELTA DA DATA PREVISTA" E "DELTA DA CONFERMA ORDINE"
--* VEDERE ESEMPIO IN CED/PROGETTO ERP/ RICAMBI_ON TIME DELIVERY.XLXS




--*****************************************************
-- cudiferro: ordini ricambi che hanno prelevato almeno 
--* una riga da offerte
--	IMERIO 24/05/2013
--******************************************************

select tipodoc, numerodoc
from righedocumenti where idtestarp <>0 and esercizio = YEAR(GETDATE()) and tipodoc in ('OR1', 'OR2')
GROUP BY NUMERODOC,tipodoc
order by numerodoc



--*****************************************************
--* cudiferro: articoli ricambi che richiedono ore produzione
--* per il calcolo ore è stata considerata una tariffa media di 45,00€/ora
--* (montaggio = 38,00€/ora, officina=47,00€/ora)
--*	IMERIO 04/09/2013
--******************************************************

select esercizio, numerocom, codart, DESCRIZIONEART, UMGest, convert(real, qtagestione) as qta, convert(real, (costolavinteffeuro/45)) as oreprod
from righeordprod rp
inner join TESTEORDINIPROD tp on tp.progressivo = rp.idtesta
where codiceord = 'OPR' and costolavinteffeuro > 0




--*************************************************************************
--* CUDIFERRO: ANALISI SERVIZIO ASSISTENZA (ON TIME DELIVERY RIPARAZIONI) 09/10/2013
--* 1) BOLLE RICEZIONE MERCE DA RIPARARE CHE HANNO AVUTO ALMENO UNA RIGA PRELEVATA

SELECT convert(varchar,CAST(PROGRESSIVO AS VARCHAR(6))+ CODART) AS IDRICEZIONE, PROGRESSIVO, CONVERT (varchar,TD.DATADOC, 105) AS DATACARICOMERCE, 
CONVERT (varchar,TD.DATARIFDOC, 105) AS DATABOLLACLIENTE, NUMRIFDOC AS NRBOLLACLIENTE, TD.TIPODOC, TD.NUMERODOC, RD.CODART, RIFCOMMCLI
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE
RD.ESERCIZIO in ('2012','2013','2014')
AND RD.QTAGEST <> 0
AND CODART <>''
AND TD.TIPODOC in ('DCR', 'DRC')
AND RD.IDTESTA IN (SELECT IDTESTARP FROM RIGHEDOCUMENTI) 
AND RD.IDRIGA IN (SELECT IDRIGARP FROM RIGHEDOCUMENTI) 
ORDER BY PROGRESSIVO, TD.TIPODOC, TD.NUMERODOC

--*************************************************************************
--* 2) BOLLE SPEDIZIONE MERCE RIPARATA CHE HANNO PRELEVATO RIGHE IN DOCUMENTI DI RICEZIONE MERCE

SELECT convert(varchar,CAST(IDTESTARP AS VARCHAR(6))+ CODART) AS IDSPEDIZIONE, IDTESTARP, TD.TIPODOC, TD.NUMERODOC, CONVERT(VARCHAR,TD.DATADOC, 105) AS DATABOLLA,  CODART 
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE 
TD.TIPODOC IN ('DRR')
AND QTAGEST <> 0
AND CODART <>''
AND IDTESTARP IN (SELECT PROGRESSIVO FROM TESTEDOCUMENTI WHERE ESERCIZIO in ('2012','2013','2014')) --ATTENZIONE: INDICARE STESSO ESERCIZIO DELLA QUERY 1
ORDER BY IDTESTARP, TD.TIPODOC 

--*************************************************************************
--* 3) INCROCIARE (EXCELL - CERCAVERTICALE ) I RISULTATI DI 1 CON 2
--* DOVE IDRICEZIONE = IDSPEDIZIONE



--***************************************************************
-- estrazione distinta per verifica categoria ricambi
--* I.REBELLATO 18/10/2013
--***************************************************************

DECLARE @Commessa VARCHAR(20)
SET @Commessa='00BM306-P01'

;with Distinta (artcomposto, codartcomponente, um, qta, livello, ordina)
as
(
-- individua i componenti a livello1
select dc.artcomposto, db.codartcomponente,db.um, db.qta1, 1 as livello, 
cast((row_number() over (order by db.codartcomponente ASC)*10) as int) as ordina  --assegna un progressivo (multiplo di 10) ad ogni figlio di livello 1
from distintabase db
inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
WHERE dc.artcomposto = @Commessa
--where dc.artcomposto = (@Commessa+'-P01')		-- individua i codici della sola commessa
--where dc.artcomposto like (@Commessa+'-A%')		-- individua i codici di eventuali commesse di aggiornamento

union all

-- individua componenti a livello successivo (ricorsivamente)
select dc.artcomposto, db.codartcomponente, db.um, db.qta1, livello+1, 
cast((ordina+cast(livello as int))as int)	--assegna un progressivo ai figli di livello inferiore partendo dal progressivo assegnato al padre
from distintabase db
inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
inner join distinta d on dc.artcomposto = d.codartcomponente
)

select d.artcomposto, d.codartcomponente, aa.descrizione, d.livello, d.um, d.qta, em.codartprod as codiceproduttore, 
em.nomeprod as produttore,em.ltcumulato as LeadTime, ap.tapprontacq, ap.tapprontprod, em.durataprevistaore, em.criticita, 
TBC.DESCRIZIONE AS desc_criticita, em.catricambi, tbr.descrizione as descr_catricambi,em.verricambio as verificaRic, 
ac.esaurito, ac.inesaurimento, ap.artalternativo --, convert(money, prezzoeuro) prezzolistino --, ordina
from distinta d
left join extramag em on em.codart = d.codartcomponente
left join met_tabcatricambi tbr on tbr.codice = em.CATRICAMBI
left join met_tabcriticita tbc on tbc.codice = em.CRITICITA
inner join anagraficaarticoli aa on aa.codice = d.codartcomponente
left join ANAGRAFICAARTICOLICOMM ac on ac.CODICEART = d.codartcomponente and ac.esercizio = year(getdate())
left join ANAGRAFICAARTICOLIPROD ap on ap.CODICEART = d.codartcomponente and ap.esercizio = year(getdate())
--left join LISTINIARTICOLI la on la.CODART = d.codartcomponente and nrlistino = 11
order by ordina



--*******************************************
--* IMPLOSIONE DISTINTA BASE
--*	IMERIO (06/10/2015
--****************************************

DECLARE @CODICE VARCHAR(20)
SET @CODICE='7640454'

;with Distinta (codartcomponente, artcomposto,  livello, ordina)
as
(
-- individua i componenti a livello1
select db.codartcomponente, dc.artcomposto, 1 as livello, 
cast((row_number() over (order by dc.artcomposto ASC)*10) as int) as ordina  --assegna un progressivo (multiplo di 10) ad ogni figlio di livello 1
from distintaartcomposti dc
inner join distintabase db on dc.progressivo = db.rifprogressivo
WHERE db.codartcomponente = @CODICE
--where dc.artcomposto = (@Commessa+'-P01')		-- individua i codici della sola commessa
--where dc.artcomposto like (@Commessa+'-A%')		-- individua i codici di eventuali commesse di aggiornamento

union all

-- individua componenti a livello successivo (ricorsivamente)
select db.codartcomponente, dc.artcomposto, livello+1, 
cast((ordina+cast(livello as int))as int)	--assegna un progressivo ai figli di livello inferiore partendo dal progressivo assegnato al padre
from distintaartcomposti dc 
inner join distintabase db on dc.progressivo = db.rifprogressivo
inner join distinta d on d.artcomposto = db.codartcomponente
)

select d.codartcomponente, d.artcomposto, d.livello, ordina --, aa.descrizione,
--em.catricambi, em.codartprod as codiceproduttore, em.nomeprod as produttore,
--em.ltcumulato as LeadTime, AP.TAPPRONTACQ, AP.TAPPRONTPROD, em.verricambio as verificaRic, tbr.descrizione as categoria_ricambi, ac.esaurito, ac.inesaurimento, ap.ARTALTERNATIVO
from distinta d
--left join extramag em on em.codart = d.codartcomponente
--left join met_tabcatricambi tbr on tbr.codice = em.CATRICAMBI
--inner join anagraficaarticoli aa on aa.codice = d.codartcomponente
--left join ANAGRAFICAARTICOLICOMM ac on ac.CODICEART = d.codartcomponente and ac.esercizio = year(getdate())
--left join ANAGRAFICAARTICOLIPROD ap on ap.CODICEART = d.codartcomponente and ap.esercizio = year(getdate())
--left join LISTINIARTICOLI la on la.CODART = d.codartcomponente and nrlistino = 11
order by ordina, artcomposto


--*******************************************
--* IMPLOSIONE DISTINTA BASE
--* SOLO PRIMO LIVELLO CON DESCRIZIONE
--* PER ELISA
--*	IMERIO (20/09/2016)
--****************************************


DECLARE @CODICE VARCHAR(20)
SET @CODICE='1756510'

;with Distinta (codartcomponente, artcomposto, livello, ordina)
as
(
-- individua i componenti a livello1
select db.codartcomponente, dc.artcomposto, 1 as livello, 
cast((row_number() over (order by dc.artcomposto ASC)*10) as int) as ordina  --assegna un progressivo (multiplo di 10) ad ogni figlio di livello 1
from distintaartcomposti dc
inner join distintabase db on dc.progressivo = db.rifprogressivo

WHERE db.codartcomponente = @CODICE
)

select d.codartcomponente, d.artcomposto, aa.descrizione, d.livello, ordina --, aa.descrizione,
from distinta d
left join anagraficaarticoli aa on d.artcomposto = aa.codice
order by ordina, artcomposto



--*******************************************
--* DATI RIGHE OFFERTE E ORDINI RICAMBI
--* ATTENZIONE: NON VENGONO VISUALIZZATE LE RIGHE PRIVE DI RIFERIMENTO COMMESSA
--*
--*	IMERIO 15/01/2014
--*******************************************
select convert(varchar,CAST(rd.esercizio AS VARCHAR(4))+'_'+td.Tipodoc+'_'+ CAST(td.numerodoc as varchar(10))) AS ID, rd.rifcommcli,  ac.Oggetto,td.codclifor, 
tn.DESCRIZIONE, af.dscconto1, rd.codart, rd.descrizioneart, 
convert(real, rd.qtagest) as qta, rd.tipodoc, rd.numerodoc, convert(varchar,td.DATADOC, 105) as datadocumento,
convert(real,rd.scontoriga) as sconto, convert(money,rd.totnettorigaeuro) as tot_nettoscontato_riga
from RIGHEDOCUMENTI rd
inner join AnagraficaCommesse ac on rd.RIFCOMMCLI = ac.RifComm
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
inner join ANAGRAFICACF af on td.codclifor = af.codconto
inner join tabnazioni tn on tn.CODICE = af.CODNAZIONE
where 
rd.TIPODOC in ('OF1', 'OF2')
--rd.tipodoc in ('OR1', 'OR2') 
and rd.esercizio = 2016
order by tipodoc, numerodoc


--****************************************************
--* PREBOLLE GENERATE A SEGUITO DI UN ORDINE RICAMBI
--*
--****************************************************

SELECT convert(varchar, td.tipodoc+'/'+cast(td.esercizio as varchar(4))+'/'+cast(td.numerodoc as varchar(4))) as bolla
, CONVERT(VARCHAR,TD.DATADOC, 105) AS DATABOLLA,  CODART, rigachiusa

,(select convert(varchar, td.tipodoc+'/'+cast(td.esercizio as varchar(4))+'/'+cast(td.numerodoc as varchar(4)))  
	FROM TESTEDOCUMENTI TD
	WHERE progressivo = idtestarp AND TD.TIPODOC IN ('OR1', 'OR2', 'OG1', 'OG2')
  ) as ordine
,(select PROGRESSIVO  
	FROM TESTEDOCUMENTI TD
	WHERE
	progressivo = idtestarp AND TD.TIPODOC IN ('OR1', 'OR2', 'OG1', 'OG2') 
  ) as PROGordine

FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE 
TD.TIPODOC IN ('PB1', 'PB2')
AND QTAGEST <> 0
AND CODART <>''
AND IDTESTARP IN (SELECT PROGRESSIVO FROM TESTEDOCUMENTI WHERE ESERCIZIO = YEAR(GETDATE()))
ORDER BY TD.TIPODOC, td.numerodoc
