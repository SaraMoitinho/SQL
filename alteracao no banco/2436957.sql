/*
--Quero ver minhas atividades curriculares  Atividades Curriculares
select * from DBADM.ITEM_MENU i
where i.cod_sistema = 57;*/


     
UPDATE DBADM.ITEM_MENU MM
  SET MM.ORD_ITEM_MENU = MM.ORD_ITEM_MENU + 2
WHERE MM.COD_SISTEMA = 57;


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
   57, 
   null, 
   'Para voc�', 
   0, 
   NULL, 
   1, 
   'N', 
   1); 
   commit;
   
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
   57, 
   6000, 
   'Atividades Curriculares', 
   1, 
   '/SOL/aluno/index.php/atividade_extra', 
   1, 
   'N', 
   1); 
 
