-- controllo tipo accessi in CAUSALI CONTABILI

SELECT aa.CODICECAUSALE, aa.DESCRIZIONE, bb.NOMEUTENTE, bb.FLAGABILITA, bb.FLAGVISUALIZZA 
FROM CAUSALICONTABILI aa, accessicauscont bb
WHERE aa.CODICECAUSALE = bb.CODCAUsALE and NOMEUTENTE ='s.fontana' and flagabilita = 1