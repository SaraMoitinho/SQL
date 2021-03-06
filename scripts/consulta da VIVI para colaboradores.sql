SELECT INS.CODCONC "CONCURSO",
       INS.CODINSC,
       UPPER(INS.NOMCAN) "CANDIDATO",
       INS.CPFCAN,
       BAS.NOM_FUNCIONARIO "COLABORADOR",
       BAS.CPF_FUNCIONARIO,
       BAS.NUM_MATRICULA,
       BAS.NUM_MATRICULA_BUILDUP,
       BAS.DSC_SETOR_ORIGINAL "SETOR COLABORADOR",
       MIN(PRI.DAT_OPERACAO_LOG) "DATA DA INDICACAO",     
       INS.DATINSCAN "DATA DA INSCRICAO",
       INS.TELCAN "TELEFONE",
       INS.CELCAN "CELULAR",
       CUR.NOMCUR "CURSO",
       TUR.DSCTUR "TURNO",
       CAM.NOMCAM "CAMPUS",    
       IES.SGLINSTITUICAO "INSTITUICAO",
       DECODE(INS.COD_STATUS_INSCRICAO,
              1,
              'N�O PAGA',
              2,
              'PAGA',
              'INCOMPLETA') STATUS,
              INS.DATPGTO "DATA PAGAMENTO INSCRICAO",
                  
    (SELECT 
      ASS.DAT_ASSINATURA
    FROM
      DBSIAF.ALUNO AL,
      DBSIAF.ASS_CONTRATO ASS
    WHERE
      AL.CODCONC = INS.CODCONC
      AND AL.CODCAN = INS.CODINSC
      AND AL.COD_STA_ALUNO = 1
      AND ASS.COD_ASS_CONTRATO =  (SELECT MIN(ASS1.COD_ASS_CONTRATO)
       FROM
       DBSIAF.ASS_CONTRATO ASS1
       WHERE 
          ASS1.COD_ALUNO = AL.COD_ALUNO
          AND ASS1.IND_LIBERADO <> 'C')
        ) "DATA DE ASSINATURA DO CONTRATO"   
       
  FROM DBVESTIB.PROMOCAO_INSCRICAO      PRI
       JOIN DBVESTIB.INSCRICAO          INS  ON PRI.CODCONC = INS.CODCONC AND PRI.CODINSC = INS.CODINSC
       JOIN DBVESTIB.OPCAOCANDIDATO     OPC1 ON INS.CODCONC = OPC1.CODCONC AND INS.CODINSC = OPC1.CODINSC 
       JOIN DBSIAF.BASE_FUNCIONARIO     BAS  ON PRI.CODFUNCIONARIO = BAS.COD_FUNCIONARIO
       JOIN DBVESTIB.CURSO              CUR  ON OPC1.CODCUR = CUR.CODCUR AND CUR.CODCONC = INS.CODCONC
       JOIN DBVESTIB.TURNO              TUR  ON OPC1.CODTUR = TUR.CODTUR
       JOIN DBVESTIB.CAMPUS             CAM  ON OPC1.CODCAM = CAM.CODCAM 
       LEFT JOIN DBSIAF.ALUNO           AL   ON INS.CODCONC = AL.CODCONC AND INS.CODINSC = AL.CODCAN
       JOIN DBVESTIB.INSTITUICAO_ENSINO IES ON IES.CODINSTITUICAO = CAM.CODINSTITUICAO
     
 WHERE PRI.CODCONC = :CODCONC
       AND :P_CODTPORELATORIO = 2
       AND OPC1.NROOPC = 1
       AND PRI.CODFUNCIONARIO IS NOT NULL
       AND BAS.IND_ATIVO = 'S'
       AND INS.COD_STATUS_INSCRICAO = NVL( :P_COD_STATUS_INSCRICAO, INS.COD_STATUS_INSCRICAO)
 GROUP BY
       INS.CODINSC,
       INS.NOMCAN,
       INS.CPFCAN,
       BAS.NOM_FUNCIONARIO,
       BAS.CPF_FUNCIONARIO,
       BAS.NUM_MATRICULA,
       BAS.NUM_MATRICULA_BUILDUP,
       INS.DATINSCAN,
       INS.TELCAN,
       INS.CELCAN,
       CUR.NOMCUR,
       TUR.DSCTUR,
       CAM.NOMCAM,
       IES.SGLINSTITUICAO,
       INS.COD_STATUS_INSCRICAO,
       INS.DATPGTO,
       INS.CODCONC,
       BAS.DSC_SETOR_ORIGINAL 
