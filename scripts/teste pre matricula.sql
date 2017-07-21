DECLARE
	CURSOR C_CAN IS
		SELECT *
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC IN ('3102',
							   '3103',
							   '3110')
			   AND CAN.CODFORMAPROVA = 2;

BEGIN
	DELETE FROM DBVESTIB.NOTAENEM ENE
	 WHERE ENE.CODCONC IN ('3102',
						   '3103',
						   '3110');
	COMMIT;

	FOR R_CAN IN C_CAN LOOP
		BEGIN
			UPDATE DBVESTIB.CANDIDATO CAN
			   SET CAN.CODFORMAPROVA = 1
			 WHERE CAN.CODCONC = R_CAN.CODCONC
				   AND CAN.CODCAN = R_CAN.CODCAN;
			COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20500,
										R_CAN.CODCONC || '-' || R_CAN.CODCAN);
		END;
	END LOOP;

END;