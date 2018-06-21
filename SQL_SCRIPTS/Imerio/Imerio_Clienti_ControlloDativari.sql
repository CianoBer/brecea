
--*****************************************
--* estrai clienti con un certo pagamento *
--*****************************************
select codconto, dscconto1 from anagraficacf where ((codconto LIKE '%C%') 
and (codconto IN (
	select codconto from anagraficariservaticf 
	where esercizio = 2016 and (
	codpag > 300 and codpag < 346  -- da 300 a 345 ci sono le RIBA
	--codpag >= 100 and codpag <= 145  -- da 100 a 145 ci sono le Rimesse dirette (aggiungere anche 900 e 901)
	)))) 


--************************************************************
--* richieste da N. Creazzo per spesometro
--************************************************************
--* 1) estrae clienti e fornitori Italia privi del flag "includi in elenco cli/for"
select aa.codconto, aa.dscconto1 --, aa.flgelencocf 
from anagraficacf aa
inner join ANAGRAFICACF BB on AA.CODCONTO= BB.CODCONTO
where (BB.CODNAZIONE='    0' OR BB.CODNAZIONE='   31') -- SOLO CLIENTI ITALIA
and aa.flgelencocf = 0

--* 2) estrae clienti con fatture aventi codice iva = 289
select td.esercizio, td.tipodoc,convert(varchar,td.DATADOC,105) as data_doc ,td.numerodoc, td.codclifor,BB.DSCCONTO1 as rag_sociale, 
CC.DESCRIZIONE as Nazione, rd.CODIVA, convert(money,rd.TOTNETTORIGAEURO) as totnettoriga
from RIGHEDOCUMENTI rd
inner join TESTEDOCUMENTI td on rd.idtesta = td.PROGRESSIVO
inner join ANAGRAFICACF BB on bb.codconto = td.codclifor --and bb.codconto like 'C%'
inner join TABNAZIONI CC on CC.CODICE=BB.CODNAZIONE
where td.tipodoc IN ('FA1', 'FA2','FM1', 'FM2', 'FR1', 'FR2', 'FV1', 'FV2', 'FI1', 'FI2', 'NC1', 'NC2', 'C1X', 'C2X','CR1', 'CR2', 'FX1', 'FX2')
and td.esercizio = 2016
AND rd.CODIVA = '  289'

--* 3) anagrafiche prive del codice Stato estero (Dati Comunic.)
select codconto, dscconto1, codstatoestero from anagraficacf where codstatoestero is null



--*****************************************
--* visualizza clienti e relativo pagamento *
--*****************************************
SELECT AA.ESERCIZIO, AA.CODCONTO, BB.DSCCONTO1, AA.CODPAG, DD.DESCRIZIONE, CC.DESCRIZIONE
FROM ANAGRAFICARISERVATICF AA, ANAGRAFICACF BB, TABNAZIONI CC, TABPAGAMENTI DD
WHERE (AA.ESERCIZIO='2014') 
AND (AA.CODCONTO LIKE'C%') -- SOLO CLIENTI
AND (AA.CODCONTO= BB.CODCONTO) -- ALLINEA LE TABELLE ANAGRAFICACF E ANAGRAFICARISERVATICF
AND (CC.CODICE=BB.CODNAZIONE ) -- ALLINEA LE TABELLE ANAGRAFICACF E TABNAZIONI
AND (AA.CODPAG=DD.CODICE) -- ALLINEA LE TABELLE ANAGRAFICACF E TABPAGAMENTI
--AND BB.CODNAZIONE='    8'
-- AND (BB.CODNAZIONE='    0' OR BB.CODNAZIONE='   31') -- SOLO CLIENTI ITALIA
ORDER BY CC.DESCRIZIONE



-- ***********************************************************************************************
-- controlla se ai Clienti ExtraUE è associato un Codice Iva diverso da N.I. Art.8 (cod. Iva 260)
-- ***********************************************************************************************

-- **** ELENCO CODICI PAESI UE (campo CODNAZIONE in ANAGRAFICACF) ****
-- 0-31: Italia, 1: Slovenia, 2: Francia, 3: Belgio, 4: Regno Unito, 5: Spagna, 6: Portogallo, 7: Grecia,
-- 8: germania, 9: Danimarca, 11: Svezia, 12: Irlanda, 13: Finlandia, 14: Austria, 15: Olanda, 21: Polonia, 22: Cipro,
-- 23: Ungheria, 24: Slovacchia, 29: Romania, 32 Lussemburgo
-- non codificate: Bulgaria, Estonia, Lettonia, Lituania, Malta, Rep. Ceca

