-- Verifica trasferimento lista LTT/2011/175

select tlt.*, rlt.* from righelistatrasf rlt
	inner join testelistatrasf tlt on rlt.idtesta = tlt.progressivo
where tlt.esercizio = 2011 and tlt.numerolista = 175

select ll.*, rl.* 
	from moxmes_righetrasferimento rl 
	left outer join moxmes_letturetrasferimento ll on rl.riftrasferimento = ll.riftrasferimento and 
														rl.idriga = ll.rifriga
where 
	rl.idlista = 888 
and rl.idrigalista in (25, 26)
