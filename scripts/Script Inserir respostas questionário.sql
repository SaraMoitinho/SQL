DECLARE
    CURSOR C_CONC IS
    
    --ead
        SELECT C.CODCONC
          FROM DBVESTIB.PARAMETROS_CONCURSO C
         WHERE C.IND_SELECIONA_POLO = 'S'
        
        UNION
        SELECT C.CODCONC
          FROM DBVESTIB.CONCURSO C
         WHERE C.COD_TPO_CONCURSO IN (1,
                                      3,
                                      64)
            --   AND C.SEMCONC = '1'
               AND C.ANOCONC = '2016';

    VALIDA NUMBER;
    QUANT  NUMBER;
BEGIN
    FOR R_CONC IN C_CONC LOOP
    
        SELECT COUNT(1)
          INTO VALIDA
          FROM DBVESTIB.RESPSOCECO P
         WHERE P.CODCONC = R_CONC.CODCONC;
    
        IF VALIDA > 0 THEN
        
            SELECT COUNT(P.CODRESP)
              INTO QUANT
              FROM DBVESTIB.RESPSOCECO P
             WHERE P.CODCONC = R_CONC.CODCONC;
        
            IF QUANT < 240 THEN
            
                DELETE FROM DBVESTIB.RESPSOCECO RES
                 WHERE RES.CODCONC = R_CONC.CODCONC;
                COMMIT;
            
                INSERT INTO DBVESTIB.RESPSOCECO
                    (CODCONC,
                     CODPERG,
                     CODRESP,
                     DSCRESP,
                     DSCRESPABERTA,
                     VALRESP)
                    SELECT R_CONC.CODCONC,
                           CODPERG,
                           CODRESP,
                           DSCRESP,
                           DSCRESPABERTA,
                           VALRESP
                      FROM DBVESTIB.RESPSOCECO
                     WHERE CODCONC = '2575';
            END IF;
            ELSE 
              INSERT INTO DBVESTIB.RESPSOCECO
                    (CODCONC,
                     CODPERG,
                     CODRESP,
                     DSCRESP,
                     DSCRESPABERTA,
                     VALRESP)
                    SELECT R_CONC.CODCONC,
                           CODPERG,
                           CODRESP,
                           DSCRESP,
                           DSCRESPABERTA,
                           VALRESP
                      FROM DBVESTIB.RESPSOCECO
                     WHERE CODCONC = '2575';
                     COMMIT;
        END IF;
    END LOOP;
END;
