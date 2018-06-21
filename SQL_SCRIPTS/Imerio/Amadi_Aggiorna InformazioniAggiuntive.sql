--********************************************
--* copia le info aggiuntive da dittapro a brecea
--* usata x sistemare sovrascrittura delle info
--* aggiuntive causate dal PDM
--*  AMADI 04/10/2013
--*********************************************

select B.codiceart,b.lingua, replace(replace(b.informazioniagg, char(13),' '), char(10),'') as infoagg_b,
replace(replace(d.informazioniagg, char(13),' '), char(10),'') as infoagg_D,
b.utentemodifica,b.datamodifica
 from brecea.dbo.descraRTicoli B
inner join dittapro.dbo.descrarticoli D On (B.codiceart=D.codiceart and B.lingua=D.lingua)
where B.informazioniagg<>D.informazioniagg and b.utentemodifica='pdm'
order by b.datamodifica,b.codiceart,b.lingua	

use BRECEA


--go
--update DESCRARTICOLI
--       set
--             INFORMAZIONIAGG = dp.INFORMAZIONIAGG
--       from 
--             DESCRARTICOLI bc inner join DITTAPRO..DESCRARTICOLI dp on  bc.CODICEART = dp.CODICEART and bc.LINGUA = dp.LINGUA
--       where 
--        bc.INFORMAZIONIAGG = '' and dp.CODICEART <> '' and bc.utentemodifica = 'pdm'
--go

--########################################################################################

--********************************************
--* copia le info aggiuntive da brecea a pdm
--* usata x riallineare le info
--* Connettersi in srvpdm01 e da lì lanciare
--* Attenzione: in Metodo il campo Infoaggiuntive = 3000 char, in RD = 255 char
--*  I.REBELLATO 16/10/2013
--*********************************************

--* CONFRONTA LE INFO TRA I DUE DB (per controllo)
SELECT  CO.CODCODICE, replace(replace(PC.PROPVALORE, char(13),' '), char(10),'') AS INFOAGGPDM, 
replace(replace(BC.INFORMAZIONIAGG, char(13),' '), char(10),'') AS INFOAGGMETODO
  FROM [FUSION_PDM].[dbo].[PROPCOD] PC								-- tabella che contiene le info aggiuntive ne PDM
  inner join [FUSION_PDM].[dbo].[CODICI] CO on PC.CODID = CO.CODID	-- tabella che contiene i codici nel PDM
  inner join [FUSION_PDM].[dbo].[CAMPI] CA ON CA.CPID = PC.CPID		-- tabella che contiene gli ID dei vari campi del DB del PDM
  inner join ERPW2K801.BRECEA.DBO.DESCRARTICOLI BC on bc.CODICEART = CO.CODCODICE
  where 
        bc.codiceart in (select co.codcodice from FUSION_PDM.dbo.CODICI) and bc.LINGUA = 0 AND CA.CPNOME LIKE 'INFORMAZIONI AGGIUNTIVE' 
		and len(bc.informazioniagg) > 255  -- verifica le descrizioni che non possono essere aggiornate perchè troppo lunghe




--use FUSION_PDM
--go
--update FUSION_PDM.dbo.PROPCOD
--       set
--             PROPVALORE = BC.INFORMAZIONIAGG
--       from 
--            FUSION_PDM.dbo.PROPCOD PC 
--			inner join FUSION_PDM.dbo.CODICI CO on PC.CODID = CO.CODID
--			inner join FUSION_PDM.dbo.CAMPI CA ON CA.CPID = PC.CPID
--			inner join ERPW2K801.BRECEA.DBO.DESCRARTICOLI BC on bc.CODICEART = CO.CODCODICE
--       where 
--        bc.codiceart in (select co.codcodice from FUSION_PDM.dbo.CODICI) and bc.LINGUA = 0 AND CA.CPNOME LIKE 'INFORMAZIONI AGGIUNTIVE'
--		and len(bc.informazioniagg) < 255	-- aggiorna solo i codici con le descrizioni in Metodo < di 255 char
--go
	
