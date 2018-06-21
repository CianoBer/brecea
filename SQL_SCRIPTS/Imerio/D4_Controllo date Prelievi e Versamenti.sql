-- Brevetti cea 
-- Ricerca articoli con prelievi (per produzione interna, causale 123) antecedenti 
-- i versamenti effettuati per carico da fornitore, carico da produzione interna o carico per reso da commessa
-- AMADI 05 SETTEMBRE 2012
-- Attenzione, è necessario verificare articolo per articolo, in alcuni casi potrebbe 
-- essere che ci fosse una giacenza iniziale disponibile, oppure un movimento di reso 
-- da un’altra commessa (che in questo caso deve essere valorizzato).

-- ESERCIZIO 2014 - 2015 - 2016 - 2017


--* prepara vista con i dati di storicomag relativi a operazioni di 
--* 2 = scarico magazzino
--* 90 = movim. ripresa valore
--* 115 = carico da fornitore
--* 122 = carico da produzione interna
--* 123 = prelievo per produzione interna
--* 136,141 = carico per reso da commessa
--* raggruppando le operazioni effettuate nello stesso giorno
DROP VIEW BCEA_PREL_VERS
GO

CREATE VIEW BCEA_PREL_VERS AS
SELECT  
	    SM.CODART, SM.ESERCIZIO, SM.DATAMOV, SUM(SM.CODCAUSALE) AS CODCAUSALE
	FROM 
		STORICOMAG SM
	WHERE 
		SM.CODCAUSALE IN (90,123, 2, 122, 115, 136,141) -- 2= scarico magazzino, 90 ripr. val. medio, 115 carico da fornit, 122 carico da prod. int., 123 prel. per prod. int.
														-- 136 reso da commessa, 141 carico per resa da commessa
	GROUP BY 
		SM.CODART, SM.ESERCIZIO, SM.DATAMOV
GO

GRANT SELECT ON BCEA_PREL_VERS TO METODO98
GO


DROP VIEW BCEA_PREL_VERS_2
GO

--* prepara una seconda vista partendo dalla precedente assegnando un progressivo (IDMOV) per ciascuna ricorrenza di codice-esercizio
--* in pratica mette in ordine per data e numera (idmov) quante volte un codice nell'ambito dello stesso esercizio appare nella vista precedente
CREATE VIEW BCEA_PREL_VERS_2 AS
SELECT 
	    ROW_NUMBER() OVER (PARTITION BY BV.CODART, BV.ESERCIZIO ORDER BY BV.CODART, BV.ESERCIZIO, BV.DATAMOV) AS IDMOV, 
	    BV.CODART, BV.ESERCIZIO, BV.DATAMOV, BV.CODCAUSALE
	FROM 
		BCEA_PREL_VERS BV
GO

GRANT SELECT ON BCEA_PREL_VERS_2 TO METODO98
GO


-- verifica (ed estrae) dalla vista precedente i codici di PRODUZIONE (provenienza = 1)
-- che come primo movimento (idmov = 1) nell'esercizio hanno avuto un Prelievo per Produzione (causale 123)
-- Potenzialmente questi sono articoli che hanno avuto un prelievo prima di ogni altro tipo di movimento

SELECT DISTINCT BV2.CODART, BV2.ESERCIZIO, convert(varchar, BV2.DATAMOV, 105) as dataprelievo, BV2.CODCAUSALE
	FROM BCEA_PREL_VERS_2 BV2
		INNER JOIN ANAGRAFICAARTICOLIPROD AAP ON BV2.CODART = AAP.CODICEART AND AAP.ESERCIZIO = 2017
WHERE
	BV2.IDMOV = 1 AND (BV2.CODCAUSALE = 123 or BV2.CODCAUSALE=2) AND AAP.PROVENIENZA = 1 
	AND BV2.ESERCIZIO in (2014, 2015, 2016, 2017) and BV2.DATAMOV > '2017-01-01'
ORDER BY BV2.ESERCIZIO, BV2.CODART
