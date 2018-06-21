--	 CONTROLLO ARTICOLI SENZA PIANIFICATORE

select EM.CODART, AA.DESCRIZIONE, EM.CODPIANIFICATORE, AA.AGGIORNAMAG
from EXTRAMAG EM 
inner join ANAGRAFICAARTICOLI AA ON AA.CODICE = EM.CODART
where 
EM.CODPIANIFICATORE=0
AND AA.AGGIORNAMAG = 1 -- codici che movimentano magazzino
AND (EM.CODART NOT LIKE '00%' and EM.CODART NOT LIKE 'dip%')
--((EM.CODART >= '1001000' and EM.CODART <= '9860115')
--OR (EM.CODART >= 'C002540' and EM.CODART <= 'Z80008'))
ORDER BY EM.CODART ASC


-- CONTROLLA SE UN CODICE
-- OPZ A) HA UN CODICE ALTERNATIVO MA E' PRIVO DEL FLAG IN "esaurito" E 'in esaurimento'
-- OPZ B) HA IL FLAG IN "esaurito" O 'in esaurimento' MA NON HA CODICE ALTERNATIVO


select AA.codice as codice_base, aa.descrizione, AP.ARTALTERNATIVO, CONVERT(VARCHAR, AC.DATAMODIFICA, 105) AS DATA_MODIFICAFLAG, AC.UTENTEMODIFICA AS UTENTE_INSERITOFLAG,
utentecreazione, datacreazione
from anagraficaarticoli AA
left join ANAGRAFICAARTICOLIPROD AP ON AP.CODICEART = AA.CODICE
left join EXTRAMAG EM ON EM.CODART = AA.CODICE
LEFT JOIN Anagraficaarticolicomm ac on aa.codice = ac.codiceart
where AA.codice > '1001000' and len(aa.codice)<9
and AC.esercizio = year(getdate()) AND AP.esercizio = year(getdate())
--AND AC.DATAMODIFICA > '01/01/2015'
-- OPZ A)
AND (AP.ARTALTERNATIVO <>'') and esaurito=0 and inesaurimento=0
-- OPZ B)
--AND (AP.ARTALTERNATIVO ='' OR AP.ARTALTERNATIVO IS NULL) and (ac.esaurito=1) --or ac.inesaurimento=1)
ORDER BY AC.DATAMODIFICA


--update ANAGRAFICAARTICOLIPROD set ANAGRAFICAARTICOLIPROD.ARTALTERNATIVO='ART_ALTERNATIVO_NULLO', ANAGRAFICAARTICOLIPROD.DATAMODIFICA = '2016-07-07', ANAGRAFICAARTICOLIPROD.UTENTEMODIFICA = 'admin' 
--from ANAGRAFICAARTICOLIPROD ap
--inner join Anagraficaarticolicomm ac on ap.codiceart = ac.codiceart
--and AC.esercizio = year(getdate()) AND AP.esercizio = year(getdate())
--AND (AP.ARTALTERNATIVO ='' OR AP.ARTALTERNATIVO IS NULL) and (ac.esaurito=1)



--*******************************************************
--* controlla che non vengano usati come codici alternativi
--* lo stesso articolo o un articolo già associato come 
--* alternativo ad un livello precedente
--* Verificare i codici che mostrano un nr di livelli
--* (=nr iterazioni) maggiore di 10
--* (connettersi come TRM150)
--*
--*		REFFO 13/09/2011
--*******************************************************

select * from MET_TROVAALTERNATIVO 
where livello > 10
order by livello desc



-- CONTROLLA SE UN CODICE HA IL FLAG ESAURITO
-- MA E' ANCORA PRESENTE IN DISTINTE BASI
-- P.S. UAC FA M24 E LO INVIA A SARTOR
-- REBELLATO 27/09/2013

select AA.codice as codice_base, aa.descrizione, AP.ARTALTERNATIVO, CONVERT(VARCHAR, AC.DATAMODIFICA, 105) AS DATA_MODIFICAFLAG, AC.UTENTEMODIFICA AS UTENTE_INSERITOFLAG,
utentecreazione, convert(varchar,datacreazione, 105) as data_creazione
from anagraficaarticoli AA
left join ANAGRAFICAARTICOLIPROD AP ON AP.CODICEART = AA.CODICE
LEFT JOIN Anagraficaarticolicomm ac on aa.codice = ac.codiceart
left join EXTRAMAG EM ON EM.CODART = AA.CODICE
where AA.codice > '1001000'
and (AC.esercizio = year(getdate()) AND AP.esercizio = year(getdate()))
and (ap.artalternativo = '' or ap.artalternativo is null)
and ac.esaurito = 1 and aa.codice in (select codartcomponente from distintabase)
ORDER BY AC.DATAMODIFICA



-- CONTROLLA SE STA FUNZIONANDO L'AGENTE CHE
-- SBIANCA TUTTE LE UBICAZIONI IN STORICOMAG.
-- QUESTO ASSICURA CHE GLI INVENTARI FUNZIONINO
-- CORRETTAMENTE E NON CONSIDERINO CARICHI E 
-- SCARICHI PER UBICAZIONE
-- REFFO 20/01/2015

select * FROM STORICOMAG WHERE CODUBICAZIONE<>''


--***********************************************
--* VERIFICA ARTICOLI DI PRODUZIONE (PROVENIENZA = 1)
--* SEMILAVORATI (TIPOPRODOTTO = 1) CON TEMPO DI 
--* APPRONTAMENTO A ZERO O NULL
--* 
--* EVENTUALE UPDATE PER PORTARE TEMPO APPRONTAMENTO PARI A 1
--* PER VERIFICARE MODIFICA DATE PROPOSTE DA PIANIFICAZIONE
--* PER EMISSIONE ORDINI A FORNITORE EVITANDO IL TEMPO
--* DI DEFAULT (10GG) PROPOSTI DALLA PIANIFICAZIONE
--* (DA 02/16 NON SERVE PIU' IN QUANTO E' STATO IMPOSTATO
--*  IN PIANIFICAZIONE TEMPO APPRONTAMENTO = 1)
--*
--*	IMERIO 30/09/2015
--**********************************************

select codiceart, provenienza, tipoprodotto, TAPPRONTPROD, utentemodifica, convert (varchar, datamodifica, 103) as data_mod
from anagraficaarticoliprod
where esercizio = 2016 and codiceart like '1%' 
and  provenienza = 1 
and TIPOPROdotto = 1 
--and TAPPRONTPROD = 1
and (TAPPRONTPROD = 0 or TAPPRONTPROD is null)


--begin tran
--update ANAGRAFICAARTICOLIPROD
-- set TAPPRONTPROD = 1
--where 
--  esercizio = 2016 and codiceart like '1%' 
--  and  provenienza = 1 
--  and TIPOPROdotto = 1 
--  and (TAPPRONTPROD = 0 or TAPPRONTPROD is null)
--  commit tran