
  insert into dbvestib.tipo_concurso(cod_tpo_concurso,dsc_concurso,sgl_concurso,ind_gerar_financeiro,ind_gerar_matricula,ind_insc_web,ind_verifica_qualif,ind_solicita_reserva,ind_verifica_nat_disciplina,end_web_inscricao,end_web_insc_teste
              ,end_web_insc_func,end_web_insc_func_teste,cod_cnf_rel_comprovante,codgru,codformalogin,end_segunda_via_boleto,indformaingressoobrig
              ,indativo,ind_centro_custo_curso,cod_tpo_lancamento,ind_permite_mult_insc,ind_aproveita_dados_aluno,ind_possui_turma,ind_aproveita_dados_aluno_cpf,
              ind_forma_parcelamento,cod_tpo_aluno,cod_tpo_login)
              select dbvestib.tipo_concurso_s.nextval,'Cursos de Extensão EAD',sgl_concurso,ind_gerar_financeiro,ind_gerar_matricula,ind_insc_web,ind_verifica_qualif,ind_solicita_reserva,ind_verifica_nat_disciplina,end_web_inscricao,end_web_insc_teste
              ,end_web_insc_func,end_web_insc_func_teste,cod_cnf_rel_comprovante,codgru,codformalogin,end_segunda_via_boleto,indformaingressoobrig
              ,indativo,ind_centro_custo_curso,cod_tpo_lancamento,ind_permite_mult_insc,ind_aproveita_dados_aluno,ind_possui_turma,ind_aproveita_dados_aluno_cpf,
              ind_forma_parcelamento,3,cod_tpo_login
              from dbvestib.tipo_concurso tt where tt.cod_tpo_concurso = '41';



              insert into DBVESTIB.PERM_GRUPO_TIPO_CONCURSO(COD_ITEM_MENU,COD_TPO_CONCURSO,COD_GRP_USUARIO,IND_CONTROLA_OBJETOS)
              select COD_ITEM_MENU,98,COD_GRP_USUARIO,IND_CONTROLA_OBJETOS from DBVESTIB.PERM_GRUPO_TIPO_CONCURSO PTC
              where ptc.cod_tpo_concurso = 41;

			  
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Informação inscrição rodapé especifico (Una Pouso Alegre)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Texto Experimente Especifico (Botão no fim da inscrição) (Una Pouso Alegre)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Informações para matrícula ingressante (Una Pouso Alegre)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Status - Aprovado adicional - OK - (Una Pouso Alegre)');
               
               ---------------------------------------------------------------------------------------------------
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Informação inscrição rodapé especifico (Una Bom Despacho)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Texto Experimente Especifico (Botão no fim da inscrição) (Una Bom Despacho)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Informações para matrícula ingressante (Una Bom Despacho)');
               
               insert into dbvestib.tipo_informacao (cod_tipo_informacao,dsc_tipo_informacao)
               values (dbvestib.tipo_informacao_s.nextval,'Status - Aprovado adicional - OK - (Una Bom Despacho)');
                              
               insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
               values (201,98);
              
              
