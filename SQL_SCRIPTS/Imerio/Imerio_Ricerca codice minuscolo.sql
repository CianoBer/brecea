--******************************
--* dato un codice lo cerca in tutti i posti
--* possibili per vedere dove è stato scritto
--* in minuscolo
--* IMERIO 16/01/2014
--*******************************


select CODICE from ANAGRAFICAARTICOLI where CODICE = 'kj00218'
select CODICEART from DESCRARTICOLI where CODICEart = 'kj00218'
select CODICEART, BARCODESTRING from ANAGRAFICAARTICOLICOMM where CODICEart = 'kj00218'
select CODICEART from ANAGRAFICAARTICOLIPROD where CODICEart = 'kj00218'
select CODICEART,artalternativo from ANAGRAFICAARTICOLIPROD where artalternativo = 'kj00218'
select CODART from ARTICOLIUNITAMISURA where CODart = 'kj00218'
select CODART from ARTICOLIFATTORICONVERSIONE where CODart = 'kj00218'
select CODART from ARTICOLIUMPREFERITE where CODart = 'kj00218'
select CODART from EXTRAMAG where CODart = 'kj00218'
select CODARTCOMPONENTE from DISTINTABASE where CODartcomponente = 'kj00218'
select artcomposto from DISTINTAARTCOMPOSTI where artcomposto = 'kj00218'

select opt.esercizio, opt.tipocom, opt.numerocom, opt.statochiuso, opi.codart 
from impegniordprod opi
inner join testeordiniprod opt on opi.idtesta = opt.progressivo
where codart = 'kj00218'



 --update DESCRARTICOLI seT CODICEART= 'KJ00218' where CODICEart = 'kj00218'
 --update ANAGRAFICAARTICOLIPROD set CODICEART= 'KJ00218' where CODICEart = 'kj00218'
 --update ARTICOLIUNITAMISURA set CODART= 'KJ00218' where CODart = 'kj00218'
 --update ARTICOLIUMPREFERITE set CODART= 'KJ00218' where CODart = 'kj00218'
 --update EXTRAMAG set CODART= 'KJ00218' where CODart = 'kj00218'
 --update ANAGRAFICAARTICOLICOMM set BARCODESTRING = '*KJ00218*' where codiceart = 'kj00218' 