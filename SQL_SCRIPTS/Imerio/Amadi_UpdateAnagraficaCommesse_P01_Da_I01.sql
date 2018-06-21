
-- BREVETTI CEA 17/7/2015
-- Amadi 23/07/2015
-- Script SQL per l'aggiornamento anagrafica commesse da commessa di installazione (CCCCC-I01) su commessa di produzione (CCCCC-P01)


-- Anteprima delle modifiche
select 
		acp.RifComm, acp.DataInizioConsegna, acp.DataFineConsegna,
		(left (acp.RifComm, 5) + '-I01') as commessa_inst,
		aci.DataInizioConsegna, aci.DataFineConsegna
	from
		AnagraficaCommesse acp
		inner join AnagraficaCommesse aci on (left (acp.RifComm, 5) + '-I01') = aci.RifComm
	where 
		acp.rifcomm like '%-P01'

-- Query di aggiornamento
begin tran
	update
			AnagraficaCommesse
		set 
			DataInizioConsegna = aci.DataInizioConsegna,
			DataFineConsegna = aci.DataFineConsegna
		from
			AnagraficaCommesse 
			inner join AnagraficaCommesse aci on (left (AnagraficaCommesse.RifComm, 5) + '-I01') = aci.RifComm
		where 
			AnagraficaCommesse.rifcomm like '%-P01'
commit tran






