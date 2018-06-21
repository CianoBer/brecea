INSERT INTO AccessiCausCont (CodCausale, NomeUtente, FlagAbilita, UtenteModifica, DataModifica, FlagVisualizza)
	SELECT CodiceCausale, 'r.cortese', 0, 'Input', getdate(), 1
		FROM CausaliContabili WHERE CodiceCausale NOT IN (SELECT CodCausale FROM AccessiCausCont WHERE NomeUtente='r.cortese')
GO

INSERT INTO AccessiCausMag (CodCauMag, NomeUtente, FlagVisualizza, UtenteModifica, DataModifica)
	SELECT Codice, 'r.cortese', 1, 'Input', getdate()
		FROM TabCausaliMag WHERE Codice NOT IN (SELECT CodCauMag FROM AccessiCausMag WHERE NomeUtente='r.cortese')
GO

UPDATE AccessiCausMag SET FlagVisualizza=1 WHERE NomeUtente='r.cortese' AND FlagVisualizza=0
GO
