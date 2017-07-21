     SELECT CAN.CODCONC,
            CAN.CODCAN,
            CAM.CODCAM,
            TO_DATE(DIP.DAT_HORA_INICIO,
                    'DD/MM/YYYY') DATA_PROVA,
            TO_CHAR(DIP.DAT_HORA_INICIO,
                    'HH24:MI') HORA_PROVA,
            (SELECT DBVESTIB.F_NOTA_PROVA(NPR.CODCONC,
                                          NPR.CODCAN,
                                          '1',
                                          NPR.CODPRO,
                                          NPR.COD_ETAPA)
               FROM DBVESTIB.NOTA_PROVA NPR
              WHERE NPR.CODCONC = CIN.CODCONC
                    AND NPR.CODCAN = CIN.CODINSC
                    AND NPR.NROOPC = '1'
                    AND NPR.CODPRO = 3),
            (SELECT STA.DSC_STA_CLASSIFICACAO
               FROM DBVESTIB.CLASSIFICACAO_CANDIDATO CLA,
                    DBVESTIB.STATUS_CLASSIFICACAO    STA
              WHERE CLA.CODCONC = CIN.CODCONC
                    AND CLA.CODCAN = CIN.CODINSC
                    AND CLA.COD_ETAPA = 1
                    AND CLA.NROOPC = '1'
                    AND STA.COD_STA_CLASSIFICACAO = CLA.COD_STA_CLASSIFICACAO),
            CAN.CODFORMAPROVA
       FROM DBSAG.MAPEAMENTO_CLI_INSCRICAO CIN,
            DBSAG.AGENDAMENTO              AGE,
            DBSAG.DISPONIBILIDADE_PESSOA   DIP,
            DBSAG.MAPEAMENTO_LOC_ESTRUTURA MLE,
            DBSAG.LOCAL_PROCESSO           LOC,
            DBVESTIB.CAMPUS                CAM,
            DBVESTIB.CANDIDATO             CAN
      WHERE CIN.CODCONC = &P_CODCONC
            AND CIN.COD_MAPEAMENTO_CLIENTE = AGE.COD_MAPEAMENTO_CLIENTE
            AND DIP.COD_DISPONIBILIDADE = AGE.COD_DISPONIBILIDADE
            AND DIP.COD_LOCAL_PROCESSO = LOC.COD_LOCAL_PROCESSO
            AND LOC.COD_MAPEAMENTO_LOCAL = MLE.COD_MAPEAMENTO_LOCAL
            AND MLE.COD_ESTRUTURA = CAM.COD_ESTRUTURA
            AND CAN.CODCONC = CIN.CODCONC
            AND CAN.CODCAN = CIN.CODINSC
            AND CAM.COD_CAMPUS_SIAF = NVL(&P_CODCAM,
                                          CAM.COD_CAMPUS_SIAF)
           
            AND ((((((
            -- Compara apenas a data inicio. Data e hora fim são nulos 
             (TO_DATE(DIP.DAT_HORA_INICIO,
                               'DD/MM/YY') = TO_DATE(&P_DATA_INICIO,
                                                               'DD/MM/YY') AND (&P_HORA_INICIO IS NULL) AND (&P_DATA_FIM IS NULL) AND (&P_HORA_FIM IS NULL)) OR (DIP.DAT_HORA_INICIO = TO_DATE(&P_DATA_INICIO || ' ' || &P_HORA_INICIO,
                                                                                                                                                                                                        'DD/MM/YYYY HH24:MI') AND (&P_HORA_INICIO IS NOT NULL AND &P_DATA_FIM IS NULL AND &P_HORA_FIM IS NULL)))
            -- verifica intervalo de datas com horas null
            OR (TO_DATE(DIP.DAT_HORA_INICIO,
                                 'DD/MM/YY') BETWEEN TO_DATE(&P_DATA_INICIO,
                                                                          'DD/MM/YY') AND TO_DATE(&P_DATA_FIM,
                                                                                                               'DD/MM/YY') AND (&P_HORA_INICIO IS NULL AND &P_HORA_FIM IS NULL)))
            -- intervalo de datas com as 2 horas not null
            OR (DIP.DAT_HORA_INICIO BETWEEN TO_DATE(&P_DATA_INICIO || ' ' || &P_HORA_INICIO,
                                                            'DD/MM/YYYY HH24:MI') AND TO_DATE(&P_DATA_FIM || ' ' || &P_HORA_FIM,
                                                                                                          'DD/MM/YYYY HH24:MI') AND (&P_HORA_INICIO IS NOT NULL AND &P_HORA_FIM IS NOT NULL AND &P_DATA_INICIO IS NOT NULL AND &P_DATA_FIM IS NOT NULL)))
            --intervalo de datas com hora final null
            OR (DIP.DAT_HORA_INICIO BETWEEN TO_DATE(&P_DATA_INICIO || ' ' || &P_HORA_INICIO,
                                                           'DD/MM/YYYY HH24:MI') AND TO_DATE(&P_DATA_FIM || ' ' || '23:59',
                                                                                                        'DD/MM/YYYY HH24:MI') AND (&P_HORA_INICIO IS NOT NULL AND &P_HORA_FIM IS NULL AND &P_DATA_INICIO IS NOT NULL AND &P_DATA_FIM IS NOT NULL)))
            --intervalo de datas com hora inicial null
            OR (DIP.DAT_HORA_INICIO BETWEEN TO_DATE(&P_DATA_INICIO || ' ' || '23:59',
                                                          'DD/MM/YYYY HH24:MI') AND TO_DATE(&P_DATA_FIM || ' ' || &P_HORA_FIM,
                                                                                                      'DD/MM/YYYY HH24:MI') AND (&P_HORA_INICIO IS NULL AND &P_HORA_FIM IS NOT NULL AND &P_DATA_INICIO IS NOT NULL AND &P_DATA_FIM IS NOT NULL)))
            -- apenas a data fim/hora fim foram informados
            OR ((TO_DATE(DIP.DAT_HORA_INICIO,
                              'DD/MM/YY') = TO_DATE(&P_DATA_FIM,
                                                              'DD/MM/YY') AND (&P_HORA_INICIO IS NULL) AND (&P_DATA_INICIO IS NULL) AND (&P_HORA_FIM IS NULL)) OR (DIP.DAT_HORA_INICIO = TO_DATE(&P_DATA_FIM || ' ' || &P_HORA_FIM,
                                                                                                                                                                                                          'DD/MM/YYYY HH24:MI') AND (&P_DATA_FIM IS NOT NULL AND &P_HORA_FIM IS NOT NULL AND &P_DATA_INICIO IS NULL AND &P_HORA_INICIO IS NULL))))173947
