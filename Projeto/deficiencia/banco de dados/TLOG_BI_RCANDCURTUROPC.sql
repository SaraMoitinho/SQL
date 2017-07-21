CREATE OR REPLACE TRIGGER DBVESTIB.TLOG_BI_RCANDCURTUROPC
AFTER DELETE OR UPDATE OR INSERT ON DBVESTIB.RCANDCURTUROPC
REFERENCING OLD AS OLD NEW AS NEW  FOR EACH ROW
DECLARE
  V_IDT_OPERACAO     CHAR(1);
  V_COD_USUARIO_LOG  NUMBER(10);
  V_DAT_OPERACAO_LOG DATE;
BEGIN
  IF INSERTING THEN
    V_IDT_OPERACAO := 'I';
  ELSIF UPDATING THEN
    V_IDT_OPERACAO := 'U';
  ELSIF DELETING THEN
    V_IDT_OPERACAO := 'D';
  END IF;
  V_COD_USUARIO_LOG  := DBSIAF.F_BUSCA_FUNCIONARIO(user);
  V_DAT_OPERACAO_LOG := SYSDATE;
  IF INSERTING OR UPDATING THEN
    INSERT INTO DBVESTIB.RCANDCURTUROPC_LOG_BI
      (COD_LOG_BI,
       CODCONC,
       CODCAN,
       CODCUR,
       CODTUR,
       OPCLIN,
       NROOPC,
       CODCAM,
       CODINSTITUICAO,
       INDPRINCIPAL,
       INDFORMACAOAMPLIADA,
       INDPROUNI,
       INDFIES,
       IND_DESEJA_PROUNI,
       IND_DESEJA_FIES,
       IDT_OPERACAO_LOG,
       COD_USUARIO_LOG,
       DAT_OPERACAO_LOG)
    VALUES
      (DBVESTIB.RCANDCURTUROPC_LOG_BI_S.NextVal,
       :NEW.CODCONC,
       :NEW.CODCAN,
       :NEW.CODCUR,
       :NEW.CODTUR,
       :NEW.OPCLIN,
       :NEW.NROOPC,
       :NEW.CODCAM,
       :NEW.CODINSTITUICAO,
       :NEW.INDPRINCIPAL,
       :NEW.INDFORMACAOAMPLIADA,
       :NEW.INDPROUNI,
       :NEW.INDFIES,
       :NEW.IND_DESEJA_PROUNI,
       :NEW.IND_DESEJA_FIES,
       V_IDT_OPERACAO,
       V_COD_USUARIO_LOG,
       V_DAT_OPERACAO_LOG);
  ELSE
    INSERT INTO DBVESTIB.RCANDCURTUROPC_LOG_BI
      (COD_LOG_BI,
       CODCONC,
       CODCAN,
       CODCUR,
       CODTUR,
       OPCLIN,
       NROOPC,
       CODCAM,
       CODINSTITUICAO,
       INDPRINCIPAL,
       INDFORMACAOAMPLIADA,
       INDPROUNI,
       INDFIES,
       IND_DESEJA_PROUNI,
       IND_DESEJA_FIES,
       IDT_OPERACAO_LOG,
       COD_USUARIO_LOG,
       DAT_OPERACAO_LOG)
    VALUES
      (DBVESTIB.RCANDCURTUROPC_LOG_BI_S.NextVal,
       :OLD.CODCONC,
       :OLD.CODCAN,
       :OLD.CODCUR,
       :OLD.CODTUR,
       :OLD.OPCLIN,
       :OLD.NROOPC,
       :OLD.CODCAM,
       :OLD.CODINSTITUICAO,
       :OLD.INDPRINCIPAL,
       :OLD.INDFORMACAOAMPLIADA,
       :OLD.INDPROUNI,
       :OLD.INDFIES,
       :OLD.IND_DESEJA_PROUNI,
       :OLD.IND_DESEJA_FIES,
       V_IDT_OPERACAO,
       V_COD_USUARIO_LOG,
       V_DAT_OPERACAO_LOG);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20500, SQLERRM);
END TLOG_BI_RCANDCURTUROPC;
/
