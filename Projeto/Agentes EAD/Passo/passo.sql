-- modificar a ordem do passo 
update
dbvestib.passos_inscricao p
set p.ord_passo =  p.ord_passo+ 1
where p.cod_tpo_concurso = 1    
and p.ord_passo >2;
commit;

-- insere o passo
insert into  dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
values (dbvestib.passos_inscricao_s.nextval, 1, 'agente/index/index','Agente', 3 ,4511, 'S','agente.beforeNextStep', 'agente.afterLoadStep');
commit;

/*
Para inserir o tipo de informa��o, ser� necess�rio pegar o pr�x codigo da sequence e dpois fazer o insert at� 159
select DBVESTIB.TIPO_INFORMACAO_S.NEXTVAL from dual;
*/


INSERT INTO DBVESTIB.TIPO_INFORMACAO(COD_TIPO_INFORMACAO,DSC_TIPO_INFORMACAO)
VALUES ( DBVESTIB.TIPO_INFORMACAO_S.NEXTVAL, 'Informa��o Indica��o Agente');
commit;

INSERT INTO DBVESTIB.INFORMACAO_CONCURSO(COD_INFORMACAO,CODCONC,COD_TIPO_INFORMACAO,TIT_INFORMACAO,ORD_INFORMACAO,DSC_INFORMACAO)
VALUES(DBVESTIB.INFORMACAO_CONCURSO_S.NEXTVAL,'3393', 160, 'Informa��o de indica��o de Agente',1, 'Esta informa��o � cadastrada no Vestib.');
commit;

INSERT INTO DBVESTIB.INFORMACAO_CONCURSO(COD_INFORMACAO,CODCONC,COD_TIPO_INFORMACAO,TIT_INFORMACAO,ORD_INFORMACAO,DSC_INFORMACAO)
VALUES(DBVESTIB.INFORMACAO_CONCURSO_S.NEXTVAL,'3393', 160, 'Preenchimento dos campos de indica��o de Agente',2, 'Favor preecher um dos campos para indica��o do agente.');
commit;

INSERT INTO DBVESTIB.INFORMACAO_CONCURSO(COD_INFORMACAO,CODCONC,COD_TIPO_INFORMACAO,TIT_INFORMACAO,ORD_INFORMACAO,DSC_INFORMACAO)
VALUES(DBVESTIB.INFORMACAO_CONCURSO_S.NEXTVAL,'3393', 160, 'Preenchimento dos campos de indica��o de Agente',3, 'Informa��o para agente exclusivo');
commit;

-----------------------------------------------------------------------------------------
