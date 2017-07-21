-- Create table
CREATE table DBVESTIB.DESTINO_AZUL
(
  cod_destino_azul number(10) not null,
  dsc_destino_azul varchar2(200),
  nom_aeroporto    varchar2(200) not null
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
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.DESTINO_AZUL  add constraint PK_DESTINO_AZUL primary key (COD_DESTINO_AZUL) using INDEX tablespace ts_indx_dbvestib;
 

begin
  dblog.pc_log.SP_CRIA_LOG(  'DBVESTIB', 'DESTINO_AZUL','DBVESTIB', 'DESTINO_AZUL', 'N');
  dblog.pc_log.SP_ATUALIZA_LOG(  'DBVESTIB', 'DESTINO_AZUL','DESTINO_AZUL', 'N');
end;

GRANT SELECT, UPDATE, INSERT, DELETE ON DBVESTIB.DESTINO_AZUL TO DESENV;  
GRANT SELECT, UPDATE, INSERT, DELETE ON DBVESTIB.DESTINO_AZUL to user_dbvestib;

GRANT SELECT, INSERT ON DBVESTIB.DESTINO_AZUL_LOG TO DESENV;
GRANT SELECT, INSERT ON DBVESTIB.DESTINO_AZUL_LOG TO user_dbvestib;

-- Create sequence 
create sequence DBVESTIB.DESTINO_AZUL_S
minvalue 1
start with 1
increment by 1;


GRANT SELECT ON DBVESTIB.DESTINO_AZUL_S TO DESENV;

---- origem_destino_azul

-- Create table
CREATE table DBVESTIB.ORIGEM_DESTINO_AZUL
(
  cod_origem number(10) not null,
  cod_destino number(10) not null
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
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table dbvestib.ORIGEM_DESTINO_AZUL
  add constraint FK_ORIGEM_DESTINO_AZUL foreign key (COD_DESTINO)
  references dbvestib.destino_azul (COD_DESTINO_AZUL);
alter table dbvestib.ORIGEM_DESTINO_AZUL
  add constraint FK_ORIGEM_DESTINO_AZUL foreign key (COD_ORIGEM)
  references dbvestib.destino_azul (COD_DESTINO_AZUL);  

begin
 DBVESTIB.DESTINO_AZUL_LOG
  dblog.pc_log.SP_CRIA_LOG(  'DBVESTIB', 'ORIGEM_DESTINO_AZUL','DBVESTIB', 'ORIGEM_DESTINO_AZUL', 'N');
BEGIN  dblog.pc_log.SP_ATUALIZA_LOG(  'DBVESTIB', 'ORIGEM_DESTINO_AZUL','ORIGEM_DESTINO_AZUL_LOG', 'N');
end;  

GRANT SELECT, UPDATE, INSERT, DELETE ON DBVESTIB.ORIGEM_DESTINO_AZUL TO DESENV;  

GRANT SELECT, INSERT ON DBVESTIB.ORIGEM_DESTINO_AZUL_LOG TO DESENV;

------------- MODIFICANDO A TABELA CAMPUS

-- Add/modify columns 
alter table dbvestib.CAMPUS add cod_destino_azul number(10);
-- Create/Recreate primary, unique and foreign key constraints 

alter table dbvestib.CAMPUS
  add constraint FK_CAMPUS_DESTINO_AZUL foreign key (COD_DESTINO_AZUL)
  references dbvestib.destino_azul (COD_DESTINO_AZUL);


------------ inscri��o Origem


CREATE table DBVESTIB.INSCRICAO_ORIGEM_AZUL
( COD_INSCRICAO_ORIGEM_AZUL NUMBER(10) NOT NULL,
  COD_ORIGEM NUMBER(10) NOT NULL,
  CODCONC VARCHAR2(10)NOT NULL,
  CODINSC CHAR(06) NOT NULL
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
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.INSCRICAO_ORIGEM_AZUL  add constraint PK_COD_INSCRICAO_ORIGEM_AZUL primary key (COD_INSCRICAO_ORIGEM_AZUL) using INDEX tablespace ts_indx_dbvestib;

ALTER TABLE DBVESTIB.INSCRICAO_ORIGEM_AZUL
  ADD CONSTRAINT FK_INSCRICAO_ORIGEM_AZUL   FOREIGN KEY (CODINSC,  CODCONC) 
  REFERENCES DBVESTIB.INSCRICAO (CODINSC, CODCONC);


begin
  dblog.pc_log.SP_CRIA_LOG(  'DBVESTIB', ' INSCRICAO_ORIGEM_AZUL','DBVESTIB', 'INSCRICAO_ORIGEM_AZUL', 'N');
  dblog.pc_log.SP_ATUALIZA_LOG(  'DBVESTIB', 'INSCRICAO_ORIGEM_AZUL','INSCRICAO_ORIGEM_AZUL', 'N');
end;  

GRANT SELECT, UPDATE, INSERT, DELETE ON DBVESTIB.INSCRICAO_ORIGEM_AZUL TO DESENV;  

GRANT SELECT, INSERT ON DBVESTIB.INSCRICAO_ORIGEM_AZUL_LOG TO DESENV;


-- Create sequence 
create sequence DBVESTIB.INSCRICAO_ORIGEM_AZUL_S
minvalue 1
start with 1
increment by 1; 


GRANT SELECT ON DBVESTIB.INSCRICAO_ORIGEM_AZUL_S TO DESENV;

insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Belo Horizonte ', 'Aeroporto Internacional de Confins - Tancredo Neves ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Bras�lia ' , 'Aeroporto Internacional de Bras�lia / Presidente Jucelino Kubitschek ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Florian�polis ' , ' Aeroporto Internacional de Florian�polis/Herc�lio Luz ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Ilh�us ', 'Aeroporto de Ilh�us/Bahia - Jorge Amado ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Joinville ' , 'Aeroporto de Joinville/SC � Lauro Carneiro de Loyola ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'Salvador ', 'Aeroporto Internacional de Salvador - Dep. Lu�s Eduardo Magalh�es ');
insert into dbvestib.destino_azul(cod_destino_azul,dsc_destino_azul, nom_aeroporto)
values (dbvestib.destino_azul_s.nextval,'S�o Paulo ', 'Aeroporto Internacional de S�o Paulo/Guarulhos - Governador Andr� Franco Montoro ');


SELECT * from dbvestib.destino_azul
