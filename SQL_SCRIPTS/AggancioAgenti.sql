/* Istruzioni per l'aggancio degli agenti alle form per utente */

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 4000, 'FormDoc.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=4000)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 6201, 'FrmAnaCommCli.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=6201)
	GO
	
	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 2001002, 'FrmStpPianMacc.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=2001002)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 4500, 'FormInsDBA.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=4500)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 4510, 'FormImplDBA.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=4510)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 3000, 'FormArt.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=3000)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 3005, 'FormArt.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=3005)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 1004002, 'FrmStpValRett.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=1004002)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 5020, 'FormOrdPian.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=5020)
	GO

	INSERT INTO TabAgentiUtente (CodUtente, FormID, Agente, UtenteModifica, DataModifica)
		SELECT UserID, 1405, 'CFPRVPAR.cmp', 'Input', GetDate() FROM TabUtenti
			WHERE UserID NOT IN (SELECT CodUtente FROM TabAgentiUtente WHERE FormID=1405)
	GO
