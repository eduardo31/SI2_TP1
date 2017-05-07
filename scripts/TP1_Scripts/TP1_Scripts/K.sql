/*
Obter os pagamentos					FATURAS
realizados num dado ano				RECEBER ANO
com um intervalo de amostragem especificado. MAX MONTANTE MIN MONTANTE
Function

*/

use SoAventura

set nocount on

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE 

BEGIN TRAN

go


if OBJECT_ID('dbo.EventosDisponiveis') is not null
	drop function dbo.EventosDisponiveis

go
create function dbo.EventosDisponiveis(@ANO INT,@MONTANTEMINIMO SMALLMONEY,@MONTANTEMAXIMO SMALLMONEY)
returns table
as
	return SELECT Id_Evento,ano,NIF,montante FROM dbo.Fatura WHERE montante<=@MONTANTEMAXIMO AND montante>=@MONTANTEMINIMO AND @ANO=YEAR(data_pagamento)
go 

COMMIT