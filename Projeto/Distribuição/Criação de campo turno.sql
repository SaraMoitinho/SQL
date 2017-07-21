-- Add/modify columns 
alter table DBVESTIB.CADERNOSALA add CODTUR varchar2(10);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DBVESTIB.CADERNOSALA
  add constraint FK_CODTUR foreign key (CODTUR)
  references dbvestib.turno (CODTUR);
