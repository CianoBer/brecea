select codice, descrizione, ac.scgenacquistiita, scgenacquistiest, em.utentecreazione, em.datacreazione
from anagraficaarticoli aa
left join anagraficaarticolicomm ac on aa.codice = ac.codiceart
left join extramag em on aa.codice = em.codart
where left(descrizione, 5) like 'chiav%'
and ac.scgenacquistiita <> 'G   206'


--*****************************************************
--* verifica gli articoli con le contropartite vuote
--*
--* IMERIO 29/01/2013
--****************************************************

select esercizio, codiceart, scgenvenditeita, scgenvenditeEST, SCGENACQUISTIITA, SCGENACQUISTIEST
from anagraficaarticolicomm 
where (scgenvenditeita = '' or SCGENVENDITEEST = '')
and esercizio = 2013
and codiceart NOT like '_C%' and codiceart NOT like 'dip%' and codiceart NOT like '00%'

--update anagraficaarticolicomm
--set scgenvenditeita = 'G   264', scgenvenditeEST = 'G   264' --, SCGENACQUISTIITA = 'G   148', SCGENACQUISTIEST = 'G   148'
--where scgenvenditeita = '' 
--and esercizio = 2013
--and codiceart NOT like '_C%' and codiceart NOT like 'dip%' and codiceart NOT like '00%'



--*********************************************************
--* individua doc aperti con particolari CdC da controllare
--*
--* IMERIO GIUGNO 2011
--*********************************************************

select dd.codart, dd.descrizioneart,aa.tipodoc, aa.numerodoc, convert(varchar,aa.datadoc,105)as datadocum,dd.umgest, 
convert(real,dd.qtagest)as qta, dd.rifcommcli, aa.codclifor, cc.dscconto1, dd.gencontrop, dd.contocdc 
from testedocumenti aa 
LEFT JOIN anagraficacf cc ON aa.codclifor = cc.codconto            -- allinea le tabella TESTEDOCUMENTI e ANAGRAFICACF
INNER JOIN righedocumenti dd ON dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
where 
aa.docchiuso='0'                          -- solo righe relative ad articoli

-- SELEZIONA CLIENTE
AND dd.contocdc='1200'

-- SELEZIONA TIPODOC
--AND aa.tipodoc IN ('OF1', 'OF2')  -- OFFERTE RICAMBI
--AND aa.tipodoc IN ('OR1', 'OR2')  -- CONFERME D'ORDINE RICAMBI

and aa.esercizio = '2011'
order by aa.tipodoc



--***************************************************
--* FATTURE CON CODICI IVA 201 E 278 SENZA
--* DICHIARAZIONE D'INTENTO
--* Imerio 17/05/2017
--**************************************************

select distinct (td.numerodoc), td.* from testedocumenti td
inner join righedocumenti rd on  idtesta = progressivo
where td.esercizio = 2017 and td.tipodoc = 'FAI' and datadoc > '2017-02-28' and PROGDICHINTENTO = 0
and  (codiva =278 or codiva = 201)
