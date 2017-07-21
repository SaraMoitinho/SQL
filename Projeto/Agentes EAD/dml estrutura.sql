SELECT EST.COD_ESTRUTURA,
	   EST.DSC_ESTRUTURA,
	   EST.DSC_COD_LOCALIZADOR,
	   EST.COD_TPO_ESTRUTURA,
	   TEO.NOM_TPO_ESTRUTURA,
	   EDE.NOM_LOGRADOURO,
	   EDE.NOM_COMPLEMENTO,
	   EDE.NOM_BAIRRO,
	   EDE.CEP_ENDERECO,
	   EDE.TEL_ENDERECO,
	   EDE.COD_CIDADE,
	   CID.NOM_CIDADE,
	   ETD.NOM_ESTADO,
	   ETD.SGL_ESTADO,
	   IND_ATIVO PAI,
       NOM_PAIS,
	   EPE.NUM_CPF,
	   EPE.COD_PESSOA, PAI.COD_PAIS, 
       ETD.COD_ESTADO,
       ECO.IND_AGENDA_REPLICADA,
       CON.CODCONC
       CON.NOMCONC,
       CON.ANOCONC,
       CON.SEMCONC,
       CON.COD_TPO_CONCURSO,
       TCN.DSC_CONCURSO
  FROM DBSIAF.ESTRUTURA_ORGANIZACIONAL EST
 INNER JOIN DBSIAF.ENDERECO_ESTRUTURA EDE ON EDE.COD_ESTRUTURA = EST.COD_ESTRUTURA
 INNER JOIN DBSIAF.TIPO_ESTRUTURA_ORGANIZACIONAL TEO ON TEO.COD_TPO_ESTRUTURA = EST.COD_TPO_ESTRUTURA
 INNER JOIN DBSIAF.ESTRUTURA_PESSOA EPE ON EPE.COD_ESTRUTURA = EST.COD_ESTRUTURA
 INNER JOIN DBSIAF.CIDADE CID ON CID.COD_CIDADE = EDE.COD_CIDADE
 INNER JOIN DBSIAF.ESTADO ETD ON ETD.COD_ESTADO = CID.COD_ESTADO
 INNER JOIN DBSIAF.PAIS PAI ON PAI.COD_PAIS = ETD.COD_PAIS
 INNER JOIN DBSIAF.ESTRUTURA_CONCURSO ECO ON ECO.COD_ESTRUTURA = EST.COD_ESTRUTURA
 INNER JOIN DBVESTIB.CONCURSO CON ON CON.CODCONC = ECO.CODCONC
 INNER JOIN DBVESTIB.TIPO_CONCURSO TCN ON TCN.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
 INNER JOIN DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE TCA ON TCA.COD_TPO_CONCURSO = TCN.COD_TPO_CONCURSO
 INNER JOIN DBVESTIB.CAMPUS CAP ON CAP.CODCAM 
---------------------------------------------------------
------------ ESTRUTURA ORGANIZACIONAL -------------------
---------------------------------------------------------
select * from dbsiaf.estrutura_organizacional    
    
---------------------------------------------------------
------------ ESTRUTURA ORGANIZACIONAL -------------------
---------------------------------------------------------
insert into dbsiaf.estrutura_organizacional	(cod_estrutura, cod_estrutura_pai, dsc_estrutura, cod_tpo_estrutura)
values( DBSIAF.ESTRUTURA_ORGANIZACIONAL_S.nextval, null, 'nome_estrutra',21);

--select dbsiaf.estrutura_organizacional_s.nextval;

update dbsiaf.estrutura_organizacional
set cod_estrutura_pai = :cod_estrutura_pai,
    dsc_estrutura = :dsc_estrutura,
    cod_tpo_estrutura = :cod_tpo_estrutura,
    ind_ativo = :ind_ativo,
    dsc_cod_localizador = :dsc_cod_localizador
where cod_estrutura      = :cod_estrutra;

delete from dbsiaf.estrutura_organizacional	ddd
where ddd.cod_estrutura = :old_cod_estrutura

---------------------------------------------------------
------------------ ENDERECO ESTRUTURA -------------------
---------------------------------------------------------
 
