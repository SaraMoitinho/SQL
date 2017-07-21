
--------------------------------------------------------
-------------------- TMP ESTRUTURA PESSOA --------------
--------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE DBSIAF.TMP_ESTRUTURA_PESSOA
(
  COD_ESTRUTURA_PESSOA NUMBER(10),
  COD_ESTRUTURA NUMBER(10),
  COD_PESSOA    NUMBER(10),
  NUM_CPF       VARCHAR2(11),
  NUM_CNPJ      VARCHAR (14),
  CAPACIDADE  NUMBER(10)
)
ON COMMIT DELETE ROWS;

create GLOBAL TEMPORARY table DBSIAF.TMP_ENDERECO_ESTRUTURA
(
  COD_ESTRUTURA    NUMBER(10),
  COD_CIDADE       NUMBER(10),
  NOM_LOGRADOURO   VARCHAR2(200),
  NOM_COMPLEMENTO  VARCHAR2(40),
  NOM_BAIRRO       VARCHAR2(30),
  CEP_ENDERECO     VARCHAR2(10),
  TEL_ENDERECO     VARCHAR2(14),
  REFERENCIA       VARCHAR2(100)
) ON COMMIT DELETE ROWS;


--------------------------------------------------------
-------------------- TIPO ESTRUTURA -------------------
--------------------------------------------------------
/*SER� USADO COMO SEQUENCE DA DBSIAF.TIPO_ESTRUTURA_ORGANIZACIONAL

CREATE SEQUENCE DBSIAF.TIPO_ESTRUTURA_S
MINVALUE 1
MAXVALUE 9999999999
START WITH 19
INCREMENT BY 1;
*/
---------------------------------------------------------
------------ ESTRUTURA ORGANIZACIONAL -------------------
---------------------------------------------------------

ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  ADD TEL_CELULAR VARCHAR2(20);
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  ADD DATA_CADASTRO DATE;
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  ADD EML_ESTRUTURA VARCHAR2(100);
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  ADD  IND_ATIVO CHAR(1); 
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  MODIFY  IND_ATIVO CHAR(1) NOT NULL novalidate; 
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  MODIFY  IND_ATIVO CHAR(1) default 'N';
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL ADD DSC_COD_LOCALIZADOR VARCHAR2(100);
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL  ADD  CAPACIDADE  NUMBER(10);
ALTER TABLE DBSIAF.ESTRUTURA_ORGANIZACIONAL ADD CONSTRAINT TPO_ESTRUTURA_ORG_FK FOREIGN KEY (COD_TPO_ESTRUTURA)REFERENCES DBSIAF.TIPO_ESTRUTURA_ORGANIZACIONAL (COD_TPO_ESTRUTURA); 
--CREATE INDEX DBSIAF.IX_LOCALIZADOR ON DBSIAF.ESTRUTURA_ORGANIZACIONAL (DSC_COD_LOCALIZADOR) TABLESPACE TS_INDX_DBSIAF;
CREATE UNIQUE INDEX DBSIAF.IX_LOCALIZADOR on DBSIAF.ESTRUTURA_ORGANIZACIONAL (UPPER(TRIM(TRANSLATE(DSC_COD_LOCALIZADOR,'������������������������������������������������A@#$%�&*()-_+=|\/?!{},.;:"<>[]''^~`����''','AEIOUAEIOUAEIOUAEIOUAOCNaeiouaeiouaeiouaeuouaocnA'))))TABLESPACE TS_INDX_DBSIAF;

---------------------------------------------------------
------------------ ENDERECO ESTRUTURA -------------------
---------------------------------------------------------


ALTER TABLE DBSIAF.ENDERECO_ESTRUTURA  add  REFERENCIA  VARCHAR2(100); 
alter table DBSIAF.ENDERECO_ESTRUTURA modify NOM_LOGRADOURO VARCHAR2(200);
alter table DBSIAF.ENDERECO_ESTRUTURA_log modify NOM_LOGRADOURO VARCHAR2(200);

