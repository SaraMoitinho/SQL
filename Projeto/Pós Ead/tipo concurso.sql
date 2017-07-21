
-- Add/modify columns 
alter table dbvestib.TIPO_CONCURSO modify ind_forma_parcelamento char(1) default 'N';
-- Add comments to the columns 
comment on column dbvestib.TIPO_CONCURSO.ind_forma_parcelamento
  is 'Permite utilizar as formas de pagamento do Vestib na importação';
  
update
  dbvestib.tipo_concurso tip
  set   tip.ind_forma_parcelamento = 'S'
where tip.cod_tpo_concurso in (41,76 ); -- pós e extensão

update
  dbvestib.tipo_concurso tip
  set   tip.ind_forma_parcelamento = 'N'
where tip.cod_tpo_concurso  not in (41, 76 ); -- pós e extensão


insert into dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
select dbvestib.passos_inscricao_s.nextval,76,end_tela,dsc_tela,5,NULL,ind_exibir,dsc_funcao_before,dsc_funcao_after 
 from dbvestib.passos_inscricao p
where p.cod_tpo_concurso =41
and p.ord_passo = 4;

update
dbvestib.passos_inscricao i
set i.ord_passo = 7
where i.cod_tpo_concurso = 76
and i.ord_passo = 6;

update
dbvestib.passos_inscricao i
set i.ord_passo = 6
where i.cod_tpo_concurso = 76
and i.ord_passo = 5
and i.end_tela = 'forma/index/index';
