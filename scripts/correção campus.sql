DECLARE
    CURSOR C_CURSO IS
        SELECT RCU.CODCONC,
               RCU.CODCUR,
               RCU.CODTUR,
               RCU.VAGCUR,
               RCU.VALINS,
               RCU.VALMENS,
               RCU.ULTCLA,
               RCU.TURMA_SIAF,
               RCU.INDINSCRICAO,
               RCU.COD_GRD_QUALIFICACAO_SIAF,
               RCU.COD_GRD_CURRICULAR_SIAF,
               RCU.INDCANCELADO,
               RCU.COD_GRD_CURRICULAR_SIAF_TURMA,
               RCU.COD_GRD_QUALIF_SIAF_TURMA,
               RCU.IND_LIBERAR_RESULTADO,
               RCU.INDFORMACAOAMPLIADA,
               RCU.CODCAM,
               RCU.COD_CURRICULO_CADSOFT,
               RCU.INDPROUNI,
               RCU.ETAPANATURAL,
               RCU.NUMINSCRITOS,
               RCU.NUMPAGOS,
               RCU.NUMPRESENTES,
               RCU.NUMMATRICULABRUTA,
               RCU.NUMMATRICULALIQUIDA,
               RCU.INDFIES,
               RCO.OPCLIN,
               RET.COD_ETAPA,
               RET.NUM_VAGAS,
               CCA.COD_CURSO_CADSOFT,
               CCA.COD_PERIODO_LETIVO,
               CCA.COD_CURSO_SIAF,
               CCA.COD_CURSO_SIAF_TURMA,
               CCD.CODCAD
          FROM DBVESTIB.RCURTUR           RCU,
               DBVESTIB.CONCURSO          CON,
               DBVESTIB.RCURTUROPC        RCO,
               DBVESTIB.CURSO_TURNO_ETAPA RET,
               DBVESTIB.CURSO_CAMPUS      CCA,
               DBVESTIB.CURSOSCADERNO     CCD
         WHERE CON.CODCONC = RCU.CODCONC
               AND CON.ANOCONC = 2013
               AND CON.SEMCONC = 2
               AND RCU.CODCAM = 29
               AND RCO.CODCONC = RCU.CODCONC
               AND RCO.CODCUR = RCU.CODCUR
               AND RCO.CODTUR = RCU.CODTUR
               AND RCO.CODCAM = RCU.CODCAM
               AND RET.CODCONC = RCU.CODCONC
               AND RET.CODCUR = RCU.CODCUR
               AND RET.CODTUR = RCU.CODTUR
               AND RET.CODCAM = RCU.CODCAM
               AND CCA.CODCONC = RCU.CODCONC
               AND CCA.CODCUR = RCU.CODCUR
               AND CCA.CODCAM = RCU.CODCAM
               AND CCD.CODCONC = RCU.CODCONC
               AND CCD.CODCUR = RCU.CODCUR
               AND CON.INDINSC = 'S'
             /*  and not exists (select 1 from dbvestib.rcurtur r
               where r.codconc = rcu.codconc
               and r.codcur = rcu.codcur
               and r.codcam = 28)*/;

BEGIN
    FOR R_CURSO IN C_CURSO LOOP
    INSERT INTO DBVESTIB.CURSO_CAMPUS
            (CODCONC,
             CODCUR,
             CODCAM,
             COD_CURSO_CADSOFT,
             COD_CURSO_SIAF,
             COD_PERIODO_LETIVO,
             COD_CURSO_SIAF_TURMA)
        VALUES
            (R_CURSO.CODCONC,
             R_CURSO.CODCUR,
             28,
             R_CURSO.COD_CURSO_CADSOFT,
             r_curso.COD_CURSO_SIAF,
             R_CURSO.COD_PERIODO_LETIVO,
             R_CURSO.COD_CURSO_SIAF_TURMA);
                              
        UPDATE DBVESTIB.RCURTUR R
           SET R.INDINSCRICAO = 'N'
         WHERE R.CODCONC = R_CURSO.CODCONC
               AND R.CODCUR = R_CURSO.CODCUR
               AND R.CODTUR = R_CURSO.CODTUR
               AND R.CODCAM = R_CURSO.CODCAM;
        
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
             COD_CURRICULO_CADSOFT,
             INDPROUNI,
             ETAPANATURAL,
             NUMINSCRITOS,
             NUMPAGOS,
             NUMPRESENTES,
             NUMMATRICULABRUTA,
             NUMMATRICULALIQUIDA,
             INDFIES)
        VALUES
            (R_CURSO.CODCONC,
             R_CURSO.CODCUR,
             R_CURSO.CODTUR,
             R_CURSO.VAGCUR,
             R_CURSO.VALINS,
             R_CURSO.VALMENS,
             R_CURSO.ULTCLA,
             R_CURSO.TURMA_SIAF,
             'S',
             R_CURSO.COD_GRD_QUALIFICACAO_SIAF,
             R_CURSO.COD_GRD_CURRICULAR_SIAF,
             R_CURSO.INDCANCELADO,
             R_CURSO.COD_GRD_CURRICULAR_SIAF_TURMA,
             R_CURSO.COD_GRD_QUALIF_SIAF_TURMA,
             R_CURSO.IND_LIBERAR_RESULTADO,
             R_CURSO.INDFORMACAOAMPLIADA,
             28,
             R_CURSO.COD_CURRICULO_CADSOFT,
             R_CURSO.INDPROUNI,
             R_CURSO.ETAPANATURAL,
             R_CURSO.NUMINSCRITOS,
             R_CURSO.NUMPAGOS,
             R_CURSO.NUMPRESENTES,
             R_CURSO.NUMMATRICULABRUTA,
             R_CURSO.NUMMATRICULALIQUIDA,
             R_CURSO.INDFIES);
    
        DBVESTIB.PC_CLASSIFICACAO.SP_GERA_ETAPA_CURSO(R_CURSO.CODCONC,
                                                      R_CURSO.CODCUR);
    
    
        INSERT INTO DBVESTIB.RCURTUROPC
            (CODCONC,
             CODCUR,
             CODCAM,
             CODTUR,
             OPCLIN)
        VALUES
            (R_CURSO.CODCONC,
             R_CURSO.CODCUR,
             28,
             R_CURSO.CODTUR, R_CURSO.OPCLIN);
    
        COMMIT;
    END LOOP;

END;
