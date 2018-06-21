drop table tmp_import_articoli

SELECT  *  into  tmp_import_articoli
FROM         View_Articoli_metodo
where CODICE not in (select codcodice from CODICI)
and CODICE like '72724%'

--update tmp_import_articoli set UtenteCreazione = 'import' where UtenteCreazione is null

--update tmp_import_articoli set DataCreazione = '2016-01-11 00:00:00.000' where DataCreazione is null

--update tmp_import_articoli set TP = 'TP2' where CODPIANIFICATORE =2 and PROVENIENZA =1

--update tmp_import_articoli set TP = 'TP3' where CODPIANIFICATORE =1 and PROVENIENZA =0

--update tmp_import_articoli set TP = 'TP4' where CODPIANIFICATORE =2 and PROVENIENZA =0
