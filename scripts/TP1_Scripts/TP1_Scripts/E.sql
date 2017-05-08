USE SoAventura

GO

IF OBJECT_ID('dbo.SubscreverClienteEvento') IS NOT NULL
	DROP PROCEDURE dbo.SubscreverClienteEvento
GO

CREATE PROCEDURE dbo.SubscreverClienteEvento
	@Id_Evento INT,
	@ano int,
	@NIF numeric(9)
AS
SET xact_abort ON 
BEGIN TRANSACTION
	
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano)  
		RAISERROR('Evento INVÁLIDO!',15,1)
	ELSE IF NOT EXISTS (SELECT NIF FROM dbo.Cliente WHERE NIF = @NIF AND existente = 'T')  
		RAISERROR('Cliente INVÁLIDO!',15,1)
	ELSE BEGIN
		DECLARE @AGE INT,@dob  date,@curr date,@IDADEmin int,@IDADEmax int,
		@inicio_data_subscrição date,@fim_data_subscrição date,@participantesSubscritos int,
		@max_participantes int,@estado varchar(13)
	
		/*obter variaveis do evento desportivo*/
		SELECT @IDADEmin =idade_min,@IDADEmax =idade_max,@inicio_data_subscrição=inicio_data_subscrição,@fim_data_subscrição=fim_data_subscrição,@max_participantes=max_participantes,@estado=estado FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano
		/*Calcular data currente*/
		SELECT @curr = GETDATE()
		/*ver se o estado é aceitavel*/
		IF(@estado='concluído' or @estado='cancelado')
			RAISERROR('ESTADO INVALIDO!',15,1)
		/*verificar se a data currente o evento ainda esta disponivel*/
		ELSE IF(@curr<@inicio_data_subscrição AND @curr>@fim_data_subscrição)
			RAISERROR('DATA DE SUBSCRIÇAO INVÁLIDA!',15,1)
		ELSE BEGIN
			/*contare verificar o numero de subscritos ate a data*/
			SELECT @participantesSubscritos = COUNT( NIF) FROM dbo.Subscrição WHERE Id_Evento = @Id_Evento AND ano=@ano 
			IF(@participantesSubscritos>=@max_participantes)
				RAISERROR('NUMERO MAXIMO DE SUBSCRITOS!',15,1)
			ELSE BEGIN
				/*verificar a idade do cliente segundo os padroes do evento*/
				SELECT @dob= data_nascimento FROM dbo.Cliente WHERE NIF = @NIF
				SELECT @AGE= (CONVERT(int,CONVERT(char(8),@curr,112))-CONVERT(char(8),@dob,112))/10000 
				IF (@AGE<@IDADEmin OR @AGE>@IDADEmax)  
					RAISERROR('Cliente com idade INVÁLIDA!',15,1)
				ELSE
					INSERT INTO dbo.Subscrição(Id_Evento, ano, NIF) VALUES (@Id_Evento, @ano, @NIF)
			END
		END
	END
	
COMMIT
RETURN 

GO