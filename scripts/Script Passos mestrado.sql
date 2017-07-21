/*
select p.cod_passo_inscricao,  p.cod_tpo_concurso,p.end_tela, p.dsc_tela, p.ord_passo, p.cod_cnf_consulta, p.ind_exibir, p.dsc_funcao_before, p.dsc_funcao_after from dbvestib.passos_inscricao p
where p.cod_tpo_concurso =65


select p.cod_passo_inscricao, p.cod_tpo_concurso,p.end_tela, p.dsc_tela, p.ord_passo, p.cod_cnf_consulta, p.ind_exibir, p.dsc_funcao_before, p.dsc_funcao_after from dbvestib.passos_inscricao p
where p.cod_tpo_concurso in( 40)--,65)
          */

--organizando a ordem dos passos
delete from dbvestib.passos_inscricao where cod_passo_inscricao in (135,136,137,138,139, 144, 143, 145);

update dbvestib.passos_inscricao set ord_passo = 1 where cod_passo_inscricao = 140;
update dbvestib.passos_inscricao set ord_passo = 2 where cod_passo_inscricao = 141;
--update dbvestib.passos_inscricao set ord_passo = 3 where cod_passo_inscricao = 144;
--update dbvestib.passos_inscricao set ord_passo = 3 where cod_passo_inscricao = 145;
--update dbvestib.passos_inscricao set ord_passo = 4 where cod_passo_inscricao = 143;
update dbvestib.passos_inscricao set ord_passo = 3 where cod_passo_inscricao = 142;

--setando as novas páginas dos passos
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Cadastro', END_TELA = 'dadospessoais/inscricao/index',  COD_CNF_CONSULTA = null WHERE COD_PASSO_INSCRICAO = 140;
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Informações para o Processo', END_TELA = 'informacoes/index/index' ,  COD_CNF_CONSULTA = 2568 WHERE COD_PASSO_INSCRICAO = 141;
--UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Currículo', END_TELA = 'curriculo/index/index', COD_CNF_CONSULTA = 1851 WHERE COD_PASSO_INSCRICAO = 144;
--UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Promoção', END_TELA = 'promocao/index/index', COD_CNF_CONSULTA = 3257 WHERE COD_PASSO_INSCRICAO = 145;
--UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Orientação executiva', END_TELA = 'agendamentovestib/index/index',  COD_CNF_CONSULTA = 1843 WHERE COD_PASSO_INSCRICAO = 143;
UPDATE DBVESTIB.PASSOS_INSCRICAO SET DSC_TELA = 'Finalizando Inscrição', END_TELA = 'pagamento/index/index',  COD_CNF_CONSULTA = null WHERE COD_PASSO_INSCRICAO = 142;


--setando as funções javascript
update dbvestib.passos_inscricao set dsc_funcao_before = 'dadospessoais.beforeNextStep', dsc_funcao_after = 'dadospessoais.afterLoadStep' where cod_passo_inscricao = 140;
update dbvestib.passos_inscricao set dsc_funcao_before = 'informacoes.beforeNextStep', dsc_funcao_after = 'informacoes.afterLoadStep' where cod_passo_inscricao = 141;
--update dbvestib.passos_inscricao set dsc_funcao_before = 'curriculo.beforeNextStep', dsc_funcao_after = 'curriculo.afterLoadStep' where cod_passo_inscricao = 144;
--update dbvestib.passos_inscricao set dsc_funcao_before = 'promocao.beforeNextStep', dsc_funcao_after = 'promocao.afterLoadStep' where cod_passo_inscricao = 145;
--update dbvestib.passos_inscricao set dsc_funcao_before = 'agendamentovestib.beforeNextStep', dsc_funcao_after = 'agendamentovestib.afterLoadStep' where cod_passo_inscricao = 143;
update dbvestib.passos_inscricao set dsc_funcao_before = 'pagamento.beforeNextStep', dsc_funcao_after = 'pagamento.afterLoadStep' where cod_passo_inscricao = 142;

