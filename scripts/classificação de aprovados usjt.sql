---------------------------------------------------------
-- para classifica��o geral
----------------------------------------------------------
DECLARE
    CURSOR C_CAN IS
        SELECT CODCONC,
               CODCAN,
               CAN.CODFORMAPROVA
          FROM DBVESTIB.CANDIDATO CAN
         WHERE CAN.CODCONC = &P_CODCONC_DES;

    CURSOR C_NOTA(P_CODCAN DBVESTIB.CANDIDATO.CODCAN%TYPE) IS
        SELECT NPR.CODCONC,
               NPR.CODCAN,
               NPR.NOTAPARCIAL,
               NPR.NOTAFINAL,
               NPR.CODPRO, 
               npr.nroopc
          FROM DBVESTIB.NOTA_PROVA NPR
         WHERE NPR.CODCONC = &P_CODCONC_ORIGINAL
               AND NPR.CODCAN = P_CODCAN
         AND NPR.NROOPC = '1';

    CURSOR C_NOTAENEM(P_CODCAN DBVESTIB.NOTAENEM.CODCAN%TYPE) IS
        SELECT NOE.CODPRO,
               NOE.VALNOTA
          FROM DBVESTIB.NOTAENEM NOE
         WHERE NOE.CODCONC = &P_CODCONC_ORIGINAL
               AND NOE.CODCAN = P_CODCAN;

    MENSAGEM VARCHAR2(400);
    VALIDA   NUMBER;
    CONTA    NUMBER;
