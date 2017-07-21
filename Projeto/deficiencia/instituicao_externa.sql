/*-- Create table
create table dbvestib.instituicao_externa
(
  cod_instituicao               number(10) not null,
  nom_instituicao               varchar2(300)not null,
  cod_instituicao_vestib number(10) null,
  cod_instituicao_siaf  number(10) null,
  dat_operacao_log date
)
tablespace TS_DATA_DBVESTIB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
  );

BEGIN
	DBLOG.PC_LOG.SP_CRIA_LOG('DBVESTIB',
							 'INSTITUICAO_EXTERNA',
							 'DBVESTIB',
							 'INSTITUICAO_EXTERNA',
							 'N');
	DBLOG.PC_LOG.SP_ATUALIZA_LOG('DBVESTIB',
								 'INSTITUICAO_EXTERNA',
								 'INSTITUICAO_EXTERNA',
								 'N');
END;

GRANT SELECT, ALTER,insert, delete, update ON DBVESTIB.INSTITUICAO_EXTERNA TO user_DBVESTIB;
GRANT SELECT, ALTER ON DBVESTIB.INSTITUICAO_EXTERNA_LOG TO USER_DBVESTIB;
*/



create table dbvestib.inscricao_inst_externa
( codconc                       VARCHAR2(10) not null,                           
  codinsc                       char(6) not null, 
  COD_INSTIT_EXTERNA            NUMBER(10) not null, 
  cod_usuario_log              NUMBER(10),
  dat_operacao_log date
)
tablespace TS_DATA_DBVESTIB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
  );



BEGIN
	DBLOG.PC_LOG.SP_CRIA_LOG('DBVESTIB',
							 'inscricao_inst_externa',
							 'DBVESTIB',
							 'inscricao_inst_externa',
							 'N');
END;                             

BEGIN
	DBLOG.PC_LOG.SP_ATUALIZA_LOG('DBVESTIB',
								 'inscricao_inst_externa',
								 'inscricao_inst_externa',
								 'N');
END;

GRANT SELECT, ALTER,insert, delete, update ON DBVESTIB.inscricao_inst_externa TO user_DBVESTIB;
GRANT SELECT, insert, ALTER ON DBVESTIB.inscricao_inst_externa_LOG TO DBVESTIB;

-- Create/Recreate primary, unique and foreign key constraints 
alter table dbvestib.INSCRICAO_INST_EXTERNA
  drop constraint PK_INST_EXTERNA cascade;
alter table dbvestib.INSCRICAO_INST_EXTERNA
  add constraint PK_INST_EXTERNA primary key (CODCONC, CODINSC, COD_INSTIT_EXTERNA);
alter table dbvestib.INSCRICAO_INST_EXTERNA
  add constraint FK_INST_EXTERNA foreign key (CODCONC, CODINSC)
  references dbvestib.inscricao (CODCONC, CODINSC);
alter table dbvestib.INSCRICAO_INST_EXTERNA
  add constraint FK_COD_INSTIT_EXTERNA foreign key (COD_INSTIT_EXTERNA)
  references dbsiaf.instituicao_externa (COD_INSTIT_EXTERNA);

 
insert into dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
values 
(dbvestib.passos_inscricao_s.nextval,1,'instituicaoexterna/index/index', 'Instituição Externa', 7, null, 'S', 'instituicaoExterna.beforeNextStep', 'instituicaoExterna.afterLoadStep');
commit;

select * 
FROM DBVESTIB.PASSOS_INSCRICAO PPP
WHERE PPP.COD_TPO_CONCURSO = 1 for update


SELECT ins.cod_instit_externa, cod_usuario_log
FROM DBVESTIB.INSCRICAO INS
WHERE CODCONC = '1940'
and codinsc = '135451'
AND CPFCAN = '22651348805';

SELeCT A.NUM_MATRICULA,
	   A.COD_STA_ALUNO
  FROM DBVESTIB.CANDIDATO C,
	   DBVESTIB.CONCURSO  CON,
	   DBSIAF.ALUNO       A
 WHERE CON.CODCONC = C.CODCONC
	   AND C.CODCONC = '1962'
	   --AND C.CODCAN = '108879'
	   AND A.CODCONC = C.CODCONC
	   AND A.CODCAN = C.CODCAN
	  AND a.eml_aluno LIKE '%boy18%'
	   AND NOT EXISTS (SELECT 1
		  FROM DBSIAF.ALUNO AL
		 WHERE AL.CODCONC = C.CODCONC
			   AND AL.CODCAN = C.CODCAN) ;*/
               

select * from dbvestib.instituicao_externa;
dbvestib.pc_classificacao
dbsiaf.pc_vestibular

 UPDATE DBVESTIB.INSCRICAO INS
     SET INS.COD_INSTIT_EXTERNA = 73870
   WHERE INS.CODCONC = '1940'
     AND INS.CODINSC = '135451'


select
* from dbvestib.inscricao_deficiencia d
where codconc = '1940'
and codinsc = '135451'
dbvestib.parametros_concurso;

SELECT
	INS.COD_INSTIT_EXTERNA CODINSTITEXTERNA,
	INS.NOM_INSTIT_EXTERNA NOMINSTITEXTERNA
FROM
	DBSIAF.INSTITUICAO_EXTERNA INS
WHERE
	 upper(INS.NOM_INSTIT_EXTERNA) LIKE upper('puc ')||'%'
     and  INS.COD_TPO_INSTITUICAO = 60
ORDER BY 
	INS.NOM_INSTIT_EXTERNA
    
    SELECT * FROM DBSIAF.TIPO_INSTITUICAO
    
    select *
    from dbvestib.configuracao_concurso c
    where codconc  = '1969'
    1969, 2016, 2017,2018
    
    
    insert into dbvestib.configuracao_concurso
    select '1972',
    nomcampo,ordcampo,indativo,vlrdefault,dsc_campo from dbvestib.configuracao_concurso g
    where codconc = '1892'and ordcampo in (55,56)
