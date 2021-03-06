--********************************************************
--*              AMADI OTTOBRE 2010
--* ESTRAZIONE ORE DIRETTE VERSATE TRAMITE CODICE A BARRE
--********************************************************
set dateformat dmy
SELECT	
	(SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO) AS DIP_CODE,      
	--(SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) AS DIP_NOME, 
     (SELECT NOME FROM TABELLADIPENDENTI WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) AS DIP_NOME,
	 (SELECT COGNOME FROM TABELLADIPENDENTI WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) AS DIP_COGNOME,
	 VB.CODCICLO, SA.CODCAUSALE, CA.DESCRIZIONE, SA.PROGRESSIVO AS NR_MOV, SA.NUMEROBOLLA, VB.OPERAZIONE, VB.DSCOPERAZIONE, VB.CDLAVORO,CL.DESCRIZIONE,
     convert(varchar, SA.DATAINIZIOMACCHINA, 105) AS DATAINZ, convert(varchar, SA.ORAINIZIOMACCHINA, 108) AS ORAINZ, convert(varchar, SA.DATAFINEMACCHINA, 105) AS DATAFN, 
     convert(varchar,SA.ORAFINEMACCHINA, 108) AS ORAFN, CONVERT(REAL,SA.OREMACCHINA) AS OREUOMO, CONVERT(VARCHAR,SA.DATAMOV, 105)AS DATAMV

FROM STORICOAVANZAMENTI SA
	 INNER JOIN VISTABOLLELAVORAZIONE VB ON SA.ANNOBOLLA = VB.ANNOBOLLA AND SA.NUMEROBOLLA = VB.NUMEROBOLLA
	 LEFT JOIN TABCAUSALIAVANZAMENTO CA ON SA.CODCAUSALE = CA.CODICE
	 LEFT JOIN TABELLACDLAVORO CL ON VB.CDLAVORO = CL.CODICE
	
WHERE
	-- seleziona periodo     
	((SA.DATAINIZIOMACCHINA >= '01/01/2014')) -- AND (SA.DATAINIZIOMACCHINA <= '31/01/2014'))
	
	-- seleziona nome dipendente
	--and (SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI 
		--WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) LIKE '%ansaldi%'

	-- seleziona causale versamento
	AND (SA.CODCAUSALE in (100,200))		-- 100=attivit� legate a una commessa; 200=attivit� generiche indirette pers. produzione
	and OPERAZIONE = 'f010' -- collaudi

	-- seleziona codciclo (in pratica la commessa)
	--AND (VB.CODCICLO = '00Y1038-P01')

	-- considera solo le righe con codice dipendente diverso da NULL
	AND (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)IS NOT NULL
	
	-- cerca dichiarazioni errate (superiori alle 11 ore)
	--and SA.OREMACCHINA > 11 and SA.ORAINIZIOMACCHINA is not NULL

	-- cerca dichiarazioni errate (negative)
	--and SA.OREMACCHINA <0 and SA.ORAINIZIOMACCHINA is not NULL
ORDER BY DIP_CODE, DATAINIZIOMACCHINA, orainiziomacchina


-- **********************************************************************************
-- RESTITUISCE LA SOMMA COMPLESSIVA DELLE ORE INDIVIDUATE NELLA PRECEDENTE SELEZIONE
-- **********************************************************************************
set dateformat dmy
SELECT	
	SUM(CONVERT(REAL,SA.OREMACCHINA)) AS ORE
FROM STORICOAVANZAMENTI SA
	 INNER JOIN VISTABOLLELAVORAZIONE VB ON SA.ANNOBOLLA = VB.ANNOBOLLA AND SA.NUMEROBOLLA = VB.NUMEROBOLLA
	WHERE     
	-- seleziona periodo     
	(SA.DATAINIZIOMACCHINA >= '01/05/2014') and (SA.DATAINIZIOMACCHINA <= '31/05/2014')

	-- seleziona nome dipendente
	--and (SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI 
		--WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) like '%rabino%'

	-- seleziona causale versamento
	AND (SA.CODCAUSALE in(100,220))
	--and OPERAZIONE = 'F010' -- collaudi

	-- considera solo le righe con codice dipendente diverso da NULL
	AND (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)IS NOT NULL

--SELECT TOP 10 * FROM VISTABOLLELAVORAZIONE



