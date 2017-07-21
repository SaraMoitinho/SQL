---------------------------------------------------------
-- para classificação geral
----------------------------------------------------------
DECLARE
	CURSOR C_CAN IS
		SELECT CODCONC,
			   CODCAN,
			   CAN.CODFORMAPROVA
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC = &P_CODCONC_DES;

	CURSOR C_NOTA(P_CODCAN DBVESTIB.CANDIDATO.CODCAN%TYPE) IS
		SELECT NPR.CODCONC,
			   NPR.CODCAN,
			   NPR.NOTAPARCIAL,
			   NPR.NOTAFINAL,
			   NPR.CODPRO,
               NPR.NROOPC
		  FROM DBVESTIB.NOTA_PROVA NPR
		 WHERE NPR.CODCONC = &P_CODCONC_ORIGINAL
			   AND NPR.CODCAN = P_CODCAN
			   AND NPR.NROOPC = '1';

	CURSOR C_NOTAENEM(P_CODCAN DBVESTIB.NOTAENEM.CODCAN%TYPE) IS
		SELECT NOE.CODPRO,
			   NOE.VALNOTA
		  FROM DBVESTIB.NOTAENEM NOE
		 WHERE NOE.CODCONC = &P_CODCONC_ORIGINAL
			   AND NOE.CODCAN = P_CODCAN;

	MENSAGEM VARCHAR2(400);
	VALIDA   NUMBER;
	CONTA    NUMBER;
BEGIN

	-- VERIFICA SE OS CANDIDATOS JÁ FORAM REPLICADOS
      DELETE FROM DBVESTIB.CANDIDATO CAN
       WHERE CODCONC = '3193'
             AND CODCAN = '734279';
    
	DELETE FROM DBVESTIB.LOG_ERROS_IMPORTACAO LOI
	 WHERE LOI.CODCONC = &P_CODCONC_DES;
     COMMIT;

	FOR R_CAN IN C_CAN LOOP
		BEGIN
			IF R_CAN.CODFORMAPROVA = 1 THEN
			
				SELECT COUNT(*)
				  INTO CONTA
				  FROM DBVESTIB.NOTA_PROVA NPV
				 WHERE NPV.CODCONC = &P_CODCONC_DES
					   AND NPV.CODCAN = R_CAN.CODCAN;
			
				IF CONTA = 0 THEN
					FOR R_NOTA IN C_NOTA(R_CAN.CODCAN) LOOP
					
						INSERT INTO DBVESTIB.NOTA_PROVA
							(CODNOTAPROVA,
							 CODCONC,
							 CODCAN,
							 NROOPC,
							 COD_ETAPA,
							 CODPRO,
							 NOTAPARCIAL)
						VALUES
							(DBVESTIB.NOTA_PROVA_S.NEXTVAL,
							 R_CAN.CODCONC,
							 R_CAN.CODCAN,
							 R_NOTA.NROOPC,
							 1,
							 R_NOTA.CODPRO,
							 R_NOTA.NOTAPARCIAL);
					         COMMIT;
					END LOOP;
				END IF;
			END IF;
			
            IF R_CAN.CODFORMAPROVA = 2 THEN
			
				SELECT COUNT(*)
				  INTO CONTA
				  FROM DBVESTIB.NOTAENEM NOE
				 WHERE NOE.CODCONC = &P_CODCONC_DES
					   AND NOE.CODCAN = R_CAN.CODCAN;
			
				IF CONTA = 0 THEN
				
					FOR R_ENEM IN C_NOTAENEM(R_CAN.CODCAN) LOOP
					
						INSERT INTO DBVESTIB.NOTAENEM
							(CODCONC,
							 CODCAN,
							 CODPRO,
							 VALNOTA)
						VALUES
							(R_CAN.CODCONC,
							 R_CAN.CODCAN,
							 R_ENEM.CODPRO,
							 R_ENEM.VALNOTA);
                             COMMIT;
					END LOOP;
				END IF;
			END IF;
		
		EXCEPTION
		
			WHEN OTHERS THEN
				MENSAGEM := SQLERRM;
				INSERT INTO DBVESTIB.LOG_ERROS_IMPORTACAO
					(CODCONC,
					 CODCAN,
					 COD_ERRO,
					 DSC_ERRO)
				VALUES
					(R_CAN.CODCONC,
					 R_CAN.CODCAN,
					 1,
					 MENSAGEM);
				COMMIT;
		END;
	END LOOP;

	--END;
/*
	DBVESTIB.PC_CLASSIFICACAO.SP_CLASSIFICAR_INSTITUICOES(&P_CODCONC_DES,
														  1, -- tpo_classificação
														  '1', -- opcao de curso
														  1, -- etapa
														  'N', --inclui treinantes
														  'S', --processa resultado
														  'S', --processa desistente
														  NULL, --codcan
														  'S' -- ind_commit
														  );*/

END;
