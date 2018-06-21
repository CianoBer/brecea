-- **********************************************************
-- azzerare  le dic.es.iva  Fornitori nel 2010 copiate dal 2009
-- alla creazione del nuovo esercizio
--              Nichele 08/01/2010
-- **********************************************************

-- VERIFICA
select aa.esercizio, aa.codconto, aa.dichesiva, bb.dscconto1 from anagraficariservaticf aa, anagraficacf bb 
where aa.esercizio=2009 and aa.dichesiva <> '' and left(aa.codconto,1)='F' and aa.codconto = bb.codconto

 
-- CANCELLAZIONE
-- delete anagraficariservaticf where esercizio=2010 and dichesiva <> '' and left(codconto,1)='F'

