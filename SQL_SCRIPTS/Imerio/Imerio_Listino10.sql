--**************************************************************
--* PROCEDURA CREAZIONE NUOVO LISTINO 11 VENDITA RICAMBI
--* (La numerazione segue le istruzioni contenute nel documento
--* Progetto Metodo.docx)
--* IMERIO 04/02/2016
--*************************************************************



--*************************************************************
--* 1) cancellare listini 10 e 12 precedenti
--delete listiniarticoli where nrlistino = 10
--delete listiniarticoli where nrlistino = 12


 --************************************************************
 --* 2) Creare listino 12 come backup del listino 11 precedente

-- INSERT INTO LISTINIARTICOLI ( CODART, NRLISTINO, UM, PREZZO, PREZZOEURO, UTENTEMODIFICA, DATAMODIFICA, DeltaIncremento, TP_CodConto, TP_ConsPP
--, TP_PrezzoPart, TP_PrezzoPartEuro, TP_Scorporo, TP_Sconti, TP_QTASCONTO, TP_QTACOEFF, TP_QTAMO, TP_Abbuono, TP_DataCambio, TP_ValoreCambio
--, DATAVALIDITA, TP_FormulaSct, PREZZOCALC, TP_ABBUONOEURO )
--SELECT L11.CODART, 12, L11.UM, L11.PREZZO, L11.PREZZOEURO, L11.UTENTEMODIFICA, L11.DATAMODIFICA, L11.DeltaIncremento
--, L11.TP_CodConto, L11.TP_ConsPP, L11.TP_PrezzoPart, L11.TP_PrezzoPartEuro, L11.TP_Scorporo, L11.TP_Sconti, L11.TP_QTASCONTO, L11.TP_QTACOEFF
--, L11.TP_QTAMO, L11.TP_Abbuono, L11.TP_DataCambio, L11.TP_ValoreCambio, L11.DATAVALIDITA, L11.TP_FormulaSct, L11.PREZZOCALC, L11.TP_ABBUONOEURO
--FROM LISTINIARTICOLI L11 where L11.nrlistino = 11


--************************************************************
--* 3) creare nuovo listino 10 usando procedura standard Metodo

--* Se il nuovo listino dev'essere preparato tramite semplice maggiorazione 
--*    del listino 11 dell'anno precedente una volta preparato il listino 10
--*    eseguire i punti 3-a) e 3-b) successivi
 
  --************************************************************
 --* 3-a) individua articoli mancanti nel listino 10
 --* (codici generati dopo la creazione dell'ultimo listino 11)
 --* Vengono individuati facendo la differenza con quelli contenuti nel listino CU corrente
 
 select codart as codice, descrizione, CONVERT(MONEY, prezzo) AS ListinoCU
 from listiniarticoli la
 inner join anagraficaarticoli aa on aa.codice = la.codart
 where nrlistino = 1706 AND PREZZO <> 0
 and CODART not IN (SELECT CODART FROM LISTINIARTICOLI WHERE NRLISTINO = 10)
 and codart > '1001000' and UM <> 'H' and codart <> '%#%'
 order by codart

--*************************************************************
--* 3-b) si aggiornano i prezzi degli articoli numerici (x3,5/0,9)
--INSERT INTO LISTINIARTICOLI ( CODART, NRLISTINO, UM, PREZZO, PREZZOEURO, UTENTEMODIFICA, DATAMODIFICA, DeltaIncremento )
--SELECT CU.codart, 10 , ARTICOLIUMPREFERITE.UM, CU.PREZZO*3.89, CU.PREZZO*3.89, 'EDP', GetDate(), 0
--from listiniarticoli CU
-- INNER JOIN ARTICOLIUMPREFERITE ON CU.codart = ARTICOLIUMPREFERITE.CODART AND ARTICOLIUMPREFERITE.TIPOUM=1
-- where CU.nrlistino = 1706 AND CU.PREZZO <> 0
-- and CU.CODART not IN (SELECT CODART FROM LISTINIARTICOLI WHERE NRLISTINO = 10)
-- and (CU.codart >= '1001000' and CU.codart<='9860115') and CU.UM <> 'H' and CU.codart <> '%#%'
-- 

 --*************************************************************
--* 3-c) si aggiornano i prezzi degli articoli alfa-numerici (x2,5/0,9)
--INSERT INTO LISTINIARTICOLI ( CODART, NRLISTINO, UM, PREZZO, PREZZOEURO, UTENTEMODIFICA, DATAMODIFICA, DeltaIncremento )
--SELECT CU.codart, 10 , ARTICOLIUMPREFERITE.UM, CU.PREZZO*2.78, CU.PREZZO*2.78, 'EDP', GetDate(), 0
--from listiniarticoli CU
-- INNER JOIN ARTICOLIUMPREFERITE ON CU.codart = ARTICOLIUMPREFERITE.CODART AND ARTICOLIUMPREFERITE.TIPOUM=1
-- where CU.nrlistino = 1706 AND CU.PREZZO <> 0
-- and CU.CODART not IN (SELECT CODART FROM LISTINIARTICOLI WHERE NRLISTINO = 10)
-- and (CU.codart >= 'C002540') and CU.UM <> 'H' and CU.codart <> '%#%'
-- 

--**********************************************
--*	4) Prima di copiare il listino 10 sul listino 11
--* usare questa query per controllare se ci sono 
--* articoli a listino 11 con prezzo inferiore
--* al Costo Ultimo (listino 1706 o simili)
--*************************************************

