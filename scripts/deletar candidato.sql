DECLARE
    CURSOR C_INS IS
        SELECT *
          FROM DBVESTIB.INSCRICAO I
         WHERE CODCONC = '2119'
               AND CODINSC IN ('183746',
                               '194774',
                               '187962',
                               '192720',
                               '192629',
                               '192686',
                               '192753',
                               '182720',
                               '185894',
                               '182675',
                               '182711')
               AND EXISTS (SELECT 1
                  FROM DBVESTIB.OPCAOCANDIDATO OPC
                 WHERE OPC.CODCONC = I.CODCONC
                       AND OPC.CODINSC = I.CODINSC
                       AND OPC.NROOPC = '1');
BEGIN
    FOR R_INS IN C_INS LOOP
        IF R_INS.COD_STATUS_INSCRICAO = 2 THEN
            BEGIN
                DBVESTIB.SP_ESTORNA_INSCRICAO(R_INS.CODCONC,
                                              R_INS.CODINSC);
            END;
        END IF;
        DELETE FROM DBVESTIB.INSCRICAO_DEFICIENCIA DEF
         WHERE DEF.CODINSC = R_INS.CODINSC
               AND DEF.CODCONC = R_INS.CODCONC;
        DELETE FROM DBSIAF.HIST_MAPEAMENTO_TITULO MAT
         WHERE MAT.CODCONC = R_INS.CODCONC
               AND MAT.CODINSC = R_INS.CODINSC;
    
        DELETE FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
         WHERE MI.CODCONC = R_INS.CODCONC
               AND MI.CODINSC = R_INS.CODINSC;
    
        DELETE FROM DBVESTIB.OPCAOCANDIDATO OPC
         WHERE OPC.CODCONC = R_INS.CODCONC
               AND OPC.CODINSC = R_INS.CODINSC;
        DELETE FROM DBVESTIB.INSCRICAO I
         WHERE I.CODCONC = R_INS.CODCONC
               AND I.CODINSC = R_INS.CODINSC;
    
    END LOOP;
END;
