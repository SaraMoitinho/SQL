CREATE OR REPLACE PROCEDURE dbvestib.SP_ATUALIZA_OPCOES_CANDIDATO(
  P_CODCONC DBVESTIB.CANDIDATO.CODCONC%TYPE,
  P_CODCAN DBVESTIB.CANDIDATO.CODCAN%TYPE,
  P_NROOPC DBVESTIB.RCANDCURTUROPC.NROOPC%TYPE,
  P_IDT_ACAO CHAR  ) IS

  CURSOR C_OPCAO IS      
  SELECT *
  FROM DBVESTIB.OPCAOCANDIDATO 
  WHERE CODCONC = P_CODCONC
       AND CODINSC = P_CODCAN
       AND NROOPC = P_NROOPC;  
BEGIN
     IF P_IDT_ACAO = 'D' THEN
        DELETE FROM DBVESTIB.RCANDCURTUROPC 
        WHERE CODCONC = P_CODCONC
             AND CODCAN = P_CODCAN
             AND NROOPC = P_NROOPC;
     ELSE
         FOR R_OPCAO IN C_OPCAO LOOP
             IF P_IDT_ACAO = 'I' THEN
                INSERT INTO DBVESTIB.RCANDCURTUROPC(CODCONC,CODCAN,NROOPC,CODCUR,CODTUR,OPCLIN,CODCAM,CODINSTITUICAO,INDPRINCIPAL,INDFORMACAOAMPLIADA, INDPROUNI,INDFIES, IND_DESEJA_PROUNI,IND_DESEJA_FIES)
                VALUES(
                       R_OPCAO.CODCONC,
                       R_OPCAO.CODINSC,
                       R_OPCAO.NROOPC,
                       R_OPCAO.CODCUR,
                       R_OPCAO.CODTUR,
                       R_OPCAO.OPCLIN,
                       R_OPCAO.CODCAM,
                       R_OPCAO.CODINSTITUICAO,
                       R_OPCAO.INDPRINCIPAL,
                       R_OPCAO.INDFORMACAOAMPLIADA,
                       R_OPCAO.INDPROUNI,
                       R_OPCAO.INDFIES,
                       R_OPCAO.IND_DESEJA_PROUNI,
                       R_OPCAO.IND_DESEJA_FIES);                
             ELSIF P_IDT_ACAO = 'U' THEN
                   UPDATE DBVESTIB.RCANDCURTUROPC
                   SET 
                       CODCUR = R_OPCAO.CODCUR,
                       CODTUR = R_OPCAO.CODTUR,
                       OPCLIN = R_OPCAO.OPCLIN,
                       CODCAM = R_OPCAO.CODCAM,
                       CODINSTITUICAO = R_OPCAO.CODINSTITUICAO,
                       INDPRINCIPAL = R_OPCAO.INDPRINCIPAL,
                       INDFORMACAOAMPLIADA = R_OPCAO.INDFORMACAOAMPLIADA,
                       INDPROUNI = R_OPCAO.INDPROUNI,
                       INDFIES = R_OPCAO.INDFIES,
                       IND_DESEJA_PROUNI = R_OPCAO.IND_DESEJA_PROUNI,
                       IND_DESEJA_FIES = R_OPCAO.IND_DESEJA_FIES
                   WHERE CODCONC = R_OPCAO.CODCONC
                         AND CODCAN = R_OPCAO.CODINSC
                         AND NROOPC = R_OPCAO.NROOPC;                   
             END IF;
         END LOOP;
     END IF;     
EXCEPTION
         WHEN OTHERS THEN
              NULL;
END;
/
