CREATE VIEW MET_VISTA_DATE_FOGLIOVIAGGIO AS
SELECT 
	IDTESTA,
	MIN(DATARICH) AS min_DATARICH,
	MAX(DATACONF) AS max_DATACONF 
FROM 
	EXTRARIGHEDOC
GROUP BY 
	IDTESTA
GO
GRANT SELECT ON MET_VISTA_DATE_FOGLIOVIAGGIO TO METODO98
GO