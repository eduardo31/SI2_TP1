use SoAventura
SET NOCOUNT ON 
begin tran
GO
print(' ')
print('*****************************TESTE C*****************************')
print(' ')
print('Inserir 4 clientes')
print('Antes de inserir clientes')
	select * from dbo.Cliente
	exec dbo.InsertCliente @Nome='Isabel', @NIF=178845691, @CC=273075692, @Morada='Av. Cidade de Praga', @email='isabel94@gmail.com', @data_nascimento='1994-06-25'
	exec dbo.InsertCliente @Nome='Santiago', @NIF=198865691, @CC=283075692, @Morada='Av. Liverdade', @email='santiago51@gmail.com', @data_nascimento='1689-06-25'
	exec dbo.InsertCliente @Nome='Sandra', @NIF=118845791, @CC=173075692, @Morada='R. Amália Rodrigues', @email='sandrabonita@gmail.com', @data_nascimento='2003-06-25'
	exec dbo.InsertCliente @Nome='Sérgio', @NIF=138845691, @CC=213075692, @Morada='R. Lucilia Simões', @email='sergiomorais@gmail.com', @data_nascimento='1952-06-25'
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
print('Remover cliente')
print('Antes de remover') 
	select * from dbo.Cliente where existente='T'
print('Verificar se foram removidos clientes')
	exec dbo.DeleteCliente @NIF=118845791
	select * from dbo.Cliente where existente='T'
	
GO

COMMIT