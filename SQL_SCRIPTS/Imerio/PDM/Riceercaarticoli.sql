select aa.codice, aa.descrizione, au.um, em.utentecreazione, em.datacreazione, em.codpianificatore, ap.provenienza
from anagraficaarticoli aa
inner join extramag em on aa.codice = em.codart
inner join articoliumpreferite au on aa.codice = au.codart
inner join ANAGRAFICAARTICOLIPROD ap on aa.CODICE = ap.codiceart
where tipoum = 1
and ap.esercizio = 2012
and em.codpianificatore in (1,2)