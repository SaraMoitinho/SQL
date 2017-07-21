DECLARE

	CURSOR C_IES IS
	-- instituicao
		SELECT distinct COD_INSTITUICAO, ENE.CODINSTITUICAO
		  FROM DBSIAF.INSTITUICAO_ASSOCIADA INA
          JOIN DBVESTIB.INSTITUICAO_ENSINO ENE ON ENE.COD_INSTITUICAO_SIAF = INA.COD_INSTITUICAO
		 WHERE INA.COD_INSTITUICAO_ASSOCIADA = 3
			   OR COD_INSTITUICAO = 3;

	CURSOR C_TIPO IS
	-- restante dos dados
		SELECT DISTINCT CON.COD_TPO_CONCURSO,
						TIP.DSC_CONCURSO, /*con.forma_ingresso, tie.dsc_tpo_entrada,*/
						TIE.COD_NIV_CURSO,
						PAS.COD_PASSO_INSCRICAO
		  FROM DBVESTIB.CONCURSO CON
		  JOIN DBVESTIB.TIPO_CONCURSO TIP
			ON TIP.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
		  JOIN DBSIAF.TIPO_ENTRADA TIE
			ON TIE.COD_TPO_ENTRADA = CON.FORMA_INGRESSO
		  JOIN DBVESTIB.PASSOS_INSCRICAO PAS
			ON PAS.COD_TPO_CONCURSO = TIP.COD_TPO_CONCURSO
			   AND PAS.END_TELA LIKE '%pagamento/index/index%'
		 WHERE TIE.COD_NIV_CURSO = 1
			   AND CON.ANOCONC IN (2016,
								   2017)
			   AND TIP.COD_TPO_CONCURSO NOT IN (3,
												97,
												89,
												64,
												52,
												64,
												67,
												72,
												89,
												97); -- vestibular

BEGIN
	FOR R_IES IN C_IES LOOP
		FOR R_S IN C_TIPO LOOP
		
			INSERT INTO DBVESTIB.SCRIPT_PASSOS_INSCRICAO
				(COD_PASSO_INSCRICAO,
				 CODCONC,
				 DSC_SCRIPT,
				 COD_INSTITUICAO,
				 COD_LOCAL_HTML,
				 COD_TPO_CONCURSO,
				 INDNAVEGACAO)
			VALUES
				(R_S.COD_PASSO_INSCRICAO,
				 NULL,
				 NULL,
				 R_ies.CODINSTITUICAO,
				 3,
				 R_s.COD_TPO_CONCURSO,
				 NULL);
			COMMIT;
		END LOOP;
	END LOOP;
END;