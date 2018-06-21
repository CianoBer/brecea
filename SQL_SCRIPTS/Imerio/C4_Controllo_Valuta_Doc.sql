/*CONTROLLO VALORI DOCUMENTI 
GABRIELE 14/01/2010
CONNETTERSI A SQL CON UTENTE TRM22 PWD TERMINALE
VERIFICA SE ALLA CREAZIONE DEL DOCUMENTO ERA STATA UTILIZZATA LA
DIVISA CORRETTA (EURO ANZICHE' LIRE)*/

--CONTROLLO DIFFERENZE FRA VALORI DIVISA E VALORI EURO
SELECT CODCLIFOR, TOTNETTORIGA AS TNR, TOTNETTORIGAEURO AS TNRE,
       TOTNETTORIGAEURO*1936.27 AS CAMBIO, NUMERODOC, *

FROM VISTADOCUMENTIBASE 

WHERE (((VistaDocumentiBase.TIPODOC = 'OFA' 
	AND VistaDocumentiBase.ESERCIZIO =  2009 
	AND VistaDocumentiBase.NUMERODOC BETWEEN  0 AND  99999999 
	AND VistaDocumentiBase.BIS BETWEEN ' ' AND 'Z' 
	AND VistaDocumentiBase.DATADOC BETWEEN {d '2010-01-01'} AND {d '2100-12-31'} 
	AND VistaDocumentiBase.DATARIFDOC BETWEEN {d '2010-01-01'} AND {d '2100-12-31'} 
	AND VistaDocumentiBase.NUMRIFDOC BETWEEN '' AND 'ZZZZZZZZZZZZZZZ' )) 
	AND VistaDocumentiBase.CodCliFor BETWEEN 'F     1' AND 'F999999') 

	AND (TOTNETTORIGA<>TOTNETTORIGAEURO*1936.27)