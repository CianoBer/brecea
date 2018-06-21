select * from articoliumpreferite where codart='7258001'
--update articoliumpreferite set um='N.' where codart='7258001'
select * from anagraficaarticoliprod where codiceart='7258001'
--update anagraficaarticoliprod set umlottoacq='N.', umlottoprod='N.', umlottolav='N.', umlottofabbricazione='N.' where codiceart='7258001'
select * from impegniordprod where codart='7258001'
select * from testeordiniprod where progressivo in (select idtesta from impegniordprod where codart='7258001')
--update impegniordprod set umgest='N.', umprezzo='N.', um1mag='N.', um2mag='N.', umscarto='N.' where codart='7258001'
select * from storicomovimpprod where codart='7258001'
--update storicomovimpprod set umgest='N.', umprezzo='N.', umscarto='N.', um1mag='N.', um2mag='N.' where codart='7258001'
select * from storicomag where codart='7258001'
select * from righedocumenti where codart='7258001'
select * from righeordprod where codart='7258001'
select * from distintabase where codartcomponente='7258001'
select * from distintaartcomposti where progressivo in (select rifprogressivo from distintabase where codartcomponente='7258001')
select * from storicoprezziarticolo where codarticolo='7258001'
--update storicoprezziarticolo set um='N.' where codarticolo='7258001'
select * from listamovimentictrlinv where articolo='7258001'
--update listamovimentictrlinv set um='N.' where articolo='7258001'
select * from gestioneprezzirighe where rifprogressivo in (select progressivo from gestioneprezzi where codart='7258001')
select * from gestioneprezzirighetrasf where rifprogressivo in (select progressivo from gestioneprezzitrasf where codart='7258001')
select * from relazionicfv where articolo='7258001'
select * from lifoarticoli where codiceart='7258001'
select * from listiniarticoli where codart='7258001'
--update listiniarticoli set um='N.' where codart='7258001'
select * from listiniarticolitrasf where codart='7258001'
select * from progproduzione where codart='7258001'
--update progproduzione set umdocumento='N.', umarticolo='N.' where codart='7258001'
select * from righeanalisiordprod
select * from testacicloordine where codciclo='7258001'
select * from testacicloprod where codciclo='7258001'
select * from righefoglicommcli
select * from righeforecast
select * from righelistamov where codart='7258001'
--update righelistamov set umgest='N.', umprezzo='N.', umscarto='N.', um1mag='N.', um2mag='N.' where codart='7258001'
select * from righelistatrasf where codart='7258001'
select * from righempp
select * from righemps
select * from righeprevcommcli
select * from storicoallestimenti
select * from storicoconsegne
select * from tabrighedocumentimiss where codart='7258001'
select * from ccbilanciomateriale where codart='7258001'
select * from ccbilancioconscostimateriale where codart='7258001'