USE [BRECEA]
GO

DROP VIEW [dbo].[BRECEA_VISTA_LISTINIARTICOLI_100]
GO

CREATE VIEW [dbo].[BRECEA_VISTA_LISTINIARTICOLI_100] AS 
SELECT [CODART]
      ,[NRLISTINO]
      ,[UM]
      ,[PREZZO]
      ,[PREZZOEURO]
      ,[UTENTEMODIFICA]
      ,[DATAMODIFICA]
      ,[DeltaIncremento]
      ,[TP_CodConto]
      ,[TP_ConsPP]
      ,[TP_PrezzoPart]
      ,[TP_PrezzoPartEuro]
      ,[TP_Scorporo]
      ,[TP_Sconti]
      ,[TP_QTASCONTO]
      ,[TP_QTACOEFF]
      ,[TP_QTAMO]
      ,[TP_Abbuono]
      ,[TP_DataCambio]
      ,[TP_ValoreCambio]
      ,[DATAVALIDITA]
      ,[TP_FormulaSct]
      ,[PREZZOCALC]
      ,[TP_ABBUONOEURO]
  FROM [LISTINIARTICOLI]
  WHERE NRLISTINO = 1412
  
GO
GRANT ALL ON [dbo].[BRECEA_VISTA_LISTINIARTICOLI_100] TO METODO98
GO