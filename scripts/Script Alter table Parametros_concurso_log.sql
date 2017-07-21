-- Add/modify columns 
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add DAT_MATRICULA_1A_ETAPA date;
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add DAT_MATRICULA_2A_ETAPA date;
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add HORA_RESULTADO_1A_ETAPA varchar2(180);
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add HORA_RESULTADO_2A_ETAPA varchar2(180);
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add HORA_MATRICULA_1A_ETAPA varchar2(180);
alter table DBVESTIB.PARAMETROS_CONCURSO_LOG add HORA_MATRICULA_2A_ETAPA varchar2(180);
-- Add comments to the columns 
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.DAT_MATRICULA_1A_ETAPA
  is 'Data do Início da Matrícula referente à 1° etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.DAT_MATRICULA_2A_ETAPA
  is 'Data do Início da Matrícula referente à 2° etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.HORA_RESULTADO_1A_ETAPA
  is 'Hora do Resultado da 1° Etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.HORA_RESULTADO_2A_ETAPA
  is 'Hora do Resultado da 1° Etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.HORA_MATRICULA_1A_ETAPA
  is 'Hora do Início da Matrícula referente à 1° etapa';
comment on column DBVESTIB.PARAMETROS_CONCURSO_LOG.HORA_MATRICULA_2A_ETAPA
  is 'Hora do Início da Matrícula referente à 2° etapa';
