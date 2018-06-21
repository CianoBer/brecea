--**************************************
--* ANALISI SU CPI/OPI/IMPEGNI
--*  AMADI 22/01/2015         
--*
--* creata su richiesta di Giuliano per verificare
--* ordini chiusi (ROP.STATOORDINE=3) con impegni aperti (IOP.STATOIMPEGNO<>2) => comunicare a Giuliano
--* ordini chiusi (ROP.STATOORDINE=3) con impegni  aperti (IOP.STATOIMPEGNO<>2) con iop.qtagestione = 0 => chiudere
--* ordini aperti (ROP.STATOORDINE<>3) con impegni aperti (IOP.STATOIMPEGNO<>2) con iop.qtagestione = 0 => valutare con Giuliano
--*
--* N.B. in questa tabella la causale è sempre 121
--* TOR = teste ordini produzione (CPI)
--* ROP = righe ordini produzione (OPI)
--* IOP = impegni
--* 
--* 06/06/2016: Tutti gli ordini di produzione fino al 2014 compreso
--* con ordini chiusi e impegni aperti sono stati chiusi
--**************************************

SELECT TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, IOP.IDRIGA AS ORDINE, IOP.IDIMPEGNO AS IMPEGNO, 
	IOP.CODART, IOP.DESCRIZIONEART, convert(varchar, UA.CODubicazione) as UBICAZIONE, iop.umgest, convert(real,iop.qtagestione)as qtagest, convert(real,iop.qtagestionevers)as qtaprelevata,
	convert(real,iop.qtagestioneres)as qtaresidua, iop.tipoimpegno, iop.rifcommcli, iop.datamodifica as data_modifica_impegno, iop.utentemodifica as utente_modifica_impegno
FROM RIGHEORDPROD ROP
INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
LEFT JOIN UBICAZIONIARTICOLI UA ON IOP.CODART = UA.CODICEART AND CODDEPOSITO = '100'
WHERE TOR.ESERCIZIO in ('2012','2013','2014','2015','2016', '2017')
AND ROP.STATOORDINE<>3		--statoordine 0=aperto, 1 = prelevato, 2 = versato, 3 = chiuso
AND IOP.STATOIMPEGNO<>2		--statoimpegno 0= aperto, 1 = prelevato, 2 =  chiuso
and iop.qtagestione = 0
order by TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, IOP.IDRIGA, IOP.IDIMPEGNO


-- Elenco dei movimenti di magazzino (impegno produzione), relativi agli impegni di cui sopra

SELECT TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, IOP.IDTESTA, IOP.IDRIGA, IOP.IDIMPEGNO, IOP.CODART, iop.rifcommcli, IOP.DESCRIZIONEART, IOP.QTA1MAGRES, 
SM.QTA1UM, SM.CODCAUSALE, SM.TIPOMOV, SM.DATAMOV, IOP.*
FROM RIGHEORDPROD ROP
INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
INNER JOIN STORICOMAG SM ON IOP.IDTESTA=SM.IDTESTA AND IOP.IDRIGA=SM.RIGADOC AND IOP.IDIMPEGNO=SM.RIGACOMP AND SM.TIPOMOV=7
INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
WHERE ROP.STATOORDINE=3
AND IOP.STATOIMPEGNO<>2
and TOR.ESERCIZIO in ('2012','2013','2014','2015','2016', '2017')
order by TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM



-- Cancellazione dei movimenti di magazzino
--BEGIN TRAN
--DELETE STORICOMAG
--FROM RIGHEORDPROD ROP
--INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
--INNER JOIN STORICOMAG SM ON IOP.IDTESTA=SM.IDTESTA AND IOP.IDRIGA=SM.RIGADOC AND IOP.IDIMPEGNO=SM.RIGACOMP AND SM.TIPOMOV=7
--INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
--WHERE ROP.STATOORDINE=3
--AND IOP.STATOIMPEGNO<>2
--and TOR.ESERCIZIO in ('2012','2013','2014','2015', '2016', '2017')
--COMMIT TRAN


 Chiusura degli impegni 
