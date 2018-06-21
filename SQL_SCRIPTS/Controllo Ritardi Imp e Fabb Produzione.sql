-- Controllo Fabbisogni di produzione e Impegni scaduti

-- Fabbisogni (50.400)
select tipo, * from progproduzione 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 0 

-- Impegni di produzione (16.734)
select tipo, * from progproduzione 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 7

-- Fabbisogni scaduti (17.422)
select * from 	eccezioniprogprod 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 3

-- Impegni scaduti (10.772)
select * from 	eccezioniprogprod 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 2

-- Ritardi fabbisogni scaduti
select max (datediff(dd, datariga, nuovadata)) as ritardo_max,
	   avg (datediff(dd, datariga, nuovadata)) as ritardo_medio
 from eccezioniprogprod 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 3

-- Ritardi impegni scaduti
select max (datediff(dd, datariga, nuovadata)) as ritardo_max,
	   avg (datediff(dd, datariga, nuovadata)) as ritardo_medio
 from eccezioniprogprod 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 2

-- Impegni scaduti da oltre 3 mesi
select datediff(dd, datariga, nuovadata) as ritardo, *
 from eccezioniprogprod 
	where 
	nomepianif = '01_PIANIFICAZIONE_GENERALE'
	and tipo = 2
	and datediff(dd, datariga, nuovadata) > 90

