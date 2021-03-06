/****** Object:  Table dbo.MET_IMPORTDOC    Script Date: 02/13/2009 14:32:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MET_IMPORTDOC') AND type in (N'U'))
DROP TABLE MET_IMPORTDOC
GO

/****** Object:  Table dbo.MET_IMPORTDOC    Script Date: 02/13/2009 14:32:59 ******/
CREATE TABLE MET_IMPORTDOC
(
	CodCliente nvarchar(10) NULL,
	DataOrdine decimal(8, 0) NULL,
	TipoOrdine nvarchar(1) NULL,
	TipoDoc nvarchar(255) NULL,
	NrOrdine decimal(7, 0) NULL,
	DataConsegna decimal(8, 0) NULL,
	NrRiga decimal(3, 0) NULL,
	CodArticolo nvarchar(13) NULL,
	UM nvarchar(2) NULL,
	QTA decimal(13, 4) NULL,
	PrezzoUnitario decimal(19, 6) NULL,
	Sconto decimal(4, 2) NULL,
	Descrizione nvarchar(40) NULL,
	RifCommCli nvarchar(255) NULL,
	AnnotazioniRiga nvarchar(255) NULL,
	IMPORTATO SMALLINT NOT NULL DEFAULT 0
) ON [PRIMARY]
GO

GRANT ALL ON MET_IMPORTDOC TO METODO98
GO

-- CREA VISTA PER GENERAZIONE DOCUMENTI
DROP VIEW MET_VISTARIGHEDOCDACREARE
GO
CREATE VIEW MET_VISTARIGHEDOCDACREARE AS
SELECT 
	(CASE WHEN TIPOORDINE='G' THEN 'OG1' ELSE (CASE WHEN TIPOORDINE='R' THEN'OR1' ELSE (CASE WHEN TIPOORDINE='O' THEN'OF1' ELSE '' END) END) END)+
	CAST(NRORDINE AS VARCHAR) AS CODDOC,
	ID.CODCLIENTE,
	XC.CODCONTO,
	LEFT(DATAORDINE,4) AS ESERCIZIO,
	(CASE WHEN TIPOORDINE='G' THEN 'OG1' ELSE (CASE WHEN TIPOORDINE='R' THEN'OR1' ELSE (CASE WHEN TIPOORDINE='O' THEN'OF1' ELSE '' END) END) END) AS TIPODOC,
	RIGHT(DATAORDINE,2)+'/'+SUBSTRING(CAST(DATAORDINE AS VARCHAR), 5, 2)+'/'+LEFT(DATAORDINE,4) AS DATADOC,
	NRORDINE AS NRRIFDOC,
	NRRIGA,
	(CASE WHEN DATACONSEGNA=0 THEN '' ELSE RIGHT(DATACONSEGNA,2)+'/'+SUBSTRING(CAST(DATACONSEGNA AS VARCHAR), 5, 2)+'/'+LEFT(DATACONSEGNA,4)END) AS DATACONSEGNA,
	CODARTICOLO AS CODART,
	DESCRIZIONE AS DESCRIZIONEART,
	UM,
	QTA AS QTAGEST,
	PREZZOUNITARIO AS PREZZOUNITLORDO,
	(CASE WHEN SCONTO=0 OR CODARTICOLO='' THEN '' ELSE CAST(SCONTO AS VARCHAR) END) AS SCONTIESTESI,
	RIFCOMMCLI,
	ANNOTAZIONIRIGA,
	IMPORTATO
FROM
	MET_IMPORTDOC ID
	LEFT OUTER JOIN EXTRACLIENTI XC ON XC.CODICEVECCHIO=ID.CODCLIENTE
GO
GRANT SELECT ON MET_VISTARIGHEDOCDACREARE TO METODO98
GO

DROP VIEW MET_VISTATESTEDOCDACREARE
GO
CREATE VIEW MET_VISTATESTEDOCDACREARE AS
SELECT
	CODDOC,
	CODCONTO,
	ESERCIZIO,
	TIPODOC,
	DATADOC,
	NRRIFDOC,
	IMPORTATO
FROM
	MET_VISTARIGHEDOCDACREARE
GROUP BY
	CODDOC,
	CODCONTO,
	ESERCIZIO,
	TIPODOC,
	DATADOC,
	NRRIFDOC,
	IMPORTATO
GO
GRANT SELECT ON MET_VISTATESTEDOCDACREARE TO METODO98
GO