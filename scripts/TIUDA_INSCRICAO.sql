CREATE OR REPLACE TRIGGER "DBVESTIB"."TIUDA_INSCRICAO" 
AFTER UPDATE OR INSERT ON DBVESTIB.INSCRICAO

DECLARE

	N_CODRCO         DBTELEMAR.RESULTADOCONTATO.CODRCO%TYPE;
	N_CODCLI         DBTELEMAR.CLIENTES.CODCLI%TYPE;
	N_CODCAM         DBVESTIB.PARAMETROS_CONCURSO.CODCAMPANHA%TYPE;
	V_DAT_VENCIMENTO DBVESTIB.INSCRICAO.DAT_VENCIMENTO%TYPE;
	N_JA_EXISTE      NUMBER;

BEGIN

	-- ================
	IF INSERTING THEN
		-- ===============
		IF DBSIAF.F_BUSCA_FUNCIONARIO(USER) <> 13391 THEN
			FOR V_LOOPINDEX IN 1 .. PC_INSCRICAO_MUT_TBL.VNUMLINHAS LOOP
			
				-- =================================
				-- insere cliente no Telemar
				-- =================================
				DBVESTIB.PC_INSCRICAO.SP_INTEGRA_INSC_CLIENTE(PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
															  PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC,
															  N_CODCLI,
															  N_CODCAM);
			
			END LOOP;
		END IF;
		PC_INSCRICAO_MUT_TBL.VNUMLINHAS := 0;
		-- ================
	ELSIF UPDATING
		  AND NOT DBVESTIB.PC_INSCRICAO.BJAFEZUPDATEINSCRICAO THEN
		-- evitando loop
		-- ================  
		FOR V_LOOPINDEX IN 1 .. DBVESTIB.PC_INSCRICAO_MUT_TBL.VNUMLINHAS LOOP
		
			IF DBVESTIB.PC_INSCRICAO_MUT_TBL.VNUMLINHAS = 0 THEN
				EXIT;
			END IF;
			-- =================================
			-- atualiza cliente no Telemar
			-- =================================      
			DBVESTIB.PC_INSCRICAO.SP_INTEGRA_INSC_CLIENTE(PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
														  PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC,
														  N_CODCLI,
														  N_CODCAM);
		
			-- =====================
			-- confirmando pagamento inscri��o
			-- =====================
			IF ((PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).DATPGTO IS NULL OR PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).COD_STATUS_INSCRICAO <> 2) AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).DATPGTO IS NOT NULL) THEN
				-- =====
				-- adicionando resultado no Telemar e atualizando cliente - Inscr/Confirma��o de pagamento
			
				BEGIN
				
					DBVESTIB.PC_INSCRICAO.SP_ADICIONAR_RESULTADO(N_CODCLI,
																 N_CODCAM,
																 139,
																 NULL,
																 DBTELEMAR.PC_RELACIONAMENTO.F_CIRCUITO(N_CODCLI,
																										N_CODCAM,
																										4));
					DBVESTIB.PC_INSCRICAO.BJAFEZUPDATEINSCRICAO := TRUE;
					SP_CONFIRMA_INSC_INTERNET(PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
											  PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC);
					DBVESTIB.PC_INSCRICAO.BJAFEZUPDATEINSCRICAO := FALSE;
				
				EXCEPTION
					WHEN OTHERS THEN
						DBVESTIB.PC_INSCRICAO.BJAFEZUPDATEINSCRICAO := FALSE;
				END;
			
				IF PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).COD_STATUS_INSCRICAO = 4 THEN
					DBVESTIB.PC_EXTENSAO.SP_ATUALIZA_STATUS(PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
															PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC,
															7);
				ELSE
					DBVESTIB.PC_EXTENSAO.SP_ATUALIZA_STATUS(PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
															PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC,
															2);
				END IF;
			
				-- ==================================
				-- inscricao completa
				-- ==================================
			ELSIF ((PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).COD_STATUS_INSCRICAO IS NULL AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_STATUS_INSCRICAO = 1) AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_TPO_ENVIO IS NULL) THEN
				-- =====
			
				-- adicionando resultado no Telemar e atualizando cliente - Insc/Email enviado/Inscri��o completa      
				V_DAT_VENCIMENTO := PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).DAT_VENCIMENTO;
				DBVESTIB.PC_INSCRICAO.SP_ADICIONAR_RESULTADO(N_CODCLI,
															 N_CODCAM,
															 159,
															 'Boleto vence dia ' || TO_CHAR(V_DAT_VENCIMENTO,
																							'DD/MM/YYYY'),
															 DBTELEMAR.PC_RELACIONAMENTO.F_CIRCUITO(N_CODCLI,
																									N_CODCAM,
																									1));
			
				-- ==================================
				-- renova��o do boleto
				-- ==================================
			ELSIF (PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_STATUS_INSCRICAO = 1 AND PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).DAT_VENCIMENTO IS NOT NULL AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).DAT_VENCIMENTO IS NOT NULL AND PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).DAT_VENCIMENTO <> PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).DAT_VENCIMENTO) THEN
				-- =====
			
				-- verifica se j� existe renova��o de boleto ou inscri��o completa no mesmo dia para evitar inser��o de resultados desnecess�rios
				SELECT COUNT(1)
				  INTO N_JA_EXISTE
				  FROM DBTELEMAR.CONTATO CON
				 WHERE CON.CODCLI = N_CODCLI
					   AND CON.CODRCO IN (159,
										  169)
					   AND TRUNC(CON.DATCON) = TRUNC(SYSDATE);
			
				IF N_JA_EXISTE = 0 THEN
				
					V_DAT_VENCIMENTO := PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).DAT_VENCIMENTO;
					DBVESTIB.PC_INSCRICAO.SP_ADICIONAR_RESULTADO(N_CODCLI,
																 N_CODCAM,
																 169,
																 TO_CHAR(V_DAT_VENCIMENTO,
																		 'DD/MM/YYYY'),
																 DBTELEMAR.PC_RELACIONAMENTO.F_CIRCUITO(N_CODCLI,
																										N_CODCAM,
																										4));
				
				END IF;
			
				-- ==================================
				-- escolhido modo de envio de boleto
				-- ==================================
			ELSIF (PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).COD_TPO_ENVIO IS NULL AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_TPO_ENVIO IS NOT NULL) THEN
				-- =====
			
				BEGIN
					SELECT TIP.CODRCO
					  INTO N_CODRCO
					  FROM DBVESTIB.TIPO_ENVIO_BOLETO TIP
					 WHERE TIP.COD_TPO_ENVIO = PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_TPO_ENVIO
						   AND PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).COD_TPO_ENVIO IS NOT NULL;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						NULL;
				END;
			
				IF (N_CODRCO IS NOT NULL) THEN
				
					DBVESTIB.PC_INSCRICAO.SP_ADICIONAR_RESULTADO(N_CODCLI,
																 N_CODCAM,
																 N_CODRCO,
																 NULL,
																 DBTELEMAR.PC_RELACIONAMENTO.F_CIRCUITO(N_CODCLI,
																										N_CODCAM,
																										4));
				
				END IF;
			
			END IF;
			-- =====
		
			IF UPDATING
			   AND DBVESTIB.PC_CONCURSO_MUT_TBL.BATUALIZACANDIDATO
			   AND PC_INSCRICAO_MUT_TBL.VINSCRICAO_OLD(V_LOOPINDEX).DATPGTO IS NOT NULL THEN
				DBVESTIB.PC_CONCURSO_MUT_TBL.BATUALIZAINSCRICAO := FALSE;
				DBVESTIB.SP_ATUALIZA_CANDIDATO(DBVESTIB.PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODCONC,
											   DBVESTIB.PC_INSCRICAO_MUT_TBL.VINSCRICAO(V_LOOPINDEX).CODINSC);
				DBVESTIB.PC_CONCURSO_MUT_TBL.BATUALIZAINSCRICAO := TRUE;
			END IF;
		
		END LOOP;
	
		PC_INSCRICAO_MUT_TBL.VNUMLINHAS := 0;
		-- =====
	END IF;
	-- =====

END TIUDA_INSCRICAO;
/