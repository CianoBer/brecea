
--*************************************************************************
 --* ESTRAZIONE ORE INDIRETTE VERSATE TRAMITE HDP
 --* Dati per Elisa 
 --* IMERIO (03/03/2017)

select esercizio, tipodoc, numerodoc, codart, right(codart, 5) as ente,descrizioneart, left(descrizioneart,charindex(' ', descrizioneart)) as Nome ,
substring(descrizioneart,charindex(' ', descrizioneart)+1,charindex(' ', descrizioneart, charindex(' ', descrizioneart)+1)-charindex(' ', descrizioneart)) as Cognome, 
convert (real, qtagest) as qta, convert (money, prezzounitnetto) as prezzo_unit, convert(money, totnettoriga) as tot_netto, 
convert (varchar, dataconsegna, 105) as data_consegna, RIFCOMMCLI
 from righedocumenti 
 where esercizio = 2016 and tipodoc = 'hdp' and (dataconsegna>'2016-06-30' and dataconsegna < '2016-12-31')



-- *********************************************************************
-- RESTITUISCE LA SOMMA DELLE ORE INDIVIDUATE NELLA PRECEDENTE SELEZIONE
-- (EVENTUALMENTE RAGGRUPPATE PER DIPENDENTE)
-- *********************************************************************
set dateformat dmy
SELECT CONVERT (REAL, SUM(RD.QTAGEST)) AS ORE --, AA.CODICEPRIMARIO,
FROM RIGHEDOCUMENTI RD
INNER JOIN ANAGRAFICAARTICOLI AA ON RD.CODART = AA.CODICE
WHERE CODART LIKE 'DIP%' and RD.TIPODOC = 'HDP'
--AND RIFCOMMCLI LIKE 'Y1048%'		-- PER COMMESSA
--AND (CODART LIKE '%PM02%' OR CODART LIKE '%SED%' OR CODART LIKE '%VED%')		--PER CENTRO
AND AA.DESCRIZIONE LIKE '%rabino%'		--PER DIPENDENTE
AND DATACONSEGNA > ='01/11/2013' AND DATACONSEGNA < ='30/11/2013'
--GROUP BY AA.CODICEPRIMARIO



--**********************************************************************
--* RESITUISCE LE RIGHE DEI DOC HDP RELATIVI AI FOGLI VIAGGIO
--**********************************************************************
set dateformat dmy
SELECT RD.ESERCIZIO, RD.TIPODOC, RD.NUMERODOC, RD.RIFCOMMCLI, RD.CODART, RD.DESCRIZIONEART,
RD.UMGEST, CONVERT(REAL, RD.QTAGEST) AS ORE, CONVERT(VARCHAR, RD.DATACONSEGNA, 105) AS DATA
FROM  RIGHEDOCUMENTI RD
INNER JOIN TESTEDOCUMENTI TD ON RD.IDTESTA = TD.PROGRESSIVO
WHERE TD.TIPODOC = 'HDP' 
AND TD.NUMRIFDOC LIKE '%FV%'
AND RD.DATACONSEGNA >= ' 01/01/2011' AND RD.DATACONSEGNA < '01/01/2012'


--*******************************************************
-- CONTROLLA LE RIGHE DEGLI HDP PRIVI DEL CENTRO DI COSTO
-- (E QUINDI NON CARICA LA TARIFFA)
--*******************************************************
select esercizio, tipodoc, numerodoc, posizione, RIFCOMMCLI, codart, descrizioneart 
from righedocumenti 
where esercizio = 2017 and tipodoc = 'HDP' and descrizioneart not like '%diaria%'
--and contocdc =''
AND (RIFCOMMCLI = '' OR RIFCOMMCLI IS NULL)

--update righedocumenti set rifcommcli = 'Y1050-P01' WHERE tipodoc = 'HDP' and numerodoc = '647' and esercizio = '2011'


