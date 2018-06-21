

update listiniarticoli	
	set 
		prezzo = 
				(select la.prezzo from listiniarticoli la 
						where la.nrlistino = 100 
						      and la.codart = listiniarticoli.codart
							  and la.um = listiniarticoli.um)
	where 
		nrlistino = 101 
		and prezzo = 0


update listiniarticoli	
	set 
		prezzoeuro = 
				(select la.prezzoeuro from listiniarticoli la 
						where la.nrlistino = 100 
						      and la.codart = listiniarticoli.codart
							  and la.um = listiniarticoli.um)
	where 
		nrlistino = 101 
		and prezzoeuro = 0







