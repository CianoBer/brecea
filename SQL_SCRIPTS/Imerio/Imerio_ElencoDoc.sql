--*********************************************************
--*	ELENCO TIPI DOCUMENTO CON CAUSALI MAGAZZINO ASSOCIATE *
--*            IMERIO NOV 2010                            *
--*********************************************************

select pd.codice, pd.descrizione, pd.tipo, pd.coddeposito, pd.causalemag, (select tc.descrizione from tabcausalimag tc where pd.causalemag = tc.codice) as causale,
       coddepositocoll, pd.causalemagcoll,(select tc.descrizione from tabcausalimag tc where pd.causalemagcoll = tc.codice) as causale2 
from parametridoc pd
where tipo = 'A'
order by codice