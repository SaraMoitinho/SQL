-- Marcando Flag de selecao de pólo(necessario para funcionamento da estrutura criada) e marcando o concurso com uma unicao opcao
-- Escolhendo concurso 2057

update dbvestib.parametros_concurso p set p.ind_seleciona_polo = 'S', p.numopcoes = 1 where p.codconc = 2057;

-- inserindo 2 campus com indicador de pólo no SIAF, juntamente com endereço a ser exibido na tela de inscricao
-- Estou assumindo que os codigos deles serão (82 e 83)

insert into dbsiaf.campus
  (cod_campus,
   cod_instituicao,
   nom_campus,
   sgl_campus,
   num_campus,
   end_host_email,
   num_porta_email,
   num_ult_inscricao,
   ind_ativo,
   cod_campus_integrador,
   dsc_letra_turma_ini,
   dsc_letra_turma_fim,
   ind_ead,
   cod_campus_inep,
   cod_instituicao_integ)
values
  (dbsiaf.campus_s.nextval,
   3,
   'Pólo Raja',
   'p1teste',
   1,
   'teste@teste.com',
   80,
   0,
   'S',
   null,
   null,
   null,
   'S',
   null,
   null);

--select * from dbsiaf.campus cam where cam.nom_campus = 'Pólo 2 teste';

-- select * from dbsiaf.cidade where cod_cidade = 10

insert into dbsiaf.end_campus
  (cod_campus, cod_tpo_endereco, cod_cidade, nom_logradouro, nom_complemento, nom_bairro, cep_endereco, tel_endereco, fax_numero)
values
  (82, 2, 163, 'Av. Raja Gabaglia - 1000', null,'Estoril', '0564564564', '231231231', '231231231');


insert into dbsiaf.campus
  (cod_campus,
   cod_instituicao,
   nom_campus,
   sgl_campus,
   num_campus,
   end_host_email,
   num_porta_email,
   num_ult_inscricao,
   ind_ativo,
   cod_campus_integrador,
   dsc_letra_turma_ini,
   dsc_letra_turma_fim,
   ind_ead,
   cod_campus_inep,
   cod_instituicao_integ)
values
  (dbsiaf.campus_s.nextval,
   3,
   'Pólo Barro Preto',
   'p2teste',
   1,
   'teste@teste.com',
   80,
   0,
   'S',
   null,
   null,
   null,
   'S',
   null,
   null);

--select * from dbsiaf.campus cam where cam.nom_campus = 'Pólo 2 teste';

-- select * from dbsiaf.cidade where cod_cidade = 10

insert into dbsiaf.end_campus
  (cod_campus, cod_tpo_endereco, cod_cidade, nom_logradouro, nom_complemento, nom_bairro, cep_endereco, tel_endereco, fax_numero)
values
  (83, 2, 163, 'Rua teste 2', 'complemento teste', 'bairro teste', '0564564564', '231231231', '231231231');
----------------------------------------------------------------------------------------------------------------------------

-- Inserindo campus no VESTIB, vinculados aos campus do SIAF 
-- (nesse vinculos são criados locais e entrevistadores no sistema de agendamento)

insert into dbvestib.campus
  (codcam,
   nomcam,
   endcam,
   baicam,
   cidcam,
   estcam,
   cepcam,
   telcam,
   cod_campus_siaf,
   CODINSTITUICAO)
values
  ('88',
   'Pólo Raja',
   'endereco',
   'baiirro',
   'cidade',
   'MG',
   '00000',
   '0000',
   82,
   5); ------ campus siaf

insert into dbvestib.campus
  (codcam,
   nomcam,
   endcam,
   baicam,
   cidcam,
   estcam,
   cepcam,
   telcam,
   cod_campus_siaf,
   CODINSTITUICAO)
values
  ('89',
   'Pólo Barro Preto',
   'endereco',
   'baiirro',
   'cidade',
   'MG',
   '00000',
   '0000',
   83,
   5); ------ campus siaf
   
   --select * from dbvestib.campus for update
-------------------------------------------------------------------------------------------------------------------------------------------   
   
-- Cadastrando temas de redação, que serão vinculados a disponibilidades de agendamento, 
-- quando elas forem criadas no sistema de agendamento
-- Tela nova desenvolvida foi no VESTIB desktop para criacao dos temas.

insert into dbvestib.tema_redacao
  (cod_tema_redacao, codconc, nom_tema_redacao, num_ordem_tema_redacao, dsc_tema_redacao)
values
  (DBVESTIB.TEMA_REDACAO_S.NEXTVAL, 2057, 'TEMA DE REDACAO 1', 1, 'TESTE TESTE TESTE </ BR> TESTE TESTE TESTE </ BR>');

insert into dbvestib.tema_redacao
  (cod_tema_redacao, codconc, nom_tema_redacao, num_ordem_tema_redacao, dsc_tema_redacao)
