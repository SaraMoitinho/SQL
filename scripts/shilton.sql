DECLARE

	CURSOR C_GRADE IS
		SELECT 'Disciplina/Atividades Curriculares' TITULO,
			   TRIM(VGC.NOMDISCIPLINA) ITEM,
			   TRIM(VGC.SGL_DISCIPLINA) SGLITEM,
			   VGC.VALCARGATOTAL CARGAHORARIA,
			   TO_CHAR(NVL(VGC.NUMCREDITOSTOTAL,
						   0)) NUMCREDITOSTOTAL,
			   VGC.DSCTURNO DSCTURNO,
			   TRIM(VGC.DSCNATDISCIPLINA) DSCNATDISCIPLINA,
			   TRIM(VGC.CICLOMODULO) CICLOMODULO,
			   VGC.CODOCORRENCIA CODOCORRENCIA,
			   REPLACE(TRIM(VGC.DSCEMENTA),
					   '''',
					   '') DSCEMENTA,
                     
     TRIM(VGC.NOM_CAMPUS) NOMCAMPUS 
			  
		  FROM DBSIAF.VW_GRADE_CURSO_PUBLICADA VGC
		 INNER JOIN "curso"@DBL_SITE_UNIBH C
			ON C."cod_curso_siaf" = VGC.COD_CURSO
		 WHERE C."cod_curso" = 16
			   AND VGC.CODGRDCURRICULAR = 14609
			   AND ((VGC.COD_TURNO = 1 AND 1 IS NOT NULL) OR (VGC.COD_TURNO IS NULL AND 1 IS NULL))
			   AND ((VGC.COD_CAMPUS = 2 AND 2 IS NOT NULL) OR (VGC.COD_CAMPUS IS NULL AND 2 IS NULL))
		UNION
		SELECT 'Qualificação' TITULO,
			   TRIM(DECODE(ING.COD_GRD_QUALIFICACAO,
						   NULL,
						   '<< Comum >>',
						   QUO.DSC_QUALIFICADOR)) ITEM,
			   NULL SGLITEM,
			   SUM(NVL(ING.VAL_CARGA_HORARIA,
					   0)) CARGAHORARIA,
			   TO_CHAR(SUM(NVL(ING.NUM_CREDITOS,
							   0))) NUMCREDITOSTOTAL,
			   (SELECT DISTINCT VGC.DSCTURNO
				  FROM DBSIAF.VW_GRADE_CURSO_PUBLICADA VGC
				 WHERE VGC.CODGRDCURRICULAR = 14609
					   AND ((VGC.COD_TURNO = 1 AND 1 IS NOT NULL) OR (VGC.COD_TURNO IS NULL AND 1 IS NULL))
					   AND ((VGC.COD_CAMPUS = 2 AND 2 IS NOT NULL) OR (VGC.COD_CAMPUS IS NULL AND 2 IS NULL))) DSCTURNO,
			   TRIM(NAT.DSC_NAT_DISCIPLINA) DSCNATDISCIPLINA,
			   'Integralização' CICLOMODULO,
			   NULL CODOCORRENCIA,
			   '' DSCEMENTA,
			   (SELECT DISTINCT VGC.NOM_CAMPUS
				  FROM DBSIAF.VW_GRADE_CURSO_PUBLICADA VGC
				 WHERE VGC.CODGRDCURRICULAR = 14609
					   AND ((VGC.COD_TURNO = 1 AND 1 IS NOT NULL) OR (VGC.COD_TURNO IS NULL AND 1 IS NULL))
					   AND ((VGC.COD_CAMPUS = 2 AND 2 IS NOT NULL) OR (VGC.COD_CAMPUS IS NULL AND 2 IS NULL))) NOMCAMPUS
                   
		  FROM DBSIAF.INTEGRALIZA_GRADE ING
		  LEFT JOIN DBSIAF.GRADE_QUALIFICACAO GRQ
			ON GRQ.COD_GRD_QUALIFICACAO = ING.COD_GRD_QUALIFICACAO
		  LEFT JOIN DBSIAF.QUALIFICACAO QUA
			ON QUA.COD_QUALIFICACAO = GRQ.COD_QUALIFICACAO
		  LEFT JOIN DBSIAF.QUALIFICADOR QUO
			ON QUO.COD_QUALIFICADOR = QUA.COD_QUALIFICADOR
		 INNER JOIN DBSIAF.NATUREZA_DISCIPLINA NAT
			ON NAT.COD_NAT_DISCIPLINA = ING.COD_NAT_DISCIPLINA
		 WHERE ING.COD_GRD_CURRICULAR = 14609
		 GROUP BY ING.COD_GRD_CURRICULAR,
				  ING.COD_GRD_QUALIFICACAO,
				  ING.COD_NAT_DISCIPLINA,
				  DECODE(ING.COD_GRD_QUALIFICACAO,
						 NULL,
						 '<< Comum >>',
						 QUO.DSC_QUALIFICADOR),
				  NAT.DSC_NAT_DISCIPLINA
		 ORDER BY NOMCAMPUS     ASC,
				  DSCTURNO      ASC,
				  CODOCORRENCIA ASC;
 S_SQL_INSERT     VARCHAR2(4000);         
 	N_ORD            PLS_INTEGER;         
BEGIN
	FOR R_INSERIR_GRADE_CURRICULAR IN C_GRADE LOOP
        N_ORD := 1;
		S_SQL_INSERT := 'INSERT INTO "grade_curricular"@DBL_SITE_UNIBH
			 ("cod_curso",
			   "nom_titulo",
			   "nom_item",
			   "sgl_item",
			   "val_carga_horaria",
			   "num_creditos",
			   "nom_turno",
			   "nom_natureza",
			   "nom_periodo",
			   "ord_grade_curricular",
			   "dsc_ementa",
			   "nom_campus")
			  VALUES (' || 16 || ',
					  ''' || R_INSERIR_GRADE_CURRICULAR.TITULO || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.ITEM || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.SGLITEM || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.CARGAHORARIA || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.NUMCREDITOSTOTAL || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.DSCTURNO || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.DSCNATDISCIPLINA || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.CICLOMODULO || ''',
					  ''' || N_ORD || ''',
					  ''' || SUBSTR(R_INSERIR_GRADE_CURRICULAR.DSCEMENTA,
														   0,
														   995) || ''',
					  ''' || R_INSERIR_GRADE_CURRICULAR.NOMCAMPUS || ''')';
	
		EXECUTE IMMEDIATE S_SQL_INSERT;
		COMMIT;
	END LOOP;
END;
