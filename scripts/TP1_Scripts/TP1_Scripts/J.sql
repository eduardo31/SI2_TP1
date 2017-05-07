/*Function
Listar todos os eventos com lugares disponíveis para um intervalo de datas especificado;  
*/

use SoAventura

set nocount on

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE 

BEGIN TRAN

go


if OBJECT_ID('dbo.EventosDisponiveis') is not null
	drop function dbo.EventosDisponiveis

go
create function dbo.EventosDisponiveis(@INICIO DATE,@FIM DATE)
returns table
as

	RETURN SELECT
	Id_Evento, ano
	FROM dbo.Evento_Desportivo 
	WHERE ((estado='em subscrição' OR estado='subscrito') AND data_da_realização<=@FIM AND data_da_realização>=@INICIO AND max_participantes>=
	(SELECT COUNT (NIF) FROM dbo.Subscrição WHERE dbo.Evento_Desportivo.Id_Evento=dbo.Subscrição.Id_Evento AND dbo.Evento_Desportivo.ano=dbo.Subscrição.ano)) 
go 

COMMIT