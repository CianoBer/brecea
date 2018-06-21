--***************************************************
--* Ricerca FILE *_3D.pdf che contengano nella stessa
--* cartella anche il corrispondente file _3D.asm.pdf
--* (o _3D.par.pdf).
--* Una volta cancellati i file in ROOT è necessario fare pulizia nel DB
--* 1) eliminare dalla tabella COMPONENTI
--* i riferimenti ai _3D.pdf (x eliminare la visualizzazione dei legami nel PDM)
--* 2) eliminare dalla tabella FilesPubblicati_001 (FUSION_COLL) i file che 
--* non trovano corrispondenza nel PDM a seguito della query 1
--* (x eliminare la visualizzazione delle icone nel WebPortal)
--* 3) eliminare fisicamente i file dalla cartella ROOT tramite
--* EdmRootClean.exe (nella cartella c:\Programmi (x86)\RuleDesigner\...2008\....)
--* oppure con un bat fatto appositamente
--*
--*			MALDINI (16/05/2014)
--***************************************************

--* 1)
select compfile from componenti where compfile like '71556251.pdf' and exists 
(select compID from componenti as COMP2 where COMP2.codid = componenti.codid and COMP2.compfile like '71556251.pdf')
order by compfile

--delete from componenti where compfile like '71556251.pdf' and exists 
--(select compID from componenti as COMP2 where COMP2.codid = componenti.codid and COMP2.compfile like '71556251.pdf')


--* 2)
select * from FilesPubblicati_001 where fpFileName not in (select compfile from FUSION_PDM.dbo.COMPONENTI)

--delete from FilesPubblicati_001 where fpFileName not in (select compfile from FUSION_PDM.dbo.COMPONENTI)


