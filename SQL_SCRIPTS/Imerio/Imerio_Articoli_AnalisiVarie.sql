--*********************************
--* VERIFICA PREZZI LISTINO
--*********************************

select aa.codice, aa.descrizione, bb.nrlistino, bb.prezzoeuro from anagraficaarticoli aa, listiniarticoli bb 
where aa.codice=bb.codart and bb.nrlistino = '104' and bb.prezzoeuro = 0
order by aa.codice


--*********************************
--* VERIFICA TEMPO APPRONTAMENTO
--* (solo per mag 100. Il mag 20 viene gestito
--* tramite il documento SCR)
--*********************************
select CODICEART, provenienza, descrizione, tapprontacq, tapprontprod, ltcumulato, scortamin 
from anagraficaarticoliprod aap
left join extramag em on aap.codiceart = em.codart
left join anagraficaarticoli aa on aap.codiceart = aa.codice
where
(codiceart like '7%' or codiceart like '6%' )
and provenienza = 0 --0= acquisti, 1=produzione
and tapprontacq = 0 --(tapprontacq > 20 or tapprontacq = 0)
and aap.ESERCIZIO IN ('2014')
and codiceart in (select codart from storicomag where datamov > '01/01/2010') -- movimentati dopo una certa data
order by tapprontacq



--******************************************************
--* PER ACQUISTI
--* CERCA CODICI CON UM DIVERSE IN ANAGRAFICA ARTICOLI TRA
--* UM ACQUISTO (TAB UNITA' DI MISURA) E  UM PIANIFICAZIONE
--* (PRODUZIONE | ACQUISTO)
--*
--*imerio 27/07/2011
--********************************************************
select aa.codiceart, aa.umlottoacq AS UMPIANIFICAZIONE, ap.UM AS UMACQUISTI
from anagraficaarticoliprod aa
inner join articoliumpreferite ap on aa.codiceart = ap.codart
where aa.esercizio = '2011' 
and ap.tipoUM = 4 --individua l'UM di acquisto
and aa.umlottoacq <> ap.UM
order by aa.codiceart

--*********************************
--* VERIFICA ARTICOLI CON SCORTA MINIMA
--*********************************
select codiceart, aa.descrizione, convert(real, qminriordacq) as livacq, convert(real, qminriordprod) as livprod, convert(money, PREZZOEURO) as EuroUnitario
from anagraficaarticoliprod aap
left join anagraficaarticoli aa on aap.codiceart = aa.codice
left join listiniarticoli la on aap.codiceart = la.codart
where esercizio = 2013
and (qminriordacq >0 or qminriordprod > 0)
and nrlistino = '1306'
order by CODICEART


--************************************************
--* ARTICOLI CON SCORTA IN DOCUMENTO SCR (RICAMBI)
--************************************************
SELECT CODART, DESCRIZIONE, umgest as UM, convert(real,QTAGEST) as qta
FROM RIGHEDOCUMENTI RD
INNER JOIN ANAGRAFICAARTICOLI AA ON AA.CODICE = RD.CODART
WHERE 
TIPODOC = 'SCR'
AND ESERCIZIO = '2011'
AND QTAGEST <> 0 
order by codart


--*********************************************
--* DATI ARTICOLI PER UFF. ACQUISTI
--* CODICE, CAT. STATISTICHE, TEMPO APPRONTAMENTO STD
--* TEMPO APPRONT. PER FORNITORI PREFERENZIALI
--*********************************************
select aap.CODICEART, aa.descrizione, AA.GRUPPO, AA.CATEGORIA, AA.CODCATEGORIASTAT, AAP.TAPPRONTACQ, AAP.TAPPRONTPROD,
CONVERT(REAL,aap.scortamin) AS SCORTAMIN,TL.CODFOR, TL.GGAPPRONT
from anagraficaarticoliprod aap
inner join anagraficaarticoli aa on aa.codice = aap.codiceart
LEFT JOIN TABLOTTIRIORDINO TL ON AA.CODICE = TL.CODART
where 
--AAP.TAPPRONTACQ <> 0	-- da usare se AAP.PROVENIENZA = '0'
 AAP.TAPPRONTPROD<>0	-- da usare se AAP.PROVENIENZA = '1'
AND AAP.PROVENIENZA = '1' -- 0=ACQUISTO, 1=PRODUZIONE, 2=CONTOLAVORO
AND ESERCIZIO IN ('2011')
order by codiceart



--*********************************
--* VERIFICA E UPDATE ARTICOLI SENZA NOMENCLATURA COMBINATA
--*********************************
select CODICE, DESCRIZIONE from anagraficaarticoli
where ((NOMENCLCOMBINATA2 = '') OR (NOMENCLCOMBINATA2 = ''))
and codice >= '1001000' and codice <= 'z80008'
order by codice

--UPDATE ANAGRAFICAARTICOLI SET NOMENCLCOMBINATA2 = '90319038'
--where NOMENCLCOMBINATA2 = ''
--and codice >= '1001000' and codice <= 'z80008'


--*********************************
--* VERIFICA CATEGORIE
--*********************************
select codice, descrizione, categoria 
from anagraficaarticoli 
where categoria IN (select codice from tabcategorie where codice = '21') 
order by codice



--*********************************************
--* DATI ARTICOLI PER UFF. ACQUISTI
--* ARTICOLI ACQUISTATI DA CERTI FORNITORI
--* IN CERTI PERIODI
--*********************************************
select 
	sm.codart, aa.descrizione, sm.codclifor, da.informazioniagg, convert(real, sum (sm.qta1um)) as Qta_acquistate
from storicomag sm
LEFT JOIN anagraficaarticoli aa ON aa.codice = sm.codart
LEFT JOIN descrarticoli da ON sm.codart = da.codiceart
where 
	(sm.datamov > '01/01/2010') --and sm.datamov <= '30/04/2010') 
	and sm.coddeposito = '100'
	
	-- CASUALI MOVIMENTI
	and sm.codcausale = '115'
	-- 501 = carico iniziale, 90 = ripresa valore, 200 = RETTIFICA Positiva, 201 = rettifica negativa
	-- 2 = scarico magazzino, 18 = scarico x vendita da visione, 
	-- 124 = carico consegna in c/lavoro, 125 = scarico x consegna in c/lavoro
	-- 120 = ordinato prod., 121 = impegnato prod., 122 = carico da prod. int., 123= prel. x prod. int.
	-- 15 = scarico x trasf. a deposito, 16=carico x trasf. da dep.
	-- 115 = carico da fornitore
	
	--and sm.codart IN ('1056000', '1702010', '1480018', '1056001', 'IAB0800', '11220011', 'IAB0875', 'IAC1400', 'IAB0560', '14060483')
	and sm.codclifor='F   316'
	and sm.codart NOT LIKE '%DIP%' and sm.codart >= '1001000'	-- controlla solo i codici articolo, saltando i vari codici macchine e dipendenti


