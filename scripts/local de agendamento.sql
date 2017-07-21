

insert into dbsiaf.estrutura_organizacional(cod_estrutura,cod_estrutura_pai,dsc_estrutura,cod_tpo_estrutura)
select dbsiaf.estrutura_organizacional_s.nextval, est.cod_estrutura_pai, 'Faculdade Una de Betim - UNA -Av. Governador Valadares ,640 - Bairro Centro', est.cod_tpo_estrutura
from dbsiaf.estrutura_organizacional est
where cod_usuario_log = 13391
and cod_estrutura = 910


SELECT * FROM DBSIAF.ESTRUTUra

select *
from dbsiaf.estrutura_organizacional est
where cod_usuario_log = 13391 --for update
and cod_estrutura = 948

select * from dbsag.processo p
where p.cod_sistema = 55

select * from
dbsag.local_processo

select *
from DBSAG.MAPEAMENTO_LOC_ESTRUTURA]


begin  
 dbsag.sp_insere_mapeamento_local(948,14);
end; 
