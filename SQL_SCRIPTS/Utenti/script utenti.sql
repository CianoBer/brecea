IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.bovo')
 CREATE LOGIN [a.bovo] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'a.bovo'
EXEC sp_grantdbaccess N'a.bovo', N'a.bovo'
EXEC sp_addrolemember N'Metodo98', N'a.bovo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.norbiato')
 CREATE LOGIN [a.norbiato] WITH PASSWORD=N'A0409bdA', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'a.norbiato'
EXEC sp_grantdbaccess N'a.norbiato', N'a.norbiato'
EXEC sp_addrolemember N'Metodo98', N'a.norbiato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.zilio')
 CREATE LOGIN [a.zilio] WITH PASSWORD=N'pz0608uac', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'a.zilio'
EXEC sp_grantdbaccess N'a.zilio', N'a.zilio'
EXEC sp_addrolemember N'Metodo98', N'a.zilio'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='c.cenci')
 CREATE LOGIN [c.cenci] WITH PASSWORD=N'berber', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'c.cenci'
EXEC sp_grantdbaccess N'c.cenci', N'c.cenci'
EXEC sp_addrolemember N'Metodo98', N'c.cenci'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='c.moroni')
 CREATE LOGIN [c.moroni] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'c.moroni'
EXEC sp_grantdbaccess N'c.moroni', N'c.moroni'
EXEC sp_addrolemember N'Metodo98', N'c.moroni'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='c.tozzi')
 CREATE LOGIN [c.tozzi] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'c.tozzi'
EXEC sp_grantdbaccess N'c.tozzi', N'c.tozzi'
EXEC sp_addrolemember N'Metodo98', N'c.tozzi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='c.zampieri')
 CREATE LOGIN [c.zampieri] WITH PASSWORD=N'Raffaella', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'c.zampieri'
EXEC sp_grantdbaccess N'c.zampieri', N'c.zampieri'
EXEC sp_addrolemember N'Metodo98', N'c.zampieri'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='camcea')
 CREATE LOGIN [camcea] WITH PASSWORD=N'pa04cc11', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'camcea'
EXEC sp_grantdbaccess N'camcea', N'camcea'
EXEC sp_addrolemember N'Metodo98', N'camcea'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='cqcea1')
 CREATE LOGIN [cqcea1] WITH PASSWORD=N'allegri', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'cqcea1'
EXEC sp_grantdbaccess N'cqcea1', N'cqcea1'
EXEC sp_addrolemember N'Metodo98', N'cqcea1'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='cqcea2')
 CREATE LOGIN [cqcea2] WITH PASSWORD=N'allegri', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'cqcea2'
EXEC sp_grantdbaccess N'cqcea2', N'cqcea2'
EXEC sp_addrolemember N'Metodo98', N'cqcea2'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='d.bassani')
 CREATE LOGIN [d.bassani] WITH PASSWORD=N'db05yesok', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'd.bassani'
EXEC sp_grantdbaccess N'd.bassani', N'd.bassani'
EXEC sp_addrolemember N'Metodo98', N'd.bassani'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='d.dalbello')
 CREATE LOGIN [d.dalbello] WITH PASSWORD=N'dodi00', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'd.dalbello'
EXEC sp_grantdbaccess N'd.dalbello', N'd.dalbello'
EXEC sp_addrolemember N'Metodo98', N'd.dalbello'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='d.pavan')
 CREATE LOGIN [d.pavan] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'd.pavan'
EXEC sp_grantdbaccess N'd.pavan', N'd.pavan'
EXEC sp_addrolemember N'Metodo98', N'd.pavan'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.carolo')
 CREATE LOGIN [e.carolo] WITH PASSWORD=N'silvia', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.carolo'
EXEC sp_grantdbaccess N'e.carolo', N'e.carolo'
EXEC sp_addrolemember N'Metodo98', N'e.carolo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.cestonaro')
 CREATE LOGIN [e.cestonaro] WITH PASSWORD=N'sofiac', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.cestonaro'
