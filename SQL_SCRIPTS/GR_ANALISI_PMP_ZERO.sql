SELECT TEMP.CODART, SM.RIFERIMENTI, SM.DATAMOV, SM.CODCAUSALE, TCM.DESCRIZIONE, *
FROM TEMPSTAMPALIFO TEMP
LEFT OUTER JOIN STORICOMAG SM
	ON TEMP.CODART=SM.CODART --AND SM.GIACENZA =1
LEFT OUTER JOIN TABCAUSALIMAG TCM
	ON SM.CODCAUSALE=TCM.CODICE
WHERE NRTERMINALE = 150
AND TEMP.VALUNITEURO = 0
AND TEMP.CODART='1833201'
ORDER BY TEMP.CODART, DATAMOV

--ANALISI CAUSALI
SELECT COUNT (PROGRESSIVO) AS NR_MOV, SM.CODCAUSALE, TCM.DESCRIZIONE
FROM TEMPSTAMPALIFO TEMP
LEFT OUTER JOIN STORICOMAG SM
	ON TEMP.CODART=SM.CODART AND SM.GIACENZA=1
LEFT OUTER JOIN TABCAUSALIMAG TCM
	ON SM.CODCAUSALE=TCM.CODICE
WHERE NRTERMINALE = 150
AND TEMP.VALUNITEURO = 0
GROUP BY SM.CODCAUSALE, TCM.DESCRIZIONE
ORDER BY SM.CODCAUSALE, TCM.DESCRIZIONE

SELECT *
FROM STORICOMAG
WHERE CODART = '77203351'
AND IMPORTOTOTNETTOEURO = 0


SELECT TEMP.CODART, (SELECT REPLACE(PREZZOEURO,'.',',') FROM LISTINIARTICOLI WHERE CODART=TEMP.CODART AND NRLISTINO=100) AS VAL_100, *
FROM TEMPSTAMPALIFO TEMP
WHERE NRTERMINALE = 150
AND VALUNITEURO=0
ORDER BY CODART