insert into dbsiaf.endereco_estrutura (cod_estrutura,cod_cidade,nom_logradouro,nom_complemento,nom_bairro,cep_endereco,tel_endereco)
values (:cod_estrutura,:cod_cidade,:nom_logradouro,:nom_complemento,:nom_bairro,:cep_endereco,:tel_endereco);

update dbsiaf.endereco_estrutura
set cod_cidade = :cod_cidade,
    nom_logradouro = :nom_logradouro,
    nom_complemento = :nom_complemento,
    nom_bairro = :nom_bairro,
    cep_endereco = :cep_endereco,
    tel_endereco = :tel_endereco
where cod_estrutura = :cod_estrutura
and cod_pessoa = :cod_pessoa;

delete from dbsiaf.endereco_estrutura est
where est.cod_estrutura = :old_cod_estrutura
and est.cod_cidade = :old_cod_cidade;


---------------------------------------------------------
------------------ ESTRUTURA PESSOA --------------------
---------------------------------------------------------


select  epe.num_cpf, epe.cod_estrutura, epe.cod_pessoa
from dbsiaf.estrutura_pessoa epe
inner join dbsiaf.pessoa pes on pes.cod_pessoa = epe.cod_pessoa
inner join dbsiaf.estrutura_organizacional est on est.cod_estrutua = epe.cod_estrutura
where epe.cod_estrutura = :cod_estrutura
and epe.cod_pessoa = :cod_pessoa;

insert into dbsiaf.estrutura_pessoa(cod_estrutura_pessoa,cod_estrutura,cod_pessoa,num_cpf)
values (23,1743, null, '12312312322');

update dbsiaf.estrutura_pessoa
set num_cpf = :num_cpf
where cod_estrutura= :cod_estrutura
  and cod_pessoa = :cod_pessoa;

delete from dbsiaf.estrutura_pessoa epe
where epe.cod_estrutura = :old_cod_estrutura
and epe.cod_pessoa = :old_cod_pessoa;


---------------------------------------------------------
------------------ ESTRUTURA CIDADE ---------------------
---------------------------------------------------------
select esc.cod_estrutura, esc.cod_cidade, cid.nom_cidade, pai.cod_pais, est.nom_estado, pai.nom_pais, esc.ind_exclusivo
 from dbsiaf.estrutura_cidade esc
 inner join dbsiaf.cidade cid on cid.cod_cidade = esc.cod_cidade
 inner join dbsiaf.estado est on est.cod_estado = cid.cod_estado
 inner join dbsiaf.pais pai   on pai.cod_pai = est.cod_pais
 where esc.cod_estrutura = :cod_estrutura;
 
 insert into dbsiaf.estrutura_cidade(cod_estrutura,cod_cidade,ind_exclusivo)
 values ( :cod_estrutura, :cod_cidade, decode( :ind_exclusivo,'Sim', 'S', 'N'));
 
 update dbsiaf.estrutura_cidade
 set cod_cidade = :cod_cidade,
     ind_exclusivo = :ind_exclusivo
 where cod_estrutura   = :cod_estrutura 
   and cod_cidade = :old_cod_cidade;
   
 delete from dbsiaf.estrutura_cidade esc
  where esc.cod_estrutura = :old_cod_estrutura
    and esc.cod_cidade = :old_cod_estrutura;
    

---------------------------------------------------------
-------------- ESTRUTURA CAMPUS VESTIB ------------------
---------------------------------------------------------    
   
   
select ecv.cod_estrutura, ecv.codcam, ecv.num_vagas_padrao, cam.nomcam, ies.sglinstituicao
  from dbsiaf.estrutura_campus_vestib ecv
  inner join dbvestib.campus cam on cam.codcam = ecv.codcam
  inner join dbvestib.instituicao_ensino ies on ies.codinstituicao = cam.codinstituicao
 where ecv.cod_estrutura = :cod_estrutura
   and ecv.codcam = :codam
  
   
insert into dbsiaf.estrutura_campus_vestib(cod_estrutura,codcam,num_vagas_padrao)
values ( :cod_estrutura, :codcam, :num_vagas_padrao)
    
   update dbsiaf.estrutura_campus_vestib
   set codcam = :codcam,
       num_vagas_padrao = :num_vagas_padrao
   where cod_estrutura   = :cod_estrutura    
     and cod_codcam = :old_codcam;
     
