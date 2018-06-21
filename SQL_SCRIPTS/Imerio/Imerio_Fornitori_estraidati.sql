
--**************************************************
--* fornitori appoggiati ad una certa banca *
--**************************************************
select codconto, dscconto1, fax 
from anagraficacf 
where codconto IN (select codconto from anagraficariservaticf where codbanca = 'B     3') 
order by dscconto1


--***************************************************
--* FORNITORI  FATTURATO TOT E NR ARTICOLI ACQUISTATI *
--*     L.DIPIETRA PER RIESAME DIREZIONE
--* 
--***************************************************
select aa.codclifor, cc.dscconto1, convert(money,sum(dd.totnettoriga)) as Fatturato,CONVERT(REAL,sum(DD.QTAGEST)) AS TOT_ARTICOLI
from testedocumenti aa, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
--and dd.codart <>''
and dd.totnettoriga > 0

-- SELEZIONA FORNITORE
AND AA.CODCLIFOR LIKE 'F%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('FAI', 'FAC', 'FAE')
--('OFA', 'OFR', 'OFG')

and aa.esercizio = '2015'
group by aa.codclifor, cc.dscconto1
order by aa.codclifor


-- **************************************
-- * FORNITORI FATTURATI DETTAGLIATI VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 09/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, aa.tipodoc, aa.numerodoc, convert(money,d.totnettoriga) as NettoRiga
from testedocumenti aa, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.totnettoriga <> 0                -- non considera eventuali anticipi

-- SELEZIONA FORNIOTRE
AND AA.CODCLIFOR LIKE 'F%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('FAI', 'FAC', 'FAE')
--AND aa.tipodoc IN ('OFA', 'OFG', 'OFR')

and aa.esercizio = '2009'
order by aa.tipodoc


-- **************************************
-- * FORNITORI TOTALI FATTURATI  (ABC) 
-- * SOMMANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE NEGATIVE)
-- * si confronti con la stampa in Metodo in 
-- * Documenti/Stampe/Statisctiche/Liste ABC: fatturato Fornitori
-- * Imerio 12/05/2011
-- **************************************
select aa.codclifor, cc.dscconto1, convert(money, sum(dd.totnettoriga))as ToT_Imponibile
from testedocumenti aa, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.totnettoriga <> 0                -- non considera eventuali anticipi

-- SELEZIONA FORNIOTRE
AND AA.CODCLIFOR LIKE 'F%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('FAI', 'FAC', 'FAE')
--AND aa.tipodoc IN ('OFA', 'OFG', 'OFR')

and aa.esercizio = '2015'
group by aa.codclifor, cc.dscconto1
order by tot_imponibile DESC



-- **************************************
-- * FORNITORI TOTALI RIGHE FATTURE VENDITA MATERIE PRIME
-- * PER ELISA
-- * Imerio 09/02/2012
-- **************************************
select codclifor, rd.tipodoc, rd.numerodoc, convert(money,rd.totnettorigaeuro) as TOT_NETTO_RIGA, gencontrop  from righedocumenti RD
inner join testedocumenti td on rd.idtesta = td.progressivo
where rd.tipodoc = 'fai' 
and codclifor IN ('F   636', 'F    32') 
and rd.esercizio = '2012' 
and gencontrop = 'g   148' -- G148 = materia prima, G149 = conto lavoro
order by codclifor



--*****************************************
--* controllo dati spesometro
--* (Richiesto da O. Bonazzo)
--* IMERIO 02/04/2014
--****************************************

select meq.anno, meq.tipoquadro, meq.codclifor, acf.dscconto1, convert(money, imponibileeuro) as imponibile, convert(money,impostaeuro) as imposta,
numfattura, convert(varchar, datareg, 105) as dataregistrazione, convert(varchar, datadoc, 105) as datadocumento
from MOVELENCOCLIFORQUADRI meq
inner join anagraficacf acf on meq.codclifor = acf.codconto
where anno = 2013 and tipoquadro = 'SE'


--******************************************
--* NUMERO DI RIGHE BCF CARICATE
--* IMERIO 14/07/2016
--******************************************

select td.codclifor, dscconto1, count(td.numerodoc) as numerorighe 
from righedocumenti rd
inner join testedocumenti td on rd.idtesta = td.progressivo
left join anagraficacf acf on td.codclifor=acf.codconto
where rd.esercizio = 2016 and rd.codart <>'' and td.tipodoc = 'BCF'
group by td.codclifor, dscconto1
order by numerorighe desc





