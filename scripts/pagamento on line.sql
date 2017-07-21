

SELECT DBSIAF.PC_MAPEAMENTO_TITULO.F_MAPEAMENTO_INSCRICAO('1826','138278') CODMAPEAMENTO FROM DUAL;

select * from dbpagamento.pagamento p
where p.cod_mapeamento = 501732;

select * from dbpagamento.pagamento_status pp
where pp.cod_pagamento = 56024;

select *
from dbsiaf.mapeamento_titulo mt, dbsiaf.titulo_receber tr
where mt.cod_mapeamento = 501732
and tr.cod_titulo_receber = mt.cod_titulo_receber;

dbpagamento.sp_baixa_acordo_online(

SELECT * FROM  DBPAGAMENTO.STATUS_PAGAMENTO
select c.datvalbol from dbvestib.concurso_log c
where codconc = '1826';


select datpgto, i.cpfcan, i.cod_status_inscricao,i.cpfcan, i.cod_usuario_log, i.dat_operacao_log, i.formapgto, i.codlocpag
from dbvestib.inscricao_log i
where i.codconc = '1826'
and i.codinsc = '138278'