ALTER TABLE DBSIAF.ENDERECO_ESTRUTURA ADD CONSTRAINT CIDADE_ESTRUTURA_FK FOREIGN KEY (COD_CIDADE) REFERENCES DBSIAF.CIDADE (COD_CIDADE);
--ON COMMIT DELETE ROWS;
CREATE INDEX DBSIAF.IX_ENDERECO_ESTRUTURA ON DBSIAF.ENDERECO_ESTRUTURA (COD_CIDADE) TABLESPACE TS_INDX_DBSIAF; 
--CREATE INDEX DBSIAF.IX_ESTRUTURA ON DBSIAF.ENDERECO_ESTRUTURA (COD_ESTRUTURA)TABLESPACE TS_INDX_DBSIAF;
  
---------------------------------------------------------
------------------ ESTRUTURA PESSOA --------------------
---------------------------------------------------------
CREATE SEQUENCE DBSIAF.ESTRUTURA_PESSOA_S
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1;

CREATE TABLE DBSIAF.ESTRUTURA_PESSOA
(
  COD_ESTRUTURA_PESSOA NUMBER(10) NOT NULL,     
  COD_ESTRUTURA NUMBER(10) NOT NULL,
  COD_PESSOA    NUMBER(10) ,
  NUM_CPF       VARCHAR2(11),
  SEXO          CHAR(1),
  NUM_CNPJ       VARCHAR2(14)
)TABLESPACE TS_INDX_DBSIAF ;--ON COMMIT DELETE ROWS;

ALTER TABLE DBSIAF.ESTRUTURA_PESSOA  ADD CONSTRAINT EST_PESSOA_PK PRIMARY KEY (COD_ESTRUTURA_PESSOA)USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.ESTRUTURA_PESSOA  ADD CONSTRAINT EST_PESSOA_FK FOREIGN KEY (COD_ESTRUTURA)REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL(COD_ESTRUTURA);
ALTER TABLE DBSIAF.ESTRUTURA_PESSOA  ADD CONSTRAINT EST_PESSOA_FK1 FOREIGN KEY (COD_PESSOA)REFERENCES DBSIAF.PESSOA(COD_PESSOA);


---------------------------------------------------------
------------------ ESTRUTURA CIDADE ---------------------
---------------------------------------------------------

CREATE TABLE DBSIAF.ESTRUTURA_CIDADE
(
  COD_ESTRUTURA NUMBER(10) NOT NULL,
  COD_CIDADE    NUMBER(10) NOT NULL,
  IND_EXCLUSIVO CHAR(1) DEFAULT 'N' NOT NULL
)TABLESPACE TS_DATA_DBSIAF;
 
