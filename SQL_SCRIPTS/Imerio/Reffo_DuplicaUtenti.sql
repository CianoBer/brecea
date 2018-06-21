-- crea un nuovo utente (già creato in Metodo e in SQL con l'apposita query)
-- clonando il profilo di un utente esistente
-- Attenzione: una volta clonato l'utente nuovo lanciare lo script "AggancioAgenti.sql"

DECLARE @NUOVOUTENTE VARCHAR(20)
DECLARE @VECCHIOUTENTE VARCHAR(20)
SET @NUOVOUTENTE='l.zanotto'
SET @VECCHIOUTENTE='f.rossato'

--cancellazione accessi per NUOVOUTENTE
delete from accessidocumenti where nomeutente=@NUOVOUTENTE
delete from accessicauscont where nomeutente=@NUOVOUTENTE
delete from ACCESSICAUSMAG where nomeutente=@NUOVOUTENTE
delete from ACCESSICOMMESSEPROD where nomeutente=@NUOVOUTENTE
delete from ACCESSILISTECONS where nomeutente=@NUOVOUTENTE
delete from ACCESSILISTEMOV where nomeutente=@NUOVOUTENTE
delete from ACCESSILISTETRASF where nomeutente=@NUOVOUTENTE
delete from ACCESSIFORM where codutente=@NUOVOUTENTE
delete from TABACCESSIUTENTE where codutente=@NUOVOUTENTE


-- Duplicazione accessi documenti
insert into accessidocumenti select coddocumento, @NUOVOUTENTE, tiporighe, tipopiede, flagabilita, utentemodifica, datamodifica, persrighedoc, flagvisualizza, flagpreleva
from accessidocumenti where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi causalicontabili
insert into accessicauscont select codcausale, @NUOVOUTENTE, flagabilita, utentemodifica, datamodifica, flagvisualizza
from accessicauscont where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi magazzino
INSERT INTO ACCESSICAUSMAG SELECT codcaumag, @NUOVOUTENTE, flagvisualizza, utentemodifica, datamodifica
from ACCESSICAUSMAG where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi commesse prod
INSERT INTO ACCESSICOMMESSEPROD SELECT codcommessa, @NUOVOUTENTE, tiporigheord,tiporigheimp,tipopiede,flagabilita, utentemodifica, datamodifica
from ACCESSICOMMESSEPROD where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi listecons
insert into ACCESSILISTECONS select codlista, @NUOVOUTENTE, tiporighe, flagabilita, utentemodifica, datamodifica
from ACCESSILISTECONS where nomeutente=@VECCHIOUTENTE

-- Duplicazione accessi listemov
INSERT INTO ACCESSILISTEMOV SELECT codlista, @NUOVOUTENTE, tiporigheord,tiporigheimp,tipopiede,flagabilita, utentemodifica, datamodifica
from ACCESSILISTEMOV where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi listetrasf
insert into ACCESSILISTETRASF select codlista, @NUOVOUTENTE, tiporighe, flagabilita, utentemodifica, datamodifica
from ACCESSILISTETRASF where nomeutente=@VECCHIOUTENTE
-- Duplicazione accessi form
INSERT INTO ACCESSIFORM SELECT @NUOVOUTENTE, helpid, tipoaccesso, utentemodifica, datamodifica
from ACCESSIFORM where codutente=@VECCHIOUTENTE
-- Duplicazione accessi utente
INSERT INTO TABACCESSIUTENTE SELECT @NUOVOUTENTE, helpid, indicescheda, tipoaccesso, utentemodifica, datamodifica
from tabaccessiutente where codutente=@VECCHIOUTENTE
