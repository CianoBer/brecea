--***************************************************************
-- estrazione distinta per verifica categoria ricambi
--* I.REBELLATO 18/10/2013
--***************************************************************

DECLARE @Commessa VARCHAR(20)
SET @Commessa='00u0503'

;with Distinta (artcomposto, codartcomponente, livello, ordina)
as
(
-- individua i componenti a livello1
select dc.artcomposto, db.codartcomponente, 1 as livello, 
cast((row_number() over (order by db.codartcomponente ASC)*10) as int) as ordina  --assegna un progressivo (multiplo di 10) ad ogni figlio di livello 1
from distintabase db
inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
WHERE dc.artcomposto = @Commessa
--where dc.artcomposto = (@Commessa+'-P01')		-- individua i codici della sola commessa
--where dc.artcomposto like (@Commessa+'-A%')		-- individua i codici di eventuali commesse di aggiornamento

union all

-- individua componenti a livello successivo (ricorsivamente)
select dc.artcomposto, db.codartcomponente, livello+1, 
cast((ordina+cast(livello as int))as int)	--assegna un progressivo ai figli di livello inferiore partendo dal progressivo assegnato al padre
from distintabase db
inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
inner join distinta d on dc.artcomposto = d.codartcomponente
)

select ordina, d.artcomposto, d.codartcomponente, aa.descrizione, d.livello, em.catricambi, em.codartprod as codiceproduttore, em.nomeprod as produttore,
em.ltcumulato as LeadTime, AP.TAPPRONTACQ, AP.TAPPRONTPROD, em.verricambio as verificaRic, tbr.descrizione as categoria_ricambi, ac.esaurito, ac.inesaurimento, ap.ARTALTERNATIVO --, ordina
from distinta d
left join extramag em on em.codart = d.codartcomponente
left join met_tabcatricambi tbr on tbr.codice = em.CATRICAMBI
inner join anagraficaarticoli aa on aa.codice = d.codartcomponente
left join ANAGRAFICAARTICOLICOMM ac on ac.CODICEART = d.codartcomponente and ac.esercizio = year(getdate())
left join ANAGRAFICAARTICOLIPROD ap on ap.CODICEART = d.codartcomponente and ap.esercizio = year(getdate())
left join LISTINIARTICOLI la on la.CODART = d.codartcomponente and nrlistino = 11
order by ordina

