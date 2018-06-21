--*********************************
--* VERIFICA TRADUZIONI
--*********************************
select 
	aa.codice,
	aa.descrizione,
	aa.datamodifica,
	da.lingua,
	da.descrizioneagg
from
	anagraficaarticoli aa
	left outer join descrarticoli da on aa.codice=da.codiceart
where
	lingua=5
--AND AA.CODICE < '7600000'


--********************************************************
--* ESTRAZIONE TRADUZIONI DA LISTA EXCEL
--* 2= Traduzioni lunghe, 5= traduzioni corte (Ricambi)
--*******************************************************

select tr.*, codartprod, nomeprod, da.descrizioneagg 
	from zzzdistinta tr
	left join descrarticoli da on da.codiceart = tr.codice
	left join extramag em on em.codart = tr.codice
	where lingua in (5)



 --****************************************************************************************************
 --*	MANUTENZIONE TRADUZIONI TENENDO ALLINEATE LE RIGHE TRA TRADUZIONE ESTESA E TRADUZIONE CORTA
 
 --**************************************************************************
 --* CONTROLLARTE PRIMA DI TUTTO CHE TUTTI I CODICI DA IMPORTARE ESISTANO IN METODO

select it.* from zzzimporttraduzioni it
where not exists (select * from anagraficaarticoli aa where aa.CODICE = it.CODARTCOMPONENTE)

--DELETE ZZZIMPORTTRADUZIONI WHERE CODARTCOMPONENTE = '71341261'


 --***********************************************************
 --* ALLINEAMENTO TRA TRAD. ESTESA E TRAD. RICAMBI QUANDO
 --* UNA DELLE DUE NON ESISTE
 --* 
 --* CERCA TUTTI I CODICI CHE HANNO TRADUZIONE INGLESE ESTESA
 --* (LINGUA = 2) MA NON LA TRAD. INGLESE RICAMBI (LINGUA = 5)
 --* (EFFETTUARE ANCHE L'ALLINEAMENTO INVERSO, CREA 2 COPIANDOVI 5)
 --* IMERIO 05/11/2015
 --***********************************************************
 
 select * from descrarticoli A where 
 LINGUA IN(2,5) AND 
 EXISTS (SELECT * FROM DESCRARTICOLI B WHERE A.CODICEART = B.CODICEART AND LINGUA = 2) AND 
 not EXISTS (SELECT * FROM DESCRARTICOLI C WHERE A.CODICEART = C.CODICEART AND LINGUA = 5)
 
 --INSERT INTO descrarticoli (CODICEART,descrizioneagg, utentemodifica, LINGUA, DATAMODIFICA) 
 --SELECT A2.CODICEART, a2.descrizioneagg,a2.utentemodifica, 5, '2015-11-17'
 --from descrarticoli a2
 --where 
 --LINGUA = 2 AND
 --EXISTS (SELECT * FROM DESCRARTICOLI B WHERE A2.CODICEART = B.CODICEART AND LINGUA = 2) AND 
 --NOT EXISTS (SELECT * FROM DESCRARTICOLI C WHERE A2.CODICEART = C.CODICEART AND LINGUA = 5)


--*******************************************************
--* ALLINEAMENTO TRA TRAD. ESTESA E TRAD. RICAMBI QUANDO 
--* ENTRAMBE ESISTONO MA UNA DELLE DUE E' NULL
--*
--* CERCA I CODICI CHE HANNO TRAD. RICAMBI (LINGUA=5) 
--* MA TRAD. ESTESA (LINGUA =2) NULL

 select A.*, B.* from descrarticoli A 
 INNER join DESCRARTICOLI b on a.codiceart = b.codiceart AND B.LINGUA = 2
 where
 a.lingua = 5 and 
 (a.descrizioneagg is null and b.DESCRIZIONEAGG is not null)
 ORDER BY A.CODICEART
 
--update A set a.descrizioneagg = b.descrizioneagg, a.utentemodifica=b.utentemodifica, DATAMODIFICA = '2015-11-05'
--from DESCRARTICOLI a
-- INNER join DESCRARTICOLI b on a.codiceart = b.codiceart AND B.LINGUA = 2
-- where
-- a.lingua = 5 and 
-- (a.descrizioneagg is null and b.DESCRIZIONEAGG is not null)



--**************************************************************************************************************
--*		IMPORTAZIONE TRADUZIONI DA FILE EXCEL ESTERNO

--* IMPORTARE DATI CREANDO NUOVA TABELLA CON NOME ZZZxxxxx (ES. zzzImportTraduzioni)
--* LA TABELLA DEVE AVERE LE COLONNE CODARCOMPONENTE, TRADUZIONE ED EVENTUALMENTE LISTA (da usare se ci sono 
--* codici con e senza traduzione; si mette il valore LISTA=1 per quei codici che hanno la TRADUZIONE da importare)

--* CONTROLLO CODICI DA IMPORTARE
SELECT * FROM zzzImportTraduzioni WHERE LISTA = 1


--* ESISTE IN LINGUA 2 E NON IN LINGUA 5 (VERIFICARE ANCHE IL VICEVERSA)
--* IN QUESTO CASO SI DEVE FARE L'INSERT PER LA LINGUA MANCANTE
select *
FROM DESCRARTICOLI a
inner JOIN zzzImportTraduzioni B ON A.CODICEART=B.codartcomponente and b.lista = 1
where
lingua = 2 and
EXISTS (SELECT * FROM DESCRARTICOLI  WHERE CODICEART = B.codartcomponente AND LINGUA = 2)
and NOT EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5)  

 --INSERT INTO descrarticoli (CODICEART,descrizioneagg, utentemodifica, LINGUA, DATAMODIFICA) 
 --SELECT B.codartcomponente, B.TRADUZIONE,'DAL BELLO', 5, '2015-11-05'
 --from zzzImportTraduzioni B
 --where 
  --EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 2) AND 
 --NOT EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5)

 
