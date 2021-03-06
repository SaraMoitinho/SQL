DECLARE
	CURSOR
	
	C_ALUNO is
		SELECT a.cod_aluno,
			   A.COD_TPO_ENTRADA,
			   A.CODCONC,
			   CON.NOMCONC,
               con.forma_ingresso
		  FROM DBSIAF.ALUNO      A,
			   DBVESTIB.CONCURSO CON
		 WHERE CON.COD_TPO_CONCURSO = 1
			   AND A.COD_TPO_ENTRADA <> 2
			   AND A.CODCONC = CON.CODCONC
			   AND CON.ANOCONC = 2013;

BEGIN
	FOR R_ALUNO IN C_ALUNO LOOP
		UPDATE DBSIAF.ALUNO A
		   SET A.COD_TPO_ENTRADA = r_aluno.forma_ingresso
		 WHERE A.COD_ALUNO = R_ALUNO.COD_ALUNO;
	END LOOP;
END;
