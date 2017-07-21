-- Add/modify columns 
alter table DBVESTIB.CANDIDATO add CANADVENT char(1) default 'N';
-- Add comments to the columns 
comment on column DBVESTIB.CANDIDATO.CANADVENT
  is 'Para indicar se o candidato é Advestista';
