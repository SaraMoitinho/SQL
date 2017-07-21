/*
select * from dbvestib.passos_inscricao pp where pp.cod_tpo_concurso = 43 for update
*/
insert into dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
values (dbvestib.passos_inscricao_s.nextval,43,'deficiencia/index/index', 'Deficiência', 2, null, 'S', 'deficiencia.beforeNextStep', 'deficiencia.afterLoadStep');

update dbvestib.passos_inscricao set ord_passo = 1 where cod_passo_inscricao = 9;
update dbvestib.passos_inscricao set ord_passo = 3 where cod_passo_inscricao = 10;
update dbvestib.passos_inscricao set ord_passo = 4 where cod_passo_inscricao = 11;


--setando as novas páginas dos passos
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Cadastro', END_TELA = 'dadospessoais/inscricao/index',  COD_CNF_CONSULTA = null WHERE COD_PASSO_INSCRICAO = 9;
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Pagamento', END_TELA = 'pagamento/index/index' WHERE COD_PASSO_INSCRICAO = 11;
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Escolha da turma', END_TELA = 'turma/index/index' WHERE COD_PASSO_INSCRICAO = 10;


--setando as funções javascript
update dbvestib.passos_inscricao set dsc_funcao_before = 'dadospessoais.beforeNextStep', dsc_funcao_after = 'dadospessoais.afterLoadStep' where cod_passo_inscricao = 9;
update dbvestib.passos_inscricao set dsc_funcao_before = 'turma.beforeNextStep', dsc_funcao_after = 'turma.afterLoadStep' where cod_passo_inscricao = 10;
update dbvestib.passos_inscricao set dsc_funcao_before = 'pagamento.beforeNextStep', dsc_funcao_after = 'pagamento.afterLoadStep' where cod_passo_inscricao = 11;