select l11.codart, l11.nrlistino, convert(money,l11.prezzoeuro) as Listino10, lCU.nrlistino,convert(money,lCU.prezzoeuro) as CU, 
convert(integer,((lCU.prezzoeuro-l11.prezzoeuro)/l11.prezzoeuro)*100) as differenza 
from listiniarticoli l11
inner join listiniarticoli lCU on l11.codart=lCU.codart
where l11.nrlistino = 10 and lCU.nrlistino=1706
and l11.prezzoeuro<lCU.prezzoeuro		--prezzo di vendita minore del CU
--and l11.prezzoeuro>6*lCU.prezzoeuro		--prezzo di vendita troppo superiore al CU
and l11.prezzoeuro>10
and l11.codart >'1000000'
order by differenza


--*************************************************************
--* 5) cancellare listino 11 precedente
--delete listiniarticoli where nrlistino = 11


--************************************************************
 --* 6) Creazione listino 11 copiandolo dal listino 10 preparato al punto 3

-- INSERT INTO LISTINIARTICOLI ( CODART, NRLISTINO, UM, PREZZO, PREZZOEURO, UTENTEMODIFICA, DATAMODIFICA, DeltaIncremento, TP_CodConto, TP_ConsPP
--, TP_PrezzoPart, TP_PrezzoPartEuro, TP_Scorporo, TP_Sconti, TP_QTASCONTO, TP_QTACOEFF, TP_QTAMO, TP_Abbuono, TP_DataCambio, TP_ValoreCambio
--, DATAVALIDITA, TP_FormulaSct, PREZZOCALC, TP_ABBUONOEURO )
--SELECT L10.CODART, 11, L10.UM, L10.PREZZO, L10.PREZZOEURO, L10.UTENTEMODIFICA, L10.DATAMODIFICA, L10.DeltaIncremento
--, L10.TP_CodConto, L10.TP_ConsPP, L10.TP_PrezzoPart, L10.TP_PrezzoPartEuro, L10.TP_Scorporo, L10.TP_Sconti, L10.TP_QTASCONTO, L10.TP_QTACOEFF
--, L10.TP_QTAMO, L10.TP_Abbuono, L10.TP_DataCambio, L10.TP_ValoreCambio, L10.DATAVALIDITA, L10.TP_FormulaSct, L10.PREZZOCALC, L10.TP_ABBUONOEURO
--FROM LISTINIARTICOLI L10 where L10.nrlistino = 10

 
 --************************************************************
 --* 7) Eliminare i listini particolari e ricrearli a partire 
 --* dal nuovo listino 10 aggiungendo le dovute maggiorazioni
 --* (14 Brasile +10%, 15 BPS +40%, 16 Teva +10%, 17 Marchesini +10%)
 
 --delete listiniarticoli where nrlistino = 15

--  INSERT INTO LISTINIARTICOLI ( CODART, NRLISTINO, UM, PREZZO, PREZZOEURO, UTENTEMODIFICA, DATAMODIFICA, DeltaIncremento, TP_CodConto, TP_ConsPP
--, TP_PrezzoPart, TP_PrezzoPartEuro, TP_Scorporo, TP_Sconti, TP_QTASCONTO, TP_QTACOEFF, TP_QTAMO, TP_Abbuono, TP_DataCambio, TP_ValoreCambio
--, DATAVALIDITA, TP_FormulaSct, PREZZOCALC, TP_ABBUONOEURO )
--SELECT L10.CODART, 15, L10.UM, L10.PREZZO*1.4, L10.PREZZOEURO*1.4, L10.UTENTEMODIFICA, L10.DATAMODIFICA, L10.DeltaIncremento
--, L10.TP_CodConto, L10.TP_ConsPP, L10.TP_PrezzoPart, L10.TP_PrezzoPartEuro, L10.TP_Scorporo, L10.TP_Sconti, L10.TP_QTASCONTO, L10.TP_QTACOEFF
--, L10.TP_QTAMO, L10.TP_Abbuono, L10.TP_DataCambio, L10.TP_ValoreCambio, L10.DATAVALIDITA, L10.TP_FormulaSct, L10.PREZZOCALC, L10.TP_ABBUONOEURO
--FROM LISTINIARTICOLI L10 where L10.nrlistino = 10






--**********************************************
--* usare questa query per controllare se ci sono 
--* articoli a listino 10 con prezzo inferiore
--* al listino 12
--*************************************************

select l11.codart, l11.nrlistino, l11.prezzoeuro, l12.nrlistino,l12.prezzoeuro 
from listiniarticoli l11
inner join listiniarticoli l12 on l11.codart=l12.codart
where l11.nrlistino = 10 and l12.nrlistino=12
and l11.prezzoeuro<l12.prezzoeuro
and l11.prezzoeuro>10
and l11.codart >'1000000'
order by l11.codart

--BEGIN TRAN
--update l11 set l11.prezzo=l12.prezzo*1.10, l11.prezzoeuro=l12.prezzoeuro*1.10
--from listiniarticoli l11
--inner join listiniarticoli l12 on l11.codart=l12.codart
--where l11.nrlistino = 16 and l12.nrlistino=11
--and l11.prezzoeuro<l12.prezzoeuro*1.1
--and l11.codart >'1000000'
--COMMIT TRAN