group by sm.codart, aa.descrizione, sm.codclifor,da.informazioniagg
order by sm.codart ASC --Nr_Movimenti DESC, 


-- *************************************************************************************************
--          CERCA ARTICOLI NON MOVIMENTATI
--              IMERIO LUGLIO 2009
--
-- seleziona tutti gli articoli con ubicazione che non hanno movimenti successivi ad una certa
-- data escludendo in ogni caso i movimenti aventi
-- causali 501 = carico iniziale, 90 = ripresa valore, 200 = rettifica positiva e 201 = rettifica negativa
-- lanciare query con (vg.ordinato = 0 and impegnato = 0) per trovare i codici non impegnati e non ordinati
-- Nota: la query estrae tutti i codici che hanno una ubicazione in anagraficaarticoli.
--* Per verificare se hanno anche giacenza incrociare con un inventario
-- **************************************************************************************************
set dateformat dmy
select convert(varchar, aa.codice) as cod, aa.descrizione, ua.codubicazione, em.UtenteCreazione --, vg.ordinato, vg.impegnato, vg.carico, vg.scarico,vg.esercizio 
from anagraficaarticoli aa
left join vistagiacenzetot vg on vg.codart = aa.codice
left join ubicazioniarticoli ua on ua.codiceart = aa.codice
left join extramag em on em.codart = aa.codice
where 
		-- considera solo i codici che non hanno subito movimenti dopo una certa data
		codice not in (select codart from storicomag where (datamov > '01/01/2017' and codcausale not in (501, 90, 200, 201))) 
		-- considera quelli che non hanno ordini nè impegni (per la giacenza fare un confronto con un inventario)
		and (vg.ordinato = 0 and vg.impegnato = 0)
		and ua.coddeposito = 020
		and codice NOT LIKE '%DIP%' and codice NOT LIKE '%#%'
		and vg.esercizio > 2008
group by codice, descrizione, ua.codubicazione, em.UtenteCreazione
order by aa.codice --codubicazione


-- ***************************************************************************
--          CERCA ARTICOLI MOVIMENTATI
--              IMERIO FEBBRAIO 2010
-- 
-- seleziona tutti gli articoli che hanno avuto movimenti in un certo periodo
-- e in un certo magazzino secondo certe causali
-- Nota: incrociando i dati con un inventario, per differenza si possono
-- estrarre i Non Movimentati
-- ***************************************************************************
set dateformat dmy
select 
	sm.codart, aa.descrizione, convert(real, sum (sm.qta1um)) as Qta_Movimentate, Nr_Carichi = sum (quantitacarico), Nr_Scarichi = sum (quantitascarico)
