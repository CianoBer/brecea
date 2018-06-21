IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('TDA_FEEDBACK') and sysobjects.XTYPE='U') and syscolumns.name='CAUSALEMOV')
	ALTER TABLE TDA_FEEDBACK ADD CAUSALEMOV DECIMAL(5,0)
GO
UPDATE TDA_FEEDBACK SET CAUSALEMOV = 0 WHERE CAUSALEMOV IS NULL
GO

IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('TDA_FEEDBACK') and sysobjects.XTYPE='U') and syscolumns.name='CAUSALEOPER')
	ALTER TABLE TDA_FEEDBACK ADD CAUSALEOPER INT
GO
UPDATE TDA_FEEDBACK SET CAUSALEOPER = 0 WHERE CAUSALEOPER IS NULL
GO

IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('TDA_FEEDBACK') and sysobjects.XTYPE='U') and syscolumns.name='NOTELAV')
	ALTER TABLE TDA_FEEDBACK ADD NOTELAV VARCHAR(256)
GO
UPDATE TDA_FEEDBACK SET NOTELAV = '' WHERE NOTELAV IS NULL
GO

IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('EXTRAAVANZAMENTI') and sysobjects.XTYPE='U') and syscolumns.name='NOTELAV')
	ALTER TABLE EXTRAAVANZAMENTI ADD NOTELAV VARCHAR(256)
GO
UPDATE EXTRAAVANZAMENTI SET NOTELAV = '' WHERE NOTELAV IS NULL
GO

IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('EXTRAAVANZAMENTI') and sysobjects.XTYPE='U') and syscolumns.name='IDFEEDBACK_INI')
	ALTER TABLE EXTRAAVANZAMENTI ADD IDFEEDBACK_INI INT
GO
UPDATE EXTRAAVANZAMENTI SET IDFEEDBACK_INI = 0 WHERE IDFEEDBACK_INI IS NULL
GO

IF NOT EXISTS(select syscolumns.NAME from syscolumns where
   	syscolumns.id=(select id from sysobjects where id =OBJECT_ID('EXTRAAVANZAMENTI') and sysobjects.XTYPE='U') and syscolumns.name='IDFEEDBACK_FINE')
	ALTER TABLE EXTRAAVANZAMENTI ADD IDFEEDBACK_FINE INT
GO
UPDATE EXTRAAVANZAMENTI SET IDFEEDBACK_FINE = 0 WHERE IDFEEDBACK_FINE IS NULL
GO

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID('BCEA_TABCAUSALILAV') AND TYPE = 'U')
BEGIN
	CREATE TABLE BCEA_TABCAUSALILAV
	(
		CODICE INT NOT NULL,
		DESCRIZIONE VARCHAR(30) NOT NULL,
		FLGNOTEOBBL SMALLINT,
		CAUSALE_MOV INT,
		PRIMARY KEY (CODICE)
	)
	GRANT REFERENCES,SELECT,UPDATE,INSERT ,DELETE ON BCEA_TABCAUSALILAV TO METODO98
	
	INSERT INTO BCEA_TABCAUSALILAV (CODICE,DESCRIZIONE,FLGNOTEOBBL,CAUSALE_MOV) VALUES (100,'Produzione',0,100)
	INSERT INTO BCEA_TABCAUSALILAV (CODICE,DESCRIZIONE,FLGNOTEOBBL,CAUSALE_MOV) VALUES (110,'Ripresa',1,110)
	INSERT INTO BCEA_TABCAUSALILAV (CODICE,DESCRIZIONE,FLGNOTEOBBL,CAUSALE_MOV) VALUES (120,'Pulizia e manutenzione',1,120)
	INSERT INTO BCEA_TABCAUSALILAV (CODICE,DESCRIZIONE,FLGNOTEOBBL,CAUSALE_MOV) VALUES (130,'Preparazione trasferta',1,130)
	INSERT INTO BCEA_TABCAUSALILAV (CODICE,DESCRIZIONE,FLGNOTEOBBL,CAUSALE_MOV) VALUES (200,'Varie',1,200)