values
  (DBVESTIB.TEMA_REDACAO_S.NEXTVAL, 2057, 'TEMA DE REDACAO 2', 2, 'TESTE TESTE TESTE </ BR> TESTE TESTE TESTE </ BR>');

insert into dbvestib.tema_redacao
  (cod_tema_redacao, codconc, nom_tema_redacao, num_ordem_tema_redacao, dsc_tema_redacao)
values
  (DBVESTIB.TEMA_REDACAO_S.NEXTVAL, 2057, 'TEMA DE REDACAO 3', 3, 'TESTE TESTE TESTE </ BR> TESTE TESTE TESTE </ BR>');

insert into dbvestib.tema_redacao
  (cod_tema_redacao, codconc, nom_tema_redacao, num_ordem_tema_redacao, dsc_tema_redacao)
values
  (DBVESTIB.TEMA_REDACAO_S.NEXTVAL, 2057, 'TEMA DE REDACAO 4', 4, 'TESTE TESTE TESTE </ BR> TESTE TESTE TESTE </ BR>');



-- Alterando tipo do concurso para o tipo correspondente ao vestibular EAD e indisponibilizando todos os cursos deste concurso

UPDATE DBVESTIB.CONCURSO C SET C.COD_TPO_CONCURSO = 73 WHERE C.CODCONC = 2057;

UPDATE DBVESTIB.CURSO CU SET CU.INDINSCRICAO = 'N' WHERE CU.CODCONC = 2057;

UPDATE DBVESTIB.RCURTUR RCU SET RCU.INDINSCRICAO = 'N' WHERE RCU.CODCONC = 2057;
-- UPDATE DBVESTIB.CURSO_CAMPUS CCA SET CCA.COD_CURSO_SIAF = NULL WHERE CCA.CODCONC = 2057 AND CCA.CODCUR IN ('02','04');
-----------------------------------------------------------------------------------------------

-- associando os campus criados com 2 cursos de exemplo no VESTIB (02 e 04) aos campus criados
-- Isso faz os locais de agendamento serem vinculados ao processo de agendamento desse concurso

insert into dbvestib.curso_campus
  (codconc, codcur, codcam, cod_periodo_letivo, cod_curso_siaf, cod_curso_siaf_turma)
values
  (2057, '02', 88, 2283, 1103, NULL);

insert into dbvestib.curso_campus
  (codconc, codcur, codcam, cod_periodo_letivo, cod_curso_siaf, cod_curso_siaf_turma)
values
  (2057, '02', 89, 2283, 1103, NULL);

insert into dbvestib.rcurtur
  (codconc,
   codcur,
   codtur,
   valins,
   valmens,
   turma_siaf,
   indinscricao,
   cod_grd_qualificacao_siaf,
   cod_grd_curricular_siaf,
   indcancelado,
   cod_grd_curricular_siaf_turma,
   cod_grd_qualif_siaf_turma,
   ind_liberar_resultado,
   codcam)
values
  ('2057',
   '02',
   '15',
   0,
   0,
   NULL,
   'N',
   12009,
   7757,
   'N',
   NULL,
   NULL,
   'S',
   '88');

insert into dbvestib.rcurtur
  (codconc,
   codcur,
   codtur,
   valins,
   valmens,
   turma_siaf,
   indinscricao,
   cod_grd_qualificacao_siaf,
   cod_grd_curricular_siaf,
   indcancelado,
   cod_grd_curricular_siaf_turma,
   cod_grd_qualif_siaf_turma,
   ind_liberar_resultado,
   codcam)
values
  ('2057',
   '02',
   '15',
   0,
   0,
   NULL,
   'N',
   12009,
   7757,
   'N',
   NULL,
   NULL,
   'S',
   '89');

insert into dbvestib.rcurturopc
  (codconc, codcur, codtur, opclin,CODCAM)
values
  ('2057', '02', '15', 0,'88');

insert into dbvestib.rcurturopc
  (codconc, codcur, codtur, opclin,CODCAM)
values
  ('2057', '02', '15', 0,'89');

--SELECT * FROM DBVESTIB.CURSO_CAMPUS CA WHERE CA.CODCONC = '2057' AND CA.CODCUR = '02'


insert into dbvestib.curso_campus
  (codconc, codcur, codcam, cod_periodo_letivo, cod_curso_siaf, cod_curso_siaf_turma)
values
  (2057, '04', '88', 2283, 1106, NULL);
  
insert into dbvestib.curso_campus
  (codconc, codcur, codcam, cod_periodo_letivo, cod_curso_siaf, cod_curso_siaf_turma)
values
  (2057, '04', '89', 2283, 1106, NULL);
  
    

insert into dbvestib.rcurtur
  (codconc,
   codcur,
   codtur,
   valins,
   valmens,
   turma_siaf,
   indinscricao,
   cod_grd_qualificacao_siaf,
   cod_grd_curricular_siaf,
   indcancelado,
   cod_grd_curricular_siaf_turma,
   cod_grd_qualif_siaf_turma,
   ind_liberar_resultado,
   codcam)