--* NON ESISTE NE' IN LINGUA 2 NE' IN LINGUA 5
--* IN QUESTO CASO SI FA L'INSERT PER ENTRAMBE LE LINGUE
select *
FROM DESCRARTICOLI a
inner JOIN zzzImportTraduzioni B ON A.CODICEART=B.codartcomponente and b.lista = 1
where
NOT EXISTS (SELECT * FROM DESCRARTICOLI  WHERE CODICEART = B.codartcomponente AND LINGUA = 2)
and NOT EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5) 

--INSERT INTO descrarticoli (CODICEART,descrizioneagg, utentemodifica, LINGUA, DATAMODIFICA) 
-- SELECT B.codartcomponente, B.TRADUZIONE,'DAL BELLO', 5, '2015-11-05'
-- from zzzImportTraduzioni B
-- where
-- B.LISTA = 1 AND 
--  NOT EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 2) AND 
-- NOT EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5)


--* ESISTE SIA IN LINGUA 2 CHE IN 5
--* IN QUESTO CASO FARE L'UPDATE PER ENTRAMBE LE LINGUE
select *
FROM DESCRARTICOLI a
inner JOIN zzzImportTraduzioni B ON A.CODICEART=B.codartcomponente and b.lista = 1
where
lingua IN (2,5) and
EXISTS (SELECT * FROM DESCRARTICOLI  WHERE CODICEART = B.codartcomponente AND LINGUA = 2)
and EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5)
 
-- UPDATE A SET a.descrizioneagg = B.Traduzione, a.utentemodifica='DOCUMENTAZIONE', DATAMODIFICA = '2015-11-17'
--FROM DESCRARTICOLI a
--inner JOIN zzzImportTraduzioni B ON A.CODICEART=B.codartcomponente and b.lista = 1
--where
--a.lingua = 5 and
--EXISTS (SELECT * FROM DESCRARTICOLI WHERE CODICEART = B.codartcomponente AND LINGUA = 5) 



--**********************************************
--* ESTRAI DISTINTA RICAMBI CON INFO VARIE

DECLARE @Commessa VARCHAR(20)
SET @Commessa='19180829'

;with Distinta (artcomposto, codartcomponente, um, qta, livello, ordina)
as
(
-- individua i componenti a livello1
select dc.artcomposto, db.codartcomponente,db.um, db.qta1, 1 as livello, 
cast((row_number() over (order by db.codartcomponente ASC)*10) as int) as ordina  --assegna un progressivo (multiplo di 10) ad ogni figlio di livello 1
from distintabase db
inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
WHERE dc.artcomposto = @Commessa


--union all

---- individua componenti a livello successivo (ricorsivamente)
--select dc.artcomposto, db.codartcomponente, db.um, db.qta1, livello+1, 
--cast((ordina+cast(livello as int))as int)	--assegna un progressivo ai figli di livello inferiore partendo dal progressivo assegnato al padre
--from distintabase db
--inner join distintaartcomposti dc on dc.progressivo = db.rifprogressivo
--inner join distinta d on dc.artcomposto = d.codartcomponente
)

select d.artcomposto, d.codartcomponente, aa.descrizione, d.livello, d.um, d.qta, em.codartprod as codiceproduttore, 
em.nomeprod as produttore,em.ltcumulato as LeadTime, ap.tapprontacq, ap.tapprontprod, em.durataprevistaore, em.criticita, 
TBC.DESCRIZIONE AS desc_criticita, em.catricambi, tbr.descrizione as descr_catricambi,em.verricambio as verificaRic, 
ac.esaurito, ac.inesaurimento, ap.artalternativo, da.DESCRIZIONEAGG, em.UtenteCreazione --, convert(money, prezzoeuro) prezzolistino --, ordina
from distinta d
left join extramag em on em.codart = d.codartcomponente
left join met_tabcatricambi tbr on tbr.codice = em.CATRICAMBI
left join met_tabcriticita tbc on tbc.codice = em.CRITICITA
inner join anagraficaarticoli aa on aa.codice = d.codartcomponente
left join DESCRARTICOLI da on da.codiceart = d.codartcomponente and da.lingua = 2	--* 2: short inglese
left join ANAGRAFICAARTICOLICOMM ac on ac.CODICEART = d.codartcomponente and ac.esercizio = year(getdate())
left join ANAGRAFICAARTICOLIPROD ap on ap.CODICEART = d.codartcomponente and ap.esercizio = year(getdate())
--left join LISTINIARTICOLI la on la.CODART = d.codartcomponente and nrlistino = 11
order by ordina