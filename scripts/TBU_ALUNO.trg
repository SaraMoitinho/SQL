CREATE OR REPLACE TRIGGER DBSIAF.TBU_ALUNO 
BEFORE UPDATE ON DBSIAF.ALUNO 
FOR EACH ROW 
DECLARE

	-- ************************************************
	-- UNIBH - Centro Universitario de Belo Horizonte
	-- **********************************************
	-- Responsavel      : Paulo Henrique Nonaka
	-- Criado           : 08/2007
	-- Objetivo Inicial : tratar o indicador 
	--                    IND_IMP_CUR_ORIGEM
	-- **********************************************

	-- ====================
	-- == Variáveis
	-- ====================
	NERRO     NUMBER;
	NNOMCURSO DBSIAF.CURSO.NOM_CURSO%TYPE;

BEGIN

	-- ===============================================================
	-- == O indicador não pode ser desmarcado caso cod_curso_destino 
	-- == esteja nulo no curso do aluno
	-- ===============================================================
	IF DBSIAF.F_BUSCA_FUNCIONARIO(USER) <> 13391 THEN
		IF :NEW.IND_IMP_CUR_ORIGEM = 'N' THEN
		
			NERRO := 0;
		
			SELECT DECODE(CR.COD_CURSO_DESTINO,
						  NULL,
						  1,
						  0),
				   CR.NOM_CURSO
			  INTO NERRO,
				   NNOMCURSO
			  FROM CURSO CR
			 WHERE CR.COD_CURSO = :OLD.COD_CURSO;
		
			IF NERRO = 1 THEN
				RAISE_APPLICATION_ERROR(-20600,
										'Não será possível desmarcar o indicador para imprimir o curso de origem do aluno ' || :NEW.NUM_MATRICULA || ', pois não existe um curso destino relacionado na tela de cadastro do curso ' || NNOMCURSO || ' ... ');
			END IF;
		
		END IF;
	END IF;
	IF UPDATING THEN
		-- O alunos só pode passar para status "remanejado" via processo de remanejamento
		IF (:NEW.COD_STA_ALUNO = 9)
		   AND (:OLD.COD_STA_ALUNO <> 9)
		   AND (NOT PC_REMANEJAMENTO.BREMANEJANDO) THEN
			RAISE_APPLICATION_ERROR(-20600,
									'Este status não pode ser alterado manualmente. ');
		END IF;
		-- O alunos com status "remanejado" só pode ter seu status alterado pelo processo de remanejamento.
		IF (:NEW.COD_STA_ALUNO <> 9)
		   AND (:OLD.COD_STA_ALUNO = 9)
		   AND (NOT PC_REMANEJAMENTO.BREMANEJANDO) THEN
			RAISE_APPLICATION_ERROR(-20600,
									'Este status não pode ser alterado manualmente. ');
		END IF;
	END IF;

	-- ==

EXCEPTION
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20600,
								SQLERRM);
	
END TAUI_ALUNO;
/
