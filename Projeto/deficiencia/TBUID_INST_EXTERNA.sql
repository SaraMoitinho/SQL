CREATE OR REPLACE TRIGGER "DBVESTIB"."TBUID_INST_EXTERNA" 
BEFORE INSERT OR UPDATE OR DELETE ON DBVESTIB.INSCRICAO_INST_EXTERNA                                                 
FOR EACH ROW                                                                                              
DECLARE
	V_IDT_OPERACAO CHAR(1);
BEGIN
	-- =========================================================================                             
	-- LOG                                                                                            
	-- =========================================================================                             
	IF INSERTING THEN
		V_IDT_OPERACAO := 'I';
	ELSIF UPDATING THEN
		V_IDT_OPERACAO := 'U';
	ELSIF DELETING THEN
		V_IDT_OPERACAO := 'D';
	END IF;

	IF INSERTING
	   OR UPDATING THEN
		:NEW.DAT_OPERACAO_LOG := SYSDATE;
		:NEW.COD_USUARIO_LOG  := DBSIAF.F_BUSCA_FUNCIONARIO(USER);
	
		INSERT INTO DBVESTIB.INSCRICAO_INST_EXTERNA_LOG
			(CODCONC,
			 CODINSC,
			 COD_INSTIT_EXTERNA,
			 COD_USUARIO_LOG,
			 DAT_OPERACAO_LOG,
			 IDT_OPERACAO_LOG)
		
		VALUES
			(:NEW.CODCONC,
			 :NEW.CODINSC,
			 :NEW.COD_INSTIT_EXTERNA,
			 :NEW.COD_USUARIO_LOG,
			 :NEW.DAT_OPERACAO_LOG,
			 V_IDT_OPERACAO);
	END IF;

	IF DELETING THEN
		INSERT INTO DBVESTIB.INSCRICAO_INST_EXTERNA_LOG
			(CODCONC,
			 CODINSC,
			 COD_INSTIT_EXTERNA,
			 COD_USUARIO_LOG,
			 DAT_OPERACAO_LOG,
			 IDT_OPERACAO_LOG)
		VALUES
			(:OLD.CODCONC,
			 :OLD.CODINSC,
			 :OLD.COD_INSTIT_EXTERNA,
			 DBSIAF.F_BUSCA_FUNCIONARIO(USER),
			 SYSDATE,
			 V_IDT_OPERACAO);
	END IF;

EXCEPTION
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20500,
								SQLERRM);
END TBUID_CAMPUS;
/
