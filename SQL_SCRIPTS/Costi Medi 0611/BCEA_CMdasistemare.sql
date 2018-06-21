-- BREVETTI CEA
-- INSERIMENTO PREZZI MEDI MANCANTI CON COSTI ULTIMO ACQUISTO, AL 01/01/2011
-- COME DA FILE XLS FORNITO DA I. REBELLATO 02/06/2011

-- Tramite applicazione MS ACCESS sono stati caricati in una tabella temporanea articoli e costi da inserire, importati dal file XLS
-- In totale 582 articoli
select * from 
	bcea_medidains0611
-- Ciascun articolo è presente solo in una riga della tabella medi da inserire
select articolo, count(1) from bcea_medidains0611
	group by articolo
	having count(1) > 1

-- Alcuni di questi hanno già movimento di ripresa valore al 01/01/2011
-- 514 righe
select med.costoultimo, sma.*
	from storicomag sma
	inner join bcea_medidains0611 med on sma.codart = med.articolo
	where 
	sma.esercizio = 2011
	and sma.codcausale = 90	

-- Per questi 514 articoli aggiornamo prezzo unitario e valore complessivo del movimento su STORICOMAG
begin tran
update storicomag 
	set
		storicomag.IMPORTOTOTLORDO =		ROUND((storicomag.QTA1UM * MD.COSTOULTIMO * 1936.27), 0), 
		storicomag.IMPORTOTOTLORDOVAL =		ROUND((storicomag.QTA1UM * MD.COSTOULTIMO), 2), 
		storicomag.IMPORTOTOTLORDOEURO =	ROUND((storicomag.QTA1UM * MD.COSTOULTIMO), 2),
		storicomag.IMPORTOTOTNETTO =		ROUND((storicomag.QTA1UM * MD.COSTOULTIMO * 1936.27), 0), 
		storicomag.IMPORTOTOTNETTOVAL =		ROUND((storicomag.QTA1UM * MD.COSTOULTIMO), 2),
		storicomag.IMPORTOTOTNETTOEURO =	ROUND((storicomag.QTA1UM * MD.COSTOULTIMO), 2)
	from
		storicomag 
		inner join bcea_medidains0611 md on storicomag.codart = md.articolo
	where 
	storicomag.esercizio = 2011
	and storicomag.codcausale = 90	
commit tran


-- Per questi articoli non esiste un movimento di ripresa valore al 01/01/2011
-- 68 righe
select med.*
	from bcea_medidains0611 med
		where 
			(select distinct codart from storicomag where esercizio = 2011 and codcausale = 90 and codart = med.articolo) is null

---- Inserimento movimenti di ripresa a valore al 01/01/2011 per i 68 articoli che ne sono privi (15/06/2011)
---- ATTENZIONE: SARANNO CANCELLATI DALL'EVENTUALE NUOVA ESECUZIONE DELLA GENERAZIONE RIPRESA VALORE DAL 2010!!
BEGIN TRAN

set dateformat ymd
  insert into STORICOMAG
	select 
		(select MAX(progressivo) from STORICOMAG) + MD.ROWNUM	as PROGRESSIVO,
		MD.ARTICOLO												AS CODART,
		'F   131'												AS CODCLIFOR,
		90														AS CODCAUSALE,
		'2011-01-01'												AS DATAMOV,
		1														AS QUANTITACARICO,
		1														as VALORECARICO,
		0														as QUANTITASCARICO, 
		0														as VALORESCARICO,
		0														as GIACENZA,
		0														as ORDINATO, 
		0														as IMPEGNATO,
		0														as GIACENZA2UM, 
		0														as ORDINATO2UM, 
		0														as IMPEGNATO2UM,
		MD.QTA   												as QTA1UM, 
		MD.QTA  												as QTA2UM, 
		0														as LISTINO,
		ROUND((MD.QTA * MD.COSTOULTIMO * 1936.27), 0)	    	as IMPORTOTOTLORDO, 
		ROUND((MD.QTA * MD.COSTOULTIMO), 2)						as IMPORTOTOTLORDOVAL, 
		ROUND((MD.QTA * MD.COSTOULTIMO), 2)						as IMPORTOTOTLORDOEURO,
		'' 														as SCONTO, 
		ROUND((MD.QTA * MD.COSTOULTIMO * 1936.27), 0)			as IMPORTOTOTNETTO, 
		ROUND((MD.QTA * MD.COSTOULTIMO), 2)		         		as IMPORTOTOTNETTOVAL, 
		ROUND((MD.QTA * MD.COSTOULTIMO), 2)       				as IMPORTOTOTNETTOEURO,
		95														as CODCAMBIO,
		0														as VALCAMBIO, 
		''														as GENVENACQ, 
		''														as IDDISTINTABASE, 
		''														as NRIFDOC, 
		NULL													as DATARIFDOC, 
		''														as RIFERIMENTI,
		0														as DESTDIV, 
		''														as NRIFPARTITA, 
		900														as CODPAG, 
		NULL													as PROGRCOLLEGATO, 
		''														as CONTOCDCMOV, 
		'100'													as CODDEPOSITO, 
		''														as CODUBICAZIONE, 
		''														as TIPODOC, 
		0														as NUMERODOC, 
		''														as BIS, 
		NULL													as RIGADOC, 
		NULL													as IDTESTA, 
		''														as VARIANTE, 
		0														as TIPOMOV,
		0														as RIGACOMP,
		2011													as ESERCIZIO, 
		''														as CODCOMMESSA,
		'import0611'  											as UTENTEMODIFICA, 
		GETDATE()												as DATAMODIFICA, 
		0														as ProgMovVBanco, 
		'2011-01-01'												as DATADISP,
		0														as Reso, 
		0														as RigaCauz, 
		0														as SPESERIPMAG, 
		0														as SPESERIPMAGVAL, 
		0														as SPESERIPMAGEURO 
	from bcea_medidains0611 MD 
	where 
		(select distinct codart from storicomag where esercizio = 2011 and codcausale = 90 and codart = MD.articolo) is null
	order by rownum 
commit  TRAN	
	
---- Aggiorna tabella progressivi per lo storico magazzino STORICOMAG
--
update TABPROGRESSIVI
	set PROGR = (select MAX(progressivo) from STORICOMAG)
	where NOMETABELLA = 'STORICOMAG'
go	
--
---- Controllo progressivo STORICOMAG
SELECT MAX(PROGRESSIVO) AS ULTIMOMOVMAG FROM STORICOMAG

SELECT PROGR AS PROGRESSIVO_METODO FROM TABPROGRESSIVI WHERE NOMETABELLA = 'STORICOMAG'