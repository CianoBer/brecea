--***************************************************
--* CONTROLLA SE UN DOCUMENTO E' STATO PRELEVATO

SELECT TIPODOC, NUMERODOC
FROM RIGHEDOCUMENTI
WHERE
ESERCIZIO = '2011'
AND TIPODOC = 'OFG'
AND IDTESTA IN (SELECT IDTESTARP FROM RIGHEDOCUMENTI WHERE ESERCIZIO = '2011' AND TIPODOC = 'BCF')
GROUP BY TIPODOC, NUMERODOC
ORDER BY NUMERODOC



--**********************************************
--* ESTRAZIONE RIGHE DOCUMENTI PCC
--* PER ELISA
--* IMERIO (03/10/2016)
--**********************************************

select tipodoc, numerodoc, datamodifica, utentemodifica,codart, descrizioneart,contocdc, idcdc 
from RIGHEDOCUMENTI 
where esercizio = 2016 
and tipodoc ='PCC'
and codart <>''
and contocdc='' 
order by numerodoc


--***************************************************
--* QUERY PER RASCHIETTI
--* RIGHE BOLLE CARICATE DA MAGCEA4
--*
--** REBELLATO 11/05/2015
--************************************************

SELECT rd.TIPODOC, rd.NUMERODOC, rd.utentemodifica, CONVERT(varchar,rd.datamodifica, 103) AS DATA_modifica, codart, descrizioneart, umgest, convert(real,qtagest)as qta
FROM RIGHEDOCUMENTI rd
WHERE
rd.TIPODOC IN ('BC1','BCF','BCX', 'BCI', 'BC2', 'RGF')
AND QTAGEST <> 0
and (rd.datamodifica > '2015-06-03' and rd.datamodifica < '2015-06-14')
and rd.utentemodifica = 'magcea4'
ORDER BY datamodifica, tipodoc, numerodoc