--BEGIN TRAN
--UPDATE IMPEGNIORDPROD
--SET STATOIMPEGNO=2, QTA1MAGRES=0, QTA2MAGRES=0, QTAGESTIONERES=0
--FROM RIGHEORDPROD ROP
--INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
--INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
--WHERE ROP.STATOORDINE=3
--AND IOP.STATOIMPEGNO<>2
--and TOR.ESERCIZIO in ('2012','2013','2014','2015','2016', '2017')
--and tipocom in ('CPI', 'CPR', 'CAM')
----and iop.qtagestione = 0
--COMMIT TRAN


--**********************************************
--* CONTROLLO SE SONO STATI EFFETTUATI STORNI 
--* IN QUANTITA' MAGGIORE ALLA QUANTITA PREVISTA NELLE CPI
--*
--* IMERIO 23/02/2016
--************************************************

SELECT TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, IOP.IDRIGA AS ORDINE, IOP.IDIMPEGNO AS IMPEGNO, 
	IOP.CODART, IOP.DESCRIZIONEART, iop.umgest, convert(real,iop.qtagestione)as qtagest, convert(real,iop.qtagestionevers)as qtaprelevata,
	convert(real,iop.qtagestioneres)as qtaresidua, iop.tipoimpegno, iop.deposito, iop.rifcommcli, convert(varchar,iop.datamodifica, 103) as data_modifica, iop.utentemodifica as UTENTEULTIMAMODIFICA
FROM RIGHEORDPROD ROP
INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO

WHERE TOR.ESERCIZIO in ('2015','2016', '2017')
and iop.QTAGESTIONEVERS < 0 and iop.datamodifica > '2017-01-01'
order by iop.datamodifica --,TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, IOP.IDRIGA, IOP.IDIMPEGNO




--**************************************
--* ANALISI SU CPI/OPI/IMPEGNI
--*  IMERIO 21/12/2010         
--*
--* creata su richiesta di Frasson per verificare
--* il totale degli impegni aperti in qualche magazzino 
--* (tipicamente magazzini terzisti)
--* N.B. in questa tabella la causale è sempre 121
--* TOR = teste ordini produzione (CPI)
--* ROP = righe ordini produzione (OPI)
--* IOP = impegni
--**************************************
select	IOP.codart, sum(IOP.qtagestione) as totimpegno
from impegniordprod IOP
inner join righeordprod ROP on ROP.idriga = IOP.idriga AND ROP.idtesta = IOP.idtesta
inner join testeordiniprod TOR on TOR.progressivo = ROP.idtesta
where 
IOP.deposito = 'F316'	-- ricerca su magazzino
-- and IOP.codart = 'KB00104'		-- ricerca su codice figlio
--and TOR.numerocom = '201'	-- ricerca su nr CPI
--and ROP.statoordine = '0'	--statoordine 0=aperto, 1 = prelevato, 2 = versato, 3 = chiuso
and IOP.statoimpegno = '0'	--statoimpegno 0= aperto, 1 = prelevato, 2 =  chiuso
and IOP.qtagestione <> 0
group by IOP.codart



--***************************************************************
--              VERIFICA PRELIEVI PRODUZIONE
--     QUADRATURA DATI RIGA IMPEGNO / DATI MOVIMENTI PRODUZIONE
-- controlla che le qtà prelevate da sessioni di movimentazione
-- quadrino con le qtà prelevate a livello di impegno di produzione
--      AMADI DICEMBRE 2010
--***************************************************************

select	TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA, IOP.IDIMPEGNO,IOP.CODART, 
		convert(real,MAX(IOP.QTAGESTIONEVERS))AS QTAORDINE, convert(real,SUM(SMI.QTAMOVGESTIONE)) AS QTAMOVIMENTI, 
		convert(varchar ,MIN(SMO.DATAMOV), 105) AS PRIMO_MOV, convert (varchar,MAX(SMO.DATAMOV), 105) AS ULTIMO_MOV
	from STORICOMOVIMPPROD SMI
		INNER JOIN STORICOMOVPROD SMO ON SMI.RIFPROGRESSIVO = SMO.PROGRESSIVO
		INNER JOIN IMPEGNIORDPROD IOP ON SMI.RIFTESTA = IOP.IDTESTA AND SMI.RIFRIGA = IOP.IDRIGA AND SMI.RIFIMPEGNO = IOP.IDIMPEGNO
		INNER JOIN RIGHEORDPROD ROP ON SMI.RIFTESTA = ROP.IDTESTA  AND SMI.RIFRIGA = ROP.IDRIGA 
		INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
	WHERE 
		TOR.ESERCIZIO IN (2013,2014,2015,2016,2017) 
