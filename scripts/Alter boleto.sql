-- Create/Recreate indexes 
drop index DBVESTIB.IDX_NOSSO_NUMERO;
create index DBVESTIB.IDX_NOSSO_NUMERO on DBVESTIB.DADOS_BOLETO_INSCRICAO (NUMNOSSONUMERO)
  tablespace TS_INDX_DBVESTIB
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
