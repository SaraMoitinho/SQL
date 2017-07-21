DECLARE

    V_TEL_END        DBSIAF.END_ALUNO.TEL_ENDERECO%TYPE;
    V_TEL_CEL        DBSIAF.END_ALUNO.TEL_ENDERECO%TYPE;
    V_TELCAND        DBSIAF.END_ALUNO.TEL_ENDERECO%TYPE;
    V_TEL2           DBSIAF.END_ALUNO.TEL_ENDERECO%TYPE;
    V_TEL            DBSIAF.END_ALUNO.TEL_ENDERECO%TYPE;   
    REG_ALUNOS       DBSIAF.ALUNO.COD_ALUNO%TYPE;
    REG_CANDIDATO    DBVESTIB.CANDIDATO.CODCAN%TYPE;
    V_TELCAN         DBVESTIB.CANDIDATO.TELCAN%TYPE;
    V_CELCAN         DBVESTIB.CANDIDATO.CELCAN%TYPE;
    V_COD_CIDADE     DBSIAF.END_ALUNO.COD_CIDADE%TYPE;
     V_COD_ESTADO    DBSIAF.ESTADO.COD_ESTADO%TYPE;
     V_CODCAN        DBVESTIB.CANDIDATO.CODCAN%TYPE;
    
    
    CURSOR C_ALUNOS IS
      SELECT ALU.COD_ALUNO, 
             ALU.TEL_CELULAR,
             ENA.TEL_ENDERECO, 
             ENA.COD_CIDADE, 
             ALU.CODCAN                    
        FROM DBSIAF.ALUNO ALU,
             DBSIAF.END_ALUNO ENA
       WHERE ENA.COD_ALUNO = ALU.COD_ALUNO
         AND ENA.COD_TPO_ENDERECO = 1;
    
    


    CURSOR C_INSCRICAO IS
      SELECT INS.CODINSC,
             INS.TELCAN,
             INS.CELCAN, 
             INS.CODCIDADE
        FROM DBVESTIB.INSCRICAO INS;
        
        
        
      CURSOR C_CANDIDATO IS
      SELECT CAN.CODCAN,
             CAN.TELCAN,
             CAN.CELCAN, 
             CAN.CODCIDADENAT
        FROM DBVESTIB.CANDIDATO CAN;
         
    
BEGIN
 /*  DBSIAF.PC_MUTANTE_TABLE.SP_INSERE('TEL', 'FORMATA', 'S');
  -- usando ALUNOS
  
   FOR R_ALUNOS IN C_ALUNOS LOOP
	     REG_ALUNOS := R_ALUNOS.COD_ALUNO;
         V_TEL_END:= R_ALUNOS.TEL_ENDERECO;
         V_TEL_CEL := R_ALUNOS.TEL_CELULAR; 
         V_COD_CIDADE := R_ALUNOS.COD_CIDADE;
/*
  --  VERIFICAR O TELEFONE ENDEREÇO

    IF V_TEL_END IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_TEL_END), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
           V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
          
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST
         WHERE CID.COD_CIDADE =  V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
          
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' + V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;
    
     IF V_TEL IS NOT NULL THEN     
     UPDATE DBSIAF.END_ALUNO ENA
           SET ENA.TEL_ENDERECO = V_TEL
         WHERE ENA.COD_ALUNO = REG_ALUNOS
               AND ENA.COD_TPO_ENDERECO = 1;
         COMMIT;
      END IF;
    END IF;
    
    IF V_TEL_CEL IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_TEL_CEL), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
         V_TEL2 := SUBSTR(V_TEL, 0, 1);
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
            
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST               
         WHERE CID.COD_CIDADE = V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
           
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' + V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' + V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' + V_TEL;
            END IF;
        END IF;
        
   IF V_TEL IS NOT NULL THEN
     
     UPDATE DBSIAF.ALUNO ALU
           SET ALU.TEL_CELULAR = V_CELCAN
         WHERE ALU.COD_ALUNO = REG_ALUNOS;
         
         COMMIT;
   END IF;
      

 END IF;
 END LOOP;


  /*DBSIAF.PC_MUTANTE_TABLE.SP_LIMPA_TEMPORARIA('TEL', 'FORMATA');        

 -- USANDO CANDIDATO

 FOR R_CANDIDATO IN C_CANDIDATO LOOP
	     REG_CANDIDATO := R_CANDIDATO.CODCAN;
         V_TELCAN := R_CANDIDATO.TELCAN; 
         V_CELCAN := R_CANDIDATO.CELCAN; 
         V_COD_CIDADE := R_CANDIDATO.CODCIDADENAT;
         
 
       
   IF V_TELCAN IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_TELCAN), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
             V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
  
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST
         WHERE CID.COD_CIDADE = V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
        
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' || V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;       
      
        UPDATE DBVESTIB.CANDIDATO CAN
           SET CAN.TELCAN = V_TEL
         WHERE CAN.CODCAN = REG_CANDIDATO;
    
        UPDATE DBVESTIB.INSCRICAO INS
           SET INS.TELCAN = V_TEL
         WHERE INS.CODINSC = REG_CANDIDATO;
    
        UPDATE DBVESTIB.PREINSCRICAO PRE
           SET PRE.TELCAN = V_TEL
         WHERE PRE.CODINSC = REG_CANDIDATO;

    COMMIT;
    END IF;

    IF V_CELCAN IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_CELCAN), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
        IF LENGTH(V_TEL) >= 10 THEN
            V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
        END IF;
    
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST
         WHERE CID.COD_CIDADE = V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
        
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' || V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;       
        
        UPDATE DBVESTIB.CANDIDATO CAN
           SET CAN.CELCAN = V_TEL
         WHERE CAN.CODCAN = REG_CANDIDATO;
    
       /* UPDATE DBVESTIB.INSCRICAO INS
           SET INS.CELCAN = V_TEL
         WHERE INS.CODINSC = REG_CANDIDATO;
    
        UPDATE DBVESTIB.PREINSCRICAO PRE
           SET PRE.CELCAN = V_TEL
         WHERE PRE.CODINSC = REG_CANDIDATO;
         
   

    COMMIT;
    END IF;
   END LOOP; 
*/
-- INSCRICAO   


