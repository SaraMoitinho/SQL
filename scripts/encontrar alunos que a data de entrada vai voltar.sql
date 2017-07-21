SELECT PLE.*,alu.*,
ALU2.*--COD_PERIODO_ENTRADA)
       --   INTO NCODPERIODOENTRADADEST
          FROM DBSIAF.ALUNO          ALU,
             DBSIAF.ALUNO          ALU2,
             DBSIAF.CURSO          CUR,
             DBSIAF.CURSO          CUR2,
             DBSIAF.PERIODO_LETIVO PLE,
             DBSIAF.CAMPUS         CAM,
             DBSIAF.CAMPUS         CAM2
         WHERE ALU.COD_PESSOA = ALU2.COD_PESSOA
             AND ALU.COD_ALUNO = 1228830--R_REMANEJAMENTO.COD_ALUNO_ORIGEM
             AND ALU2.COD_ALUNO <> ALU.COD_ALUNO
             AND ALU2.COD_CURSO = 1117
             AND ALU.COD_CURSO = CUR.COD_CURSO
             AND ALU2.COD_CURSO = CUR2.COD_CURSO
             AND CUR2.COD_NIV_CURSO = CUR.COD_NIV_CURSO
             AND ALU.COD_CAMPUS = CAM.COD_CAMPUS
             AND ALU2.COD_CAMPUS = CAM2.COD_CAMPUS
             AND CAM2.COD_INSTITUICAO = CAM.COD_INSTITUICAO
             AND ALU2.COD_STA_ALUNO <> 6
             AND PLE.COD_PERIODO_LETIVO = ALU2.COD_PERIODO_ENTRADA
             AND EXISTS (SELECT 1
              FROM DBSIAF.ASS_CONTRATO ASS
             WHERE ASS.COD_ALUNO = ALU2.COD_ALUNO
                 AND ASS.IND_LIBERADO = 'S'
                 AND ROWNUM = 1)
             AND EXISTS (SELECT 1
              FROM DBSIAF.HIST_ESCOLAR HE
             WHERE HE.COD_ALUNO = ALU2.COD_ALUNO
                 AND ROWNUM = 1)
             AND PLE.DAT_INI_PERIODO = (SELECT MIN(PLE.DAT_INI_PERIODO)
                          FROM DBSIAF.ALUNO          AL,
                             DBSIAF.ALUNO          AL2,
                             DBSIAF.CURSO          CU,
                             DBSIAF.CURSO          CU2,
                             DBSIAF.PERIODO_LETIVO PE,
                             DBSIAF.CAMPUS         CA,
                             DBSIAF.CAMPUS         CA2
                           WHERE AL.COD_PESSOA = AL2.COD_PESSOA
                             AND AL.COD_ALUNO = 1228830
                             AND AL2.COD_ALUNO <> AL.COD_ALUNO
                            AND AL2.COD_CURSO =1117
                             AND AL.COD_CURSO = CU.COD_CURSO
                             AND AL2.COD_CURSO = CU2.COD_CURSO
                             AND CU2.COD_NIV_CURSO = CU.COD_NIV_CURSO
                             AND AL.COD_CAMPUS = CA.COD_CAMPUS
                             AND AL2.COD_CAMPUS = CA2.COD_CAMPUS
                             AND CA2.COD_INSTITUICAO = CA.COD_INSTITUICAO
                             AND AL2.COD_STA_ALUNO <> 6
                             AND PE.COD_PERIODO_LETIVO = AL2.COD_PERIODO_ENTRADA
                             AND EXISTS (SELECT 1
                              FROM DBSIAF.ASS_CONTRATO ASS
                               WHERE ASS.COD_ALUNO = AL2.COD_ALUNO
                                 AND ASS.IND_LIBERADO = 'S'
                                 AND ROWNUM = 1)
                             AND EXISTS (SELECT 1
                              FROM DBSIAF.HIST_ESCOLAR HE
                               WHERE HE.COD_ALUNO = AL2.COD_ALUNO
                                 AND ROWNUM = 1));
