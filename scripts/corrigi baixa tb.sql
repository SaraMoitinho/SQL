DECLARE

	CURSOR C_VAL IS
	
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
						  WHERE FPG.CODFORMAPGTO = INS.FORMAPGTO) "FORMA PAGTO",
                          tre.Dat_Pagamento
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
			  /*   AND ((INS.COD_STATUS_INSCRICAO <> 2) OR (INS.COD_STATUS_INSCRICAO = 2 AND INS.FORMAPGTO IN ('8',
              '9')))*/
			   AND INS.DATINSCAN >= '25/08/2014'
			  --  AND CON.COD_TPO_CONCURSO = 64
			/*   AND INS.CODCONC = '1967'
			   AND MI.CODINSC = '147851'*/
			--   AND INS.VALPAGO IS NULL
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAOCANDIDATO OPC
				 WHERE OPC.CODCONC = INS.CODCONC
					   AND OPC.CODINSC = INS.CODINSC)
			   AND not EXISTS (SELECT 1
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE CAN.CODCONC = MI.CODCONC
					   AND CAN.CODCAN = MI.CODINSC);
BEGIN
	FOR R_VAL IN C_VAL LOOP
	/*
		UPDATE DBSIAF.MAPEAMENTO_TITULO MT
		   SET MT.COD_TITULO_RECEBER = R_VAL.COD_TITULO_RECEBER
		 WHERE MT.COD_MAPEAMENTO = R_VAL.COD_MAPEAMENTO;
	
		UPDATE DBVESTIB.INSCRICAO I
		   SET I.VALPAGO = R_VAL.VAL_TITULO,
               I.DATPGTO = R_VAL.DAT_PAGAMENTO
		 WHERE I.CODCONC = R_VAL.CODCONC
			   AND I.CODINSC = R_VAL.CODINSC;
               */
               
               DBVESTIB.SP_CONFIRMA_INSC_INTERNET(R_VAL.CODCONC, R_VAL.CODINSC);
	END LOOP;
END;



