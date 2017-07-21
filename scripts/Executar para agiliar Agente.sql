
INSERT INTO DBVESTIB.TIPO_INFORMACAO(COD_TIPO_INFORMACAO,DSC_TIPO_INFORMACAO)
VALUES ( DBVESTIB.TIPO_INFORMACAO_S.NEXTVAL, 'Informação Indicação Agente');
commit;

insert into dbadm.item_menu(cod_item_menu, cod_sistema, cod_item_menu_pai, tit_item_menu, ord_item_menu, nom_item_menu, cod_tpo_item_menu, ind_separador, cod_sta_item_menu) 
values (dbadm.item_menu_s.nextval, 41, 6017, 'Horário Padrão',2, 'frmHorarioPadrao', 1, 'N', 1); 
commit;

insert into dbadm.item_menu(cod_item_menu, cod_sistema, cod_item_menu_pai, tit_item_menu, ord_item_menu, nom_item_menu, cod_tpo_item_menu, ind_separador, cod_sta_item_menu) 
values (dbadm.item_menu_s.nextval, 41, 6017, 'Criar/Excluir Horários',3, 'frmHorarioAgentes', 1, 'N', 1); 
commit;


begin
dbadm.sp_copia_relatorio(799, 'Lista de Presenca (Agente)');
end;