delete from dbsiaf.estrutura_campus_vestib ddc
where ddc.cod_estrutura = :old_cod_estrutura
  and ddc.codcam = :old_codcam;    
  
  
---------------------------------------------------------
-------------- ESTRUTURA TIPO_CONCURSO ------------------
---------------------------------------------------------
     
select etc.cod_estrutura, etc.cod_tpo_concurso, etc.anoconc, etc.semconc, tcc.dsc_concurso
  from dbsiaf.estrutura_tipo_concurso      etc
  inner join dbvestib.tipo_concurso tcc on tcc.cod_tpo_concurso = etc.cod_tpo_concurso
where etc.cod_estrutura = :cod_estrutura
  and etc.cod_tpo_concurso = :cod_tpo_concurso;

insert into dbsiaf.estrutura_tipo_concurso (cod_estrutura,cod_tpo_concurso,anoconc,semconc)
values(:cod_estrutura, :cod_tpo_concurso, :anoconc, :semconc);
  
update dbsiaf.estrutura_tipo_concurso
set cod_tpo_concurso = :cod_tpo_concurso
    anoconc = :anoconc
    semconc = :semconc
where cod_estrutura = :cod_estrutura
  and cod_tpo_concurso = :old_cod_tpo_concurso;
  
delete from dbsiaf.estrutura_tipo_concurso etc
where etc.cod_estrutura = :old_cod_estrutura
  and etc.cod_tpo_concurso = :old_cod_tpo_concurso;
  
  
---------------------------------------------------------
---------------- ESTRUTURA CONCURSO ---------------------
---------------------------------------------------------

select ecc.cod_estrutura, ecc.codconc, ecc.ind_agenda_replicada, con.nomconc
  from dbsiaf.estrutura_concurso   ecc
 inner join dbvestib.concurso con on con.codconc = ecc.codconc
 where ecc.cod_estrutura = :cod_estrutura
   and ecc.codconc = :codconc;
   
insert into dbsiaf.estrutura_concurso(cod_estrutura,codconc,ind_agenda_replicada)
values (:cod_estrutura, :codconc, decode( :ind_agenda_replicada,'Sim', 'S', 'N'));

update dbsiaf.estrutura_concurso
set ind_agenda_replicada  = : ind_agenda_replicada,
    codconc = :codconc
where cod_estrutura = :cod_estrutura
  and codconc = :old_codconc;
  
delete dbsiaf.estrutura_concurso
where cod_estrutura = :cod_estrutura
  and codconc = :old_codconc;
  
  
---------------------------------------------------------
------------ TIPO CONCURSO ANO SEMESTRE -----------------
---------------------------------------------------------
  
select cas.cod_tipo_concurso_ano_semestre, cas.cod_tpo_concurso, cas.anoconc, cas.semconc
  from DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE cas
where cas.cod_tpo_concurso = :cod_tpo_concurso;  
 
insert into DBSIAF.TIPO_CONCURSO_ANO_SEMESTRE(COD_TIPO_CONCURSO_ANO_SEMESTRE,COD_TPO_CONCURSO,ANOCONC,SEMCONC)
values( :COD_TIPO_CONCURSO_ANO_SEMESTRE, :COD_TPO_CONCURSO, :ANOCONC, :SEMCONC);

update dbsiaf.tipo_concurso_ano_semestre 
set cod_tpo_concurso = :cod_tpo_concurso,
    anoconc = :anoconc,
    semconc = :anoconc
where cod_tipo_concurso_ano_semestre = :cod_tipo_concurso_ano_semestre
and cod_tpo_concurso = :old_cod_tpo_concurso;

delete dbsiaf.tipo_concurso_ano_semestre 
where cod_tipo_concurso_ano_semestre = :old_cod_tipo_concurso_ano_semestre
and cod_tpo_concurso = :old_cod_tpo_concurso;


---------------------------------------------------------
---------- HORARIO TIPO CONCURSO ANO SEMESTRE -----------
---------------------------------------------------------

select hor.cod_tipo_concurso_ano_semestre, hor.horario
  from dbsiaf.horario_tpo_concurso_ano_sem  hor
where hor.cod_tipo_concurso_ano_semestre = :cod_tipo_concurso_ano_semestre;

