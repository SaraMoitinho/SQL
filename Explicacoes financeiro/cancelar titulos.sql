DECLARE

	CURSOR C_CANCELA IS
	
		SELECT TIT.COD_TITULO_RECEBER COD_TITULO_RECEBER,
			   TIT.COD_ALUNO
		  FROM DBSIAF.TITULO_RECEBER TIT
		 INNER JOIN DBSIAF.ALUNO ALU
			ON (TIT.COD_ALUNO = ALU.COD_ALUNO AND TIT.NUM_PARCELA = 6 AND TIT.COD_INSTITUICAO = 3 AND TRUNC(TIT.DAT_GERACAO) = '17/11/2015' AND TIT.COD_STA_TITULO <> 4)
		 INNER JOIN DBSIAF.TIPO_TITULO TIP
			ON (TIP.COD_TPO_TITULO = TIT.COD_TPO_TITULO AND TIP.IND_FINANCEIRO = 'S' AND TIP.IND_MENSALIDADE = 'S')
		 WHERE EXISTS (SELECT 1
				  FROM DBSIAF.TITULO_RECEBER TIR
				 WHERE TIR.COD_ALUNO = TIT.COD_ALUNO
					   AND TIR.NUM_PARCELA = TIT.NUM_PARCELA
					   AND TIR.COD_STA_TITULO = TIT.COD_STA_TITULO
					   AND TIR.COD_TPO_TITULO = TIP.COD_TPO_TITULO
					   AND TRUNC(TIR.DAT_GERACAO) = TRUNC(TIT.DAT_GERACAO)
					   AND TIR.COD_ASS_CONTRATO = TIT.COD_ASS_CONTRATO
					   AND TIR.COD_TITULO_RECEBER <> TIT.COD_TITULO_RECEBER)
			   AND NOT EXISTS (SELECT 1
				  FROM DBSIAF.PARCELAMENTO_CALOURO PAR
				 WHERE PAR.COD_ASS_CONTRATO = TIT.COD_ASS_CONTRATO
					   AND PAR.NUM_PARCELA = TIT.NUM_PARCELA)
		 GROUP BY TIT.COD_ALUNO;
	P_MSG_ERRO DBSIAF.LOG_MENSAGEM.MSG_TECNICA%TYPE;
BEGIN
	FOR R_CANCELA IN C_CANCELA LOOP
		DBSIAF.PC_OPERACAO_TITULO .SP_CANCELAR_TITULO(R_CANCELA.COD_TITULO_RECEBER,
													  277,
													  7,
													  P_MSG_ERRO);
	END LOOP;
END;
