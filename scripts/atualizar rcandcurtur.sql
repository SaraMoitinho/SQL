DECLARE
    CURSOR C_INS IS
        SELECT *
          FROM DBVESTIB.CANDIDATO CAN
         INNER JOIN DBVESTIB.OPCAOCANDIDATO OPC
            ON (OPC.CODCONC = CAN.CODCONC AND OPC.CODINSC = CAN.CODCAN AND OPC.NROOPC = '2')
         INNER JOIN DBVESTIB.CONCURSO CON
            ON (CON.CODCONC = CAN.CODCONC AND CON.ANOCONC IN (
                                                              2016))
         WHERE NOT EXISTS (SELECT 1
                  FROM DBVESTIB.RCANDCURTUROPC OOO
                 WHERE OOO.CODCONC = CAN.CODCONC
                       AND OOO.CODCAN = CAN.CODCAN
                       AND OOO.NROOPC = '2');

BEGIN
    FOR R_INS IN C_INS LOOP
        DBVESTIB.SP_ATUALIZA_OPCOES_CANDIDATO(R_INS.CODCONC,
                                              R_INS.CODCAN,
                                              '2',
                                              'I');
        COMMIT;
    END LOOP;
END;
