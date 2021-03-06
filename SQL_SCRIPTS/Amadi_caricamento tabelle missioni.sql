

-- CARICAMENTO TABELLE TIPIDOCUMENTO MISSIONI

-- CANCELLO IL CONTENUTO ATTUALE DELLE TABELLE
DELETE FROM Tabtestetipodocconsmiss 

	DELETE FROM tabrighetipodocconsmiss 

-- CARICAMENTO TESTE

INSERT INTO Tabtestetipodocconsmiss
	SELECT 
		ROW_NUMBER () OVER (ORDER BY CODCONTO) AS PROGRESSIVO, 
		CODCONTO,
		0 AS NUMDDM,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM ANAGRAFICACF
		WHERE 
			TIPOCONTO = 'C'
			
-- CARICAMENTO OG1 E OG2 PER TUTTI I CLIENTI			

INSERT INTO tabrighetipodocconsmiss
	SELECT 
		PROGRESSIVO,
		'OG1' AS DOCMISS,
		'DSG' AS DOCCONS,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM Tabtestetipodocconsmiss
	
INSERT INTO tabrighetipodocconsmiss
	SELECT 
		PROGRESSIVO,
		'OG2' AS DOCMISS,
		'DSG' AS DOCCONS,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM Tabtestetipodocconsmiss

-- CARICAMENTO OR1 CLIENTI IT CEE 

INSERT INTO tabrighetipodocconsmiss
	SELECT 
		PROGRESSIVO,
		'OR1' AS DOCMISS,
		'DR1' AS DOCCONS,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM Tabtestetipodocconsmiss
		INNER JOIN ANAGRAFICACF ON Tabtestetipodocconsmiss.CODCONTO = ANAGRAFICACF.CODCONTO
	WHERE 
		ANAGRAFICACF.CODICEISO <> '' 

-- CARICAMENTO OR1 e OR2 CLIENTI EXTRACEE

INSERT INTO tabrighetipodocconsmiss
	SELECT 
		PROGRESSIVO,
        'OR2' AS DOCMISS,
        'DR2' AS DOCCONS,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM Tabtestetipodocconsmiss
		INNER JOIN ANAGRAFICACF ON Tabtestetipodocconsmiss.CODCONTO = ANAGRAFICACF.CODCONTO
	WHERE 
		ANAGRAFICACF.CODICEISO = ''
UNION			
	SELECT 
		PROGRESSIVO,
		'OR1'  AS DOCMISS,
        'DR2' AS DOCCONS,
		'import' AS UTENTEMODIFICA,
		GETDATE() AS DATAMODIFICA 
	FROM Tabtestetipodocconsmiss
		INNER JOIN ANAGRAFICACF ON Tabtestetipodocconsmiss.CODCONTO = ANAGRAFICACF.CODCONTO
	WHERE 
		ANAGRAFICACF.CODICEISO = ''








	