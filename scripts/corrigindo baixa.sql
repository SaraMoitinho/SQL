DECLARE
	CURSOR C_CAN IS
		SELECT DISTINCT MI.CODCONC,
						CON.NOMCONC,
						INS.NOMCAN,
						MI.CODINSC,
						INS.DATINSCAN,
						TRE.DAT_CREDITO,
						TRE.COD_TITULO_RECEBER,
						MI.COD_MAPEAMENTO,
						TRE.NUM_NOSSO_NUMERO,
						TRE.VAL_TITULO,
						INS.COD_STATUS_INSCRICAO,
						INS.VALPAGO,
						INS.DATPGTO,
						CON.COD_TPO_CONCURSO,
						(SELECT FPR.DSCFORMAPROVA
						   FROM DBVESTIB.INSCRICAO   III,
								DBVESTIB.FORMA_PROVA FPR
						  WHERE III.CODCONC = INS.CODCONC
								AND III.CODINSC = INS.CODINSC
								AND INS.CODFORMAPROVA = FPR.CODFORMAPROVA) "MODALIDADE",
						(SELECT FPG.DSCFORMAPGTO
						   FROM DBVESTIB.FORMA_PGTO FPG
						  WHERE FPG.CODFORMAPGTO = INS.FORMAPGTO) "FORMA PAGTO"
		  FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
		  JOIN DBSIAF.MAPEAMENTO_TITULO_LOG MT
			ON MI.COD_MAPEAMENTO = MT.COD_MAPEAMENTO
		  JOIN DBSIAF.TITULO_RECEBER TRE
			ON MT.COD_TITULO_RECEBER = TRE.COD_TITULO_RECEBER
		  JOIN DBVESTIB.INSCRICAO INS
			ON INS.CODCONC = MI.CODCONC
			   AND INS.CODINSC = MI.CODINSC
		  JOIN DBVESTIB.CONCURSO CON
			ON CON.CODCONC = INS.CODCONC
		 WHERE TRE.COD_STA_TITULO IN (3,
									  6)
			   AND ((INS.COD_STATUS_INSCRICAO <> 2) OR (INS.COD_STATUS_INSCRICAO = 2 AND INS.FORMAPGTO IN ('8',
																										   '9')))
			   AND INS.DATINSCAN >= '13/03/2014'
			 --  AND CON.COD_TPO_CONCURSO = 64
			/* --  AND INS.CODCONC = '1949'
			  AND MI.CODINSC  ='148394'*/
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAOCANDIDATO OPC
				 WHERE OPC.CODCONC = INS.CODCONC
					   AND OPC.CODINSC = INS.CODINSC
					   AND ROWNUM = 1)
                         AND  EXISTS (SELECT 1
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE CAN.CODCONC = MI.CODCONC
					   AND CAN.CODCAN = MI.CODINSC)
			  ;

	CURSOR C_ATUAL IS
		SELECT DISTINCT MI.CODCONC,
						CON.NOMCONC,
						INS.NOMCAN,
						MI.CODINSC,
						INS.DATINSCAN,
						TRE.DAT_CREDITO,
						TRE.COD_TITULO_RECEBER,
						MI.COD_MAPEAMENTO,
						TRE.NUM_NOSSO_NUMERO,
						TRE.VAL_TITULO,
						INS.COD_STATUS_INSCRICAO,
						(SELECT FPR.DSCFORMAPROVA
						   FROM DBVESTIB.INSCRICAO   III,
								DBVESTIB.FORMA_PROVA FPR
						  WHERE III.CODCONC = INS.CODCONC
								AND III.CODINSC = INS.CODINSC
								AND INS.CODFORMAPROVA = FPR.CODFORMAPROVA) "MODALIDADE"
		
		  FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
		  JOIN DBSIAF.MAPEAMENTO_TITULO_LOG MT
			ON MI.COD_MAPEAMENTO = MT.COD_MAPEAMENTO
		  JOIN DBSIAF.TITULO_RECEBER TRE
			ON MT.COD_TITULO_RECEBER = TRE.COD_TITULO_RECEBER
		  JOIN DBVESTIB.INSCRICAO INS
			ON INS.CODCONC = MI.CODCONC
			   AND INS.CODINSC = MI.CODINSC
		  JOIN DBVESTIB.CONCURSO CON
			ON CON.CODCONC = INS.CODCONC
		 WHERE TRE.COD_STA_TITULO NOT IN (3,
										  6)
			  /* AND INS.COD_STATUS_INSCRICAO > 7
              AND INS.COD_STATUS_INSCRICAO <> 2*/
			   AND INS.DATINSCAN >= '01/01/2014'
			   AND NOT EXISTS (SELECT 1
				  FROM DBSIAF.HIST_MAPEAMENTO_TITULO HIT
				 WHERE HIT.COD_MAPEAMENTO = MT.COD_MAPEAMENTO
					   AND HIT.COD_TITULO_RECEBER = MT.COD_TITULO_RECEBER)
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAOCANDIDATO OPC
				 WHERE OPC.CODCONC = INS.CODCONC
					   AND OPC.CODINSC = INS.CODINSC
					   AND ROWNUM = 1)
			   AND  EXISTS (SELECT 1
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE CAN.CODCONC = INS.CODCONC
					   AND CAN.CODCAN = INS.CODINSC);

	TITULO DBSIAF.TITULO_RECEBER.COD_TITULO_RECEBER%TYPE;
	EXISTE NUMBER;
