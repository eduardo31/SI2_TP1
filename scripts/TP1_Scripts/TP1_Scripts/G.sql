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
	/*atualizar os que ja entrarem em subscrição*/
	UPDATE  dbo.Evento_Desportivo SET estado='em subscrição' WHERE GETDATE()>=(SELECT inicio_data_subscrição FROM dbo.Evento_Desportivo WHERE estado=NULL)

	
	/*CRIAR VIEW*/

	/*atualizar os que ja subscreveram*/

	Declare @Id int,@ANOEVENTO int,@fim_data_subscrição DATE,@min_participantes int,@Participantes int


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
	End
	Update dbo.Evento_Desportivo Set Processed = 0 Where Id_Evento = @Id AND ano=@ANOEVENTO AND Processed = 1
	/*atualizar os que ja acabaram*/

	UPDATE  dbo.Evento_Desportivo SET estado='concluído' WHERE GETDATE()>=(SELECT data_da_realização FROM dbo.Evento_Desportivo WHERE estado='subscrito')
	
	
	
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

		/*ENVIAR EMAIL*/
		DECLARE @NIF numeric(9)
		SELECT @NIF=(SELECT NIF FROM DBO.Subscrição WHERE Id_Evento = @Id AND ano=@ANOEVENTO)
		EXEC dbo.SendMail @NIF,@MENSAGEM

	END
go

COMMIT

print('Finished creating triggers on database SoAventura.'); 