DECLARE

	CURSOR C_ENEM IS
	             	
    SELECT CAN.CODCONC                                             CODCONC,
                  CAN.CODCAN                                        CODCAN,
                  CAN.NUMINSCENEM                                   NUMENEM,
                  DBSIAF.F_SO_NUMERO(CAN.NUMINSCENEM)               NUMINSCENEM, 
                  DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))  ANO_INS, 
                  CAN.ANOENEM                                       ANOENEM,
                  can.nomcan                             
             FROM DBVESTIB.CANDIDATO CAN
           WHERE CAN.CODFORMAPROVA = 2
             AND CAN.CODCONC = 1433--P_CODCONC   
             AND (
             (
             (CAN.ANOENEM = 2007 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '2007'))
             )
             OR
             ((CAN.ANOENEM = 2008 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '2008'))
             )
             OR
             ((CAN.ANOENEM = 2009 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '2009'))
             )
             OR
             ((CAN.ANOENEM = 2010 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '2010'))
             )
             OR
             (
             (CAN.ANOENEM = 2011 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '1110'))
             )
             OR 
             (
             (CAN.ANOENEM = 2012 AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4))<> '1210'))
             ) 
             OR
             (
             (CAN.ANOENEM IS NULL AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4)) IS NOT NULL))             
             )
             OR 
             (
             (CAN.ANOENEM IS NOT NULL AND (DBSIAF.F_SO_NUMERO(SUBSTR(CAN.NUMINSCENEM,1, 4)) IS NULL))             
             )
             );
    P_CODCONC DBVESTIB.CONCURSO.CODCONC%TYPE;         
	N_ENEM DBVESTIB.CANDIDATO.NUMINSCENEM%TYPE;
	CONTA  NUMBER;

BEGIN

	CONTA := 0;

	FOR R_ENEM IN C_ENEM LOOP
		SELECT CASE
				   WHEN (R_ENEM.ANO_INS = 2007) THEN
					2007
				   WHEN (R_ENEM.ANO_INS = 2008) THEN
					2008
				   WHEN (R_ENEM.ANO_INS = 2009) THEN
					2009
				   WHEN (R_ENEM.ANO_INS = 2010) THEN
					2010
				   WHEN (R_ENEM.ANO_INS = 1110) THEN
					2011
				   WHEN (R_ENEM.ANO_INS = 1210) THEN
					2012
				   ELSE
					TO_NUMBER(DBSIAF.F_SO_NUMERO(R_ENEM.ANO_INS))
			   END
		  INTO N_ENEM
		  FROM DUAL;

	
		IF ((TO_NUMBER(N_ENEM) IS NOT NULL) AND (R_ENEM.ANOENEM <> TO_NUMBER(N_ENEM)))
          OR (R_ENEM.ANOENEM IS NULL AND R_ENEM.NUMINSCENEM IS NOT NULL) THEN
			-- Se o ano Enem for diferente do ano  da substr e o nº da inscrição Enem for válido
		
			UPDATE DBVESTIB.CANDIDATO CAN
			   SET CAN.ANOENEM = TO_NUMBER(N_ENEM)
			 WHERE CAN.CODCONC = R_ENEM.CODCONC
				   AND CAN.CODCAN = R_ENEM.CODCAN;
		END IF;
	
		IF CONTA = 10 THEN
			COMMIT;
			CONTA := 0;
		ELSE
			CONTA := CONTA + 1;
		END IF;
        
	END LOOP;
    
    COMMIT;
END;
