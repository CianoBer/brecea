
-- PROBLEMA ORDINI DI PRODUZIONE CON DATAFINERICH NULL NON ENTRANO IN PIANIFICAZIONE
-- Amadi 29/03/2016


select * from RIGHEORDPROD where DATAINIZIORICH is null or DATAFINERICH is null

-- Conteggio ordini buggati per mese di emissione
select 
		year(rop.DATAEMISSIONE) as AnnoEmOrd, month (rop.dataemissione) as MeseEmOrd,
		sum(1) as TotRigheOrdEm,
		sum((case when rop.datafinerich is null or rop.DATAINIZIORICH is null then 1 else 0 end)) as OrdBug  
	from 
		RIGHEORDPROD rop
		inner join TESTEORDINIPROD tor on rop.IDTESTA = tor.PROGRESSIVO
	--where 
	--	rop.DATAFINERICH is null or rop.DATAINIZIORICH is null
	group by
		year(rop.DATAEMISSIONE), month(rop.dataemissione)
	order by
		year(rop.DATAEMISSIONE), month(rop.dataemissione)

-- Query di correzione errori massiva
--begin tran
--	update
--		RIGHEORDPROD
--	set
--		DATAFINERICH = (case when DATAINIZIORICH is not null then DATAINIZIORICH else DATAEMISSIONE end)
--	where
--		DATAFINERICH is null 
--commit tran

--begin tran
--	update 
--		RIGHEORDPROD
--	set
--		DATAINIZIORICH = (case when DATAFINERICH is not null then DATAFINERICH else DATAEMISSIONE end)
--	where
--		DATAINIZIORICH is null 
--commit tran





