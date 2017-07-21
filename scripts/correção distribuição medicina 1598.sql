DECLARE
	CURSOR C_MEDICINA IS
	
		SELECT CAN.CODCONC,
			   CAN.CODCAN,
			   CAN.NOMCAN,
			   CAN.EMAIL,
			   DDC.COD_ETAPA,
			   CAN.CELCAN "CELULAR",
			   CAN.TELCAN "TELEFONE",
			   'S' P_INSC_PAGA,
			   (SELECT CUR.NOMCUR
				  FROM DBVESTIB.CURSO CUR
				 WHERE CUR.CODCONC = OPC.CODCONC
					   AND CUR.CODCUR = OPC.CODCUR
					   AND CUR.CODCAM = OPC.CODCAM) "CURSO",
			   (SELECT TUR.DSCTUR
				  FROM DBVESTIB.TURNO TUR
				 WHERE TUR.CODTUR = OPC.CODTUR) TURNO,
			   (SELECT LOC.NOMLOC
				  FROM DBVESTIB.LOCAL LOC
				 WHERE LOC.CODCONC = DDC.CODCONC
					   AND LOC.CODLOC = DDC.CODLOC) "LOCAL ATUAL",
			   DDC.CODLOC,
			   (SELECT SAL.CODSAL
				  FROM DBVESTIB.SALA SAL
				 WHERE SAL.CODCONC = DDC.CODCONC
					   AND SAL.CODSAL = DDC.CODSAL
					   AND SAL.CODLOC = DDC.CODLOC) "SALA ATUAL"
		  FROM DBVESTIB.CANDIDATO              CAN,
			   DBVESTIB.RCANDCURTUROPC         OPC,
			   DBVESTIB.DISTRIBUICAO_CANDIDATO DDC
		
		 WHERE CAN.CODCONC = 1598
			   AND OPC.CODCONC = CAN.CODCONC
			   AND OPC.CODCAN = CAN.CODCAN
			   AND OPC.NROOPC = '1'
			   AND OPC.CODCUR = '34'
			   AND DDC.CODCONC = CAN.CODCONC
			   AND DDC.CODCAN = CAN.CODCAN
			  -- AND (DDC.CODLOC <> '08' AND DDC.CODLOC <> '07' AND DDC.CODLOC <> '09')]
               and ddc.cod_usuario_log = '13391'
			  -- AND CAN.CODCAN = '774418'
		 ORDER BY CAN.NOMCAN;
BEGIN

	FOR R_MEDICINA IN C_MEDICINA LOOP
	
		DELETE FROM DBVESTIB.DISTRIBUICAO_CANDIDATO DDC
		 WHERE DDC.CODCONC = R_MEDICINA.CODCONC
			   AND DDC.CODCAN = R_MEDICINA.CODCAN
			   AND DDC.COD_ETAPA = R_MEDICINA.COD_ETAPA;
	
		DBVESTIB.PC_DISTRIBUICAO.SP_DISTRIBUIR_CANDIDATO(R_MEDICINA.CODCONC,
														 R_MEDICINA.CODCAN,
														 R_MEDICINA.COD_ETAPA,
														 R_MEDICINA.P_INSC_PAGA);
		COMMIT;
	END LOOP;
END;
