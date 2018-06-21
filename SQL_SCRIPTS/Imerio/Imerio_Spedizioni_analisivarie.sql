-- *******************************************
-- * verifica nei tipidoc indicati le spedizioni
-- * fatte secondo determinati parametri
-- *******************************************

select bb.ragsocsped, aa.porto, tp.descrizione, aa.tipodoc, aa.numerodoc, aa.codclifor, cc.dscconto1, aa.datadoc
from testedocumenti aa, spedizdocumenti bb, anagraficacf cc, tabporto tp 
where 
aa.progressivo = bb.idtesta       -- allinea le tabella TESTEDOCUMENTI e SPEDIZDOCUMENTI
and aa. codclifor = cc.codconto   -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and aa.porto = tp.codice		  -- allinea le tabella TESTEDOCUMENTI e TABPORTO
--and aa.porto NOT IN (5, 7, 10)                  -- individua i documenti con un determinato PORTO
 -- and bb.codsped = 3             -- individua i documenti con un determinato SPEDIZIONIERE
-- bb.codsped not in (3,15, 30)   -- esclude i documenti con determinati SPEDIZIONIERI
AND AA.CODCLIFOR LIKE 'C%'
-- and aa.codclifor = 'C   256'
-- and aa.tipodoc = 'DR1'
and aa.tipodoc IN ('FR1','FM1','FA1','AR1','FX1','FI1','NC1','FV1','CR1','FR2', 'FM2', 'FA2','AR2','FX2', 'FI2', 'NC2', 'FV2', 'CR2')
-- and aa.tipodoc not in ('COM1', 'COM2', 'OF1', 'OF2', 'OR1', 'OR2', 'OG1', 'OG2')
-- include Paesi UE
--AND BB.CODNAZIONE IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')
and aa.esercizio = '2010'
order by NUMERODOC

-- CODSPED associati a DHL
-- ID = 3 => DHL EXPRESS
-- ID = 15 => DHL GLOBAL
-- ID = 30 => DHL FREIGHT
-- ID = 4 => SAIMA


-- *************************************
-- * lista bolle doganali CINEFRA/PIVA
-- * 15 MAGGIO 2009
-- *************************************

select aa.traspacura, bb.ragsocsped, aa.tipodoc, aa.numerodoc, aa.datadoc, aa.codclifor, cc.dscconto1 
from testedocumenti aa, spedizdocumenti bb, anagraficacf cc 
where 
	aa.progressivo = bb.idtesta 
	and aa.codclifor = cc.codconto 

-- LANCIARE IN SEQUENZA I DOCUMENTI CEE ('XX1') E POI QUELLI EXTRACEE ('XX2')

-- 1) DOCUMENTI CEE 
and aa.tipodoc in ('FR1','FM1','FA1','AR1','FX1','FI1','NC1','FV1')

-- 2) DOCUMENTI EXTRACEE
--and aa.tipodoc in ('FR2', 'FM2', 'FA2','AR2','FX2', 'FI2', 'NC2', 'FV2', 'CR2')

and aa.esercizio = '2010'
order by aa.numerodoc


-- **************************************
-- * IMPORTI FATTURE DI VENDITA INDICANDO IL PORTO
-- * VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * RICHIESTO DA SBALCHIERO PER ASSICURAZIONE SU TRASPORTI
-- * Imerio 14/12/2010
-- **************************************
select aa.codclifor, cc.dscconto1, aa.porto, tp.descrizione, CONVERT(VARCHAR,aa.datadoc,105) AS DATA_DOC, aa.tipodoc, 
	aa.numerodoc, CONVERT(MONEY,dd.totnettoriga) AS TOT_NETTO_RIGA, convert(money,totspesetrasp) as SPESE_TRASPORTO
from testedocumenti aa, anagraficacf cc, righedocumenti dd, tabporto tp
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and aa.porto = tp.codice		       -- allinea le tabella TESTEDOCUMENTI e TABPORTO
--and aa.porto IN (1,9,13,14)                -- individua i documenti con un determinato PORTO
and dd.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'
--AND AA.CODCLIFOR = 'C   149'

