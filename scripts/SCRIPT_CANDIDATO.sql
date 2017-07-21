ALTER TRIGGER DBVESTIB.TBUID_CANDIDATO DISABLE ; 
alter table dbvestib.CANDIDATO_log_bi modify ramal CHAR(9); 
alter table dbvestib.CANDIDATO_log modify ramal CHAR(9); 
alter table dbvestib.CANDIDATO modify ramal CHAR(9); 
ALTER TRIGGER DBVESTIB.TBUID_CANDIDATO ENABLE; 
