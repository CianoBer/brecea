Public Sub tabella1Unlock

    Dim strQuery

    ' Sblocco procedura da parte dell'utente
    strQuery = "DELETE FROM BCEA_TempRischOP WHERE ProgCC=-1 AND UtenteModifica='" & Ambienti("MXNU").UtenteAttivo & "'"
    Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)

End Sub



Public Sub tabella1Load

    Dim strQuery, rsSS, strUtente

    ' Verifica che la procedura non sia già in uso
    strQuery = "SELECT UtenteModifica FROM BCEA_TempRischOP WHERE ProgCC=-1"
    Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
    If Ambienti("MXDB").dbFineTab((rsSS)) Then
        strUtente = ""
    Else
        strUtente = Ambienti("MXDB").dbGetCampo((rsSS), 4, "UtenteModifica", "")
    End If
    Call Ambienti("MXDB").dbChiudiSS ((rsSS))
    Set rsSS = Nothing

    ' Se la procedura è già in uso, chiede conferma per proseguire (nel caso di chiusura errata in precedenza)
    If strUtente = "" Then
        Call CaricaTabellaTemp
    Else
        If MsgBox("La procedura è già in uso dall'utente [" & strUtente & "]!" & Chr(13) & Chr(13) & "Procedere lo stesso?", 292, "ATTENZIONE!") = 6 Then
            If MsgBox("Sicuro di voler procedere?" & Chr(13) & "Se la procedura è già in funzione si possono creare problemi!", 292, "ATTENZIONE!") = 6 Then
                strQuery = "DELETE FROM BCEA_TempRischOP WHERE ProgCC=-1"
                Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
                Call CaricaTabellaTemp
            Else
                Call BCEARischOPClose
            End If
        Else
            Call BCEARischOPClose
        End If
    End If

End Sub



Public Sub tabella1SaveUnlock

    Call tabella1Save
    Call tabella1Unlock

End Sub



Public Sub BCEARischOPElab

    Dim objFiltro, intModCiclo
    Dim bolCont
    Dim strQuery, rsSS, strRifComm, strDeltaGG, strDataFine

    Call tabella1Save

    ' Recupero oggetto filtro
    Set objFiltro = filtro1.ControlInterface.EmbeddedObject("filter")

    ' Recupero clausola where e formule
    intModCiclo = CInt(Trim(objFiltro.ParAgg("ModCiclo").ValoreFormula))

    Set objFiltro = Nothing

    ' Verifica che le date siano presenti
    bolCont = True
    strQuery = "SELECT 1 FROM BCEA_TempRischOP WHERE ProgCC>0 AND FlagSel=1 AND ISNULL(DeltaGGRisched,0)=0"
    Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
    If Not Ambienti("MXDB").dbFineTab((rsSS)) Then
        bolCont = False
        MsgBox "Indicare i giorni di rischedulazione nelle righe selezionate!", 48, "ATTENZIONE!"
    End If
    Call Ambienti("MXDB").dbChiudiSS ((rsSS))
    Set rsSS = Nothing

    ' Richiesta conferma elaborazione
    If bolCont Then
        If MsgBox("Confermi l'elaborazione delle righe selezionate?", 36, "CONFERMA!") = 7 Then
            bolCont = False
        End If
    End If

    ' Ciclo di lettura righe ed update record
    If bolCont Then
        strQuery = "SELECT RifComm,DeltaGGRisched,"
        strQuery = strQuery + " (cast(year(DataFine) AS varchar(4)) + '-' + right('00' + cast(month(DataFine) AS varchar(2)), 2) + '-' + right('00' + cast(day(DataFine) AS varchar(2)), 2)) AS DtFine"
        strQuery = strQuery + " FROM BCEA_TempRischOP WHERE ProgCC>0 AND FlagSel=1"
        Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
        If Ambienti("MXDB").dbFineTab((rsSS)) Then
            bolCont = False
            MsgBox "Non ci sono righe selezionate per l'elaborazione!", 48, "ATTENZIONE!"
        Else
            Call Ambienti("MXDB").dbPrimo((rsSS))
            Do
                strRifComm = Ambienti("MXDB").dbGetCampo((rsSS), 4, "RifComm", "")
                strDeltaGG = Ambienti("MXDB").dbGetCampo((rsSS), 4, "DeltaGGRisched", "")
                strDataFine = Ambienti("MXDB").dbGetCampo((rsSS), 4, "DtFine", "")

				'aggiorna campi
				strQuery = "EXEC RISCHEDCOMMCLI '" & strRifComm & "'," & strDeltaGG & ",'" & Ambienti("MXNU").UtenteAttivo & "'"
				Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
				
                Call Ambienti("MXDB").dbSuccessivo((rsSS))
            Loop Until Ambienti("MXDB").dbFineTab((rsSS))
        End If
        Call Ambienti("MXDB").dbChiudiSS ((rsSS))
        Set rsSS = Nothing

        If bolCont Then
            MsgBox "Elaborazione terminata!", 0, "Fine Elaborazione!"
            Call BCEARischOPClose
        End If
    End If

