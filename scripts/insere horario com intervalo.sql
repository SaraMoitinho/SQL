PROCEDURE SP_INSERE_HORARIO(P_DATA                     DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM.DATA_PROVA%TYPE,
                                P_HORA_INICIAL             VARCHAR2,
                                P_HORA_FINAL               VARCHAR2,
                                P_COD_TPO_CONCURSO_ANO_SEM DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM.COD_TIPO_CONCURSO_ANO_SEMESTRE%TYPE,
                                INTERVALO                  intEGER) IS
    
        HORA_INICIAL TIMESTAMP;
        HORA_FINAL   VARCHAR(10);
        DATA         TIMESTAMP;
        HORAINI      VARCHAR2(10);
        DATA_PROVA   DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM.DATA_PROVA%TYPE;
    BEGIN
    
        DATA_PROVA := TO_DATE(P_DATA,
                              'DD/MM/YY');
        HORA_FINAL := TO_CHAR(TO_DATE(DATA_PROVA || ' ' || P_HORA_FINAL,
                                      'DD/MM/YY HH24:MI'),
                              'hh24:mi');
    
        HORAINI := TO_CHAR(TO_DATE(DATA_PROVA || ' ' || P_HORA_INICIAL,
                                   'DD/MM/YY HH24:MI'),
                           'hh24:mi');
    
        DATA := TO_DATE(DATA_PROVA || ' ' || P_HORA_INICIAL,
                        'DD/MM/YY HH24:MI');
    
        IF (P_HORA_FINAL > P_HORA_INICIAL)
           AND intERVALO > 0 THEN
        
            WHILE HORAINI < HORA_FINAL LOOP
            
                HORA_INICIAL := TO_DATE(DATA_PROVA || ' ' || HORAINI,
                                        'DD/MM/YY HH24:MI');
            
                DATA := DATA + intervalo / 24 / 60; -- data acrescentada
                IF TO_CHAR(DATA,
                           'hh24:mi') <= HORA_FINAL THEN
                    INSERT INTO DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM
                        (COD_HORARIO_TPO_CONC_ANO_SEM,
                         COD_TIPO_CONCURSO_ANO_SEMESTRE,
                         HOR_INICIO,
                         HOR_FIM,
                         DATA_PROVA)
                    VALUES
                        (DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM_S.NEXTVAL,
                         P_COD_TPO_CONCURSO_ANO_SEM,
                         HORA_INICIAL,
                         DATA,
                         DATA_PROVA);
                
                    HORAINI := TO_CHAR(DATA,
                                       'hh24:mi');
                ELSE
                    HORAINI := HORA_FINAL;
                
                END IF;
            
            END LOOP;
        
        ELSE
        
            INSERT INTO DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM
                (COD_HORARIO_TPO_CONC_ANO_SEM,
                 COD_TIPO_CONCURSO_ANO_SEMESTRE,
                 HOR_INICIO,
                 HOR_FIM,
                 DATA_PROVA)
            VALUES
                (DBSIAF.HORARIO_TPO_CONCURSO_ANO_SEM_S.NEXTVAL,
                 P_COD_TPO_CONCURSO_ANO_SEM,
                 TO_DATE(P_DATA || ' ' || HORAINI,
                         'DD/MM/YY HH24:MI'),
                 TO_DATE(P_DATA || ' ' || HORA_FINAL,
                         'DD/MM/YY HH24:MI'),
                 DATA_PROVA);
        END IF;
    END;

end
