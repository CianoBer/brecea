--*************************************************
--* CERCA I CODICI GENERATI NEL PDM CHE NON SONO
--* STATI PASSATI AL DB_LEI PER IL PASSAGGIO
--* A METODO
--* E' NECESSARIO ESSERE CONNESSI AD ENTRAMBI I DATABASE
--* SRVPDM01 E ERPW2K801
--* I.REBELLATO (14/11/2013)
--*************************************************

DECLARE @DataModificaCodice DATE
SET @DataModificaCodice='2013-11-14'

select * 
from [FUSION_PDM].[dbo].[CODICI]
where codmoddate > @DataModificaCodice and codlastrev = 1 and codbackup = 0
and [FUSION_PDM].[dbo].[CODICI].[codcodice] not in (select CODICE from [erpw2k801].[Db_Lei].[dbo].[PDM_ANAG_SMALL] where data = @DataModificaCodice)
and codcruser is not NULL			-- elimina i codici creati in Metodo e trasmessi al PDM