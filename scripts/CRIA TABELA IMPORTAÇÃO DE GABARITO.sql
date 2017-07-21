-- Create table
create table DBVESTIB.CONFIGURACAO_IMPORTA_GABARITO
(
  CODCONC    varchar2(10) not null,
  NOMCAMPO   varchar2(32) not null,
  ORDCAMPO   number(6) not null,
  INDATIVO   char(2) not null,
  VLRDEFAULT varchar2(500),
  DSC_CAMPO  varchar2(500) not null
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.CONFIGURACAO_IMPORTA_GABARITO
  add constraint PK_CONF_IMPORTA_GABARITO primary key (CODCONC, NOMCAMPO);
-- Grant/Revoke object privileges 
grant select, insert, update, delete on DBVESTIB.CONFIGURACAO_IMPORTA_GABARITO to user_dbvestib;
grant select, insert, update, delete on DBVESTIB.CONFIGURACAO_IMPORTA_GABARITO to user_dbvestibweb;
