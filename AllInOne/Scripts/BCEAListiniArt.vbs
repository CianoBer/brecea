' Routine colorazione visione righe documento
Public Sub visListiniColor

    Dim objVis, objSS
    Dim lngRiga, lngCol
    Dim strArt, lngList
    Dim strQuery, rsSS

    ' Recupero oggetto visione, spread, riga caricata e colonna numero listino
    Set objVis = visListini.ControlInterface.EmbeddedObject("traccia")
    Set objSS = objVis.pLivelloCorrente.ssVisione
    lngRiga = CLng(EventPars("row").Value)
    lngCol = CLng(objVis.DataField2Colonna("NrListino"))

    ' Recupero codice articolo e numero listino riga caricata
    strArt = Trim(visArt.ControlInterface.GetData("Codice"))
    lngList = CLng(MXSpread.ssCellGetValue((objSS), lngCol, lngRiga))

    ' Colorazione riga se listino uguale a listino fornitore preferenziale acquisto articolo
    strQuery = "SELECT 1 FROM VistaCliFor VCF INNER JOIN VistaAnagraficaArticoli VAA ON VCF.CodConto=VAA.FornPrefAcq WHERE VAA.Codice='" & strArt & "' AND VCF.Listino=" & lngList
    Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
    If Ambienti("MXDB").dbFineTab((rsSS)) Then
        Call Ambienti("MXDB").dbChiudiSS((rsSS))
        strQuery = "SELECT 1 FROM VistaCliFor VCF INNER JOIN TabLottiRiordino TLR ON VCF.CodConto=TLR.CodFor WHERE TLR.CodArt='" & strArt & "' AND VCF.Listino=" & lngList & " AND TLR.TipoRiord=0 AND TLR.PrcRipart=100"
        Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
        If Not Ambienti("MXDB").dbFineTab((rsSS)) Then
            Call MXSpread.ssCellBackColor((objSS), -1, lngRiga, RGB(255, 255, 0))
        End If
    Else
        Call MXSpread.ssCellBackColor((objSS), -1, lngRiga, RGB(255, 255, 0))
    End If
    Call Ambienti("MXDB").dbChiudiSS((rsSS))

    ' Scaricamento oggetti
    Set objVis = Nothing
    Set objSS = Nothing
    Set rsSS = Nothing

End Sub



' Riotine di modifica fornitore preferenziale nell'articolo
Public Sub SetFornAcq

    Dim strArt, strForn
    Dim strQuery, rsSS
    Dim lngNum
    Dim Azione

    ' Recupero articolo e fornitore riga selezionata
    strArt = Trim(visArt.ControlInterface.GetData("Codice"))
    strForn = Trim(visListini.ControlInterface.GetData("CodFor"))

    ' Se è un fornitore, chiede la conferma per impostarlo come fornitore preferenziale
    If Left(strForn, 1) = "F" Then
        If MsgBox("Impostare il fornitore [" & strForn & "] come fornitore preferenziale per l'articolo [" & strArt & "] ?", 292, "Conferma Fornitore Preferenziale") = 6 Then

            ' Verifica che il fornitore sia già presente nell'elenco
            strQuery = "SELECT Numero FROM TabLottiRiordino WHERE CodArt='" & strArt & "' AND TipoRiord=0 AND CodFor='" & strForn & "'"
            Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
            If Ambienti("MXDB").dbFineTab((rsSS)) Then
                Call Ambienti("MXDB").dbChiudiSS((rsSS))

                ' Inserisce una nuova riga con il fornitore selezionato
                strQuery = "SELECT max(Numero) AS MaxNum FROM TabLottiRiordino WHERE CodArt='" & strArt & "' AND TipoRiord=0"
                Set rsSS = Ambienti("MXDB").dbCreaSS((hndDBArch), strQuery)
                If Ambienti("MXDB").dbFineTab((rsSS)) Then
                    lngNum = 1
                Else
                    lngNum = CLng(Ambienti("MXDB").dbGetCampo((rsSS), rsSS.Tipo, "MaxNum", 0)) + 1
                End If
                strQuery = "INSERT INTO TabLottiRiordino (CodArt, Numero, TipoRiord, CodFor, LottoRif, UM, QtaMinima, QtaMassima, QtaDelta, PrcRipart, GGApprovv, GGAppront, ArrotLotto, CostoUnTrasf, CostoUnTrasEuro, UtenteModifica, DataModifica, TP_CodDep, TP_FornFatturazione)"
                strQuery = strQuery & " SELECT Codice, " & lngNum & ", 0, '" & strForn & "', LottoRifAcq, UMLottoAcq, QMinRiordAcq, QMaxRiordAcq, QDeltaRiordAcq, 100, TApprovvAcq, TApprontAcq, ArrotLottoAcq, 0, 0, '" & Ambienti("MXNU").UtenteAttivo & "', getdate(), '', ''"
                strQuery = strQuery & " FROM VistaAnagraficaArticoli WHERE Codice='" & strArt & "'"
                Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
            Else

                ' Imposta a 100 la percentuale di ripartizione per il fornitore selezionato
                lngNum = CLng(Ambienti("MXDB").dbGetCampo((rsSS), rsSS.Tipo, "Numero", 0))
                strQuery = "UPDATE TabLottiRiordino SET PrcRipart=100 WHERE CodArt='" & strArt & "' AND Numero=" & lngNum & " AND TipoRiord=0"
                Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
            End If
            Call Ambienti("MXDB").dbChiudiSS((rsSS))

            ' Imposta a 0 la percentuale di ripartizione per gli altri fornitori ed elimina quello predefinito
            strQuery = "UPDATE TabLottiRiordino SET PrcRipart=0 WHERE CodArt='" & strArt & "' AND Numero<>" & lngNum & " AND TipoRiord=0"
            Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)
            strQuery = "UPDATE AnagraficaArticoliProd SET FornPrefAcq='' WHERE CodiceArt='" & strArt & "'"
            Call Ambienti("MXDB").dbEseguiSQL((hndDBArch), strQuery)

            ' Riesegue il caricamento della visione listini
            Set Azione = visListini.CreateActionByID("CaricaVisione")
            Azione.Params("criteria").ActualValue = "CodArt='" & strArt & "'"
            Azione.Params("orderby").ActualValue = ""
            Call visListini.ControlInterface.ExecuteAction((Azione), (Nothing))
        End If
    End If

    ' Scaricamento oggetti
    Set rsSS = Nothing
    Set Azione = Nothing

End Sub
