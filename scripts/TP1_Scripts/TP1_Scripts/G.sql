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

	Declare @Id int,@ANOEVENTO int,@fim_data_subscrição DATE,@inicio_data_subscrição DATE,@min_participantes int,@Participantes int, @dataCurrente DATETIME,@data_da_realização DATETIME
	
	SELECT @dataCurrente = GETDATE()

	While (Select Count(*) From dbo.Evento_Desportivo Where Processed=0) > 0
	Begin
		Select Top 1 @Id = Id_Evento,@ANOEVENTO=ano, @fim_data_subscrição = fim_data_subscrição,@inicio_data_subscrição=inicio_data_subscrição,@min_participantes=min_participantes,@data_da_realização=data_da_realização From dbo.Evento_Desportivo Where Processed=0
		
		/*atualizar os que ja entraram em subscrição*/

		IF(@dataCurrente>=@inicio_data_subscrição /*AND @estado IS NULL*/)
		BEGIN
			UPDATE  dbo.Evento_Desportivo SET estado='em subscrição' WHERE @Id = Id_Evento AND @ANOEVENTO=ano AND (estado IS NULL)
			/*exec dbo.UpdateEvento @Id_Evento=@Id,@ano=@ANOEVENTO, @estado='em subscrição'*/
		END
		
		/*atualizar os que ja subscreveram*/
		SELECT @Participantes = COUNT( NIF) FROM dbo.Subscrição WHERE @Id = Id_Evento AND @ANOEVENTO=ano

		IF (@dataCurrente>=@fim_data_subscrição)
		BEGIN
			IF (@min_participantes<@Participantes)
				Update dbo.Evento_Desportivo Set estado='subscrito' Where Id_Evento = @Id AND ano=@ANOEVENTO AND estado = 'em subscrição'
			ELSE
				Update dbo.Evento_Desportivo Set estado='cancelado' Where Id_Evento = @Id AND ano=@ANOEVENTO AND estado = 'em subscrição'	
		END

		/*atualizar os que ja acabaram*/
		IF(@dataCurrente>=@data_da_realização)
		BEGIN
		UPDATE  dbo.Evento_Desportivo SET estado='concluído' WHERE Id_Evento = @Id AND ano=@ANOEVENTO AND estado='subscrito'
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
		select  @MENSAGEM = @MENSAGEM + cast(Id_Evento as varchar(20)) + ', ' + cast(descrição as varchar(50)) + ', passou a estar  '+ +cast(estado as varchar(13)) + '|'
		from    dbo.Evento_Desportivo WHERE Id_Evento = @Id AND ano=@ANOEVENTO
		/*group by cat_id*/
		option(maxdop 1)/**/
		/*print @MENSAGEM*/
		IF NOT EXISTS(SELECT NIF FROM dbo.Subscrição WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
			RAISERROR('Sem clientes subscritos',15,1)
		ELSE
		BEGIN
			DECLARE @NIF numeric(9)
			SELECT @NIF=(SELECT NIF FROM dbo.Subscrição WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
			EXEC dbo.SendMail @NIF,@MENSAGEM
		END	
		/*ENVIAR EMAIL*/
		

	END
go

COMMIT

print('Finished creating triggers on database SoAventura.'); 