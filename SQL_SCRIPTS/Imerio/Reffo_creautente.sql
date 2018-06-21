
-- *************************************
-- *       CREAZIONE UTENTE            *
-- * USARE SOLO SE L'UTENTE NON ESISTE *
-- *************************************

-- *************************************
-- * 1) LANCIARE PER PRIMA QUESTA SELECT 
-- * PER VERIFICARE IL TRM DA ASSEGNARE AL NUOVO UTENTE

select userid, userdb from tabutenti
order by userdb
--order by userid

--delete tabutenti where userid = 'a.zarantonello'

-- *****************************
-- * 2) CREARE L'UTENTE IN SQL *

IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.schenato')
CREATE LOGIN [a.schenato] WITH PASSWORD=N'dr*3pahU', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF



-- *******************************************************************
-- * 3) CREARE ACCESSO, RUOLO E POPOLA LA TABUTENTI NEI DB DI METODO *
-- * LANCIARE SIA PER LA DITTA BRECEA CHE PER LA DITTA DITTAPRO      *

EXEC sp_grantdbaccess N'a.schenato', N'a.schenato'
EXEC sp_addrolemember N'Metodo98', N'a.schenato'

INSERT INTO TABUTENTI(USERID,USERDB,DESCRIZIONE,NRTERMINALE,ESERCIZIOATTIVO,SUPERVISOR,
UTENTEMODIFICA,DATAMODIFICA,CTRLECCEZIONIART,NomeMacchina,PERSVISIONI,CODCLIFOR) 
VALUES('a.schenato','TRM41','Andrea Schenato','41','2017','0','i.rebellato',GETDATE(),1,'',1,'')
