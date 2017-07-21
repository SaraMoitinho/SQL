-- Add/modify columns 
alter table DBVESTIB.CONCURSO add MODELO_PROVA varchar2(100);
BEGIN
     DBLOG.PC_LOG.SP_ATUALIZA_LOG('DBVESTIB', 'CONCURSO', null, 'N');
     END;