EXEC sp_grantdbaccess N'e.cestonaro', N'e.cestonaro'
EXEC sp_addrolemember N'Metodo98', N'e.cestonaro'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.cinefra')
 CREATE LOGIN [e.cinefra] WITH PASSWORD=N'sovizzo', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.cinefra'
EXEC sp_grantdbaccess N'e.cinefra', N'e.cinefra'
EXEC sp_addrolemember N'Metodo98', N'e.cinefra'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.cudiferro')
 CREATE LOGIN [e.cudiferro] WITH PASSWORD=N'telefono', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.cudiferro'
EXEC sp_grantdbaccess N'e.cudiferro', N'e.cudiferro'
EXEC sp_addrolemember N'Metodo98', N'e.cudiferro'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.sartore')
 CREATE LOGIN [e.sartore] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.sartore'
EXEC sp_grantdbaccess N'e.sartore', N'e.sartore'
EXEC sp_addrolemember N'Metodo98', N'e.sartore'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.targon')
 CREATE LOGIN [e.targon] WITH PASSWORD=N'etmn08', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.targon'
EXEC sp_grantdbaccess N'e.targon', N'e.targon'
EXEC sp_addrolemember N'Metodo98', N'e.targon'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.brazzarola')
 CREATE LOGIN [f.brazzarola] WITH PASSWORD=N'paloma', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.brazzarola'
EXEC sp_grantdbaccess N'f.brazzarola', N'f.brazzarola'
EXEC sp_addrolemember N'Metodo98', N'f.brazzarola'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.carlotto')
 CREATE LOGIN [f.carlotto] WITH PASSWORD=N'fc0910rc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.carlotto'
EXEC sp_grantdbaccess N'f.carlotto', N'f.carlotto'
EXEC sp_addrolemember N'Metodo98', N'f.carlotto'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.festival')
 CREATE LOGIN [f.festival] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.festival'
EXEC sp_grantdbaccess N'f.festival', N'f.festival'
EXEC sp_addrolemember N'Metodo98', N'f.festival'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.lorenzi')
 CREATE LOGIN [f.lorenzi] WITH PASSWORD=N'fl02tabc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.lorenzi'
EXEC sp_grantdbaccess N'f.lorenzi', N'f.lorenzi'
EXEC sp_addrolemember N'Metodo98', N'f.lorenzi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.rossato')
 CREATE LOGIN [f.rossato] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.rossato'
EXEC sp_grantdbaccess N'f.rossato', N'f.rossato'
EXEC sp_addrolemember N'Metodo98', N'f.rossato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.valsecchi')
 CREATE LOGIN [f.valsecchi] WITH PASSWORD=N'frasson', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.valsecchi'
EXEC sp_grantdbaccess N'f.valsecchi', N'f.valsecchi'
EXEC sp_addrolemember N'Metodo98', N'f.valsecchi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='f.zanin')
 CREATE LOGIN [f.zanin] WITH PASSWORD=N'FZ0610us', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'f.zanin'
EXEC sp_grantdbaccess N'f.zanin', N'f.zanin'
EXEC sp_addrolemember N'Metodo98', N'f.zanin'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.castagna')
 CREATE LOGIN [g.castagna] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.castagna'
EXEC sp_grantdbaccess N'g.castagna', N'g.castagna'
EXEC sp_addrolemember N'Metodo98', N'g.castagna'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.castrignano')
 CREATE LOGIN [g.castrignano] WITH PASSWORD=N'giuliano', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.castrignano'
EXEC sp_grantdbaccess N'g.castrignano', N'g.castrignano'
EXEC sp_addrolemember N'Metodo98', N'g.castrignano'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.ferrari')
 CREATE LOGIN [g.ferrari] WITH PASSWORD=N'ndslmp09', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.ferrari'
EXEC sp_grantdbaccess N'g.ferrari', N'g.ferrari'
EXEC sp_addrolemember N'Metodo98', N'g.ferrari'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.giuriato')
 CREATE LOGIN [g.giuriato] WITH PASSWORD=N'g.giuriato', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.giuriato'
