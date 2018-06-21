--**************************************
--* CONFRONTO VALORI LIRE-EURO IN STORICOPREZZIARTICOLO
--* AMADI 26/04/2010
--***************************************




SELECT CODARTICOLO, PREZZOLIRE, PREZZOEURO, (PREZZOEURO - (PREZZOLIRE / 1936.27))AS DIFFERENZA  FROM STORICOPREZZIARTICOLO 
WHERE 
	(PREZZOLIRE / 1936.27) <> PREZZOEURO AND TIPOPREZZO = 'f' AND ULTIMO = 1
ORDER BY (PREZZOEURO - (PREZZOLIRE / 1936.27)) DESC


SELECT DISTINCT TIPOPREZZO FROM STORICOPREZZIARTICOLO
--BEGIN TRAN
--UPDATE STORICOPREZZIARTICOLO
--	SET PREZZOLIRE = 1936.27, PREZZORIGHEDOC = 1936.27
-- WHERE CODARTICOLO = 'costimat'
--COMMIT TRAN

SELECT CODARTICOLO, PREZZOLIRE, PREZZOEURO, (PREZZOEURO - (PREZZOLIRE / 1936.27)) AS DIFFERENZA, DATAMODIFICA 
	FROM STORICOPREZZIARTICOLO 
	WHERE DATA = '07/03/2009' 
	AND (PREZZOLIRE / 1936.27) <> PREZZOEURO 
ORDER BY (PREZZOEURO - (PREZZOLIRE / 1936.27)) DESC

SELECT  DATAMODIFICA, COUNT(1) FROM STORICOPREZZIARTICOLO 
	WHERE DATA = '07/03/2009'
GROUP BY DATAMODIFICA 