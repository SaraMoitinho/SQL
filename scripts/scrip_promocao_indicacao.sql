PL/SQL Developer Test script 3.0
123
DECLARE

    DESCONTO  DBVESTIB.PROMOCAO_INSCRICAO.CODDESCPROMOCAO%TYPE;
    ALUNO     DBSIAF.ALUNO.COD_ALUNO%TYPE;
    MATRICULA DBSIAF.ALUNO.NUM_MATRICULA%TYPE;
    EXISTE    NUMBER;

    CURSOR C_PROMOCAO IS
        SELECT PRI.CODCONC,
               PRI.CODINSC,
               PRI.CODDESCPROMOCAO,
               PRI.CODDESCONTO,
               DES.INDTPODESCONTO,
               DES.CODTPODESCPROMOCAO,
               PRI.NUMMATRICULA,
               PRI.NOMFUNCIONARIO,
               PRI.CODALUNO,
               PRI.CODFUNCIONARIO
          FROM DBVESTIB.PROMOCAO_INSCRICAO PRI,
               DBVESTIB.DESCONTO_PROMOCAO  DES
         WHERE PRI.CODCONC = DES.CODCONC
               AND PRI.CODDESCPROMOCAO = DES.CODDESCPROMOCAO
               AND PRI.NUMMATRICULA IS NOT NULL
               AND DES.CODTPODESCPROMOCAO = 4
               and length (pri.nummatricula)<= 10/*
               and pri.nummatricula = '31218373'*/;
    /* AND PRI.CODCONC = '1288'
    AND PRI.NUMMATRICULA = '41211406'*/

    CURSOR C_ALUNO IS
        SELECT ALU.COD_ALUNO,
               ALU.NOM_ALUNO,
               ALU.NUM_MATRICULA,
               VES.CODINSTITUICAO,
               TUR.DSC_TURNO,
               CUR.NOM_CURSO,
               CAM.NOM_CAMPUS
          FROM DBSIAF.ALUNO                ALU,
               DBSIAF.INSTITUICAO_ENSINO   IES,
               DBSIAF.GRADE_CURRICULAR     GR,
               DBSIAF.TURNO                TUR,
               DBSIAF.CURSO                CUR,
               DBSIAF.CAMPUS               CAM,
               DBVESTIB.INSTITUICAO_ENSINO VES
         WHERE ALU.NUM_MATRICULA = MATRICULA --ALU.COD_ALUNO = ALUNO
               AND GR.COD_GRD_CURRICULAR = ALU.COD_GRD_CURRICULAR
               AND GR.COD_INSTITUICAO = IES.COD_INSTITUICAO
               AND ALU.COD_TURNO = TUR.COD_TURNO
               AND ALU.COD_CURSO = CUR.COD_CURSO
               AND ALU.COD_CAMPUS = CAM.COD_CAMPUS
               AND VES.COD_INSTITUICAO_SIAF = IES.COD_INSTITUICAO;

BEGIN
    FOR R_PROMOCAO IN C_PROMOCAO LOOP
        EXISTE    := 0;
        MATRICULA := (R_PROMOCAO.NUMMATRICULA);
        -- VERIFICA SE O NUMMATRICULA É DE ALUNO       
        /*BEGIN
            SELECT ALU.COD_ALUNO
              INTO ALUNO
              FROM DBSIAF.ALUNO ALU
             WHERE ALU.NUM_MATRICULA = trim(MATRICULA);
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
            when others then
              raise_application_error (-20500, 'erro'+ matricula);    
        END;*/
    

            -- VERDADEIRO COD_DESCONTO_PROMOÇÃO ALUNO  
            SELECT DES.CODDESCPROMOCAO
              INTO DESCONTO
              FROM DBVESTIB.DESCONTO_PROMOCAO DES
             WHERE DES.CODCONC = R_PROMOCAO.CODCONC
                   AND DES.CODTPODESCPROMOCAO = 3;
                   
            FOR R_ALUNO IN C_ALUNO LOOP
                BEGIN
                    SELECT 1
                      INTO EXISTE
                      FROM DBVESTIB.ALUNO_INSTITUICAO AL
                     WHERE AL.CODALUNO = R_ALUNO.COD_ALUNO;
                
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        INSERT INTO DBVESTIB.ALUNO_INSTITUICAO
                            (CODALUNO,
                             CODINSTITUICAO,
                             NUMMATRICULA,
                             NOMALUNO,
                             NOMTURNO,
                             NOMCURSO,
                             NOMCAMPUS)
                        VALUES
                            (R_ALUNO.COD_ALUNO,
                             R_ALUNO.CODINSTITUICAO,
                             R_ALUNO.NUM_MATRICULA,
                             R_ALUNO.NOM_ALUNO,
                             R_ALUNO.DSC_TURNO,
                             R_ALUNO.NOM_CURSO,
                             R_ALUNO.NOM_CAMPUS);
                             COMMIT;                         
                END;
            
                -- CORRIGIR OS DADOS DA PROMOAO_INSCRICAO
            BEGIN
                UPDATE DBVESTIB.PROMOCAO_INSCRICAO PRO
                   SET PRO.CODDESCPROMOCAO = DESCONTO,
                       PRO.CODALUNO        = R_ALUNO.COD_ALUNO
                 WHERE PRO.CODCONC = R_PROMOCAO.CODCONC
                       AND PRO.CODINSC = R_PROMOCAO.CODINSC
                       AND PRO.NUMMATRICULA = R_PROMOCAO.NUMMATRICULA;
                 EXCEPTION
                   WHEN OTHERS THEN
                     NULL;  
                  END;
              COMMIT;           
            END LOOP;
    END LOOP;
END;


0
0