--*******************************************************************************************
-- ESTRAE ELENCO DICHIARAZIONI DI INIZIO LAVORAZIONE, NON CHIUSE E APERTE DA PIU' DI 1 GIORNO
-- PER VERIFICARLE LANCIARE "RILEVAZIONE DATI FABBRICA" E INSERIRE IL NUMEROBADGE DEL DIPENDENTE
-- POSIZIONARSI POI SU "INTERROGAZIONE". LA DICHIARAZIONE APERTA DOVREBBE ESSERE LA PRIMA DELLA LISTA IN LATO
--* Fornire a inizio mese dati a Elisa per verifica eventuali
--* situazioni anomale in WIP
--*******************************************************************************************
select	TC.DIPENDENTE, DI.NUMEROBADGE, DI.COGNOME, DI.NOME,
		TC.ANNOBOLLA, TC.NUMEROBOLLA, VB.RIFCOMMCLI, VB.OPERAZIONE, VB.DSCOPERAZIONE, tf.stato, tf.progressivo, tf.causale,
		TD.ORARILEVAMENTO AS DATA_ORA_INIZIO,
		DATEDIFF(hour, TD.ORARILEVAMENTO, GETDATE()) AS ORE_ACCUMULATE
	from 
		TDA_FEEDBACK TF
		INNER JOIN TDA_DETTFEEDBACK_TEMPI TD ON TF.PROGRESSIVO = TD.RIFPROGRESSIVO
		INNER JOIN TDA_DETTFEEDBACK_CONSUNTIVO TC ON TF.PROGRESSIVO = TC.RIFPROGRESSIVO
		INNER JOIN TABELLADIPENDENTI DI ON TC.DIPENDENTE = DI.CODICE
		INNER JOIN VISTABOLLELAVORAZIONE VB ON TC.ANNOBOLLA = VB.ANNOBOLLA AND TC.NUMEROBOLLA = VB.NUMEROBOLLA
	where 
		TF.stato <> 4
		--tc.dipendente = 109
		and TF.causale = 1
		and DATEDIFF(hour, TD.ORARILEVAMENTO, GETDATE()) > 12 --VERIFICA LE DICHIARAZIONE CHE HANNO SUPERATO LE 12 ORE



--*****************************************************
-- FORZA LA CHIUSURA DELLE DICHIARAZIONI DI CUI SOPRA,
--  SENZA CHE SIA GENERATO ALCUN MOVIMENTO IN METODO
--*****************************************************

--update TDA_FEEDBACK
--	set TDA_FEEDBACK.stato = 4,
--		TDA_FEEDBACK.utentemodifica = 'CHIUSURA FORZATA',
--		TDA_FEEDBACK.datamodifica = getdate()
--	from
--	TDA_FEEDBACK TF
--		INNER JOIN TDA_DETTFEEDBACK_TEMPI TD ON TF.PROGRESSIVO = TD.RIFPROGRESSIVO
--		INNER JOIN TDA_DETTFEEDBACK_CONSUNTIVO TC ON TF.PROGRESSIVO = TC.RIFPROGRESSIVO
--		INNER JOIN TABELLADIPENDENTI DI ON TC.DIPENDENTE = DI.CODICE
--	where 
--		TF.stato <> 4
--		and TF.causale = 1
--		and DATEDIFF(hour, TD.ORARILEVAMENTO, GETDATE()) > 12



--*********************************************
--* Verifica ore Collaudo e Fat in determinate Commesse
--* richiesta da E. Targon
--* (caricare la lista delle commesse in una tabella xxxxCommesseA35)
--* Rebellato (05/11/2013)
--*************************************************

set dateformat dmy
SELECT	
	VB.CODCICLO, (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO) AS DIP_CODE,      
	(SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) AS DIP_NOME, 
      SA.CODCAUSALE, SA.PROGRESSIVO AS NR_MOV, SA.NUMEROBOLLA, VB.OPERAZIONE, VB.CDLAVORO, VB.DSCOPERAZIONE,
     convert(varchar, SA.DATAINIZIOMACCHINA, 105) AS DATAINZ, convert(varchar, SA.ORAINIZIOMACCHINA, 108) AS ORAINZ, convert(varchar, SA.DATAFINEMACCHINA, 105) AS DATAFN, 
     convert(varchar,SA.ORAFINEMACCHINA, 108) AS ORAFN, CONVERT(REAL,SA.OREMACCHINA) AS OREUOMO, CONVERT(VARCHAR,SA.DATAMOV, 105)AS DATAMV

FROM STORICOAVANZAMENTI SA
	 INNER JOIN VISTABOLLELAVORAZIONE VB ON SA.ANNOBOLLA = VB.ANNOBOLLA AND SA.NUMEROBOLLA = VB.NUMEROBOLLA
	 inner join xxxxCommesseA35 A35 ON A35.COMMESSA = VB.CODCICLO
	