EXEC sp_grantdbaccess N'g.giuriato', N'g.giuriato'
EXEC sp_addrolemember N'Metodo98', N'g.giuriato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.peron')
 CREATE LOGIN [g.peron] WITH PASSWORD=N'carota2', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.peron'
EXEC sp_grantdbaccess N'g.peron', N'g.peron'
EXEC sp_addrolemember N'Metodo98', N'g.peron'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='g.visona')
 CREATE LOGIN [g.visona] WITH PASSWORD=N'giulia', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'g.visona'
EXEC sp_grantdbaccess N'g.visona', N'g.visona'
EXEC sp_addrolemember N'Metodo98', N'g.visona'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='i.baggio')
 CREATE LOGIN [i.baggio] WITH PASSWORD=N'latina', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'i.baggio'
EXEC sp_grantdbaccess N'i.baggio', N'i.baggio'
EXEC sp_addrolemember N'Metodo98', N'i.baggio'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='i.bagiacchi')
 CREATE LOGIN [i.bagiacchi] WITH PASSWORD=N'vpcecsbre003', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'i.bagiacchi'
EXEC sp_grantdbaccess N'i.bagiacchi', N'i.bagiacchi'
EXEC sp_addrolemember N'Metodo98', N'i.bagiacchi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='i.marra')
 CREATE LOGIN [i.marra] WITH PASSWORD=N'ilario', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'i.marra'
EXEC sp_grantdbaccess N'i.marra', N'i.marra'
EXEC sp_addrolemember N'Metodo98', N'i.marra'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='i.rebellato')
 CREATE LOGIN [i.rebellato] WITH PASSWORD=N'gaim9592', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'i.rebellato'
EXEC sp_grantdbaccess N'i.rebellato', N'i.rebellato'
EXEC sp_addrolemember N'Metodo98', N'i.rebellato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='i.vukadin')
 CREATE LOGIN [i.vukadin] WITH PASSWORD=N'sd0412npB', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'i.vukadin'
EXEC sp_grantdbaccess N'i.vukadin', N'i.vukadin'
EXEC sp_addrolemember N'Metodo98', N'i.vukadin'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.battaglia')
 CREATE LOGIN [l.battaglia] WITH PASSWORD=N'angela', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.battaglia'
EXEC sp_grantdbaccess N'l.battaglia', N'l.battaglia'
EXEC sp_addrolemember N'Metodo98', N'l.battaglia'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.dipietra')
 CREATE LOGIN [l.dipietra] WITH PASSWORD=N'ldp0708slm', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.dipietra'
EXEC sp_grantdbaccess N'l.dipietra', N'l.dipietra'
EXEC sp_addrolemember N'Metodo98', N'l.dipietra'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.montagna')
 CREATE LOGIN [l.montagna] WITH PASSWORD=N'edilkamin', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.montagna'
EXEC sp_grantdbaccess N'l.montagna', N'l.montagna'
EXEC sp_addrolemember N'Metodo98', N'l.montagna'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.piva')
 CREATE LOGIN [l.piva] WITH PASSWORD=N'lsdt0709', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.piva'
EXEC sp_grantdbaccess N'l.piva', N'l.piva'
EXEC sp_addrolemember N'Metodo98', N'l.piva'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.schenato')
 CREATE LOGIN [l.schenato] WITH PASSWORD=N'andrea', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.schenato'
EXEC sp_grantdbaccess N'l.schenato', N'l.schenato'
EXEC sp_addrolemember N'Metodo98', N'l.schenato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.brunelli')
 CREATE LOGIN [m.brunelli] WITH PASSWORD=N'mb0608pmbc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.brunelli'
EXEC sp_grantdbaccess N'm.brunelli', N'm.brunelli'
EXEC sp_addrolemember N'Metodo98', N'm.brunelli'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.colombara')
 CREATE LOGIN [m.colombara] WITH PASSWORD=N'm10Met', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.colombara'
