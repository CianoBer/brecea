--********************************************
--* INDIVIDUA I CLIENTI CHA HANNO CODNAZIONE = 31
--* PER METODO DEV'ESSERE
--* CODNAZIONE = 0 PER I CLIENTI ITALIA
--* REBELLATO 26/08/2013


select codconto, dscconto1, codnazione from anagraficacf where (codnazione = 31 ) and tipoconto = 'C'

--update anagraficacf set codnazione = 31 where codnazione = 0 and tipoconto = 'C'