from storicomag sm
LEFT JOIN anagraficaarticoli aa ON aa.codice = sm.codart
where 
	(sm.datamov > '30/06/2015') --and sm.datamov <= '30/04/2010') 
	and sm.coddeposito = '020'
	
	-- CASUALI MOVIMENTI
	and codcausale not in (501, 90, 200, 201, 15, 16) 
	-- 501 = carico iniziale, 90 = ripresa valore, 200 = RETTIFICA Positiva, 201 = rettifica negativa, 15= trasferimento a deposito, 16 = Trasferimento da deposito
	-- 2 = scarico magazzino, 18 = scarico x vendita da visione, 
	-- 124 = carico consegna in c/lavoro, 125 = scarico x consegna in c/lavoro
	-- 120 = ordinato prod., 121 = impegnato prod., 122 = carico da prod. int., 123= prel. x prod. int.
	-- 15 = scarico x trasf. a deposito, 16=carico x trasf. da dep.
	and sm.codart NOT LIKE '%DIP%' and sm.codart >= '1001000'	-- controlla solo i codici articolo, saltando i vari codici macchine e dipendenti

group by sm.codart, aa.descrizione, aa.gruppo, aa.categoria --, codcausale
order by sm.codart ASC --Nr_Movimenti DESC, 


-- ***************************************************************************
--          CERCA ARTICOLI CON UN CERTO TEMPO DI APPRONTAMENTO
--           E MOVIMENTATI IN UN CERTO PERIODO
--  ATTENZIONE: IL MAGAZZINO 20 PRENDE I TEMPI DI APPRONTAMENTO DAL DOCUMENTO RIC
--              IMERIO FEBBRAIO 2010
-- AGGIUNGERE CODICE PADRE, DATA ULTIMA MODIFICA/PRIMO MOVIMENTO, NR SCARICHI ULTIMI ANNO
-- ***************************************************************************
set dateformat dmy
select 
	ap.CODICEART, aa.descrizione, aa.datamodifica, TempoApprontamento=ap.tapprontacq, 
	ap.scortamin, bb.prezzoeuro--, Art_Padre=da.artcomposto
from anagraficaarticoliprod ap
	inner join anagraficaarticoli aa on aa.codice = ap.codiceart				-- ALLINEA AANAGRAFICAARTICOLI E ANAGRAFICAARTICOLIPROD
	left outer join listiniarticoli bb on ap.codiceart=bb.codart				-- ALLINEA ANAGRAFICAARTICOLIPROD E LISTINIARTICOLI
--	left outer join distintabase db on ap.codiceart=db.codartcomponente			-- ALLINEA ANAGRAFICAARTICOLIPROD CON DISTINTABASE
--	left outer join distintaartcomposti da on db.rifprogressivo=da.progressivo	-- ALLINEA DISTINTABASE CON DISTINTAARTCOMPOSTI
where 
	ap.tapprontacq > 20			-- TEMPO APPRONTAMENTO ACQUISTO > 20 GIORNI
	and bb.nrlistino = '112'	-- LISTINO 112

	-- CONSIDERA GLI ARTICOLI CHE SONO STATI MOVIMENTATI IN UN CERTO PERIODO ESCLUDENDO I MOVIMENTI
	-- 501 = carico iniziale, 90 = ripresa valore e 200 = RETTIFICA INVENTARIALE
	and ap.codiceart in (	select ap.CODICEART 
							from anagraficaarticoliprod ap
								left outer join storicomag sm on ap.codiceart=sm.codart
							where 
								(sm.datamov > '31/12/2008' and sm.datamov < '01/01/2010')
								and sm.codcausale not in (501, 90, 200)
						)
	and ap.esercizio = '2009'

order by ap.codiceart



-- **************************************
-- * CONTA MOVIMENTI E QUANTITA' NEI DOCUMENTI TMG E TMR
-- * DI ARTICOLI TRASFERITI TRA MAG 20 E MAG 100 
-- *  
-- * Imerio 17/02/2010
-- **************************************

select DD.codart, Nr_mov = count(dd.codart) --qtà = SUM (QTAGEST) 
from testedocumenti aa, righedocumenti dd
where dd.idtesta = aa.progressivo		   -- ALLINEA TESTEDOCUMENTI E RIGHEDOCUMENTI
and dd.codart <> ''                          -- solo righe relative ad articoli

-- SELEZIONA TIPODOC
AND aa.tipodoc IN ('TMG', 'TMR')  
AND ((dd.causalemag = '16' and dd.coddeposito = '020' and dd.causalemagcoll = '15' and dd.coddepositocoll = '100')
      OR (dd.causalemag = '15' and dd.coddeposito = '100' and dd.causalemagcoll = '16' and dd.coddepositocoll = '020')
	)

