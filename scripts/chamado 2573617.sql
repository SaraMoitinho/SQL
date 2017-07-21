
SELECT COD_ALUNO,
	   ALU.NUM_MATRICULA,
	   DAT_NASCIMENTO,
	   NUM_CPF,
	   ALU.COD_STA_ALUNO,
	   ALU.DAT_ENTRADA,
	   ALU.COD_PERIODO_ENTRADA,
	   STA.DSC_STA_ALUNO,
	   CUR.NOM_CURSO,
	   ALU.COD_TPO_ENTRADA,
	   ALU.NOM_ALUNO,
	   TPS.DSC_TPO_SAIDA,
	   ALU.DAT_SAIDA,
	   ALU.COD_INSTITUICAO
  FROM DBSIAF.ALUNO ALU
  LEFT JOIN DBSIAF.TIPO_SAIDA TPS
	ON TPS.COD_TPO_SAIDA = ALU.COD_TPO_SAIDA
 INNER JOIN DBSIAF.STATUS_ALUNO STA
	ON STA.COD_STA_ALUNO = ALU.COD_STA_ALUNO
 INNER JOIN DBSIAF.CURSO CUR
	ON CUR.COD_CURSO = ALU.COD_CURSO
 WHERE ALU.CODCONC = '3182'
	   AND ALU.COD_STA_ALUNO = 1
