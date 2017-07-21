DECLARE
  
  DDD     DBVESTIB.CANDIDATO.TELCAN%TYPE;
  CONTA   NUMBER;
 
  CURSOR C_CANDIDATO IS
      SELECT EST.COD_ESTADO,
             CAN.CODCAN,
             CAN.CODCONC,
             TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN)) CELCAN_CORRETO,
             TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELCAN)) TELCAN_CORRETO,
             TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELESC)) TELESC_CORRETO,
             TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELCOMERCIAL)) TELCOME_CORRETO,
             CID.COD_CIDADE
        FROM DBVESTIB.CANDIDATO CAN,
             DBSIAF.ESTADO EST, 
             DBSIAF.CIDADE CID
       WHERE CAN.CIDCAN = UPPER(CID.NOM_CIDADE)
        -- AND CAN.ESTCAN = EST.SGL_ESTADO 
         AND CID.COD_ESTADO = EST.COD_ESTADO
         AND  EST.COD_PAIS = '1'
         AND(         
         ((CAN.TELCAN IS NOT NULL) AND  
           (LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELCAN)))  < 10 ))
             
       OR 
           ((CAN.TELESC IS NOT NULL) AND
           (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELESC))) < 10))
       OR   
           ((CAN.TELCOMERCIAL IS NOT NULL) AND
           (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.TELCOMERCIAL))) < 10))
       OR    
           ((CAN.CELCAN IS NOT NULL) AND
           (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(CAN.CELCAN))) < 10))
           
       OR  (
       
           (LENGTH(CAN.TELCAN)  > 10 )
             
       OR 

           (LENGTH (CAN.TELESC) > 10)
       OR   
           
           (LENGTH(CAN.TELCOMERCIAL) > 10)
       OR    
           
           (LENGTH (CAN.CELCAN) > 10)
           ));
        
           
  CURSOR C_INSCRICAO IS
    SELECT EST.COD_ESTADO,
           INS.CODCIDADE,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)) CELCAN_CORRETO,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.TELCAN)) TELCAN_CORRETO,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.TELCOMERCIAL)) TELCOM_CORRETO,           
           INS.CODINSC,
           INS.CODCONC        
      FROM DBVESTIB.INSCRICAO INS,
           DBSIAF.CIDADE      CID,
           DBSIAF.ESTADO      EST
         WHERE INS.CODCIDADE = CID.COD_CIDADE
           AND INS.CODESTADO = CID.COD_ESTADO
           AND CID.COD_ESTADO = EST.COD_ESTADO           
           AND EST.COD_PAIS = 1
           AND INS.CODESTADO = EST.COD_ESTADO
            AND(         
         ((INS.CELCAN IS NOT NULL) AND  
           (LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.CELCAN)))  < 10 ))
             
       OR 
           ((INS.TELCAN IS NOT NULL) AND
           (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.TELCAN))) < 10))
       OR   
           ((INS.TELCOMERCIAL IS NOT NULL) AND
           (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(INS.TELCOMERCIAL))) < 10))
           
       OR  (         
           (LENGTH(INS.CELCAN)  > 10 )
             
       OR 
           (LENGTH (INS.TELCAN) > 10)
       OR   
           (LENGTH(INS.TELCOMERCIAL) > 10)
           ));           
     

  CURSOR C_ENDERECO IS
    SELECT ENA.COD_CIDADE, 
           CID.COD_ESTADO,
           ENA.COD_ALUNO,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.TEL_ENDERECO)) TELEND_CORRETO,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.FAX_NUMERO)) FAX_CORRETO
      FROM DBSIAF.END_ALUNO ENA,
           DBSIAF.CIDADE CID,
           DBSIAF.ESTADO EST
         WHERE ENA.COD_CIDADE = CID.COD_CIDADE 
           AND CID.COD_ESTADO = EST.COD_ESTADO         
           AND (
           (
           (ENA.TEL_ENDERECO IS NOT NULL) AND  
           (LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.TEL_ENDERECO)))  < 10 ))
           
           OR
           
           ((ENA.FAX_NUMERO IS NOT NULL) AND
               (LENGTH (TO_NUMBER(DBSIAF.F_SO_NUMERO(ENA.FAX_NUMERO))) < 10))
               
           OR  (LENGTH (ENA.FAX_NUMERO) > 10)  
               
           OR  (LENGTH(ENA.TEL_ENDERECO)  > 10 ))
           AND EST.COD_PAIS = 1
           AND ENA.COD_TPO_ENDERECO = 1;
    


  CURSOR C_ALUNO IS
    SELECT ALU.COD_CIDADE, 
           ALU.COD_ALUNO,
           CID.COD_ESTADO,
           TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)) CELULAR_CORRETO,
           ALU.CODCONC,
           ALU.CODCAN
      FROM DBSIAF.ALUNO ALU,
           DBSIAF.CIDADE CID,
           DBSIAF.ESTADO EST
         WHERE ALU.COD_CIDADE = CID.COD_CIDADE
           AND CID.COD_ESTADO = EST.COD_ESTADO
           AND EST.COD_PAIS = 1
           AND (
           ((ALU.TEL_CELULAR IS NOT NULL) AND  
           (LENGTH(TO_NUMBER(DBSIAF.F_SO_NUMERO(ALU.TEL_CELULAR)))  < 10 ))
           
           OR (LENGTH(ALU.TEL_CELULAR)  > 10 ) );
    


