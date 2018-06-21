--****************************************************
--* INDIVIDUA I MOVIMENTI DI RESO A COMMESSA
--* CON VALORE A ZERO

select esercizio, tipodoc, numerodoc, convert(date,dataconsegna, 105) as datadoc, codart, NUMLISTINO 
from RIGHEDOCUMENTI 
where ESERCIZIO in ('2014', '2015', '2016', '2017') and TIPODOC = 'RCG' and PREZZOUNITLORDO = 0
order by numerodoc


--******************************************************
--* INDIVIDUA I RESI DA COMMESSA EFFETTUATI CON 
--* COMMESSE ANCORA IN WIP (QUESTO GENERA IMPORTO DOPPI
--* NEGLI INVENTARI)
--* VA CARICATA TABELLA xxxxcommwip CON LE COMMESSE IN WIP
--*  I.REBELLATO 08/11/2013
--*********************************************************

select esercizio, tipodoc, numerodoc, RIFCOMMCLI, codart, descrizioneart, umgest, CONVERT(real, qtagest) AS qta,
convert(money, totnettorigaeuro) as TOTRIGA, convert(varchar, dataconsegna, 103) as DATA, CODDEPOSITO 
from righedocumenti where tipodoc = 'RCG' and rifcommcli in (select commesse from xxxxcommwip)