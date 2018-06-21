
-- BREVETTI CEA 09/01/2013
-- Azzeramento dei costi relativi alle operazioni FAT (Operazione F011)
-- richiesta Imerio 17/12/2012

-- Azzeramento dei costi nelle sole OPERAZIONI APERTE
-- Elenco delle fasi aperte, per il codice operazione F011
select 
		rco.ANNOBOLLA, rco.NUMEROBOLLA,
		rco.TEMPOEFFMACCHINA as ORE_LAVORATE,
		tor.TIPOCOM, tor.ESERCIZIO, tor.NUMEROCOM, rop.IDRIGA, rop.RIFCOMMCLI,
		rop.CODART, rop.DESCRIZIONEART, rop.QTAGESTIONE as QTA_ORD, rop.QTAGESTIONEVERS as QTA_VERS, 
		rop.STATOORDINE as STATO_ORD, rco.STATOOPERAZIONE as STATO_FASE	
	from 
		RIGHECICLOORDINE rco
		inner join TESTACICLOORDINE tco on rco.PROGRESSIVO = tco.PROGRESSIVO
		inner join TESTEORDINIPROD tor on tco.IDTESTACOMM = tor.PROGRESSIVO
		inner join RIGHEORDPROD rop on tco.IDTESTACOMM = rop.IDTESTA and tco.IDRIGACOMM = rop.IDRIGA
	where
		rco.OPERAZIONE = 'F011' 
		and rco.STATOOPERAZIONE < 2
		and rop.STATOORDINE < 3
		

-- Azzeramento delle tariffe nelle fasi d'ordine
select 
		rco.QUC_ATTREZZAGGIO,
		rco.QUC_MACCHINA,
		rco.CP_MACCHINA,
		rco.CC_MACCHINA,
		rco.CP_EU_MACCHINA,
		rco.CC_EU_MACCHINA
	from 
		RIGHECICLOORDINE rco
		inner join TESTACICLOORDINE tco on rco.PROGRESSIVO = tco.PROGRESSIVO
		inner join TESTEORDINIPROD tor on tco.IDTESTACOMM = tor.PROGRESSIVO
		inner join RIGHEORDPROD rop on tco.IDTESTACOMM = rop.IDTESTA and tco.IDRIGACOMM = rop.IDRIGA
	where
		rco.OPERAZIONE = 'F011' 
		and rco.STATOOPERAZIONE < 2
		and rop.STATOORDINE < 3

begin tran
	update RIGHECICLOORDINE 
		set QUC_ATTREZZAGGIO = 0,
		    QUC_MACCHINA = 0,
			CP_MACCHINA = 0,
			CC_MACCHINA = 0,
			CP_EU_MACCHINA = 0,
			CC_EU_MACCHINA = 0
	from 
		RIGHECICLOORDINE rco
		inner join TESTACICLOORDINE tco on rco.PROGRESSIVO = tco.PROGRESSIVO
		inner join TESTEORDINIPROD tor on tco.IDTESTACOMM = tor.PROGRESSIVO
		inner join RIGHEORDPROD rop on tco.IDTESTACOMM = rop.IDTESTA and tco.IDRIGACOMM = rop.IDRIGA
	where
		rco.OPERAZIONE = 'F011' 
		and rco.STATOOPERAZIONE < 2
		and rop.STATOORDINE < 3
commit tran

-- NOTA BENE: andrebbero ricalcolati anche i costi previsti di lavorazione per gli ordini di produzione aggiornati
-- valutare se necessario
		

-- MOVIMENTI DI AVANZAMENTO DA MODIFICARE MANUALMENTE (PER LE BOLLE CON ORE LAVORATE <> 0)

