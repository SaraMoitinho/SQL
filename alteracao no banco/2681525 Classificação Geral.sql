---------------------------------------------------------
-- para classificação geral
----------------------------------------------------------
DECLARE
	-- CANDIDATO COM NOTA NAS 2 PROVAS
	CURSOR C_CAN IS
		SELECT CODCONC,
			   CODCAN,
			   CAN.CODFORMAPROVA
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC = &P_CODCONC_ORIGEM
			   AND CAN.CODFORMAPROVA = 1
			   AND 2 = (SELECT COUNT(*)
						  FROM DBVESTIB.NOTA_PROVA NPR
						 WHERE NPR.CODCONC = CAN.CODCONC
							   AND NPR.CODCAN = CAN.CODCAN
							   AND NPR.NROOPC = '1')
		UNION ALL
		SELECT CODCONC,
			   CODCAN,
			   CAN.CODFORMAPROVA
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC = &P_CODCONC_ORIGEM
			   AND CAN.CODFORMAPROVA = 2
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.NOTAENEM NOE
				 WHERE NOE.CODCONC = CAN.CODCONC
					   AND NOE.CODCAN = CAN.CODCAN);

	CURSOR C_NOTA(P_CODCAN DBVESTIB.CANDIDATO.CODCAN%TYPE) IS
		SELECT NPR.CODCONC,
			   NPR.CODCAN,
			   NPR.NOTAPARCIAL,
			   NPR.NOTAFINAL,
			   NPR.CODPRO,
			   NPR.NROOPC,
			   NPR.COD_ETAPA
		  FROM DBVESTIB.NOTA_PROVA NPR
		 WHERE NPR.CODCONC = &P_CODCONC_ORIGEM
			   AND NPR.CODCAN = P_CODCAN
			   AND NPR.NROOPC = '1';

	CURSOR C_NOTAENEM(P_CODCAN DBVESTIB.NOTAENEM.CODCAN%TYPE) IS
		SELECT NOE.CODPRO,
			   NOE.VALNOTA
		  FROM DBVESTIB.NOTAENEM NOE
		 WHERE NOE.CODCONC = &P_CODCONC_ORIGEM
			   AND NOE.CODCAN = P_CODCAN;

	MENSAGEM VARCHAR2(400);
	VALIDA   NUMBER;
	CONTA    NUMBER;
	NOTA     DBVESTIB.NOTA_PROVA.NOTAPARCIAL%TYPE;
BEGIN

	FOR R_CAN IN C_CAN LOOP
		BEGIN
		
			-- VESTIBULAR TRADICIONAL
			IF R_CAN.CODFORMAPROVA = 1 THEN
			
				FOR R_NOTA IN C_NOTA(R_CAN.CODCAN) LOOP
					-- SE FOR REDAÇÃO, FAZ REGRA DE 3
					IF R_NOTA.CODPRO = '03' THEN
						R_NOTA.NOTAPARCIAL := (60 * R_NOTA.NOTAPARCIAL) / 100;
					END IF;
				
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
						 &P_CODCONC_DESTINO,
						 R_CAN.CODCAN,
						 R_NOTA.NROOPC,
						 1,
						 R_NOTA.CODPRO,
						 R_NOTA.NOTAPARCIAL);
					COMMIT;
				END LOOP;
			END IF;
		-- PARA CANDIDATOS ENEM
			IF R_CAN.CODFORMAPROVA = 2 THEN
			
				FOR R_ENEM IN C_NOTAENEM(R_CAN.CODCAN) LOOP
				
					INSERT INTO DBVESTIB.NOTAENEM
						(CODCONC,
						 CODCAN,
						 CODPRO,
						 VALNOTA)
					VALUES
						(&P_CODCONC_DESTINO,
						 R_CAN.CODCAN,
						 R_ENEM.CODPRO,
						 R_ENEM.VALNOTA);
					COMMIT;
				END LOOP;
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
					(&P_CODCONC_DESTINO,
					 R_CAN.CODCAN,
					 1,
					 MENSAGEM);
				COMMIT;
		END;
	END LOOP;

	
    DBVESTIB.PC_CLASSIFICACAO.SP_CLASSIFICAR_INSTITUICOES(&P_CODCONC_DES,
                                                          1, -- tpo_classificação
                                                          '1', -- opcao de curso
                                                          1, -- etapa
                                                          'N', --inclui treinantes
                                                          'S', --processa resultado
                                                          'S', --processa desistente
                                                          NULL, --codcan
                                                          'S' -- ind_commit
                                                          );

END;