UNION ALL
SELECT INS.CODCONC "CONCURSO",
       INS.CODINSC,
       UPPER(INS.NOMCAN) "CANDIDATO",
       INS.CPFCAN,
       BAS.NOM_FUNCIONARIO "COLABORADOR",
       BAS.CPF_FUNCIONARIO,
       BAS.NUM_MATRICULA,
       BAS.NUM_MATRICULA_BUILDUP,
       BAS.DSC_SETOR_ORIGINAL "SETOR COLABORADOR",
       MIN(PRI.DAT_OPERACAO_LOG) "DATA DA INDICACAO",     
       INS.DATINSCAN "DATA DA INSCRICAO",
       INS.TELCAN "TELEFONE",
       INS.CELCAN "CELULAR",
       CUR.NOMCUR "CURSO",
       TUR.DSCTUR "TURNO",
       CAM.NOMCAM "CAMPUS",    
       IES.SGLINSTITUICAO "INSTITUICAO",
       DECODE(INS.COD_STATUS_INSCRICAO,
              1,
              'N�O PAGA',
              2,
              'PAGA',
              'INCOMPLETA') STATUS,
              INS.DATPGTO "DATA PAGAMENTO INSCRICAO",
                  
    (SELECT 
      ASS.DAT_ASSINATURA
    FROM
      DBSIAF.ALUNO AL,
      DBSIAF.ASS_CONTRATO ASS
    WHERE
      AL.CODCONC = INS.CODCONC
      AND AL.CODCAN = INS.CODINSC
      AND AL.COD_STA_ALUNO = 1
      AND ASS.COD_ASS_CONTRATO =  (SELECT MIN(ASS1.COD_ASS_CONTRATO)
       FROM
       DBSIAF.ASS_CONTRATO ASS1
       WHERE 
          ASS1.COD_ALUNO = AL.COD_ALUNO
          AND ASS1.IND_LIBERADO <> 'C')
        ) "DATA DE ASSINATURA DO CONTRATO"   
       
  FROM DBVESTIB.PROMOCAO_INSCRICAO      PRI
       JOIN DBVESTIB.INSCRICAO          INS  ON PRI.CODCONC = INS.CODCONC AND PRI.CODINSC = INS.CODINSC
       JOIN DBVESTIB.OPCAOCANDIDATO     OPC1 ON INS.CODCONC = OPC1.CODCONC AND INS.CODINSC = OPC1.CODINSC 
       JOIN DBSIAF.BASE_FUNCIONARIO     BAS  ON PRI.CODFUNCIONARIO = BAS.COD_FUNCIONARIO
       JOIN DBVESTIB.CURSO              CUR  ON OPC1.CODCUR = CUR.CODCUR AND CUR.CODCONC = INS.CODCONC
       JOIN DBVESTIB.TURNO              TUR  ON OPC1.CODTUR = TUR.CODTUR
       JOIN DBVESTIB.CAMPUS             CAM  ON OPC1.CODCAM = CAM.CODCAM 
       LEFT JOIN DBSIAF.ALUNO           AL   ON INS.CODCONC = AL.CODCONC AND INS.CODINSC = AL.CODCAN
       JOIN DBVESTIB.CONCURSO CON ON CON.CODCONC = PRI.CODCONC
       JOIN DBVESTIB.INSTITUICAO_ENSINO IES ON IES.CODINSTITUICAO = CAM.CODINSTITUICAO

     
 WHERE OPC1.NROOPC = 1
       AND PRI.CODFUNCIONARIO IS NOT NULL
       AND BAS.IND_ATIVO = 'S'
       AND INS.COD_STATUS_INSCRICAO = NVL( :P_COD_STATUS_INSCRICAO, INS.COD_STATUS_INSCRICAO)
        AND :P_CODTPORELATORIO = 1
       AND EXISTS (SELECT 1
          FROM DBVESTIB.CONCURSO CON1
         WHERE CON.ANOCONC = CON1.ANOCONC
               AND CON.SEMCONC = CON1.SEMCONC
               AND CON1.CODCONC = :CODCONC
               AND CON1.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO)
 GROUP BY
       INS.CODINSC,
       INS.NOMCAN,
       INS.CPFCAN,
       BAS.NOM_FUNCIONARIO,
       BAS.CPF_FUNCIONARIO,
       BAS.NUM_MATRICULA,
       BAS.NUM_MATRICULA_BUILDUP,
       INS.DATINSCAN,
       INS.TELCAN,
       INS.CELCAN,
       CUR.NOMCUR,
       TUR.DSCTUR,
       CAM.NOMCAM,
       IES.SGLINSTITUICAO,
       INS.COD_STATUS_INSCRICAO,
       INS.DATPGTO,
       INS.CODCONC,
       BAS.DSC_SETOR_ORIGINAL           
ORDER BY CONCURSO, CANDIDATO
