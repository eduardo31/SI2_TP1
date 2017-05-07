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
	COUNT(dbo.Canoagem.Id_Evento) AS CanoagemCancelados, 
	COUNT(dbo.escalada.Id_Evento) AS EscaladaCancelados,
	COUNT(dbo.trail.Id_Evento) AS TrailCancelados,
	COUNT(dbo.ciclismo.Id_Evento) AS CiclismoCancelados
	FROM dbo.Evento_Desportivo 
	JOIN dbo.canoagem on(dbo.Evento_Desportivo.Id_Evento= dbo.canoagem.Id_Evento AND dbo.Evento_Desportivo.ano= dbo.canoagem.ano)
	JOIN dbo.escalada on(dbo.Evento_Desportivo.Id_Evento= dbo.escalada.Id_Evento AND dbo.Evento_Desportivo.ano= dbo.escalada.ano)
	JOIN dbo.trail on(dbo.Evento_Desportivo.Id_Evento= dbo.trail.Id_Evento AND dbo.Evento_Desportivo.ano= dbo.trail.ano)
	JOIN dbo.ciclismo on(dbo.Evento_Desportivo.Id_Evento= dbo.ciclismo.Id_Evento AND dbo.Evento_Desportivo.ano= dbo.ciclismo.ano)
	WHERE (estado='cancelado' AND data_da_realização<=@FIM AND data_da_realização>=@INICIO) 

go 

COMMIT