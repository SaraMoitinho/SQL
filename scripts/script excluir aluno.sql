
DECLARE
	CURSOR C_SARA IS
		SELECT A.CODCONC,
			   A.NUM_MATRICULA,
			   A.COD_USUARIO_LOG,
			   A.DAT_OPERACAO_LOG,
			   A.COD_ALUNO
		  FROM DBSIAF.ALUNO A
		 WHERE A.CODCONC = '1597'
			   AND A.COD_USUARIO_LOG = 13391;
BEGIN
	FOR R_SARA IN C_SARA LOOP
		BEGIN
			DBVESTIB.PC_CONCURSO.SP_EXCLUIR_ALUNO(R_SARA.CODCONC,
												  R_SARA.COD_ALUNO);
		END;
	END LOOP;
END;
