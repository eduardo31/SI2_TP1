/*Function
Listar todos os eventos com lugares dispon�veis para um intervalo de datas especificado;  
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
	WHERE ((estado='em subscri��o' OR estado='subscrito') AND data_da_realiza��o<=@FIM AND data_da_realiza��o>=@INICIO AND max_participantes>=
	(SELECT COUNT (NIF) FROM dbo.Subscri��o WHERE dbo.Evento_Desportivo.Id_Evento=dbo.Subscri��o.Id_Evento AND dbo.Evento_Desportivo.ano=dbo.Subscri��o.ano)) 
go 

COMMIT