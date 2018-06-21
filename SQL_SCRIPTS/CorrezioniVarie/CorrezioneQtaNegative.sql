select * from righedocumenti where qta2mag<0
select * from righedocumenti where qta2magres<0

select rd.qtagest, rd.qtaprezzo, rd.qta1mag, rd.qta2mag, round(rd.qta1mag*afc.fattore, 3), afc.fattore, afc.formulafc, rd.*
from righedocumenti rd inner join vistaanagraficaarticoli vaa
	on rd.codart=vaa.codice
inner join articolifattoriconversione afc
	on rd.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --rd.qta2mag<0 and
	rd.qta2mag<>round(rd.qta1mag*afc.fattore, 3)

select rd.qtagestres, rd.qtaprezzores, rd.qta1magres, rd.qta2magres, round(rd.qta1magres*afc.fattore, 3), afc.fattore, afc.formulafc, rd.*
from righedocumenti rd inner join vistaanagraficaarticoli vaa
	on rd.codart=vaa.codice
inner join articolifattoriconversione afc
	on rd.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --rd.qta2magres<0 and
	rd.qta2magres<>round(rd.qta1magres*afc.fattore, 3)

update righedocumenti set qta2mag=round((qta1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=righedocumenti.codart)), 3) where qta2mag<0
update righedocumenti set qta2magres=round((qta1magres*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=righedocumenti.codart)), 3) where qta2magres<0



select * from impegniordprod where qta2mag<0
select * from impegniordprod where qta2magres<0

select iop.qtagestione, iop.qtaprezzo, iop.qta1mag, iop.qta2mag, round(iop.qta1mag*afc.fattore, 3), afc.fattore, afc.formulafc, iop.*
from impegniordprod iop inner join vistaanagraficaarticoli vaa
	on iop.codart=vaa.codice
inner join articolifattoriconversione afc
	on iop.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --iop.qta2mag<0 and
	iop.qta2mag<>round(iop.qta1mag*afc.fattore, 3)

select iop.qtagestioneres, iop.qtaprezzores, iop.qta1magres, iop.qta2magres, round(iop.qta1magres*afc.fattore, 3), afc.fattore, afc.formulafc, iop.*
from impegniordprod iop inner join vistaanagraficaarticoli vaa
	on iop.codart=vaa.codice
inner join articolifattoriconversione afc
	on iop.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --iop.qta2magres<0 and
	iop.qta2magres<>round(iop.qta1magres*afc.fattore, 3)

update impegniordprod set qta2mag=round((qta1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3) where qta2mag<0
update impegniordprod set qta2magres=round((qta1magres*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3) where qta2magres<0
update impegniordprod set qta2mag=round((qta1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3) where qta2mag<>round((qta1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3)
update impegniordprod set qta2magres=round((qta1magres*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3) where qta2magres<>round((qta1magres*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=impegniordprod.codart)), 3)



select * from storicomovimpprod where qtamov2mag<0

select smip.qtamovgestione, smip.qtamovprezzo, smip.qtamovscarto, smip.qtamov1mag, smip.qtamov2mag, round(smip.qtamov1mag*afc.fattore, 3), afc.fattore, afc.formulafc, smip.*
from storicomovimpprod smip inner join vistaanagraficaarticoli vaa
	on smip.codart=vaa.codice
inner join articolifattoriconversione afc
	on smip.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --smip.qtamov2mag<0 and
	smip.qtamov2mag<>round(smip.qtamov1mag*afc.fattore, 3)

update storicomovimpprod set qtamov2mag=round((qtamov1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomovimpprod.codart)), 3) where qtamov2mag<0
update storicomovimpprod set qtamov2mag=round((qtamov1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomovimpprod.codart)), 3) where qtamov2mag<>round((qtamov1mag*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomovimpprod.codart)), 3)



select * from storicomag where qta2um<0

select sm.qta1um, sm.qta2um, round(sm.qta1um*afc.fattore, 3), afc.fattore, afc.formulafc, sm.*
from storicomag sm inner join vistaanagraficaarticoli vaa
	on sm.codart=vaa.codice
inner join articolifattoriconversione afc
	on sm.codart=afc.codart and afc.um1=vaa.um1 and afc.um2=vaa.um2
where --sm.qta2um<0 and
	sm.qta2um<>round(sm.qta1um*afc.fattore, 3)

update storicomag set qta2um=round((qta1um*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomag.codart)), 3) where qta2um<0
update storicomag set qta2um=round((qta1um*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomag.codart)), 3) where qta2um<>round((qta1um*(select afc.fattore from articolifattoriconversione afc inner join vistaanagraficaarticoli vaa on afc.codart=vaa.codice and afc.um1=vaa.um1 and afc.um2=vaa.um2 where vaa.codice=storicomag.codart)), 3)
