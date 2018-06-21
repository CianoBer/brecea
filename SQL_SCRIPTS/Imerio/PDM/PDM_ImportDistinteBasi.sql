--******************************
--* inserisce record in TEMP_RD_importdistinte
--* leggendo i dati da RD_importdistinte
--* ABBONDANZA 06/08/2014
--******************************************

Drop table TEMP_RD_importdistinte

select BOM_session,codpadre, codfiglio,  sum(convert(real,bom_qty)) as bom_qty, validity_start
into TEMP_RD_importdistinte
from RD_importdistinte group by BOM_session, codpadre , codfiglio, validity_start
order by 1




