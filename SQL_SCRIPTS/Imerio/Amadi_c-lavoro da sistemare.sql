-- *********************************************************************************
-- * ESTRAZIONE DI TUTTE LE FASI CICLO CON CODICE OPERAZIONE C/LAVORO GENERICO (13901)
-- * RELATIVE AD ARTICOLI MOVIMENTATI DAL 1/1/2010 IN POI PER CORREGGERE IL CODICE 
-- * OPERAZIONE GENERICO 13901 USATO FINORA NEI CICLI DI C/LAVORO (ATTIVITA' IN
-- * CARICO A L. SCHENATO)
-- *  AMADI 08 MARZO 2011
-- * *******************************************************************************

select  tcr.progressivo, rcp.posizione, tcr.CODCICLO, aa.descrizione, tcr.VERSIONECICLO, rcp.NUMEROFASE, rcp.OPERAZIONE, rcp.DSCOPERAZIONE, rcp.NOTERIGA 
	from 
		RIGHECICLOPROD rcp
		inner join TESTACICLOPROD tcr on rcp.PROGRESSIVO = tcr.PROGRESSIVO
		inner join ANAGRAFICAARTICOLI aa on tcr.CODCICLO = aa.CODICE
	where
		rcp.OPERAZIONE = '13901'
		and tcr.CODCICLO in (select distinct codart from STORICOMAG where ESERCIZIO >= 2010)