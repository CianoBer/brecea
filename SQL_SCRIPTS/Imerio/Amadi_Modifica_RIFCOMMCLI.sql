

-- BREVETTI CEA - MODIFICA RIFERIMENTO COMMESSA 
-- AMADI 12/06/2013
-- NOTA : limitarne l’utilizzo al minimo possibile, soprattutto 
-- perché lo script è destinato ad “invecchiare” con le nuove versioni


DECLARE @RIFCOMM_OLD AS VARCHAR(30)
DECLARE @RIFCOMM_NEW AS VARCHAR(30)

-- Impostare qui il vecchio riferimento e quello nuovo
SET @RIFCOMM_OLD = '00Y0315-R'
SET @RIFCOMM_NEW = 'Y0315-R'

-- Controllo che non sia stato eseguito il calcolo del consuntivo
--SELECT * FROM CCBILANCIOCONSCOSTIDIRDOC where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOCONSCOSTIDIRPN where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOCONSCOSTIMATERIALE where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOCONSLAVEST where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOCONSLAVINT where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOCONSLAVINTDOC where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
--SELECT * FROM CCBILANCIOMATERIALE where IDCOMMCLI = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)


-- Aggiornamento in tutte le tabelle usate

BEGIN TRAN
--UPDATE AnagraficaCommesse
--	SET RIFCOMM = @RIFCOMM_NEW
--	WHERE RIFCOMM = @RIFCOMM_OLD

UPDATE RIGHEDOCUMENTI
	SET RIFCOMMCLI = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE TESTEORDINIPROD
	SET RIFCOMMCLI = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE RIGHEORDPROD
	SET RifCommCli = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE IMPEGNIORDPROD
	SET RifCommCli = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE STORICOMOVORDPROD
	SET RifCommCli = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE STORICOMOVIMPPROD
	SET RifCommCli= @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE STORICOMAG
	SET CODCOMMESSA = @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD
	
UPDATE RIGHE_WIP
	SET RIFCOMM = @RIFCOMM_NEW
	WHERE RIFCOMM = @RIFCOMM_OLD

UPDATE RIGHELISTAMOV
	SET RIFCOMMCLI = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE RIGHELISTATRASF
	SET RIFCOMMCLI = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE PROGPRODUZIONE
	SET RIFCOMMCLI = @RIFCOMM_NEW
	WHERE RIFCOMMCLI = @RIFCOMM_OLD

UPDATE RIGHECONTABILITA
	SET CODCOMMESSA =  @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD

UPDATE MOVIMENTICDC
	SET CODCOMMESSA =  @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD

UPDATE  RIGHECONTABILITATF
	SET CODCOMMESSA =  @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD

UPDATE MOVIMENTICDCTF
	SET CODCOMMESSA =  @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD

UPDATE COMPETENZEPNTF
	SET CODCOMMESSA =  @RIFCOMM_NEW
	WHERE CODCOMMESSA = @RIFCOMM_OLD

UPDATE CommesseCollegate
	SET RifProgressivo = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
	WHERE RifProgressivo= (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)

UPDATE CommesseCollegate
	SET ProgressivoCommColl = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)
	WHERE ProgressivoCommColl = (SELECT PROGRESSIVO FROM AnagraficaCommesse WHERE RifComm =  @RIFCOMM_OLD)

UPDATE MET_LOGCONSCOMMESSE
	SET COMMESSA =  @RIFCOMM_NEW
	WHERE COMMESSA = @RIFCOMM_OLD

UPDATE BCEA_TempRischOP
	SET RifComm=  @RIFCOMM_NEW
	WHERE RifComm = @RIFCOMM_OLD

COMMIT TRAN



--*******************************************************
--* Inserire il Rif. Commessa in movimenti di prelievo
--* che non ce l'ahho (e quindi non compaiono nei
--* consuntivi commessa)
--* Imerio 16/07/2013
--******************************************************

-- Dall'AIOT, tasto dx, leggere il Nr. Mov. e inserirlo nel Progressivo
select * from storicomovprod where progressivo = 63312

-- dal precedente leggere il Riftesta e inserirlo nel Progressivo
select * from testeordiniprod where progressivo = 4521
--update testeordiniprod set rifcommcli = 'Y0631-A02' WHERE progressivo = 4521

-- Il Progressivo inserirlo nel IdTesta
select * from righeordprod where idtesta = 4521

-- Ancora l'IdTesta nell'IDTesta. Scegliere poi la riga di interesse e prendere l'IdRiga relativo
select * from impegniordprod where idtesta = 4521 and idriga = 2
--update impegniordprod set rifcommcli = 'Y0631-A02' where idtesta = 4521 and idriga = 2

--Riprendere il Nr. Mov iniziale e inserirlo in RifProgressivo, e l'IdTesta precedente inserirlo nel RifTesta
select * from storicomovordprod where rifprogressivo = 63312 and riftesta = 4521

-- Ancora RifProgressivo dal Nr. Mov iniziale e RigaMovOrd dalla select precedente
select * from storicomovimpprod where rifprogressivo=63312 and rigamovord = 2
--update storicomovimpprod set rifcommcli = 'Y0631-A02' where rifprogressivo=63312 and rigamovord = 2

-- Ancora IdTesta uguale al Nr. Mov, la RigaDoc uguale al precedente RigaMovOrd e RigaComp uguale al precedente RigaMovImp
select * from storicomag where idtesta = 63312 and rigadoc= 2 and rigacomp = 1
--update storicomag set codcommessa = 'Y0631-A02' where idtesta = 63312 and rigadoc= 2 and rigacomp = 1