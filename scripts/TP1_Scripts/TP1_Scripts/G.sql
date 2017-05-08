USE SoAventura


GO
/*pagamento*/
IF OBJECT_ID('dbo.VerificarEstados') IS NOT NULL
	DROP PROCEDURE dbo.VerificarEstados
GO

CREATE PROCEDURE dbo.VerificarEstados
AS
SET xact_abort ON 
BEGIN TRANSACTION

	Declare @Id int,@ANOEVENTO int,@fim_data_subscri��o DATE,@inicio_data_subscri��o DATE,@min_participantes int,@Participantes int, @dataCurrente DATETIME,@data_da_realiza��o DATETIME
	
	SELECT @dataCurrente = GETDATE()

	While (Select Count(*) From dbo.Evento_Desportivo Where Processed=0) > 0
	Begin
		Select Top 1 @Id = Id_Evento,@ANOEVENTO=ano, @fim_data_subscri��o = fim_data_subscri��o,@inicio_data_subscri��o=inicio_data_subscri��o,@min_participantes=min_participantes,@data_da_realiza��o=data_da_realiza��o From dbo.Evento_Desportivo Where Processed=0
		
		/*atualizar os que ja entraram em subscri��o*/

		IF(@dataCurrente>=@inicio_data_subscri��o /*AND @estado IS NULL*/)
		BEGIN
			UPDATE  dbo.Evento_Desportivo SET estado='em subscri��o' WHERE @Id = Id_Evento AND @ANOEVENTO=ano AND (estado IS NULL)
			/*exec dbo.UpdateEvento @Id_Evento=@Id,@ano=@ANOEVENTO, @estado='em subscri��o'*/
		END
		
		/*atualizar os que ja subscreveram*/
		SELECT @Participantes = COUNT( NIF) FROM dbo.Subscri��o WHERE @Id = Id_Evento AND @ANOEVENTO=ano

		IF (@dataCurrente>=@fim_data_subscri��o)
		BEGIN
			IF (@min_participantes<@Participantes)
				Update dbo.Evento_Desportivo Set estado='subscrito' Where Id_Evento = @Id AND ano=@ANOEVENTO AND estado = 'em subscri��o'
			ELSE
				Update dbo.Evento_Desportivo Set estado='cancelado' Where Id_Evento = @Id AND ano=@ANOEVENTO AND estado = 'em subscri��o'	
		END

		/*atualizar os que ja acabaram*/
		IF(@dataCurrente>=@data_da_realiza��o)
		BEGIN
		UPDATE  dbo.Evento_Desportivo SET estado='conclu�do' WHERE Id_Evento = @Id AND ano=@ANOEVENTO AND estado='subscrito'
		END

		Update dbo.Evento_Desportivo Set Processed = 1 Where Id_Evento = @Id AND ano=@ANOEVENTO 
	End
	
	Update dbo.Evento_Desportivo Set Processed = 0 Where Processed = 1
	
	
COMMIT
RETURN 

GO

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN 

if OBJECT_ID('dbo.estadoEvento') is not null
	drop trigger dbo.estadoEvento

GO

create trigger dbo.estadoEvento on dbo.Evento_Desportivo
after update
as
	if update(estado)
	BEGIN
		SET NOCOUNT ON;
 
		DECLARE @Id int,@ANOEVENTO int
 
		SELECT @Id = INSERTED.Id_Evento , @ANOEVENTO = INSERTED.ano FROM INSERTED
		
		/*CRIAR A MENSAGEM*/
		declare @MENSAGEM varchar(8000)
		set     @MENSAGEM = 'Gostariamos de o avisar que o evento '
		select  @MENSAGEM = @MENSAGEM + cast(Id_Evento as varchar(20)) + ', ' + cast(descri��o as varchar(50)) + ', passou a estar  '+ +cast(estado as varchar(13)) + '|'
		from    dbo.Evento_Desportivo WHERE Id_Evento = @Id AND ano=@ANOEVENTO
		/*group by cat_id*/
		option(maxdop 1)/**/
		/*print @MENSAGEM*/
		IF NOT EXISTS(SELECT NIF FROM dbo.Subscri��o WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
			RAISERROR('Sem clientes subscritos',15,1)
		ELSE
		BEGIN
			DECLARE @NIF numeric(9)
			SELECT @NIF=(SELECT NIF FROM dbo.Subscri��o WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
			EXEC dbo.SendMail @NIF,@MENSAGEM
		END	
		/*ENVIAR EMAIL*/
		

	END
go

COMMIT

print('Finished creating triggers on database SoAventura.'); 