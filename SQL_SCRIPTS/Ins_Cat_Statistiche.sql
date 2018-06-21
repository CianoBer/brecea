
-- ELENCO CODICI E CATEGORIE STATISTICHE DA AGGIORNARE

select aa.codice,  cast(right((left(aa.codice, 4)), 3)as integer)  as catstat
	from anagraficaarticoli aa
where 
	isnumeric (right((left(aa.codice, 4)), 3)) = 1
	and charindex('D',(right((left(aa.codice, 4)), 3))) = 0
	and charindex('E',(right((left(aa.codice, 4)), 3))) = 0
	and charindex('.',(right((left(aa.codice, 4)), 3))) = 0

--------

-- AGGIORNAMENTO IN ANAGRAFICA ARTICOLI, DOPO CARICAMENTO TABELLA CATEGORIE STATISTICHE

BEGIN TRAN

UPDATE ANAGRAFICAARTICOLI
	SET ANAGRAFICAARTICOLI.CODCATEGORIASTAT = TABCATEGORIESTAT.CODICE
FROM
	ANAGRAFICAARTICOLI
	INNER JOIN TABCATEGORIESTAT ON cast(right((left(ANAGRAFICAARTICOLI.CODICE, 4)), 3)as integer) = TABCATEGORIESTAT.CODICE
WHERE 
	isnumeric (right((left(ANAGRAFICAARTICOLI.CODICE, 4)), 3)) = 1
	and charindex('D',(right((left(ANAGRAFICAARTICOLI.CODICE, 4)), 3))) = 0
	and charindex('E',(right((left(ANAGRAFICAARTICOLI.CODICE, 4)), 3))) = 0
	and charindex('.',(right((left(ANAGRAFICAARTICOLI.CODICE, 4)), 3))) = 0

COMMIT TRAN
	