EXEC sp_grantdbaccess N'm.colombara', N'm.colombara'
EXEC sp_addrolemember N'Metodo98', N'm.colombara'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.cozzuol')
 CREATE LOGIN [m.cozzuol] WITH PASSWORD=N'Mus1110C', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.cozzuol'
EXEC sp_grantdbaccess N'm.cozzuol', N'm.cozzuol'
EXEC sp_addrolemember N'Metodo98', N'm.cozzuol'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.frasson')
 CREATE LOGIN [m.frasson] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.frasson'
EXEC sp_grantdbaccess N'm.frasson', N'm.frasson'
EXEC sp_addrolemember N'Metodo98', N'm.frasson'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.milan')
 CREATE LOGIN [m.milan] WITH PASSWORD=N'M0311udB', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.milan'
EXEC sp_grantdbaccess N'm.milan', N'm.milan'
EXEC sp_addrolemember N'Metodo98', N'm.milan'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.moscon')
 CREATE LOGIN [m.moscon] WITH PASSWORD=N'moscon', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.moscon'
EXEC sp_grantdbaccess N'm.moscon', N'm.moscon'
EXEC sp_addrolemember N'Metodo98', N'm.moscon'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.panozzo')
 CREATE LOGIN [m.panozzo] WITH PASSWORD=N'annaleo', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.panozzo'
EXEC sp_grantdbaccess N'm.panozzo', N'm.panozzo'
EXEC sp_addrolemember N'Metodo98', N'm.panozzo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.sartor')
 CREATE LOGIN [m.sartor] WITH PASSWORD=N'samsam', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.sartor'
EXEC sp_grantdbaccess N'm.sartor', N'm.sartor'
EXEC sp_addrolemember N'Metodo98', N'm.sartor'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.sbalchiero')
 CREATE LOGIN [m.sbalchiero] WITH PASSWORD=N'mry0708trctrc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.sbalchiero'
EXEC sp_grantdbaccess N'm.sbalchiero', N'm.sbalchiero'
EXEC sp_addrolemember N'Metodo98', N'm.sbalchiero'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.tognato')
 CREATE LOGIN [m.tognato] WITH PASSWORD=N'd0608muc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.tognato'
EXEC sp_grantdbaccess N'm.tognato', N'm.tognato'
EXEC sp_addrolemember N'Metodo98', N'm.tognato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='m.trentin')
 CREATE LOGIN [m.trentin] WITH PASSWORD=N'SOLUZIONI', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'm.trentin'
EXEC sp_grantdbaccess N'm.trentin', N'm.trentin'
EXEC sp_addrolemember N'Metodo98', N'm.trentin'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='magcea1')
 CREATE LOGIN [magcea1] WITH PASSWORD=N'mg08ctds1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'magcea1'
EXEC sp_grantdbaccess N'magcea1', N'magcea1'
EXEC sp_addrolemember N'Metodo98', N'magcea1'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='magcea2')
 CREATE LOGIN [magcea2] WITH PASSWORD=N'mg08ctds1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'magcea2'
EXEC sp_grantdbaccess N'magcea2', N'magcea2'
EXEC sp_addrolemember N'Metodo98', N'magcea2'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='magcea3')
 CREATE LOGIN [magcea3] WITH PASSWORD=N'mg08ctds1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'magcea3'
EXEC sp_grantdbaccess N'magcea3', N'magcea3'
EXEC sp_addrolemember N'Metodo98', N'magcea3'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='magcea4')
 CREATE LOGIN [magcea4] WITH PASSWORD=N'mg08ctds1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'magcea4'
EXEC sp_grantdbaccess N'magcea4', N'magcea4'
EXEC sp_addrolemember N'Metodo98', N'magcea4'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='magcea5')
 CREATE LOGIN [magcea5] WITH PASSWORD=N'mg08ctds1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'magcea5'
EXEC sp_grantdbaccess N'magcea5', N'magcea5'
EXEC sp_addrolemember N'Metodo98', N'magcea5'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='n.creazzo')
 CREATE LOGIN [n.creazzo] WITH PASSWORD=N'nicolasette', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'n.creazzo'
