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
						(SELECT FPR.DSCFORMAPROVA
						   FROM DBVESTIB.INSCRICAO   III,
								DBVESTIB.FORMA_PROVA FPR
						  WHERE III.CODCONC = INS.CODCONC
								AND III.CODINSC = INS.CODINSC
								AND INS.CODFORMAPROVA = FPR.CODFORMAPROVA) "MODALIDADE"
		  FROM DBSIAF.MAPEAMENTO_INSCRICAO_LOG MI
		  JOIN DBSIAF.MAPEAMENTO_TITULO_LOG MT
			ON MI.COD_MAPEAMENTO = MT.COD_MAPEAMENTO
		  JOIN DBSIAF.TITULO_RECEBER TRE
			ON MT.COD_TITULO_RECEBER = TRE.COD_TITULO_RECEBER
		  JOIN DBVESTIB.INSCRICAO INS
			ON INS.CODCONC = MI.CODCONC
			   AND INS.CODINSC = MI.CODINSC
		  JOIN DBVESTIB.CONCURSO CON
			ON CON.CODCONC = INS.CODCONC
		 WHERE TRE.COD_STA_TITULO  IN (3,6)
			   AND INS.COD_STATUS_INSCRICAO > 7
			   AND INS.COD_STATUS_INSCRICAO <> 2
			   AND INS.DATINSCAN > '01/01/2014'
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAOCANDIDATO OPC
				 WHERE OPC.CODCONC = INS.CODCONC
					   AND OPC.CODINSC = INS.CODINSC
					   AND ROWNUM = 1);
                       
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
		 WHERE TRE.COD_STA_TITULO NOT IN (3,6)
			  /* AND INS.COD_STATUS_INSCRICAO > 7
			   AND INS.COD_STATUS_INSCRICAO <> 2*/
			   AND INS.DATINSCAN >= '01/01/2014'
               AND NOT EXISTS (SELECT 1 FROM DBSIAF.HIST_MAPEAMENTO_TITULO HIT
               WHERE HIT.COD_MAPEAMENTO = MT.COD_MAPEAMENTO
               AND HIT.COD_TITULO_RECEBER = MT.COD_TITULO_RECEBER)
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAOCANDIDATO OPC
				 WHERE OPC.CODCONC = INS.CODCONC
					   AND OPC.CODINSC = INS.CODINSC
					   AND ROWNUM = 1);                       

	TITULO DBSIAF.TITULO_RECEBER.COD_TITULO_RECEBER%TYPE;
BEGIN
	FOR R_CAN IN C_CAN LOOP
		BEGIN
			SELECT TRE.COD_TITULO_RECEBER
			  INTO TITULO
			  FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
			  JOIN DBSIAF.MAPEAMENTO_TITULO MT
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
				   AND INS.COD_STATUS_INSCRICAO > 7
				   AND INS.COD_STATUS_INSCRICAO <> 2
				   AND INS.CODCONC = R_CAN.CODCONC
				   AND INS.CODINSC = R_CAN.CODINSC
				   AND NOT EXISTS (SELECT 1
					  FROM DBVESTIB.CANDIDATO CAN
					 WHERE CAN.CODCONC = R_CAN.CODCONC
						   AND CAN.CODCAN = R_CAN.CODINSC);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20500,
										'Candidato: Concurso' || R_CAN.CODCONC || 'Candidato: ' || R_CAN.CODINSC || ' Boleto atual n�o encontrado');
			WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20500,
										'Candidato: Concurso' || R_CAN.CODCONC || 'Candidato: ' || R_CAN.CODINSC || ' outro erro');
		END;
		IF TITULO IS NOT NULL THEN
			/*DELETE FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
			 WHERE MI.CODCONC = R_CAN.CODCONC
				   AND MI.CODINSC = R_CAN.CODINSC;
		
			BEGIN
				DBVESTIB.SP_CONFIRMA_INSC_INTERNET(R_CAN.CODCONC,
												   R_CAN.CODINSC);
			EXCEPTION
				WHEN OTHERS THEN
					RAISE_APPLICATION_ERROR(-20500,
											'Candidato: Concurso' || R_CAN.CODCONC || 'Candidato: ' || R_CAN.CODINSC || ' confirma inscricao' || SQLERRM);
			END;
		
			INSERT INTO DBSIAF.MAPEAMENTO_INSCRICAO
				(COD_MAPEAMENTO,
				 CODINSC,
				 CODCONC,
				 COD_CURSO,
				 COD_CAMPUS,
				 COD_GRD_QUALIFICACAO)
				SELECT COD_MAPEAMENTO,
					   CODINSC,
					   CODCONC,
					   COD_CURSO,
					   COD_CAMPUS,
					   COD_GRD_QUALIFICACAO
				  FROM DBSIAF.MAPEAMENTO_INSCRICAO_LOG MII
				 WHERE MII.CODCONC = R_CAN.CODCONC
					   AND MII.CODINSC = R_CAN.CODINSC
					   AND MII.COD_USUARIO_LOG = 13391;
		END IF;*/
	
		UPDATE DBSIAF.MAPEAMENTO_TITULO MTT
		   SET MTT.COD_MAPEAMENTO     = R_CAN.COD_MAPEAMENTO,
			   MTT.COD_TITULO_RECEBER = R_CAN.COD_TITULO_RECEBER
		 WHERE MTT.COD_TITULO_RECEBER = TITULO;
	     dbsiaf.pc_mapeamento_titulo.sp_baixa_mapeamento(R_CAN.COD_MAPEAMENTO,R_CAN.COD_TITULO_RECEBER);         
		COMMIT;
       END IF; 
	END LOOP;
    
    FOR R_ATUAL IN C_ATUAL LOOP

      INSERT INTO DBSIAF.HIST_MAPEAMENTO_TITULO(COD_HIST_MAPEAMENTO_TITULO,COD_MAPEAMENTO,COD_TITULO_RECEBER,CODCONC,CODINSC)
      VALUES (DBSIAF.HIST_MAPEAMENTO_TITULO_S.NEXTVAL, R_ATUAL.COD_MAPEAMENTO, R_ATUAL.COD_TITULO_RECEBER, R_ATUAL.CODCONC, R_ATUAL.CODINSC);
    END LOOP;
    COMMIT;
END;