and aa.esercizio = '2009'
group by dd.codart
order by dd.codart ASC


--**********************************************************************************
--* PER M. FACCIO: VITERIE MOVIMENTATE A MAGAZZINO 100
--* IMERIO 13/04/2010
--************************************************************
-- 2 = scarico magazzino, 18 = scarico x vendita da visione, 125=scarico x consegna in c/lavoro, 123= prel. x prod. int.
-- 120=ordinato prod., 121=impegnato prod., 122=carico da prod. int.
-- 15=scarico x trasf. a deposito, 16=carico x trasf. da dep.
select 
	sm.codart, aa.descrizione, Qta_scaricate = sum (sm.qta1um), la.prezzoeuro, aa.codcategoriastat, count (1) as Nrmovimenti --, codcausale
from storicomag sm
inner join anagraficaarticoli aa on aa.codice = sm.codart
left outer join listiniarticoli la on sm.codart=la.codart
where 
	(sm.datamov > '31/12/2009' and sm.datamov < '01/03/2010') 
	and sm.codcausale in (123) 
    and la.nrlistino = '103'
--and aa.codcategoriastat = 900
--and aa.categoria = 31
and sm.coddeposito = '100'
group by sm.codart, aa.descrizione, aa.codcategoriastat, la.prezzoeuro --, codcausale
order by sm.CODART ASC


--**********************************************************************************
--* PER FERRARI: ANALISI LISTINI RICAMBI
--* ARTICOLI MOVIMENTATI A MAG 020 (prima query) E VALORIZZATI SECONDO UN CERTO LISTINO (seconda query)
--* ATTENZIONE: FISSATO UN LISTINO FA VEDERE SOLO I CODICI PRESENTI IN
--* QUEL LISTINO! => PER AVERE TUTTI I MOVIMENTATI TOGLIERE IL RIFERIMENTO AL LISTINO
--* IMERIO 18/05/2010
--************************************************************
select 
	sm.codart, aa.descrizione, convert(real, sum (sm.qta1um)) as Qta_scaricate, Nr_Movimenti = count (sm.datamov)
from storicomag sm
LEFT JOIN anagraficaarticoli aa ON aa.codice = sm.codart			-- ALLINEA ANAGRAFICAARTICOLIPROD
where 
	(sm.datamov > '01/01/2008' and sm.datamov <= '31/12/2011') 
	and sm.codcausale in (2)--, 18)									-- 2 = scarico magazzino, 18 = scarico x vendita da visione, 
and sm.coddeposito IN ('020') --, '050')								-- mag 020 = mag ricambi, mag 050 = mag c/visione
--and sm.codart = 'e0z0207'
group by sm.codart, aa.descrizione --, bb.prezzoeuro
order by sm.codart ASC --Nr_Movimenti DESC,


select 
	sm.codart, aa.descrizione, convert(money,bb.prezzoeuro) AS PREZZO
from storicomag sm
LEFT JOIN anagraficaarticoli aa ON aa.codice = sm.codart			-- ALLINEA ANAGRAFICAARTICOLIPROD
inner join listiniarticoli bb on sm.codart = bb.codart				-- ALLINEA LISTINIARTICOLI
where 
	(sm.datamov > '01/01/2010' and sm.datamov <= '28/02/2011') 
	and sm.codcausale in (2, 18)									-- 2 = scarico magazzino, 18 = scarico x vendita da visione, 
and sm.coddeposito IN ('020', '050')								-- mag 020 = mag ricambi, mag 050 = mag c/visione
--and sm.codart = '17561772'
and bb.nrlistino = '11'	
group by sm.codart, aa.descrizione, bb.prezzoeuro
order by sm.codart ASC --Nr_Movimenti DESC,



--**********************************************************************************
--* ANALISI RETTIFICHE FINE ANNO
--* ESTRAZIONE MOVIMENTI DI RETTIFICA ELABORATI A FINE ANNO
--* PER EVENTUALI CONTROLLI E/O MODIFICHE
--* IMERIO 25/01/2011
--************************************************************
SELECT     SM.CODART, AA.DESCRIZIONE, SM.CODCAUSALE, SM.DATAMOV, SM.QUANTITACARICO, SM.QUANTITASCARICO, SM.GIACENZA, SM.ORDINATO, SM.IMPEGNATO, 
		   convert(real,SM.QTA1UM) as quantita, SM.CODDEPOSITO, SM.CODUBICAZIONE, SM.ESERCIZIO, SM.UTENTEMODIFICA, SM.DATAMODIFICA
FROM       STORICOMAG SM
			left join anagraficaarticoli aa on AA.codice = SM.codart    