SELECT AA.CODCONTO, BB.DSCCONTO1, CC.DESCRIZIONE, AA.CODIVA 
FROM ANAGRAFICARISERVATICF AA, ANAGRAFICACF BB, TABNAZIONI CC
WHERE AA.ESERCIZIO='2009' AND AA.CODCONTO= BB.CODCONTO AND CC.CODICE=BB.CODNAZIONE AND AA.CODCONTO LIKE'C%'
AND BB.CODNAZIONE NOT IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')
AND AA.CODIVA<>'  260'
ORDER BY CC.DESCRIZIONE



-- *********************************************************
-- controlla se ai Clienti sono associate le banche corrette
-- in CC.DESCRIZIONE c'è lo Stato di appartenenza
-- *********************************************************

SELECT AA.ESERCIZIO, AA.CODCONTO, BB.DSCCONTO1, CC.DESCRIZIONE, AA.CODBANCA 
FROM ANAGRAFICARISERVATICF AA, ANAGRAFICACF BB, TABNAZIONI CC
WHERE AA.ESERCIZIO='2016' AND AA.CODCONTO= BB.CODCONTO AND CC.CODICE=BB.CODNAZIONE AND AA.CODCONTO LIKE'C%'
-- *** TOGLIERE COMMENTO IN BASE AL CRITERIO DESIDERATO ***
-- ** se Italia => banca B3 **
AND BB.CODNAZIONE IN ('    0', '   31') AND AA.CODBANCA <> 'B     1'
-- ** se paese CEE => banca B1 **
--AND BB.CODNAZIONE IN ('    1', '    2', '    3', '    4', '    5', '    6', '    7','    8', '    9', '   11',
-- '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32') AND AA.CODBANCA <> 'B     1'
-- ** se paese Extracee => banca B2 **
-- AND BB.CODNAZIONE NOT IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
-- '    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32') AND AA.CODBANCA <> 'B     2'
ORDER BY CC.DESCRIZIONE


--AGGIORNAMENTO BANCA CLIENTI EXTRACEE
--update ANAGRAFICARISERVATICF set CODBANCA = 'B     4' where CODBANCA = 'B     2' and esercizio = '2014' and codconto like 'C%'
--and codconto in (select codconto from anagraficacf where CODNAZIONE not IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
-- '    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32'))





--**********************************************************
--* Aggiornamento codice agente clienti in base alla nazione
--**********************************************************

--* SELECT DI CONTROLLO E VERIFICA *
SELECT AA.CODCONTO, BB.DSCCONTO1, CC.DESCRIZIONE, AA.CODAGENTE1, AG.DSCAGENTE 
FROM ANAGRAFICARISERVATICF AA
LEFT JOIN ANAGRAFICACF BB ON AA.CODCONTO= BB.CODCONTO
LEFT JOIN TABNAZIONI CC ON CC.CODICE=BB.CODNAZIONE
LEFT JOIN ANAGRAFICAAGENTI AG ON AA.CODAGENTE1 = AG.CODAGENTE
WHERE AA.ESERCIZIO='2012' 
AND AA.CODCONTO LIKE'C%'
--and aa.codagente1 = 'A     1'
order by AA.CODCONTO

--* UPDATE DI AGGIORNAMENTO DATI *
--update anagraficariservaticf set codagente1 = 'A     8'
--WHERE (ESERCIZIO='2009') 
--AND (CODCONTO LIKE'C%') -- SOLO CLIENTI
--AND (CODCONTO IN (select CODCONTO from anagraficacf where CODNAZIONE='   15')) -- INDICAZIONE NAZIONE



-- ****************************************************************************************
-- * Nella tabella ANAGRAFICARISERVATICF setta nei CLIENTI il flag nel campo PRZ/PRV PART.*
-- ****************************************************************************************

--* SELECT DI CONTROLLO E VERIFICA *
select codconto, usaprzprvpart from anagraficariservaticf where usaprzprvpart = '1'

--* UPDATE DI AGGIORNAMENTO DATI *
--update anagraficariservaticf set usaprzprvpart='1' where (codconto >= 'C     1' and codconto<='C   309')



