DECLARE

	CURSOR C_PROVA IS
		SELECT DISTINCT CODCONC,
						CODCAD
		  FROM DBVESTIB.PROVASCADERNO CAD
		 WHERE CAD.CODCONC = '1969'
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.PROVASCADERNO PPP
				 WHERE PPP.CODCONC = CAD.CODCONC
					   AND PPP.CODCAD = CAD.CODCAD
					   AND PPP.CODPRO <> '16');
	/*
    CURSOR C_PROVA IS
      SELECT CAD.CODCONC,
           CAD.CODCAD,
           CAD.DSCCAD,
           CAD.CODETP,
           ETP.DSCETP,
           CAD.COD_ETAPA,
           ETC.DSC_ETAPA,
           CAD.MINAPROV
        FROM DBVESTIB.CADERNO        CAD,
           DBVESTIB.ETAPA          ETP,
           DBVESTIB.ETAPA_CONCURSO ETC
       WHERE CAD.CODCONC = '1977'
           AND ETP.CODCONC = CAD.CODCONC
           AND ETP.CODETP = CAD.CODETP
           AND CAD.COD_ETAPA = ETC.COD_ETAPA
         \* --  AND CAD.CODCAD LIKE '94%'
           AND NOT EXISTS (SELECT 1
            FROM DBVESTIB.PROVASCADERNO PRO
           WHERE PRO.CODCONC = CAD.CODCONC
               AND PRO.CODCAD = CAD.CODCAD)*\
      */
	--ORDER BY CODCAD;

	VALIDA NUMBER;
BEGIN
	FOR R_PROVA IN C_PROVA LOOP
		--BEGIN
		/*
          INSERT INTO DBVESTIB.PROVASCADERNO
            (CODCONC,
             CODCAD,
             CODPRO,
             QUEINI,
             QUEFIN,
             MINAPROV,
             IND_VERIFICA_DESISTENCIA,
             VALPROVA)
          VALUES
            (R_PROVA.CODCONC,
             R_PROVA.CODCAD,
             '16',
             1,
             5,
             1,
             'S',
             5);
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20500,
                        R_PROVA.CODCAD);
        END;
        */
	
		UPDATE DBVESTIB.PROVASCADERNO PPP
		   SET PPP.QUEINI                   = 6,
			   PPP.QUEFIN                   = 30,
			   PPP.MINAPROV                 = 1,
			   PPP.IND_VERIFICA_DESISTENCIA = 'S',
			   PPP.VALPROVA                 = 25
		 WHERE PPP.CODCONC = R_PROVA.CODCONC
			   AND PPP.CODCAD = R_PROVA.CODCAD
			   AND PPP.CODPRO = '16';
	
		/*
        SELECT COUNT(1)
          INTO VALIDA
          FROM DBVESTIB.GABARITO GAB
         WHERE GAB.CODCONC = R_PROVA.CODCONC
             AND GAB.CODCAD = R_PROVA.CODCAD;
        
        IF VALIDA = 0 THEN
          INSERT INTO DBVESTIB.GABARITO
            (CODCONC,
             CODCAD,
             OPCLIN,
             RESPGAB)
          VALUES
            (R_PROVA.CODCONC,
             R_PROVA.CODCAD,
             0,
             NULL);
        END IF;*/
	
		DELETE FROM DBVESTIB.PROVASCADERNO PRO
		 WHERE PRO.CODCONC = R_PROVA.CODCONC
			   AND PRO.CODCAD = R_PROVA.CODCAD
			   AND PRO.CODPRO NOT IN ('16',
									  '48');
	END LOOP;

END;