BEGIN
    CONTA := 0; 
   FOR R_CANDIDATO IN C_CANDIDATO LOOP           
  
    
    IF (R_CANDIDATO.COD_ESTADO = 1) THEN
      SELECT
         CASE
          WHEN ( R_CANDIDATO.COD_CIDADE = 2587)  THEN 37 -- ABAETÉ
          WHEN  ( R_CANDIDATO.COD_CIDADE = 38)    THEN 35-- ALFENAS
          WHEN  ( R_CANDIDATO.COD_CIDADE = 42)    THEN 33 -- Almenara
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2783)  THEN 33 -- ARAXÁ
          WHEN  ( R_CANDIDATO.COD_CIDADE = 126)   THEN 37 -- Arcos
          WHEN  ( R_CANDIDATO.COD_CIDADE = 173)   THEN 37-- Bambuí               
          WHEN  ( R_CANDIDATO.COD_CIDADE = 178)   THEN 32 -- Barbacena
          WHEN  ( R_CANDIDATO.COD_CIDADE = 197)   THEN 32-- Barroso                
    --        ( R_CANDIDATO.COD_CIDADE = 126)   THEN  -- Inhaúma      
          WHEN  ( R_CANDIDATO.COD_CIDADE = 814)   THEN 37 -- Itaguara
          WHEN  ( R_CANDIDATO.COD_CIDADE = 821)   THEN 35 -- Itajuba
          WHEN  ( R_CANDIDATO.COD_CIDADE = 827)   THEN 33 -- Itambacuri        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 837)   THEN 37 -- Itapecerica        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 858)   THEN 37 -- Itaúna        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 886)   THEN 38 -- JAnaúba      
          WHEN  ( R_CANDIDATO.COD_CIDADE = 901)   THEN 33 --Jequitinhonha                
          WHEN  ( R_CANDIDATO.COD_CIDADE = 940)   THEN 37 -- Lagoa da Prata
          WHEN  ( R_CANDIDATO.COD_CIDADE = 941)   THEN 32 -- Lagoa Dourada                
          WHEN  ( R_CANDIDATO.COD_CIDADE = 956)   THEN 35 -- Lavras        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 980)   THEN 37 -- Luz        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 989)   THEN 35 -- Machado        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2717)   THEN 33 -- Manhuacu
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1010)   THEN 33 -- Mantena
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1056)   THEN 33 -- Medina
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1063)   THEN 33 -- Minas Novas        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1099)   THEN 38 -- Montes Claros        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2958)   THEN 38 -- Morada Nova de Minas        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1173)   THEN 37 -- Oliveira      
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1243)   THEN 37 -- Pará de Minas        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1244)   THEN 34 -- Patrocínio
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1252)   THEN 33 -- Peçanha
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2954)   THEN 33 -- Pedra Azul        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1299)   THEN 38 -- Pirapora        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1309)   THEN 37 -- Pitangui
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1312)   THEN 37 -- Piumhi
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2702)   THEN 35 -- Poços de Caldas                
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1324)   THEN 37 -- Pompéu        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1347)   THEN 35 -- Pouso Alegre
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2712)   THEN 33 -- Rio Vermelho
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1481)   THEN 38 -- Salinas
          WHEN  ( R_CANDIDATO.COD_CIDADE = 3292)   THEN 33 -- Salto da Divisa    
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1515)   THEN 33 -- Santa Maria do Suaçui            
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1528)   THEN 35 -- Santana da vargem        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 2958)   THEN 38 -- Sao Gonçalo do Abaete
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1591)   THEN 34 -- Sao Gotardo                
          WHEN  ( R_CANDIDATO.COD_CIDADE = 5201)   THEN 38 -- Sao Joao da Ponte
          WHEN  ( R_CANDIDATO.COD_CIDADE = 3295)   THEN 32 -- Sao Joao Del Rey        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1662)   THEN 35 -- Sao Vicente de MInas                
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1683)   THEN 38 -- Serro        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1786)   THEN 35 -- Tres Corações        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1787)   THEN 38 -- Tres Marias
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1788)   THEN 35 -- Tres Pontas        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1789)   THEN 38 -- Turmalina        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1800)   THEN 32 -- Uba        
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1806)   THEN 34 -- Uberaba
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1832)   THEN 35 -- Varginha
          WHEN  ( R_CANDIDATO.COD_CIDADE = 4255)   THEN 38-- Varzea da Palma
          WHEN  ( R_CANDIDATO.COD_CIDADE = 1859)   THEN 32 -- Visconde do Rio Branco
          ELSE 31
            END
            INTO DDD 
    FROM DUAL;
    
     ELSIF (R_CANDIDATO.COD_ESTADO = 2) THEN
      SELECT
       CASE          
      WHEN (R_CANDIDATO.COD_CIDADE = 6421) THEN 13 -- Itariri
      WHEN (R_CANDIDATO.COD_CIDADE = 4456) THEN 18 -- Araçatuba
      WHEN (R_CANDIDATO.COD_CIDADE = 118) THEN 19 -- Araras  
      WHEN (R_CANDIDATO.COD_CIDADE = 146) THEN 13 -- Atibaia  
      WHEN (R_CANDIDATO.COD_CIDADE = 203) THEN 14 -- Bauru
      WHEN (R_CANDIDATO.COD_CIDADE = 233) THEN 13 -- Bertioga  
      WHEN (R_CANDIDATO.COD_CIDADE = 242) THEN 13 -- Berigui  
      WHEN (R_CANDIDATO.COD_CIDADE = 250) THEN 15 -- Itariri  
      WHEN (R_CANDIDATO.COD_CIDADE = 300) THEN 12 -- Caçapava  
      WHEN (R_CANDIDATO.COD_CIDADE = 345) THEN 19 -- Campinas
      WHEN (R_CANDIDATO.COD_CIDADE = 3497) THEN 19 -- Capivari
      WHEN (R_CANDIDATO.COD_CIDADE = 396) THEN 12 -- Caraguatatuba
      WHEN (R_CANDIDATO.COD_CIDADE = 4036) THEN 14 -- Chavantes  
      WHEN (R_CANDIDATO.COD_CIDADE = 551) THEN 13 -- Cubatao  
      WHEN (R_CANDIDATO.COD_CIDADE = 668) THEN 16 -- Caçapava  
      WHEN (R_CANDIDATO.COD_CIDADE = 704) THEN 17 -- Guaira  
      WHEN (R_CANDIDATO.COD_CIDADE = 732) THEN 13 -- Guaruja  
      WHEN (R_CANDIDATO.COD_CIDADE = 769) THEN 12 -- IlhaBela 
      WHEN (R_CANDIDATO.COD_CIDADE = 831) THEN 13 -- Itanhaem
      WHEN (R_CANDIDATO.COD_CIDADE = 300) THEN 15 -- Itacaré 
      WHEN (R_CANDIDATO.COD_CIDADE = 6601) THEN 13 -- Jacupiranga
      WHEN (R_CANDIDATO.COD_CIDADE = 897) THEN 14 -- Jau  
      WHEN (R_CANDIDATO.COD_CIDADE = 959) THEN 14 -- Lençois Paulistas  
      WHEN (R_CANDIDATO.COD_CIDADE = 966) THEN 19 -- Limeira  
      WHEN (R_CANDIDATO.COD_CIDADE = 974) THEN 14 -- Lorena  
      WHEN (R_CANDIDATO.COD_CIDADE = 1024) THEN 14 -- Marília  
      WHEN (R_CANDIDATO.COD_CIDADE = 6655) THEN 12 -- miracatu  
      WHEN (R_CANDIDATO.COD_CIDADE = 6026) THEN 13 -- Monguagua
      WHEN (R_CANDIDATO.COD_CIDADE = 1165) THEN 17 -- Novo Horizonte
      WHEN (R_CANDIDATO.COD_CIDADE = 1207) THEN 18 -- Palmital  
      WHEN (R_CANDIDATO.COD_CIDADE = 4079) THEN 13 -- Pariquera - Acu  
      WHEN (R_CANDIDATO.COD_CIDADE = 6719) THEN 13 -- Pedro de Toledo
      WHEN (R_CANDIDATO.COD_CIDADE = 1273) THEN 13 -- Peruibe  
      WHEN (R_CANDIDATO.COD_CIDADE = 1284) THEN 12 -- Pindamoinhangaba  
      WHEN (R_CANDIDATO.COD_CIDADE = 1293) THEN 19 -- Piracicaba  
      WHEN (R_CANDIDATO.COD_CIDADE = 1353) THEN 13 -- Praia Grande  
      WHEN (R_CANDIDATO.COD_CIDADE = 1362) THEN 18 -- Presidente Venceslau  
      WHEN (R_CANDIDATO.COD_CIDADE = 5370) THEN 13 -- Registro  
      WHEN (R_CANDIDATO.COD_CIDADE = 1407) THEN 16 -- Ribeirao Preto  
      WHEN (R_CANDIDATO.COD_CIDADE = 1424) THEN 19 -- Rio Claro 
      WHEN (R_CANDIDATO.COD_CIDADE = 1554) THEN 13 -- Santos
      WHEN (R_CANDIDATO.COD_CIDADE = 5373) THEN 13 -- Santos  
      WHEN (R_CANDIDATO.COD_CIDADE = 1568) THEN 16 -- Sao Carlos
      WHEN (R_CANDIDATO.COD_CIDADE = 3324) THEN 17 -- Sao Jose do Rio Preto
      WHEN (R_CANDIDATO.COD_CIDADE = 1655) THEN 12 -- Sao Sebastiao
      WHEN (R_CANDIDATO.COD_CIDADE = 1661) THEN 13 -- Sao Vicente
      WHEN (R_CANDIDATO.COD_CIDADE = 1704) THEN 19 -- Socorro  
      WHEN (R_CANDIDATO.COD_CIDADE = 1710) THEN 15 -- Sorocaba  
      WHEN (R_CANDIDATO.COD_CIDADE = 1753) THEN 18 -- Taruma        
      WHEN (R_CANDIDATO.COD_CIDADE = 1757) THEN 12 -- Taubate  
      WHEN (R_CANDIDATO.COD_CIDADE = 1825) THEN 19 -- Valinhos
      WHEN (R_CANDIDATO.COD_CIDADE = 6858) THEN 13 -- Vicente de Carvalho    
      ELSE 11
        END
          INTO DDD 
    FROM DUAL;
   END IF;
     
    SELECT
      CASE         
      WHEN (R_CANDIDATO.COD_ESTADO = 3)  THEN 21 -- Rio de Janeiro / RJ
      WHEN (R_CANDIDATO.COD_ESTADO = 4)  THEN 27  -- Espírito Sando / Vitória
      WHEN (R_CANDIDATO.COD_ESTADO = 5)  THEN 62 -- Goias / Goiânia
      WHEN (R_CANDIDATO.COD_ESTADO = 12) THEN 98 -- Maranhão / São Luiz 
      WHEN (R_CANDIDATO.COD_ESTADO = 14) THEN 67 -- Mato Grosso do Sul / Campo Grande
      WHEN (R_CANDIDATO.COD_ESTADO = 15) THEN 65 -- Mato Grosso / Cuiabá
      WHEN (R_CANDIDATO.COD_ESTADO = 16) THEN 91 -- Pará / Belém
      WHEN (R_CANDIDATO.COD_ESTADO = 17) THEN 83 -- Paraíba / João Pessoa
      WHEN (R_CANDIDATO.COD_ESTADO = 18) THEN 81 -- Pernambuco / Recife
      WHEN (R_CANDIDATO.COD_ESTADO = 19) THEN 86 -- Piaui / Teresina
      WHEN (R_CANDIDATO.COD_ESTADO = 20) THEN 41 -- Paraná / Curitiba           
      WHEN (R_CANDIDATO.COD_ESTADO = 22) THEN 84 -- Rio Grande no Norte / Natal
      WHEN (R_CANDIDATO.COD_ESTADO = 23) THEN 69 -- Rondônia / Porto Velho 
      WHEN (R_CANDIDATO.COD_ESTADO = 24) THEN 95 -- Roraima / Boa Vista                
      WHEN (R_CANDIDATO.COD_ESTADO = 25) THEN 51 -- Rio Grande do Sul / Porto Alegre       
      WHEN (R_CANDIDATO.COD_ESTADO = 26) THEN 48 -- Santa Catarina / Florianópolis      
      WHEN (R_CANDIDATO.COD_ESTADO = 27) THEN 79 -- Sergipe /Aracajú
      WHEN (R_CANDIDATO.COD_ESTADO = 29) THEN 63 -- Tocantins / Palmas
      WHEN (R_CANDIDATO.COD_ESTADO = 30) THEN 68 -- Acre / Rio Branco               
      WHEN (R_CANDIDATO.COD_ESTADO = 31) THEN 92 -- Amazonas / Manaus
      WHEN (R_CANDIDATO.COD_ESTADO = 32) THEN 96 -- Amapá  / Macapá
      WHEN (R_CANDIDATO.COD_ESTADO = 33) THEN 71 -- Bahia / Salvador
      WHEN (R_CANDIDATO.COD_ESTADO = 34) THEN 85 -- Ceará / Fortaleza
      WHEN (R_CANDIDATO.COD_ESTADO = 35) THEN 61 -- Distrito Federal / Brasília
      WHEN (R_CANDIDATO.COD_ESTADO = 36) THEN 82 -- Alagoas / Maceió                                
      ELSE 693 --NÃO INFORMADO
        END
        INTO DDD 
    FROM DUAL;
    
    IF ((R_CANDIDATO.TELCAN_CORRETO IS NOT NULL) AND
        (LENGTH (R_CANDIDATO.TELCAN_CORRETO) < 10)) THEN
     R_CANDIDATO.TELCAN_CORRETO  := DDD || R_CANDIDATO.TELCAN_CORRETO;
    
    ELSIF ((R_CANDIDATO.TELESC_CORRETO IS NOT NULL) AND
           (LENGTH (R_CANDIDATO.TELESC_CORRETO) < 10)) THEN
       R_CANDIDATO.TELESC_CORRETO := DDD || R_CANDIDATO.TELESC_CORRETO;
    
    ELSIF ((R_CANDIDATO.TELCOME_CORRETO IS NOT NULL) AND
           (LENGTH (R_CANDIDATO.TELCOME_CORRETO) < 10)) THEN  
      R_CANDIDATO.TELCOME_CORRETO := DDD || R_CANDIDATO.TELCOME_CORRETO;      
    END IF;  
  
    UPDATE DBVESTIB.CANDIDATO CAN
       SET CAN.TELCAN = R_CANDIDATO.TELCAN_CORRETO,
           CAN.CELCAN = R_CANDIDATO.CELCAN_CORRETO,
           CAN.TELESC = R_CANDIDATO.TELESC_CORRETO,
           CAN.TELCOMERCIAL = R_CANDIDATO.TELCOME_CORRETO 
     WHERE CODCONC = R_CANDIDATO.CODCONC
         AND CODCAN = R_CANDIDATO.CODCAN;                                     
     
  
  IF CONTA = 50 THEN
    COMMIT;
    CONTA := 0;
   ELSE CONTA := CONTA +1; 
 END IF;  
  END LOOP;

  FOR R_INSCRICAO IN C_INSCRICAO LOOP
 
    SELECT 
    CASE 
      WHEN (R_INSCRICAO.COD_ESTADO = 1) THEN 31 -- Minas Gerais 
      WHEN (R_INSCRICAO.COD_ESTADO = 2 AND R_INSCRICAO.CODCIDADE = 1554) THEN 13 -- SP/Santos
      WHEN (R_INSCRICAO.COD_ESTADO = 2 AND R_INSCRICAO.CODCIDADE <> 1554) THEN 11 -- SP
      WHEN (R_INSCRICAO.COD_ESTADO = 3)  THEN 21 -- Rio de Janeiro / RJ
      WHEN (R_INSCRICAO.COD_ESTADO = 4)  THEN 27  -- Espírito Sando / Vitória
      WHEN (R_INSCRICAO.COD_ESTADO = 5)  THEN 62 -- Goias / Goiânia
      WHEN (R_INSCRICAO.COD_ESTADO = 12) THEN 98 -- Maranhão / São Luiz 
      WHEN (R_INSCRICAO.COD_ESTADO = 14) THEN 67 -- Mato Grosso do Sul / Campo Grande
      WHEN (R_INSCRICAO.COD_ESTADO = 15) THEN 65 -- Mato Grosso / Cuiabá
      WHEN (R_INSCRICAO.COD_ESTADO = 16) THEN 91 -- Pará / Belém
      WHEN (R_INSCRICAO.COD_ESTADO = 17) THEN 83 -- Paraíba / João Pessoa
      WHEN (R_INSCRICAO.COD_ESTADO = 18) THEN 81 -- Pernambuco / Recife
      WHEN (R_INSCRICAO.COD_ESTADO = 19) THEN 86 -- Piaui / Teresina
      WHEN (R_INSCRICAO.COD_ESTADO = 20) THEN 41 -- Paraná / Curitiba           
      WHEN (R_INSCRICAO.COD_ESTADO = 22) THEN 84 -- Rio Grande no Norte / Natal
      WHEN (R_INSCRICAO.COD_ESTADO = 23) THEN 69 -- Rondônia / Porto Velho 
      WHEN (R_INSCRICAO.COD_ESTADO = 24) THEN 95 -- Roraima / Boa Vista                
      WHEN (R_INSCRICAO.COD_ESTADO = 25) THEN 51 -- Rio Grande do Sul / Porto Alegre       
      WHEN (R_INSCRICAO.COD_ESTADO = 26) THEN 48 -- Santa Catarina / Florianópolis      
      WHEN (R_INSCRICAO.COD_ESTADO = 27) THEN 79 -- Sergipe /Aracajú
      WHEN (R_INSCRICAO.COD_ESTADO = 29) THEN 63 -- Tocantins / Palmas
      WHEN (R_INSCRICAO.COD_ESTADO = 30) THEN 68 -- Acre / Rio Branco               
      WHEN (R_INSCRICAO.COD_ESTADO = 31) THEN 92 -- Amazonas / Manaus
      WHEN (R_INSCRICAO.COD_ESTADO = 32) THEN 96 -- Amapá  / Macapá
      WHEN (R_INSCRICAO.COD_ESTADO = 33) THEN 71 -- Bahia / Salvador
      WHEN (R_INSCRICAO.COD_ESTADO = 34) THEN 85 -- Ceará / Fortaleza
      WHEN (R_INSCRICAO.COD_ESTADO = 35) THEN 61 -- Distrito Federal / Brasília
      WHEN (R_INSCRICAO.COD_ESTADO = 36) THEN 82 -- Alagoas / Maceió                                
      ELSE 693 --NÃO INFORMADO
        END
        INTO DDD 
    FROM DUAL;    

    
    IF ((R_INSCRICAO.TELCAN_CORRETO IS NOT NULL)AND
        (LENGTH (R_INSCRICAO.TELCAN_CORRETO) < 10)) THEN
      R_INSCRICAO.TELCAN_CORRETO := DDD || R_INSCRICAO.TELCAN_CORRETO;
    
    ELSIF ((R_INSCRICAO.CELCAN_CORRETO IS NOT NULL) AND
           (LENGTH (R_INSCRICAO.CELCAN_CORRETO) < 10)) THEN
      R_INSCRICAO.CELCAN_CORRETO := DDD || R_INSCRICAO.CELCAN_CORRETO;
    
    ELSIF ((R_INSCRICAO.TELCOM_CORRETO IS NOT NULL) AND
           (LENGTH (R_INSCRICAO.TELCOM_CORRETO) < 10)) THEN  
      R_INSCRICAO.TELCOM_CORRETO := DDD || R_INSCRICAO.TELCOM_CORRETO;      
    END IF;    
    
    UPDATE DBVESTIB.INSCRICAO INS
       SET INS.TELCAN = R_INSCRICAO.TELCAN_CORRETO,
           INS.CELCAN = R_INSCRICAO.CELCAN_CORRETO,
           INS.TELCOMERCIAL = R_INSCRICAO.TELCOM_CORRETO
     WHERE CODCONC = R_INSCRICAO.CODCONC
       AND CODINSC = R_INSCRICAO.CODINSC;
           
     IF CONTA = 50 THEN
       COMMIT;
       CONTA := 0;    
     ELSE CONTA:= CONTA +1;
    END IF;  
    
    
  END LOOP;


