DELETE FROM MET_TAB_EXPORTRADAR
GO

INSERT INTO MET_TAB_EXPORTRADAR	(FLGSEL,IDTESTADOC,IDRIGADOC,RIFERIMENTI,TIPO,NOTE,UTENTEMODIFICA,DATAMODIFICA)
(SELECT DISTINCT 1 AS FLGSEL,MSE.IDTESTADOC,MSE.IDRIGADOC,MSE.RIFERIMENTI,MSE.TIPO,'' AS NOTE,'IMPORT' AS UTENTEMODIFICA,GETDATE() AS DATAMODIFICA FROM MET_SEL_EXPORTRADAR MSE
WHERE MSE.STATOORDINE<>3 AND MSE.TIPOCOM='CAM')