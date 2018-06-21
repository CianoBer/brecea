
-- BREVETTI CEA: script per la generazione dei movimenti di ripresa a valore al 01/01/2010
------------------------------------------------------------------------------------------ 
-- E' stato verificato che alla partenza al 07/03/2009, per alcuni articoli con giacenza iniziale, non è stato
-- importato da AS/400 il relativo movimento di ripresa valore (generato per tutti gli altri articoli al 01/01/2009, causale 90)
-- TOTALI 1452 articoli
--
-- Per ALCUNI di questi articoli, pur mancando il movimento di ripresa originale, sono stati registrati alcuni carichi
-- per cui nel 2010 sono stati ripresi dei valori, con quantità parziali, che non sono stati mediati con la giacenza di partenza a marzo 2009
-- TOTALI 293 articoli
--
-- I movimenti di ripresa a valore 2010 relativi a questi 293 articoli, saranno mantenuti, per cui le correzioni dovrebbero riguardare
-- 1159 articoli
--
-- Alcuni di questi non hanno giacenza al 31/12/2009, per cui non necessitano di ripresa del valore nel 2010
--
-- L'ELABORAZIONE RIGUARDERA' QUINDI COMPLESSIVAMENTE 891 articoli

------------------------------------------------------------------------------------------ 


--  Articoli con inventario iniziale al 08/03/2009

--select distinct CODART  from STORICOMAG 
--	where 
--	CODCAUSALE = 501 
	
-- Articoli con movimenti di ripresa a valore iniziale al 01/01/2009

--select distinct CODART from STORICOMAG
--	where
--	CODCAUSALE = 90
--	and DATAMOV = '2009-01-01'
	
-- Articoli con giacenza iniziale 08/03/2009 e senza ripresa a valore al 01/01/2009
--
--select distinct CODART  from STORICOMAG 
--	where 
--	CODCAUSALE = 501 
--	and CODART NOT IN (
--		select distinct CODART from STORICOMAG
--			where
--			CODCAUSALE = 90
--			and ESERCIZIO IN (2009, 2010)
--	)

-- Creazione vista di appoggio Articoli Valore Iniziale MANCANTE

create view BCEA_TMP_RIPRESAVAL_MANCANTI as 
	select distinct CODART  from STORICOMAG 
		where 
		CODCAUSALE = 501 
		and CODART NOT IN 
			(
			select distinct CODART from STORICOMAG
				where
				CODCAUSALE = 90 
				and ESERCIZIO IN (2009, 2010)
			)
go

-- Creazione Vista di appoggio Prezzo ultimo carico al 31/12/2009 

create view BCEA_TMP_RIPRESAVAL_PREZZIULTIMI as
--	set dateformat ymd
	select row_number() over(partition by SP.CODARTICOLO order by SP.CODARTICOLO, SP.DATA desc) AS NRIGA, 
		   SP.CODARTICOLO AS CODARTICOLI, SP.DATA as DATEULTIME, SP.PREZZOEURO AS PREZZIULTIMI 
		from STORICOPREZZIARTICOLO SP
		where 
		TIPOPREZZO = 'F'
		and DATA <= '20091231'
go

create view BCEA_TMP_RIPRESAVAL_PREZZOULTIMO as
	select UP.CODARTICOLI AS CODARTICOLO, UP.DATEULTIME AS DATAULTIMA, UP.PREZZIULTIMI AS PREZZOULTIMO 
		from BCEA_TMP_RIPRESAVAL_PREZZIULTIMI UP
		where 
		UP.NRIGA = 1
go


-- Creazione Vista di appoggio giacenza 31/12/2009

create view BCEA_TMP_RIPRESAVAL_GIACENZE as
--	set dateformat ymd
	select SM.CODART, SUM(SM.QTA1UM * SM.giacenza)AS GIACENZA311209
		from STORICOMAG SM
		where SM.DATAMOV <= '20091231' 
		and SM.CODDEPOSITO not in ('015', '016', '017', '018') 
	group by SM.CODART
go

-- Creazione Vista di appoggio Articoli ripresa a valori mancante con relativo prezzo ultimo carico 31/12/2009 e giacenza 31/12/2009

create view BCEA_TMP_RIPRESAVAL_DAINSERIRE as 
	select ROW_NUMBER() OVER(ORDER BY AM.CODART) as NREC, AM.CODART, UC.PREZZOULTIMO, ISNULL(GI.GIACENZA311209, 0) AS GIACENZA  
		from BCEA_TMP_RIPRESAVAL_MANCANTI AM 
		inner join BCEA_TMP_RIPRESAVAL_PREZZOULTIMO UC on AM.CODART = UC.CODARTICOLO
		left outer join BCEA_TMP_RIPRESAVAL_GIACENZE GI on AM.CODART = GI.CODART
	where
		ISNULL(GI.GIACENZA311209, 0) <> 0
go

-- Inserimento movimenti di ripresa a valore al 01/01/2010
-- ATTENZIONE: SARANNO CANCELLATI DALL'EVENTUALE NUOVA ESECUZIONE DELLA GENERAZIONE RIPRESA VALORE DAL 2009!!
BEGIN TRAN

insert into STORICOMAG
	select 
		(select MAX(progressivo) from STORICOMAG) + DI.NREC		as PROGRESSIVO,
		DI.CODART												AS CODART,
		'F   131'												AS CODCLIFOR,
		90														AS CODCAUSALE,
		'20100101'												AS DATAMOV,
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
		DI.GIACENZA												as QTA1UM, 
		DI.GIACENZA												as QTA2UM, 
		0														as LISTINO,
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO * 1936.27), 0)		as IMPORTOTOTLORDO, 
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO), 2)				as IMPORTOTOTLORDOVAL, 
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO), 2)				as IMPORTOTOTLORDOEURO,
		'' 														as SCONTO, 
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO * 1936.27), 0)		as IMPORTOTOTNETTO, 
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO), 2)				as IMPORTOTOTNETTOVAL, 
		ROUND((DI.GIACENZA * DI.PREZZOULTIMO), 2)				as IMPORTOTOTNETTOEURO,
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
		2010													as ESERCIZIO, 
		''														as CODCOMMESSA,
		'import2010'  											as UTENTEMODIFICA, 
		GETDATE()												as DATAMODIFICA, 
		0														as ProgMovVBanco, 
		'20100101'												as DATADISP,
		0														as Reso, 
		0														as RigaCauz, 
		0														as SPESERIPMAG, 
		0														as SPESERIPMAGVAL, 
		0														as SPESERIPMAGEURO 
	from BCEA_TMP_RIPRESAVAL_DAINSERIRE DI
COMMIT TRAN	
	
-- Aggiorna tabella progressivi per lo storico magazzino STORICOMAG

update TABPROGRESSIVI
	set PROGR = (select MAX(progressivo) from STORICOMAG)
	where NOMETABELLA = 'STORICOMAG'
go	

-- Cancellazione viste appoggio

drop view BCEA_TMP_RIPRESAVAL_MANCANTI
go

drop view BCEA_TMP_RIPRESAVAL_PREZZIULTIMI
go

drop view BCEA_TMP_RIPRESAVAL_PREZZOULTIMO
go

drop view BCEA_TMP_RIPRESAVAL_GIACENZE
go

drop view BCEA_TMP_RIPRESAVAL_DAINSERIRE
go

-- Controllo progressivo STORICOMAG
SELECT MAX(PROGRESSIVO) AS ULTIMOMOVMAG FROM STORICOMAG

SELECT PROGR AS PROGRESSIVO_METODO FROM TABPROGRESSIVI WHERE NOMETABELLA = 'STORICOMAG'
