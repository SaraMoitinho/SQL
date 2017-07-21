update ITEM_GRADE_DATA
set
  DAT_HORARIO = '20/02/2015',
  COD_HORARIO =561,
  COD_ESPACO_FISICO = 6957
where
  COD_GRD_HORARIO = 322763 and
  DAT_HORARIO = :5 and
  COD_HORARIO = :6

 
select *
from iTEM_GRADE_DATA g
--dbsiaf.grade_horario g
where g.cod_grd_horario = 325124 for update

insert into ITEM_GRADE_DATA(COD_GRD_HORARIO,DAT_HORARIO,COD_HORARIO,COD_ESPACO_FISICO)
values ( 325123, '20/02/2015',561, 6957);

insert into ITEM_GRADE_DATA(COD_GRD_HORARIO,DAT_HORARIO,COD_HORARIO,COD_ESPACO_FISICO)
values ( 325124, '20/02/2015',542, 6957);



select
from 

SELECT ALU.COD_ALUNO, length(alu.num_matricula), length(can.matricula),alu.num_matricula,can.matricula,
				   CAN.FORMA_INGRESSO			
			  FROM DBVESTIB.CANDIDATO CAN,
				   DBSIAF.ALUNO       ALU,
				   DBSIAF.CAMPUS      CAM
			 WHERE  CAM.COD_INSTITUICAO = CAN.COD_INSTITUICAO_PSVS
				   AND CAN.CODCAN = '194405'
				   AND CAN.CODCONC = '2115'
                   and ALU.COD_CAMPUS = CAM.COD_CAMPUS
				   AND dbsiaf.f_so_numero(ALU.NUM_MATRICULA) = dbsiaf.f_so_numero(CAN.MATRICULA)
                  
                   
                   
select forma_ingresso, cOD_INSTITUICAO_PSVS, matricula, nomcan,length(matricula)
from dbvestib.candidato
where codconc = '2115'
and codcan = '194405' for update;


select c.cod_instituicao, a.cod_campus, nom_aluno, nom_campus, length(a.num_matricula)
from dbsiaf.aluno a, dbsiaf.campus c
where num_matricula = '31427177'
and a.cod_campus = c.cod_campus;

select *
from dbvestib.opcao_turma_candidato 
where codconc = '2224'
and codinsc = '274809'

select * from dbsiaf.grade_horario g
where g.cod_grd_horario = 324987

select cpfcan, nomcan, cod_status_inscricao, codinsc
from dbvestib.inscricao
where codconc = '2224'
and cpfcan = '51468784390' for update;

select cod_tpo_concurso, c.*
from dbvestib.concurso c
where c.codconc = '2223';

select c.ind_possui_turma, c.ind_permite_mult_insc
from dbvestib.tipo_concurso c
where c.cod_tpo_concurso = 71 for update
