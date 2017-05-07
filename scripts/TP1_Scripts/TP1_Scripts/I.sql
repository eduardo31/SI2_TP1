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
create function dbo.EventosCancelados(/*@n int,*/@INICIO DATE,@FIM DATE)
returns table
as
	return SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE estado='cancelado' AND data_da_realização<=@FIM AND data_da_realização>=@INICIO /*GROUP BY TIPO DE EVENTO*/ 
	/*return (select top (@n) * from dbo.Licitacao where unCheck = 1 order by dataHora desc)   */
go 

COMMIT