values
  ('2057',
   '04',
   '15',
   0,
   0,
   NULL,
   'N',
   12020,
   7707,
   'N',
   NULL,
   NULL,
   'S',
   '88');

insert into dbvestib.rcurtur
  (codconc,
   codcur,
   codtur,
   valins,
   valmens,
   turma_siaf,
   indinscricao,
   cod_grd_qualificacao_siaf,
   cod_grd_curricular_siaf,
   indcancelado,
   cod_grd_curricular_siaf_turma,
   cod_grd_qualif_siaf_turma,
   ind_liberar_resultado,
   codcam)
values
  ('2057',
   '04',
   '15',
   0,
   0,
   NULL,
   'N',
   12020,
   7707,
   'N',
   NULL,
   NULL,
   'S',
   '89');

insert into dbvestib.rcurturopc
  (codconc, codcur, codtur, opclin,CODCAM)
values
  ('2057', '04', '15', 0,'88');

insert into dbvestib.rcurturopc
  (codconc, codcur, codtur, opclin,CODCAM)
values
  ('2057', '04', '15', 0,'89');
-------------------------------------------------------------------------------------------------------------------------

-- Liberando os cursos de teste para inscrição.
UPDATE DBVESTIB.CURSO CU SET CU.INDINSCRICAO = 'S' WHERE CU.CODCONC = 2057 AND CU.CODCUR IN('02','04');

UPDATE DBVESTIB.RCURTUR RCU SET RCU.INDINSCRICAO = 'S' WHERE RCU.CODCONC = 2057 AND RCU.CODCUR IN ('02','04') AND RCU.CODCAM IN ('88','89');


-- Criando centros de custo de teste para inscricao

insert into dbsiaf.campus_centro_custo
  (cod_ctr_custo_campus, cod_campus, cod_curso, cod_qualificacao, dsc_plano_ccusto, cod_unidade_negocio, cod_ctr_custo, dat_ini_ctr_custo, dat_fim_ctr_custo)
 
select dbsiaf.campus_centro_custo_s.nextval,
       tab.* from
(select distinct 82,
       cod_curso,
       cod_qualificacao,
       dsc_plano_ccusto,
       cod_unidade_negocio,
       cod_ctr_custo,
       dat_ini_ctr_custo,
       dat_fim_ctr_custo
  from dbsiaf.campus_centro_custo ccc
  where ccc.cod_curso = 1103) tab ;
  
insert into dbsiaf.campus_centro_custo
  (cod_ctr_custo_campus, cod_campus, cod_curso, cod_qualificacao, dsc_plano_ccusto, cod_unidade_negocio, cod_ctr_custo, dat_ini_ctr_custo, dat_fim_ctr_custo)
 
select dbsiaf.campus_centro_custo_s.nextval,
       tab.* from
(select distinct 83,
       cod_curso,
       cod_qualificacao,
       dsc_plano_ccusto,
       cod_unidade_negocio,
       cod_ctr_custo,
       dat_ini_ctr_custo,
       dat_fim_ctr_custo
  from dbsiaf.campus_centro_custo ccc
  where ccc.cod_curso = 1103) tab ;
  
    
  
insert into dbsiaf.campus_centro_custo
  (cod_ctr_custo_campus, cod_campus, cod_curso, cod_qualificacao, dsc_plano_ccusto, cod_unidade_negocio, cod_ctr_custo, dat_ini_ctr_custo, dat_fim_ctr_custo)
  
select dbsiaf.campus_centro_custo_s.nextval,
       tab.* from
(select distinct 82,
       cod_curso,
       cod_qualificacao,
       dsc_plano_ccusto,
       cod_unidade_negocio,
       cod_ctr_custo,
       dat_ini_ctr_custo,
       dat_fim_ctr_custo
  from dbsiaf.campus_centro_custo ccc
  where ccc.cod_curso = 1106) tab ;
  
insert into dbsiaf.campus_centro_custo
  (cod_ctr_custo_campus, cod_campus, cod_curso, cod_qualificacao, dsc_plano_ccusto, cod_unidade_negocio, cod_ctr_custo, dat_ini_ctr_custo, dat_fim_ctr_custo)
 
select dbsiaf.campus_centro_custo_s.nextval,
       tab.* from
(select distinct 83,
       cod_curso,
       cod_qualificacao,
       dsc_plano_ccusto,
       cod_unidade_negocio,
       cod_ctr_custo,
       dat_ini_ctr_custo,
       dat_fim_ctr_custo
  from dbsiaf.campus_centro_custo ccc
  where ccc.cod_curso = 1106) tab ;  



/*SELECT * FROM DBVESTIB.TURNO
DBVESTIB.CURSO_CAMPUS*/

-- SELECT * FROM DBSIAF.PERIODO_LETIVO WHERE SGL_PERIODO_LETIVO = '2014/2'


--SELECT * FROM DBVESTIB.TIPO_CONCURSO
