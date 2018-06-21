--**********************************
--* LISTA DI TRASFERIMENTO
--* mostra i dati della stampa della LTT
--* una LTT si identifica per il nr (es LTT 2011/00363),  
--* per la CPI (es CPI/2011/00486/00011) o per il CODICE A BARRE (es. 1075)
--* IMERIO MAGGIO 2011
--**********************************

select tl.progressivo, tl.esercizio, tl.numerolista,  tp.tipocom, tp.numerocom, rl.rifrigaord, convert(varchar, tl.dataemissione, 105) as dataemissione,  
rl.codart, rl.umgest, convert(real, rl.qtatrasfgestione) as qtatrasfgestione, convert(real, rl.qtatrasf1mag) as qtatrasf1mag,
convert (real, rl.qtatrasf2mag) as qtatrasf2mag, rl.ubicazionecoll as ubi_art, rl.depositocoll as dep_prov, rl.deposito as dep_dest
from testelistatrasf tl
inner join righelistatrasf rl on tl.progressivo = rl.idtesta -- aggancia righe e teste delle LTT
left join testeordiniprod tp on tp.progressivo = rl.riftestacomm -- aggancia righe LTT e teste Ordini Produzione per avere la CPI
where 
-- ricerca per nr LTT
--tl.esercizio = '2011' and tl.numerolista = '363'

-- ricerca per nr CPI	
--tl.esercizio = '2011' and tp.numerocom = '486' and rl.rifrigaord = '11'

-- ricerca per CODICE A BARRE
tl.esercizio = '2011' and tl.progressivo = '1077'
order by rl.ubicazionecoll, codart


--********************************************************************
--* LISTA DI TRASFERIMENTO PALMARE
--* moxmes_testatrasferimento E moxmes_righetrasferimento
--* contengono i dati presi in carico dal palmare
--*
--* moxmes_letturetrasferimento contiene i dati dichiarati dal palmare
--* (la selezione può essere fatta dando i riferimenti della CPI
--* o il numero del codice a barre presente nella stampa della LTT)
--*			IMERIO MAGGIO 2011
--********************************************************************
select tp.esercizio, tp.numerocom,rt.idordine,rt.idlista,
rt.articolo, rt.um, 
convert(real,rt.qtadatrasferire) as qtadatrasferire,
convert (real, lt.qtatrasferita) as qtatrasferita, rt.nonservito,
tt.idoperatore, convert (varchar, tt.datamodifica, 105) as datamodifica
from moxmes_testatrasferimento tt
inner join moxmes_righetrasferimento rt on tt.idtrasferimento = rt.riftrasferimento
inner join moxmes_letturetrasferimento lt on (lt.riftrasferimento = rt.riftrasferimento and lt.rifriga = rt.idriga)
inner join testeordiniprod tp on rt.idcommessa = tp.progressivo
where
-- ESERCIZIO, NR e RIGA ORDINE CPI che leggo nella stampa della LTT (es. CPI/2011/00486/00010)
tp.esercizio = '2011' and tp.numerocom = '486' and rt.idordine ='11'

-- CODICE A BARRE idenitificativo della LTT
--tp.esercizio = '2011' and rt.idlista = '1077'

--and rt.qtadatrasferire<>lt.qtatrasferita
--and rt.articolo = '71583052'
order by rt.articolo



--select * from moxmes_testatrasferimento
--select * from moxmes_righetrasferimento where idcommessa = '2844' and idordine = '9'
--select * from moxmes_letturetrasferimento

--select * from righelistatrasf where riftestacomm = '2844' and rifrigaord = '10' order by ubicazionecoll, codart
select * from testelistatrasf
--select * from testeordiniprod where progressivo = '2844'
