
BEGIN
  FOR C IN (SELECT COD_MAPEAMENTO
              FROM DBSISPEX.MAPEAMENTO_SOLICITACAO
             WHERE COD_SOLICITACAO IN (4993117)) LOOP
    DBSIAF.PC_ACAO_PROTOCOLO.SP_REALIZAR_TRANCAMENTO(C.COD_MAPEAMENTO);
    COMMIT;
  END LOOP;

END; 