DECLARE

	CURSOR C_C IS
	/*SELECT *
                      FROM DBVESTIB.RCANDCURTUROPC OPC
                     WHERE CODCONC = '2240'
                           AND EXISTS (SELECT 1
                              FROM DBVESTIB.INSCRICAO I
                             WHERE I.CODCONC = OPC.CODCONC
                                   AND I.CODINSC = OPC.CODCAN
                                   AND I.COD_STATUS_INSCRICAO is null );\*
                                   select cod_status_inscricao from dbvestib.inscricao ins
                                   where codconc ='2240'and codinsc in ('296603', '285414' ) for update;*\*/
	
		SELECT *
		  FROM DBVESTIB.INSCRICAO I
		 WHERE I.COD_STATUS_INSCRICAO = 2
			   AND NOT EXISTS (SELECT 1
				  FROM DBVESTIB.OPCAO_TURMA_CANDIDATO T
				 WHERE T.CODCONC = I.CODCONC
					   AND T.CODINSC = I.CODINSC)
			   AND I.CODCONC = '2240';

BEGIN
	FOR R_C IN C_C LOOP
		UPDATE DBVESTIB.INSCRICAO I
		   SET COD_STATUS_INSCRICAO = NULL
		 WHERE CODCONC = R_C.CODCONC
			   AND CODINSC = R_C.CODINSC;
	
		DELETE FROM DBVESTIB.CLASSIFICACAO_CANDIDATO
		 WHERE CODCONC = R_C.CODCONC
			   AND CODCAN = R_C.CODINSC;
	
		DELETE FROM DBVESTIB.LOG_ERROS_IMPORTACAO L
		 WHERE CODCONC = R_C.CODCONC
			   AND CODCAN = R_C.CODINSC;
	
		DBVESTIB.SP_ESTORNA_INSCRICAO(R_C.CODCONC,
									  R_C.CODINSC);
	END LOOP;
END;
