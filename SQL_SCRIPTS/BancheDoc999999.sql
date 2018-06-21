select * from testedocumenti where codbancaincasso='B999999' and left(codclifor,1)='C'
and codclifor in (select codconto from vistaclifor where codbanca is not null and codbanca<>'' and codbanca<>'B999999')

select * from vistaclienti where codbanca is null or codbanca='' or codbanca='B999999'

--update testedocumenti set codbancaincasso=(select vcf.codbanca from vistaclifor vcf where vcf.codconto=testedocumenti.codclifor)
--where codbancaincasso='B999999'
--and codclifor in (select codconto from vistaclifor where codbanca is not null and codbanca<>'' and codbanca<>'B999999')