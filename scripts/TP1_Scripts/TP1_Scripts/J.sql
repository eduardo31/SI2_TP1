/*Function
Listar a contagem dos eventos cancelados, agrupados por tipo, num dado intervalo de datas; 
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
	
	return SELECT Id_Evento,ano FROM dbo.Evento_Desportivo WHERE (estado='em subscrição' OR estado='subscrito') AND @FIM<=fim_data_subscrição AND @INICIO>=inicio_data_subscrição/* AND PARTICIPANTES COUNT < MAX PARTICIPANTES*/ 
	/*return (select top (@n) * from dbo.Licitacao where unCheck = 1 order by dataHora desc)   */
go 

COMMIT