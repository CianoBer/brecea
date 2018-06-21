' Caricamento tabella temporanea per analisi disponibilità
Public Sub visDispLoadTemp()

    Dim trcVis
    Dim objFiltro
    Dim objAnaDisp

    ' Recupero oggetto filtro visione analisi disponibilità
    Set trcVis = visDisp.ControlInterface.EmbeddedObject("Traccia")
    Set objFiltro = trcVis.mCFiltroDati

    ' Esecuzione caricamento tabella temporanea
    Set objAnaDisp = Ambienti("MXPROD").CreaCAnalisiProd()
    If Not objAnaDisp Is Nothing Then
        Call objAnaDisp.AnalisiCopertura("CodArt='" & visArt.ControlInterface.GetData("Codice") & "' AND " & objFiltro.SQLFiltro, objFiltro.ParAgg("DataElab").ValoreFormula)

        Set objAnaDisp = Nothing
    End If

    ' Azzeramento filtro per caricamento visione
    Call objFiltro.SettaSQLFiltro("")

    Set objFiltro = Nothing
    Set trcVis = Nothing

End Sub