EXEC sp_grantdbaccess N'n.creazzo', N'n.creazzo'
EXEC sp_addrolemember N'Metodo98', N'n.creazzo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='n.galvan')
 CREATE LOGIN [n.galvan] WITH PASSWORD=N'NG0210aua', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'n.galvan'
EXEC sp_grantdbaccess N'n.galvan', N'n.galvan'
EXEC sp_addrolemember N'Metodo98', N'n.galvan'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='o.bonazzo')
 CREATE LOGIN [o.bonazzo] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'o.bonazzo'
EXEC sp_grantdbaccess N'o.bonazzo', N'o.bonazzo'
EXEC sp_addrolemember N'Metodo98', N'o.bonazzo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='p.zoppelletto')
 CREATE LOGIN [p.zoppelletto] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'p.zoppelletto'
EXEC sp_grantdbaccess N'p.zoppelletto', N'p.zoppelletto'
EXEC sp_addrolemember N'Metodo98', N'p.zoppelletto'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea1')
 CREATE LOGIN [prdcea1] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea1'
EXEC sp_grantdbaccess N'prdcea1', N'prdcea1'
EXEC sp_addrolemember N'Metodo98', N'prdcea1'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea2')
 CREATE LOGIN [prdcea2] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea2'
EXEC sp_grantdbaccess N'prdcea2', N'prdcea2'
EXEC sp_addrolemember N'Metodo98', N'prdcea2'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea3')
 CREATE LOGIN [prdcea3] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea3'
EXEC sp_grantdbaccess N'prdcea3', N'prdcea3'
EXEC sp_addrolemember N'Metodo98', N'prdcea3'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea4')
 CREATE LOGIN [prdcea4] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea4'
EXEC sp_grantdbaccess N'prdcea4', N'prdcea4'
EXEC sp_addrolemember N'Metodo98', N'prdcea4'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea5')
 CREATE LOGIN [prdcea5] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea5'
EXEC sp_grantdbaccess N'prdcea5', N'prdcea5'
EXEC sp_addrolemember N'Metodo98', N'prdcea5'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea6')
 CREATE LOGIN [prdcea6] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea6'
EXEC sp_grantdbaccess N'prdcea6', N'prdcea6'
EXEC sp_addrolemember N'Metodo98', N'prdcea6'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea7')
 CREATE LOGIN [prdcea7] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea7'
EXEC sp_grantdbaccess N'prdcea7', N'prdcea7'
EXEC sp_addrolemember N'Metodo98', N'prdcea7'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='prdcea8')
 CREATE LOGIN [prdcea8] WITH PASSWORD=N'pippo123', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'prdcea8'
EXEC sp_grantdbaccess N'prdcea8', N'prdcea8'
EXEC sp_addrolemember N'Metodo98', N'prdcea8'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='r.cortese')
 CREATE LOGIN [r.cortese] WITH PASSWORD=N'ROSETTA', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'r.cortese'
EXEC sp_grantdbaccess N'r.cortese', N'r.cortese'
EXEC sp_addrolemember N'Metodo98', N'r.cortese'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='r.merlo')
 CREATE LOGIN [r.merlo] WITH PASSWORD=N'Rtp1009', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'r.merlo'
EXEC sp_grantdbaccess N'r.merlo', N'r.merlo'
EXEC sp_addrolemember N'Metodo98', N'r.merlo'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='r.palma')
 CREATE LOGIN [r.palma] WITH PASSWORD=N'terminale', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'r.palma'
EXEC sp_grantdbaccess N'r.palma', N'r.palma'
EXEC sp_addrolemember N'Metodo98', N'r.palma'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='r.rossato')
 CREATE LOGIN [r.rossato] WITH PASSWORD=N'sandra', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'r.rossato'
EXEC sp_grantdbaccess N'r.rossato', N'r.rossato'
EXEC sp_addrolemember N'Metodo98', N'r.rossato'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='s.battistella')
 CREATE LOGIN [s.battistella] WITH PASSWORD=N's.battistella', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N's.battistella'
