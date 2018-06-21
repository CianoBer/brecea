

-- BREVETTI CEA - CONTROLLO AGGIORNAMENTO MOVIMENTI DI CONSUNTIVAZIONE
-- AMADI DIC 2010
-- La query evidenzia gli ordini di produzione e relative fasi di lavorazione, con squadrature nelle ore lavorate
-- (differenze tra ore lavorate calcolate dai movimenti di dettaglio e ore accumulate nella fase d'ordine)

select vb.tipocom, vb.esercizio,vb.numerocom, vb.codart, sa.annobolla, sa.numerobolla,
		sum(case when sa.oremacchina > sa.oredurata then sa.oremacchina else sa.oredurata end) as Ore_Da_Movimenti, 
		ro.oreeffmacchina as Ore_Da_Ordine,
		(abs ((sum(case when sa.oremacchina > sa.oredurata then sa.oremacchina else sa.oredurata end)) - ro.oreeffmacchina) 
		/ ((case when ro.oreeffmacchina = 0 then 1 else ro.oreeffmacchina end) )* 100) as diffperc
	from storicoavanzamenti sa 
		inner join righecicloordine ro on sa.annobolla = ro.annobolla and sa.numerobolla = ro.numerobolla
		inner join vistabollelavorazione vb on sa.annobolla = vb.annobolla and sa.numerobolla = vb.numerobolla
group by 
	vb.tipocom, vb.esercizio, vb.numerocom, vb.codart, sa.annobolla, 
	sa.numerobolla, ro.oreeffmacchina 
having 
	(abs ((sum(case when sa.oremacchina > sa.oredurata then sa.oremacchina else sa.oredurata end)) - ro.oreeffmacchina) 
		/ ((case when ro.oreeffmacchina = 0 then 1 else ro.oreeffmacchina end))*100) > 0
--	sum(case when sa.oremacchina > sa.oredurata then sa.oremacchina else sa.oredurata end) <> ro.oreeffmacchina
order by 
	vb.tipocom, vb.esercizio, vb.numerocom