WHERE     (SM.DATAMOV = '2013-12-31') 
		  AND (SM.CODCAUSALE IN (200, 201))   --200= Positive, 201=Negative
		  AND SM.CODDEPOSITO = '100'
		  and (SM.CODART NOT LIKE '%DIP%' and SM.CODART NOT LIKE '%#%')
		  --AND (SM.CODART IN ('14801533'))
		  

--**********************************************************
--* VALORIZZAZIONI RETTIFICHE SECONDO UN LISTINO

SELECT     SM.CODART, SM.CODCAUSALE, CONVERT(VARCHAR, SM.DATAMOV, 105) AS DATAMV,  
			 SM.GIACENZA, convert(real,SM.QTA1UM) as QTA1,  
			SM.CODDEPOSITO, SM.ESERCIZIO,  BB.NRLISTINO,
		   CONVERT(MONEY, BB.PREZZOEURO, 1) AS PREZZOLISTINO
FROM       STORICOMAG SM
           left join listiniarticoli bb on sm.codart = bb.codart				-- ALLINEA LISTINIARTICOLI
WHERE     (SM.DATAMOV = '31/12/2010') 
		  AND (SM.CODCAUSALE IN (200,201))
		  AND SM.CODDEPOSITO = 'F755' 
		  --AND (SM.CODART IN ('14801533'))
		  AND BB.NRLISTINO = '111'


SELECT     sum(CONVERT(MONEY, BB.PREZZOEURO, 1)) AS PREZZOLISTINO
FROM       STORICOMAG SM
           left join listiniarticoli bb on sm.codart = bb.codart				-- ALLINEA LISTINIARTICOLI
WHERE     (SM.DATAMOV = '31/12/2010') 
		  AND (SM.CODCAUSALE IN (201))
		  AND SM.CODDEPOSITO = '100' 
		  --AND (SM.CODART IN ('14801533'))
		  AND BB.NRLISTINO = '111'


--**********************************************************
--* INDIVIDUA I CODICI 
--* CHE HANNO UN INDICE DI REVISIONE (secondo la vecchia metodologia)
--* E SONO CONTENUTI IN UNA DISTINTA
--* (Se sono contenuti in una distinta restituisce il codice stesso, 
--*	non quello della distinta, nella colonna DB)
--* IMERIO 12/05/2011
--*********************************************************

-- parte dai codici base (7 caratteri)
select AA.codice as codice_base, DB.CODARTCOMPONENTE AS DB, CONVERT(VARCHAR, EM.DATACREAZIONE, 105) AS DATA_CREAZIONE, EM.UTENTECREAZIONE
from anagraficaarticoli AA
LEFT JOIN DISTINTABASE DB ON AA.CODICE = DB.CODARTCOMPONENTE
left join EXTRAMAG EM ON EM.CODART = AA.CODICE 
where len(AA.codice)=7
and AA.codice in (select left(codice,7) from anagraficaarticoli where len(codice)=8) -- CONSIDERA SOLO I CODICI CHE SONO STATI REVISIONATI
and AA.codice > '1001000'
AND EM.DATACREAZIONE >= '01/06/2011'
group by aa.codice,DB.CODARTCOMPONENTE, EM.DATACREAZIONE, EM.UTENTECREAZIONE

-- ... e poi tutte le revisioni (codici a 8 caratteri)
select AA.codice as codice_base, DB.CODARTCOMPONENTE AS DB, CONVERT(VARCHAR, EM.DATACREAZIONE, 105) AS DATA_CREAZIONE, EM.UTENTECREAZIONE 
from anagraficaarticoli AA
left JOIN DISTINTABASE DB ON AA.CODICE = DB.CODARTCOMPONENTE
left join EXTRAMAG EM ON EM.CODART = AA.CODICE
where len(AA.codice)=8
and AA.codice > '1001000'
AND DATACREAZIONE >= '01/06/2011'
group by aa.codice, DB.CODARTCOMPONENTE, EM.DATACREAZIONE, EM.UTENTECREAZIONE




--*****************************************
--*	ESTRAZIONE CODICI DI NUOVA CREAZIONE
--*
--*	IMERIO 05/07/2011
--*****************************************
set dateformat dmy
select em.codart, aa.descrizione, em.revisione, ap.fornprefacq, em.codpianificatore, ap.tapprontacq, ap.tapprontprod,
em.utentecreazione, convert(varchar, em.datacreazione,105) as data_crea, em.disegno,
aa.nomenclcombinata1, aa.nomenclcombinata2, 
ac.scgenvenditeita, ac.scgenvenditeest, ac.scgenacquistiita, ac.scgenacquistiest 
from extramag em
right join anagraficaarticoli aa on em.codart = aa.codice
left join anagraficaarticolicomm ac on aa.codice =ac.codiceart
left join anagraficaarticoliprod ap on aa.codice = ap.codiceart
where utentecreazione is not null 
and (codart > '1000000' and codart < '9999999') and datacreazione is not null
and datacreazione >= '01/11/2012' and datacreazione<= '30/11/2012'
and ap.esercizio = '2012'
order by codart, datacreazione