-- ****************************************************************************************
-- * Nella tabella ANAGRAFICARISERVATICF setta nei CLIENTI il campo GRUPPO PROV. PARTICOLARI 
-- * uguale a valore NAZIONE 
-- ****************************************************************************************

--update anagraficariservaticf set codgruppoprovpart = (select codnazione from anagraficacf 
--where codconto = anagraficariservaticf.codconto)
--WHERE (codconto >= 'C     1' and codconto<='C   309')


--*****************************************
--* visualizza clienti e relativo porto   *
--*****************************************
select an.codconto, an.dscconto1, ar.porto, tp.descrizione
from anagraficacf an
left join anagraficariservaticf ar on an.codconto = ar.codconto
left join tabporto tp on tp.codice = ar.porto
where ar.esercizio = '2011'
and an.codconto like 'C%'

--* CAMBIA IL PORTO AI CLIENTI DI DETERMINATE NAZIONI
--UPDATE ANAGRAFICARISERVATICF SET PORTO = 21 WHERE ESERCIZIO = 2015 AND CODCONTO LIKE 'C%'
--AND CODCONTO IN 
--(SELECT CODCONTO FROM ANAGRAFICACF AA 
--	left join tabnazioni tn on aa.codnazione = tn.codice 
--	WHERE descrizione in ( 'ARGENTINA', 'BOLIVIA','BRASILE', 'COLOMBIA','FILIPPINE','GUATEMALA', 'MESSICO','URUGUAY')
--)



-- **************************************
-- * FATTURATI PER AREA/PORTO ECC
-- * VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 09/02/2010
-- **************************************
select TD.codclifor, AC.dscconto1, TN.descrizione AS NAZIONE,  TD.porto, TD.esercizio, TD.tipodoc, TD.numerodoc, 
	RD.RIFCOMMCLI, CONVERT(MONEY,RD.totnettoriga) AS NETTORIGA --, CONVERT(MONEY,TD.totspesetraspeuro) AS SPESETRASPORTO
from testedocumenti TD
INNER JOIN anagraficacf AC ON TD.codclifor = AC.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
INNER JOIN tabnazioni TN ON AC.codnazione = TN.codice          -- ALLINEA LE TABELLA ANAGRAFICACF E TABNAZIONI
INNER JOIN righedocumenti RD ON TD.progressivo= RD.idtesta	   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
where RD.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA PORTO
--and TD.porto IN (1,9,13,14)                

-- SELEZIONA CLIENTE
AND TD.CODCLIFOR LIKE 'C%'

-- SELEZIONA NAZIONE
-- USA e CANADA
--and AC.codnazione IN ('33', '53') 
-- PAESI UE
--AND AC.CODNAZIONE IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')

--  MACCHINE, ACCESSORI, UPGRADE
and TD.tipodoc IN ('FM1', 'FM2', 'NC1', 'NC2', 'FX1','FX2')
--  RICAMBI
--and TD.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')
--	INTERVENTI
-- and TD.tipodoc IN ('FI1', 'FI2')  -- le note di accredito per gli interventi si fanno con i documenti NC1, NC2
--  GARANZIE
--AND TD.tipodoc IN ('OG1', 'OG2')
-- C/VISIONI
--and TD.tipodoc IN ('FV1', 'FV2')

and TD.esercizio = '2010'
order by TD.codclifor, TD.tipodoc





-- **************************************
-- * FATTURATI PER GENERICO X SBALCHIERO
-- * VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 17/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, Tot_Imponibile_righe = sum(dd.totnettoriga)
from testedocumenti aa, tabnazioni bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
and cc.codnazione = bb.codice          -- ALLINEA LE TABELLA TESTEDOCUMENTI E TABNAZIONI
and dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.gencontrop = 'G   264'		   -- G 264 = RICAMBI  G 265 = INTERVENTI
and dd.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA NAZIONE
--and cc.codnazione NOT IN ('0', '31') -- ITALIA
-- ELENCO Paesi UE
--AND CC.CODNAZIONE NOT IN ('    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')

-- SELEZIONA TIPODOC
and aa.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')					-- RICAMBI
--and aa.tipodoc IN ('FI1', 'FI2', 'NC1', 'NC2')				  -- INTERVENTI

and aa.esercizio = '2009'
group by aa.codclifor, cc.dscconto1
order by Tot_Imponibile_righe DESC




