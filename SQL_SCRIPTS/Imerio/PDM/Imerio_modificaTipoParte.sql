--************************************
--* Modifca tipo parte in FUSION_PDM
--* IMERIO 15/12/2016

--* individuare il CODID associato al codice (248 è il cpid del Tipo parte)
select pc.*--, cv.*
from propcod pc
left join codici cv on cv.codid = pc.codid
where  pc.cpid = 248 and cv.codcodice = '19750129'

--* controllare i dati per sicurezza
select pc.*--, cv.*
from propcod pc where cpid = 248 and codid in (1489432, 1535684)

--* aggiornare il tipo parte
--update PROPCOD set propvalore = 'TP4' where cpid = 248 and codid in (1489432, 1535684)