use SoAventura
SET NOCOUNT ON 
begin tran
GO
print(' ')
print('*****************************TESTE C CLIENTES*****************************')
print(' ')
print('Inserir 4 clientes')
print('Antes de inserir clientes')
	select * from dbo.Cliente
	exec dbo.InsertCliente @Nome='Isabel', @NIF=178845691, @CC=273075692, @Morada='Av. Cidade de Praga', @email='isabel94@gmail.com', @data_nascimento='1994-06-25'/*23*/
	exec dbo.InsertCliente @Nome='Santiago', @NIF=198865691, @CC=283075692, @Morada='Av. Liverdade', @email='santiago51@gmail.com', @data_nascimento='1977-06-25'/*40*/
	exec dbo.InsertCliente @Nome='Sandra', @NIF=118845791, @CC=173075692, @Morada='R. Amália Rodrigues', @email='sandrabonita@gmail.com', @data_nascimento='1947-06-25'/*70*/
	exec dbo.InsertCliente @Nome='Sérgio', @NIF=138845691, @CC=213075692, @Morada='R. Lucilia Simões', @email='sergiomorais@gmail.com', @data_nascimento='1987-06-25'/*30*/
print('Verificar se foram inseridos clientes')
	select * from dbo.Cliente
GO
print(' ')
print('Atualizar email da Isabel para isabelsoares@gmail.com')
print('Antes da atulização') 
	select email from dbo.Cliente where NIF=178845691
print('Verificar a atulização')
	exec dbo.UpdateCliente @NIF=178845691,@email='isabelsoares@gmail.com'
	select * from dbo.Cliente where NIF=178845691
print(' ')	
print('Atualizar nome da Sandra para Sandro')
print('Antes da atulização') 
	select Nome from dbo.Cliente where NIF=118845791
print('Verificar a atulização')
	exec dbo.UpdateCliente @NIF=118845791, @Nome='Sandro'
	select * from dbo.Cliente where NIF=118845791	
print(' ')
print('Atualizar morada do Santiago para Av. Cidade de Praga')
print('Antes da atulização') 
	select Morada from dbo.Cliente where NIF=198865691
print('Verificar a atulização')
	exec dbo.UpdateCliente @NIF=198865691, @Morada='Av. Cidade de Praga'
	select * from dbo.Cliente where NIF=198865691	
print(' ')	
print('Remover cliente com nif 118845791')
print('Antes de remover') 
	select * from dbo.Cliente where existente='T'
print('Verificar se foram removidos clientes')
	exec dbo.DeleteCliente @NIF=118845791
	select * from dbo.Cliente where existente='T'
	
GO

COMMIT



















