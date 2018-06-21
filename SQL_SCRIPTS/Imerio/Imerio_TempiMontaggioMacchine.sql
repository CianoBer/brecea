--********************************************************
-- TEMPI MONTAGGIO MACCHINE
--	IMERIO DICEMBRE 2011
--*******************************************


select tc.codciclo, aa.descrizione, rc.progressivo, rc.operazione, rc.dscoperazione, 
convert(real,rc.oreprevmacchina) as tmpprevisto, convert(real,oreeffmacchina)as tmpeffettivo
from righecicloordine rc
inner join testacicloordine tc on tc.progressivo = rc.progressivo
left join anagraficaarticoli aa on tc.codciclo = aa.codice
where tc.codciclo = '00y1111-p01'


select * from testacicloordine where codciclo = '00y1111-p01'
select * from righecicloordine where progressivo = 15558
select * from testacicloprod



--****************************************************
--* ORE VERSATE SU UNA DETERMINATA OPERAZIONE DI FASE
--* RICHIESTA DA GIULIANO
--* IMERIO DICEMBRE 2015
--****************************************************

--* SOMMA COMPLESSIVA
select ANNOBOLLA, OPERAZIONE, DSCOPERAZIONE, SUM(convert(real,oreeffmacchina))as tmpeffettivo 
from righecicloordine 
where ANNOBOLLA = 2015 AND OPERAZIONE = '15001'
GROUP BY ANNOBOLLA, OPERAZIONE, DSCOPERAZIONE

--* DETTAGLIO
select tc.codciclo, aa.descrizione, rc.progressivo, rc.operazione, rc.dscoperazione, 
convert(real,rc.oreprevmacchina) as tmpprevisto, convert(real,oreeffmacchina)as tmpeffettivo
from righecicloordine rc
inner join testacicloordine tc on tc.progressivo = rc.progressivo
left join anagraficaarticoli aa on tc.codciclo = aa.codice
where RC.ANNOBOLLA = 2015 AND RC.OPERAZIONE = '15001'
ORDER BY TC.CODCICLO
