
-- Aggiornamento scadenze clienti estero
BEGIN TRAN
UPDATE TABSCADENZE	
	SET 
		IMPONIBSCLIT = IMPORTOSCEURO,
		IMPONIBSCVAL = IMPORTOSCEURO,
		IMPONIBSCEURO = IMPORTOSCEURO,
		TOTFATTLIT = IMPORTOSCEURO,
		TOTFATTVAL = IMPORTOSCEURO,
		TOTFATTEURO = IMPORTOSCEURO,
		IMPFATTLIT = IMPORTOSCEURO,
		IMPFATTVAL = IMPORTOSCEURO,
		IMPFATTEURO = IMPORTOSCEURO
	FROM
	TABSCADENZE 
	inner join ANAGRAFICARISERVATICF on TABSCADENZE.CODCLIFOR = ANAGRAFICARISERVATICF.codconto
where
	ANAGRAFICARISERVATICF.ESERCIZIO = 2009
	and ANAGRAFICARISERVATICF.CODIVA between 200 and 299
	and (
		TABSCADENZE.IMPONIBSCVAL = 0 
		or TABSCADENZE.IMPONIBSCLIT = 0
		or TABSCADENZE.IMPONIBSCVAL = 0
		or TABSCADENZE.IMPONIBSCEURO = 0
		or TABSCADENZE.TOTFATTLIT = 0 
		or TABSCADENZE.TOTFATTEURO = 0
		or TABSCADENZE.IMPFATTLIT = 0
		)

COMMIT TRAN

-- Aggiornamento scadenze Italia
BEGIN TRAN
UPDATE TABSCADENZE	
	SET 
		IMPONIBSCLIT = IMPORTOSCEURO * 100/120,
		IMPONIBSCVAL = IMPORTOSCEURO  * 100/120,
		IMPONIBSCEURO = IMPORTOSCEURO  * 100/120,
		TOTFATTLIT = IMPORTOSCEURO,
		TOTFATTVAL = IMPORTOSCEURO,
		TOTFATTEURO = IMPORTOSCEURO,
		IMPFATTLIT = IMPORTOSCEURO  * 100/120,
		IMPFATTVAL = IMPORTOSCEURO  * 100/120,
		IMPFATTEURO = IMPORTOSCEURO  * 100/120
	FROM
	TABSCADENZE 
	inner join ANAGRAFICARISERVATICF on TABSCADENZE.CODCLIFOR = ANAGRAFICARISERVATICF.codconto
where
	ANAGRAFICARISERVATICF.ESERCIZIO = 2009
	and ANAGRAFICARISERVATICF.CODIVA not between 200 and 299
	and (
		TABSCADENZE.IMPONIBSCVAL = 0 
		or TABSCADENZE.IMPONIBSCLIT = 0
		or TABSCADENZE.IMPONIBSCVAL = 0
		or TABSCADENZE.IMPONIBSCEURO = 0
		or TABSCADENZE.TOTFATTLIT = 0 
		or TABSCADENZE.TOTFATTEURO = 0
		or TABSCADENZE.IMPFATTLIT = 0
		)

COMMIT TRAN


	



