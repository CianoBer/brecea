--***********************************************
--* ESTRAZIONE DATA INIZIO E DATA FINE TIMBRATURE
--* OFFICINA
--* IMERIO 14/09/2015
--***********************************************


select td.COGNOME,td.NOME, sa.progressivo, sa.esercizio,  sa.codcausale, sa.numerobolla, sa.cdlavoro, sa.macchina,
convert(varchar,sa.datamov, 105) as datamovimento,convert(varchar,sa.orainiziomacchina, 108) as apre, convert(varchar, sa.orafinemacchina, 108) as chiude, 
convert(real,sa.oremacchina) as ore, sa.datamodifica, sa.UTENTEMODIFICA 
FROM TABELLADIPENDENTI td
inner join dipendentimovimento dm on codice = dipendente
inner join storicoavanzamenti sa on rifprogressivo = progressivo
where datamov > '2015-09-13'
and codcausale in (100,110,200)
order by cognome, progressivo


--* ESTRAZIONE ORE TIMBRATURE CARTELLINO (SU ARCA_BREVETTI)
SELECT COGNOME, NOME, T.CODICE, DATA_ORA, * 
FROM TIMBRATURE T
INNER JOIN DIPENDENTI D ON D.CODICE = T.RIF_DIPE
WHERE (DATA_ORA > '2017-03-15' AND DATA_ORA < '2017-03-17') --and COGNOME like 'REBEL%'
order by D.COGNOME, T.DATA_ORA



--*************************************************************************************
--* LISTA RIFERIMENTI DIPENDENTI
select dd.[CODICE], dd.[COGNOME], dd.[NOME] 
from [Arca_Brevetti].[dbo].[DIPENDENTI] dd
where [DATA_LICENZ] is null
order by dd.[COGNOME]

--* ESTRAZIONE ORE BUSTA PAGA (SU ARCA_BREVETTI)
--* Fornire dati mensili a Elisa
select aa.[RIF_DIPE], dd.[COGNOME], dd.[NOME],CONVERT(VARCHAR, aa.[DATA], 105) AS GIORNO, 
aa.[TIMB_1],aa.[TIMB_2],aa.[TIMB_3],aa.[TIMB_4],aa.[MINUTI]/60 AS ORE, aa.[MINUTI]%60 as MINUTI,
CC.[DESCRIZIONE] 
from [Arca_Brevetti].[dbo].[vw_RISULTATI] aa 
inner join [Arca_Brevetti].[dbo].[DIPENDENTI] dd on dd.[CODICE] = aa.[RIF_DIPE]
LEFT JOIN [Arca_Brevetti].[dbo].[CAUSALI] CC ON aa.[RIF_CAUSALE] = CC.[CODICE]
where
--[RIF_DIPE] IN  (159) and
--dd.[COGNOME] = 'REBELLATO' AND
 ([DATA] >= '2017-06-01' AND [DATA] <= '2017-06-30')
 ORDER BY [COGNOME], [DATA]

 
