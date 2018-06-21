-- AMADI 08/07/2009
-- controlla se nelle distinte ci sono quantità con valori decimali
-- separati dal punto anzichè dalla virgola

select dbt.artcomposto, dbt.versionedba, dbr.CODARTCOMPONENTE, dbr.QTA1, dbt.utentemodifica 
from DISTINTAARTCOMPOSTI dbt
inner join DISTINTABASE dbr on dbt.PROGRESSIVO = dbr.RIFPROGRESSIVO
where dbr.qta1 like '%.%'

--update DISTINTABASE SET QTA1 = REPLACE(QTA1,'.',',')
--from DISTINTAARTCOMPOSTI dbt
--            inner join DISTINTABASE dbr on dbt.PROGRESSIVO = dbr.RIFPROGRESSIVO
--      where dbr.qta1 like '%.%'

--******************************************************
--*    CONTROLLO QUANTITA' IN DISTINTA
--* QTA2 DEVE ESSERE A ZERO ALTRIMENTI SI SOMMA CON QTA1
--*       IMERIO 15 MARZO 2011
--******************************************************

select da.artcomposto, db.codartcomponente, qta1, qta2 
from distintabase db 
inner join distintaartcomposti da on da.progressivo = db.rifprogressivo
where qta2 <>''




-- I.REBELLATO 13/05/2010
-- controlla se nei cicli di lavorazione ci sono quantità con valori decimali
-- separati dal punto anzichè dalla virgola

SELECT     TC.CODCICLO, RC.PROGRESSIVO, RC.NUMEROFASE, RC.POSIZIONE, RC.OPERAZIONE, RC.CDLAVORO, 
           RC.MACCHINA, RC.CALCOLOTEMPOSETUP, RC.LOTTOSTNSETUP, RC.CALCOLOTEMPOMACCHINA, RC.DSCOPERAZIONE

FROM       RIGHECICLOPROD RC
		   
		   INNER JOIN TESTACICLOPROD TC ON RC.PROGRESSIVO = TC.PROGRESSIVO

WHERE      (RC.CALCOLOTEMPOSETUP LIKE '%.%') OR
                      (RC.CALCOLOTEMPOMACCHINA LIKE '%.%')



-- I.REBELLATO 13/05/2010
-- controlla se in ordini di produzione già emessi sono stati
-- inseriti cicli di lavorazione aventi quantità con valori decimali
-- separati dal punto anzichè dalla virgola (individuati con la query precedente)
-- Per correggere gli errori -> GESTIONE RISORSE/MANUTENZIONE CICLI EMESSI
-- clic su Rif. Ordine e ricercare per CODCICLO. 

SELECT     TC.CODCICLO, TP.TIPOCOM, TP.NUMEROCOM, TP.PIANOPRODRIF, RC.PROGRESSIVO, RC.NUMEROFASE, RC.POSIZIONE, RC.OPERAZIONE, RC.CDLAVORO, 
           RC.MACCHINA, RC.CALCOLOTEMPOSETUP, RC.LOTTOSTNSETUP, RC.CALCOLOTEMPOMACCHINA, RC.DSCOPERAZIONE

FROM       RIGHECICLOORDINE RC
		   
		   INNER JOIN TESTACICLOORDINE TC ON RC.PROGRESSIVO = TC.PROGRESSIVO
			LEFT JOIN TESTEORDINIPROD TP ON TC.IDTESTACOMM = TP.PROGRESSIVO

WHERE      (RC.CALCOLOTEMPOSETUP LIKE '%.%') OR
                      (RC.CALCOLOTEMPOMACCHINA LIKE '%.%')


--**************************************************************************
-- controlla se la data di validità della distinta è diversa da 01/01/2008
-- E' stato deciso che tutte le distinte debbano avere tale valore
-- come data di validità
--* CONTROLLA INOLTRE ANCHE GLI ALTRI PARAMETRI 
--***************************************************************************

select artcomposto, versionedba, statoversione, dbastandard, 
       CONVERT(VARCHAR,validitadba,105) as data_validita, rifarticolo, utentemodifica, datamodifica
from distintaartcomposti
where validitadba <> '01/01/2008' or dbastandard<>1 or statoversione<>1 or versionedba<>'STD'

--update distintaartcomposti set statoversione = 1 where artcomposto = '00Y0617-A01'


--*****************************************
-- Controlla se articoli componenti sono privi
-- di unità di misura
--******************************************
select artcomposto, db.* 
from DISTINTAARTCOMPOSTI da
inner join distintabase db on da.PROGRESSIVO = db.RIFPROGRESSIVO
where db.UM = ''
order by artcomposto
