-- *****************************************************
--* AGGIUNTA DELL'UNITA' DI MISURA NR IN TUTTI GLI ARTICOLI
--* OPERAZIONE EFFETTUATA PER SEMPLIFICARE IMPORT DA iDOCK
--* BERLANDA 13/07/2017
--* ocio che con begin transaction fai un lock sulla tabelle...
--* non dimenticare di fare il commit o il roolback alla fine
--******************************************************
 
BEGIN TRANSACTION;
WITH cte AS (
SELECT A.CODART FROM dbo.ARTICOLIUNITAMISURA AS A
WHERE um='N.'
EXCEPT
SELECT A.CODART FROM dbo.ARTICOLIUNITAMISURA AS A
WHERE um='NR'
)
SELECT * INTO _tmpum_ FROM cte;
 
INSERT INTO ARTICOLIUNITAMISURA ( CODART, UM,  UtenteModifica, DataModifica ) 
       SELECT CODART, 'NR', 'QueryUM', GETDATE() FROM _tmpum_;
INSERT INTO dbo.ARTICOLIFATTORICONVERSIONE (CODART ,UM1 ,UM2 ,FORMULAFC ,FATTORE ,UTENTEMODIFICA ,DATAMODIFICA)
       SELECT CODART, 'N.', 'NR', '1', 1, 'QueryUM', GETDATE() FROM _tmpum_;
INSERT INTO dbo.ARTICOLIFATTORICONVERSIONE (CODART ,UM1 ,UM2 ,FORMULAFC ,FATTORE ,UTENTEMODIFICA ,DATAMODIFICA)
       SELECT CODART, 'NR', 'N.', '1', 1, 'QueryUM', GETDATE() FROM _tmpum_;
INSERT INTO dbo.ARTICOLIFATTORICONVERSIONE (CODART ,UM1 ,UM2 ,FORMULAFC ,FATTORE ,UTENTEMODIFICA ,DATAMODIFICA)
       SELECT CODART, 'NR', 'NR', '1', 1, 'QueryUM', GETDATE() FROM _tmpum_;
COMMIT TRANSACTION;
 
-- se vuoi cancella la tabella temporanea con la lista degli articoli aggiornati
--DROP TABLE _tmpum_;
 
-- se tutto ok lancia il seguente comando e le modifiche verranno consolidate nel db
-- COMMIT TRANSACTION;
 
-- altrimenti se le query ti hanno dato errore di chiave duplicata ecc. torna indietro senza nessuna modifica al db
-- ROLLBACK TRANSACTION
 
-- se vuoi cancellare i record inseriti perchè ti sei pentito:
-- DELETE FROM dbo.ARTICOLIUNITAMISURA WHERE UTENTEMODIFICA='QueryUM';
-- DELETE FROM dbo.ARTICOLIFATTORICONVERSIONE WHERE UTENTEMODIFICA='QueryUM';
 