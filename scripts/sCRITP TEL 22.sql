DECLARE

	DDD   DBVESTIB.CANDIDATO.TELCAN%TYPE;
	CONTA NUMBER;

	CURSOR C_CANDIDATO IS
		SELECT CAN.CODCONC,
			   CAN.CODCAN,
			  -- TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)) CELCAN_CORRETO,
			   SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
					  3) CELCAN_CORRETO,
         SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
					  1, 2) DDD,             
			   OPC.CODINSTITUICAO,
			   CAN.TELCAN,
			   CAN.CELCAN,
			   CAN.TELCOMERCIAL
		
		  FROM DBVESTIB.CANDIDATO          CAN,
			   DBVESTIB.RCANDCURTUROPC     OPC,
			   DBVESTIB.INSTITUICAO_ENSINO IEN
		 WHERE CAN.CODCONC = OPC.CODCONC(+)
			   AND OPC.CODCAN = CAN.CODCAN
			   AND OPC.NROOPC = '1'
			   AND OPC.CODINSTITUICAO = IEN.CODINSTITUICAO
			   AND (SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
						   1,
						   2) = 13) -- S� em Santos
			   AND (((LENGTH(SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
									3)) = 8) -- telefone errado com 8 d�gitos
			   AND TO_NUMBER(SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
										  3,
										  1)) >= '7') AND (SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)),
																	   3,
																	   2)) NOT IN ('78',
																																   '79',
																																   '77',
																																   '70'))
			   AND OPC.CODINSTITUICAO = 8;

	CURSOR C_INSCRICAO IS
		SELECT --TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)) CELCAN_CORRETO,
			   SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
					  3) CELCAN_CORRETO,
         SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
					  1,2) DDD,   
			   INS.CODINSC,
			   INS.CODCONC,
			   OPC.CODINSTITUICAO,
			   INS.CELCAN,
			   INS.TELCAN,
			   INS.TELCOMERCIAL
		
		  FROM DBVESTIB.INSCRICAO          INS,
			   DBVESTIB.OPCAOCANDIDATO     OPC,
			   DBVESTIB.INSTITUICAO_ENSINO IEN
		
		 WHERE OPC.CODCONC = INS.CODCONC
			   AND OPC.CODINSC = INS.CODINSC
			   AND OPC.NROOPC = '1'
			   AND OPC.CODINSTITUICAO = IEN.CODINSTITUICAO
			  
			   AND (SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
						   1,
						   2) = 13) -- S� em Santos
			   AND (((LENGTH(SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
									3)) = 8) -- telefone errado com 8 d�gitos
			   AND TO_NUMBER(SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
										  3,
										  1)) >= '7') AND (SUBSTR(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)),
																	   3,
																	   2)) NOT IN ('78',
																																   '79',
																																   '77',
																																   '70'))
			   AND OPC.CODINSTITUICAO = 8
               AND INS.CODCONC = '738'
               AND INS.CODINSC = '280090';
	/*
    CURSOR C_ENDERECO IS
        SELECT TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)) CELULAR_CORRETO,
               TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.TEL_ENDERECO)) TELEND_CORRETO,
               TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.FAX_NUMERO)) FAX_CORRETO,
               ALU.COD_ALUNO AS ACODALUNO,
               ENA.COD_ALUNO AS ECODALUNO,
               CAM.COD_INSTITUICAO,
               ALU.TEL_CELULAR,
               ENA.TEL_ENDERECO,
               ENA.FAX_NUMERO
          FROM DBSIAF.END_ALUNO ENA,
               DBSIAF.ALUNO     ALU,
               DBSIAF.CAMPUS    CAM
         WHERE ALU.COD_ALUNO = ENA.COD_ALUNO(+)
               AND ALU.COD_CAMPUS = CAM.COD_CAMPUS
               AND ((ENA.TEL_ENDERECO IS NOT NULL) AND ((LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.TEL_ENDERECO))) < 10) OR (DBSIAF.F_SO_NUMERO(ENA.TEL_ENDERECO) IS NULL))
               
               OR
               
               ((ENA.FAX_NUMERO IS NOT NULL) AND ((LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.FAX_NUMERO))) < 10) OR (DBSIAF.F_SO_NUMERO(ENA.FAX_NUMERO) IS NULL)))
               
               OR (LENGTH(ENA.FAX_NUMERO) > 10)
               
               OR (LENGTH(ENA.TEL_ENDERECO) > 10) 
               
               OR ((ALU.TEL_CELULAR IS NOT NULL) AND ((LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR))) < 10) OR (DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR) IS NULL)))
               
               OR (LENGTH(ALU.TEL_CELULAR) > 10))
              
               AND (ENA.COD_TPO_ENDERECO = 1)
               
               UNION
               
               SELECT TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)) CELULAR_CORRETO,
               NULL TELEND_CORRETO,
               NULL FAX_CORRETO,
               ALU.COD_ALUNO AS ACODALUNO,
               NULL AS ECODALUNO,
               CAM.COD_INSTITUICAO,
               ALU.TEL_CELULAR,
               NULL AS TEL_ENDERECO,
               NULL AS FAX_NUMERO
          FROM DBSIAF.ALUNO     ALU,
               DBSIAF.CAMPUS    CAM
         WHERE ALU.COD_CAMPUS = CAM.COD_CAMPUS
               AND (
               (ALU.TEL_CELULAR IS NOT NULL) 
               AND 
               ((LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR))) < 10) OR (DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR) IS NULL))
               
               OR (LENGTH(ALU.TEL_CELULAR) > 10))
               AND NOT EXISTS (SELECT 1 FROM DBSIAF.END_ALUNO EE
                                 WHERE EE.COD_ALUNO = ALU.COD_ALUNO);*/

