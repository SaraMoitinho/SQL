CREATE OR REPLACE TRIGGER DBVESTIB.TBUID_RCANDCURTUROPC                                                   
BEFORE INSERT OR UPDATE OR DELETE ON DBVESTIB.RCANDCURTUROPC                                             
FOR EACH ROW                                                                                              
declare                                                                                                   
	V_IDT_OPERACAO 		CHAR(1);     
  nValida           NUMBER;                                                                           
begin                                                                                                     
	-- =========================================================================                             
        -- LOG                                                                                            
	-- =========================================================================     

	IF INSERTING THEN V_IDT_OPERACAO := 'I';                                                                 
	ELSIF UPDATING THEN V_IDT_OPERACAO := 'U';                                                               
	ELSIF DELETING THEN V_IDT_OPERACAO := 'D';                                                               
	END IF;                                                                                                  
                                                                                                        
	IF INSERTING OR UPDATING THEN                                                                            
		:NEW.DAT_OPERACAO_LOG := sysdate;                                                                       
		:NEW.COD_USUARIO_LOG  :=  DBSIAF.F_BUSCA_FUNCIONARIO(user);                                             
                                                                                                          
		INSERT INTO DBVESTIB.RCANDCURTUROPC_LOG(                                                                
                      CODCONC,                                                                            
                      CODCAN,                                                                             
                      CODCUR,     
                      CODCAM,                                                                        
                      CODTUR,                                                                             
                      OPCLIN,                                                                             
                      NROOPC,     
                      CODINSTITUICAO,
                      INDPRINCIPAL,   
                      INDFORMACAOAMPLIADA,  
                      INDPROUNI,
                      INDFIES,        
                      IND_DESEJA_PROUNI,
                      IND_DESEJA_FIES,                                                                                
                      COD_USUARIO_LOG,                                                                    
                      DAT_OPERACAO_LOG,                                                                   
                      IDT_OPERACAO_LOG)                                                                   
              VALUES(                                                                                     
                      :NEW.CODCONC,                                                                       
                      :NEW.CODCAN,                                                                        
                      :NEW.CODCUR,   
                      :NEW.CODCAM,                                                                     
                      :NEW.CODTUR,                                                                        
                      :NEW.OPCLIN,                                                                        
                      :NEW.NROOPC, 
                      :NEW.CODINSTITUICAO, 
                      :NEW.INDPRINCIPAL,  
                      :NEW.INDFORMACAOAMPLIADA, 
                      :NEW.INDPROUNI,         
                      :NEW.INDFIES,       
                      :NEW.IND_DESEJA_PROUNI,
                      :NEW.IND_DESEJA_FIES,                                                                         
                      :NEW.COD_USUARIO_LOG,                                                               
                      :NEW.DAT_OPERACAO_LOG,                                                              
                      V_IDT_OPERACAO                                                                      
              );                                                                                          
        END IF;                                                                                           
                                                                                                          
        IF DELETING THEN                                                                                  
      		INSERT INTO DBVESTIB.RCANDCURTUROPC_LOG(                                                          
                      CODCONC,                                                                            
                      CODCAN,                                                                             
                      CODCUR,  
                      CODCAM,                                                                           
                      CODTUR,                                                                             
                      OPCLIN,                                                                             
                      NROOPC,    
                      CODINSTITUICAO, 
                      INDPRINCIPAL,        
                      INDFORMACAOAMPLIADA,  
                      INDPROUNI,     
                      INDFIES,  
                      IND_DESEJA_PROUNI,
                      IND_DESEJA_FIES,                                                                             
                      COD_USUARIO_LOG,                                                                    
                      DAT_OPERACAO_LOG,                                                                   
                      IDT_OPERACAO_LOG)                                                                   
          VALUES(                                                                                         
                      :OLD.CODCONC,                                                                       
                      :OLD.CODCAN,                                                                        
                      :OLD.CODCUR,
                      :OLD.CODCAM,                                                                        
                      :OLD.CODTUR,                                                                        
                      :OLD.OPCLIN,                                                                        
                      :OLD.NROOPC,   
                      :OLD.CODINSTITUICAO,    
                      :OLD.INDPRINCIPAL, 
                      :OLD.INDFORMACAOAMPLIADA,      
                      :OLD.INDPROUNI,    
                      :OLD.INDFIES,     
                      :OLD.IND_DESEJA_PROUNI,
                      :OLD.IND_DESEJA_FIES,                                                                       
                      DBSIAF.F_BUSCA_FUNCIONARIO(user),                                                   
                      sysdate,                                                                            
                      V_IDT_OPERACAO                                                                      
                    );                                                                                    
	END IF;  

  
  IF UPDATING THEN
   
    SELECT COUNT(*)
    INTO nValida
    FROM DBVESTIB.CONCURSO CON
    WHERE CON.COD_TPO_CONCURSO = 8
          AND CON.CODCONC = :NEW.CODCONC
          AND EXISTS(
              SELECT 1
              FROM DBVESTIB.INSCRICAO_FIAT IFI
              WHERE IFI.CODCONC = :NEW.CODCONC
                    AND IFI.CODINSC = :NEW.CODCAN
          );
          
    IF nValida > 0 THEN
      UPDATE DBVESTIB.OPCAOCANDIDATO
      SET 
          CODCUR = :NEW.CODCUR,
          CODTUR = :NEW.CODTUR
      WHERE CODCONC = :NEW.CODCONC
            AND CODINSC = :NEW.CODCAN
            AND NROOPC = :NEW.NROOPC;
    END IF;
    
  -- Verificando formacao ampliada na alteracao da formacao ampliada
  
    IF (:NEW.INDFORMACAOAMPLIADA = 'S') 
    AND 
       (:NEW.CODCUR <> :OLD.CODCUR OR
        :NEW.CODCAM <> :OLD.CODCAM OR
        :NEW.CODTUR <> :OLD.CODTUR) THEN
    
        SELECT COUNT(*)
        INTO nValida
        FROM DBVESTIB.RCURTUR RCO
        WHERE 
            (:NEW.CODCUR = RCO.CODCUR AND
             :NEW.CODCAM = RCO.CODCAM AND
             :NEW.CODTUR = RCO.CODTUR and
             :NEW.CODCONC = RCO.CODCONC) AND RCO.INDFORMACAOAMPLIADA = 'S';
         
        IF nValida = 0 THEN
          :NEW.INDFORMACAOAMPLIADA := 'N';       
        END IF;

    END IF;

  END IF;
  
  -- ATUALIZANDO OPCAO DE CURSO DA INSCRICAO
  BEGIN
  	IF UPDATING THEN 
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao := DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao + 1;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCONC := :NEW.CODCONC;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCAN := :NEW.CODCAN;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :NEW.NROOPC;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao_old(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :OLD.NROOPC;       
    ELSIF INSERTING THEN
        SELECT COUNT(*)
        INTO nValida
        FROM DBVESTIB.OPCAOCANDIDATO OPC
        WHERE OPC.CODCONC = :NEW.CODCONC
              AND OPC.CODINSC = :NEW.CODCAN
              AND OPC.NROOPC = :NEW.NROOPC;
        IF nValida = 0 THEN
          DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao := DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao + 1;
          DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCONC := :NEW.CODCONC;
          DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCAN := :NEW.CODCAN;
          DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :NEW.NROOPC;
          DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao_old(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :NEW.NROOPC;
        END IF;
    ELSIF DELETING THEN 
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao := DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao + 1;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCONC := :OLD.CODCONC;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).CODCAN := :OLD.CODCAN;
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :OLD.NROOPC;        
        DBVESTIB.PC_INSCRICAO_MUT_TBL.vOpcao_old(DBVESTIB.PC_INSCRICAO_MUT_TBL.vNumLinhasOpcao).NROOPC := :OLD.NROOPC;
    END IF;                                                   
  EXCEPTION
           WHEN OTHERS THEN
                NULL;
  END;
                                                                                                    
exception                                                                                                 
  when OTHERS then                                                                                        
    raise_application_error( -20500, SQLERRM );                                                           
end TBUID_RCANDCURTUROPC;
/
