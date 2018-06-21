-- ESTRAZIONE DATI MENSILI (A.NORBIATO)

-- ELENCO COMMESSE INSTALLAZIONE 
select annocom, tipocom, numcom, riferimento, RIFCOMM, oggetto, CONVERT(VARCHAR,datainizioconsegna,105)AS INIZIO_GARANZIA, CONVERT(VARCHAR,datafineconsegna,105) AS FINE_GARANZIA, STATOCOMMESSA
from anagraficacommesse
where tipocom = 'CCI' --and rifcomm = 'y0721-i01'
and statocommessa <> '3'  --stato 0 = IMMESSA, 1= APERTA, 2= SOSPESA, 3= CHIUSA

-- ELENCO COMMESSE PRODUZIONE NON CHIUSE O SENZA DATA
select annocom, tipocom, numcom, riferimento, RIFCOMM, oggetto, CONVERT(VARCHAR,datainizioconsegna,105)AS INIZIO_GARANZIA, CONVERT(VARCHAR,datafineconsegna,105) AS FINE_GARANZIA, 
CONVERT(VARCHAR,datachiusuracomm,105) AS DATA_CHIUSURA, STATOCOMMESSA
from anagraficacommesse
where tipocom ='CCP' and annocom >2013
and (statocommessa <> '3' or datainizioconsegna is null or datafineconsegna is null or datachiusuracomm is null) --stato 0 = IMMESSA, 1= APERTA, 2= SOSPESA, 3= CHIUSA
and riferimento <>'Amministrazione'
order by tipocom, annocom, numcom




-- ELENCO COMMESSE AGGIORNAMENTO APERTE (A. NORBIATO)
select annocom, tipocom, numcom, riferimento, RIFCOMM, oggetto, CONVERT(VARCHAR,datainizioconsegna,105)AS INIZIO, CONVERT(VARCHAR,datafineconsegna,105) AS FINE, 
CONVERT(VARCHAR,datachiusuracomm,105) AS CHIUSA, STATOCOMMESSA
from anagraficacommesse
where rifcomm like '%-A0%' AND TIPOCOM <> 'CCG'
and statocommessa <> '3' --stato 0 = IMMESSA, 1= APERTA, 2= SOSPESA, 3= CHIUSA


-- ELENCO COMMESSE GARANZIA APERTE (NON INVIARLE A A. NORBIATO)
set dateformat dmy
select annocom, tipocom, numcom, riferimento, RIFCOMM, oggetto, CONVERT(VARCHAR,datainizioconsegna,105)AS INIZIO, CONVERT(VARCHAR,datafineconsegna,105) AS FINE, 
CONVERT(VARCHAR,datachiusuracomm,105) AS CHIUSA, STATOCOMMESSA
from anagraficacommesse
where rifcomm like '%-G0%'
and statocommessa <> '3' --stato 0 = IMMESSA, 1= APERTA, 2= SOSPESA, 3= CHIUSA


-- AGGIORNA LE COMMESSE INSERITE COME "IMMESSE" (StatoCommessa = '0') IN NON "APERTE" (StatoCommessa = '1')
select annocom, tipocom, rifcomm, oggetto 
from anagraficacommesse WHERE StatoCommessa = '0'
--update anagraficacommesse set StatoCommessa ='1' where StatoCommessa = '0'


-- ELENCO COMMESSE GLOBALI RICHIESTA DA CUDIFERRO PER ANALISI ATTIVITA' NORBIATO 21/07/2014
select annocom, tipocom, rifcomm, riferimento, oggetto, statocommessa, convert(varchar,datainizioconsegna,105) as data_inizio, convert(varchar,datafineconsegna,105) as data_fine, 
convert(varchar,datachiusuracomm,105) as data_chiusura, responsabilecomm, utentemodifica, convert(varchar,dataemissione,105) as data_emissione, convert(varchar,datamodifica,105)as data_modifica 
from anagraficacommesse where tipocom <>'CCR'



--***************************************************************
--*SE UNA COMMESSA E' STATA INSERITA CON RIFCOMM ERRATO
--* PRIMA DI MODIFICARLO VA VERIFICATO SE E' STATA USATA
--* IN DOCUMENTI O IN CPI/CPR
--*	IMERIO 07/06/2013
--****************************************************************

--* 1)CONTROLLA SE SONO STATI EMESSI OPI PER UNA DETERMINATA COMMESSA
SELECT TOR.tipocom, TOR.numerocom,TOR.ESERCIZIO, ROP.CODART, ROP.RIFCOMMCLI 
FROM RIGHEORDPROD ROP
inner join testeordiniprod TOR on TOR.progressivo = ROP.idtesta
WHERE ROP.RIFCOMMCLI LIKE '00Y0514-S01%'

--UPGRADE RIGHEORDPRO SET RIFCOMMCLI = '00Y0514-S01' WHERE RIFCOMMCLI = 'Y0514-S01'

--* 2)CONTROLLA SE SONO STATI EFFETTUATI MOVIMENTI DI PRODUZIONE PER UNA DETERMINATA COMMESSA
SELECT * FROM STORICOMovordprod WHERE rifcommcli LIKE '00Y0514-S01%'
SELECT * FROM STORICOMAG WHERE CODCOMMESSA LIKE '00Y0514-S01%'


--* 1)CONTROLLA SE SONO STATI EMESSI DOCUMENTI PER UNA DETERMINATA COMMESSA
select tipodoc, esercizio, numerodoc, RIFCOMMCLI
from righedocumenti
where rifcommcli LIKE '00Y0514-S01%'

--UPGRADE RIGHEDOCUMENTI SET RIFCOMMCLI = '' WHERE RIFCOMMCLI = ''


--************************************************
--* COMMESSE I F E G PRIVE DI COMMESSA DI RIEPILOGO
--* (richiesta da E. targon)
--* Imerio 28/03/2017
--**************************************************


select AnnoCom, TipoCom, NumCom, RifComm, Riferimento, Oggetto  
from anagraficacommesse 
where rifcommriep = '' and tipocom in ('CCF', 'CCG', 'CCI')


