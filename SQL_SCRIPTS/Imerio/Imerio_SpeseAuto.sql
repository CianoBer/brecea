--***********************************************
--* ESTRAZIONE SPESE AUTO X AMMINISTRAZIONE COMPLETA
--*         IMERIO 24/03/2011
--***********************************************

SELECT     NRREG, ESERCIZIO, NRRIGA, POSIZIONE, DATAREG, DATARIF, NRRIF, NRPARTITA, CONTO, SEGNO, CONVERT(MONEY, IMPORTOEURO) AS IMPORTO, 
           DESCRIZIONE, DATAVALUTA, CPARTITA, RIGACAUSALE, CODCOMMESSA
FROM         RIGHECONTABILITA rc
inner join anagraficacommesse ac on rc.codcommessa = ac.rifcomm
WHERE     
riferimento = 'amministrazione' -- estrae le targhe direttamente da Anagrafica Commesse
AND (ESERCIZIO = '2011')
ORDER BY CODCOMMESSA, CONTO


--***********************************************
--* ESTRAZIONE SPESE AUTO X AMMINISTRAZIONE SINTETICA
--*         IMERIO 24/03/2011
--* i dati vanno poi esportati in Excel e fatte le somme
--* per generico tramite una pivot 
--* (ATTENZIONE AI VALORI CON SEGNO=1 => NEGATIVO! Nell'Excel mettere il segno meno davanti al valore)
--***********************************************

SELECT     RESPONSABILECOMM AS TIPO, CODCOMMESSA AS TARGA, CONTO, SEGNO, CONVERT(MONEY, IMPORTOEURO) AS IMPORTO, DESCRIZIONE, 
           CONVERT(VARCHAR,DATAREG,105) AS DATAREGISTRAZIONE
FROM         RIGHECONTABILITA rc
inner join anagraficacommesse ac on rc.codcommessa = ac.rifcomm
WHERE     
riferimento = 'amministrazione' -- estrae le targhe direttamente da Anagrafica Commesse
AND (ESERCIZIO = '2016')
ORDER BY CODCOMMESSA, CONTO



--***********************************************
--* ESTRAZIONE SPESE AUTO SENZA RIFERIMENTO TARGA
--*         IMERIO 02/03/2012
--***********************************************
SELECT NRREG, ESERCIZIO, NRRIGA, POSIZIONE, DATAREG, DATARIF, NRRIF, NRPARTITA, CONTO, SEGNO, CONVERT(MONEY, IMPORTOEURO) AS IMPORTO, 
           DESCRIZIONE, DATAVALUTA, CPARTITA, RIGACAUSALE
FROM RIGHECONTABILITA 
WHERE CONTO IN ('G   222', 'G   223', 'G   224', 'G   225', 'G   226', 'G   228', 'G   322')     
AND (ESERCIZIO = '2011')
AND CODCOMMESSA = ''