-- ELIMINA RIFERIMENTI UBICAZIONI DA STORICO MAGAZZINO E ORDINI DI PRODUZIONE

-- STORICO MOVIMENTI PRELIEVO PRODUZIONE

	UPDATE StoricoMovImpProd
	SET
		Ubicazione='', 
		UbicazioneColl='', 
		UbicazioneScarto='', 
		UbicazioneScartoColl=''
	WHERE 
		Ubicazione<>'' OR 
		UbicazioneColl<>'' OR 
		UbicazioneScarto<>'' OR 
		UbicazioneScartoColl<>''

-- STORICO MOVIMENTI VERSAMENTI PRODUZIONE

	UPDATE StoricoMovOrdProd 
	SET 
		Ubicazione='', 
		UbicazioneColl='', 
		UbicazioneScarto='', 
		UbicazioneScartoColl='' 
	WHERE
		Ubicazione<>'' OR 
		UbicazioneColl<>'' OR 
		UbicazioneScarto<>'' OR 
		UbicazioneScartoColl<>'' 


-- STORICOMAG

	UPDATE Storicomag
	SET
		codubicazione = ''
	WHERE
		codubicazione <> ''



-- RIGHE ORDINI DI PRODUZIONE

	UPDATE RigheOrdProd 
	SET 
		Ubicazione='', 
		UbicazioneColl=''
	WHERE
		Ubicazione<>'' OR 
		UbicazioneColl<>''



-- IMPEGNI ORDINI DI PRODUZIONE

	UPDATE ImpegniOrdProd 
	SET 
		Ubicazione='', 
		UbicazioneColl=''

	WHERE
		Ubicazione<>'' OR
		UbicazioneColl<>''

