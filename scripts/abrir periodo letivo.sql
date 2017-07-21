DECLARE
	CODPER DBSIAF.PERIODO_LETIVO.COD_PERIODO_LETIVO%TYPE;
BEGIN
	SELECT COD_PERIODO_LETIVO, p.ind_fechado
	 -- INTO CODPER
	  FROM DBSIAF.PERIODO_LETIVO P
	 WHERE P.SGL_PERIODO_LETIVO = 'M2006/2'
		   AND P.COD_INSTITUICAO = 3;
           
	DBSIAF.PC_MUTANTE_TABLE.SP_INSERE('GERAL',
									  'IND_LIBERAR',
									  'S');
	UPDATE DBSIAF.PERIODO_LETIVO P
	   SET P.IND_FECHADO = 'N'
	 WHERE P.COD_PERIODO_LETIVO = CODPER;

	DBSIAF.PC_MUTANTE_TABLE.SP_LIMPA_TEMPORARIA('GERAL',
												'IND_LIBERAR');

	COMMIT;

END;