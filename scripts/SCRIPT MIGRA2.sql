DECLARE

	CURSOR C_ALUNO IS
	
		SELECT ALU.NOM_ALUNO,
			   ALU.NUM_CPF,
			   CON.CODCONC,
			   MIRA.DSC_TPO_SOLICITACAO,
			   MIRA.VAL_DESC_CAIXA,
			   MIRA.COD_GRP_RECEBIMENTO,
			   MIRA.VAL_ENTRADA,
			   MIRA.COD_CONTA_CORRENTE,
			   ALU.DAT_COLACAO,
			   ALU.DAT_SAIDA,
			   ALU.COD_TPO_SAIDA,
			   ALU.COD_STA_ALUNO,
			   ALU.COD_ALUNO
		  FROM DBSIAF.TITULO_MIRA2 MIRA,
			   DBSIAF.ALUNO        ALU,
			   DBVESTIB.CONCURSO   CON
		 WHERE ALU.NUM_MATRICULA = MIRA.COD_CONTA_CORRENTE
			   AND TRIM(CON.NOMCONC) = TRIM(MIRA.DSC_TPO_SOLICITACAO)
			   AND ALU.NUM_CPF IS NOT NULL
			   and alu.codconc is null
              and alu.codcan is null
			   AND NOT EXISTS (SELECT 1
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE  CAN.CODCONC = ALU.CODCONC
					   AND CAN.CODCAN = ALU.CODCAN)
			  AND  NOT (((ALU.TEL_CELULAR IS NOT NULL) AND (LENGTH(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)) < 10)) OR ((ALU.TEL_CELULAR IS NOT NULL) AND (LENGTH(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)) IS NULL)));
			  -- AND ALU.NUM_MATRICULA = '200812652';

	CAND      DBVESTIB.CANDIDATO.CODCAN%TYPE;
	VALIDA    NUMBER;
	N_CODCONC DBVESTIB.CANDIDATO.CODCONC%TYPE;
	N_CODCAN  DBVESTIB.CANDIDATO.CODCAN%TYPE;
	ERRO      VARCHAR2(250);

