-- Create/Recreate check constraints 
alter table DBVESTIB.INSCRICAO
  add constraint CHK_FORMAPGTO_INS
  check (FORMAPGTO IN ('B','V','M','1','2','3','4','5','6', '7','8','9'));
