SELECT *
  FROM DBA_SCHEDULER_JOBS DBJ
 WHERE 
 DBJ.JOB_NAME LIKE '%SP_CRIAR_AGENDAMENTO_SUGESTAO%'
 OR DBJ.JOB_NAME LIKE '%AGE%'
 OR DBJ.program_name LIKE '%AGENDAMENTO%'
 OR DBJ.program_name LIKE '%AGE%'
 /*DBJ.JOB_NAME LIKE '%SP_ATUALIZA_INCRICAO_COC%'
 OR DBJ.JOB_NAME LIKE '%COC%'
 OR DBJ.program_name LIKE '%COC%'*/
 
 
 DBVESTIB.SP_VERIF_AGENDAM_AUSENTE;
 
