
-- Add/modify columns 
alter table DBVESTIB.INSCRICAO add COD_INSTIT_ENSINO_MEDIO number(10);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.INSCRICAO
  add constraint FK_INSTIT_EXT_ENSINOMEDIO_INSC foreign key (COD_INSTIT_ENSINO_MEDIO)
  references dbsiaf.instituicao_externa (COD_INSTIT_EXTERNA);



-- Add/modify columns 
alter table DBVESTIB.CANDIDATO add COD_INSTIT_ENSINO_MEDIO number(10);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.CANDIDATO
  add constraint FK_INSTIT_ENSINOMEDIO_INSC foreign key (COD_INSTIT_ENSINO_MEDIO)
  references dbsiaf.instituicao_externa (COD_INSTIT_EXTERNA);
