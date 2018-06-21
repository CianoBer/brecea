-- Articoli in ordini produzione, non gestiti a magazzino

select * from righeordprod rop
	inner join anagraficaarticoli aa on rop.codart = aa.codice
	where aggiornamag = 0

-- Articoli in impegni produzione, non gestiti a magazzino

select * from impegniordprod iop
	inner join anagraficaarticoli aa on iop.codart = aa.codice
	where aggiornamag = 0

-- Articoli con movimento di carico iniziale (501) e senza movimento di ripresa valore iniziale

select distinct codart, descrizione 
	from storicomag 
inner join anagraficaarticoli on storicomag.codart = anagraficaarticoli.codice
	where 
	codcausale = 501
	and codart not in (select distinct codart from storicomag where codcausale = 90)


