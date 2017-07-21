-- Criar concursos

DECLARE

	CONC_DESTINO DBVESTIB.CONCURSO.CODCONC%TYPE;
	I            NUMBER;
	CURSO        DBSIAF.CURSO.COD_CURSO%TYPE;
	CURSO        DBSIAF.CURSO.COD_CURSO%TYPE;
	NOMCURSO     DBSIAF.CURSO.NOM_CURSO%TYPE;
	CAMPUS       DBVESTIB.CAMPUS.CODCAM%TYPE;
	CONCURSO     DBVESTIB.CONCURSO.CODCONC%TYPE;
	VALIDA       NUMBER;
	TURNO        DBSIAF.ALUNO.COD_TURNO%TYPE;

BEGIN
	I := 1;
	WHILE I <2 LOOP
	
		/*SELECT MAX(TO_NUMBER(CODCONC))
        INTO CONC_DESTINO
        FROM DBVESTIB.CONCURSO;*/
		CONC_DESTINO := DBVESTIB.F_BUSCA_CONCURSO;
		DBVESTIB.SP_PREPARA_NOVO_CONCURSO('2643',
										  CONC_DESTINO, 'N');
		I := I + 1;
	
		-- criando curso
		SELECT COUNT( 1)
		  INTO VALIDA
		  FROM DBVESTIB.CURSO C
		 WHERE C.CODCONC = CONC_DESTINO;
	
		IF VALIDA = 1 THEN
			DELETE FROM DBVESTIB.CURSO
			 WHERE CODCONC = CONC_DESTINO;
			COMMIT;
		END IF;
	
		INSERT INTO DBVESTIB.CURSO
			(CODCONC,
			 NOMCUR,
			 CODCUR,
			 CODARE,
			 CODCAM,
			 COD_CURSO_SIAF)
		VALUES
			(CONC_DESTINO,
			 'Fict�cio',
			 '01',
			 'A',
			 '63', --butant�
			 5552);
	
		INSERT INTO DBVESTIB.CURSO_CAMPUS
			(CODCONC,
			 CODCUR,
			 CODCAM)
		VALUES
			(CONC_DESTINO,
			 '01',
			 '63');
	
		INSERT INTO DBVESTIB.RCURTUR
			(CODCONC,
			 CODCUR,
			 CODTUR,
			 CODCAM,
			 VALINS,
			 VALMENS)
		VALUES
			(CONC_DESTINO,
			 '01',
			 '01',
			 '63',
			 0,
			 0);
	
		-- opcao de curso / op. lingua
		INSERT INTO DBVESTIB.RCURTUROPC
			(CODCONC,
			 CODCUR,
			 CODTUR,
			 OPCLIN,
			 CODCAM)
		VALUES
			(CONC_DESTINO,
			 '01',
			 '01',
			 0,
			 '63');
	
		-- CURSO/TURNO/ETAPA
		INSERT INTO DBVESTIB.CURSO_TURNO_ETAPA
			(COD_ETAPA,
			 CODCONC,
			 CODCUR,
			 CODTUR,
			 CODCAM)
		VALUES
			(1,
			 CONC_DESTINO,
			 '01',
			 '01',
			 '63');
		COMMIT;
	END LOOP;
END;