BEGIN
	CONTA := 0;
FOR R_CANDIDATO IN C_CANDIDATO LOOP
		/*SELECT CASE
				   WHEN (R_CANDIDATO.CODINSTITUICAO = 1) THEN
					31 -- unibh
				   WHEN (R_CANDIDATO.CODINSTITUICAO = 5) THEN
					31 -- una
				   WHEN (R_CANDIDATO.CODINSTITUICAO = 7) THEN
					31 -- una Contagem
				   WHEN (R_CANDIDATO.CODINSTITUICAO = 8) THEN
					13 -- Unimonte                        
				   ELSE
					31 --N�O INFORMADO
			   END
		  INTO DDD
		  FROM DUAL;
	
		IF (LENGTH(R_CANDIDATO.CELCAN_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_CANDIDATO.CELCAN_CORRETO := DDD || SUBSTR(R_CANDIDATO.CELCAN_CORRETO,
														1,
														1) || R_CANDIDATO.CELCAN_CORRETO;
		
		ELSIF (R_CANDIDATO.CELCAN IS NOT NULL)
			  AND ((LENGTH(R_CANDIDATO.CELCAN_CORRETO) < 7) OR (R_CANDIDATO.CELCAN_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7
			R_CANDIDATO.CELCAN_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_CANDIDATO.CELCAN_CORRETO);
		
		ELSIF ((LENGTH(R_CANDIDATO.CELCAN_CORRETO) < 10) AND (LENGTH(R_CANDIDATO.CELCAN_CORRETO) > 7)) THEN
			-- inserindo somente DDD
			R_CANDIDATO.CELCAN_CORRETO := DDD || R_CANDIDATO.CELCAN_CORRETO;
		END IF;
	
		IF (LENGTH(R_CANDIDATO.TELCAN_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_CANDIDATO.TELCAN_CORRETO := DDD || '3' || R_CANDIDATO.TELCAN_CORRETO;
		
		ELSIF (R_CANDIDATO.TELCAN IS NOT NULL)
			  AND ((LENGTH(R_CANDIDATO.TELCAN_CORRETO) < 7) OR (R_CANDIDATO.TELCAN_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7      
			R_CANDIDATO.TELCAN_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_CANDIDATO.TELCAN_CORRETO);
		
		ELSIF ((LENGTH(R_CANDIDATO.TELCAN_CORRETO) < 10) AND (LENGTH(R_CANDIDATO.TELCAN_CORRETO) > 7)) THEN
			-- Inserindo somente DDD    
			R_CANDIDATO.TELCAN_CORRETO := DDD || R_CANDIDATO.TELCAN_CORRETO;
		END IF;
	
		IF (LENGTH(R_CANDIDATO.TELCOME_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_CANDIDATO.TELCOME_CORRETO := DDD || '3' || R_CANDIDATO.TELCOME_CORRETO;
		
		ELSIF (R_CANDIDATO.TELCOMERCIAL IS NOT NULL)
			  AND ((LENGTH(R_CANDIDATO.TELCOME_CORRETO) < 7) OR (R_CANDIDATO.TELCOME_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7
			R_CANDIDATO.TELCOME_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_CANDIDATO.TELCOME_CORRETO);
		
		ELSIF ((LENGTH(R_CANDIDATO.TELCOME_CORRETO) < 10) AND (LENGTH(R_CANDIDATO.TELCOME_CORRETO) > 7)) THEN
			-- Inserindo somente DDD     
			R_CANDIDATO.TELCOME_CORRETO := DDD || R_CANDIDATO.TELCOME_CORRETO;
		END IF;*/
	
		UPDATE DBVESTIB.CANDIDATO CAN
		   SET
			   CAN.CELCAN       = R_CANDIDATO.DDD||'9'||R_CANDIDATO.CELCAN_CORRETO
		 WHERE CODCONC = R_CANDIDATO.CODCONC
			   AND CODCAN = R_CANDIDATO.CODCAN;
	
		IF CONTA = 20 THEN
			COMMIT;
			CONTA := 0;
		ELSE
			CONTA := CONTA + 1;
		END IF;
	END LOOP;
	FOR R_INSCRICAO IN C_INSCRICAO LOOP
	
			
		/*IF (LENGTH(R_INSCRICAO.CELCAN_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_INSCRICAO.CELCAN_CORRETO := DDD || SUBSTR(R_INSCRICAO.CELCAN_CORRETO,
														1,
														1) || R_INSCRICAO.CELCAN_CORRETO;
		
		ELSIF (R_INSCRICAO.CELCAN IS NOT NULL)
			  AND ((LENGTH(R_INSCRICAO.CELCAN_CORRETO) < 7) OR (R_INSCRICAO.CELCAN_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade de d�gitos � menor que 7
			R_INSCRICAO.CELCAN_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_INSCRICAO.CELCAN_CORRETO);
		
		ELSIF ((LENGTH(R_INSCRICAO.CELCAN_CORRETO) < 10) AND (LENGTH(R_INSCRICAO.CELCAN_CORRETO) > 7)) THEN
			-- Inserindo somente DDD
			R_INSCRICAO.CELCAN_CORRETO := DDD || R_INSCRICAO.CELCAN_CORRETO;
		
		END IF;
	
		IF (LENGTH(R_INSCRICAO.TELCAN_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_INSCRICAO.TELCAN_CORRETO := DDD || '3' || R_INSCRICAO.TELCAN_CORRETO;
		
		ELSIF (R_INSCRICAO.TELCAN IS NOT NULL)
			  AND ((LENGTH(R_INSCRICAO.TELCAN_CORRETO) < 7) OR (R_INSCRICAO.TELCAN_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7      
			R_INSCRICAO.TELCAN_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_INSCRICAO.TELCAN_CORRETO);
		
		ELSIF ((LENGTH(R_INSCRICAO.TELCAN_CORRETO) < 10) AND (LENGTH(R_INSCRICAO.TELCAN_CORRETO) > 7)) THEN
			-- Inserindo somente DDD           
			R_INSCRICAO.TELCAN_CORRETO := DDD || R_INSCRICAO.TELCAN_CORRETO;
		END IF;
	
		IF (LENGTH(R_INSCRICAO.TELCOME_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_INSCRICAO.TELCOME_CORRETO := DDD || '3' || R_INSCRICAO.TELCOME_CORRETO;
		
		ELSIF ((R_INSCRICAO.TELCOMERCIAL IS NOT NULL) AND ((LENGTH(R_INSCRICAO.TELCOME_CORRETO) < 7) OR (R_INSCRICAO.TELCOME_CORRETO IS NULL))) THEN
			-- Inserido "9" quando quantidade de d�gitos � menor que 7                            
			R_INSCRICAO.TELCOME_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_INSCRICAO.TELCOME_CORRETO);
		
		ELSIF ((LENGTH(R_INSCRICAO.TELCOME_CORRETO) < 10) AND (LENGTH(R_INSCRICAO.TELCOME_CORRETO) > 7)) THEN
			-- Inserindo somente DDD     
			R_INSCRICAO.TELCOME_CORRETO := DDD || R_INSCRICAO.TELCOME_CORRETO;
		
		END IF;*/
	
		UPDATE DBVESTIB.INSCRICAO INS
		   SET 
			   INS.CELCAN       = R_INSCRICAO.DDD||'9'||R_INSCRICAO.CELCAN_CORRETO
		 WHERE CODCONC = R_INSCRICAO.CODCONC
			   AND CODINSC = R_INSCRICAO.CODINSC;
	
		IF CONTA = 20 THEN
			COMMIT;
			CONTA := 0;
		ELSE
			CONTA := CONTA + 1;
		END IF;
	
	END LOOP;

	