--*****************************************
--*	NUMERO CODICI DI NUOVA CREAZIONE
--*	LEN = 7 CODICI NUOVI - LEN = 8 NUOVE REVISIONI
--*	IMERIO 05/07/2011
--*****************************************

select count(1)
from extramag
where utentecreazione is not null
--AND LEN (codart)= 7
and (codart > '1000000' and codart < '9999999') and datacreazione is not null
and datacreazione >= '01/01/2015'
and revisione >0



-- *********************************************
--*           CANCELLA DA PIANIFICAZIONE
-- * Cancella i records delle pianificazioni (ed eventualmente
-- * dello storicoprezzi) relativi ad un dato articolo.
-- * Da usare qualora si voglia eliminare un articolo e ciò non sia
-- * possibile in quanto presente in RISULTATI ELABORAZIONE PIANIFICAZIONE
--* o in TABELLA STORICO PREZZI (messaggi di Metodo)

--DELETE progproduzione where codart = '70569201'

--DELETE storicoprezziarticolo where codarticolo = '70569201'





--************************************************
--* AGGIORNA UBICAZIONE ARTICOLI
--*
--* IMERIO 06/03/2014
--***********************************************

SELECT * FROM UBICAZIONIARTICOLI
WHERE CODDEPOSITO = 100 AND CODUBICAZIONE = 'F03'

--update ubicazioniarticoli set codubicazione = 'G325'
--WHERE CODUBICAZIONE = 'G095' AND CODDEPOSITO = 100


--************************************************
--* NUMERO MOVIMENTI CODICI IN CERTE UBICAZIONI
--*
--* IMERIO 19/07/2014
--***********************************************
select codiceart, ua.codubicazione, count (codart) as nrmov
from ubicazioniarticoli ua
left join storicomag sm on ua.codiceart = sm.codart
where 
		sm.coddeposito = '100' 
		and datamov > '01/01/2015'
		and codcausale not in (501, 90, 200, 201)
		and (ua.codubicazione >='E000' and ua.codubicazione <='E804')
group by codiceart, ua.codubicazione
order by nrmov desc


-- *************************************************************************************************
--          SVUOTA CASSETTINE MAGAZZINO
--              IMERIO FEBBRAIO 2014
--
-- seleziona tutti gli articoli che:
-- A) non hanno movimenti successivi ad una certa data
-- B) non hanno impegni nè ordini in corso
-- C) hanno una ubicazione a magazzino 100
--  Nota: si escludono in ogni caso i movimenti aventi
-- causali 501 = carico iniziale, 90 = ripresa valore, 200 = rettifica positiva e 201 = rettifica negativa
--
-- 1) datamov = 3 mesi prima della data attuale
-- 2) lanciare la query (con vg.ordinato = 0 and impegnato = 0) per trovare i codici non impegnati e non ordinati
-- 3) lanciare un inventario e incrociare (in excel) le giacenze con l'analisi 2 per eliminare le ubicazioni dove comunque c'è della giacenza
-- **************************************************************************************************
set dateformat dmy
select convert(varchar, aa.codice) as cod, aa.descrizione, ua.codubicazione --, vg.ordinato, vg.impegnato, vg.carico, vg.scarico,vg.esercizio 
from anagraficaarticoli aa
left join vistagiacenzetot vg on vg.codart = aa.codice
left join ubicazioniarticoli ua on ua.codiceart = aa.codice
where 
		-- considera solo i codici che non hanno subito movimenti dopo una certa data
		codice not in (select codart from storicomag where (datamov > '01/03/2017' and coddeposito = '100' and codcausale not in (501, 90, 200, 201))) 
		-- considera quelli che non hanno ordini nè impegni (per la giacenza fare un confronto con un inventario)
		and (vg.ordinato = 0 and impegnato = 0)
		and ua.coddeposito = 100 AND UA.CODUBICAZIONE <>''
		and codice NOT LIKE '%DIP%' and codice NOT LIKE '%#%'
		and aa.coddeposito = '100'
		and vg.esercizio > 2008
group by codice, descrizione, ua.codubicazione
order by codice --codubicazione

-- ** SE SERVE CANCELLARE LE UBICAZIONI DA UNA LISTA DI CODICI RESTITUITI DA RASCHIETTI CARICARE LA LISTA NELLA TABELLA xxxxSvuotaCassettine E LANCIARE IL SEGUENTE COMANDO
-- ** (VERIFICARE CHE I CODICI IN EXCEL ABBIANO COME NOME COLONNA "COD")
--DELETE ubicazioniarticoli where codiceart in (select codice from BRECEA.dbo.xxxxSvuotaCassettine) and coddeposito = 100

