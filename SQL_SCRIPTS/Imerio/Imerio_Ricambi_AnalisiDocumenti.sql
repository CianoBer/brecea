-- **************************************
-- * CONTA NUMERO RIGHE NEI DOCUMENTI RICAMBI
-- * CONSIDERANDO LE SOLE RIGHE CHE 
-- * CONTENGONO UN CODICE ARTICOLO
-- * Imerio 17/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, count (1) as Nr_righe 
from testedocumenti aa, anagraficacf cc, righedocumenti dd
where dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and aa.codclifor = cc.codconto             -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.codart <> ''                          -- solo righe relative ad articoli

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
--AND aa.tipodoc IN ('OF1', 'OF2')  -- OFFERTE RICAMBI
AND aa.tipodoc IN ('OR1', 'OR2')  -- CONFERME D'ORDINE RICAMBI

--and aa.esercizio = '2009'
group by aa.codclifor, cc.dscconto1
order by Nr_righe DESC



-- **************************************
-- * FATTURATI PER AREA/PORTO ECC
-- * VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 09/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, bb.descrizione,  aa.porto, aa.datadoc, aa.tipodoc, aa.numerodoc, dd.totnettoriga, aa.totspesetraspeuro
from testedocumenti aa, tabnazioni bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and cc.codnazione = bb.codice          -- ALLINEA LE TABELLA TESTEDOCUMENTI E TABNAZIONI
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
--and aa.porto IN (1,9,13,14)                -- individua i documenti con un determinato PORTO
and dd.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR = 'C   149'

-- SELEZIONA NAZIONE
--and cc.codnazione IN ('33', '53') -- USA e CANADA
-- include Paesi UE
--AND CC.CODNAZIONE IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')

-- SELEZIONA TIPODOC
and aa.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')
--AND aa.tipodoc IN ('OG1', 'OG2')

and (aa.DATADOC > '01/07/2009' AND aa.DATADOC <= '31/07/2010')
order by aa.codclifor, aa.tipodoc



-- **************************************
-- * TOTALI FATTURATI PER CLIENTE
-- * SOMMANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 09/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, Nr_Doc = count(aa.tipodoc) --Tot_Imponibile_righe = sum(dd.totnettoriga)--,  
from testedocumenti aa, anagraficacf cc, righedocumenti dd
where dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and aa.codclifor = cc.codconto             -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.totnettoriga > 0                    -- non considera eventuali anticipi
--and dd.codart = 'e0z8070'

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR = 'C   149'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')  -- FATTURATO RICAMBI A PAGAMENTO
--AND aa.tipodoc IN ('OG1', 'OG2')  -- FATTURATO RICAMBI IN GARANZIA

--and aa.esercizio = '2009'
and (aa.DATADOC > '01/07/2009' AND aa.DATADOC <= '31/07/2010')
group by aa.codclifor, cc.dscconto1
--order by Tot_Imponibile_righe DESC



-- **************************************
-- * VALORIZZAZIONE CODICI A ZERO EVENTUALMENTE PRESENTI
-- * NEI DOCUMENTI DI GARANZIA OG1 E OG2 UTILIZZANDO UN LISTINO.
-- * QUESTI IMPORTI VANNO SOMMATI A QUELLI TROVATI CON LA QUERY PRECEDENTE
-- * Imerio 09/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, aa.esercizio, aa.tipodoc, DD.CODART, QTa = left(DD.QTAGEST, 3), bb.prezzoeuro, dd.totnettoriga 
from testedocumenti aa, listiniarticoli bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea la tabella TESTEDOCUMENTI E TABNAZIONI
and dd.codart = bb.codart             -- ALLINEA LE TABELLA RIGHEDOCUMENTI e LISTINIARTICOLI
and dd.idtesta = aa.progressivo		  -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.totnettoriga = 0               -- considera solo le righe a zero
AND DD.CODART <>''					  -- considera solo le righe con codice articolo
and bb.nrlistino = '112'			  -- usa listino 112

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('OG1', 'OG2')

--and aa.esercizio = '2009'
and (aa.DATADOC > '01/01/2010' AND aa.DATADOC <= '30/06/2010')
order by aa.tipodoc




--*****************************************************
-- SIMULAZIONI FATTURATI RICAMBI USANDO DIVERSI LISTINI
--
--		IMERIO MAGGIO 2011
-- ****************************************************
select aa.codclifor, cc.dscconto1, aa.esercizio, aa.tipodoc, AA.NUMERODOC, DD.CODART, CONVERT(REAL,left(DD.QTAGEST, 3)) AS QTA, 
	CONVERT(REAL,DD.SCONTORIGA) AS SCONTO, CONVERT(MONEY,bb.prezzoeuro) AS PREZZOUNITLISTINO,  
    CONVERT(MONEY, (bb.prezzoeuro*dd.qtagest*(1-dd.scontoriga/100))) as PREZZOTOT
from testedocumenti aa, listiniarticoli bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea la tabella TESTEDOCUMENTI E TABNAZIONI
and dd.codart = bb.codart             -- ALLINEA LE TABELLA RIGHEDOCUMENTI e LISTINIARTICOLI
and dd.idtesta = aa.progressivo		  -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
AND DD.CODART <>''					  -- considera solo le righe con codice articolo
and bb.nrlistino = '11'				  -- usa listino 

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('OR1', 'OR2')

