--select * from dbvestib.informacao_concurso i where i.cod_tipo_informacao = 88

--dbvestib.informacao_concurso

insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao)
select dbvestib.informacao_concurso_s.nextval, 2057, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao 
from dbvestib.informacao_concurso
where codconc = 1965 and cod_tipo_informacao = 96;


insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao)
select dbvestib.informacao_concurso_s.nextval, 2057, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao 
from dbvestib.informacao_concurso
where codconc = 1965 and cod_tipo_informacao = 87;

insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao)
select dbvestib.informacao_concurso_s.nextval, 2057, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao 
from dbvestib.informacao_concurso
where codconc = 1965 and cod_tipo_informacao = 97;


insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao)
select dbvestib.informacao_concurso_s.nextval, 2057, cod_tipo_informacao, tit_informacao, ord_informacao, dsc_informacao 
from dbvestib.informacao_concurso
where codconc = 1965 and cod_tipo_informacao = 88;



  

insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 111, 'Classificação', 1,  'Reprovado');
  
insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 112, 'Classificação', 1,  'Aprovado');  
  
  
insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 113, 'Classificação', 1,  'Ausente');  


insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 114, 'Classificação', 1,  'Excedente'); 
  
insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 115, 'Matrícula', 1,  'Matriculado');   
  

insert into dbvestib.informacao_concurso
  (cod_informacao, codconc, cod_tipo_informacao, tit_informacao, ORD_INFORMACAO, dsc_informacao)
values
  (dbvestib.informacao_concurso_s.nextval, 2057, 116, 'Classificação', 1,  'Aprovado'); 
  
--dbcrm.f_status_inscricao

--select * from dbvestib.tipo_informacao