--**************************************
--* AGGIORNAMENTI LISTINO IN NUOVO FORNITORE
--* (DA USARE QUANDO UN FORNITORE CAMBIA RAGIONE SOCIALE)
--*
--* IMERIO 20/01/2017
--***************************************


--* A) A tutti gli articoli aventi il vecchio listino viene inserita una nuova riga con il nuovo listino
--INSERT INTO listiniarticoli (CODART,nrlistino,UM,PREZZO, PREZZOEURO, utentemodifica,DATAMODIFICA, DeltaIncremento) 
-- SELECT A2.CODART,11492,A2.UM,A2.PREZZO, A2.PREZZOEURO, 'admin','2017-01-20',DeltaIncremento 
-- from listiniarticoli a2
-- where 
-- a2.NRLISTINO = 10229


--* B) Viene aggiornato il fornitore preferenziale nell'anagrafica articolo
--update ANAGRAFICAARTICOLIPROD set fornprefacq = 'F  1492' where esercizio = 2017 and fornprefacq = 'F   229'

--*C) Viene aggiornata la tabella Lotti nell'anagrafica articolo
--update TABLOTTIRIORDINO set codfor = 'F  1492', utentemodifica = 'admin', datamodifica = '2017-01-20' where  codfor = 'F   229'



--*************************************************************************
--* ZILIO: ANALISI tempi consegna fornitori  01/02/2017
--* 1) ORDINI FORNITORI IN UN DATO ESERCIZIO FISCALE CHE HANNO AVUTO ALMENO UNA RIGA PRELEVATA

SELECT convert(varchar,CAST(PROGRESSIVO AS VARCHAR(6))+ CODART) AS IDORDINE, PROGRESSIVO, CONVERT (varchar,TD.DATADOC, 105) AS DATACONFORDINE, TD.TIPODOC, TD.NUMERODOC, TD.CODCLIFOR,ACF.DSCCONTO1, RD.CODART, 
CONVERT (varchar, RD.dataconsegna, 105) as DATACONSPREVISTA  --, RD.CODART, CONVERT(REAL,RD.QTAGEST) AS QTA, CONVERT(MONEY, TOTNETTORIGAEURO) AS TOTRIGA
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
left join anagraficacf acf on td.codclifor = acf.CODCONTO
WHERE
TD.ESERCIZIO = 2016 --YEAR(GETDATE())
AND RD.QTAGEST <> 0
AND CODART <>''
AND TD.TIPODOC IN ('OFA', 'OFS', 'OFG', 'OFR', 'OFW','ORI', 'ORL', 'ORR') --AND TD.NUMERODOC = '1126'
AND RD.IDTESTA IN (SELECT IDTESTARP FROM RIGHEDOCUMENTI) -- WHERE ESERCIZIO = '2011')-- AND TIPODOC = 'BCF' AND NUMERODOC = '3')
AND RD.IDRIGA IN (SELECT IDRIGARP FROM RIGHEDOCUMENTI) --WHERE ESERCIZIO = '2011')-- AND TIPODOC = 'BCF' AND NUMERODOC = '3')
ORDER BY PROGRESSIVO, TD.TIPODOC, TD.NUMERODOC

--*************************************************************************
--* 2) ELENCO BOLLE CHE HANNO PRELEVATO RIGHE IN DOCUMENTI IN UN DETERMINATO ESERCIZIO FISCALE

SELECT convert(varchar,CAST(IDTESTARP AS VARCHAR(6))+ CODART) AS IDBOLLA, IDTESTARP, TD.TIPODOC, TD.NUMERODOC, TD.CODCLIFOR,  CONVERT(VARCHAR,TD.DATADOC, 105) AS DATABOLLA,  CODART 
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE 
TD.TIPODOC IN ('BC1','BCF','BCX')
AND QTAGEST <> 0
AND CODART <>''
AND IDTESTARP IN (SELECT PROGRESSIVO FROM TESTEDOCUMENTI WHERE ESERCIZIO = 2016) --YEAR(GETDATE())) --ATTENZIONE: INDICARE STESSO ESERCIZIO DELLA QUERY 1
ORDER BY IDTESTARP, TD.TIPODOC, TD.NUMERODOC 

--*************************************************************************
--* 3) INCROCIARE (EXCELL - CERCAVERTICALE ) I RISULTATI DI 1 CON 2
--* DOVE IDORDINE = IDBOLLA. NELLA CARTELLA DEGLI ORDINI CALCOLARE COLONNE
--* "DELTA DA DATA PREVISTA" E "DELTA DA CONFERMA ORDINE"
--* VEDERE ESEMPIO IN CED/PROGETTO ERP/ RICAMBI_ON TIME DELIVERY.XLXS