End Sub



Private Sub CaricaTabellaTemp

    Dim objFiltro, strWhere, intCancPrec
    Dim strQuery

    ' Recupero oggetto filtro
    Set objFiltro = filtro1.ControlInterface.EmbeddedObject("filter")

    ' Recupero clausola where e formule
    strWhere = objFiltro.SQLFiltro
    intCancPrec = CInt(Trim(objFiltro.ParAgg("CancPrec").ValoreFormula))

    Set objFiltro = Nothing

    ' Svuota la tabella temporanea se richiesto
    If intCancPrec = 1 Then
        strQuery = "DELETE FROM BCEA_TempRischOP"
        Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
    End If

    ' Blocco aplicazione da parte dell'utente
    strQuery = "INSERT INTO BCEA_TempRischOP (ProgCC, FlagSel, RifComm, Riferimento, DataFine, UtenteModifica, DataModifica, DeltaGGRisched)"
    strQuery = strQuery & " VALUES (-1, 0, '', '', '', '" & Ambienti("MXNU").UtenteAttivo & "', getdate(), 0)"
    Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)

    ' Carica i dati delle commesse clienti nella tabella temporanea
    strQuery = "INSERT INTO BCEA_TempRischOP (ProgCC, FlagSel, RifComm, Riferimento, UtenteModifica, DataModifica, DeltaGGRisched)"
    strQuery = strQuery  & " SELECT DISTINCT VCC.Progressivo, 0, VCC.RifComm, '', '" & Ambienti("MXNU").UtenteAttivo & "', getdate(), 0"
    strQuery = strQuery  & " FROM VistaCommesseClienti VCC INNER JOIN VistaOrdiniCommesseProd ON VCC.RifComm=VistaOrdiniCommesseProd.RifCommCli"
    strQuery = strQuery  & " WHERE VCC.Progressivo NOT IN (SELECT ProgCC FROM BCEA_TempRischOP) AND VistaOrdiniCommesseProd.RifCommCli IS NOT NULL AND VistaOrdiniCommesseProd.RifCommCli<>'' AND " & strWhere
    Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)

    ' Aggiorna le date nei record inseriti
    strQuery = "update BCEA_TempRischOP set Riferimento = isnull((select max((TOR.TipoCom + '/' + cast(TOR.ESERCIZIO AS varchar) + '/' + cast(TOR.NumeroCom AS varchar))) from RIGHEORDPROD ROP INNER JOIN TESTEORDINIPROD AS TOR ON ROP.IDTESTA=TOR.PROGRESSIVO where ROP.RifCommCli = RifComm and ROP.CODART = ('00'+ROP.RifCommCli)),'')"
    Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
    strQuery = "update BCEA_TempRischOP	set	DataFine = (select max(DATAFINERICH) from RIGHEORDPROD where RifCommCli = RifComm and CODART = ('00'+RifCommCli))"
    Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)

    Call tabella1Open

End Sub



Private Sub BCEARischOPClose

    Dim Azione

    ' Chiude la console
    Set Azione = BCEARischOP.CreateActionByID("ChiudiConsole")
    Call BCEARischOP.ObjectInterface.ExecuteAction((Azione), (Nothing))
    Set Azione = Nothing

End Sub



Public Sub tabella1Save

    Dim Azione

    ' Salva la tabella
    Set Azione = tabella1.CreateActionByID("SalvaTabella")
    Call tabella1.ControlInterface.ExecuteAction((Azione), (Nothing))
    Set Azione = Nothing

End Sub



Private Sub tabella1Open

    Dim Azione

    ' Apre la tabella
    Set Azione = tabella1.CreateActionByID("ApriTabella")
    Azione.Params("stragg").ActualValue = ""
    Azione.Params("chiaveagg").ActualValue = ""
    Azione.Params("tipochiave").ActualValue = "0"
    Azione.Params("valorechiave").ActualValue = ""
    Call tabella1.ControlInterface.ExecuteAction((Azione), (Nothing))
    Set Azione = Nothing

End Sub
