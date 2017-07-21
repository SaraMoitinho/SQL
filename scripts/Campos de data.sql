-- Add/modify columns 
alter table DBVESTIB.PARAMETROS_CONCURSO add DAT_PROVA_1A_ETAPA DATE;
alter table DBVESTIB.PARAMETROS_CONCURSO add DAT_PROVA_2A_ETAPA DATE;
alter table DBVESTIB.PARAMETROS_CONCURSO add DAT_RESULTADO_1A_ETAPA DATE;
alter table DBVESTIB.PARAMETROS_CONCURSO add DAT_RESULTADO_2A_ETAPA DATE;
-- Add comments to the columns 
comment on column DBVESTIB.PARAMETROS_CONCURSO.DAT_PROVA_1A_ETAPA
  is 'Data da prova 1° Etapa ';
comment on column DBVESTIB.PARAMETROS_CONCURSO.DAT_PROVA_2A_ETAPA
  is 'Data da Prova 2° Etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO.DAT_RESULTADO_1A_ETAPA
  is 'Data do Resultado da 1° Etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO.DAT_RESULTADO_2A_ETAPA
  is 'Data do Resultado da 2° Etapa';