BEGIN
	FOR R_ALUNO IN C_ALUNO LOOP
	
		SELECT COUNT(1)
		  INTO VALIDA
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC = R_ALUNO.CODCONC
			   AND CAN.CPFCAN = R_ALUNO.NUM_CPF;
		-- E N�O TIVER CANDIDATO
		IF VALIDA = 0 THEN
			DBVESTIB.SP_IMPORTA_CANDIDATO(R_ALUNO.CODCONC,
										  R_ALUNO.NOM_ALUNO,
										  '',
										  SYSDATE,
										  '',
										  '',
										  '',
										  '',
										  R_ALUNO.NUM_CPF,
										  '',
										  '',
										  R_ALUNO.NUM_CPF,
										  '',
										  'usjt@usjt.com.br',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '',
										  '01',
										  '01',
										  0,
										  '63',
										  1,
										  1,
										  '',
										  '',
										  '',
										  '');
			BEGIN
				SELECT CAN.CODCAN
				  INTO CAND
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE CAN.CODCONC = R_ALUNO.CODCONC
					   AND CAN.CPFCAN = R_ALUNO.NUM_CPF;
			EXCEPTION
				WHEN OTHERS THEN
					ERRO := SQLERRM;
					RAISE_APPLICATION_ERROR(-20500,
											CAND || ' - ' || R_ALUNO.NUM_CPF || '- ' || R_ALUNO.CODCONC || ERRO);
			END;
		
			UPDATE DBSIAF.TITULO_MIRA2 MM
			   SET MM.VAL_LANCAMENTO      = DBSIAF.F_SO_NUMERO(R_ALUNO.NUM_CPF),
				   MM.COD_GRP_RECEBIMENTO = DBSIAF.F_SO_NUMERO(TO_NUMBER(R_ALUNO.CODCONC)),
				   MM.COD_BANDEIRA        = CAND
			 WHERE MM.COD_CONTA_CORRENTE = R_ALUNO.COD_CONTA_CORRENTE;
		
			BEGIN
				INSERT INTO DBVESTIB.CLASSIFICACAO_CANDIDATO
					(COD_CLASSIFICACAO,
					 COD_TPO_CLASSIFICACAO,
					 CODCONC,
					 CODCAN,
					 COD_ETAPA,
					 COD_STA_CLASSIFICACAO,
					 NROOPC,
					 NUM_POSICAO,
					 NUM_PONTOS,
					 IND_INCLUI_TREINANTES,
					 CODINSTITUICAO)
				VALUES
					(DBVESTIB.CLASSIFICACAO_CANDIDATO_S.NEXTVAL,
					 1,
					 R_ALUNO.CODCONC,
					 CAND,
					 1,
					 9,
					 1,
					 R_ALUNO.VAL_DESC_CAIXA,
					 R_ALUNO.VAL_ENTRADA,
					 'N',
					 12);
			EXCEPTION
				WHEN OTHERS THEN
					RAISE_APPLICATION_ERROR(-20500,
											CAND || ' - ' || R_ALUNO.COD_CONTA_CORRENTE || '- ' || R_ALUNO.CODCONC);
			END;
		ELSE
			-- SE EXISTIR CANDIDATO
			IF R_ALUNO.COD_STA_ALUNO <> 7
			   AND R_ALUNO.DAT_COLACAO IS NOT NULL THEN
			
				DBSIAF.PC_ALUNO.SP_LIBERA_STATUS(R_ALUNO.COD_ALUNO,
												 1);
			
				/*UPDATE DBSIAF.ALUNO ALN
                  SET ALN.COD_STA_ALUNO = 1
                WHERE ALN.COD_ALUNO = R_ALUNO.COD_ALUNO;*/
				BEGIN
					SELECT CODCONC,
						   CODCAN
					  INTO N_CODCONC,
						   N_CODCAN
					  FROM DBVESTIB.CANDIDATO CAN
					 WHERE CAN.CODCONC = R_ALUNO.CODCONC
						   AND CAN.CPFCAN = R_ALUNO.NUM_CPF;
				EXCEPTION
					WHEN OTHERS THEN
						RAISE_APPLICATION_ERROR(-20500,
												'ATUALIZANDO' || ' - ' || CAND || ' - ' || R_ALUNO.COD_CONTA_CORRENTE || '- ' || R_ALUNO.CODCONC);
				END;
				BEGIN
					UPDATE DBSIAF.ALUNO ALU
					   SET CODCONC = N_CODCONC,
						   CODCAN  = N_CODCAN
					 WHERE ALU.COD_ALUNO = R_ALUNO.COD_ALUNO;
				EXCEPTION
					WHEN OTHERS THEN
						ERRO := SQLERRM;
						RAISE_APPLICATION_ERROR(-20500,
												'INSERINDO CODCONC E CODCAN' || ' - ' || N_CODCONC || ' - ' || N_CODCAN || '-' || R_ALUNO.NUM_CPF || ERRO);
				END;
				DBSIAF.PC_ALUNO.SP_LIBERA_STATUS(R_ALUNO.COD_ALUNO,
												 R_ALUNO.COD_STA_ALUNO);
			
				UPDATE DBSIAF.ALUNO ALN
				   SET ALN.COD_STA_ALUNO = R_ALUNO.COD_STA_ALUNO,
					   ALN.DAT_SAIDA     = R_ALUNO.DAT_SAIDA,
					   ALN.DAT_COLACAO   = R_ALUNO.DAT_COLACAO,
					   ALN.COD_TPO_SAIDA = R_ALUNO.COD_TPO_SAIDA
				 WHERE ALN.COD_ALUNO = R_ALUNO.COD_ALUNO;
			
			ELSE
				BEGIN
					SELECT CODCONC,
						   CODCAN
					  INTO N_CODCONC,
						   N_CODCAN
					  FROM DBVESTIB.CANDIDATO CAN
					 WHERE CAN.CODCONC = R_ALUNO.CODCONC
						   AND CAN.CPFCAN = R_ALUNO.NUM_CPF;
				
					UPDATE DBSIAF.ALUNO ALU
					   SET CODCONC = N_CODCONC,
						   CODCAN  = N_CODCAN
					 WHERE ALU.COD_ALUNO = R_ALUNO.COD_ALUNO;
				EXCEPTION
					WHEN OTHERS THEN
						ERRO := SQLERRM;
						RAISE_APPLICATION_ERROR(-20500,
												'ATUALIZANDO' || ' - ' || N_CODCONC || ' - ' || N_CODCAN || '-' || R_ALUNO.NUM_CPF || ERRO);
				END;
			END IF;
		
		END IF;
		COMMIT;
	END LOOP;
END;