EXEC sp_grantdbaccess N's.battistella', N's.battistella'
EXEC sp_addrolemember N'Metodo98', N's.battistella'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='s.campanella')
 CREATE LOGIN [s.campanella] WITH PASSWORD=N'SC0110sbc', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N's.campanella'
EXEC sp_grantdbaccess N's.campanella', N's.campanella'
EXEC sp_addrolemember N'Metodo98', N's.campanella'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='s.fontana')
 CREATE LOGIN [s.fontana] WITH PASSWORD=N'sf0708gdp', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N's.fontana'
EXEC sp_grantdbaccess N's.fontana', N's.fontana'
EXEC sp_addrolemember N'Metodo98', N's.fontana'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='s.tolio')
 CREATE LOGIN [s.tolio] WITH PASSWORD=N's.tolio', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N's.tolio'
EXEC sp_grantdbaccess N's.tolio', N's.tolio'
EXEC sp_addrolemember N'Metodo98', N's.tolio'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='t.lanaro')
 CREATE LOGIN [t.lanaro] WITH PASSWORD=N'tiziano', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N't.lanaro'
EXEC sp_grantdbaccess N't.lanaro', N't.lanaro'
EXEC sp_addrolemember N'Metodo98', N't.lanaro'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.scarpulla')
 CREATE LOGIN [a.scarpulla] WITH PASSWORD=N'ventus', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'a.scarpulla'
EXEC sp_grantdbaccess N'a.scarpulla', N'a.scarpulla'
EXEC sp_addrolemember N'Metodo98', N'a.scarpulla'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='l.gastaldi')
 CREATE LOGIN [l.gastaldi] WITH PASSWORD=N'gastaldi', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'l.gastaldi'
EXEC sp_grantdbaccess N'l.gastaldi', N'l.gastaldi'
EXEC sp_addrolemember N'Metodo98', N'l.gastaldi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.rigon')
 CREATE LOGIN [e.rigon] WITH PASSWORD=N'Michael', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'e.rigon'
EXEC sp_grantdbaccess N'e.rigon', N'e.rigon'
EXEC sp_addrolemember N'Metodo98', N'e.rigon'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='v.pistininzi')
 CREATE LOGIN [v.pistininzi] WITH PASSWORD=N'Vd11lucB', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'v.pistininzi'
EXEC sp_grantdbaccess N'v.pistininzi', N'v.pistininzi'
EXEC sp_addrolemember N'Metodo98', N'v.pistininzi'
GO
IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='r.bicego')
 CREATE LOGIN [r.bicego] WITH PASSWORD=N'starlight1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_revokedbaccess N'r.bicego'
EXEC sp_grantdbaccess N'r.bicego', N'r.bicego'
EXEC sp_addrolemember N'Metodo98', N'r.bicego'
GO

IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='e.dagostini')
 CREATE LOGIN [e.dagostini] WITH PASSWORD=N'Sted8me*', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'e.dagostini')
EXEC sp_revokedbaccess N'e.dagostini'
EXEC sp_grantdbaccess N'e.dagostini', N'e.dagostini'
EXEC sp_addrolemember N'Metodo98', N'e.dagostini'
GO

IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='a.zarantonello')
 CREATE LOGIN [a.zarantonello] WITH PASSWORD=N'j4-UxeSp', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'a.zarantonello')
EXEC sp_revokedbaccess N'a.zarantonello'
EXEC sp_grantdbaccess N'a.zarantonello', N'a.zarantonello'
EXEC sp_addrolemember N'Metodo98', N'a.zarantonello'
GO

IF NOT EXISTS(SELECT 1 FROM MASTER.DBO.SYSLOGINS WHERE LOGINNAME ='c.raschietti')
 CREATE LOGIN [c.raschietti] WITH PASSWORD=N'C313ciMB', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'c.raschietti')
EXEC sp_revokedbaccess N'c.raschietti'
EXEC sp_grantdbaccess N'c.raschietti', N'c.raschietti'
EXEC sp_addrolemember N'Metodo98', N'c.raschietti'
GO







































