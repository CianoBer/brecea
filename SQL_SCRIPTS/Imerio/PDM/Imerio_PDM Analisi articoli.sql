--*****************************************
--* CAMPI e relativi sottovalori (CODVAL)
--* presenti nel Manager Configuration
--* (individuare da qui il CPID per filtrare
--* la select successiva)
--*
--*	I.REBELLATO (27/11/2013)
--****************************************
select CP.CPID, CP.CPNOME, CV.CVALID, CV.CVALVALORE 
from campi CP
left join CODVAL CV ON CP.CPID = CV.CPID
ORDER BY CP.CPID, CV.CVALID

--select * from campi
--select * FROM CODVAL
--SELECT * FROM revisioni
--select * from propcod where cpid in (332, 333)
--SELECT * FROM CODICI WHERE CODID = 72584



--******************************************
--* informazioni inserite nei vari codici
--*
--******************************************
select cd.codid, CODCODICE, CODMODUSER, CODMODDATE, CODCRUSER, CODCRDATE, CODFULLDESC, CP.CPID, CP.CPNOME, PROPVALORE 
from codici CD
left join PROPCOD CV on cd.codid=cv.CODID
left join CAMPI CP ON CV.CPID = CP.CPID
WHERE CODLASTREV= 1 AND CODBACKUP = 0
AND CODCODICE = 'KEB0004'
AND CP.CPID in (283, 332, 333)	--283= Informazioni Aggiuntive, 332=Codice Produttore, 333= Nome Produttore, 216 = Descrizione Completa, 295=descrizione completa
ORDER BY CODCODICE, CP.CPID

--update propcod set propvalore = '' where codid = 1426606 and cpid = 283

--***********************************************
--* informazioni associate ai codici revisionati
--*
--***********************************************
select CODCODICE, REVPOS, REVVAL
FROM CODICI CD
left join REVISIONI RV ON RV.CODID = CD.CODID
WHERE CODLASTREV= 1 AND CODBACKUP = 0 AND REVPOS IS NOT NULL



--*************************************************
--* CERCA I CODICI GENERATI NEL PDM CHE NON SONO
--* STATI PASSATI AL DB_LEI PER IL PASSAGGIO
--* A METODO
--* APRIRE LA SELECT ESSENDO CONNESSI A SRVPDM01
--* 
--* I.REBELLATO (14/11/2013)
--*************************************************

DECLARE @DataModificaCodice DATE
SET @DataModificaCodice='2013-11-14'

select * 
from [FUSION_PDM].[dbo].[CODICI]
where codmoddate > @DataModificaCodice and codlastrev = 1 and codbackup = 0
and [FUSION_PDM].[dbo].[CODICI].[codcodice] not in (select CODICE from [erpw2k801].[Db_Lei].[dbo].[PDM_ANAG_SMALL] where data = @DataModificaCodice)
and codcruser is not NULL			-- elimina i codici creati in Metodo e trasmessi al PDM


--**************************************************
--* controlla i codici in Metodo che hanno compilato il campo
--* extra NOMEPROD e che non hanno l'equivalente campo caricato 
--* nel PDM
--* Aprire la select collegati a erpw2k801
--* Imerio 29/01/2014
--*************************************************************

select * from extramag where 
nomeprod not like 'brevetti%' and nomeprod <>''
and codart not in 
(select codcodice from srvpdm01.fusion_pdm.dbo.propcod pc
left join srvpdm01.fusion_pdm.dbo.codici cv on cv.codid = pc.codid
where  pc.cpid = 333 and propvalore not like 'brevetti%' and propvalore <>'')