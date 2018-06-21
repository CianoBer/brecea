IF not EXISTS(select syscolumns.NAME from syscolumns where syscolumns.id=(select id from sysobjects where id =OBJECT_ID('STORICOMOVORDPROD') and sysobjects.XTYPE='U') and syscolumns.name='FLGEMESSOCICLO')
    alter table STORICOMOVORDPROD add FLGEMESSOCICLO smallint default 0
GO
