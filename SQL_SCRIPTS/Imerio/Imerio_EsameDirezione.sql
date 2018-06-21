-- ORDINI MACCHINE/ACCESSORI-UPGRADE

SELECT RD.RIFCOMMCLI , TD.codclifor, AC.dscconto1
FROM TESTEDOCUMENTI TD
INNER JOIN righedocumenti RD ON TD.progressivo= RD.idtesta	   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
INNER JOIN anagraficacf AC ON TD.codclifor = AC.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
where RD.totnettoriga > 0                -- non considera eventuali anticipi
-- SELEZIONA CLIENTE
AND TD.CODCLIFOR <> 'C    26' -- ESCLUDE AUTOFATTURAZIONI SU BREVETTI CEA
-- MACCHINE
--AND RD.RIFCOMMCLI LIKE '%-P0%'
-- ACCESSORI-UPGRADE
AND (RD.RIFCOMMCLI LIKE '%-A0%' OR RD.RIFCOMMCLI LIKE '%-U0%')
and TD.tipodoc IN ('FM1', 'FM2', 'FX1', 'FX2')
and TD.esercizio = '2011'
GROUP BY RD.RIFCOMMCLI, TD.codclifor, AC.dscconto1
ORDER BY RD.RIFCOMMCLI





-- *********************************************************************
-- * FATTURATO COMPLESSIVO MACCHINE, ACCESSORI, UPGRADE
-- * VERIFICANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE DI ANTICIPO)
-- * Imerio 09/02/2010
-- *********************************************************************
select TD.codclifor, AC.dscconto1, TN.descrizione AS NAZIONE, TD.esercizio, TD.tipodoc,TD.numerodoc, 
	RD.RIFCOMMCLI, CONVERT(MONEY,RD.totnettoriga) AS NETTORIGA
from testedocumenti TD
INNER JOIN anagraficacf AC ON TD.codclifor = AC.codconto      -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
INNER JOIN tabnazioni TN ON AC.codnazione = TN.codice          -- ALLINEA LE TABELLA ANAGRAFICACF E TABNAZIONI
INNER JOIN righedocumenti RD ON TD.progressivo= RD.idtesta	   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
where RD.totnettoriga > 0                -- non considera eventuali anticipi

-- SELEZIONA CLIENTE
AND TD.CODCLIFOR <> 'C    26' -- ESCLUDE AUTOFATTURAZIONI SU BREVETTI CEA

-- SELEZIONA NAZIONE
--and AC.codnazione IN ('33', '53') -- USA e CANADA
-- PAESI UE
--AND AC.CODNAZIONE IN ('    0', '   31', '    1', '    2', '    3', '    4', '    5', '    6', '    7',
--'    8', '    9', '   11', '   12', '   13', '   14', '   15', '   21', '   22', '   23', '   24', '   29', '   32')

-- SOLO MACCHINE
--AND RD.RIFCOMMCLI LIKE '%-P0%'
-- SOLO ACCESSORI-UPGRADE
--AND (RD.RIFCOMMCLI LIKE '%-A0%' OR RD.RIFCOMMCLI LIKE '%-U0%')
-- MACCHINE E ACCESSORI-UPGRADE INSIEME
AND (RD.RIFCOMMCLI LIKE '%-P0%' OR RD.RIFCOMMCLI LIKE '%-A0%' OR RD.RIFCOMMCLI LIKE '%-U0%')

-- MACCHINE/ACCESSORI-UPGRADE
and TD.tipodoc IN ('FM1', 'FM2', 'NC1', 'NC2', 'FX1', 'FX2')
-- SOLO RICAMBI
--and TD.tipodoc IN ('FR1', 'FR2', 'CR1', 'CR2')
-- SOLO GARANZIE
--AND TD.tipodoc IN ('OG1', 'OG2')
--SOLO C/VISIONI
--and TD.tipodoc IN ('FV1', 'FV2')

and TD.esercizio = '2011'
order by TD.codclifor, TD.tipodoc



-- **************************************
-- * TOTALI FATTURATI  X CLIENTI (PARETO)
-- * SOMMANDO IL TOT NETTO RIGA NELLE RIGHE DEL DOCUMENTO
-- * SOLO PER I VALORI > 0 (ELIMINA QUINDI EVENTUALI RIGHE NEGATIVE) 
-- * DATI FORNITI: COD CLIENTE, RAG SOCIALE, FATTURATO TOTALE
-- * Imerio 23/04/2010
-- **************************************
select aa.codclifor, cc.dscconto1, Tot_Imponibile_righe = CONVERT(MONEY,sum(dd.totnettoriga))
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
	AND aa.tipodoc IN ('FM1', 'FM2', 'NC1', 'NC2', 'FX1', 'FX2') -- MACCHINE/ACCESSORI-UPGRADE

-- MACCHINE E ACCESSORI-UPGRADE INSIEME
AND (DD.RIFCOMMCLI LIKE '%-P0%' OR DD.RIFCOMMCLI LIKE '%-A0%' OR DD.RIFCOMMCLI LIKE '%-U0%')

-- SELEZIONA ANNO PER TESTEDOCUMENTI E PER ANAGRAFICARISERVATICF
	and aa.esercizio = '2011'

group by aa.codclifor, cc.dscconto1
order by Tot_Imponibile_righe DESC



--***************************************
-- Numero righe BCF caricate
--***************************************

SELECT codclifor,  ac.dscconto1, td.esercizio, td.tipodoc, td.numerodoc, codart, descrizioneart, umgest, convert(real, qtagest) as QTA
FROM RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
left join ANAGRAFICACF ac on ac.codconto = td.codclifor
WHERE
TD.ESERCIZIO = '2016'
AND RD.QTAGEST <> 0
AND TD.TIPODOC = 'BCF'
