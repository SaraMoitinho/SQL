
 -- Create table
create table DBVESTIB.CLASSIFICACAO_EAD
(
  COD_CLASSIFICACAO_EAD  NUMBER(10) not null,
  CODCONC                VARCHAR2(10) not null,
  CODCAN                 CHAR(6)not null,
  CODCAM                 CHAR(2)not null,
  DATA_PROVA             DATE not null,
  HORA_PROVA             VARCHAR2(10) );
-- Create/Recreate primary, unique and foreign key constraints 
alter table dbvestib.CLASSIFICACAO_EAD 
  add constraint PK_COD_CLASSIFICACAO_EAD primary key (COD_CLASSIFICACAO_EAD) using index tablespace TS_INDX_DBVESTIB;

alter table dbvestib.CLASSIFICACAO_EAD
  add constraint FK_CLASSIFICACAO_EAD foreign key (CODCONC,CODCAN) 
  references DBVESTIB.CANDIDATO(CODCONC, CODCAN)  ;
 
-- Add comments to the columns 
comment on column dbvestib.CLASSIFICACAO_EAD.CODCAM
  is 'Cód do campus/Pólo VESTIB';

comment on column dbvestib.CLASSIFICACAO_EAD.DATA_PROVA
  is 'É a Data*/hora do agendamento. Para candidato ENEM, esta é a data início da tela da classificação EAD';  
  
-- Create sequence 
create sequence dbvestib.CLASSIFICACAO_EAD_S
minvalue 1
start with 1
increment by 1
order;



BEGIN
dblog.pc_log.SP_CRIA_LOG('DBVESTIB',
                             'CLASSIFICACAO_EAD',
                             'DBVESTIB',
                             'CLASSIFICACAO_EAD',
                             'N');

dblog.pc_log.SP_ATUALIZA_LOG('DBVESTIB',
                             'CLASSIFICACAO_EAD',
                             'CLASSIFICACAO_EAD',
                             'N');
END;                             

grant  select, INSERT on dbvestib.classificacao_ead_LOG to desenv, USER_DBVESTIB;
grant  SELECT, insert, delete , ALTER on dbVESTIB.CLASSIFICACAO_EAD to desenv,  user_dbvestib  ; 
grant  SELECT on dbVESTIB.CLASSIFICACAO_EAD_s to desenv,  user_dbvestib  ;
