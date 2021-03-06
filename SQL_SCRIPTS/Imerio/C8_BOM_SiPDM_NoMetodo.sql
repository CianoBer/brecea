--*******************************************
--* CONTROLLA CHE LE DISTINTE DEGLI ASSIEMI
--* GENERATE NEL PDM SIANO STATE TRASMESSE
--* A METODO 
--* CONTROLLARE PRIMA LA SITAUZIONE A) E TRASMETTERE LISTA A MED
--* CONTROLLARE POI LA SITUAZIONE B) E RILANCIARE L'IMPORT
--*
--* IMERIO OTTOBRE 2014
--*******************************************

SELECT LEI.ID, lei.statocontrolli
	  ,dst.[codCodice] AS CODICE_DISTINTA
      ,dst.[codRev] AS REVISIONE
	  ,[utName] as UTENTE_ULTIMA_MODIFICA
      ,convert(varchar, dst.[distModDate], 105) AS DATA_ULTIMA_MODIFICA_PDM
  FROM [srvpdm01].[FUSION_PDM].[dbo].[DISTINTA] DST
  LEFT join [srverp01].[BRECEA].[dbo].[DISTINTAARTCOMPOSTI] DA on [artcomposto] = [codCodice]
  LEFT join [srverp01].[BRECEA].[dbo].[EXTRAMAG] EM on [CODART] = [codCodice]
  LEFT JOIN [srverp01].[BRECEA].[dbo].[EXTRADISTINTA] ED on DA.[PROGRESSIVO] = ED.[PROGRESSIVO]
  LEFT JOIN [srvpdm01].[FUSION_PDM].[dbo].[USERS] ON [UTid] = [utIDModUser]
  LEFT JOIN [srverp01].[Db_Lei].[dbo].[MET_DISTINTAARTCOMPOSTI]  LEI ON dst.[codCodice] = LEI.[CODICE]
--* elimina i doppioni tenendo solo le righe con la data di ultima modifica  
  INNER JOIN (select [codCodice], max([distModDate]) as DATAMODIFICA from [srvpdm01].[FUSION_PDM].[dbo].[DISTINTA] dst 
				group by [codCodice]) GDST on dst.[codCodice]=GDST.[codCodice] and dst.[distModDate]=GDST.DATAMODIFICA
  where
  --* A) la distinta non è stata esportata (e quindi non è presente nelle tabelle del LEI) 
  --dst.[codCodice] not in (select [CODICE] from [srverp01].[Db_Lei].[dbo].[MET_DISTINTAARTCOMPOSTI])

   --* B) la distinta è stata esportata (e quindi è presente nelle tabelle del LEI) 
  dst.[codCodice] in (select [CODICE] from [srverp01].[Db_Lei].[dbo].[MET_DISTINTAARTCOMPOSTI])
  
  --* si considerano solo gli assiemi
  and dst.[codCodice]  like '1%' 

--* elimina tutti i TP4 (aggiunta del 04/11/2016)
  and dst.[codCodice] not in (select [codCODICE] from [srvpdm01].[FUSION_PDM].[dbo].[codici] cv
								left join [srvpdm01].[FUSION_PDM].[dbo].[propcod] pc on cv.codid = pc.codid
								where  (pc.cpid = 249 or cpIDAlias = 249) and propValore = 'TP4')
  
  --* si eliminano tutti i codici di acquisto che non hanno distinta
  and [CODPIANIFICATORE] <> 1
  
  --* in Metodo la distinta non esiste
  and DA.[datamodifica] IS NULL

  --* si considerano solo le distinte emesse dopo una certa data
  and [distModDate]>'2017-07-01'
  
  ORDER BY dst.[codCodice]

--**************************************************
--* RE-IMPORT DI UNA DISTINTA DA LEI IN METODO
--* DA FARE PER LE DISTINTE EVIDENZIATE NEL CASO B) PRECEDENTE
--* affinchè venga importata in Metodo è sufficiente mettere statocontrolli = 0. 
--* In base al codice padre leggere l’ID corrispondente nella tabella 
--* MET_DISTINTAARTCOMPOSTI e aggiornare di conseguenza le due tabelle
--*
--*IMERIO 16/09/2016
--**************************************************

  --update MET_DISTINTAARTCOMPOSTI set statocontrolli = 0 where id = 18436
  --update MET_DISTINTABASE set statocontrolli = 0 where id = 18436




 --*************************************
 --* CONTROLLO SE CODICI HANNO REVISIONI
 --* DIVERSE TRA PDM E METODO
 --*
 --* IMERIO 11/12/2015
 --**********************************************
select codcodice as codPDM, codrevisione as revPDM, revisione as revMetodo, codcrdate as DATA_CREAZIONE, codcruser AS UTENTE_CREAZIONE, 
codmoddate AS DATA_MODIFCA, codmoduser AS UTENTE_MODIFICA, CODSTATUS AS STATO --(0=disponibile, 2= in revisione, 3=rilasciato, 4=congelato). 
from [srvpdm01].[FUSION_PDM].[dbo].[codici] pc  
inner join [srverp01].[BRECEA].[dbo].[EXTRAMAG] EM on [CODART] = [codCodice]
where 
pc.codlastrev = 1 
and pc.codbackup = 0 
and pc.codrevisione>0
and em.revisione <> pc.codrevisione
order by pc.codcodice

select * from pdm_anag_small where codice = '70560203'

--* allinea Metodo alle revisioni del PDM (solo per i codici rilasciati codstatus = 3)
--update extramag set revisione = PDM.codrevisione
--from extramag erp
--inner join [srvpdm01].[FUSION_PDM].[dbo].[codici] pdm on erp.codart = pdm.codcodice
--where
--pdm.codlastrev = 1 
--and pdm.codbackup = 0 
--and pdm.codrevisione>0
--and revisione <> pdm.codrevisione
--and codstatus = 3



--**********************************************
--* CONTROLLA SE CI SONO CODICI RILASCIATI IN RD
--* CHE NON SONO PASSATI A EMBYON
--* IMERIO 28/08/2017
--**********************************************

select * 
from [srvpdm01].[FUSION_PDM].[dbo].[CODICI] DST
where
  (dst.codlastrev = 1 and dst.codbackup = 0)
  and (dst.[codCodice] not like 'ESP%' and dst.[codCodice] not like 'LAY%' and dst.[codCodice] not like 'X%')
  and (dst.[codstatus] =3)				-- considera solo i rilasciati
  and dst.[codcruser] <> 'brecea'		-- salta quelli generati in automatico alla partenza di RD
  and dst.[codCrDate]>'2017-01-01'
  and dst.[codCodice] not in (select CODICE from ANAGRAFICAARTICOLI)	--verifica che non siano in Embyon
  ORDER BY DST.[CODCRDATE]