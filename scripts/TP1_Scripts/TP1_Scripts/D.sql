USE SoAventura

GO

IF OBJECT_ID('dbo.InsertEvento') IS NOT NULL
	DROP PROCEDURE dbo.InsertEvento
GO

CREATE PROCEDURE dbo.InsertEvento
	/*@ID int output,*/
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	/*DECLARE @ID INT*/
	DECLARE @ID INT

	SELECT @ID = max(Id_Evento) FROM dbo.Evento_Desportivo WHERE ano=@ano

	IF @ID IS NULL
		SET @ID=0
	SET @ID=@ID+1

	INSERT INTO dbo.Evento_Desportivo(Id_Evento, ano, data_da_realiza��o, data_limite_pagamento, fim_data_subscri��o, inicio_data_subscri��o, idade_min, idade_max, estado, min_participantes, max_participantes, descri��o, pre�o_por_participante) 
	VALUES (@ID, @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, NULL, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante)
	PRINT @ID
	COMMIT
	RETURN @ID

GO

IF OBJECT_ID ('dbo.UpdateEvento') IS NOT NULL
	DROP PROCEDURE dbo.UpdateEvento
GO

CREATE PROCEDURE dbo.UpdateEvento 
	@Id_Evento int output,
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL
AS/*fatura nao � fraca*/
SET XACT_ABORT ON
BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Id_Evento INV�LIDO!',15,1)

	IF @data_da_realiza��o IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET data_da_realiza��o = @data_da_realiza��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @data_limite_pagamento IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET data_limite_pagamento = @data_limite_pagamento WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @fim_data_subscri��o IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET fim_data_subscri��o = @fim_data_subscri��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @inicio_data_subscri��o IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET inicio_data_subscri��o = @inicio_data_subscri��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @inicio_data_subscri��o IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET inicio_data_subscri��o = @inicio_data_subscri��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @idade_min IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET idade_min = @idade_min WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @idade_max IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET idade_max = @idade_max WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @estado IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET estado = @estado WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @min_participantes IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET min_participantes = @min_participantes WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @max_participantes IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET max_participantes = @max_participantes WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @descri��o IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET descri��o = @descri��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	IF @pre�o_por_participante IS NOT NULL
		UPDATE dbo.Evento_Desportivo SET pre�o_por_participante = @pre�o_por_participante WHERE Id_Evento = @Id_Evento AND ano=@ano
COMMIT 

GO

IF OBJECT_ID ('dbo.RemoveEvento') IS NOT NULL
	DROP PROCEDURE dbo.RemoveEvento
GO

CREATE PROCEDURE dbo.RemoveEvento 
	@Id_Evento int output,
	@ano int output
AS
SET xact_abort ON 
BEGIN TRANSACTION
IF EXISTS(SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)
BEGIN
	DELETE FROM dbo.canoagem WHERE Id_Evento = @Id_Evento AND ano=@ano
	DELETE FROM dbo.ciclismo WHERE Id_Evento = @Id_Evento AND ano=@ano
	DELETE FROM dbo.trail WHERE Id_Evento = @Id_Evento AND ano=@ano
	DELETE FROM dbo.escalada WHERE Id_Evento = @Id_Evento AND ano=@ano

	DELETE FROM dbo.Fatura WHERE Id_Evento = @Id_Evento AND ano=@ano
	DELETE FROM dbo.Subscri��o WHERE Id_Evento = @Id_Evento AND ano=@ano

	DELETE FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano
END
ELSE
	RAISERROR('Evento inv�lido ou ID_Evento/ano inv�lidos!',15,1)
COMMIT


GO














IF OBJECT_ID('dbo.InsertEventoCanoagem') IS NOT NULL
	DROP PROCEDURE dbo.InsertEventoCanoagem
GO

CREATE PROCEDURE dbo.InsertEventoCanoagem
	/*@ID int output,*/
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@dificuldade int=NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	DECLARE @ID INT
	exec @ID =  dbo.InsertEvento /*@ID,*/ @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, NULL, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	/*SELECT */
	PRINT @ID
	INSERT INTO dbo.canoagem(Id_Evento, ano, dificuldade)
	VALUES(@ID, @ano, @dificuldade)
	PRINT @ID
COMMIT
RETURN 

GO

IF OBJECT_ID('dbo.InsertEventoEscalada') IS NOT NULL
	DROP PROCEDURE dbo.InsertEventoEscalada
GO

CREATE PROCEDURE dbo.InsertEventoEscalada
	/*@ID int output,*/
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@dificuldade int=NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	DECLARE @ID INT
	exec @ID =dbo.InsertEvento/* @ID,*/ @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, NULL, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	PRINT @ID
	INSERT INTO dbo.escalada(Id_Evento, ano, dificuldade)
	VALUES(@ID, @ano, @dificuldade)
	PRINT @ID