group by TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA, IOP.IDIMPEGNO,IOP.CODART
having MAX(IOP.QTAGESTIONEVERS) <> SUM(SMI.QTAMOVGESTIONE) AND MAX(SMO.DATAMOV)>'2017-01-01'
ORDER BY TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA, IOP.IDIMPEGNO 
			

--***************************************************************
--              VERIFICA VERSAMENTI PRODUZIONE
--     QUADRATURA DATI RIGA ORDINE / DATI MOVIMENTI PRODUZIONE
-- controlla che le qtà prelevate da sessioni di movimentazione
-- quadrino con le qtà prelevate a livello di ordine di produzione
--                    AMADI DICEMBRE 2010
--***************************************************************

select	TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA, ROP.CODART, 
		convert(real,MAX(ROP.QTAGESTIONEVERS))AS QTAORDINE, convert(real,SUM(SMI.QTAMOVGESTIONE)) AS QTAMOVIMENTI, 
		convert(varchar,MIN(SMO.DATAMOV),105) AS PRIMO_MOV, convert(varchar,MAX(SMO.DATAMOV),105) AS ULTIMO_MOV
	from STORICOMOVORDPROD SMI
		INNER JOIN STORICOMOVPROD SMO ON SMI.RIFPROGRESSIVO = SMO.PROGRESSIVO
		INNER JOIN RIGHEORDPROD ROP ON SMI.RIFTESTA = ROP.IDTESTA  AND SMI.RIFRIGA = ROP.IDRIGA 
		INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
	WHERE 
		TOR.ESERCIZIO IN(2013,2014,2015,2016,2017)
group by TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA, ROP.CODART
having MAX(ROP.QTAGESTIONEVERS) <> SUM(SMI.QTAMOVGESTIONE)
ORDER BY TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA



--****************************************************************
--* CONTROLLA VERSAMENTI DOPPI EFFETTUATI NELLE CPI
--*	I.REBELLATO 22/11/2013
--****************************************************************
-- * 1) A LIVELLO DI RIGHE
select	TOR.ESERCIZIO, ROP.RIFCOMMCLI,TOR.TIPOCOM, TOR.NUMEROCOM, ROP.IDTESTA,ROP.IDRIGA, ROP.CODART, ROP.DESCRIZIONEART, 
		convert(real, qtagestione) as QTARICHIESTA, convert(real,MAX(ROP.QTAGESTIONEVERS))AS QTAORDINE, 
		convert(varchar,MAX(SMO.DATAMOV),105) AS ULTIMO_MOV
	from STORICOMOVORDPROD SMI
		INNER JOIN STORICOMOVPROD SMO ON SMI.RIFPROGRESSIVO = SMO.PROGRESSIVO
		INNER JOIN RIGHEORDPROD ROP ON SMI.RIFTESTA = ROP.IDTESTA  AND SMI.RIFRIGA = ROP.IDRIGA 
		INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
	WHERE 
		SMO.DATAMOV > '2017-01-01'
--and tor.esercizio in(2013,2014,2015) 
and qtagestione <= qtagestionevers/2 and qtagestione > 0
group by TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDTESTA,ROP.IDRIGA, ROP.CODART, qtagestione, rop.rifcommcli, ROP.DESCRIZIONEART
ORDER BY TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDRIGA



