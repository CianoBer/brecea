--*****************************************
--* CONTROLLA SCADENZE CON IMPORTI UGUALI
--* A PARITA' DI CLIENTE
--* RICHIESTO DA N. CREAZZO
--*
--* AMADI 26/02/2015
--*****************************************

select 
             ts.codclifor, ts.esercizio, ts.annodoc, ts.tipodoc, ts.numdoc, convert (varchar,ts.datascadenza, 103) as data_scadenza, convert(varchar,ts.datafattura, 103) as data_fattura, 
			 ts.numeroprot, convert(money,ts.importosceuro) as importo, ts.esito
       from
             TABSCADENZE ts
       where
             (select COUNT(*) from TABSCADENZE ts1 where ts.IMPORTOSCEURO = ts1.IMPORTOSCEURO and ts.CODCLIFOR = ts1.CODCLIFOR) > 1
			 and ts.codclifor like 'C%'
			 and ts.importosceuro > 1
			 and ts.esito in (0,2)
			 and esercizio in (2014,2015,2016,2017)
       order by
             ts.CODCLIFOR,
             ts.IMPORTOSCEURO





-- scadenze che bloccano clienti 
-- (v. vista fatta da Reffo dbo.BRECEA_GIORNISCADENZA)
-- con aggiunta del nr documento e relativo valore

--SELECT     CODCLIFOR, impfatteuro , tipodoc, numdoc, annodoc, DATEDIFF(DD, DATASCADENZA, GETDATE()) AS GIORNI
--FROM       TABSCADENZE
--WHERE     (LEFT(CODCLIFOR, 1) = 'C') AND (ESITO IN (0, 1)) AND (DATEDIFF(DD, DATASCADENZA, GETDATE()) > 60) AND (IMPORTOSCEURO > 50) OR
--                      (LEFT(CODCLIFOR, 1) = 'C') AND (ESITO = 3) AND (IMPORTOSCEURO > 50)
--order by codclifor

-- ***********************************************************
-- VERIFICA FATTURE CON DATA SCADENZA INFERIORE A DATA FATTURA
--          Imerio 13/01/2010
-- ***********************************************************


SELECT     CODCLIFOR, impfatteuro , tipodoc, numdoc, datascadenza, datafattura, annodoc, DATEDIFF(DD, DATAFATTURA, DATASCADENZA) AS GIORNI
FROM       TABSCADENZE
WHERE     (LEFT(CODCLIFOR, 1) = 'C') AND (ESITO IN (0, 1)) 
--AND(DATASCADENZA - DATAFATTURA < 30)
and (datascadenza < datafattura)
and (annodoc >2008) 
--and tipodoc IN ('FX1', 'FX2', 'FR1', 'FR2', 'FV1', 'FV2')
order by codclifor