FOR R_ENDERECO IN C_ENDERECO LOOP

 
  SELECT 
    CASE 
      WHEN (R_ENDERECO.COD_ESTADO = 1) THEN 31 -- Minas Gerais 
      WHEN (R_ENDERECO.COD_ESTADO = 2 AND R_ENDERECO.COD_CIDADE = 1554) THEN 13 -- SP/Santos
      WHEN (R_ENDERECO.COD_ESTADO = 2 AND R_ENDERECO.COD_CIDADE <> 1554) THEN 11 -- SP
      WHEN (R_ENDERECO.COD_ESTADO = 3)  THEN 21 -- Rio de Janeiro / RJ
      WHEN (R_ENDERECO.COD_ESTADO = 4)  THEN 27  -- Espírito Sando / Vitória
      WHEN (R_ENDERECO.COD_ESTADO = 5)  THEN 62 -- Goias / Goiânia
      WHEN (R_ENDERECO.COD_ESTADO = 12) THEN 98 -- Maranhão / São Luiz 
      WHEN (R_ENDERECO.COD_ESTADO = 14) THEN 67 -- Mato Grosso do Sul / Campo Grande
      WHEN (R_ENDERECO.COD_ESTADO = 15) THEN 65 -- Mato Grosso / Cuiabá
      WHEN (R_ENDERECO.COD_ESTADO = 16) THEN 91 -- Pará / Belém
      WHEN (R_ENDERECO.COD_ESTADO = 17) THEN 83 -- Paraíba / João Pessoa
      WHEN (R_ENDERECO.COD_ESTADO = 18) THEN 81 -- Pernambuco / Recife
      WHEN (R_ENDERECO.COD_ESTADO = 19) THEN 86 -- Piaui / Teresina
      WHEN (R_ENDERECO.COD_ESTADO = 20) THEN 41 -- Paraná / Curitiba           
      WHEN (R_ENDERECO.COD_ESTADO = 22) THEN 84 -- Rio Grande no Norte / Natal
      WHEN (R_ENDERECO.COD_ESTADO = 23) THEN 69 -- Rondônia / Porto Velho 
      WHEN (R_ENDERECO.COD_ESTADO = 24) THEN 95 -- Roraima / Boa Vista                
      WHEN (R_ENDERECO.COD_ESTADO = 25) THEN 51 -- Rio Grande do Sul / Porto Alegre       
      WHEN (R_ENDERECO.COD_ESTADO = 26) THEN 48 -- Santa Catarina / Florianópolis      
      WHEN (R_ENDERECO.COD_ESTADO = 27) THEN 79 -- Sergipe /Aracajú
      WHEN (R_ENDERECO.COD_ESTADO = 29) THEN 63 -- Tocantins / Palmas
      WHEN (R_ENDERECO.COD_ESTADO = 30) THEN 68 -- Acre / Rio Branco               
      WHEN (R_ENDERECO.COD_ESTADO = 31) THEN 92 -- Amazonas / Manaus
      WHEN (R_ENDERECO.COD_ESTADO = 32) THEN 96 -- Amapá  / Macapá
      WHEN (R_ENDERECO.COD_ESTADO = 33) THEN 71 -- Bahia / Salvador
      WHEN (R_ENDERECO.COD_ESTADO = 34) THEN 85 -- Ceará / Fortaleza
      WHEN (R_ENDERECO.COD_ESTADO = 35) THEN 61 -- Distrito Federal / Brasília
      WHEN (R_ENDERECO.COD_ESTADO = 36) THEN 82 -- Alagoas / Maceió                                
      ELSE 693--NÃO INFORMADO
        END
        INTO DDD 
    FROM DUAL;
    
  IF ((R_ENDERECO.TELEND_CORRETO IS NOT NULL)AND
        (LENGTH (R_ENDERECO.TELEND_CORRETO) < 10)) THEN
      R_ENDERECO.TELEND_CORRETO := DDD || R_ENDERECO.TELEND_CORRETO;
    
    ELSIF ((R_ENDERECO.FAX_CORRETO IS NOT NULL) AND
           (LENGTH (R_ENDERECO.FAX_CORRETO) < 10)) THEN
      R_ENDERECO.FAX_CORRETO := DDD || R_ENDERECO.FAX_CORRETO;        
    END IF;    

 IF (R_ENDERECO.TELEND_CORRETO IS NOT NULL) THEN
  UPDATE DBSIAF.END_ALUNO EN
     SET EN.TEL_ENDERECO = R_ENDERECO.TELEND_CORRETO,
         EN.FAX_NUMERO   = R_ENDERECO.FAX_CORRETO
   WHERE EN.COD_ALUNO = R_ENDERECO.COD_ALUNO;

 END IF;
  
  IF CONTA = 50 THEN
    COMMIT;
    CONTA := 0;
   ELSE CONTA := CONTA +1; 
 END IF;  