--* 2) A LIVELLO DI IMPEGNI (Ragazzo 04/05/2015 - Ho aggiunto le colonne Nr_Letture e q.tà prelevata. Entrambe le colonne 
--*                          leggono quello che è stato fatto a livello palmare e aiutano a capire se il problema è su Metodo oppure sui terminali)
SELECT TOR.ESERCIZIO,IOP.RIFCOMMCLI, TOR.TIPOCOM,  TOR.NUMEROCOM, ROP.IDTESTA, ROP.IDRIGA, IOP.IDIMPEGNO,IOP.CODART, IOP.DESCRIZIONEART,
CONVERT(REAL,IOP.QTAGESTIONE)AS QTARICHIESTA, CONVERT(REAL,MAX(IOP.QTAGESTIONEVERS))AS QTAORDINE,
CONVERT (VARCHAR,MAX(SMO.DATAMOV), 105) AS ULTIMO_MOV,
SMI.UTENTEMODIFICA as UTENTE_ULTIMA_SESS_METODO,
(SELECT COUNT(1)
	FROM MOXMES_RIGHEPRELIEVO MR
	INNER JOIN MOXMES_LETTUREPRELIEVO ML ON MR.RIFPRELIEVO=ML.RIFPRELIEVO AND MR.IDRIGA=ML.RIFRIGA
	WHERE IDCOMMESSA = ROP.IDTESTA
	AND IDORDINE = ROP.IDRIGA
	AND IDIMPEGNO = IOP.IDIMPEGNO) AS NR_LETTURE,
convert(real, (SELECT SUM(ML.QTAPRELEVATA)
	FROM MOXMES_RIGHEPRELIEVO MR
	INNER JOIN MOXMES_LETTUREPRELIEVO ML ON MR.RIFPRELIEVO=ML.RIFPRELIEVO AND MR.IDRIGA=ML.RIFRIGA
	WHERE IDCOMMESSA = ROP.IDTESTA
	AND IDORDINE = ROP.IDRIGA
	AND IDIMPEGNO = IOP.IDIMPEGNO)) AS QTA_PRELEVATA

FROM STORICOMOVIMPPROD SMI
INNER JOIN STORICOMOVPROD SMO ON SMI.RIFPROGRESSIVO = SMO.PROGRESSIVO
INNER JOIN IMPEGNIORDPROD IOP ON SMI.RIFTESTA = IOP.IDTESTA AND SMI.RIFRIGA = IOP.IDRIGA AND SMI.RIFIMPEGNO = IOP.IDIMPEGNO
INNER JOIN RIGHEORDPROD ROP ON SMI.RIFTESTA = ROP.IDTESTA  AND SMI.RIFRIGA = ROP.IDRIGA 
INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
WHERE 
SMO.DATAMOV >= '2017-01-01'
--AND TOR.ESERCIZIO IN(2013,2014,2015) 
AND  IOP.QTAGESTIONE <= IOP.QTAGESTIONEVERS/2 AND IOP.QTAGESTIONE > 0
GROUP BY TOR.PROGRESSIVO, TOR.TIPOCOM, IOP.RIFCOMMCLI,TOR.ESERCIZIO, TOR.NUMEROCOM, ROP.IDTESTA,ROP.IDRIGA, IOP.IDIMPEGNO,IOP.CODART,IOP.DESCRIZIONEART, IOP.QTAGESTIONE,IOP.TIPOIMPEGNO, SMI.UTENTEMODIFICA
ORDER BY TOR.PROGRESSIVO DESC, TOR.TIPOCOM, TOR.ESERCIZIO, TOR.NUMEROCOM,  ROP.IDRIGA, IOP.IDIMPEGNO 





--**************************************************************
--* CANCELLAZIONE MOVIMENTI DI VERSAMENTO DOPPI E CORREZIONE QUANITA'

--*
--* IMERIO OTTOBRE 2014
--*****************************************************************

-- CORREZIONE QUANTITA' NELLA RIGA IMPEGNO DELL'ORDINE DI PRODUZIONE
--BEGIN TRAN
--UPDATE IMPEGNIORDPROD 
--SET IMPEGNIORDPROD.QTAGESTIONEVERS = IOP.QTAGESTIONE
--FROM RIGHEORDPROD ROP
--INNER JOIN IMPEGNIORDPROD IOP ON ROP.IDTESTA=IOP.IDTESTA AND ROP.IDRIGA=IOP.IDRIGA
--INNER JOIN TESTEORDINIPROD TOR ON ROP.IDTESTA = TOR.PROGRESSIVO
--WHERE TOR.TIPOCOM = 'CPR'
--AND TOR.ESERCIZIO = '2014'
--AND TOR.NUMEROCOM = 1739
--AND IOP.IDRIGA = 3
--COMMIT TRAN


-- *CANCELLAZIONE MOVIMENTI IN storicomovimpprod
--* per la cancellazione dei movimenti Rilevare l'IDTESTA dalla query
--* precedente e inserirlo nella select seguente
--* per rilevare i dati da inserire nel Delete

