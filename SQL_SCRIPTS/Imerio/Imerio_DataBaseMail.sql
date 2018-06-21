--************************************
--* DATABASE MAIL
--* verifica mail inviate

use msdb
go
select * from sysmail_allitems


--** verifica dati vari
Use msdb
Go
--Step1: Varifying the new profile
     select * from sysmail_profile
--Step2: Verifying accounts
     select * from sysmail_account
--Step3: To check the accounts of a profile
     select * from sysmail_profileaccount
     where profile_id=3
--Step4: To display mail server details
select * from sysmail_server


--** invio mail di test
--** vedi anche da Gestione/Posta Elettronica DB: tasto dx
--use msdb
--go 
--sp_send_dbmail @profile_name='Metodosql',
--@recipients='i.rebellato@brevetti-cea.com',
--@subject='test',
--@body='come va?'