BEGIN

    -- VERIFICA SE OS CANDIDATOS J� FORAM REPLICADOS
  DELETE FROM   DBVESTIB.LOG_ERROS_IMPORTACAO LOI
  WHERE LOI.CODCONC =  &P_CODCONC_DES;
  
    SELECT count(1)
      INTO VALIDA
      FROM DBVESTIB.CANDIDATO CAN
     WHERE CAN.CODCONC = &P_CODCONC_DES     ;

    IF VALIDA = 0 THEN
        INSERT INTO DBVESTIB.CANDIDATO
            (CODCONC,
             CODCAN,
             NOMCAN,
             SEXCAN,
             DATNASCAN,
             IDECAN,
             NOMIDECAN,
             EXPIDECAN,
             TELCAN,
             ENDCAN,
             BAICAN,
             CIDCAN,
             ESTCAN,
             CEPCAN,
             DATINSCAN,
             DATPAGCAN,
             CODLOCPAG,
             EMAIL,
             CANHOTO,
             TAG,
             CODCANANT,
             REGFCH,
             FLGMAT,
             DATINCCAN,
             str_SOCECO,
             CODTPODEF,
             IND_TREINANTE,
             CODDIS,
             NOM_PAI,
             NOM_MAE,
             IND_ALUNO_FUNCESI,
             TIP_ESCOLA,
             REG_EMPREGADO,
             NOM_EMPREGADO,
             LOC_TRABALHO,
             CODCIDPROVA,
             CODCIDESCOLHA,
             CELCAN,
             CPFCAN,
             SERIECAN,
             NOMEESC,
             RAMAL,
             NUMERO,
             MATRICULA,
             FORMA_INGRESSO,
             ESCOLA_ORIGEM,
             SENCAN,
             TELESC,
             NUMCRESP,
             DSCCRESP,
             NUMEQUIPE,
             DSCEQUIPE,
             INDUSATRANS,
             INDQUANTPASSAGEM,
             INDITIESCOLHIDO,
             CODEMP,
             INDLEESCREVE,
             ENDESC,
             COMPLEMENTO,
             NUMEND,
             COD_LOC_INSCRICAO,
             COD_FIS_INSCRICAO,
             NOM_SETOR,
             VALPAGO,
             INDCONFIRMADO,
             BAIESC,
             CEPESC,
             CIDESC,
             NUM_ESCOLA,
             COMPLEMENTO_ESCOLA,
             COD_INSTIT_EXTERNA,
             CODCAMPROXRESIDENCIA,
             CODFORMAPROVA,
             ANOENEM,
             NUMINSCENEM,
             DATPROVAAGENDADA,
             CODESTADOCIVIL,
             CODPAISNC,
             CODCIDADENAT,
             TELCOMERCIAL,
             INDTRABALHA,
             CODESCOLA,
             EMAIL_ALTERNATIVO,
             NOMCURSOGRADUACAO,
             ANOCONCLUSAOEM,
             COD_ESCOLA_ORIGEM,
             COD_CURSINHO,
             NOMCURSINHOOUTRO,
             COD_EMP_CONVENIADAS,
             CODBARRAS,
             COD_GRD_CURRICULAR,
             COD_GRD_QUALIFICACAO,
             COD_OCORRENCIA,
             COD_INSTITUICAO_PSVS)
            SELECT &P_CODCONC_DES,
                   CODCAN,
                   NOMCAN,
                   SEXCAN,
                   DATNASCAN,
                   IDECAN,
                   NOMIDECAN,
                   EXPIDECAN,
                   TELCAN,
                   ENDCAN,
                   BAICAN,
                   CIDCAN,
                   ESTCAN,
                   CEPCAN,
                   DATINSCAN,
                   DATPAGCAN,
                   CODLOCPAG,
                   EMAIL,
                   CANHOTO,
                   TAG,
                   CODCANANT,
                   REGFCH,
                   FLGMAT,
                   DATINCCAN,
                   str_SOCECO,
                   CODTPODEF,
                   IND_TREINANTE,
                   CODDIS,
                   NOM_PAI,
                   NOM_MAE,
                   IND_ALUNO_FUNCESI,
                   TIP_ESCOLA,
                   REG_EMPREGADO,
                   NOM_EMPREGADO,
                   LOC_TRABALHO,
                   CODCIDPROVA,
                   CODCIDESCOLHA,
                   CELCAN,
                   CPFCAN,
                   SERIECAN,
                   NOMEESC,
                   RAMAL,
                   NUMERO,
                   MATRICULA,
                   FORMA_INGRESSO,
                   ESCOLA_ORIGEM,
                   SENCAN,
                   TELESC,
                   NUMCRESP,
                   DSCCRESP,
                   NUMEQUIPE,
                   DSCEQUIPE,
                   INDUSATRANS,
                   INDQUANTPASSAGEM,
                   INDITIESCOLHIDO,
                   CODEMP,
                   INDLEESCREVE,
                   ENDESC,
                   COMPLEMENTO,
                   NUMEND,
                   COD_LOC_INSCRICAO,
                   COD_FIS_INSCRICAO,
                   NOM_SETOR,
                   VALPAGO,
                   INDCONFIRMADO,
                   BAIESC,
                   CEPESC,
                   CIDESC,
                   NUM_ESCOLA,
                   COMPLEMENTO_ESCOLA,
                   COD_INSTIT_EXTERNA,
                   CODCAMPROXRESIDENCIA,
                   CODFORMAPROVA,
                   ANOENEM,
                   NUMINSCENEM,
                   DATPROVAAGENDADA,
                   CODESTADOCIVIL,
                   CODPAISNC,
                   CODCIDADENAT,
                   TELCOMERCIAL,
                   INDTRABALHA,
                   CODESCOLA,
                   EMAIL_ALTERNATIVO,
                   NOMCURSOGRADUACAO,
                   ANOCONCLUSAOEM,
                   COD_ESCOLA_ORIGEM,
                   COD_CURSINHO,
                   NOMCURSINHOOUTRO,
                   COD_EMP_CONVENIADAS,
                   CODBARRAS,
                   COD_GRD_CURRICULAR,
                   COD_GRD_QUALIFICACAO,
                   COD_OCORRENCIA,
                   COD_INSTITUICAO_PSVS
              FROM DBVESTIB.CANDIDATO CAN
             WHERE CAN.CODCONC = &P_CODCONC_ORIGINAL
             AND EXISTS (SELECT 1 FROM DBVESTIB.CLASSIFICACAO_CANDIDATO CLA
             WHERE CLA.CODCONC = CAN.CODCONC AND CLA.CODCAN = CAN.CODCAN AND CLA.COD_STA_CLASSIFICACAO = 9 AND CLA.COD_ETAPA = 1
             AND CLA.NROOPC = '1');
        COMMIT;
    END IF;
    -- PASSA O CONCURSO PARA "OUTRAS AVALIA��ES PORQUE N�O EXISTE INSCRI��O PARA ESTES CANDIDATOS E N�O ATUALIZA O CURSO DA OPCAOCANDIDATO"
    UPDATE DBVESTIB.CONCURSO CON
       SET CON.COD_TPO_CONCURSO = '67'
     WHERE CON.CODCONC = &P_CODCONC_DES;

    CONTA := 0;
    -- INSERE OPCAO DE CURSO
    FOR R_CAN IN C_CAN LOOP
        BEGIN
      insert into dbvestib.rcandcurturopc (CODCONC,
                 CODCAN,
                 CODCUR,
                 CODTUR,
                 NROOPC,
                 OPCLIN,
                 INDFORMACAOAMPLIADA,
                 INDPROUNI,
                 INDFIES,
                 CODCAM,
                 CODINSTITUICAO,
                 IND_DESEJA_PROUNI,
                 IND_DESEJA_FIES)
      select &P_CODCONC_DES,
                 CODCAN,
                 CODCUR,
                 '03',
                 NROOPC,
                 OPCLIN,
                 INDFORMACAOAMPLIADA,
                 INDPROUNI,
                 INDFIES,
                 '63',
                 '12',
                 IND_DESEJA_PROUNI,
                 IND_DESEJA_FIES
         FROM DBVESTIB.RCANDCURTUROPC RPC
         WHERE RPC.CODCONC =  &P_CODCONC_ORIGINAL
         AND RPC.CODCAN = R_CAN.CODCAN
         AND RPC.NROOPC = '1'
         AND EXISTS (SELECT 1 FROM DBVESTIB.CLASSIFICACAO_CANDIDATO CLA
             WHERE CLA.CODCONC = RPC.CODCONC AND CLA.CODCAN = RPC.CODCAN AND CLA.COD_STA_CLASSIFICACAO = 9 AND CLA.COD_ETAPA = 1
             AND CLA.NROOPC = '1');
         
            /*INSERT INTO DBVESTIB.RCANDCURTUROPC
                (CODCONC,
                 CODCAN,
                 CODCUR,
                 CODTUR,
                 NROOPC,
                 OPCLIN,
                 INDFORMACAOAMPLIADA,
                 INDPROUNI,
                 INDFIES,
                 CODCAM,
                 CODINSTITUICAO,
                 IND_DESEJA_PROUNI,
                 IND_DESEJA_FIES)
            VALUES
                (R_CAN.CODCONC,
                 R_CAN.CODCAN,
                 '01',
                 '03',
                 '1',
                 0,
                 'N',
                 'N',
                 'N',
                 '63',
                 '12',
                 'N',
                 'N');*/
        
            IF R_CAN.CODFORMAPROVA = 1 THEN
                FOR R_NOTA IN C_NOTA(R_CAN.CODCAN) LOOP
                    INSERT INTO DBVESTIB.NOTA_PROVA
                        (CODNOTAPROVA,
                         CODCONC,
                         CODCAN,
                         NROOPC,
                         COD_ETAPA,
                         CODPRO,
                         NOTAPARCIAL)
                    VALUES
                        (DBVESTIB.NOTA_PROVA_S.NEXTVAL,
                         R_CAN.CODCONC,
                         R_CAN.CODCAN,
                         R_NOTA.NROOPC,
                         1,
                         R_NOTA.CODPRO,
                         R_NOTA.NOTAPARCIAL);
                END LOOP;
            
            ELSE
                FOR R_ENEM IN C_NOTAENEM(R_CAN.CODCAN) LOOP
                    INSERT INTO DBVESTIB.NOTAENEM
                        (CODCONC,
                         CODCAN,
                         CODPRO,
                         VALNOTA)
                    VALUES
                        (R_CAN.CODCONC,
                         R_CAN.CODCAN,
                         R_ENEM.CODPRO,
                         R_ENEM.VALNOTA);
                END LOOP;
            
            END IF;
        
        EXCEPTION
            WHEN OTHERS THEN
                MENSAGEM := SQLERRM;
                INSERT INTO DBVESTIB.LOG_ERROS_IMPORTACAO
                    (CODCONC,
                     CODCAN,
                     COD_ERRO,
                     DSC_ERRO)
                VALUES
                    (R_CAN.CODCONC,
                     R_CAN.CODCAN,
                     1,
                     MENSAGEM);
                COMMIT;
            
        END;
        CONTA := CONTA + 1;
        IF CONTA = 50 THEN
            CONTA := 0;
            COMMIT;
        END IF;
    END LOOP;
    DBVESTIB.PC_CLASSIFICACAO.SP_CLASSIFICAR_INSTITUICOES(&P_CODCONC_DES,
                                                          1, -- tpo_classifica��o
                                                          '1', -- opcao de curso
                                                          1, -- etapa
                                                          'N', --inclui treinantes
                                                          'S', --processa resultado
                                                          'S', --processa desistente
                                                          NULL, --codcan
                                                          'S' -- ind_commit
                                                          );

END;
