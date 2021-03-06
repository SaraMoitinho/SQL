DECLARE 
CURSOR C_CAN IS
SELECT TIT.COD_TITULO_RECEBER, TIT.NUM_TITULO
  FROM DBVESTIB.CANDIDATO CAN
  INNER JOIN DBSIAF.ALUNO ALU ON (ALU.CODCONC = CAN.CODCONC AND ALU.CODCAN = CAN.CODCAN)
  INNER JOIN DBSIAF.TITULO_RECEBER TIT ON (TIT.COD_ALUNO = ALU.COD_ALUNO AND TIT.COD_STA_TITULO = 1 AND TIT.COD_MODALIDADE = 220)
 WHERE CAN.CODCONC = '2623'
	   AND DBVESTIB.F_STATUS_INSCRICAO_PROCESSOCOD(CAN.CODCAN,
												   CAN.CODCONC) = 14;
     P_COD_LOG_SISTEMA LOG_MENSAGEM.COD_LOG_SISTEMA%TYPE;
BEGIN
  FOR R_CAN IN C_CAN LOOP
   DBSIAF.PC_OPERACAO_TITULO.SP_ALTERA_MODALIDADE(R_CAN.COD_TITULO_RECEBER,
																		 222, --MODALIDADE
																		 R_CAN.NUM_TITULO,
																		 P_COD_LOG_SISTEMA);               
   DBSIAF.PC_OPERACAO_TITULO.SP_ALTERA_DISPONIBILIZACAO(R_CAN.COD_TITULO_RECEBER,1, R_CAN.NUM_TITULO, P_COD_LOG_SISTEMA);
   END LOOP;
END;                                                                         
