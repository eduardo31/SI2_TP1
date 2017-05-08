USE SoAventura

GO

IF OBJECT_ID('dbo.InsertCliente') IS NOT NULL
	DROP PROCEDURE dbo.InsertCliente
GO

CREATE PROCEDURE dbo.InsertCliente
	@Nome varchar(50) = NULL,
	@NIF numeric(9) output,
	@CC numeric(9) = NULL,
	@Morada varchar(50) = NULL,
	@email varchar(50) = NULL,
	@data_nascimento date = NULL
AS
SET xact_abort ON 
BEGIN TRANSACTION
	INSERT INTO dbo.Cliente(Nome, NIF, CC, Morada, email, data_nascimento) VALUES (@Nome, @NIF, @CC, @Morada, @email, @data_nascimento)
	/*SELECT @NIF = SCOPE_IDENTITY()*/
COMMIT
RETURN

/*INSERT INTO dbo.Cliente(Nome, NIF, CC, Morada, email, data_nascimento)
VALUES('Jose Manel',111111111,100000000,'Rua das batatas 44 RC','JoseManel37@sapo.pt','1963-05-13');
PRINT('Database created.')*/


GO

IF OBJECT_ID('dbo.UpdateCliente') IS NOT NULL
	DROP PROCEDURE dbo.UpdateCliente
GO

CREATE PROCEDURE dbo.UpdateCliente
	@Nome varchar(50) = NULL,
	@NIF numeric(9) output,
	@CC numeric(9) = NULL,
	@Morada varchar(50) = NULL,
	@email varchar(50) = NULL,
	@data_nascimento date = NULL

AS
SET xact_abort on 
SET TRANSACTION ISOLATION LEVEL  REPEATABLE READ --porque faz varias leituras
BEGIN TRANSACTION
IF (SELECT existente FROM dbo.Cliente WHERE NIF=@NIF) = 'F'
	PRINT N'There is no Client with that id'
ELSE IF @NIF IS NOT NULL
BEGIN
	IF @Nome IS NULL
		SET @Nome = (SELECT Nome FROM dbo.Cliente WHERE NIF = @NIF)
	IF @CC IS NULL
		SET @CC = (SELECT CC FROM dbo.Cliente WHERE NIF = @NIF)
	IF @Morada IS NULL
		SET @Morada = (SELECT Morada FROM dbo.Cliente WHERE NIF = @NIF)
	IF @email IS NULL
		SET @email = (SELECT email FROM dbo.Cliente WHERE NIF = @NIF)
	IF @data_nascimento IS NULL
		SET @data_nascimento = (SELECT data_nascimento FROM dbo.Cliente WHERE NIF = @NIF)
	UPDATE dbo.Cliente SET Nome=@Nome, @CC=CC, Morada=@Morada, email=@email, data_nascimento=@data_nascimento WHERE NIF = @NIF
END
ELSE
	PRINT N'Porfavor forneça um NIF para o cliente'
COMMIT

/*UPDATE dbo.Cliente 
SET CC=200000000, data_nascimento='1963-05-12'
WHERE NIF = 111111111 ;*/

GO

IF OBJECT_ID('dbo.DeleteCliente') IS NOT NULL
	DROP PROCEDURE dbo.DeleteCliente
GO

CREATE PROCEDURE dbo.DeleteCliente
@NIF int
AS
SET xact_abort ON 
BEGIN TRANSACTION
IF @NIF IS NULL
	RAISERROR('NIF nao pode ser null',15,1)
ELSE IF NOT EXISTS(SELECT NIF FROM dbo.Cliente where NIF = @NIF)
	RAISERROR('Não existe um cliente com este NIF!',15,1)
ELSE
	UPDATE dbo.Cliente SET existente='F' WHERE NIF = @NIF
COMMIT

/*DELETE FROM dbo.Cliente
WHERE Nome='Jose Manel';*/