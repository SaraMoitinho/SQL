



UPDATE  DBSIAF.MATRICULA M
 SET COD_STA_MATRICULA = 9
WHERE M.COD_ALUNO =432851;

DELETE ITEM_DIARIO_CLASSE D
WHERE D.COD_ALUNO =432851;

commit;
DELETE DBSIAF.ERROS_RECALCULO_DISCIPLINA ER
WHERE ER.COD_ALUNO =432851;
begin
dbvestib.pc_concurso.SP_EXCLUIR_ALUNO(1301, 432851);
end;

select alu.num_matricula, alu.nom_aluno, alu.cod_aluno, alu.cod_curso
from  dbsiaf.aluno alu
where ALU.CODCONC = 1301
--and alu.cod_curso = 3089
order by alu.nom_aluno, alu.num_matricula;
