--******************************************************
--* controllo letture palmari
--* se nella console presente in erpw2k801 si vede una lettura che rimane bloccata
--* controllare le query 2 e 3 e nel
--* caso lanciare l'update per mettere lo stato a 4
--*
--* FERRARO GIUGNO 2011
--*******************************************************

--1)
set dateformat dmy
	select * from moxmes_testaprelievo 
	where 
	idprelievo=110176
	--datamodifica > '05/02/2013'
	--and idoperatore = 'magcea5'

--2) se statoconsolidamento = 1 => la riga è chiusa e si può forzare lo stato a 4
	select * from moxmes_righeprelievo where rifprelievo=137246

--3) se qta = 0 e saldaprelievo = 0 => l'utente ha aperto una sessione e l'ha chiusa senza fare nessun prelievo => si può forzare stato a 4
	select * from dbo.MOXMES_LetturePrelievo where rifprelievo=137246 


 --mette il movimento in stato 4 per farlo sparire dalla lista
--update moxmes_testaprelievo set stato = 4 where idprelievo=137246



--**********************************************
--* Verifica le situazioni aperte nei vari palmari
--* Può essere utilizzata se una sessione rimane
--* aperta in un palmare e non si riesce a
--* chiudere (es perchè la CPI/CPR è stata
--* cancellata)
--* stato 1: operazione in corso
--* stato 2: operazione sospesa ferma su palmare e non trasmessa a Metodo
--* stato 3: operazione conclusa su palmare e passata a Metodo
--* stato 4: operazione gestita e chiusa da metodo
--* Una volta individuata portarne lo stato a 4
--* Ragazzo 02/2015
--********************************************** 

select *
from MOXMES_TestaPrelievo tp
left outer join righeordprod rop
	on tp.idcommessa=rop.IDTESTA
	and tp.IDORDINE=rop.IDRIGA
where stato in  (0,3)
order by idprelievo desc

--update MOXMES_TestaPrelievo
--set stato = 4 
--where idprelievo = 90015



--***********************************************
--* Controllo attività effettuate dai palmari
--* (richiesta da Castrignanò)
--* Imerio 02/2014
--**********************************************
select
            tp.* --, rp.*, lp.*, sp.*
       from 
             MOXMES_TestaPrelievo tp
             left outer join MOXMES_RighePrelievo rp on tp.idprelievo = rp.rifprelievo
             left outer join MOXMES_LetturePrelievo lp on rp.RIFPRELIEVO = lp.RIFPRELIEVO and rp.IDRIGA = lp.RIFRIGA
             left outer join MOXMES_SessioniPrelievoVersamento sp on tp.IDPRELIEVO = sp.REFIDSESSIONE
where tp.datamodifica > '2015-05-20' order by idoperatore, datamodifica

-- PRELIEVI
select
             tp.idoperatore, convert(varchar, tp.datamodifica, 105) as dataattivita, tor.tipocom, tor.esercizio, 
			 tor.numerocom, rp.articolo, convert(real, rp.qtadaprelevare) as daprelevare, convert(real,lp.qtaprelevata) as prelevata --, rp.idordine, rp.idimpegno, sp.*
       from 
             MOXMES_TestaPrelievo tp
             left outer join MOXMES_RighePrelievo rp on tp.idprelievo = rp.rifprelievo
             left outer join MOXMES_LetturePrelievo lp on rp.RIFPRELIEVO = lp.RIFPRELIEVO and rp.IDRIGA = lp.RIFRIGA
             left outer join MOXMES_SessioniPrelievoVersamento sp on tp.IDPRELIEVO = sp.REFIDSESSIONE
			 left join testeordiniprod tor on tor.progressivo = tp.idcommessa
where (tp.datamodifica > '2015-05-03' and tp.datamodifica < '2015-05-30') and lp.qtaprelevata is not null
order by tp.idoperatore, dataattivita, esercizio, numerocom --, idordine, idimpegno


-- TRASFERIMENTI
select
             tp.idoperatore, convert(varchar, tp.datamodifica, 105) as dataattivita, tor.tipocom, tor.esercizio, tor.numerocom, rp.articolo,
			 convert(real, rp.qtadatrasferire) as datrasferire, convert(real,lp.qtatrasferita) as trasferita --, rp.idimpegno, rp.idordine, sp.*, 
       from 
             MOXMES_TestaTrasferimento tp
             left outer join MOXMES_RigheTrasferimento rp on tp.idtrasferimento = rp.riftrasferimento
             left outer join MOXMES_LettureTrasferimento lp on rp.riftrasferimento = lp.riftrasferimento and rp.IDRIGA = lp.RIFRIGA
 			 left outer join testeordiniprod tor on tor.progressivo = rp.idcommessa
			 where (tp.datamodifica > '2015-05-03' and tp.datamodifica < '2015-05-30') and lp.qtatrasferita is not null
order by  tp.idoperatore, dataattivita, esercizio, numerocom --, idordine, idimpegno


--**************************************
--* Ordini Ricambi su palmare
--* Trova eventuali ordini sospesi
--* o in errore
--*
--* Ragazzo 19/06/2015
--**************************************

select * 
from MOXWA_VistaPicking vp
left outer join testedocumenti td
on vp.IDTESTADOC=td.PROGRESSIVO
where STATO<>4 and stato <> 100
