 

--* copia i campi della tabella TABNAZIONI nella tabella TABRAGGRPROVVIGIONICF
--* (può essere usato anche per inserire una nuova riga nella stessa tabella copiando
--* i dati da una riga già esistente)

--Insert Into tabraggrprovvigionicf (codice, descrizione, utentemodifica, datamodifica)
--select codice, descrizione, 'Input', getdate() from tabnazioni



--****************************************************************************************

--* aggiorna i campi della tabella extramag in Brecea prendendo i valori
--* dalla tabella Extramag di Dittapro

select be.codart,be.codartprod as BCEA, de.codartprod AS PROVA, BE.NomeProd as PRODbcea, de.nomeprod as prodprova 
from brecea.dbo.extramag be 
LEFT join dittapro.dbo.extramag de on be.codart = de.codart
where --BE.UtenteCreazione IN ('D.PAVAN', 'I.MARRA')
de.nomeprod <> '' AND Be.nomeprod IS NULL

--* aggiorna codartprod
--update brecea.dbo.extramag set codartprod=de.CodArtProd
--from dittapro.dbo.extramag de
--LEFT join brecea.dbo.extramag be on be.codart = de.codart
--where de.codartprod <> '' AND Be.codartprod IS NULL

--* aggiorna nomeprod
--update brecea.dbo.extramag set nomeprod=de.nomeProd
--from dittapro.dbo.extramag de
--LEFT join brecea.dbo.extramag be on be.codart = de.codart
--where de.nomeprod <> '' AND Be.nomeprod IS NULL


--************************************************************************************

--* aggiorna il campo codicestatoestero in anagraficacf partendo dal codice inserito
--* nel campo codnAzione, leggendone la Descrizione nella tabella Tabnazioni e andando a
--* prendere il codice in Tabcodicistatoestero che ha la stessa descrizione

--update anagraficacf set CODSTATOESTERO = tce.codice
--from TABCODICISTATOESTERO tce 
--left join tabnazioni tn on tce.descrizione= tn.descrizione
--inner join ANAGRAFICACF acf on acf.codnazione = tn.codice

select acf.codconto, acf.codnazione, tn.descrizione as nazione, acf.codstatoestero, tce.descrizione as Estero from anagraficacf acf
left join tabnazioni tn on tn.codice = acf.codnazione
left join TABCODICISTATOESTERO tce on tce.codice = acf.codstatoestero




--*********************************************************
--* rispristino distinta da backup
--* (si presume che il bckp sia stato ripristinato in DITTAPRO)
--* IMERIO 26/05/2014

--* 1) Controllare riferimenti distinta da recuperare
select * from distintaartcomposti where artcomposto = '00BM365-P01'

--* 2) CONTROLLARE E CONFRONTARE I RECORD DA RIPRISTINARE
select * from DITTAPRO.dbo.distintaartcomposti where progressivo = 73439
select * from DITTAPRO.dbo.distintabase where rifprogressivo = 73439

select * from BRECEA.dbo.distintabase where rifprogressivo = 73439
select * from BRECEA.dbo.distintabase where rifprogressivo = 73439



--* 3) ELIMINARE (QUALORA SIANO STATI SOVRASCRITTI DA ALTRI DATI ERRATI) I RECORD DA SOSTITUIRE
--delete from BRECEA.dbo.DISTINTABASE where rifprogressivo = 51208



--* 3) RIPRISTINARE DAL BCKP I RECORD INDIVIDUATI
--* Testa
--insert into BRECEA.dbo.distintaartcomposti select * from DITTAPRO.dbo.distintaartcomposti where progressivo = 73439
--* Figli
--insert into BRECEA.dbo.DISTINTABASE select * from DITTAPRO.dbo.DISTINTABASE where rifprogressivo = 73439

--* RIPRISTINARE DAL BCKP I RECORD INDIVIDUATI SOLO PER ALCUNI CAMPI
--insert into BRECEA.dbo.DISTINTABASE (CODARTCOMPONENTE, QTA1) select (CODARTCOMPONENTE, QTA1) from DITTAPRO.dbo.DISTINTABASE where rifprogressivo = 51208