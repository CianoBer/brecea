--*************************************************
--* REGISTRAZIONI CONTABILI SU FOGLI VIAGGIO TECNICI
--* passare mensilmente a Elisa per confronto
--* con costi a forfait preventivati per i FVA
--* 
--* note: i dati estratti sono ordinati per commessa.
--* Le spese aeree vengono registrate x commessa
--* e non riportano quindi l'indicazione del FV.
--* Le spese di vito e alloggio (e carta carburante
--* se estero) vengono registrate con voce unica
--*  (SPESE) a carico dei singoli tecnici
--*
--*				IMERIO OTTOBRE 2011
--**************************************************
set dateformat dmy

select RC.ESERCIZIO, CONVERT(VARCHAR, RC.DATAREG, 105) AS DATA_REG, CONTO, DSCCONTO1 AS DESCR_CONTO, CONVERT(MONEY,IMPORTOEURO)AS IMPORTO, 
DESCRIZIONE, RC.CODCOMMESSA, NRREG, RC.segno
from righecontabilita RC
LEFT JOIN ANAGRAFICAGENERICI AG ON CODCONTO = CONTO
where 
--SEGNO = '0'		-- considera solo le voci DARE (cioè le spese da sostenere)
CONTO IN ('G   227', 'G   208', 'G   212', 'G   153', 'G   323', 'G   265')  --G153 = CONTO PER CONSULENTI ESTERNI (V. CARRARO), G265 RICAVI
and RC.DATAREG>='01/01/2016' AND RC.DATAREG <= '31/05/2016'
--esercizio = '2011' 
--and codcommessa = 'Y0829-P01'
--and (RC.codcommessa LIKE '%-I0%' OR RC.CODCOMMESSA LIKE '%-F0%' OR RC.CODCOMMESSA LIKE '%-G0%' OR RC.CODCOMMESSA LIKE '%-A0%')
AND CODCOMMESSA <>''
ORDER BY RC.CODCOMMESSA, RC.DATAREG

-- qui di seguito le stesse spese prelevate però dai Movimenti per CdC
set dateformat dmy
SELECT ANNO, CONVERT(VARCHAR,DATAREG,105) DATA_REG, CODGENERICO, CODCONTOCC, DESCRIZIONE, CONVERT(REAL,IMPORTORIPEURO) AS COSTI,CODCOMMESSA, IDRIFERIMENTO AS NRREG, SEGNO
FROM MOVIMENTICDC 
inner join tabcentricosto on codice = CODCONTOCC
WHERE 
CODGENERICO IN ('G   227', 'G   208', 'G   212', 'G   153', 'G   323', 'G   265')
and DATAREG>='01/01/2016' AND DATAREG <= '31/05/2016'
AND CODCOMMESSA <> ''
ORDER BY CODCOMMESSA, DATAREG




 --************************************************
--* ESTRAZIONE DA RIGHE DOCUMENTI DATI FV COMMERCIALI
--* PER CUDIFERRO
--* REBELLATO 11/01/2013
--************************************************select esercizio, tipodoc, numerodoc, posizione, descrizioneart, umgest, CONVERT(INT,qtagest) AS QTA,
CONVERT(MONEY,prezzounitlordoeuro) AS IMPORTOUNIT, codiva, CONVERT(MONEY,totlordorigaeuro) AS IMPORTTOT, 
convert(date, dataconsegna) as data, contocdc, meseiniziocomp, rifcommcli
 from righedocumenti where tipodoc = 'FVC'
 order by esercizio, numerodoc, posizione



--************************************************
--* COSTI SPEDIZIONI IN GARANZIA DA REGISTRAZIONI CONTABILI
--* PER CUDIFERRO
--* REBELLATO 27/06/2013
--************************************************
set dateformat dmy

select ESERCIZIO, CONVERT(VARCHAR, DATAREG, 105) AS DATA_REG, CONTO, DSCCONTO1 AS DESCR_CONTO, CONVERT(MONEY,IMPORTOEURO)AS IMPORTO, 
DESCRIZIONE, CODCOMMESSA, NRREG
from righecontabilita RC
LEFT JOIN ANAGRAFICAGENERICI AG ON CODCONTO = CONTO
where 
SEGNO = '0'		-- considera solo le voci DARE (cioè le spese da sostenere)
and CONTO IN ('G   172' )
and DATAREG>='01/01/2016' AND DATAREG <= '31/12/2016'
--esercizio = '2011' 
--and codcommessa = 'Y0829-P01'
and (CODCOMMESSA LIKE '%-G0%')
ORDER BY CODCOMMESSA, datareg


--****************************************
--* ESTRAZIONE ANNOTAZIONE ESTESA DA FVA
--* REBELLATO 11/09/2013
--* Nota: replace(replace(er.descrestesa, char(13),' '), char(10),'') elimina il CARRIAGE RETURN
--****************************************

select td.esercizio, td.tipodoc, td.numerodoc, rd. rifcommcli, er.nomemacchina, rd.descrizioneart, 
replace(replace(er.descrestesa, char(13),' '), char(10),'') as Note_estese
from testedocumenti td
inner join extrarighedoc er on er.idtesta = td.progressivo
inner join righedocumenti rd on td.progressivo = rd.idtesta
where td.tipodoc = 'FVA'
 and rd.idriga = er.idriga and descrestesa is not null