/*
	FOR R_ENDERECO IN C_ENDERECO LOOP
	
		SELECT CASE
				   WHEN (R_ENDERECO.COD_INSTITUICAO = 1) THEN
					31 -- unibh
				   WHEN (R_ENDERECO.COD_INSTITUICAO = 3) THEN
					31 -- una
				   WHEN (R_ENDERECO.COD_INSTITUICAO = 4) THEN
					31 -- una Contagem
				   WHEN (R_ENDERECO.COD_INSTITUICAO = 5) THEN
					13 -- Unimonte                              
				   ELSE
					31 --N�O INFORMADO
			   END
		  INTO DDD
		  FROM DUAL;
	
		IF (LENGTH(R_ENDERECO.TELEND_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_ENDERECO.TELEND_CORRETO := DDD || '3' || R_ENDERECO.TELEND_CORRETO;
		
		ELSIF (R_ENDERECO.TEL_ENDERECO IS NOT NULL)
			  AND ((LENGTH(R_ENDERECO.TELEND_CORRETO) < 7) OR (R_ENDERECO.TELEND_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7
			R_ENDERECO.TELEND_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_ENDERECO.TELEND_CORRETO);
		
		ELSIF ((LENGTH(R_ENDERECO.TELEND_CORRETO) < 10) AND (LENGTH(R_ENDERECO.TELEND_CORRETO) > 7)) THEN
			-- Inserindo somente DDD     
			R_ENDERECO.TELEND_CORRETO := DDD || R_ENDERECO.TELEND_CORRETO;
		END IF;
	
		IF (LENGTH(R_ENDERECO.FAX_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_ENDERECO.FAX_CORRETO := DDD || '3' || R_ENDERECO.FAX_CORRETO;
		
		ELSIF (R_ENDERECO.FAX_NUMERO IS NOT NULL)
			  AND ((LENGTH(R_ENDERECO.FAX_CORRETO) < 7) OR (R_ENDERECO.FAX_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7
			R_ENDERECO.FAX_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_ENDERECO.FAX_CORRETO);
		
		ELSIF ((LENGTH(R_ENDERECO.FAX_CORRETO) < 10) AND (LENGTH(R_ENDERECO.FAX_CORRETO) > 7)) THEN
			-- Inserindo somente DDD     
			R_ENDERECO.FAX_CORRETO := DDD || R_ENDERECO.FAX_CORRETO;
		
		END IF;
	
		IF (LENGTH(R_ENDERECO.CELULAR_CORRETO) = 7) THEN
			-- Duplicando 1� D�gito e Colocando DDD
			R_ENDERECO.CELULAR_CORRETO := DDD || SUBSTR(R_ENDERECO.CELULAR_CORRETO,
														1,
														1) || R_ENDERECO.CELULAR_CORRETO;
		
		ELSIF (R_ENDERECO.TEL_CELULAR IS NOT NULL)
			  AND ((LENGTH(R_ENDERECO.CELULAR_CORRETO) < 7) OR (R_ENDERECO.CELULAR_CORRETO IS NULL)) THEN
			-- Inserido "9" quando quantidade d e d�gitos � menor que 7
			R_ENDERECO.CELULAR_CORRETO := DBVESTIB.F_INSERE_DIGITO(R_ENDERECO.CELULAR_CORRETO);
		
		ELSIF ((LENGTH(R_ENDERECO.CELULAR_CORRETO) < 10) AND (LENGTH(R_ENDERECO.CELULAR_CORRETO) > 7)) THEN
			-- Inserindo somente DDD     
			R_ENDERECO.CELULAR_CORRETO := DDD || R_ENDERECO.CELULAR_CORRETO;
		END IF;
	
		IF (R_ENDERECO.TELEND_CORRETO IS NOT NULL) THEN
			UPDATE DBSIAF.END_ALUNO EN
			   SET EN.TEL_ENDERECO = R_ENDERECO.TELEND_CORRETO,
				   EN.FAX_NUMERO   = R_ENDERECO.FAX_CORRETO
			 WHERE EN.COD_ALUNO = R_ENDERECO.ECODALUNO;
		
		END IF;
	
		UPDATE DBSIAF.ALUNO ALU
		   SET ALU.TEL_CELULAR = R_ENDERECO.CELULAR_CORRETO
		 WHERE COD_ALUNO = R_ENDERECO.ACODALUNO;
	
		IF CONTA = 20 THEN
			COMMIT;
			CONTA := 0;
		ELSE
			CONTA := CONTA + 1;
		END IF;
	
	END LOOP;
*/
	COMMIT;

END;
