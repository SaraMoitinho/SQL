
UPDATE DBSIAF.ALUNO ALU
   SET COD_PERIODO_ENTRADA = 2511,
    DAT_ENTRADA         = '01/01/2012'
 WHERE COD_ALUNO = 786412;

select cod_aluno,COD_PERIODO_ENTRADA, DAT_ENTRADA from dbsiaf.aluno  where num_matricula = '201000367';
