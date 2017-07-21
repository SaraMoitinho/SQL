select cod_aluno, COD_PESSOA, alu.num_matricula, alu.cod_sta_aluno, alu.cod_tpo_entrada, alu.nom_aluno, dat_nascimento, num_cpf, alu.cod_tpo_saida,tps.dsc_tpo_saida, alu.cod_instituicao
from dbsiaf.aluno alu
left join dbsiaf.tipo_saida tps on tps.cod_tpo_saida = alu.cod_tpo_saida
where alu.num_matricula = '11221587';

--------------------------------------------------  -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- 

select alu.cod_aluno,cur.cod_niv_curso,cod_aluno, alu.num_matricula, alu.cod_sta_aluno, alu.dat_entrada,alu.cod_periodo_entrada,sta.dsc_sta_aluno, cur.nom_curso,alu.cod_tpo_entrada, alu.nom_aluno, dat_nascimento, num_cpf, alu.cod_tpo_saida, tps.dsc_tpo_saida, ALu.DAT_SAIDA, alu.cod_instituicao
from dbsiaf.aluno alu
left join dbsiaf.tipo_saida tps on tps.cod_tpo_saida = alu.cod_tpo_saida
inner join dbsiaf.status_aluno sta on sta.cod_sta_aluno = alu.cod_sta_aluno
inner join dbsiaf.curso cur on cur.cod_curso = alu.cod_curso
where  CUR.COD_NIV_CURSO = 1
AND ALU.COD_STA_ALUNO =2
and alu.cod_instituicao = 1
and alu.cod_aluno  = 1289762
ORDER BY ALU.DAT_ENTRADA DESC

-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- 

select cod_aluno, alu.num_matricula, alu.cod_sta_aluno, alu.dat_entrada,alu.cod_periodo_entrada,sta.dsc_sta_aluno, cur.nom_curso,alu.cod_tpo_entrada, alu.nom_aluno, dat_nascimento, num_cpf, alu.cod_tpo_saida, tps.dsc_tpo_saida, ALu.DAT_SAIDA, alu.cod_instituicao
from dbsiaf.aluno alu
left join dbsiaf.tipo_saida tps on tps.cod_tpo_saida = alu.cod_tpo_saida
inner join dbsiaf.status_aluno sta on sta.cod_sta_aluno = alu.cod_sta_aluno
inner join dbsiaf.curso cur on cur.cod_curso = alu.cod_curso
where  alu.codconc = '3182'
and alu.cod_sta_aluno = 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select pro.cod_professor, pro.log_professor, dd.cod_instituicao
from dbsiaf.professor pro
left join dbsiaf.coordenador_curso cc on cc.cod_professor = pro.cod_professor
inner join dbsiaf.departamento_ensino dd on dd.cod_departamento = pro.cod_departamento
where  pro.cod_sta_professor = 2 
and dbsiaf.pc_professor.F_COORDENADOR_DIRETOR_ATIVO(cc.cod_coordenador_curso) = 'N'
and dd.cod_instituicao  = 8
nom_professor like 'Moisés Stefano%'
pro.log_professor like 'ctorres'





  ------------------------------------------------------------
  UPDATE
  DBSIAF.ALUNO ALU
  SET ALU.SEN_ALUNO ='sara'
  where num_matricula='11221587'
  cod_aluno = 797767;
    
  -------------------------------------------------------------------------------------
  
  update dbsiaf.professor p
  set p.sen_professor = 'sara' 
  where --cod_professor = 61507
   p.log_professor like'prof.iedasantos'-- 'prof.leoni'  ;
   
  -------------------------------------------------------------------------------------
  --  ***********  dados para acessar API usando 
  --------------------------------------------------------------------------------------
  select *
  from dbadm.parceiro_acesso;
  
  select * from dbadm.token where cod_origem = 1289762 and cod_sistema_origem = 93 for update
  
  --------------------------------------------------------------------------------------
  
  
