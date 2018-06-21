-- Brevetti CEA 30/08/2012
-- Controllo impegni ordini di produzione che non seguono il trasferimento di giacenza
-- Estrae un elenco degli impegni di produzione che hanno il magazzino non congruente con lo storico magazzzino
-- (accade con una certa frequenza per il magazzino Mecatronica)
-- SE LA SITUAZIONE E' CONSISTENTE, NON DEVE TORNARE ALCUN RECORD
-- si veda anche il manuale alla voce Faq c/l: Impegni che non seguono il trasferimento di giacenza
select 	
		iop.datamodifica, iop.UTENTEMODIFICA,
		(select DATAMODIFICA from STORICOMAG sma where iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP and sma.CODCAUSALE = 121)as DTMOD_STORICOMAG,
		(select UTENTEMODIFICA from STORICOMAG sma where iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP and sma.CODCAUSALE = 121)as DTMOD_STORICOMAG,
		tor.TIPOCOM, tor.esercizio, tor.numerocom, iop.IDRIGA, iop.deposito, 
		(select coddeposito from STORICOMAG sma where iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP and sma.CODCAUSALE = 121)as DEPOSITO_STORICOMAG,
		iop.* 
	from 
		IMPEGNIORDPROD iop
		inner join TESTEORDINIPROD tor on iop.IDTESTA = tor.PROGRESSIVO
	where 
		iop.QTA1MAGRES <> 0
		and iop.DEPOSITO <> (select coddeposito from STORICOMAG sma where iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP and sma.CODCAUSALE = 121)
	order by 
		iop.DATAMODIFICA desc


-- Elenco delle commesse di produzione con problemi nel magazzino di impegno
-- raggruppa ed elenca le commesse che nella query precedente hanno rilevato errori
select 	distinct
		tor.TIPOCOM, tor.ESERCIZIO, tor.NUMEROCOM
	from 
		IMPEGNIORDPROD iop
		inner join TESTEORDINIPROD tor on iop.IDTESTA = tor.PROGRESSIVO
	where 
		iop.QTA1MAGRES <> 0
		and iop.DEPOSITO <> (select coddeposito from STORICOMAG sma where iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP and sma.CODCAUSALE = 121)
	order by tor.NUMEROCOM

-- Correzione degli errori 

--update 
--		STORICOMAG
--	set
--		CODDEPOSITO= iop.DEPOSITO	
--	from 
--		IMPEGNIORDPROD iop
--		inner join STORICOMAG sma on iop.idtesta = sma.IDTESTA and iop.IDRIGA = sma.RIGADOC and iop.IDIMPEGNO = sma.RIGACOMP
--	where 
--		iop.QTA1MAGRES <> 0
--		and sma.CODCAUSALE = 121
--		and iop.DEPOSITO <> sma.CODDEPOSITO