--**********************************************************************
--* CONTROLLA CHE FATTURE CLIENTI CEE NON CONTENGANO DETERMINATI CODICI IVA
--* (Richiesto da N. creazzo)
--*  IMERIO 02/04/2014
--************************************************************************

select td.esercizio, td.tipodoc, td.numerodoc, td.codclifor,BB.DSCCONTO1, CC.DESCRIZIONE,rd.codiva
from RIGHEDOCUMENTI rd
inner join TESTEDOCUMENTI td on rd.idtesta = td.PROGRESSIVO
inner join ANAGRAFICACF BB on bb.codconto = td.codclifor --and bb.codconto like 'C%'
inner join TABNAZIONI CC on bb.codnazione = cc.codice and nazionece= 0      -- nazionece = 0 paese extra cee, nazionece = 1 paese cee)
where td.tipodoc IN ('FM1', 'FM2', 'FR1', 'FR2', 'FV1', 'FV2', 'FI1', 'FI2', 'NC1', 'NC2', 'CR1', 'CR2', 'FX1', 'FX2')
and td.esercizio = 2013
AND rd.CODIVA not in ('    0', '  280', '  285', '  294')




-- **************************************
-- * RIGHE FATTURATO X CLIENTI x CONSIDERANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE NEGATIVE) 
-- * DATI FORNITI: COD CLIENTE, RAG SOCIALE, NAZIONE, TERMINI DI PAGAMENTO, SCONTO IN ANAGRAFICA, FATTURATO TOTALE, SPESE DI TRASPORTO
-- * Imerio 23/04/2010
-- **************************************
select aa.codclifor, cc.dscconto1, tn.descrizione, ar.codpag, ar.sconto1, aa.tipodoc, aa.numerodoc, dd.totnettoriga, aa.totspesetrasp
from   anagraficacf cc
INNER JOIN testedocumenti aa ON aa.codclifor = cc.codconto			-- ALLINEA TESTEDOCUMENTI e ANAGRAFICACF
INNER JOIN righedocumenti dd ON dd.idtesta = aa.progressivo			-- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
INNER JOIN anagraficariservaticf ar ON aa.codclifor = ar.codconto	-- ALLINEA TESTEDOCUMENTI E ANAGRAFICARISERVATICF
INNER JOIN tabnazioni tn ON tn.codice = cc.codnazione				-- ALLINEA ANAGRAFICACF E TABNAZIONI
where 		   
	dd.totnettoriga > 0						-- non considera eventuali anticipi
	and aa.esercizio = ar.esercizio			-- allinea gliesercizio di TESTEDOCUMENTI e ANAGRAFICARISERVATICF

-- SELEZIONA CLIENTE
	and aa.codclifor = 'C    78'

-- SELEZIONA TIPODOC
	AND aa.tipodoc IN ('FM1', 'FM2', 'FR1', 'FR2', 'FV1', 'FV2', 'FI1', 'FI2', 'NC1', 'NC2', 'CR1', 'CR2', 'FX1', 'FX2')

-- SELEZIONA ANNO PER TESTEDOCUMENTI
	and aa.esercizio = '2009'

order by aa.codclifor



-- **************************************
-- * ANALOGA ALLA PRECEDENTE CALCOLANDO PERO' I TOTALI FATTURATI CLIENTI 
-- * SOMMANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE NEGATIVE) 
-- * DATI FORNITI: COD CLIENTE, RAG SOCIALE, NAZIONE, TERMINI DI PAGAMENTO, SCONTO IN ANAGRAFICA, FATTURATO TOTALE, SPESE DI TRASPORTO
-- * Imerio 23/04/2010
-- **************************************
select aa.codclifor, cc.dscconto1, tn.descrizione, ar.codpag, ar.sconto1, Tot_Imponibile_righe = sum(dd.totnettoriga), aa.totspesetrasp --Tot_Spese_Trasp = sum (aa.totspesetrasp)
from   anagraficacf cc
INNER JOIN testedocumenti aa ON aa.codclifor = cc.codconto			-- ALLINEA TESTEDOCUMENTI e ANAGRAFICACF
INNER JOIN righedocumenti dd ON dd.idtesta = aa.progressivo			-- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
INNER JOIN anagraficariservaticf ar ON aa.codclifor = ar.codconto	-- ALLINEA TESTEDOCUMENTI E ANAGRAFICARISERVATICF
INNER JOIN tabnazioni tn ON tn.codice = cc.codnazione				-- ALLINEA ANAGRAFICACF E TABNAZIONI
where 		   
	dd.totnettoriga > 0                    -- non considera eventuali anticipi
	and aa.esercizio = ar.esercizio			-- allinea gli esercizi di TESTEDOCUMENTI e ANAGRAFICARISERVATICF

