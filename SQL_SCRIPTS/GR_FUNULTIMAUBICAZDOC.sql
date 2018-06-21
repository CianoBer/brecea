USE [BREVCEA]
GO

ALTER FUNCTION [dbo].[GR_FUNULTIMAUBICAZDOC]
(
	@CODART VARCHAR(80)
)
RETURNS VARCHAR(272)
AS
BEGIN
	DECLARE @UBIATERRA AS VARCHAR(255)
	DECLARE @RIFULTDOC AS VARCHAR(50)
	DECLARE @RESULT AS VARCHAR(272)

	SELECT TOP 1 @UBIATERRA=ERD.UBIDESC, @RIFULTDOC=(TD.TIPODOC +'/'+ CAST(TD.ESERCIZIO AS VARCHAR(4)) +'/'+ RIGHT('0000000' + CAST(TD.NUMERODOC AS VARCHAR(100)), 7))
	FROM TESTEDOCUMENTI TD 
	LEFT OUTER JOIN RIGHEDOCUMENTI RD
		ON TD.PROGRESSIVO=RD.IDTESTA
	LEFT OUTER JOIN EXTRARIGHEDOC ERD
		ON RD.IDTESTA=ERD.IDTESTA AND RD.IDRIGA=ERD.IDRIGA
	WHERE CODART=@CODART
	AND RD.TIPODOC IN ('BAM','BAR')
	ORDER BY TD.DATADOC DESC

	SET @RESULT=@UBIATERRA+','+@RIFULTDOC

	-- Return the result of the function
	RETURN ISNULL(@RESULT,',')

END
GO

GRANT EXECUTE ON [dbo].[GR_FUNULTIMAUBICAZDOC] TO METODO98
GO
