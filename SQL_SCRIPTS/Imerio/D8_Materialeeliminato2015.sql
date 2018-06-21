--**************************************************************
--  CONTROLLO MATERIALE ELIMINATO A SCARTI A FINE 2015
--- La tabella zzzzMag48_2015 contiene l'elenco del materiale
--* buttato a scarti ed eliminato perchè non movimentato
--* dal 2009 al 2011 (sono 2131 articoli)
--* La query verifica se nel 2016 questo materiale
--* è stato riacquistato e riutilizzato
--* Controllo richiesto da Frasson
--* IMERIO GENNAIO 2016
--*************************************************************

select distinct codart --, convert(real, qta1um) as qtanew, qta as qta48, valoreunitario, datamov, riferimenti, coddeposito 
from storicomag sm
inner join zzzzMag48_2015 ms on codice = codart
where datamov > '2016-01-01'