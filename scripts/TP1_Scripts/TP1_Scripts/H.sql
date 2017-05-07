/*TRIGGER*/
/*SendMail*/
USE SoAventura

GO

IF OBJECT_ID('dbo.SendMail') IS NOT NULL
	DROP PROCEDURE dbo.SendMail
GO

CREATE PROCEDURE dbo.SendMail
@NIF numeric(9),
@MSG varchar(8000)
AS
SET xact_abort ON 
BEGIN TRANSACTION
	IF NOT EXISTS (SELECT NIF FROM dbo.Cliente WHERE NIF = @NIF)  
		RAISERROR('Cliente INV�LIDO!',15,1)
	DECLARE @email varchar(50)
	SELECT @email = email FROM dbo.Cliente WHERE NIF=@NIF
	IF @email=NULL  
		RAISERROR('EMAIL INV�LIDO!',15,1)

	INSERT INTO dbo.MailsEnviados(NIF, email, MSG) VALUES (@NIF,@email,@MSG)
COMMIT
RETURN 

GO

IF OBJECT_ID('dbo.EnviarMailIntervalo') IS NOT NULL
	DROP PROCEDURE dbo.EnviarMailIntervalo
GO

CREATE PROCEDURE dbo.EnviarMailIntervalo
@Dias INT
AS
SET xact_abort ON 
BEGIN TRANSACTION

DECLARE @INICIO DATE,@FIM DATE,@Id int,@ANOEVENTO int,@data_da_realiza��o datetime

SELECT @INICIO = GETDATE(),@FIM=DATEADD(day,@Dias,@INICIO)

While (Select Count(*) From dbo.Evento_Desportivo Where Processed=0 AND (estado='em subscri��o' OR estado='subscrito')) > 0
Begin
	Select Top 1 @Id = Id_Evento,@ANOEVENTO=ano From dbo.Evento_Desportivo Where Processed=0 AND (estado='em subscri��o' OR estado='subscrito')

	SELECT @data_da_realiza��o=data_da_realiza��o FROM dbo.Evento_Desportivo WHERE @Id = Id_Evento AND @ANOEVENTO=ano

	IF (@data_da_realiza��o>=@INICIO AND @data_da_realiza��o<=@FIM)
	BEGIN
		/*CRIAR A MENSAGEM*/
		declare @MENSAGEM varchar(8000)
		set     @MENSAGEM = 'Gostariamos de o avisar que o evento '
		select  @MENSAGEM = @MENSAGEM + cast(Id_Evento as varchar(20)) + ', ' + cast(descri��o as varchar(50)) + ', vai se realizar a '+ CONVERT(VARCHAR, data_da_realiza��o, 120)+cast(data_da_realiza��o as varchar(20)) + '|'
		from    dbo.Evento_Desportivo WHERE Id_Evento = @Id AND ano=@ANOEVENTO
		/*group by cat_id*/
		option(maxdop 1)/**/
		/*print @MENSAGEM*/

		/*ENVIAR EMAIL*/
		DECLARE @NIF numeric(9)
		SELECT @NIF=(SELECT NIF FROM DBO.Subscri��o WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
		EXEC dbo.SendMail @NIF,@MENSAGEM
	END
	Update dbo.Evento_Desportivo Set Processed = 1 Where Id_Evento = @Id AND ano=@ANOEVENTO 
End
Update dbo.Evento_Desportivo Set Processed = 0 Where Id_Evento = @Id AND ano=@ANOEVENTO AND Processed = 1

COMMIT
RETURN 

GO