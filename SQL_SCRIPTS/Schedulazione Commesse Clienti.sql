

select RIFCOMMCLI,livello, CODART, DESCRIZIONE, datainizprod, DATACONS, RIFERIMENTI 
	from progproduzione
		INNER JOIN ANAGRAFICAARTICOLI ON PROGPRODUZIONE.CODART = ANAGRAFICAARTICOLI.CODICE
	where nomepianif like '01%'
	and tipo in (2,6)
	and rifcommcli LIKE 'Y1144-P01'
order by livello desc
