/*Function
Listar a contagem dos eventos cancelados, agrupados por tipo, num dado intervalo de datas; 
*/

use SoAventura

set nocount on

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE 

BEGIN TRAN

go


if OBJECT_ID('dbo.EventosCancelados') is not null
	drop function dbo.EventosCancelados

go
create function dbo.EventosCancelados(@INICIO DATE,@FIM DATE)
returns table
as
	RETURN SELECT 
	COUNT(tb.Id_Evento) AS CanoagemCancelados , 
	COUNT(tc.Id_Evento) AS EscaladaCancelados,
	COUNT(td.Id_Evento) AS TrailCancelados,
	COUNT(te.Id_Evento) AS CiclismoCancelados
	FROM dbo.Evento_Desportivo AS ta
	Left Outer Join dbo.canoagem AS tb ON ta.Id_Evento = tb.Id_Evento
	Left Outer Join dbo.escalada AS tc ON ta.Id_Evento = tc.Id_Evento
	Left Outer Join dbo.trail AS td ON ta.Id_Evento = td.Id_Evento
	Left Outer Join dbo.ciclismo AS te ON ta.Id_Evento = te.Id_Evento
	WHERE (estado='cancelado' AND data_da_realização<=@FIM AND data_da_realização>=@INICIO)

go 

COMMIT