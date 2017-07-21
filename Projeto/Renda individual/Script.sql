-- Add/modify columns 
alter table DBVESTIB.RENDA_MENSAL add IND_EXIBE_INDIVIDUAL char(1) not null;
alter table DBVESTIB.RENDA_MENSAL add IND_EXIBE_FAMILIAR char(1) not null;

alter table DBVESTIB.INSCRICAO add COD_RENDA_MENSAL_FAMILIAR NUMBER(10) not null;

alter table DBVESTIB.INSCRICAO
  add constraint FK_RENDA_MENSAL_FAMILIAR foreign key (COD_RENDA_MENSAL_FAMILIAR)
  references dbvestib.renda_mensal (COD_RENDA_MENSAL);
  


BEGIN 
     DBLOG.PC_LOG.SP_ATUALIZA_LOG('DBVESTIB', 'INSCRICAO', null, 'N'); 
END;


INSERT INTO DBADM.ITEM_MENU 
  (COD_ITEM_MENU, 
   COD_SISTEMA, 
   COD_ITEM_MENU_PAI, 
   TIT_ITEM_MENU, 
   ORD_ITEM_MENU, 
   NOM_ITEM_MENU, 
   COD_TPO_ITEM_MENU, 
   IND_SEPARADOR, 
   COD_STA_ITEM_MENU) 
VALUES 
  (dbadm.item_menu_s.nextval, 
   41, 
   3936, 
   'Renda Individual/Familiar', 
   57, 
   'frmConfRenda', 
   1, 
   'N', 
   1); 
   
   insert into dbadm.perm_grp_usuario 
  (cod_grp_usuario, cod_item_menu) 
values 
  (2, 5963);  -- Item de menu
