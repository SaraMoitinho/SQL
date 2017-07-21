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
    V_CIDADE         DBSIAF.CIDADE.NOM_CIDADE%TYPE;
    V_ESTADO       DBVESTIB.CANDIDATO.ESTCAN%TYPE;
    V_CODCAN        DBVESTIB.CANDIDATO.CODCAN%TYPE;
    
   
      CURSOR C_CANDIDATO IS
      SELECT CAN.CODCAN,
             CAN.TELCAN,
             CAN.CELCAN, 
             CAN.ESTCAN, 
             CAN.CIDCAN
        FROM DBVESTIB.CANDIDATO CAN;
         
    
BEGIN

 -- USANDO CANDIDATO

 FOR R_CANDIDATO IN C_CANDIDATO LOOP
         REG_CANDIDATO := R_CANDIDATO.CODCAN;
         V_TELCAN := R_CANDIDATO.TELCAN; 
         V_CELCAN := R_CANDIDATO.CELCAN; 
         V_ESTADO := R_CANDIDATO.ESTCAN;
         V_CIDADE := R_CANDIDATO.CIDCAN;
    
    IF V_CELCAN IS NOT NULL THEN
        V_TEL := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_CELCAN), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), '/', '');
    
        -- VERIFICA SE O 1° DIGITO É ZERO
             V_TEL2 := SUBSTR(V_TEL, 0, 1);
        
            IF V_TEL2 = '0' THEN
                V_TEL := SUBSTR(V_TEL, 2);
            END IF;
  
        -- VERIFICA A CIDADE

        
        IF V_ESTADO = 'SP' THEN
            IF LENGTH(V_TEL) <= 8 THEN
                IF (V_CIDADE = 'SANTOS') THEN
                    V_TEL := '13' || V_TEL;
                END IF;
            END IF;
        END IF;
    
        IF V_CIDADE = 'BELO HORIZONTE' THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '31' || V_TEL;
            END IF;
        END IF;
    
        IF V_ESTADO = 'RJ' THEN
            IF LENGTH(V_TEL) <= 8 THEN
                V_TEL := '21' || V_TEL;
            END IF;
        END IF;       
      
        UPDATE DBVESTIB.CANDIDATO CAN
           SET CAN.CELCAN = V_TEL
         WHERE CAN.CODCAN = REG_CANDIDATO;
    
       
    COMMIT;
    END IF;
   END LOOP; 
   END;
