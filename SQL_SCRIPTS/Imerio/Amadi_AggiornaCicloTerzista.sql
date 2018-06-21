
-- IMPOSTAZIONE NUOVO FORNITORE TERZISTA PER FASE ESTERNA


-- Imposto tutte le fasi come esterne (150)
--begin tran
--update righecicloprod 
--	set tipofase = 1	
--where operazione in ('13902', '13903') and tipofase <> 1
--
--commit tran



-- Imposto per tutte le fasi il fornitore preferenziale richiesto (22 righe)
--begin tran
--update  righecicloprod 
--	set fornitorepref = 'F   374'	
--where operazione in ('13902', '13903') and fornitorepref <> 'F   374'
--
--commit tran

-- Controllo che per le fasi che hanno già il fornitore abbinato, sia quello corretto (ok per le 22 già presenti)

--select righecicloprod.fornitorepref, tabfornitoriciclo.codforn  from righecicloprod 
--	inner join tabfornitoriciclo on righecicloprod.progressivo = tabfornitoriciclo.progressivo 
--								     and righecicloprod.numerofase = tabfornitoriciclo.numerofase
--	where righecicloprod.operazione in ('13902', '13903') and tabfornitoriciclo.codforn <> 'F   374'


-- Inserisco le righe del dettaglio fornitore preferenziale associato al ciclo dove mancante
-- BEGIN TRAN
--INSERT INTO TABFORNITORICICLO
--select	rcp.progressivo as progressivo, 
--		rcp.numerofase as numerofase,
--		'F   374' as codforn,
--		1 as priorita,
--		0 as listinotrasf,
--		'sa' as utentemodifica,
--		getdate() as datamodifica			
--			from righecicloprod rcp
--	left outer join tabfornitoriciclo tfc on rcp.progressivo = tfc.progressivo 
--								     and rcp.numerofase = tfc.numerofase
--	where rcp.operazione in ('13902', '13903') and tfc.progressivo is null 
--commit tran