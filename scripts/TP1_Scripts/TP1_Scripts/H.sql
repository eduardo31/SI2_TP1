/*TRIGGER*/
/*SendMail*/
USE SoAventura

GO

IF OBJECT_ID('dbo.SendMail') IS NOT NULL
	DROP PROCEDURE dbo.SendMail
GO

CREATE PROCEDURE dbo.SendMail
@NIF numeric(9),
@MSG varchar(250)
AS
SET xact_abort ON 
BEGIN TRANSACTION
	IF NOT EXISTS (SELECT NIF FROM dbo.Cliente WHERE NIF = @NIF)  
		RAISERROR('Cliente INVÁLIDO!',15,1)
	DECLARE @email varchar(50)
	SELECT @email = email FROM dbo.Cliente WHERE NIF=@NIF
	IF @email=NULL  
		RAISERROR('EMAIL INVÁLIDO!',15,1)

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

DECLARE @INICIO DATE,@FIM DATE

SELECT @INICIO = GETDATE(),@FIM=DATEADD(day,@Dias,@INICIO)


	




/*Declare @Id int,@ANOEVENTO int,@fim_data_subscrição DATE,@min_participantes int,@Participantes int


While (Select Count(*) From dbo.Evento_Desportivo Where Processed=0 AND estado='em subscrição') > 0
Begin
	Select Top 1 @Id = Id_Evento,@ANOEVENTO=ano From dbo.Evento_Desportivo Where Processed=0 AND estado='em subscrição'

	SELECT @fim_data_subscrição = fim_data_subscrição,@min_participantes=min_participantes FROM dbo.Evento_Desportivo WHERE @Id = Id_Evento AND @ANOEVENTO=ano
	SELECT @Participantes = COUNT( NIF) FROM dbo.Subscrição WHERE @Id = Id_Evento AND @ANOEVENTO=ano

	IF (GETDATE()>=@fim_data_subscrição)
	BEGIN
		IF (@min_participantes<@Participantes)
			Update dbo.Evento_Desportivo Set estado='subscrito' Where Id_Evento = @Id AND ano=@ANOEVENTO
		ELSE
			Update dbo.Evento_Desportivo Set estado='cancelado' Where Id_Evento = @Id AND ano=@ANOEVENTO	
	END
	Update dbo.Evento_Desportivo Set Processed = 1 Where Id_Evento = @Id AND ano=@ANOEVENTO 
End*/



COMMIT
RETURN 

GO