END LOOP;

FOR R_ALUNO IN C_ALUNO LOOP

  SELECT 
    CASE 
      WHEN (R_ALUNO.COD_ESTADO = 1) THEN 31 -- Minas Gerais 
      WHEN (R_ALUNO.COD_ESTADO = 2 AND R_ALUNO.COD_CIDADE = 1554) THEN 13 -- SP/Santos
      WHEN (R_ALUNO.COD_ESTADO = 2 AND R_ALUNO.COD_CIDADE <> 1554) THEN 11 -- SP
      WHEN (R_ALUNO.COD_ESTADO = 3)  THEN 21 -- Rio de Janeiro / RJ
      WHEN (R_ALUNO.COD_ESTADO = 4)  THEN 27  -- Espírito Sando / Vitória
      WHEN (R_ALUNO.COD_ESTADO = 5)  THEN 62 -- Goias / Goiânia
      WHEN (R_ALUNO.COD_ESTADO = 12) THEN 98 -- Maranhão / São Luiz 
      WHEN (R_ALUNO.COD_ESTADO = 14) THEN 67 -- Mato Grosso do Sul / Campo Grande
      WHEN (R_ALUNO.COD_ESTADO = 15) THEN 65 -- Mato Grosso / Cuiabá
      WHEN (R_ALUNO.COD_ESTADO = 16) THEN 91 -- Pará / Belém
      WHEN (R_ALUNO.COD_ESTADO = 17) THEN 83 -- Paraíba / João Pessoa
      WHEN (R_ALUNO.COD_ESTADO = 18) THEN 81 -- Pernambuco / Recife
      WHEN (R_ALUNO.COD_ESTADO = 19) THEN 86 -- Piaui / Teresina
      WHEN (R_ALUNO.COD_ESTADO = 20) THEN 41 -- Paraná / Curitiba           
      WHEN (R_ALUNO.COD_ESTADO = 22) THEN 84 -- Rio Grande no Norte / Natal
      WHEN (R_ALUNO.COD_ESTADO = 23) THEN 69 -- Rondônia / Porto Velho 
      WHEN (R_ALUNO.COD_ESTADO = 24) THEN 95 -- Roraima / Boa Vista                
      WHEN (R_ALUNO.COD_ESTADO = 25) THEN 51 -- Rio Grande do Sul / Porto Alegre       
      WHEN (R_ALUNO.COD_ESTADO = 26) THEN 48 -- Santa Catarina / Florianópolis      
      WHEN (R_ALUNO.COD_ESTADO = 27) THEN 79 -- Sergipe /Aracajú
      WHEN (R_ALUNO.COD_ESTADO = 29) THEN 63 -- Tocantins / Palmas
      WHEN (R_ALUNO.COD_ESTADO = 30) THEN 68 -- Acre / Rio Branco               
      WHEN (R_ALUNO.COD_ESTADO = 31) THEN 92 -- Amazonas / Manaus
      WHEN (R_ALUNO.COD_ESTADO = 32) THEN 96 -- Amapá  / Macapá
      WHEN (R_ALUNO.COD_ESTADO = 33) THEN 71 -- Bahia / Salvador
      WHEN (R_ALUNO.COD_ESTADO = 34) THEN 85 -- Ceará / Fortaleza
      WHEN (R_ALUNO.COD_ESTADO = 35) THEN 61 -- Distrito Federal / Brasília
      WHEN (R_ALUNO.COD_ESTADO = 36) THEN 82 -- Alagoas / Maceió                                
      ELSE 693 --NÃO INFORMADO
        END
        INTO DDD 
    FROM DUAL;
    
    IF ((R_ALUNO.CELULAR_CORRETO IS NOT NULL)AND
        (LENGTH (R_ALUNO.CELULAR_CORRETO) < 10)) THEN
      R_ALUNO.CELULAR_CORRETO:= DDD || R_ALUNO.CELULAR_CORRETO;
   
     END IF;
      
     UPDATE DBSIAF.ALUNO ALU
        SET ALU.TEL_CELULAR = R_ALUNO.CELULAR_CORRETO
      WHERE COD_ALUNO = R_ALUNO.COD_ALUNO
        AND CODCONC = R_ALUNO.CODCONC
        AND CODCAN = R_ALUNO.CODCAN;
              
        IF CONTA = 50 THEN
          COMMIT;        
          CONTA := 0;
        ELSE CONTA := CONTA +1; 
        END IF;  

END LOOP;
COMMIT;
END;
