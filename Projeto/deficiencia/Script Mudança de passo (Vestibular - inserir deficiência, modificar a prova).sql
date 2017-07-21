
insert into dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
values 
(dbvestib.passos_inscricao_s.nextval,1,'deficiencia/index/index', 'Deficiência', 6, null, 'S', 'deficiencia.beforeNextStep', 'deficiencia.afterLoadStep')
;


--organizando a ordem dos passos

UPDATE DBVESTIB.PASSOS_INSCRICAO   SET ORD_PASSO = 3 WHERE COD_PASSO_INSCRICAO = 217	   AND COD_TPO_CONCURSO = 1;   
update dbvestib.passos_inscricao set ord_passo = 2 where cod_passo_inscricao = 51  AND COD_TPO_CONCURSO = 1;
update dbvestib.passos_inscricao set ord_passo = 4 where cod_passo_inscricao = 191 AND COD_TPO_CONCURSO = 1;
update dbvestib.passos_inscricao set ord_passo = 5 where cod_passo_inscricao = 16 AND COD_TPO_CONCURSO = 1;
update dbvestib.passos_inscricao set ord_passo = 6 where cod_passo_inscricao = 19 AND COD_TPO_CONCURSO = 1;

select * from dbvestib.passos_inscricao where cod_tpo_concurso = 1
