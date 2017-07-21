

-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.PROMOCAO_INSCRICAO
  drop constraint FK_PROM_ALUNO;
alter table DBVESTIB.PROMOCAO_INSCRICAO
  add constraint FK_PROM_ALUNO foreign key (CODALUNO)
  references dbsiaf.aluno (COD_ALUNO) NOVALIDATE;