--and aa.esercizio = '2009'
and aa.DATADOC > '01/01/2011' --AND aa.DATADOC <= '30/06/2010')
order by aa.tipodoc, AA.NUMERODOC


--*****************************************************
-- CREAZIONE LISTINO RICAMBI PER CLIENTI E DISTRIBUTORI
-- (DA ESPORTARE E SALVARE IN EXCEL PER INVIO)
-- CONSIDERA SOLO CODICI PROPOSTI IN OFFERTE, ORDINI, GARANZIE
--
--		IMERIO AGOSTO 2011
-- ****************************************************
select  DD.CODART, aa.descrizione, CONVERT(MONEY,bb.prezzoeuro) AS PREZZOUNITLISTINO, 
em.ltcumulato as GG_LEADTIME, ap.tapprontacq as GG_CONSEGNA_ACQUISTI  
from righedocumenti dd 
inner join listiniarticoli bb on dd.codart = bb.codart
left join anagraficaarticoli aa on dd.codart = aa.codice
inner join testedocumenti td on dd.idtesta = td.progressivo
left join extramag em on em.codart = dd.codart
left join anagraficaarticoliprod ap on ap.codiceart = dd.codart
where       
DD.CODART <>''						-- considera solo le righe con codice articolo
AND DD.CODART NOT LIKE 'Z%' AND DD.CODART NOT LIKE 'X%'  --esclude i codici X e Z
AND AP.ESERCIZIO = '2013'			--	imposta esercizio per tabella anagraficaarticoliprod per fornire i tempi di consegna
and bb.nrlistino = '10'				-- seleziona listino
--and bb.prezzoeuro > 0				-- considera solo codici con prezzo diverso da zero
AND td.tipodoc IN ('OR1', 'OR2', 'of1', 'of2', 'og1', 'og2')
--AND td.tipodoc IN ('OR1', 'OR2', 'og1', 'og2')

group by dd.codart, aa.descrizione, bb.prezzoeuro, em.ltcumulato, ap.tapprontacq
order by dd.codart




--**********************************************
--* CALCOLO DIFFERENZA TRA DATA PROPOSTA E DATA 
--* EFFETTIVA CONSEGNA RICAMBI
--* PER ANALISI QUALITA' SERVIZIO
--*
--*		IMERIO SETTEMBRE 2011
--**********************************************

SELECT TD.CODCLIFOR, AC.DSCCONTO1, TD.ESERCIZIO, TD.TIPODOC, TD.NUMERODOC,  
rd.codart, AA.DESCRIZIONE, convert(varchar,RD.dataconsegna, 105) AS DATA_PROMESSA,
convert(varchar, td.datadoc, 105) as DATA_BOLLA,CONVERT(REAL,(td.datadoc-RD.dataconsegna)) AS RITARDO_CONSEGNA
from righedocumenti rd
left join testedocumenti td on rd.idtesta = td.progressivo
INNER JOIN ANAGRAFICACF AC ON TD.codclifor = AC.codconto             -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
left join anagraficaarticoli aa on Rd.codart = aa.codice
where rd.rigachiusa = '1'
and rd.codart <>''

and TD.DATADOC >= '01/01/2012' --AND TD.DATADOC <= '31/08/2011'

and td.tipodoc in ('DR1','DR2')
ORDER BY TD.CODCLIFOR, TD.NUMERODOC

-- **************************************
-- * CODICI ARTICOLI FORNITI COME RICAMBI
-- * Imerio 06/07/2010
-- **************************************
select RD.RIFCOMMCLI, AC.OGGETTO, TD.CODCLIFOR, cc.dscconto1, CONVERT(VARCHAR,RD.CODART) AS CODICE, RD. DESCRIZIONEART,CONVERT(REAL,RD.QTAGEST) AS QTA,
 TD.TIPODOC, TD.NUMERODOC, CONVERT(VARCHAR, TD.DATADOC, 105) AS DATADOCUMENTO--, CONVERT(MONEY,LA.PREZZOEURO, 1) AS LIST11 
from TESTEDOCUMENTI TD
LEFT JOIN  RIGHEDOCUMENTI RD ON TD.PROGRESSIVO = RD.IDTESTA		-- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
LEFT JOIN anagraficacf cc ON td.codclifor = cc.codconto         -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
--LEFT JOIN LISTINIARTICOLI LA ON RD.CODART = LA.CODART			-- ALLINEA LISTINIARTICOLI E RIGHEDOCUMENTI
LEFT JOIN ANAGRAFICACOMMESSE AC ON AC.RIFCOMM = RD.RIFCOMMCLI   -- ALLINEA ANAGRAFICACOMMESSE E RIGHEDOCUMENTI
where 		  
RD.CODART <>''					  -- considera solo le righe con codice articolo

--and rd.rifcommcli <>''

-- SELEZIONA TIPODOC
AND TD.tipodoc IN ('OR1', 'OR2')  -- ORDINI
--AND TD.tipodoc IN ('OF1', 'OF2')  -- OFFERTE
-- AND TD.tipodoc IN ('OG1', 'OG2')  -- GARANZIE

-- SELEZIONA LISTINO
--AND LA.NRLISTINO = '103'

-- SELEZIONA PERIODO
and (TD.DATADOC > '2010-01-01' AND TD.DATADOC <= '2010-12-31')

ORDER BY TD.NUMERODOC --d.codart --RD.RIFCOMMCLI ASC, TD.DATADOC ASC

