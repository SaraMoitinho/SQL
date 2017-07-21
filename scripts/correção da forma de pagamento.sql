DECLARE
	CURSOR C_PAGTO IS
	
		SELECT INS.CODINSC,
			   INS.NOMCAN,
			   INS.VALPAGO,
			   INS.COD_STATUS_INSCRICAO,
			   INS.DATINSCAN,
			   INS.DATPGTO,
			   INS.FORMA_INGRESSO,
			   ST.DSC_STA_TITULO,
			   ST.COD_STA_TITULO,
			   TR.COD_TITULO_RECEBER,
			   MI.COD_MAPEAMENTO
		  FROM DBVESTIB.INSCRICAO          INS,
			   DBSIAF.MAPEAMENTO_INSCRICAO MI,
			   DBSIAF.MAPEAMENTO_TITULO    MT,
			   DBSIAF.TITULO_RECEBER       TR,
			   DBSIAF.STATUS_TITULO        ST
		 WHERE INS.CODCONC = '1940'
			  --  AND TR.COD_TITULO_RECEBER = 9656409
			   AND INS.COD_STATUS_INSCRICAO = 2
			  --  AND INS.CODINSC = '9656403'-- '981264'
			   AND MI.CODCONC = INS.CODCONC
			   AND MI.CODINSC = INS.CODINSC
			   AND MT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO
			   AND MT.COD_TITULO_RECEBER = TR.COD_TITULO_RECEBER
			   AND ST.COD_STA_TITULO = TR.COD_STA_TITULO
			   AND TR.COD_STA_TITULO = 1 --NOT  IN (3, 6)
			   AND EXISTS (SELECT 1
				  FROM DBVESTIB.INSCRICAO_LOG III
				 WHERE III.CODCONC = INS.CODCONC
					   AND III.CODINSC = INS.CODINSC
					   AND III.COD_USUARIO_LOG = 13391
					   AND III.FORMAPGTO = '1'
					   AND TRUNC(III.DATPGTO) = '24/05/2014')		
		 ORDER BY NOMCAN;

BEGIN
	FOR R_PAGTO IN C_PAGTO LOOP
	
		DBSIAF.PC_MAPEAMENTO_TITULO.SP_BAIXA_MAPEAMENTO_DINHEIRO(R_PAGTO.COD_MAPEAMENTO,
																 R_PAGTO.DATPGTO,
																 R_PAGTO.VALPAGO);
	END LOOP;
    commit;
END;