select * from storicomovimpprod where RIFTESTA = 7621 AND RIFRIGA = 2 and rifimpegno in (352, 353) and qtamov1mag >0
-- begin tran
-- delete storicomovimpprod where rifprogressivo = 158178 and rifimpegno in (352, 353)
-- comit tran


--**** ATTENZIONE: QUESTA PARTE VA VERIFICATA IN QUANTO ERRATA!!!!!!!
--* CANCELLAZIONE MOVIMENTI IN STORICOMAG
--* Rilevare dall'AIOT i movimenti da eliminare e utilizzare
--* il Progressivo individuato nel movimento
--* (fare un controllo preventivo con la select)

--select * from storicomag WHERE numerodoc = 165924
--delete storicomag where idtesta = 154827






--************************************************
--* A FRONTE DI ARTICOLI STORNATI IN ORDINI DI PRODUZIONE
--* (CONTROLLABILI CON LA PRIMA QUERY) VERIFICA SE
--* RIGA E IMPEGNO RISULTANO CHIUSI (STATORDINE = 3, STATOIMPEGNO=2)
--* imerio 28/03/2014
--***************************************************


select codcommessa, codart, datamov, qta1um, riferimenti, utentemodifica, datamodifica
  from storicomag 
  where datamodifica > '2016-08-31' --and codcommessa = 'bm197-p01'
   and qta1um<0
  order by codcommessa, datamov

  select tor.TIPOCOM, tor.esercizio, tor.NUMEROCOM, rop.idriga, rop.RifCommCli as RifComm_Ordine, rop.statoordine, iop.RifCommCli as RifComm_Impegno, iop.statoimpegno,
			rop.CODART as ART_DAPROD, iop.CODART as  ART_IMP, iop.DESCRIZIONEART,
			iop.umgest, iop.qtaunitaria, iop.qtagestione, iop.qtagestionevers as qtaprelevata, iop.qtagestioneres, iop.datamodifica,
			convert(varchar, iop.dataemissione, 105) as Data_Emissione, iop.flagriga as flagsaldoriga
       from 
             RIGHEORDPROD rop
             inner join TESTEORDINIPROD tor  on rop.IDTESTA = tor.PROGRESSIVO 
             inner join IMPEGNIORDPROD iop on rop.idtesta = iop.IDTESTA and rop.idriga = iop.IDRIGA 
       where 
			 tor.TIPOCOM = 'CPI'
			 and tor.esercizio = 2013
			 and tor.NUMEROCOM = 944
			 and iop.codart = 'KEB0609'
		order by rop.RifCommCli

			 
--***************************************************************
--              VERIFICA FABBISOGNI-IMPEGNI SCADUTI
--   
--                    AMADI MAGGIO 2011
--***************************************************************
SET DATEFORMAT DYM
select * from progproduzione
	where 
		nomepianif like '01%' -- 01 = Pianif. Generale, 02 = Pianif. Ricambi
		and tipo = 7 -- 0= fabbisogni, 7 = Impegni di produzione
		and datacons < '01-01-2017'
order by datacons desc





--*CONTROLLA SE SONO STATI EMESSI OPI PER UNA DETERMINATA COMMESSA
SELECT TOR.tipocom, TOR.numerocom,ROP.CODART, ROP.RIFCOMMCLI 
FROM RIGHEORDPROD ROP
inner join testeordiniprod TOR on TOR.progressivo = ROP.idtesta
WHERE ROP.RIFCOMMCLI LIKE 'Y1162-A%'




--*******************************************************************
--* VERIFICA GLI STORNI DA CPI (RDC) EFFETTUATI IN UN CERTO PERIODO
--* FORNIRE DATI MENSILI A ELISA
--* IMERIO NOVEMBRE 2015
--*******************************************************************
select convert(varchar,codart) as codice, convert(real,qta1um) as qta,convert(real, importototnettoeuro) as importototale, riferimenti,codcommessa, coddeposito,utentemodifica, 
convert(varchar,datamodifica, 105) as data_modifica 
from storicomag 
where esercizio = 2016 and qta1um <0 
and (datamov>'2016-11-30' and datamov<'2016-12-28')