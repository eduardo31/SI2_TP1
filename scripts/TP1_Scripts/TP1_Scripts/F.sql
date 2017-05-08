USE SoAventura

GO
/*pagamento*/
IF OBJECT_ID('dbo.PagarSubscricao') IS NOT NULL
	DROP PROCEDURE dbo.PagarSubscricao
GO

CREATE PROCEDURE dbo.PagarSubscricao
		@Id_Evento int,
		@ano int,
		@Id_Factura int output,
		@montante SMALLMONEY,
		@NIF numeric(9)
AS
SET xact_abort ON 
BEGIN TRANSACTION
	IF NOT EXISTS (SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano) 
		RAISERROR('Evento INVÁLIDO!',15,1)
	ELSE IF NOT EXISTS (SELECT NIF FROM dbo.Cliente WHERE NIF = @NIF)  
		RAISERROR('Cliente INVÁLIDO!',15,1)
	ELSE IF NOT EXISTS (SELECT Id_Evento, ano, NIF FROM dbo.Subscrição WHERE Id_Evento=@Id_Evento AND ano=@ano AND NIF = @NIF)  
		RAISERROR('Cliente nao se encontra subscrito ao evento!',15,1)
	ELSE BEGIN
		DECLARE @curr DATETIME,@descricao varchar(50),@Nome varchar(50),@Morada varchar(50),@data_limite_pagamento date,@estado varchar(13),@preço_por_participante smallmoney
		SELECT @curr = GETDATE()
		SELECT @data_limite_pagamento=data_limite_pagamento, @estado=estado,@preço_por_participante=preço_por_participante FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano

		IF @curr>@data_limite_pagamento
			RAISERROR('A DATA LIMITE DE PAGAMENTO FOI EXCEDIDA!',15,1)

		ELSE IF @estado='concluído' or @estado='cancelado'
			RAISERROR('A DATA LIMITE DE PAGAMENTO FOI EXCEDIDA!',15,1)

		ELSE IF @montante<@preço_por_participante
			RAISERROR('MONTANTE INSUFICIENTE!',15,1)
		ELSE BEGIN

		/*CALCULO DO Id_Fatura*/
	
		SELECT @Id_Factura = max(Id_Factura) FROM dbo.Fatura WHERE YEAR(@curr)=YEAR(data_pagamento)
		IF @Id_Factura IS NULL
			SET @Id_Factura=0
		SET @Id_Factura=@Id_Factura+1

		/*OBTER INFO DO CLIENTE*/
		SELECT @Nome=Nome,@Morada=Morada FROM dbo.Cliente WHERE NIF=@NIF
		/*OBTER DESCRICAO*/
		SELECT @descricao=descrição FROM dbo.Evento_Desportivo WHERE Id_Evento = @Id_Evento AND ano=@ano

		INSERT INTO dbo.Fatura (Id_Evento,ano,Id_Factura,montante,data_pagamento,descricao,Nome,Morada,NIF) VALUES (@Id_Evento, @ano,@Id_Factura,@montante,@curr,@descricao,@Nome,@Morada,@NIF)
		END
	END
COMMIT
RETURN 

GO