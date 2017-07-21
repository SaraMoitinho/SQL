-- Usar para encontrar aluno no SOL Ingressante  para USJT
select cod_aluno, alu.num_matricula, alu.cod_sta_aluno, alu.dat_entrada,alu.cod_periodo_entrada,sta.dsc_sta_aluno, cur.nom_curso,alu.cod_tpo_entrada, alu.nom_aluno, dat_nascimento, num_cpf, alu.cod_tpo_saida, tps.dsc_tpo_saida, ALu.DAT_SAIDA, alu.cod_instituicao
from dbsiaf.aluno alu
left join dbsiaf.tipo_saida tps on tps.cod_tpo_saida = alu.cod_tpo_saida
inner join dbsiaf.status_aluno sta on sta.cod_sta_aluno = alu.cod_sta_aluno
inner join dbsiaf.curso cur on cur.cod_curso = alu.cod_curso
where  alu.codconc = '3182' 
and alu.cod_sta_aluno <>1;

------------------------------------------

-- Uasar para encontrar aluno para testar no SOL Aluno
select alu.cod_aluno,cur.cod_niv_curso,cod_aluno, alu.num_matricula, alu.cod_sta_aluno, alu.dat_entrada,alu.cod_periodo_entrada,sta.dsc_sta_aluno, cur.nom_curso,alu.cod_tpo_entrada, alu.nom_aluno, dat_nascimento, num_cpf, alu.cod_tpo_saida, tps.dsc_tpo_saida, ALu.DAT_SAIDA, alu.cod_instituicao
,alu.eml_aluno 
from dbsiaf.aluno alu
left join dbsiaf.tipo_saida tps on tps.cod_tpo_saida = alu.cod_tpo_saida
inner join dbsiaf.status_aluno sta on sta.cod_sta_aluno = alu.cod_sta_aluno
inner join dbsiaf.curso cur on cur.cod_curso = alu.cod_curso
where  CUR.COD_NIV_CURSO = 1
AND ALU.COD_STA_ALUNO =1
and alu.cod_instituicao = 1