-- SELEZIONA TIPODOC
and aa.tipodoc IN ('FR1','FM1','FX1','FI1','FV1','CR1','FR2', 'FM2','FX2', 'FI2', 'FV2', 'CR2')
--and aa.tipodoc IN ('dsg','ddg')
and aa.esercizio = '2012'
order by aa.tipodoc, aa.datadoc



--*************************************************
--* ANALISI STATISTISCHE ESPORTAZIONI
--* NR DOCUMENTI E FATTURATO COMPLESSIVO
--*
--*    IMERIO 06/07/2011
--************************************************
select COUNT (1) AS NRDOCUMENTI
from testedocumenti aa
Inner Join anagraficacf cc on aa.codclifor = cc.codconto -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
Inner Join tabnazioni bb ON cc.codnazione = bb.codice -- ALLINEA LE TABELLA ANAGRAFICACF E TABNAZIONI
where       
-- SELEZIONA CLIENTE
AA.CODCLIFOR LIKE 'C%' AND AA.CODCLIFOR <> 'C    26'

-- SELEZIONA NAZIONE
and cc.codnazione NOT IN ('0', '31') -- ITALIA
-- ELENCO Paesi UE
AND CC.CODNAZIONE NOT IN ('    1', '    2', '    3', '    4', '    5', '    6', '    7',
'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')
-- SELEZIONA TIPODOC
and aa.tipodoc IN ('PR2')			
and aa.esercizio = '2011'

select sum(CONVERT(MONEY,dd.totnettoriga)) AS Tot_Imponibile_righe, SUM(CONVERT(MONEY, AA.TOTSPESETRASP)) AS TOT_SPESE_TRASP
from testedocumenti aa, tabnazioni bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and cc.codnazione = bb.codice          -- ALLINEA LE TABELLA TESTEDOCUMENTI E TABNAZIONI
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%' AND AA.CODCLIFOR <> 'C    26'

-- SELEZIONA NAZIONE
--and cc.codnazione NOT IN ('0', '31') -- ITALIA
-- ELENCO Paesi UE
--AND CC.CODNAZIONE NOT IN ('    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')

-- SELEZIONA TIPODOC
--and aa.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2', 'FM1', 'FM2', 'NC1', 'NC2', 'FV1', 'FV2', 'FX1', 'FX2')			
and aa.tipodoc IN ('FM1','FM2')
and aa.esercizio = '2011'
--AND AA.DATADOC < '31/01/2011'



--********************************************************
--* CONTROLLA CHE NOMENCLATURACOMBINATA1 = 90319085
--* (tariffa doganale per vendita Ricambi)
--* In NOMENCLATURACOMBINATA2 va messo invece la tariffa
--* doganale di acquisto
--* IMERIO 08/07/2011
--********************************************************
select codice, descrizione, nomenclcombinata1, nomenclcombinata2
from anagraficaarticoli
where nomenclcombinata1 <> '90319085'
and (codice > '1001000' and codice < 'z800008' and codice not like 'dip%')


--*****************************************************
--* sostituisce l'agente in tutti i clienti che rispondono
--* a determinate condizioni
--* IMERIO 25/07/2012
--********************************************************

select acf.codconto, dscconto1, codnazione, codagente1
from anagraficacf acf
inner join anagraficariservaticf ar on acf.CODCONTO = ar.CODCONTO
where ESERCIZIO = 2012 and CODNAZIONE = 8 and acf.CODCONTO like 'c%'

--update anagraficariservaticf set codagente1 = 'A    52'
--where anagraficariservaticf.ESERCIZIO = 2012 and anagraficariservaticf.CODCONTO like 'c%' 
--and exists (select anagraficacf.codconto
--from anagraficacf
--where anagraficariservaticf.CODCONTO = anagraficacf.codconto and anagraficacf.CODNAZIONE = 8)