COMMENT ON COLUMN DBSIAF.ESTRUTURA_CIDADE.IND_EXCLUSIVO  IS '''S''N�O SE PODE INSERIR OUTRA ESTRUTURA PARA A MESMA CIDADE';
ALTER TABLE DBSIAF.ESTRUTURA_CIDADE ADD CONSTRAINT ESTRUTURA_CIDADE_PK PRIMARY KEY (COD_ESTRUTURA, COD_CIDADE)USING INDEX TABLESPACE TS_INDX_DBSIAF;
CREATE INDEX DBSIAF.IX_ESTRUTURA_CIDADE ON DBSIAF.ESTRUTURA_CIDADE (COD_ESTRUTURA) TABLESPACE TS_INDX_DBSIAF;
CREATE INDEX DBSIAF.IX1_ESTRUTURA_CIDADE ON DBSIAF.ESTRUTURA_CIDADE (COD_CIDADE) TABLESPACE TS_INDX_DBSIAF; 


---------------------------------------------------------
-------------- ESTRUTURA CAMPUS VESTIB ------------------
---------------------------------------------------------

CREATE TABLE DBSIAF.ESTRUTURA_CAMPUS_VESTIB
(
  COD_ESTRUTURA NUMBER(10) NOT NULL,
  CODCAM    CHAR(2) NOT NULL
)TABLESPACE TS_DATA_DBSIAF;
   
ALTER TABLE DBSIAF.ESTRUTURA_CAMPUS_VESTIB  ADD CONSTRAINT ESTRUTURA_CAMPUS_VESTIB_PK PRIMARY KEY (COD_ESTRUTURA, CODCAM)USING INDEX TABLESPACE TS_INDX_DBSIAF;

GRANT REFERENCES ON DBVESTIB.CAMPUS  TO DBSIAF;
ALTER TABLE DBSIAF.ESTRUTURA_CAMPUS_VESTIB  ADD CONSTRAINT ESTRUTURA_CIDADE_FK FOREIGN KEY (CODCAM) REFERENCES DBVESTIB.CAMPUS (CODCAM);
 
ALTER TABLE DBSIAF.ESTRUTURA_CAMPUS_VESTIB  ADD CONSTRAINT ESTRUTURA_CIDADE_FK1 FOREIGN KEY (COD_ESTRUTURA) REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL (COD_ESTRUTURA);
CREATE INDEX DBSIAF.IX_ESTRUTURA_CAMPUS_VESTIB ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB (COD_ESTRUTURA)TABLESPACE TS_INDX_DBSIAF;
CREATE INDEX DBSIAF.IX1_ESTRUTURA_CAMPUS_VESTIB ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB (CODCAM)TABLESPACE TS_INDX_DBSIAF;


---------------------------------------------------------
-------------- ESTRUTURA TIPO_CONCURSO ------------------
---------------------------------------------------------

CREATE TABLE DBSIAF.ESTRUTURA_TIPO_CONCURSO
(
  COD_ESTRUTURA NUMBER(10) NOT NULL,
  COD_TPO_CONCURSO    NUMBER(10) NOT NULL,
  ANOCONC            CHAR(4)      NOT NULL,
  SEMCONC            CHAR(1)     NOT NULL
)TABLESPACE TS_DATA_DBSIAF ;
ALTER TABLE DBSIAF.ESTRUTURA_TIPO_CONCURSO ADD CONSTRAINT ESTRUTURA_TPO_CONCURSO_PK PRIMARY KEY (COD_ESTRUTURA, COD_TPO_CONCURSO, ANOCONC,SEMCONC)USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.ESTRUTURA_TIPO_CONCURSO ADD CONSTRAINT ESTRUTURA_TPO_CONCURSO_FK FOREIGN KEY (COD_TPO_CONCURSO) REFERENCES DBVESTIB.TIPO_CONCURSO (COD_TPO_CONCURSO);
ALTER TABLE DBSIAF.ESTRUTURA_TIPO_CONCURSO ADD CONSTRAINT ESTRUTURA_TPO_CONCURSO_FK1 FOREIGN KEY (COD_ESTRUTURA) REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL (COD_ESTRUTURA);
CREATE INDEX DBSIAF.IX_ESTRUTURA_TIPO_CONCURSO ON DBSIAF.ESTRUTURA_TIPO_CONCURSO(COD_ESTRUTURA)TABLESPACE TS_INDX_DBSIAF;
CREATE INDEX DBSIAF.IX1_ESTRUTURA_TIPO_CONCURSO ON DBSIAF.ESTRUTURA_TIPO_CONCURSO(COD_TPO_CONCURSO)TABLESPACE TS_INDX_DBSIAF;


---------------------------------------------------------
---------------- ESTRUTURA CONCURSO ---------------------
---------------------------------------------------------

CREATE TABLE DBSIAF.ESTRUTURA_CONCURSO
(
  COD_ESTRUTURA       NUMBER(10)   NOT NULL,
  CODCONC             VARCHAR2(10) NOT NULL,
  IND_AGENDA_REPLICADA  CHAR(1)DEFAULT 'N',
  IND_ASSOCIADO          CHAR(1)DEFAULT 'N'
)TABLESPACE TS_DATA_DBSIAF;  
   
COMMENT ON COLUMN DBSIAF.ESTRUTURA_CONCURSO.IND_AGENDA_REPLICADA IS 'S INDICA QUE A AGENDA DA ESTRUTURA FOI CRIADA. ';  
COMMENT ON COLUMN DBSIAF.ESTRUTURA_CONCURSO.IND_ASSOCIADO  IS 'INDICA SE O CONCURSO FOI ASSOCIADO A ESTRUTURA_CONCURSO';
ALTER TABLE DBSIAF.ESTRUTURA_CONCURSO ADD CONSTRAINT ESTRUTURA_CONCURSO_PK PRIMARY KEY (COD_ESTRUTURA, CODCONC)USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.ESTRUTURA_CONCURSO ADD CONSTRAINT ESTRUTURA_CONCURSO_FK FOREIGN KEY (CODCONC) REFERENCES DBVESTIB.CONCURSO (CODCONC);
ALTER TABLE DBSIAF.ESTRUTURA_CONCURSO ADD CONSTRAINT ESTRUTURA_CONC_FK FOREIGN KEY (COD_ESTRUTURA) REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL (COD_ESTRUTURA);
CREATE INDEX DBSIAF.IX_ESTRUTURA_CONCURSO ON DBSIAF.ESTRUTURA_CONCURSO(COD_ESTRUTURA)TABLESPACE TS_INDX_DBSIAF;
CREATE INDEX DBSIAF.IX1_ESTRUTURA_CONCURSO ON DBSIAF.ESTRUTURA_CONCURSO(CODCONC)TABLESPACE TS_INDX_DBSIAF;

---------------------------------------------------------
------------ TIPO CONCURSO ANO SEMESTRE -----------------
---------------------------------------------------------

/*SEQUENCE SER� USADA NA DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE*/

-- CREATE SEQUENCE 
CREATE SEQUENCE DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE_S
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1;


CREATE TABLE DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE
(
  COD_TIPO_CONCURSO_ANO_SEMESTRE   NUMBER(10)   NOT NULL,
  COD_TPO_CONCURSO                 NUMBER(10) NOT NULL, 
  ANOCONC                          CHAR(4)    NOT NULL,
  SEMCONC                          CHAR(1)    NOT NULL
)TABLESPACE TS_DATA_DBSIAF;
    
ALTER TABLE DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE add CONSTRAINT TIPO_CONCURSO_ANO_SEMESTRE_PK PRIMARY KEY (COD_TIPO_CONCURSO_ANO_SEMESTRE) USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE ADD CONSTRAINT TIPO_CONCURSO_ANO_SEMESTRE_FK FOREIGN KEY (COD_TPO_CONCURSO) REFERENCES DBVESTIB.TIPO_CONCURSO(COD_TPO_CONCURSO);
CREATE INDEX DBSIAF.IX_TIPO_CONCURSO_ANO_SEMESTRE ON DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE(COD_TPO_CONCURSO)TABLESPACE TS_INDX_DBSIAF; 



---------------------------------------------------------
---------- HORARIO TIPO CONCURSO ANO SEMESTRE -----------
---------------------------------------------------------

/*SEQUENCE SER� USADA NA DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE*/

-- CREATE SEQUENCE 
CREATE SEQUENCE DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM_S
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1;

CREATE  TABLE DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM
( 
  COD_HORARIO_TPO_CONC_ANO_SEM     NUMBER(10)   NOT NULL,  
  COD_TIPO_CONCURSO_ANO_SEMESTRE   NUMBER(10)   NOT NULL,  
  HOR_INICO                        DATE,
  HOR_FIM                          DATE
)TABLESPACE TS_DATA_DBSIAF; 

ALTER TABLE DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM ADD CONSTRAINT HORARIO_TPO_CONCURSO_ANO_SEM PRIMARY KEY (COD_HORARIO_TPO_CONC_ANO_SEM)USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE ADD CONSTRAINT HORARIO_TPO_CONC_ANO_SE_FK FOREIGN KEY (COD_TIPO_CONCURSO_ANO_SEMESTRE) REFERENCES DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE(COD_TIPO_CONCURSO_ANO_SEMESTRE);

---------------------------------------------------------
---------- INSCRICAO ESTRUTURA ORGANIZACIONAL -----------
---------------------------------------------------------

CREATE TABLE DBVESTIB.INSCRICAO_ESTRUTURA
(
  CODCONC   VARCHAR2(10)   NOT NULL,  
  CODINSC   CHAR(6) NOT NULL,
  COD_ESTRUTURA  NUMBER(10)   NOT NULL,
  IND_LINK CHAR(1),
  IND_ALTERA_WEB  CHAR(1)  DEFAULT 'S' NOT NULL
) TABLESPACE TS_DATA_DBVESTIB;
   


ALTER TABLE DBVESTIB.INSCRICAO_ESTRUTURA ADD CONSTRAINT INSCRICAO_ESTRUTURA_PK PRIMARY KEY (CODCONC, CODINSC, COD_ESTRUTURA)USING INDEX TABLESPACE TS_INDX_DBVESTIB;
ALTER TABLE DBVESTIB.INSCRICAO_ESTRUTURA ADD CONSTRAINT INSCRICAO_ESTRUTURA_FK FOREIGN KEY (CODCONC, CODINSC) REFERENCES DBVESTIB.INSCRICAO(CODCONC, CODINSC);
ALTER TABLE DBVESTIB.INSCRICAO_ESTRUTURA ADD CONSTRAINT INSCRICAO_ESTRUTURA_FK1 FOREIGN KEY (COD_ESTRUTURA) REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL(COD_ESTRUTURA); 
CREATE INDEX DBVESTIB.IX_INSCRICAO_ESTRUTURA ON DBVESTIB.INSCRICAO_ESTRUTURA(CODCONC) TABLESPACE TS_INDX_DBVESTIB;
CREATE INDEX DBVESTIB.IX1_INSCRICAO_ESTRUTURA ON DBVESTIB.INSCRICAO_ESTRUTURA(CODINSC)TABLESPACE TS_INDX_DBVESTIB;
CREATE INDEX DBVESTIB.IX2_INSCRICAO_ESTRUTURA ON DBVESTIB.INSCRICAO_ESTRUTURA(COD_ESTRUTURA)TABLESPACE TS_INDX_DBVESTIB;   


---------------------------------------------------------
---------- ALUNO ESTRUTURA ORGANIZACIONAL -----------
---------------------------------------------------------

CREATE TABLE DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL
(
  COD_ALUNO   NUMBER(10)   NOT NULL,  
  COD_ESTRUTURA  NUMBER(10)   NOT NULL
) TABLESPACE TS_DATA_DBSIAF;
  
ALTER TABLE DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL ADD CONSTRAINT ALUNO_ESTRUTURA_PK PRIMARY KEY (COD_ALUNO, COD_ESTRUTURA)USING INDEX TABLESPACE TS_INDX_DBSIAF;
ALTER TABLE DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL ADD CONSTRAINT ALUNO_ESTRUTURA_FK FOREIGN KEY (COD_ALUNO) REFERENCES DBSIAF.ALUNO(COD_ALUNO);
ALTER TABLE DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL ADD CONSTRAINT ALUNO_ESTRUTURA_FK1 FOREIGN KEY (COD_ESTRUTURA) REFERENCES DBSIAF.ESTRUTURA_ORGANIZACIONAL(COD_ESTRUTURA);
CREATE INDEX DBSIAF.IX_ALUNO_ESTRUTURA ON DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL(COD_ESTRUTURA) TABLESPACE TS_INDX_DBSIAF;   
CREATE INDEX DBSIAF.IX2_ALUNO_ESTRUTURA_ORGANIZ ON DBSIAF.ALUNO_ESTRUTURA_ORGANIZACIONAL(COD_ALUNO) TABLESPACE TS_INDX_DBSIAF;


 ALTER SEQUENCE dbsiaf.estrutura_organizacional_s INCREMENT BY 302;
 
 create table dbsiaf.PROCESSO_TPO_CONCURSO_ANO_SEM
(
  COD_TIPO_CONCURSO_ANO_SEMESTRE    number(10) not null,
  NUM_PRAZO_MIN_HORAS_MARCACAO      number(10),
  NUM_PRAZO_MAX_DIAS_MARCACAO       number(10),
  NUM_PRAZO_HORAS_DESMARCACAO       number(10),
  IND_PERMITE_SUGERIR_HORARIO       char(1),
  NUM_MINUTOS_ENTREVISTA            number(10),
  IND_AGENDAMENTO_OBRIGATORIO       char(1),
  IND_PERMITE_ESCOLHER_LOCAL        char(1),
  IND_CONCLUIR_INSCRICAO_VESTIB     char(1),
  IND_EXIBIR_MOTIVO_AGENDAMENTO     char(1),
  NUM_PRAZO_MIN_DIAS_UTEIS_MARC     number(10),
  NUM_PRAZO_VENC_BOLETO_UTEIS number(10)
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table dbsiaf.PROCESSO_TPO_CONCURSO_ANO_SEM
  add constraint PK_PROC_TPO_CONCURSO_ANO_SEM primary key (COD_TIPO_CONCURSO_ANO_SEMESTRE) using index tablespace ts_indx_dbsiaf;
  
alter table DBSIAF.PROCESSO_TPO_CONCURSO_ANO_SEM
  add constraint FK_TPO_CONCURSO_processo foreign key (COD_TIPO_CONCURSO_ANO_SEMESTRE)
  references dbsiaf.tipo_concurso_ano_semestre (COD_TIPO_CONCURSO_ANO_SEMESTRE);

alter table DBSAG.HIST_AGENDAMENTO  drop constraint FK_HIST_DISPONIBILIDADE;