begin tran
GO
print(' ')
print('*****************************TESTE D EVENTOS*****************************')
print(' ')
print('Inserir 8 eventos')
print('Antes de inserir eventos')
	select * from dbo.Evento_Desportivo


	exec dbo.InsertEventoCanoagem @ano=2017,	@data_da_realização='2017-06-1 16:30:00',@data_limite_pagamento = '2017-05-31',@fim_data_subscrição = '2017-05-25',	@inicio_data_subscrição = '2017-05-1',	@idade_min = 8,	@idade_max = 65,	@min_participantes = 2,	@max_participantes = 4,	@descrição = 'Descer o rio tejo.',	@preço_por_participante = 24.99,	@dificuldade =1
	exec dbo.InsertEventoCanoagem @ano=2017,	@data_da_realização='2017-06-25 16:30:00',@data_limite_pagamento = '2017-06-24',@fim_data_subscrição = '2017-06-20',	@inicio_data_subscrição = '2017-05-5',	@idade_min = 8,	@idade_max = 65,	@min_participantes = 1,	@max_participantes = 2,	@descrição = 'Descer o rio douro.',	@preço_por_participante = 24.99,	@dificuldade =5
	
	exec dbo.InsertEventoEscalada @ano=2017,	@data_da_realização='2017-06-25 16:30:00',@data_limite_pagamento = '2017-06-24',@fim_data_subscrição = '2017-06-20',	@inicio_data_subscrição = '2017-05-5',	@idade_min = 8,	@idade_max = 65,	@min_participantes = 1,	@max_participantes = 2,	@descrição = 'Escalar a parede do ISEL.',	@preço_por_participante = 24.99,	@dificuldade =5

	exec dbo.InsertEventoCiclismo @ano=2017,	@data_da_realização='2017-06-25 16:30:00',@data_limite_pagamento = '2017-06-24',@fim_data_subscrição = '2017-06-20',	@inicio_data_subscrição = '2017-05-5',	@idade_min = 8,	@idade_max = 65,	@min_participantes = 1,	@max_participantes = 2,	@descrição = 'Escalar a parede do ISEL.',	@preço_por_participante = 24.99,	@distancia =50
	
	exec dbo.InsertEventoCiclismo @ano=2017,	@data_da_realização='2017-06-25 16:30:00',@data_limite_pagamento = '2017-06-24',@fim_data_subscrição = '2017-06-20',	@inicio_data_subscrição = '2017-06-1',	@idade_min = 8,	@idade_max = 65,	@min_participantes = 1,	@max_participantes = 2,	@descrição = 'Escalar a parede do ISEL.',	@preço_por_participante = 24.99,	@distancia =50


print('Verificar se foram inseridos os eventos')
	select * from dbo.Evento_Desportivo
GO
print(' ')
print('Atualizar idade minima')
print('Antes da atulização') 
	select idade_min from dbo.Evento_Desportivo where Id_Evento=1 and ano=2017
print('Verificar a atulização')
	exec dbo.UpdateEventoCanoagem @Id_Evento=1,@ano=2017,@idade_min=9
	select idade_min from dbo.Evento_Desportivo where Id_Evento=1 and ano=2017
print(' ')	
print('Remover evento ')
print('Antes de remover') 
	select * from dbo.Evento_Desportivo
print('Verificar se foram removidos clientes')
	exec dbo.RemoveEvento @Id_Evento=1,@ano=2017
	select * from dbo.Evento_Desportivo
	
GO

COMMIT



print('*****************************TESTE G*****************************')
	select Id_Evento,estado from dbo.Evento_Desportivo
	exec dbo.VerificarEstados
	select Id_Evento,estado from dbo.Evento_Desportivo





begin tran
GO
print(' ')
print('*****************************TESTE E*****************************')
print(' ')
print('Subscrever clinte')
	select * from dbo.Subscrição


	exec SubscreverClienteEvento @Id_Evento=2,@ano=2017,@NIF=178845691

	select * from dbo.Subscrição
	
GO

COMMIT

GO




SET NOCOUNT ON 
begin tran
GO
print(' ')
print('*****************************TESTE I INICIO*****************************')
print('Listar a contagem dos eventos cancelados, agrupados por tipo, num dado intervalo de datas')
print('Data de  inicio 2017-01-1 e data de fim 2017-08-1')
	select * from dbo.EventosCancelados ('2017-01-1','2017-08-1');
GO
COMMIT




SET NOCOUNT ON 
begin tran
GO
print(' ')
print('*****************************TESTE J INICIO*****************************')
print('Listar todos os eventos com lugares disponíveis para um intervalo de datas especificado')
print('Data de  inicio 2017-05-05 e data de fim 2017-05-20')
	select * from dbo.EventosDisponiveis ('2017-06-20','2017-06-30');
GO
COMMIT

SET NOCOUNT ON 
begin tran
GO
print(' ')
print('*****************************TESTE K INICIO*****************************')
print('Listar todas as faturas por ano num dado intervalo de montantes.')
print('Ano 2017 entre 0 e 30 euros')
	select * from dbo.FaturasPorAno ('2017',0,30);
GO
COMMIT