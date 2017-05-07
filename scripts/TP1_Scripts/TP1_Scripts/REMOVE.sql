USE SoAventura

BEGIN TRANSACTION
	PRINT('Droping tables...')

	IF OBJECT_ID('dbo.MailsEnviados') IS NOT NULL
		DROP TABLE dbo.MailsEnviados

	IF OBJECT_ID('dbo.Fatura') IS NOT NULL
		DROP TABLE dbo.Fatura

	IF OBJECT_ID('dbo.Subscrição') IS NOT NULL
		DROP TABLE dbo.Subscrição

	IF OBJECT_ID('dbo.Cliente') IS NOT NULL
		DROP TABLE dbo.Cliente

	IF OBJECT_ID('dbo.trail') IS NOT NULL
		DROP TABLE dbo.trail
		
	IF OBJECT_ID('dbo.ciclismo') IS NOT NULL
		DROP TABLE dbo.ciclismo

	IF OBJECT_ID('dbo.escalada') IS NOT NULL
		DROP TABLE dbo.escalada

	IF OBJECT_ID('dbo.canoagem') IS NOT NULL
		DROP TABLE dbo.canoagem

	IF OBJECT_ID('dbo.Evento_Desportivo') IS NOT NULL
		DROP TABLE dbo.Evento_Desportivo

	PRINT('Tables droped.')
COMMIT
GO