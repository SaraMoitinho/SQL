DECLARE
CURSOR C_COB IS
SELECT --SUBSTR (AGE.REF_CONTABIL, 1,2        
         ALU.NUM_MATRICULA,
         UPPER(ALU.NOM_ALUNO) NOME,
         SOL.DAT_SOLICITACAO DATA_SOLICITACAO,
         TIT.DAT_PROG_ORIGINAL DATA_TITULO,
         AGE.REF_CONTABIL REFERENCIA_CONTABIL,
         LIM.COD_LIMPEZA_BASE,
         TIT.COD_TITULO_RECEBER,
         TIT.COD_ALUNO
          FROM DBSIAF.TITULO_RECEBER TIT
          JOIN DBSIAF.SOLICITACAO SOL
            ON (TIT.COD_ALUNO = SOL.COD_ALUNO AND TIT.COD_INSTITUICAO = SOL.COD_INSTITUICAO)
          JOIN DBSIAF.TIPO_SOLICITACAO_ETAPA TSE
            ON (TSE.COD_TPO_SOLICITACAO = SOL.COD_TPO_SOLICITACAO)
          JOIN DBSIAF.ETAPA_STATUS_SOLICITACAO ESS
            ON (ESS.COD_ETAPA_SOLICITACAO = TSE.COD_ETAPA_SOLICITACAO AND ESS.COD_STA_SOLICITACAO = SOL.COD_STA_SOLICITACAO)
          JOIN DBSIAF.ACAO_PROTOCOLO APR
            ON (APR.COD_ACAO_PROTOCOLO = ESS.COD_ACAO_PROTOCOLO AND APR.COD_TPO_SERVICO IN (2,
                                                                                            3))
          JOIN DBSIAF.TIPO_TITULO TTL
            ON (TTL.COD_TPO_TITULO = TIT.COD_TPO_TITULO AND TTL.IND_FINANCEIRO = 'S' AND TTL.IND_MENSALIDADE = 'S')
          JOIN DBSIAF.LIMPEZA_BASE LIM
            ON (LIM.COD_INSTITUICAO = SOL.COD_INSTITUICAO AND LIM.COD_ALUNO = SOL.COD_ALUNO AND LIM.COD_SOLICITACAO = SOL.COD_SOLICITACAO)
          JOIN DBSIAF.ALUNO ALU
            ON (ALU.COD_ALUNO = TIT.COD_ALUNO AND ALU.COD_INSTITUICAO = SOL.COD_INSTITUICAO AND SOL.COD_ALUNO IN( 843114,838936, 838539))
          JOIN DBSIAF.AGENDA_CONTABIL AGE
            ON (AGE.COD_PERIODO_LETIVO = TIT.COD_PERIODO_LETIVO AND AGE.NUM_PARCELA = TIT.NUM_PARCELA)
         WHERE TIT.COD_STA_TITULO = 1
              -- AND DBSIAF.PC_COBRANCA.F_TITULO_COBRANCA(TIT.COD_TITULO_RECEBER) = 'S'
               AND AGE.REF_CONTABIL >= TO_CHAR(SOL.DAT_SOLICITACAO,
                                               'YYYYMM')
               AND TO_NUMBER(TO_CHAR(SOL.DAT_SOLICITACAO,
                                     'DD')) <= 8            
               AND TIT.COD_INSTITUICAO= 8;
               S_MSG_ERRO CLOB;
BEGIN               
FOR R_COB IN C_COB LOOP
        DBSIAF.PC_OPERACAO_TITULO.SP_OPERACAO_TITULO(R_COB.COD_ALUNO,
                                                     R_COB.COD_TITULO_RECEBER,
                                                     4,
                                                     408,
                                                     'N',
                                                     'S',
                                                     S_MSG_ERRO,
                                                     'S');
        COMMIT;
    END LOOP;  
    END;             
