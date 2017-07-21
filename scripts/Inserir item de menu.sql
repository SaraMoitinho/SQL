insert into dbadm.item_menu(cod_item_menu, cod_sistema, cod_item_menu_pai, tit_item_menu, ord_item_menu, nom_item_menu, cod_tpo_item_menu, ind_separador, cod_sta_item_menu) 
values (dbadm.item_menu_s.nextval, 41, 3936, 'agentes', 57, null, 1, 'N', 1); 

insert into dbadm.perm_grp_usuario (cod_grp_usuario, cod_item_menu) 
values (235, 6019);  -- Item de menu   

insert into dbadm.perm_grp_usuario (cod_grp_usuario, cod_item_menu) 
values (2, 6019);  -- Item de menu   

insert into dbadm.item_menu(cod_item_menu, cod_sistema, cod_item_menu_pai, tit_item_menu, ord_item_menu, nom_item_menu, cod_tpo_item_menu, ind_separador, cod_sta_item_menu) 
values (dbadm.item_menu_s.nextval, 41, 6019, 'Cadastro', 1, 'frmAgente', 1, 'N', 1); 

insert into dbadm.perm_grp_usuario (cod_grp_usuario, cod_item_menu) 
values (235, 6021);  -- Item de menu   

insert into dbadm.perm_grp_usuario (cod_grp_usuario, cod_item_menu) 
values (2, 6021);  -- Item de menu   

      
select *
from dbadm.usuario u
where u.nom_usuario like 'Viviani%'; --235

select * from dbadm.
where .cod_usuario = 2972;

select * from DBADM.ITEM_MENU i
where i.cod_sistema = 41
and i.cod_item_menu_pai = 6019
and i.ord_item_menu = 191
select * from dbvestib.forma_pgto

select ii.codconc, codinsc, ii.formapgto, pp.dscformapgto, ii.valpago, con.nomconc from dbvestib.inscricao ii, dbvestib.forma_pgto pp, 
dbvestib.concurso con
where ii.formapgto = '5'
and ii.valpago =0
and pp.codformapgto = 5
and pp.codformapgto = ii.formapgto
and ii.codconc = con.codconc

select *
    from DBVESTIB.VW_LOCAL_EAD LOC,
    DBVESTIB.VW_INSTITUICAO_CONCURSO IEC
    WHERE IEC.COD_INSTITUICAO_SIAF = LOC.cod_instituic
    
    
    
    
    select
    c.* from dbvestib.parametros_concurso p
    inner join dbvestib.concurso c on (c.codconc = p.codconc and c.anoconc = 2016 and c.indinsc = 'S' )
    where p.numopcoes > 1
    and p.i
