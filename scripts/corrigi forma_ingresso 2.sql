PL/SQL Developer Test script 3.0
44


DECLARE
    CURSOR C_PAGO IS
        SELECT DISTINCT (MIS.CODINSC),
                        MIS.CODCONC,
                        T.DAT_PAGAMENTO,
                        T.VAL_PAGO
          FROM DBSIAF.MAPEAMENTO_INSCRICAO MIS,
               DBSIAF.MAPEAMENTO_TITULO    A,
               DBSIAF.TITULO_RECEBER       T
         WHERE MIS.COD_MAPEAMENTO = A.COD_MAPEAMENTO
               AND T.COD_TITULO_RECEBER = A.COD_TITULO_RECEBER
               AND T.COD_STA_TITULO = 6
               AND NOT EXISTS (SELECT 1
                  FROM DBVESTIB.CANDIDATO CAN
                 WHERE CAN.CODCONC = MIS.CODCONC
                       AND CAN.CODCAN = MIS.CODINSC)
               AND EXISTS (SELECT 1
                  FROM DBVESTIB.INSCRICAO INS
                 WHERE INS.CODCONC = MIS.CODCONC
                       AND INS.CODINSC = MIS.CODINSC
                       AND INS.FORMA_INGRESSO = 0
                       AND INS.COD_STATUS_INSCRICAO <> 2)
               AND EXISTS(SELECT 1
               FROM DBVESTIB.OPCAOCANDIDATO OPC
               WHERE OPC.CODCONC = MIS.CODCONC
               AND OPC.CODINSC = MIS.CODINSC
               AND OPC.NROOPC = '1')        ;
BEGIN
    FOR R_PAGO IN C_PAGO LOOP
        DELETE FROM DBSIAF.MAPEAMENTO_INSCRICAO M
         WHERE M.CODCONC = R_PAGO.CODCONC
               AND M.CODINSC = R_PAGO.CODINSC;
    
        UPDATE DBVESTIB.INSCRICAO III
           SET III.DATPGTO              = R_PAGO.DAT_PAGAMENTO,
               III.COD_STATUS_INSCRICAO = 2
         WHERE III.CODCONC = R_PAGO.CODCONC
               AND III.CODINSC = R_PAGO.CODINSC;
    END LOOP;
END;
  

0
0
