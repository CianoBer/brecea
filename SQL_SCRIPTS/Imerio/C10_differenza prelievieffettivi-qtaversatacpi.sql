           --************************************************
		   --* CONTROLLA SE QUANTITA' EFFETTIVAMENTE PRELEVATA 
		   --* COINCIDE CON LA QUANTITA'
		   --* REGISTRATA IN RIGA NELL'IMPEGNO DELLA CPI
		   --* se ci sono delle discrepanze lanciare l'utility
		   --* PRODUZIONE/UTILITA'/RICALCOLO MOV. MAG DA SESSIONI MOV.
		   --* (non durante l'attività lavorativa)
		   --* Il ricalcolo non può essere eseguito per CPI/CAM generate in esercizi chiusi
		   --* M. ROSINA (14/10/2016)
		   --*************************************************
			
			
			
			SELECT I.IDTESTA, I.IDRIGA,
                  T.TIPOCOM, T.ESERCIZIO, T.NUMEROCOM, R.IDRIGA,I.IDIMPEGNO, i.CODART
                  ,I.QTAGESTIONE
                  ,I.QTAGESTIONEVERS
                  ,ISNULL(MOV.QTAPRELEVATA,0) Prelevato
                  ,(CASE WHEN I.QTAGESTIONEVERS<>MOV.QTAPRELEVATA                                           THEN 'PRELIEVI MANCANTI'
                         WHEN (I.STATOIMPEGNO<>2 AND (I.QTAGESTIONE-I.QTAGESTIONEVERS)<>I.QTAGESTIONERES)   THEN 'RESIDUO ERRATO'
                         WHEN (I.QTAGESTIONE-MOV.QTAPRELEVATA<=0 AND I.STATOIMPEGNO<>2)                     THEN 'NON CHIUSI'
                         ELSE ''
                    END) AS ERRORE
            FROM TESTEORDINIPROD T
                  INNER JOIN RIGHEORDPROD R ON R.IDTESTA=T.PROGRESSIVO
                  INNER JOIN IMPEGNIORDPROD I ON I.IDTESTA=R.IDTESTA AND I.IDRIGA=R.IDRIGA
                  LEFT OUTER JOIN (SELECT SI.RIFTESTA, SI.RIFRIGA, SI.RIFIMPEGNO, ISNULL(SUM(QTAMOVGESTIONE),0) AS QTAPRELEVATA
                                     FROM STORICOMOVIMPPROD SI GROUP BY SI.RIFTESTA, SI.RIFRIGA, SI.RIFIMPEGNO
                                  ) MOV ON MOV.RIFTESTA=I.IDTESTA AND MOV.RIFRIGA=I.IDRIGA AND MOV.RIFIMPEGNO=I.IDIMPEGNO
            WHERE ( (I.QTAGESTIONEVERS<>MOV.QTAPRELEVATA) OR
                   (I.STATOIMPEGNO<>2 AND (I.QTAGESTIONE-I.QTAGESTIONEVERS)<>I.QTAGESTIONERES) 
                 --   (I.QTAGESTIONE-MOV.QTAPRELEVATA<=0 AND I.STATOIMPEGNO<>2)
                  )
				  and T.ESERCIZIO IN (2017)
				  order by i.idtesta
