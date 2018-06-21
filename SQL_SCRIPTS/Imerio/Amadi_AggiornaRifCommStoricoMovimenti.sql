--************************************************
--* query per aggiornare il riferimento commessa 
--* nelle sessioni di movimentazione della CAM
--* Successivamente lanciare aggiornamento movimenti di magazzino
--* AMADI 16/02/2012
--*************************************************



-- A) Qui trovo il riferimento dell’Ordine di produzione (IDTESTA e IDRIGA) da inserire nel successivo Update
select * 
from righeordprod 
where rifcommcli = 'BM015-A02' and codiceord = 'OAM'

-- B) Aggiorno storicomovordprod con il Riferimento Commessa
--begin tran
--update storicomovordprod
--    set rifcommcli = 'BM015-A02' 
--    where 
--          riftesta = 10504 and rifriga = 1
--          and rifcommcli <> 'BM015-A02'  and rifcommcli = ''
--commit tran

-- C) Verifico che storicomovordprod sia a posto
select * from storicomovordprod
      where 
            riftesta = 10504 and rifriga = 1
            and rifcommcli <> 'BM015-A02'  and rifcommcli = ''


-- D) aggiorno storicomovimpprod
--begin tran
--update storicomovimpprod
--    set rifcommcli = 'BM015-A02'
--    where 
--          riftesta = 10504 and rifriga = 1
--          and rifcommcli <> 'BM015-A02' and rifcommcli = ''
--commit tran

select * from storicomovimpprod
      where 
            riftesta = 10504 and rifriga = 1
            and rifcommcli <> 'BM015-A02' and rifcommcli = ''

 