FOR R_INSCRICAO IN C_INSCRICAO LOOP
	     REG_CANDIDATO := R_INSCRICAO.CODINSC;
         V_TELCAN := R_INSCRICAO.TELCAN; 
         V_CELCAN := R_INSCRICAO.CELCAN; 
         V_COD_CIDADE := R_INSCRICAO.CODCIDADE;   

   IF V_TELCAN IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_TELCAN), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
             V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
  
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST
         WHERE CID.COD_CIDADE = V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
        
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' || V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;       
      
       /* UPDATE DBVESTIB.CANDIDATO CAN
           SET CAN.TELCAN = V_TEL
         WHERE CAN.CODCAN = REG_CANDIDATO;*/
    
        UPDATE DBVESTIB.INSCRICAO INS
           SET INS.TELCAN = V_TEL
         WHERE INS.CODINSC = REG_CANDIDATO;
    
        UPDATE DBVESTIB.PREINSCRICAO PRE
           SET PRE.TELCAN = V_TEL
         WHERE PRE.CODINSC = REG_CANDIDATO;

    COMMIT;
    END IF;

    IF V_CELCAN IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_CELCAN), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
        IF LENGTH(V_TEL) >= 10 THEN
            V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
        END IF;
    
        -- VERIFICA A CIDADE
        
        SELECT CID.COD_CIDADE
          INTO V_COD_ESTADO
          FROM DBSIAF.CIDADE CID,
               DBSIAF.ESTADO EST
         WHERE CID.COD_CIDADE = V_COD_CIDADE
           AND EST.COD_ESTADO = CID.COD_ESTADO;
        
        IF V_COD_ESTADO = 2 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_COD_CIDADE = 1554) OR (V_COD_CIDADE = 5373) THEN
                    V_TEL := '13' || V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 1 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_COD_ESTADO = 3 THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;       
        
      /*  UPDATE DBVESTIB.CANDIDATO CAN
           SET CAN.CELCAN = V_TEL
         WHERE CAN.CODCAN = REG_CANDIDATO;*/
    
        UPDATE DBVESTIB.INSCRICAO INS
           SET INS.CELCAN = V_TEL
         WHERE INS.CODINSC = REG_CANDIDATO;
    
        UPDATE DBVESTIB.PREINSCRICAO PRE
           SET PRE.CELCAN = V_TEL
         WHERE PRE.CODINSC = REG_CANDIDATO;
         
   

    COMMIT;
    END IF;
   END LOOP; 
   

END;
