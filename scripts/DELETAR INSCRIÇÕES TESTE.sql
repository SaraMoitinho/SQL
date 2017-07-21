DECLARE
	CURSOR C_TESTE IS
		SELECT INS.CODCONC,
			   INS.CODINSC              CODCAN,
			   INS.COD_STATUS_INSCRICAO,
			   INS.NOMCAN               NOMCAN
		  FROM DBVESTIB.INSCRICAO INS
		 WHERE INS.CODCONC = '1598'
			   AND UPPER(INS.NOMCAN) LIKE '%TESTE%'
			   AND NOT EXISTS (SELECT 1
				  FROM DBVESTIB.CANDIDATO CAN
				 WHERE CAN.CODCONC = INS.CODCONC
					   AND CAN.CODCAN = INS.CODINSC)
		
		UNION
		SELECT CAN.CODCONC,
			   CAN.CODCAN,
			   2           COD_STATUS_INSCRICAO,
			   CAN.NOMCAN  NOMCAN
		  FROM DBVESTIB.CANDIDATO CAN
		 WHERE CAN.CODCONC = '1598'
			   AND UPPER(CAN.NOMCAN) LIKE '%TESTE%';
BEGIN
	FOR R_TESTE IN C_TESTE LOOP
	
		IF (R_TESTE.COD_STATUS_INSCRICAO = 1)
		   OR (R_TESTE.COD_STATUS_INSCRICAO IS NULL) THEN
			DELETE FROM DBVESTIB.OPCAOCANDIDATO OPC
			 WHERE OPC.CODCONC = R_TESTE.CODCONC
				   AND OPC.CODINSC = R_TESTE.CODCAN;
		
			DELETE FROM DBVESTIB.INSCRICAO_DEFICIENCIA DEF
			 WHERE DEF.CODCONC = R_TESTE.CODCONC
				   AND DEF.CODINSC = R_TESTE.CODCAN;
		
			DELETE FROM DBSIAF.MAPEAMENTO_INSCRICAO MI
			 WHERE MI.CODCONC = R_TESTE.CODCONC
				   AND MI.CODINSC = R_TESTE.CODCAN;
		
			DELETE FROM DBVESTIB.INSCRICAO CAN
			 WHERE CAN.CODCONC = R_TESTE.CODCONC
				   AND CAN.CODINSC = R_TESTE.CODCAN;
		
		ELSIF (R_TESTE.COD_STATUS_INSCRICAO = 2) THEN
		
			UPDATE DBVESTIB.INSCRICAO INS
			   SET INS.COD_STATUS_INSCRICAO = 4
			 WHERE INS.CODCONC = R_TESTE.CODCONC
				   AND INS.CODINSC = R_TESTE.CODCAN;
		
		END IF;
	END LOOP; 
END;

/*

select i.cod_status_inscricao
from dbvestib.inscricao i
where i.codconc = '1598'
and i.codinsc = '751997'*/