WHERE
	-- seleziona periodo     
	--((SA.DATAINIZIOMACCHINA >= '01/07/2013')) -- AND (SA.DATAINIZIOMACCHINA <= '31/03/2013'))

	-- seleziona nome dipendente
	--and (SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI 
		--WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) LIKE '%bicego %'

	-- seleziona causale versamento
	OPERAZIONE IN ('F010', 'F011') -- F010=collaudi, F011=Fat

	-- considera solo le righe con codice dipendente diverso da NULL
	AND (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)IS NOT NULL
	
ORDER BY codciclo, DIP_CODE, DATAINIZIOMACCHINA, orainiziomacchina




--*********************************************
--* CORREZIONE DATAMOVIMENTO PER LE DICHIARAZIONI
--* CHE PER QUALCHE MOTIVO HANNO DATA MOVIMENTO ERRATO
--* AMADI 30/01/2014
--************************************************

set dateformat dmy
SELECT	
	(SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO) AS DIP_CODE,      
	(SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) AS DIP_NOME, 
     VB.CODCICLO, SA.CODCAUSALE, SA.PROGRESSIVO AS NR_MOV, SA.NUMEROBOLLA, VB.OPERAZIONE, VB.CDLAVORO, VB.DSCOPERAZIONE,
     convert(varchar, SA.DATAINIZIOMACCHINA, 105) AS DATAINZ, convert(varchar, SA.ORAINIZIOMACCHINA, 108) AS ORAINZ, convert(varchar, SA.DATAFINEMACCHINA, 105) AS DATAFN, 
     convert(varchar,SA.ORAFINEMACCHINA, 108) AS ORAFN, CONVERT(REAL,SA.OREMACCHINA) AS OREUOMO, CONVERT(VARCHAR,SA.DATAMOV, 105)AS DATAMV

FROM STORICOAVANZAMENTI SA
	 INNER JOIN VISTABOLLELAVORAZIONE VB ON SA.ANNOBOLLA = VB.ANNOBOLLA AND SA.NUMEROBOLLA = VB.NUMEROBOLLA
	
WHERE
	-- seleziona periodo     
	((sa.datamov = '31/12/2012')) 
	
	-- seleziona nome dipendente
	--and (SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI 
		--WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) LIKE '%ansaldi%'

	-- seleziona causale versamento
	AND (SA.CODCAUSALE in (100,200))
	--and OPERAZIONE = 'F010' -- collaudi

	-- considera solo le righe con codice dipendente diverso da NULL
	AND (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)IS NOT NULL
	
		-- cerca dichiarazioni errate (negative)
	--and SA.OREMACCHINA <0 and SA.ORAINIZIOMACCHINA is not NULL
ORDER BY DIP_CODE, DATAINIZIOMACCHINA, orainiziomacchina


--update STORICOAVANZAMENTI set DATAMOV = DATAFINEMACCHINA,ESERCIZIO = 2014
--where datamov = '31/12/2012'and CODCAUSALE <> 22




--***************************************************
--* ORE MACCHINE UTENSILI PER COMMESSA
--* Richiesto da Michela il 14/06/2016
--**************************************************

set dateformat dmy
SELECT	
	     VB.CODCICLO, VB.OPERAZIONE, VB.DSCOPERAZIONE,SUM(CONVERT(REAL,SA.OREMACCHINA)) AS OREUOMO

FROM STORICOAVANZAMENTI SA
	 INNER JOIN VISTABOLLELAVORAZIONE VB ON SA.ANNOBOLLA = VB.ANNOBOLLA AND SA.NUMEROBOLLA = VB.NUMEROBOLLA
	
WHERE
	-- seleziona periodo     
	((SA.DATAINIZIOMACCHINA >= '01/01/2014')  AND (SA.DATAINIZIOMACCHINA <= '31/12/2014'))
	
	-- seleziona nome dipendente
	--and (SELECT (COGNOME + ' ' + NOME) FROM TABELLADIPENDENTI 
		--WHERE CODICE = (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)) LIKE '%ansaldi%'

	-- seleziona causale versamento
	--AND (SA.CODCAUSALE in (100,200))		-- 100=attivit� legate a una commessa; 200=attivit� generiche indirette pers. produzione
	and OPERAZIONE = '15001' -- Macchine utensili

	-- seleziona codciclo (in pratica la commessa)
	--AND (VB.CODCICLO = '00Y1038-P01')

	-- considera solo le righe con codice dipendente diverso da NULL
	AND (SELECT TOP 1 DIPENDENTE FROM DIPENDENTIMOVIMENTO WHERE RIFPROGRESSIVO = SA.PROGRESSIVO)IS NOT NULL
	
GROUP BY VB.CODCICLO, VB.OPERAZIONE, VB.DSCOPERAZIONE 
ORDER BY CODCICLO
