DECLARE
	CURSOR C_ERRO IS
		SELECT ALU.COD_ALUNO,
			   ALU.NUM_MATRICULA "MATRICULA",
			   UPPER(ALU.NOM_ALUNO) "ALUNO",
			   CUR.NOM_CURSO "CURSO ATUAL DO ALUNO",
			   ALU.COD_STA_ALUNO "STATUS",
			   ALU.CODCONC "CONCURSO",
			   ALU.CODCAN "INSCRICAO",
			   CCC.NOMCUR "CURSO NO VESTIB"
		  FROM DBSIAF.ALUNO ALU
		 INNER JOIN DBSIAF.CURSO CUR
			ON (CUR.COD_CURSO = ALU.COD_CURSO AND CUR.COD_CURSO IN (5553,
																	5550))
		 INNER JOIN DBSIAF.INSTITUICAO_ENSINO IES
			ON (IES.COD_INSTITUICAO = CUR.COD_INSTITUICAO)
		 INNER JOIN DBVESTIB.CONCURSO CON
			ON (CON.CODCONC = ALU.CODCONC AND CON.ANOCONC = 2016)
		 INNER JOIN DBVESTIB.CANDIDATO CAN
			ON (CAN.CODCONC = ALU.CODCONC AND CAN.CODCAN = ALU.CODCAN)
		 INNER JOIN DBVESTIB.RCANDCURTUROPC OPC
			ON (OPC.CODCONC = ALU.CODCONC AND OPC.CODCAN = ALU.CODCAN AND OPC.NROOPC = '1')
		 INNER JOIN DBVESTIB.CURSO CCC
			ON (CCC.CODCONC = OPC.CODCONC AND CCC.CODCUR = OPC.CODCUR)
         INNER JOIN DBSIAF.GRADE_CURRICULAR GRD ON (GRD.COD_PERIODICIDADE = 1 AND GRD.COD_GRD_CURRICULAR = ALU.COD_GRD_CURRICULAR)   
		 WHERE ALU.COD_STA_ALUNO NOT IN (9,
										 3)
                     ;

BEGIN
	FOR R_ERRO IN C_ERRO LOOP
		UPDATE DBSIAF.ALUNO ALU
		   SET CODCONC = NULL,
			   CODCAN  = NULL
		 WHERE ALU.COD_ALUNO = R_ERRO.COD_ALUNO;
	END LOOP;

END;

