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
	/*atualizar os que ja entrarem em subscri��o*/
	UPDATE  dbo.Evento_Desportivo SET estado='em subscri��o' WHERE GETDATE()>=(SELECT inicio_data_subscri��o FROM dbo.Evento_Desportivo WHERE estado=NULL)

	
	/*CRIAR VIEW*/

	/*atualizar os que ja subscreveram*/

	Declare @Id int,@ANOEVENTO int,@fim_data_subscri��o DATE,@min_participantes int,@Participantes int


	While (Select Count(*) From dbo.Evento_Desportivo Where Processed=0 AND estado='em subscri��o') > 0
	Begin
		Select Top 1 @Id = Id_Evento,@ANOEVENTO=ano From dbo.Evento_Desportivo Where Processed=0 AND estado='em subscri��o'

		SELECT @fim_data_subscri��o = fim_data_subscri��o,@min_participantes=min_participantes FROM dbo.Evento_Desportivo WHERE @Id = Id_Evento AND @ANOEVENTO=ano
		SELECT @Participantes = COUNT( NIF) FROM dbo.Subscri��o WHERE @Id = Id_Evento AND @ANOEVENTO=ano

		IF (GETDATE()>=@fim_data_subscri��o)
		BEGIN
			IF (@min_participantes<@Participantes)
				Update dbo.Evento_Desportivo Set estado='subscrito' Where Id_Evento = @Id AND ano=@ANOEVENTO
			ELSE
				Update dbo.Evento_Desportivo Set estado='cancelado' Where Id_Evento = @Id AND ano=@ANOEVENTO	
		END
		Update dbo.Evento_Desportivo Set Processed = 1 Where Id_Evento = @Id AND ano=@ANOEVENTO 
	End

	/*atualizar os que ja acabaram*/

	UPDATE  dbo.Evento_Desportivo SET estado='conclu�do' WHERE GETDATE()>=(SELECT data_da_realiza��o FROM dbo.Evento_Desportivo WHERE estado='subscrito')
	
	
	
COMMIT
RETURN 

GO