insert into dbsiaf.horario_tpo_concurso_ano_sem(cod_tipo_concurso_ano_semestre,horario)
values ( :cod_tipo_concurso_ano_semestre, decode( :horario,'Sim', 'S', 'N'));

delete from dbsiaf.horario_tpo_concurso_ano_sem
where cod_tipo_concurso_ano_semestre = :old_cod_tipo_concurso_ano_semestre;


select  epe.num_cpf, epe.cod_estrutura, epe.cod_pessoa
from dbsiaf.estrutura_pessoa epe
inner join dbsiaf.pessoa pes on pes.cod_pessoa = epe.cod_pessoa
inner join dbsiaf.estrutura_organizacional est on est.cod_estrutura = epe.cod_estrutura


---------------------------------------------------------
---------- HORARIO TIPO CONCURSO ANO SEMESTRE -----------
---------------------------------------------------------

select hor.cod_tipo_concurso_ano_semestre, hor.horario, dis.dat_hora_inicio, dis.num_capacidade_disponibilidade, dis.dat_hora_fim, tpo.dsc_concurso
from dbsiaf.horario_tpo_concurso_ano_sem hor
inner join dbsag.disponibilidade_pessoa dis on dis.cod_disponibilidade = hor.horario
inner join dbvestib.tipo_concurso tpo on tpo.cod_tpo_concurso = hor.cod_tipo_concurso_ano_semestre
where hor.cod_tipo_concurso_ano_semestre = :cod_tipo_concurso_ano_semestre


SELECt DBSIAF.PC_ESTRUTURA_ORGANIZACIONAL.F_BUSCA_ESTRUTURA_EXCLUSIVA(1485) from dual ;

insert into dbsiaf.estrutura_cidade(cod_estrutura,cod_cidade,ind_exclusivo)
values ( 2003, 1485, decode( 'Não','Sim', 'S', 'N'))


SELECT EOR.DSC_ESTRUTURA, eor.ind_ativo
		  FROM DBSIAF.ESTRUTURA_ORGANIZACIONAL EOR
		 INNER JOIN DBSIAF.ESTRUTURA_CIDADE ECI
			ON EOR.COD_ESTRUTURA = ECI.COD_ESTRUTURA
		 WHERE ECI.COD_CIDADE = 1485
			   AND ECI.IND_EXCLUSIVO = 'S'
               AND EOR.IND_ATIVO = 'S';
               
update dbsiaf.estrutura_organizacional
set cod_estrutura_pai = null,
    dsc_estrutura = 'sara moita',
    cod_tpo_estrutura = 1,
    ind_ativo = 'S',
    dsc_cod_localizador = null,
     tel_celular = null || null,
     eml_estrutura = null
where cod_estrutura      = 2003;

select * from
dbsiaf.estrutura_organizacional
where cod_estrutura = 2004
               
	


-------------------------------------------------------------
select con.codconc
from dbvestib.concurso con
inner join dbvestib.tipo_concurso tpo on tpo.cod_tpo_concurso  = cod_tpo_concurso
where con.cod_tpo_concurso = :cod_tpo_concurso;

select teo.*
  from dbsiaf.tipo_estrutura_organizacional teo
order order by teo.nom_tpo_estrutura  


insert into dbsiaf.estrutura_tipo_concurso (cod_estrutura,cod_tpo_concurso,anoconc,semconc)
values(2001, 1, 2016, 2)

SQL Execute: ORACLE - 
 update dbsiaf.estrutura_cidade
 set cod_cidade       = 5425,
     ind_exclusivo    = decode(ind_exclusivo, 'Sm', 'S', 'N')
 where cod_estrutura  = 2003 
   and cod_cidade     = 1485
   
 update dbsiaf.estrutura_cidade
 set cod_cidade       = 2003,
     ind_exclusivo    = decode( 'Sim','Sim','S', 'N')
 where cod_estrutura  = 2003 
   and cod_cidade     = 5425
   
   
    update dbsiaf.estrutura_organizacional
set cod_estrutura_pai = 1706,
    cod_tpo_estrutura = 1,
    ind_ativo = 'S'
where cod_estrutura      = 2003


select * from dbsiaf.estrutura_organizacional w
where cod_estrutura      = 2003
