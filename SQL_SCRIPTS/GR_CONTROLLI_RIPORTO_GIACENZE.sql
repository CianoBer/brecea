SELECT *
FROM LISTINIARTICOLI
WHERE NRLISTINO = 100

SELECT *
FROM LISTAMOVIMENTICTRLINV 
WHERE NOMEIMPOSTAZIONE='Inv.Inziale Mag. 100'

SELECT LA.ARTICOLO, LA.QUANTITA, LM.ARTICOLO, LM.QUANTITA 
FROM LISTAARTICOLICTRLINV LA
LEFT OUTER JOIN LISTAMOVIMENTICTRLINV LM
	ON LA.ARTICOLO=LM.ARTICOLO AND LM.NOMEIMPOSTAZIONE = 'Inv.Inziale Mag. 100'
WHERE LA.NOMEIMPOSTAZIONE='Inv.Inziale Mag. 100'
AND LA.QUANTITA<>LM.QUANTITA

UPDATE LISTAMOVIMENTICTRLINV
SET QUANTITA = 22
WHERE NOMEIMPOSTAZIONE='Inv.Inziale Mag. 100'
AND ARTICOLO = 'VR05A25'

SET DATEFORMAT DMY
SELECT CODDEPOSITO
FROM STORICOMAG
WHERE DATAMOV='08/03/2009'
AND GIACENZA <>0
AND CODCAUSALE IN (501,502)
GROUP BY CODDEPOSITO

SET DATEFORMAT DMY
--DELETE STORICOMAG
FROM STORICOMAG
WHERE DATAMOV='08/03/2009'
AND CODDEPOSITO = '100'
AND CODCAUSALE IN (501,502)