END
GO

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID('BCEA_PARAMETRITDA') AND TYPE = 'U')
BEGIN
	CREATE TABLE BCEA_PARAMETRITDA
	(
		PAR_MODULO VARCHAR(15) NOT NULL,
		PAR_CODICE VARCHAR(15) NOT NULL,
		PAR_DESC VARCHAR(250) NOT NULL,
		PAR_TIPO VARCHAR(20) NOT NULL,
		PAR_LUNGH INT NOT NULL,
		PAR_VALORE VARCHAR(250) NOT NULL,
	)
	GRANT REFERENCES,SELECT,UPDATE,INSERT ,DELETE ON BCEA_PARAMETRITDA TO METODO98
	
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','FLAV_CAU','Causale feedback per fine lavorazione','INT',3,'2')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','FLAV_GIU','Giustificativo feedback per fine lavorazione','INT',3,'1')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','FLAV_TIPO','Tipo feedback per fine lavorazione','INT',3,'1')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','ILAV_CAU','Causale feedback per inizio lavorazione','INT',3,'1')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','ILAV_GIU','Giustificativo feedback per inizio lavorazione','INT',3,'1')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','ILAV_TIPO','Tipo feedback per inizio lavorazione','INT',3,'1')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','TIMER_OP','Numero secondi per scelta causale prima del reset codice operatore','INT',3,'25')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','RIAP_CAU','Causale feedback per riapertura bolla','INT',3,'220')
	INSERT INTO BCEA_PARAMETRITDA (PAR_MODULO,PAR_CODICE,PAR_DESC,PAR_TIPO,PAR_LUNGH,PAR_VALORE) VALUES ('RIL_DATIFABB','CHIUSURA_CAU','Causale feedback per chiusura bolla','INT',3,'210')
END
GO

IF EXISTS(SELECT 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID('BCEA_VISTABOLLELAVORAZIONE') AND TYPE = 'V')
    DROP VIEW BCEA_VISTABOLLELAVORAZIONE
GO
CREATE VIEW BCEA_VISTABOLLELAVORAZIONE AS
	SELECT  TORP.TIPOCOM, 
	TORP.ESERCIZIO AS ESERCIZIOCOM, 
	TORP.NUMEROCOM, 
	RCO.ANNOBOLLA, 
	RCO.NUMEROBOLLA, 
	RCO.STATODOCUMENTAZIONE,
	RCO.OPERAZIONE,
	RCO.DSCOPERAZIONE,
    ROP.CODICEORD AS TIPOORDINE, 
	ROP.IDRIGA AS NUMEROORDINE, 
	ROP.DATAEMISSIONE AS DATAORDINE, 
	CAST(RCO.ANNOBOLLA AS VARCHAR(4)) + '.' + CAST(RCO.NUMEROBOLLA AS VARCHAR(10)) AS CODICEBOLLA, 
	ROP.CODART, 
	ROP.DESCRIZIONEART, 
	ROP.QTAGESTIONE, 
	ROP.QTAGESTIONEVERS, 
    ROP.UMGEST AS UMGESTIONE, 
	ROP.STATOORDINE, RCO.NOTERIGA AS ANNOTAZIONIFASE, 
	RCO.DATAFINEOPSCHEDULATA AS DATAFINE,
	RCO.STATOOPERAZIONE,
	ROP.STATOLANCIO,
    ROP.CODCLIDEST AS CODCLIENTE,
    (SELECT DSCCONTO1 FROM ANAGRAFICACF WHERE (CODCONTO = ROP.CODCLIDEST)) AS DSCCLIENTE,
    TORP.PROGRESSIVO AS IDTESTA, 
	ROP.IDRIGA,
	ROP.RIFCOMMCLI,
	(CASE WHEN ACC.RIFERIMENTO IS NULL THEN '' ELSE ACC.RIFERIMENTO END) AS DESCOMMCLI

	FROM TESTACICLOORDINE AS TCO 
	INNER JOIN RIGHECICLOORDINE AS RCO ON TCO.PROGRESSIVO = RCO.PROGRESSIVO
	INNER JOIN TESTEORDINIPROD AS TORP ON TCO.IDTESTACOMM = TORP.PROGRESSIVO 
	INNER JOIN RIGHEORDPROD AS ROP ON TCO.IDTESTACOMM = ROP.IDTESTA AND TCO.IDRIGACOMM = ROP.IDRIGA 
	LEFT OUTER JOIN ANAGRAFICACOMMESSE ACC ON ROP.RIFCOMMCLI=ACC.RIFCOMM
GO
GRANT SELECT ON BCEA_VISTABOLLELAVORAZIONE TO METODO98
GO
