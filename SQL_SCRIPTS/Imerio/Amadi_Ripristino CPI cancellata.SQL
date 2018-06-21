
-- AMADI 30/06/2016
-- Ripristino CPI/2016/1083/3 da DITTAPRO, causa cancellazione utente

-- Cerco progressivo testa: 12180
select * from TESTEORDINIPROD where ESERCIZIO = 2016 and TIPOCOM = 'CPI' and NUMEROCOM = 1083

-- Controllo righe esistenti
select * from RIGHEORDPROD where idtesta = 12180

-- Ripristino da DITTAPRO ordine, impegni, testa ciclo e righe ciclo
begin tran
	insert into RIGHEORDPROD
		select
				rop.* 
			from
				DITTAPRO..righeordprod rop
			where
				rop.idtesta = 12180
				and rop.idriga = 3

	insert into IMPEGNIORDPROD
		select
				iop.*
			from
				DITTAPRO..IMPEGNIORDPROD iop
			where
				iop.IDTESTA = 12180
				and iop.IDRIGA = 3
	
	insert into TESTACICLOORDINE
		select
				tco.*
			from
				DITTAPRO..TESTACICLOORDINE tco
			where
				tco.IDTESTACOMM = 12180
				and tco.IDRIGACOMM = 3
	
	insert into RIGHECICLOORDINE
		select 
				rco.* 
			from 
				DITTAPRO..RIGHECICLOORDINE rco
			where
				rco.PROGRESSIVO = 91802
commit tran
