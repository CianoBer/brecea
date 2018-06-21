

select rop.rifcommcli as commordine, iop.rifcommcli as commimpegno, tor.tipocom, tor.esercizio, tor.numerocom, rop.idriga, iop.idimpegno 
	from righeordprod rop
		inner join testeordiniprod tor on rop.idtesta = tor.progressivo
		left outer join impegniordprod iop on rop.idtesta = iop.idtesta and rop.idriga = iop.idriga
	where 
		rop.rifcommcli <> iop.rifcommcli
--		and (rop.rifcommcli = 'Y1049-P01' or iop.rifcommcli = 'Y1049-P01')
order by rop.rifcommcli