COMMIT
RETURN 

GO

IF OBJECT_ID('dbo.InsertEventoCiclismo') IS NOT NULL
	DROP PROCEDURE dbo.InsertEventoCiclismo
GO

CREATE PROCEDURE dbo.InsertEventoCiclismo
	/*@ID int output,*/
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@distancia int=NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	DECLARE @ID INT
	exec @ID =dbo.InsertEvento /*@ID,*/ @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, NULL, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	PRINT @ID
	INSERT INTO dbo.ciclismo(Id_Evento, ano, distancia)
	VALUES(@ID, @ano, @distancia)
	PRINT @ID
COMMIT
RETURN 

GO

IF OBJECT_ID('dbo.InsertEventoTrail') IS NOT NULL
	DROP PROCEDURE dbo.InsertEventoTrail
GO

CREATE PROCEDURE dbo.InsertEventoTrail
	/*@ID int output,*/
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@distancia int=NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	DECLARE @ID INT
	exec @ID = dbo.InsertEvento /*@ID,*/ @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, NULL, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	PRINT @ID
	INSERT INTO dbo.trail(Id_Evento, ano, distancia)
	VALUES(@ID, @ano, @distancia)
	PRINT @ID
COMMIT
RETURN 


GO















IF OBJECT_ID ('dbo.UpdateEventoCanoagem') IS NOT NULL
	DROP PROCEDURE dbo.UpdateEventoCanoagem
GO

CREATE PROCEDURE dbo.UpdateEventoCanoagem 
	@Id_Evento int output,
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@dificuldade int=NULL
AS
SET XACT_ABORT ON
BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Id_Evento_CANOAGEM INV�LIDO!',15,1)
    exec dbo.UpdateEvento @ID_Evento, @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, @estado, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	IF @dificuldade IS NOT NULL
		UPDATE dbo.canoagem SET dificuldade = @dificuldade WHERE Id_Evento = @Id_Evento AND ano=@ano
COMMIT 

GO

IF OBJECT_ID ('dbo.UpdateEventoEscalada') IS NOT NULL
	DROP PROCEDURE dbo.UpdateEventoEscalada
GO

CREATE PROCEDURE dbo.UpdateEventoEscalada 
	@Id_Evento int output,
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@dificuldade int=NULL
AS
SET XACT_ABORT ON
BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Id_Evento_ESCALADA INV�LIDO!',15,1)
    exec dbo.UpdateEvento @ID_Evento, @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, @estado, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	IF @dificuldade IS NOT NULL
		UPDATE dbo.escalada SET dificuldade = @dificuldade WHERE Id_Evento = @Id_Evento AND ano=@ano
COMMIT 

GO

IF OBJECT_ID ('dbo.UpdateEventoCiclismo') IS NOT NULL
	DROP PROCEDURE dbo.UpdateEventoCiclismo
GO

CREATE PROCEDURE dbo.UpdateEventoCiclismo 
	@Id_Evento int output,
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@distancia int=NULL
AS
SET XACT_ABORT ON
BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Id_Evento_Ciclismo INV�LIDO!',15,1)
    exec dbo.UpdateEvento @ID_Evento, @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, @estado, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	IF @distancia IS NOT NULL
		UPDATE dbo.Ciclismo SET distancia = @distancia WHERE Id_Evento = @Id_Evento AND ano=@ano
COMMIT 

GO

IF OBJECT_ID ('dbo.UpdateEventoTrail') IS NOT NULL
	DROP PROCEDURE dbo.UpdateEventoTrail
GO

CREATE PROCEDURE dbo.UpdateEventoTrail 
	@Id_Evento int output,
	@ano int output,
	@data_da_realiza��o datetime= NULL,
	@data_limite_pagamento date= NULL,
	@fim_data_subscri��o date= NULL,
	@inicio_data_subscri��o date= NULL,
	@idade_min int= NULL,
	@idade_max int= NULL,
	@estado varchar(13)= NULL,
	@min_participantes int= NULL,
	@max_participantes int= NULL,
	@descri��o varchar(50)= NULL,
	@pre�o_por_participante smallmoney= NULL,
	@distancia int=NULL
AS
SET XACT_ABORT ON
BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Id_Evento_Trail INV�LIDO!',15,1)
    exec dbo.UpdateEvento @ID_Evento, @ano, @data_da_realiza��o, @data_limite_pagamento, @fim_data_subscri��o, @inicio_data_subscri��o, @idade_min, @idade_max, @estado, @min_participantes, @max_participantes, @descri��o, @pre�o_por_participante
	IF @distancia IS NOT NULL
		UPDATE dbo.trail SET distancia = @distancia WHERE Id_Evento = @Id_Evento AND ano=@ano
COMMIT 

GO