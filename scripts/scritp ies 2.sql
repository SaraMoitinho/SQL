
SELECT *
  FROM DBSIAF.TITULO_MIRA2 TRM
 WHERE NOT EXISTS (SELECT 1
		  FROM DBSIAF.INSTITUICAO_EXTERNA IES
		 WHERE IES.COD_INEP = TRM.COD_TITULO_RECEBER
			   AND IES.IND_MEC = 'S');