-- SELEZIONA CLIENTE
	AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
	AND aa.tipodoc IN ('FM1', 'FM2', 'FR1', 'FR2', 'FV1', 'FV2', 'FI1', 'FI2', 'NC1', 'NC2', 'CR1', 'CR2', 'FX1', 'FX2') -- FATTURATO GLOBALE (MACCHINE+RICAMBI)
-- AND aa.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')	-- FATTURATO RICAMBI A PAGAMENTO
-- AND aa.tipodoc IN ('OG1', 'OG2')					-- FATTURATO RICAMBI IN GARANZIA

-- SELEZIONA ANNO PER TESTEDOCUMENTI E PER ANAGRAFICARISERVATICF
	and aa.esercizio = '2009'

group by aa.codclifor, cc.dscconto1, tn.descrizione, ar.codpag, ar.sconto1, aa.totspesetrasp
order by aa.codclifor



-- **************************************
-- * VALORIZZAZIONE CODICI A ZERO PRESENTI
-- * NEI DOCUMENTI DI GARANZIA OG1 E OG2
-- * QUESTI IMPORTI VANNO SOMMATI A QUELLI TROVATI CON LA QUERY PRECEDENTE
-- * Imerio 09/02/2010
-- **************************************
select aa.codclifor, cc.dscconto1, aa.esercizio, aa.tipodoc, DD.CODART, QTa = left(DD.QTAGEST, 3), bb.prezzoeuro, dd.totnettoriga 
from testedocumenti aa, listiniarticoli bb, anagraficacf cc, righedocumenti dd
where aa.codclifor = cc.codconto      -- allinea le tabella RIGHEDOCUMENTI e LISTINIARTICOLI
and dd.codart = bb.codart             -- ALLINEA LE TABELLA TESTEDOCUMENTI E TABNAZIONI
and dd.idtesta = aa.progressivo		  -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.totnettoriga = 0               -- considera solo le righe a zero
AND DD.CODART <>''					  -- considera solo le righe con codice articolo
and bb.nrlistino = '112'			  -- usa listino 112

-- SELEZIONA CLIENTE
AND AA.CODCLIFOR LIKE 'C%'

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('OG1', 'OG2')

and aa.esercizio = '2009'
order by aa.tipodoc



-- ***********************************************************************************************
-- Fatture Clienti ExtraUE con Codice Iva in riga documento uguale a 289 (SPESOMETRO)
-- Richiesto da N. Creazzo
-- I. Rebellato 26/03/2015
-- ***********************************************************************************************

-- **** ELENCO CODICI PAESI UE (campo CODNAZIONE in ANAGRAFICACF) ****
-- 0-31: Italia, 1: Slovenia, 2: Francia, 3: Belgio, 4: Regno Unito, 5: Spagna, 6: Portogallo, 7: Grecia,
-- 8: germania, 9: Danimarca, 11: Svezia, 12: Irlanda, 13: Finlandia, 14: Austria, 15: Olanda, 21: Polonia, 22: Cipro,
-- 23: Ungheria, 24: Slovacchia, 29: Romania, 32 Lussemburgo, 70 Bulgaria
-- non codificate: Estonia, Lettonia, Lituania, Malta, Rep. Ceca

select td.esercizio, td.tipodoc, convert (date, td.datadoc, 103) as data_documento, td.numerodoc, td.codclifor, bb.dscconto1 as descrizione, cc.descrizione as nazione, 
rd.codiva, CONVERT(MONEY,RD.totnettoriga) AS NETTORIGA
from TESTEDOCUMENTI td
left join ANAGRAFICARISERVATICF AA on AA.CODCONTO=td.codclifor and aa.esercizio = '2014'
left join ANAGRAFICACF BB on AA.CODCONTO= BB.CODCONTO
left join tabnazioni cc on CC.CODICE=BB.CODNAZIONE
INNER JOIN righedocumenti RD ON TD.progressivo= RD.idtesta
where td.esercizio = '2014'
and AA.CODCONTO LIKE'C%'
and td.tipodoc like 'F%'
and RD.totnettoriga <> 0
and BB.CODNAZIONE NOT IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')
and rd.codiva = '  289'