-- CANCELLARE TUTTI GLI ARTICOLI CONTENUTI IN UNA CERTA UBICAZIONE E CANCELLARE POI ANCHE L'UBICAZIONE STESSA
--delete ubicazioniarticoli where coddeposito = 100 and codubicazione = '0004'
--delete tabubicazionidepositi where coddeposito = 100 and codubicazione = '0004'



--************************************************
--* CREAZIONE NUOVO LISTINO E
--* INSERIMENTO NUOVA RIGA LISTINO IN TUTTI GLI ARTICOLI
--* QUANDO UN FORNITORE CAMBIA RAGIONE SOCIALE
--* IMERIO 02/04/2015
--*************************************************


--DECLARE @NUOVOLISTINO VARCHAR(5)
--DECLARE @VECCHIOLISTINO VARCHAR(5)
--SET @NUOVOLISTINO='11345'
--SET @VECCHIOLISTINO='10269'

----*CREAZIONE NUOVO LISTINO
--insert into  TABLISTINI (NRLISTINO,DESCRIZIONE,CODCAMBIO,VINCOLAUM,UTENTEMODIFICA,DATAMODIFICA,TP_Tipo,TP_Scorporo,FLGCOSTISTD)
--SELECT @NUOVOLISTINO,DESCRIZIONE,CODCAMBIO,VINCOLAUM,'update',getdate(),TP_Tipo,TP_Scorporo,FLGCOSTISTD
--  FROM TABLISTINI where nrlistino = @VECCHIOLISTINO

----* INSERIMENTO RIGA NUOVO LISTINO PER OGNI ARTICOLO COPIANDO I DATI DAL VECCHIO LISTINO
--Insert Into listiniarticoli (CODART,NRLISTINO,UM,PREZZO,PREZZOEURO,UTENTEMODIFICA,DATAMODIFICA,DeltaIncremento,TP_CodConto,
--      TP_ConsPP,TP_PrezzoPart,TP_PrezzoPartEuro,TP_Scorporo,TP_Sconti,TP_QTASCONTO,TP_QTACOEFF,TP_QTAMO,TP_Abbuono,TP_DataCambio,
--      TP_ValoreCambio,DATAVALIDITA,TP_FormulaSct,PREZZOCALC,TP_ABBUONOEURO)
--select CODART,@NUOVOLISTINO,UM,PREZZO,PREZZOEURO,'update',getdate(),DeltaIncremento,TP_CodConto,
--      TP_ConsPP,TP_PrezzoPart,TP_PrezzoPartEuro,TP_Scorporo,TP_Sconti,TP_QTASCONTO,TP_QTACOEFF,TP_QTAMO,TP_Abbuono,TP_DataCambio,
--      TP_ValoreCambio,DATAVALIDITA,TP_FormulaSct,PREZZOCALC,TP_ABBUONOEURO
--	  from listiniarticoli where nrlistino = @VECCHIOLISTINO


--*************************************************
--* NR PRELIEVI EFFETTUATI E NR PEZZI PRELEVATI
--* IN UN DATO MAGAZZINO DA UNA CERTA DATA
--* RICHIESTA DA GIULIANO
--* IMERIO 02/10/2015
--************************************************


select COUNT(1)
--codart, codcausale, convert(varchar, datamov, 103) as datamovimento, coddeposito, convert(real, qta1um) as qta
from storicomag 
where codcausale in (123,138,125,5)		-- 5=scarico per CdC, 123=prelievo per produzione interna, 125=scarico per consegna in c/lavoro, 138=scarico per consegna in c/installazione
and datamov > '2015-12-31' 
and CODDEPOSITO = '100'
--and codclifor NOT in ('F   636', 'F   316')	--esamina i prelievi per Pesama e Mecatronica

select sum(convert(real, qta1um)) as qta
from storicomag 
where codcausale in (123,138,125,5) 
and datamov > '2015-12-31' 
and CODDEPOSITO = '100'
--and codclifor NOT in ('F   636', 'F   316')
and codart not in (select codart		-- elimina dal conteggio del nr pezzi i prelievi in metri o litri (numeri decimali)
		from storicomag 
		where codcausale in (123,138,125,5) 
		and datamov > '2015-12-31' 
		and CODDEPOSITO = '100' 
		and ((qta1um- round(qta1um,0))*100 <> 0))


--******************************************************************
--* CONFRONTO TRA QUANTITA' IN ACCORDI QUADRO E QUANTITA' ACQUISTATE
--* IMERIO 22/10/2015

