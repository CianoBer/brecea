

select  top 10 codice,  ROUND((dbo.leggicostomedio(codice, '2013/07/05')),2)  from ANAGRAFICAARTICOLI

select  top 10 codice,  ROUND((dbo.leggicostoultimo (codice, '2013/07/05')),2)  from ANAGRAFICAARTICOLI