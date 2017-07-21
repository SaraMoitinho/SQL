DECLARE
    CURSOR C_CUR IS
        SELECT RR.CODCONC,
               RR.CODCUR,
               RR.CODTUR,
               RR.VAGCUR,
               RR.VALINS,
               RR.VALMENS,
               RR.ULTCLA,
               RR.TURMA_SIAF,
               RR.INDINSCRICAO,
               RR.COD_GRD_QUALIFICACAO_SIAF,
               RR.COD_GRD_CURRICULAR_SIAF,
               RR.INDCANCELADO,
               RR.COD_GRD_CURRICULAR_SIAF_TURMA,
               RR.COD_GRD_QUALIF_SIAF_TURMA,
               RR.IND_LIBERAR_RESULTADO,
               RR.INDFORMACAOAMPLIADA,
               RR.CODCAM,
               RR.INDPROUNI,
               RR.INDFIES,
               ET.COD_ETAPA,
               ET.NUM_VAGAS
          FROM DBVESTIB.RCURTUR           RR,
               DBVESTIB.CURSO_TURNO_ETAPA ET
         WHERE RR.CODCONC = '2068'
               AND ET.CODCONC = RR.CODCONC
               AND ET.CODCUR = RR.CODCUR
               AND ET.CODCAM = RR.CODCAM
               and rr.codtur <> '86';

    VALIDA NUMBER;
BEGIN
    FOR R_CUR IN C_CUR LOOP
        /*
        delete DBVESTIB.RCANDCURTUROPC OOO
         WHERE OOO.CODCONC = R_CUR.CODCONC
               AND OOO.CODCUR = R_CUR.CODCUR
               AND OOO.CODTUR = R_CUR.CODTUR
               AND OOO.CODCAM = R_CUR.CODCAM;*/
        SELECT COUNT(1)
          INTO VALIDA
          FROM DBVESTIB.RCURTUR RRR
         WHERE CODCONC = R_CUR.CODCONC
               AND CODCUR = R_CUR.CODCUR
               AND CODCAM = R_CUR.CODCAM
               AND CODTUR <> R_CUR.CODTUR;
    
        IF VALIDA = 1 THEN
            DELETE DBVESTIB.RCURTUR
             WHERE CODCONC = R_CUR.CODCONC
                   AND CODCUR = R_CUR.CODCUR
                   AND CODCAM = R_CUR.CODCAM
                   AND CODTUR <> R_CUR.CODTUR;
        
        END IF;
        
        DELETE DBVESTIB.RCURTUR
         WHERE CODCONC = R_CUR.CODCONC
               AND CODCUR = R_CUR.CODCUR
               AND CODCAM = R_CUR.CODCAM
               AND CODTUR = R_CUR.CODTUR;
    
        DELETE DBVESTIB.RCURTUROPC
         WHERE CODCONC = R_CUR.CODCONC
               AND CODCUR = R_CUR.CODCUR
               AND CODCAM = R_CUR.CODCAM
               AND CODTUR = R_CUR.CODTUR;
    
        INSERT INTO DBVESTIB.RCURTUR
            (CODCONC,
             CODCUR,
             CODTUR,
             VAGCUR,
             VALINS,
             VALMENS,
             ULTCLA,
             TURMA_SIAF,
             INDINSCRICAO,
             COD_GRD_QUALIFICACAO_SIAF,
             COD_GRD_CURRICULAR_SIAF,
             INDCANCELADO,
             COD_GRD_CURRICULAR_SIAF_TURMA,
             COD_GRD_QUALIF_SIAF_TURMA,
             IND_LIBERAR_RESULTADO,
             INDFORMACAOAMPLIADA,
             CODCAM,
             INDPROUNI,
             INDFIES)
        VALUES
            (R_CUR.CODCONC,
             R_CUR.CODCUR,
             '86',
             R_CUR.VAGCUR,
             R_CUR.VALINS,
             R_CUR.VALMENS,
             R_CUR.ULTCLA,
             R_CUR.TURMA_SIAF,
             R_CUR.INDINSCRICAO,
             R_CUR.COD_GRD_QUALIFICACAO_SIAF,
             R_CUR.COD_GRD_CURRICULAR_SIAF,
             R_CUR.INDCANCELADO,
             R_CUR.COD_GRD_CURRICULAR_SIAF_TURMA,
             R_CUR.COD_GRD_QUALIF_SIAF_TURMA,
             R_CUR.IND_LIBERAR_RESULTADO,
             R_CUR.INDFORMACAOAMPLIADA,
             R_CUR.CODCAM,
             R_CUR.INDPROUNI,
             R_CUR.INDFIES);
    
        /*UPDATE DBVESTIB.RCURTUR
          SET CODTUR = '86'
        WHERE CODCONC = R_CUR.CODCONC
              AND CODCUR = R_CUR.CODCUR
              AND CODCAM = R_CUR.CODCAM;*/
    
        INSERT INTO DBVESTIB.RCURTUROPC
            (CODCONC,
             CODCUR,
             CODTUR,
             OPCLIN,
             CODCAM)
        VALUES
            (R_CUR.CODCONC,
             R_CUR.CODCUR,
             '86',
             0,
             R_CUR.CODCAM);
    
        INSERT INTO DBVESTIB.CURSO_TURNO_ETAPA
            (CODCONC,
             CODCUR,
             CODTUR,
             COD_ETAPA,
             NUM_VAGAS,
             CODCAM)
        VALUES
            (R_CUR.CODCONC,
             R_CUR.CODCUR,
             '86',
             R_CUR.COD_ETAPA,
             R_CUR.NUM_VAGAS,
             R_CUR.CODCAM);
        
        COMMIT;
    END LOOP;
END;
