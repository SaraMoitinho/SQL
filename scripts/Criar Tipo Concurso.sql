
-- criando tipo concurso
insert into dbvestib.tipo_concurso (cod_tpo_concurso,dsc_concurso,sgl_concurso,ind_gerar_financeiro,ind_gerar_matricula,ind_insc_web,ind_verifica_qualif
,ind_solicita_reserva ,ind_verifica_nat_disciplina ,end_web_inscricao ,end_web_insc_teste ,end_web_insc_func ,end_web_insc_func_teste 
,cod_cnf_rel_comprovante ,codgru ,codformalogin ,end_segunda_via_boleto ,indformaingressoobrig )
select  dbvestib.tipo_concurso_s.nextval, 'Prouni-EAD',sgl_concurso,ind_gerar_financeiro,ind_gerar_matricula,ind_insc_web,ind_verifica_qualif
,ind_solicita_reserva ,ind_verifica_nat_disciplina ,end_web_inscricao ,end_web_insc_teste ,end_web_insc_func ,end_web_insc_func_teste 
,cod_cnf_rel_comprovante ,codgru ,codformalogin ,end_segunda_via_boleto ,indformaingressoobrig 
  from dbvestib.tipo_concurso
  where cod_tpo_concurso = 39;

-- inserindo passo-inscricao
insert into dbvestib.passos_inscricao(cod_passo_inscricao ,cod_tpo_concurso ,end_tela ,dsc_tela ,ord_passo ,cod_cnf_consulta ,ind_exibir 
,dsc_funcao_before ,dsc_funcao_after )
select dbvestib.passos_inscricao_s.nextval ,78 ,end_tela ,dsc_tela ,ord_passo ,cod_cnf_consulta ,ind_exibir 
,dsc_funcao_before ,dsc_funcao_after 
from dbvestib.passos_inscricao  pp
where  pp.cod_tpo_concurso = 39;

-- inserindo permissão grupo
insert into dbvestib.perm_grupo_tipo_concurso(cod_item_menu,cod_tpo_concurso ,cod_grp_usuario ,ind_controla_objetos )
select cod_item_menu,78 ,cod_grp_usuario ,ind_controla_objetos
from dbvestib.perm_grupo_tipo_concurso g
where g.cod_tpo_concurso = 39;