select RD.CODART, RD.DESCRIZIONEART, CONVERT (REAL, SUM(RD.QTAGEST)) AS TOTQTAAQF, CONVERT (REAL, SUM(RD2.QTAGEST)) AS TOTQTAACQ, convert(varchar, max(rd2.dataconsegna), 103) as dataultimaconsegna
from righedocumenti RD
LEFT JOIN RIGHEDOCUMENTI RD2 ON RD.CODART=RD2.CODART
where RD.tipodoc = 'AQF' AND RD2.TIPODOC = 'OFA'
AND RD.CODART <>'' 
GROUP BY RD.CODART, RD.DESCRIZIONEART
ORDER BY RD.CODART

--* MOVIMENTI DI SCARICO A MAGAZZINO 100 DI CODICI INTERESSATI DA ACCORDI QUADRO
select sm.CODART, CONVERT (REAL, SUM(SM.QTA1UM)) AS TOTQTAMOV, convert(varchar, MIN(DATAMOV), 103) as dataprimomov, convert(varchar, MAX(DATAMOV), 103) as dataultimomov
from STORICOMAG SM
INNER JOIN righedocumenti RD ON SM.CODART = RD.CODART
where RD.tipodoc = 'AQF' AND RD.CODART <>''
--AND RD.CODART ='73620019' 
AND (GIACENZA =-1 AND SM.CODDEPOSITO = '100')
GROUP BY SM.CODART
ORDER BY SM.CODART




--**************************************************************
--* ALLINEAMENTO QTA MOV RIPR VALORE CON GIACENZA REALE AL 01/01/2016
--* IMERIO 26/01/2016
--* NOTA: la select è stata fatta partendo dalla MET_VISTAGIACENZETOT
--*

--* Verifica giacenze al 31/12/2015
SELECT        STMAG.CODART, convert(real,SUM(CASE WHEN STMAG.GIACENZA = 1 THEN STMAG.QTA1UM ELSE 0 END)) AS CARICO, 
						    convert(real, SUM(CASE WHEN STMAG.GIACENZA = - 1 THEN STMAG.QTA1UM ELSE 0 END)) AS SCARICO, 
						    convert(real,(SUM(CASE WHEN STMAG.GIACENZA = 1 THEN STMAG.QTA1UM ELSE 0 END) - SUM(CASE WHEN STMAG.GIACENZA = - 1 THEN STMAG.QTA1UM ELSE 0 END))) as giac
FROM            dbo.STORICOMAG AS STMAG INNER JOIN
                         dbo.ANAGRAFICADEPOSITI AS AD ON STMAG.CODDEPOSITO = AD.CODICE AND AD.DISPONIBILE = 1
						 where datamov < '2016-01-01' and codart > '100000'
						 --and (select (SUM(CASE WHEN STMAG.GIACENZA = 1 AND STMAG.RESO = 0 THEN STMAG.QTA1UM ELSE 0 END) - SUM(CASE WHEN STMAG.GIACENZA = - 1 AND 
                         --STMAG.RESO = 0 THEN STMAG.QTA1UM ELSE 0 END)) FROM dbo.STORICOMAG AS STMAG )>0
GROUP BY STMAG.CODART
order by codart

--* estrazione Movimenti Ripresa Valore
select codart, convert(real,QTA1UM) as qta from storicomag where codcausale = 90 and datamov = '2016-01-01 00:00:00.000' order by codart

--* confronto dati con file excel
select gi.codice, convert(real,QTA1UM) as qtaMRV, qta as qtanew, convert(money,IMPORTOTOTLORDO) as tot_lire, imp1_totlordo,
       convert (money,IMPORTOTOTLORDOVAL) as tot_euro, imp1_totlordoval
  from storicomag sm
  inner join zzzGiacenze_inizio_2016 gi on gi.codice = sm.codart 
  where codcausale = 90 and datamov = '2016-01-01 00:00:00.000' order by gi.codice

  --begin tran
  --update sm set qta1um=QTA, qta2um=QTA, importototlordo=imp1_totlordo, importototnetto=imp1_totlordo, importototlordoval=imp1_totlordoval,
  --importototlordoeuro=imp1_totlordoval, importototnettoval=imp1_totlordoval, importototnettoeuro=imp1_totlordoval, utentemodifica='excel',
  --riferimenti='qtà allineate con inventario'
  --from storicomag sm
  --inner join zzzGiacenze_inizio_2016 gi on gi.codice = sm.codart 
  --where codcausale = 90 and datamov = '2016-01-01 00:00:00.000'
  --commit tran


--* cancellazione movimenti con qta = 0
  select * from storicomag where codcausale = 90 and datamov = '2016-01-01 00:00:00.000' and qta1um = 0
  --delete storicomag where codcausale = 90 and datamov = '2016-01-01 00:00:00.000' and qta1um = 0