BEGIN
	FOR R_CAN IN C_CAN LOOP
	
		SELECT COUNT(1)
		  INTO EXISTE
		  FROM DBSIAF.MAPEAMENTO_TITULO MT,
          DBSIAF.MAPEAMENTO_INSCRICAO MI
		 WHERE MT.COD_MAPEAMENTO =R_CAN.COD_MAPEAMENTO
         AND MT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO;
         
	
		IF EXISTE = 1 THEN
		
			UPDATE DBSIAF.MAPEAMENTO_TITULO MT
			   SET MT.COD_TITULO_RECEBER = R_CAN.COD_TITULO_RECEBER
			 WHERE MT.COD_MAPEAMENTO = R_CAN.COD_MAPEAMENTO;
		ELSE
			INSERT INTO DBSIAF.MAPEAMENTO_TITULO
				(COD_MAPEAMENTO,
				 COD_TITULO_RECEBER)
			VALUES
				(R_CAN.COD_MAPEAMENTO,
				 R_CAN.COD_TITULO_RECEBER);
                   
		END IF;
	
		BEGIN
		 DBVESTIB.SP_CONFIRMA_INSC_INTERNET(R_CAN.CODCONC,
											   R_CAN.CODINSC); 
					
		DBSIAF.PC_MAPEAMENTO_TITULO.SP_BAIXA_MAPEAMENTO(R_CAN.COD_MAPEAMENTO,
															R_CAN.COD_TITULO_RECEBER);
                                                    
		EXCEPTION
			WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20500,
										'Candidato: Concurso' || R_CAN.CODCONC || 'Candidato: ' || R_CAN.CODINSC || ' confirma inscricao' || SQLERRM);
		END;
	
		COMMIT;
	
	END LOOP;

	/*  FOR R_ATUAL IN C_ATUAL LOOP
    
      INSERT INTO DBSIAF.HIST_MAPEAMENTO_TITULO(COD_HIST_MAPEAMENTO_TITULO,COD_MAPEAMENTO,COD_TITULO_RECEBER,CODCONC,CODINSC)
      VALUES (DBSIAF.HIST_MAPEAMENTO_TITULO_S.NEXTVAL, R_ATUAL.COD_MAPEAMENTO, R_ATUAL.COD_TITULO_RECEBER, R_ATUAL.CODCONC, R_ATUAL.CODINSC);
    END LOOP;
    COMMIT;*/
END;