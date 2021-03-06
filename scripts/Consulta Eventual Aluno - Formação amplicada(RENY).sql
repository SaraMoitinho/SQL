SELECT C.NOM_CURSO,
       A.NOM_ALUNO,
       NC.DSC_NIV_CURSO,
       A.NUM_MATRICULA,
       S.DSC_STA_ALUNO,
       FA.DAT_CADASTRO,
       FA.DAT_CANCELAMENTO,
       (SELECT MAX(AIN.PER_HISTORICO_OB)
          FROM DBSIAF.ALUNO_INTEGRALIZACAO AIN
         WHERE AIN.COD_ALUNO = A.COD_ALUNO
         ) "% Integralização histórico",
         
        (SELECT MAX( AIN.PER_diario_OB)
          FROM DBSIAF.ALUNO_INTEGRALIZACAO AIN
         WHERE AIN.COD_ALUNO = A.COD_ALUNO)"% diário Integralização",

       (SELECT PRL.SGL_PERIODO_LETIVO
          FROM DBSIAF.PERIODO_LETIVO PRL, DBSIAF.ALUNO_INTEGRALIZACAO ALI
        
         WHERE PRL.COD_PERIODO_LETIVO = ALI.COD_PERIODO_LETIVO
           AND ALI.COD_ALUNO = A.COD_ALUNO
           AND PRL.DAT_FIM_PERIODO =
               (SELECT MAX(PRL1.DAT_FIM_PERIODO)
                  FROM DBSIAF.ALUNO_INTEGRALIZACAO ALI1,
                       DBSIAF.PERIODO_LETIVO       PRL1
                 WHERE ALI1.COD_ALUNO = A.COD_ALUNO
                   AND PRL1.DAT_FIM_PERIODO is not null
                   AND ALI1.COD_PERIODO_LETIVO = PRL1.COD_PERIODO_LETIVO)
           AND ROWNUM = 1) "Periodo Letivo Integralização",
       
       (SELECT C1.NOM_CURSO
          FROM DBSIAF.ALUNO A1, DBSIAF.CURSO C1, DBSIAF.CAMPUS CA
         WHERE A1.NUM_CPF = A.NUM_CPF
           AND A1.COD_ALUNO <> A.COD_ALUNO
           AND A1.DAT_ENTRADA > A.DAT_ENTRADA
           AND A1.COD_CURSO = C1.COD_CURSO
           AND C1.COD_NIV_CURSO = 2
           AND CA.COD_INSTITUICAO = CP.COD_INSTITUICAO
           AND ROWNUM = 1) "Ultimo Curso Pós ",
       P.SGL_PERIODO_LETIVO "Periodo Formatura",
       TS.DSC_TPO_SAIDA "Tipo de Saida",
       A.DAT_SAIDA "Data de Saida"
  FROM DBSIAF.FORMACAO_AMPLIADA FA,
       DBSIAF.ALUNO             A,
       DBSIAF.CURSO             C,
       DBSIAF.STATUS_ALUNO      S,
       DBSIAF.CAMPUS            CP,
       DBSIAF.NIVEL_CURSO       NC,
       DBSIAF.PERIODO_LETIVO    P,
       DBSIAF.TIPO_SAIDA        TS
 WHERE FA.COD_ALUNO = A.COD_ALUNO
   AND A.COD_CURSO = C.COD_CURSO
   AND A.COD_STA_ALUNO = S.COD_STA_ALUNO
   AND A.COD_CAMPUS = CP.COD_CAMPUS
   AND CP.COD_INSTITUICAO = &P_COD_INSTITUICAO
   AND C.COD_NIV_CURSO = NC.COD_NIV_CURSO
   AND A.COD_PERIODO_FORMATURA = P.COD_PERIODO_LETIVO(+)
   AND A.COD_TPO_SAIDA = TS.COD_TPO_SAIDA(+)
   AND   A.num_matricula = '31215380'
 ORDER BY C.NOM_CURSO, A.NOM_ALUNO
  
