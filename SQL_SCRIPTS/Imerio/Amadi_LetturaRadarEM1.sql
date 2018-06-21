-- BREVETTI CEA
-- LETTURA RADAR PER UN ORDINE DI PRODUZIONE DATO 
--	AMADI 12/03/2015
------------------------------------------------------------------------------

declare @nomepianif varchar(50)
declare @tipocom varchar(3)
declare @esercizio integer
declare @numerocomm integer
declare @IDPIANO integer
declare @RIGAORD integer
declare @IDTESTACOMM integer

-- IMPOSTARE IL NUMERO ORDINE DI PRODUZIONE ED IL NOME PIANO MODIFICANDO QUESTE VARIABILI --------------------------------------

set @nomepianif = '01_PIANIFICAZIONE_GENERALE'
set @tipocom = 'EM1'
set @numerocomm = 450
set @esercizio = 2015
set @rigaord = 1








---------------------------------------------------------------------------------------------------------------------------------

set @IDTESTACOMM =	(
		select
			tor.PROGRESSIVO
		from
			testedocumenti tor
			--TESTEORDINIPROD tor
		where
			tipodoc = @tipocom
			--TIPOCOM = @tipocom
			and ESERCIZIO = @esercizio
			and numerodoc = @numerocomm
			--and NUMEROCOM = @numerocomm
					)
set @IDPIANO =		(
	select 
			pp.PROG_ID
		from
			PROGPRODUZIONE pp
		where
			pp.NOMEPIANIF = @nomepianif
			and pp.TIPO = 3 
			and pp.IDTESTADOC = @IDTESTACOMM
			and pp.IDRIGADOC = @RIGAORD
					)

select 
		PP.RIFCOMMCLI, LEG.LIVELLO as LIVELLO, PP.TIPODOC, PP.IDRIGADOC, PP.IDIMPEGNO, PP.RIFERIMENTI, CONVERT(VARCHAR, PP.DATAORD, 103) AS DATA_DOC,
		 PP.CODART, PP.DSCARTICOLO, PP.UMBASE, CONVERT(REAL, PP.QTABASE) AS QTA_BASE, CONVERT(VARCHAR, PP.DATACONS, 103) AS DATA_CONSEGNA, 
		 PP.GIORNIRITARDO,	-- Ritardo rispetto alla DATA CONSEGNA CONCORDATA
		 PP.RITARDO AS GGATTESA,  -- Differenza tra DATA CONSEGNA e DATA ODIERNA
		 PP.SETTIMANADISP, PP.CODCLIFOR, PP.RAGSOCCLIFOR 
	from 
		VISTASITUAZIONEPROGPROD PP 
		inner join dbo.[MAPS_NAVIGAPROGPRODVALLE](@nomepianif,  @idpiano) LEG on PP.NOMEPIANIF=LEG.NOMEPIANIF and PP.PROG_ID=LEG.PROG_ID 
	order by 
		LEG.LIVELLO,PP.CODART



