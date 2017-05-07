USE master
GO
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'SoAventura')
	BEGIN
		PRINT('Creating database named SoAventura...')
		CREATE DATABASE SoAventura
		PRINT('Database created.')
	END
ELSE
	PRINT('Database already created.')

GO 

USE SoAventura

IF OBJECT_ID('dbo.Evento_Desportivo') is null
	CREATE TABLE dbo.Evento_Desportivo(
		Id_Evento int,
		ano int ,/*year()*/
		data_da_realização datetime,
		data_limite_pagamento date,
		fim_data_subscrição date,
		inicio_data_subscrição date,
		idade_min int,
		idade_max int,
		estado varchar(13),
		min_participantes int,
		max_participantes int,
		descrição varchar(50),
		preço_por_participante smallmoney,
		Processed BIT DEFAULT 0,
		PRIMARY KEY (Id_Evento,ano),
		CHECK(estado=NULL or estado='em subscrição' or estado='subscrito' or estado='concluído' or estado='cancelado')
	)

GO

IF OBJECT_ID('dbo.canoagem') is null
	CREATE TABLE dbo.canoagem(
		Id_Evento int,
		ano int,
		/*constraint fk1_Id_Evento,fk1_ano foreign key(Id_Evento,ano) references Evento_Desportivo,
		constraint fk1_Id_Evento foreign key(Id_Evento) references Evento_Desportivo,*/
		dificuldade int,
		CHECK(dificuldade>0 and dificuldade<6),
		foreign key(Id_Evento,ano)references Evento_Desportivo(Id_Evento,ano),
		PRIMARY KEY(Id_Evento,ano)
	)

IF OBJECT_ID('dbo.escalada') is null
	CREATE TABLE dbo.escalada(
		Id_Evento int,
		ano int,
		dificuldade int,
		CHECK(dificuldade>0 and dificuldade<6),
		foreign key(Id_Evento,ano)references Evento_Desportivo(Id_Evento,ano),
		PRIMARY KEY(Id_Evento,ano)
	)
IF OBJECT_ID('dbo.ciclismo') is null
	CREATE TABLE dbo.ciclismo(
		Id_Evento int,
		ano int,
		distancia int,
		CHECK(distancia>0 and distancia<6),
		foreign key(Id_Evento,ano)references Evento_Desportivo(Id_Evento,ano),
		PRIMARY KEY(Id_Evento,ano)
	)
IF OBJECT_ID('dbo.trail') is null
	CREATE TABLE dbo.trail(
		Id_Evento int,
		ano int,
		distancia int,
		CHECK(distancia>0 and distancia<6),
		foreign key(Id_Evento,ano)references Evento_Desportivo(Id_Evento,ano),
		PRIMARY KEY(Id_Evento,ano)
	)

GO
IF OBJECT_ID('dbo.Cliente') is null
	CREATE TABLE dbo.Cliente(
		Nome varchar(50),
		NIF numeric(9),
		CC numeric(9),
		Morada varchar(50),
		email varchar(50),
		data_nascimento date,
		existente varchar(1) default 'T' CHECK(existente = 'T' OR existente = 'F'),
		PRIMARY KEY(NIF)
	)
GO
IF OBJECT_ID('dbo.Subscrição') is null
	CREATE TABLE dbo.Subscrição(
		Id_Evento int,
		ano int,
		NIF numeric(9)foreign key references Cliente(NIF),
		foreign key(Id_Evento,ano)references Evento_Desportivo(Id_Evento,ano),
		PRIMARY KEY(Id_Evento,ano,NIF)
	)
GO
IF OBJECT_ID('dbo.Fatura') is null
	CREATE TABLE dbo.Fatura (
		Id_Evento int,
		ano int,
		Id_Factura int,
		montante smallmoney,
		data_pagamento datetime,
		descricao varchar(50),
		Nome varchar(50),
		Morada varchar(50),
		NIF numeric(9),
		foreign key(Id_Evento,ano,NIF)references Subscrição(Id_Evento,ano,NIF)
	)
GO
IF OBJECT_ID('dbo.MailsEnviados') is null
	CREATE TABLE dbo.MailsEnviados (
		NIF numeric(9),
		email varchar(50),
		MSG varchar(8000)
		PRIMARY KEY(NIF)
	)