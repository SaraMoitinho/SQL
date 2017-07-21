CREATE OR REPLACE PACKAGE DBVESTIB."PC_IMPORTA_DADOS" IS

	PROCEDURE SP_IMPORTA_FICHA_INSC(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_ARQ_RETORNO(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									 P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									 P_NUM_REGISTROS_LIDOS  OUT int,
									 P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_FOLHA_RESP(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_FOLHA_RESP_AUS(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
										P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
										P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
										P_NUM_REGISTROS_LIDOS  OUT int,
										P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_FOLHA_RED(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
								   P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
								   P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
								   P_NUM_REGISTROS_LIDOS  OUT int,
								   P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_NOTA_PROVA(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_CODPRO               IN DBVESTIB.PROVA.CODPRO%TYPE,
									P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_GRAVA_LOG(FILE_HANDLE_LOG IN UTL_FILE.FILE_TYPE,
						   SLINHA          IN VARCHAR2);

	PROCEDURE SP_IMPORTA_FICHA_FABRAI(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									  P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									  P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
									  P_NUM_REGISTROS_LIDOS  OUT int,
									  P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_FICHA_INSC_FIAT(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
										 P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
										 P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
										 P_NUM_REGISTROS_LIDOS  OUT int,
										 P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

	PROCEDURE SP_IMPORTA_FICHA_INSC_FUNCESI(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
											P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
											P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
											P_NUM_REGISTROS_LIDOS  OUT int,
											P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE);

END PC_IMPORTA_DADOS;
/
CREATE OR REPLACE PACKAGE BODY DBVESTIB.PC_IMPORTA_DADOS IS

	FILE_HANDLE_LOG UTL_FILE.FILE_TYPE;
	F               UTL_FILE.FILE_TYPE;
	SCABECALHO      VARCHAR2(1000);
	SLINHA          VARCHAR2(1000);
	SLINHALIMITE    VARCHAR2(1000);
	SLINHABRANCO    VARCHAR2(1000);

	-- ====================================================================================                                                                                                                            
	-- ===================        SP_IMPORTA_FICHA_INSC        ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	-- ===================================================================                                                                                                                                             
	-- LAYOUT DO ARQUIVO TEXTO GERADO PELA FICHA DE INSCRIÇÃO                                                                                                                                                          
	-- ===================================================================                                                                                                                                             
	-- ==      CAMPO          ==    POSIÇÃO INICIAL    ==    TAMANHO    ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- == BRANCOS             ==           1           ==       40      ==                                                                                                                                             
	-- == CODIGO              ==          41           ==        6      ==                                                                                                                                             
	-- == NOME                ==          47           ==       39      ==                                                                                                                                             
	-- == SEXO                ==          86           ==        1      ==                                                                                                                                             
	-- == CANHOTO             ==          87           ==        1      ==                                                                                                                                             
	-- == LINGUA              ==          88           ==        1      ==                                                                                                                                             
	-- == DEFICIENTE          ==          89           ==        1      ==                                                                                                                                             
	-- == TIPO DO DOCUMENTO   ==          90           ==        1      ==                                                                                                                                             
	-- == NÚMERO DO DOCUMENTO ==          91           ==       12      ==                                                                                                                                             
	-- == ESTADO EMISSOR      ==         103           ==        2      ==                                                                                                                                             
	-- == DATA DE NASCIMENTO  ==         105           ==        6      ==                                                                                                                                             
	-- == DATA DE INSCRIÇÃO   ==         111           ==        6      ==                                                                                                                                             
	-- == CURSO/TURNO         ==         117           ==        3      ==                                                                                                                                             
	-- == SOCECO              ==         120           ==      250      ==                                                                                                                                             
	-- == ENDEREÇO            ==         370           ==       34      ==                                                                                                                                             
	-- == BAIRRO              ==         404           ==       22      ==                                                                                                                                             
	-- == CIDADE              ==         426           ==       23      ==                                                                                                                                             
	-- == CEP                 ==         449           ==        8      ==                                                                                                                                             
	-- == TELEFONE            ==         457           ==       10      ==                                                                                                                                             
	-- == ESTADO              ==         467           ==        2      ==                                                                                                                                             
	-- == TREINANTE           ==         469           ==        1      ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             

	PROCEDURE SP_IMPORTA_FICHA_INSC(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VDATNASCAN_AUX CHAR(6);
		VDATINSCAN_AUX CHAR(6);
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VNOMCAN        CANDIDATO.NOMCAN%TYPE;
		VSEXCAN        CANDIDATO.SEXCAN%TYPE;
		VCODCUR        RCANDCURTUROPC.CODCUR%TYPE;
		VCODTUR        RCANDCURTUROPC.CODTUR%TYPE;
		VOPCLIN        RCANDCURTUROPC.OPCLIN%TYPE;
		VDEFCAN        TIPO_DEFICIENCIA.CODTPODEF%TYPE;
		VCODTPODEF     CANDIDATO.CODTPODEF%TYPE;
		VIND_TREINANTE CANDIDATO.IND_TREINANTE%TYPE;
		VCANHOTO       CANDIDATO.CANHOTO%TYPE;
		VTIPDOC        CANDIDATO.CODCAN%TYPE;
		VIDECAN        CANDIDATO.IDECAN%TYPE;
		VESTDOC        CANDIDATO.ESTCAN%TYPE;
		VNOMIDECAN     CANDIDATO.NOMIDECAN%TYPE;
		VEXPIDECAN     CANDIDATO.EXPIDECAN%TYPE;
		VSTRSOCECO     CANDIDATO.STR_SOCECO%TYPE;
		VDATNASCAN     CANDIDATO.DATNASCAN%TYPE;
		VDATINSCAN     CANDIDATO.DATINSCAN%TYPE;
		VENDCAN        CANDIDATO.ENDCAN%TYPE;
		VBAICAN        CANDIDATO.BAICAN%TYPE;
		VCIDCAN        CANDIDATO.CIDCAN%TYPE;
		VCEPCAN        CANDIDATO.CEPCAN%TYPE;
		VTELCAN        CANDIDATO.TELCAN%TYPE;
		VESTCAN        CANDIDATO.ESTCAN%TYPE;
		VFLGERRO       NUMBER;
		VDATPGTO       INSCRICAO.DATPGTO%TYPE;
		VEMAILCAN      CANDIDATO.EMAIL%TYPE;
	
	BEGIN
	
		UTL_FILE.FCLOSE_ALL;
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FI_' || TO_CHAR(SYSDATE,
												   'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - FICHAS DE INSCRICAO';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		IF LENGTH(SBUFFER) <> 472 THEN
			SLINHA := 'Arquivo nao e de fichas de inscricao';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		--  UTL_FILE.FCLOSE(f);                                                                                                                                                                                            
	
		--  UTL_FILE.FCLOSE_ALL;                                                                                                                                                                                           
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		--  f := utl_file.fopen( f_DADOS_FTP( 5 ), p_nom_arquivo, 'r' );                                                                                                                                                   
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
			
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF LENGTH(SBUFFER) <> 472 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN        := SUBSTR(SBUFFER,
										 41,
										 6);
				VNOMCAN        := SUBSTR(SBUFFER,
										 47,
										 39);
				VSEXCAN        := SUBSTR(SBUFFER,
										 86,
										 1);
				VCANHOTO       := SUBSTR(SBUFFER,
										 87,
										 1);
				VOPCLIN        := SUBSTR(SBUFFER,
										 88,
										 1);
				VDEFCAN        := SUBSTR(SBUFFER,
										 89,
										 1);
				VDATNASCAN_AUX := SUBSTR(SBUFFER,
										 105,
										 6);
				VDATINSCAN_AUX := SUBSTR(SBUFFER,
										 111,
										 6);
				VCODCUR        := SUBSTR(SBUFFER,
										 117,
										 2);
				VCODTUR        := SUBSTR(SBUFFER,
										 119,
										 1);
			
				-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                       
			
				-- Muitos candidatos marcam a opção de língua estrangeira, mesmo para os cursos que não tem.                                                                                                                 
				-- Portanto, coloco a opção 0 para os cursos diferentes de Letras.                                                                                                                                           
				IF ((VCODCUR NOT IN ('10',
									 '11')) OR (P_CODCONC = '043'))
				   AND (P_CODCONC <> '050') THEN
					VOPCLIN := '0';
				END IF;
			
				-- Troca a opção de língua                                                                                                                                                                                   
				IF (VOPCLIN = 'I') THEN
					VOPCLIN := '1';
				ELSIF (VOPCLIN = 'F') THEN
					VOPCLIN := '2';
				ELSIF (VOPCLIN = 'E') THEN
					VOPCLIN := '3';
				ELSIF (VOPCLIN IS NULL)
					  OR (VOPCLIN = ' ') THEN
					VOPCLIN := '0';
				END IF;
			
				-- Problema do curso de Fisioterapia.                                                                                                                                                                        
				IF (VCODCUR = '06' AND VCODTUR = '2') THEN
					VCODCUR := '21';
				END IF;
				IF (VCODCUR = '14' AND VCODTUR = '1') THEN
					VCODCUR := '22';
				END IF;
			
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
			
				-- Verificando se a data de nascimento do candidato é válida                                                                                                                                                 
				BEGIN
					SELECT TO_DATE(VDATNASCAN_AUX,
								   'DDMMRR')
					  INTO VDATNASCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Nascimento do Candidato (Posicao: 105) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se a data de inscrição do candidato é válida                                                                                                                                                  
				BEGIN
					SELECT TO_DATE(VDATINSCAN_AUX,
								   'DDMMYY')
					  INTO VDATINSCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Inscricao do Candidato (Posicao: 111) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se existe a opção de língua marcada pelo candidato                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM OPCLINGUA
				 WHERE OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 88';
					SLINHA := SLINHA || ' - Nao existe esta opcao de lingua estrangeira moderna. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se o Sexo eh igual a "F" ou "M"                                                                                                                                                               
				IF (VSEXCAN <> 'F' AND VSEXCAN <> 'M') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 86';
					SLINHA := SLINHA || ' - O Sexo esta diferente de "F" ou "M". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se o campo Canhoto eh igual a "S" ou "N"                                                                                                                                                      
				IF (VCANHOTO <> 'S' AND VCANHOTO <> 'N') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 86';
					SLINHA := SLINHA || ' - O campo Canhoto esta diferente de "S" ou "N". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o turno marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM TURNO
				 WHERE CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117';
					SLINHA := SLINHA || ' - Nao existe este turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CURSO
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 119';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno marcado pelo candidato                                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUR
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117 e 119';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno/opção de língua marcado pelo candidato                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUROPC
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR
					   AND OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117, 119 e 88';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno/opcao de lingua. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
			/*      sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan ;                                                                                                              
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                */
			END LOOP;
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		IF VFLGERRO > 0 THEN
			DBMS_OUTPUT.PUT_LINE('NAO FORAM IMPORTADOS NENHUM REGISTRO.');
		
			SLINHA := 'NAO FORAM IMPORTADOS NENHUM REGISTRO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE(F);
			RAISE_APPLICATION_ERROR(-20500,
									'x');
		END IF;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF LENGTH(SBUFFER) <> 469 THEN
				-- Grava o resto da importação                                                                                                                                                                               
				COMMIT;
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				UTL_FILE.FCLOSE_ALL;
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN        := TRIM(SUBSTR(SBUFFER,
										  41,
										  6));
			VNOMCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												47,
												39)));
			VSEXCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												86,
												1)));
			VCANHOTO       := UPPER(TRIM(SUBSTR(SBUFFER,
												87,
												1)));
			VOPCLIN        := TRIM(SUBSTR(SBUFFER,
										  88,
										  1));
			VDEFCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												89,
												1)));
			VTIPDOC        := TRIM(SUBSTR(SBUFFER,
										  90,
										  1));
			VIDECAN        := TRIM(SUBSTR(SBUFFER,
										  91,
										  12));
			VESTDOC        := TRIM(SUBSTR(SBUFFER,
										  103,
										  2));
			VDATNASCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  105,
										  6));
			VDATINSCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  111,
										  6));
			VCODCUR        := TRIM(SUBSTR(SBUFFER,
										  117,
										  2));
			VCODTUR        := TRIM(SUBSTR(SBUFFER,
										  119,
										  1));
			VSTRSOCECO     := SUBSTR(SBUFFER,
									 120,
									 250);
			VENDCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												370,
												34)));
			VBAICAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   404,
													   22),
												1,
												20)));
			VCIDCAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   426,
													   23),
												1,
												20)));
			VCEPCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												449,
												5) || '-' || SUBSTR(SBUFFER,
																	454,
																	3)));
			VTELCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												457,
												10)));
			VESTCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												467,
												2)));
			VIND_TREINANTE := UPPER(TRIM(SUBSTR(SBUFFER,
												469,
												1)));
		
			-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                         
		
			-- Converte para o formato data                                                                                                                                                                                
			VDATNASCAN := TO_DATE(VDATNASCAN_AUX,
								  'DDMMRR');
			VDATINSCAN := TO_DATE(VDATINSCAN_AUX,
								  'DDMMYY');
		
			-- Troca a opção de língua                                                                                                                                                                                     
			IF (VOPCLIN = 'I') THEN
				VOPCLIN := '1';
			ELSIF (VOPCLIN = 'F') THEN
				VOPCLIN := '2';
			ELSIF (VOPCLIN = 'E') THEN
				VOPCLIN := '3';
			ELSIF (VOPCLIN IS NULL)
				  OR (VOPCLIN = ' ') THEN
				VOPCLIN := '0';
			END IF;
		
			-- Troca o tipo do documento                                                                                                                                                                                   
			IF TRIM(VTIPDOC) = 1 THEN
				VTIPDOC    := '01';
				VNOMIDECAN := 'Cart.de Identidade';
				VEXPIDECAN := 'SSP/' || VESTDOC;
			ELSIF TRIM(VTIPDOC) = 2 THEN
				VTIPDOC    := '02';
				VNOMIDECAN := 'Cart.de Trabalho';
				VEXPIDECAN := 'MT';
			ELSIF TRIM(VTIPDOC) = 3 THEN
				VTIPDOC    := '03';
				VNOMIDECAN := 'Conselho Regional';
				VEXPIDECAN := 'CR';
			ELSIF TRIM(VTIPDOC) = 4 THEN
				VTIPDOC    := '04';
				VNOMIDECAN := 'Min. Ex./Aeron.';
				VEXPIDECAN := 'ME';
			ELSIF TRIM(VTIPDOC) = 5 THEN
				VTIPDOC    := '05';
				VNOMIDECAN := 'Passaporte';
				VEXPIDECAN := 'PF';
			ELSIF TRIM(VTIPDOC) = 6 THEN
				VTIPDOC    := '06';
				VNOMIDECAN := 'Policia Militar';
				VEXPIDECAN := 'PM';
			ELSIF TRIM(VTIPDOC) = 7 THEN
				VTIPDOC    := '07';
				VNOMIDECAN := 'O.A.B.';
				VEXPIDECAN := 'OAB';
			END IF;
		
			-- Muitos candidatos marcam a opção de língua estrangeira. Portanto,                                                                                                                                           
			-- coloco a opção 0 para os cursos diferentes de Letras.                                                                                                                                                       
			IF ((VCODCUR NOT IN ('10',
								 '11')) OR (P_CODCONC = '043'))
			   AND (P_CODCONC <> '050') THEN
				VOPCLIN := '0';
			END IF;
		
			-- Problema do curso de Fisioterapia.                                                                                                                                                                          
			IF (VCODCUR = '06' AND VCODTUR = '2') THEN
				VCODCUR := '21';
			END IF;
			IF (VCODCUR = '14' AND VCODTUR = '1') THEN
				VCODCUR := '22';
			END IF;
		
			IF ((TRIM(VIND_TREINANTE) = '') OR (VIND_TREINANTE IS NULL)) THEN
				VIND_TREINANTE := 'N';
			ELSIF VIND_TREINANTE = 'T' THEN
				VIND_TREINANTE := 'S';
			END IF;
		
			-- Troca o tipo de deficiencia                                                                                                                                                                                 
			IF (VDEFCAN IS NULL)
			   OR (VDEFCAN = ' ') THEN
				VDEFCAN := '03';
			ELSIF (VDEFCAN = 'V') THEN
				VDEFCAN := '01';
			ELSIF (VDEFCAN = 'F') THEN
				VDEFCAN := '02';
			END IF;
		
			-- Se o local de pagamento for o circuito universitario entao a data de pagamento = data inscricao                                                                                                             
			IF P_CODLOCPAG = '003' THEN
				VDATPGTO := VDATINSCAN;
			END IF;
		
			-- Verifica se o candidato existe na tabela de candidato e opção de curso (rcandcurturopc)                                                                                                                     
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CANDIDATO
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
		
			IF (X = 0) THEN
				-- Insere o candidato na tabela de candidatos                                                                                                                                                                
				INSERT INTO CANDIDATO
					(CODCONC,
					 CODCAN,
					 NOMCAN,
					 SEXCAN,
					 DATNASCAN,
					 IDECAN,
					 NOMIDECAN,
					 EXPIDECAN,
					 TELCAN,
					 ENDCAN,
					 BAICAN,
					 CIDCAN,
					 ESTCAN,
					 CEPCAN,
					 DATINSCAN,
					 DATPAGCAN,
					 CODLOCPAG,
					 SITCAN,
					 CLACAN,
					 CLACAN2,
					 CODLOC,
					 CODSAL,
					 EMAIL,
					 TOTPON,
					 TOTPON2,
					 CANHOTO,
					 TAG,
					 CODCANANT,
					 REGFCH,
					 FLGMAT,
					 DATINCCAN,
					 str_soceco,
					 SITCAN2,
					 CODTPODEF,
					 IND_TREINANTE,
					 SITCANGER,
					 CLACANGER)
				
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VNOMCAN,
					 VSEXCAN,
					 VDATNASCAN,
					 VIDECAN,
					 VNOMIDECAN,
					 VEXPIDECAN,
					 VTELCAN,
					 VENDCAN,
					 VBAICAN,
					 VCIDCAN,
					 VESTCAN,
					 VCEPCAN,
					 VDATINSCAN,
					 VDATPGTO,
					 P_CODLOCPAG,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NVL(VCANHOTO,
						 'N'),
					 'N',
					 NULL,
					 'N',
					 'N',
					 SYSDATE,
					 VSTRSOCECO,
					 NULL,
					 NVL(VDEFCAN,
						 '03'),
					 NVL(VIND_TREINANTE,
						 'N'),
					 NULL,
					 NULL);
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				INSERT INTO RCANDCURTUROPC
					(CODCONC,
					 CODCAN,
					 CODCUR,
					 CODTUR,
					 OPCLIN,
					 NROOPC)
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VCODCUR,
					 VCODTUR,
					 VOPCLIN,
					 '1');
			
			ELSE
				-- Atualiza os dados do candidato na tabela de candidatos                                                                                                                                                    
				UPDATE CANDIDATO
				   SET NOMCAN        = VNOMCAN,
					   SEXCAN        = VSEXCAN,
					   DATNASCAN     = VDATNASCAN,
					   IDECAN        = VIDECAN,
					   NOMIDECAN     = VNOMIDECAN,
					   EXPIDECAN     = VEXPIDECAN,
					   TELCAN        = VTELCAN,
					   ENDCAN        = VENDCAN,
					   BAICAN        = VBAICAN,
					   CIDCAN        = VCIDCAN,
					   ESTCAN        = VESTCAN,
					   CEPCAN        = VCEPCAN,
					   DATINSCAN     = VDATINSCAN,
					   DATPAGCAN     = VDATPGTO,
					   CODLOCPAG     = P_CODLOCPAG,
					   SITCAN        = NULL,
					   CLACAN        = NULL,
					   CLACAN2       = NULL,
					   CODLOC        = NULL,
					   CODSAL        = NULL,
					   EMAIL         = NULL,
					   TOTPON        = NULL,
					   TOTPON2       = NULL,
					   CANHOTO       = NVL(VCANHOTO,
										   'N'),
					   TAG           = 'N',
					   CODCANANT     = NULL,
					   REGFCH        = 'N',
					   FLGMAT        = 'N',
					   str_soceco    = VSTRSOCECO,
					   SITCAN2       = NULL,
					   CODTPODEF     = NVL(VDEFCAN,
										   '03'),
					   IND_TREINANTE = VIND_TREINANTE,
					   SITCANGER     = NULL,
					   CLACANGER     = NULL
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				UPDATE RCANDCURTUROPC
				   SET CODCUR = VCODCUR,
					   CODTUR = VCODTUR,
					   OPCLIN = VOPCLIN
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND NROOPC = '1';
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END;

	-- ====================================================================================                                                                                                                            
	-- ===================        SP_IMPORTA_ARQ_RETORNO       ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	PROCEDURE SP_IMPORTA_ARQ_RETORNO(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									 P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									 P_NUM_REGISTROS_LIDOS  OUT int,
									 P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X        NUMBER;
		VCODCONC CANDIDATO.CODCONC%TYPE;
		VCODCAN  CANDIDATO.CODCAN%TYPE;
		VDATPGTO INSCRICAO.DATPGTO%TYPE;
		VFLGERRO NUMBER;
		--  p_flg_confirma      number;                                                                                                                                                                                    
		P_GRAVA NUMBER;
	
	BEGIN
	
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'AR_' || TO_CHAR(SYSDATE,
												   'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - ARQUIVO DE RETORNO DO BANCO - (BANCO DO BRASIL / BOLETAS IMPRESSAS PELO CANDIDATO VIA INTERNET)';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 1 R');                                                                                                                                                                       
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 2 R');                                                                                                                                                                       
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		IF SUBSTR(SBUFFER,
				  1,
				  19) <> '02RETORNO01COBRANCA' THEN
			SLINHA := 'Arquivo nao e de retorno do Banco do Brasil';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		IF LENGTH(TRIM(SBUFFER)) <> 400 THEN
			SLINHA := 'Arquivo nao e de fichas de inscricao';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 3 R');                                                                                                                                                                       
	
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 1 C');                                                                                                                                                                       
	
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 2 C');                                                                                                                                                                       
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 3 C');                                                                                                                                                                   
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF (SUBSTR(SBUFFER,
						   1,
						   19) <> '02RETORNO01COBRANCA')
				   AND (SUBSTR(SBUFFER,
							   1,
							   1) <> '9') THEN
				
					IF LENGTH(TRIM(SBUFFER)) <> 400 THEN
						IF (VFLGERRO > 0) THEN
							SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																		'000000') || ' ERRO(S). ';
							SP_GRAVA_LOG(FILE_HANDLE_LOG,
										 SLINHA);
							SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																	  '000000') || ' REGISTRO(S). ';
							SP_GRAVA_LOG(FILE_HANDLE_LOG,
										 SLINHA);
						END IF;
						RAISE NO_DATA_FOUND;
					
					END IF;
					VCODCONC := SUBSTR(SBUFFER,
									   54,
									   3);
					VCODCAN  := SUBSTR(SBUFFER,
									   57,
									   6);
				
					--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 4 C');                                                                                                                                                                 
				
					-- ===================================================================                                                                                                                                     
					-- Consistindo o arquivo a ser importado                                                                                                                                                                   
					-- ===================================================================                                                                                                                                     
				
					-- Verificando se existem os candidatos no cadastro de inscrições                                                                                                                                          
					X := 0;
					SELECT COUNT(*)
					  INTO X
					  FROM INSCRICAO
					 WHERE CODCONC = VCODCONC
						   AND CODINSC = VCODCAN;
				
					--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 5 C');                                                                                                                                                                 
				
					IF (X = 0) THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 70';
						SLINHA := SLINHA || ' - Nao existe este candidato na base de dados da Internet. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
						VFLGERRO := VFLGERRO + 1;
					END IF;
				
				END IF;
			
			END LOOP;
		
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				UTL_FILE.FCLOSE(F);
		END;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
	
		UTL_FILE.FCLOSE(F);
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		IF VFLGERRO > 0 THEN
			SLINHA := 'NAO FORAM IMPORTADOS NENHUM REGISTRO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE(F);
			RAISE_APPLICATION_ERROR(-20500,
									'x');
		END IF;
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
	
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 1');                                                                                                                                                                         
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 2');                                                                                                                                                                       
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 3');                                                                                                                                                                       
		
			IF (SUBSTR(SBUFFER,
					   1,
					   19) <> '02RETORNO01COBRANCA')
			   AND (SUBSTR(SBUFFER,
						   1,
						   1) <> '9') THEN
				IF LENGTH(TRIM(SBUFFER)) <> 400 THEN
					-- Grava o resto da importação                                                                                                                                                                             
				
					COMMIT;
					SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SLINHA := 'No. de Registros importados: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
				
					UTL_FILE.FCLOSE_ALL;
				
					RAISE NO_DATA_FOUND;
				END IF;
			
				--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 4');                                                                                                                                                                          
			
				VCODCONC := SUBSTR(SBUFFER,
								   54,
								   3);
				VCODCAN  := SUBSTR(SBUFFER,
								   57,
								   6);
				VDATPGTO := TO_CHAR(TO_DATE(SUBSTR(SBUFFER,
												   111,
												   6),
											'DD-MM-YY'),
									'DD MM YYYY');
				-- Atualizo a data de pagamento                                                                                                                                                                               
				-- ALTEREI EM 23/10/2001, INCLUI A FORMAPGTO                                                                                                                                                                  
				UPDATE INSCRICAO
				   SET DATPGTO   = VDATPGTO,
					   FORMAPGTO = 'B'
				 WHERE CODCONC = VCODCONC
					   AND CODINSC = VCODCAN;
				--      SP_CONFIRMA_INSC_INTERNET ( vCodConc, vCodCan, p_grava);                                                                                                                                                   
			END IF;
		
		--DBMS_OUTPUT.PUT_LINE('PASSEI AQUI 5');                                                                                                                                                                       
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
	END SP_IMPORTA_ARQ_RETORNO;

	-- ====================================================================================                                                                                                                            
	-- ===================        SP_IMPORTA_FOLHA_RESP        ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	PROCEDURE SP_IMPORTA_FOLHA_RESP(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
	
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VCODETP        ETAPA.CODETP%TYPE;
		VRESPCAN       RESPOSTA.RESPCAN%TYPE;
		VTAMRESP       NUMBER;
		VFLGERRO       NUMBER;
		P_FLG_CONFIRMA NUMBER;
		BERRO          BOOLEAN;
		NINST          DBVESTIB.INSTITUICAO_ENSINO.CODINSTITUICAO%TYPE;
	
	BEGIN
	
		-- ==============================                                                                                                                                                                                
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		-- ==============================                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FRESP_' || TO_CHAR(SYSDATE,
													  'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
	
		-- ===================                                                                                                                                                                                           
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- ===================                                                                                                                                                                                           
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - ARQUIVO TEXTO CONTENDO AS FOLHAS DE RESPOSTAS DOS CANDIDATOS';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		NINST := DBVESTIB.F_INST_CONCURSO(P_CODCONC);
	
		IF NINST = 8 THEN
			VTAMRESP := 50;
		ELSE
			VTAMRESP := LENGTH(SBUFFER) - 48;
		END IF;
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		-- lê o arquivo até o final                                                                                                                                                                                      
		WHILE UTL_FILE.IS_OPEN(F) LOOP
		
			-- variavel de controle de erro
			BERRO := FALSE;
		
			IF NVL(LENGTH(TRIM(SBUFFER)),
				   0) = 0 THEN
				IF (VFLGERRO > 0) THEN
					SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																'000000') || ' ERRO(S). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
															  '000000') || ' REGISTRO(S). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
				END IF;
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN := SUBSTR(SBUFFER,
							  41,
							  6);
			IF NINST = 8 THEN
				VCODETP := SUBSTR(SBUFFER,
								  48,
								  1);
			ELSE
				VCODETP := SUBSTR(SBUFFER,
								  47,
								  1);
			END IF;
			-- ******************************************************************************                                                                                                                            
			-- NUNCA COLOCAR A FUNÇÃO TRIM NAS RESPOSTAS, POIS TEM CANDIDATO QUE NÃO MARCA --                                                                                                                            
			-- A PRIMEIRA QUESTÃO E SE COLOCAR TRIM HAVERÁ DESLOCAMENTO DAS RESPOSTAS.     --                                                                                                                            
			-- ******************************************************************************                                                                                                                            
			IF NINST = 8 THEN
				VRESPCAN := SUBSTR(SBUFFER,
								   53,
								   VTAMRESP);
			ELSE
				VRESPCAN := SUBSTR(SBUFFER,
								   48,
								   VTAMRESP);
			END IF;
		
			-- Verificando se existem os candidatos no cadastro de inscrições                                                                                                                                            
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CANDIDATO
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
			IF (X = 0) THEN
				SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
											   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
				SLINHA := SLINHA || ' - Nao existe este candidato na base de dados (Candidato). ';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				VFLGERRO := VFLGERRO + 1;
				BERRO    := TRUE;
			END IF;
		
			X := 0;
		
			-- Verificando se existe a etapa no cadastro de etapas                                                                                                                                                       
			SELECT COUNT(*)
			  INTO X
			  FROM ETAPA
			 WHERE CODCONC = P_CODCONC
				   AND CODETP = VCODETP
				   AND COD_ETAPA = P_COD_ETAPA;
		
			IF (X = 0) THEN
				SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
											   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 47';
				SLINHA := SLINHA || ' - Nao existe esta etapa na base de dados (Etapa). ';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				VFLGERRO := VFLGERRO + 1;
				BERRO    := TRUE;
			END IF;
		
			X := 0;
		
			-- Verificando se existe a resposta da prova deste candidato(a)                                                                                                                                              
			SELECT COUNT(*)
			  INTO X
			  FROM RESPOSTA
			 WHERE CODCONC = P_CODCONC
				   AND CODETP = VCODETP
				   AND CODCAN = VCODCAN
				   AND COD_ETAPA = P_COD_ETAPA;
		
			IF (X > 0) THEN
				/*sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan || ' - Posicao: 41';                                                                                          
                sLinha := sLinha || ' - A RESPOSTA DESTE CANDIDATO PARA A ETAPA ' || vCodEtp || ' JA EXISTE NA BASE DE DADOS.';                                                                                           
                SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                vFlgErro := vFlgErro + 1;
                */
				BERRO := TRUE;
			ELSIF NOT (BERRO) THEN
				INSERT INTO RESPOSTA
					(CODCONC,
					 CODETP,
					 CODCAN,
					 RESPCAN,
					 COD_ETAPA)
				VALUES
					(P_CODCONC,
					 VCODETP,
					 VCODCAN,
					 VRESPCAN,
					 P_COD_ETAPA);
				COMMIT;
			END IF;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
		END LOOP;
	
		SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHA);
		SLINHA := 'No. de Registros importados: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHA);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- Fecha o arquivo de log.                                                                                                                                                                                       
		UTL_FILE.FCLOSE(FILE_HANDLE_LOG);
	
	EXCEPTION
	
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                          
			COMMIT;
			SLINHA := 'NENHUM REGISTRO ENCONTRADO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			-- fim da leitura do arquivo                                                                                                                                                                 
			SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
		
	END SP_IMPORTA_FOLHA_RESP;

	-- ====================================================================================                                                                                                                            
	-- ===================      SP_IMPORTA_FOLHA_RESP_AUS      ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	PROCEDURE SP_IMPORTA_FOLHA_RESP_AUS(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
										P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
										P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
										P_NUM_REGISTROS_LIDOS  OUT int,
										P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VCODETP        ETAPA.CODETP%TYPE;
		VRESPCAN       RESPOSTA.RESPCAN%TYPE;
		VTAMRESP       NUMBER;
		VFLGERRO       NUMBER;
		P_FLG_CONFIRMA NUMBER;
	
	BEGIN
	
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FRESPAUS_' || TO_CHAR(SYSDATE,
														 'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - ARQUIVO TEXTO CONTENDO AS FOLHAS DE RESPOSTAS DOS CANDIDATOS AUSENTES/DESISTENTES';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		VTAMRESP := (LENGTH(TRIM(SBUFFER)) - 47);
	
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF NVL(LENGTH(TRIM(SBUFFER)),
					   0) = 0 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN  := SUBSTR(SBUFFER,
								   41,
								   6);
				VCODETP  := SUBSTR(SBUFFER,
								   47,
								   1);
				VRESPCAN := SUBSTR(SBUFFER,
								   48,
								   10);
			
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
			
				-- Verificando se existem os candidatos no cadastro de inscrições                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CANDIDATO
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - Nao existe este candidato na base de dados (Candidato). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a etapa no cadastro de etapas                                                                                                                                                       
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM ETAPA
				 WHERE CODCONC = P_CODCONC
					   AND CODETP = VCODETP
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 47';
					SLINHA := SLINHA || ' - Nao existe esta etapa na base de dados (Etapa). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a resposta da prova deste candidato(a)                                                                                                                                              
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RESPOSTA
				 WHERE CODCONC = P_CODCONC
					   AND CODETP = VCODETP
					   AND CODCAN = VCODCAN
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X > 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - A RESPOSTA DESTE CANDIDATO PARA A ETAPA ' || VCODETP || ' JA EXISTE NA BASE DE DADOS.';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a resposta da prova deste candidato(a)                                                                                                                                              
				IF NVL(LENGTH(TRIM(VRESPCAN)),
					   0) > 0 THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - A RESPOSTA DESTE CANDIDATO PARA A ETAPA ' || VCODETP || ' FOI PREENCHIDA.';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
			END LOOP;
		
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE_ALL;
		--UTL_FILE.FCLOSE(f);                                                                                                                                                                                              
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF TRIM(SBUFFER) = '' THEN
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SLINHA := 'No. de Registros importados: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN  := SUBSTR(SBUFFER,
							   41,
							   6);
			VCODETP  := SUBSTR(SBUFFER,
							   47,
							   1);
			VRESPCAN := SUBSTR(SBUFFER,
							   48,
							   VTAMRESP);
		
			-- Importa Definitivamente as folhas de resposta caso a resposta do candidato não for brancos                                                                                                                  
			IF (NVL(LENGTH(TRIM(VRESPCAN)),
					0) = 0) THEN
				-- Verifica se o existe a resposta do candidato na tabela de respostas                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RESPOSTA
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND CODETP = VCODETP
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X = 0) THEN
					-- Insere o candidato na tabela de respostas                                                                                                                                                              
					INSERT INTO RESPOSTA
						(CODCONC,
						 CODETP,
						 CODCAN,
						 RESPCAN,
						 COD_ETAPA)
					VALUES
						(P_CODCONC,
						 VCODETP,
						 VCODCAN,
						 ' ',
						 P_COD_ETAPA);
				ELSE
					UPDATE RESPOSTA
					   SET RESPCAN = ' '
					 WHERE CODCONC = P_CODCONC
						   AND CODCAN = VCODCAN
						   AND CODETP = VCODETP
						   AND COD_ETAPA = P_COD_ETAPA;
				END IF;
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END SP_IMPORTA_FOLHA_RESP_AUS;

	-- ====================================================================================                                                                                                                            
	-- ===================        SP_IMPORTA_FOLHA_RED         ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	PROCEDURE SP_IMPORTA_FOLHA_RED(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
								   P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
								   P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
								   P_NUM_REGISTROS_LIDOS  OUT int,
								   P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VCODETP        ETAPA.CODETP%TYPE;
		VCODPRO        NOTAPROVA.CODPRO%TYPE;
		VCODCUR        CURSO.CODCUR%TYPE;
		VPONTOS        CHAR(2);
		VPONTOS_AUX    NUMBER;
		VTOTPON        NUMBER;
		VFLGERRO       NUMBER;
		P_FLG_CONFIRMA NUMBER;
	
	BEGIN
	
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FRED_' || TO_CHAR(SYSDATE,
													 'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - ARQUIVO TEXTO CONTENDO A NOTA DE REDACAO DOS CANDIDATOS';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF NVL(LENGTH(TRIM(SBUFFER)),
					   0) = 0 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN := SUBSTR(SBUFFER,
								  41,
								  6);
				VCODETP := SUBSTR(SBUFFER,
								  47,
								  1);
				VPONTOS := SUBSTR(SBUFFER,
								  48,
								  2);
			
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
			
				-- Verificando se existem os candidatos no cadastro de candidatos                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CANDIDATO
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - Nao existe este candidato na base de dados (Candidato). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a etapa no cadastro de etapas                                                                                                                                                       
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM ETAPA
				 WHERE CODCONC = P_CODCONC
					   AND CODETP = VCODETP
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 47';
					SLINHA := SLINHA || ' - Nao existe esta etapa na base de dados (Etapa). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Busca o código da prova de Redação                                                                                                                                                                        
				SELECT CODPRO
				  INTO VCODPRO
				  FROM PROVA
				 WHERE NOMPRORED = 'RED';
			
				-- Verificando se existe a nota de redacao deste candidato(a)                                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM NOTAPROVA
				 WHERE CODCONC = P_CODCONC
					   AND CODPRO = VCODPRO
					   AND CODCAN = VCODCAN
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X > 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - JA EXISTE NOTA DA PROVA ' || VCODPRO || ' (REDACAO) NA BASE DE DADOS.';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verifica se os pontos gravados são válidos                                                                                                                                                                
				BEGIN
					SELECT TO_NUMBER(VPONTOS)
					  INTO VPONTOS_AUX
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Total de Pontos do Candidato (Posicao: 48) e invalido. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
			END LOOP;
		
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF TRIM(SBUFFER) = '' THEN
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SLINHA := 'No. de Registros importados: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN := SUBSTR(SBUFFER,
							  41,
							  6);
			VCODETP := SUBSTR(SBUFFER,
							  47,
							  1);
			VPONTOS := SUBSTR(SBUFFER,
							  48,
							  2);
		
			-- Importa Definitivamente a nota de redação dos candidatos                                                                                                                                                    
		
			-- Busca o curso do candidato na tabela rcandcurturopc                                                                                                                                                         
			SELECT CODCUR
			  INTO VCODCUR
			  FROM RCANDCURTUROPC
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN
				   AND NROOPC = '1';
		
			-- Calcula o peso da prova de redação                                                                                                                                                                          
			VPONTOS_AUX := TO_NUMBER(VPONTOS);
			SELECT (DBVESTIB.PC_CLASSIFICACAO.F_PESO_PROVA(P_CODCONC,
														   VCODCUR,
														   VCODPRO,
														   P_COD_ETAPA) * VPONTOS_AUX)
			  INTO VTOTPON
			  FROM DUAL;
		
			-- Verifica se existe a nota de redacao do candidato na tabela (NotaProva)                                                                                                                                     
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM NOTAPROVA
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN
				   AND CODPRO = VCODPRO
				   AND COD_ETAPA = P_COD_ETAPA;
		
			IF (X = 0) THEN
				-- Insere o candidato na tabela de notas de prova                                                                                                                                                            
				INSERT INTO NOTAPROVA
					(CODCONC,
					 CODPRO,
					 CODCAN,
					 NROQUEACT,
					 PONPROPES,
					 PONPROPES2,
					 COD_ETAPA)
				VALUES
					(P_CODCONC,
					 VCODPRO,
					 VCODCAN,
					 VPONTOS_AUX,
					 VTOTPON,
					 VTOTPON,
					 P_COD_ETAPA);
			ELSE
				UPDATE NOTAPROVA
				   SET NROQUEACT  = VPONTOS_AUX,
					   PONPROPES  = VTOTPON,
					   PONPROPES2 = VTOTPON
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND CODPRO = VCODPRO
					   AND COD_ETAPA = P_COD_ETAPA;
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END SP_IMPORTA_FOLHA_RED;

	/**
    * Metodo para importa a nota da prova
    */
	PROCEDURE SP_IMPORTA_NOTA_PROVA(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									P_CODPRO               IN DBVESTIB.PROVA.CODPRO%TYPE,
									P_COD_ETAPA            IN DBVESTIB.ETAPA_CONCURSO.COD_ETAPA%TYPE DEFAULT 1,
									P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									P_NUM_REGISTROS_LIDOS  OUT int,
									P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
	
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VCODETP        ETAPA.CODETP%TYPE;
		VCODPRO        NOTA_PROVA.CODPRO%TYPE;
		VCODCUR        CURSO.CODCUR%TYPE;
		VPONTOS        VARCHAR2(10);
		VPONTOS_AUX    NUMBER(5,
							  2);
		VTOTPON        NUMBER(5,
							  2);
		VTOTPON2       NUMBER(5,
							  2);
		VFLGERRO       NUMBER;
		P_FLG_CONFIRMA NUMBER;
		V_NOMPRO       DBVESTIB.PROVA.NOMPRO%TYPE;
		NINST          DBVESTIB.INSTITUICAO_ENSINO.CODINSTITUICAO%TYPE;
		TIPO_CONCURSO  DBVESTIB.CONCURSO.COD_TPO_CONCURSO%TYPE;
		CURSOR C_CURSOS IS
			SELECT RCC.CODCUR,
				   RCC.CODINSTITUICAO,
				   RCC.NROOPC
			  FROM DBVESTIB.RCANDCURTUROPC RCC
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
	BEGIN
	
		-- prova
		SELECT PRO.NOMPRO
		  INTO V_NOMPRO
		  FROM DBVESTIB.PROVA PRO
		 WHERE PRO.CODPRO = P_CODPRO;
	
		-- Tipo do Concurso
	
		SELECT CON.COD_TPO_CONCURSO
		  INTO TIPO_CONCURSO
		  FROM DBVESTIB.CONCURSO CON
		 WHERE CON.CODCONC = P_CODCONC;
	
		NINST := DBVESTIB.F_INST_CONCURSO(P_CODCONC);
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FPRO_' || TO_CHAR(SYSDATE,
								 /*                                    'MMDDMISS') || '.LOG';
                                         FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
                                                                                  P_NOM_ARQUIVO_LOG_ERRO,
                                                                                  'w');
                                     
                                         SLINHABRANCO := ' ';
                                         SLINHALIMITE := RPAD('=',
                                                              120,
                                                              '=');
                                         -- =====                                                                                                                                                                                                         
                                         -- Imprime o cabecalho                                                                                                                                                                                           
                                         -- =====                                                                                                                                                                                                         
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SLINHALIMITE);
                                         SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - ARQUIVO TEXTO CONTENDO A NOTA DA PROVA DE ' || V_NOMPRO;
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SCABECALHO);
                                         SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
                                                                                                   'DD/MM/YYYY HH24:MI:SS');
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SCABECALHO);
                                         SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SCABECALHO);
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SLINHALIMITE);
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SLINHABRANCO);
                                         SP_GRAVA_LOG(FILE_HANDLE_LOG,
                                                      SLINHABRANCO);
                                     */
								 -- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
								  F := UTL_FILE.FOPEN(F_DADOS_FTP(5), P_NOM_ARQUIVO,'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
	
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF NVL(LENGTH(TRIM(SBUFFER)),
					   0) = 0 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN := SUBSTR(SBUFFER,
								  41,
								  6);
				IF NINST = 8 THEN
					VCODETP := SUBSTR(SBUFFER,
									  48,
									  1);
				ELSE
					VCODETP := SUBSTR(SBUFFER,
									  47,
									  1);
				END IF;
			
				IF NINST = 8 THEN
					VPONTOS := TRIM(SUBSTR(SBUFFER,
										   49,
										   (LENGTH(TRIM(SBUFFER)) - 48)));
					VPONTOS := TRIM(VPONTOS);
					IF (ASCII(SUBSTR(VPONTOS,
									 LENGTH(VPONTOS),
									 1)) < 48 OR ASCII(SUBSTR(VPONTOS,
															   LENGTH(VPONTOS),
															   1)) > 57) THEN
						VPONTOS := SUBSTR(VPONTOS,
										  1,
										  LENGTH(VPONTOS) - 1);
					END IF;
				
				ELSE
					VPONTOS := SUBSTR(SBUFFER,
									  48,
									  (LENGTH(TRIM(SBUFFER)) - 47));
				END IF;
				-- verificando se tem virgula no valor passado
				IF NINST <> 8 THEN
					IF TIPO_CONCURSO = 8 THEN
						IF (INSTR(VPONTOS,
								  ',') = 0) THEN
							VPONTOS := SUBSTR(SBUFFER,
											  48,
											  3) || ',' || SUBSTR(SBUFFER,
																  51,
																  2);
						END IF;
					ELSE
						IF (INSTR(VPONTOS,
								  ',') = 0) THEN
							VPONTOS := SUBSTR(SBUFFER,
											  48,
											  2) || ',' || SUBSTR(SBUFFER,
																  50,
																  2);
						END IF;
					END IF;
				END IF;
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
			
				-- Verificando se existem os candidatos no cadastro de candidatos                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CANDIDATO
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - Nao existe este candidato na base de dados (Candidato). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a etapa no cadastro de etapas                                                                                                                                                       
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM ETAPA
				 WHERE CODCONC = P_CODCONC
					   AND CODETP = VCODETP
					   AND COD_ETAPA = P_COD_ETAPA;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 47';
					SLINHA := SLINHA || ' - Nao existe esta etapa na base de dados (Etapa). ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- repassando codigo da prova
				VCODPRO := P_CODPRO;
			
				-- Verificando se existe a nota de redacao deste candidato(a)                                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM DBVESTIB.NOTA_PROVA
				 WHERE CODCONC = P_CODCONC
					   AND CODPRO = VCODPRO
					   AND CODCAN = VCODCAN
					   AND COD_ETAPA = P_COD_ETAPA
					   AND NROOPC = '1';
				IF (X > 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 41';
					SLINHA := SLINHA || ' - JA EXISTE NOTA DA PROVA ' || V_NOMPRO || ' NA BASE DE DADOS.';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verifica se os pontos gravados são válidos                                                                                                                                                                
				BEGIN
					VPONTOS := TRIM(VPONTOS);
					SELECT TO_NUMBER(VPONTOS)
					  INTO VPONTOS_AUX
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Total de Pontos do Candidato (Posicao: 48) e invalido. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
			END LOOP;
		
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF TRIM(SBUFFER) = '' THEN
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SLINHA := 'No. de Registros importados: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN := SUBSTR(SBUFFER,
							  41,
							  6);
			IF NINST = 8 THEN
				VCODETP := SUBSTR(SBUFFER,
								  48,
								  1);
			ELSE
				VCODETP := SUBSTR(SBUFFER,
								  47,
								  1);
			END IF;
		
			IF NINST = 8 THEN
				VPONTOS := TRIM(SUBSTR(SBUFFER,
									   49,
									   (LENGTH(TRIM(SBUFFER)) - 48)));
				VPONTOS := TRIM(VPONTOS);
				IF (ASCII(SUBSTR(VPONTOS,
								 LENGTH(VPONTOS),
								 1)) < 48 OR ASCII(SUBSTR(VPONTOS,
														   LENGTH(VPONTOS),
														   1)) > 57) THEN
					VPONTOS := SUBSTR(VPONTOS,
									  1,
									  LENGTH(VPONTOS) - 1);
				END IF;
			ELSE
				VPONTOS := SUBSTR(SBUFFER,
								  48,
								  (LENGTH(TRIM(SBUFFER)) - 47));
			END IF;
			-- verificando se tem virgula no valor passado
			IF NINST <> 8 THEN
				IF (INSTR(VPONTOS,
						  ',') = 0) THEN
					VPONTOS := SUBSTR(SBUFFER,
									  48,
									  2) || ',' || SUBSTR(SBUFFER,
														  50,
														  2);
				END IF;
			END IF;
			-- Importa Definitivamente a nota da prova do candidatos    
		
			-- Verifica se os pontos gravados são válidos                                                                                                                                                                
			BEGIN
				VPONTOS := TRIM(VPONTOS);
				SELECT TO_NUMBER(VPONTOS)
				  INTO VPONTOS_AUX
				  FROM DUAL;
			
				FOR R_CURSOS IN C_CURSOS LOOP
				
					-- Verifica se existe a nota de redacao do candidato na tabela (NotaProva)                                                                                                                                     
					X := 0;
					SELECT COUNT(*)
					  INTO X
					  FROM NOTA_PROVA
					 WHERE CODCONC = P_CODCONC
						   AND CODCAN = VCODCAN
						   AND CODPRO = VCODPRO
						   AND COD_ETAPA = P_COD_ETAPA
						   AND NROOPC = '1';
					IF (X = 0) THEN
						-- Insere o candidato na tabela de notas de prova
						INSERT INTO DBVESTIB.NOTA_PROVA
							(CODNOTAPROVA,
							 CODCONC,
							 CODPRO,
							 NROOPC,
							 CODCAN,
							 NOTAPARCIAL,
							 COD_ETAPA)
						VALUES
							(DBVESTIB.NOTA_PROVA_S.NEXTVAL,
							 P_CODCONC,
							 VCODPRO,
							 '1',
							 VCODCAN,
							 VPONTOS_AUX,
							 P_COD_ETAPA);
					ELSE
						UPDATE DBVESTIB.NOTA_PROVA
						   SET NOTAPARCIAL = VPONTOS_AUX
						 WHERE CODCONC = P_CODCONC
							   AND CODCAN = VCODCAN
							   AND CODPRO = VCODPRO
							   AND COD_ETAPA = P_COD_ETAPA
							   AND NROOPC = '1';
					END IF;
				END LOOP;
			EXCEPTION
				WHEN OTHERS THEN
					NULL;
			END;
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END SP_IMPORTA_NOTA_PROVA;

	-- ====================================================================================                                                                                                                            
	-- ===================             SP_GRAVA_LOG            ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	PROCEDURE SP_GRAVA_LOG(FILE_HANDLE_LOG IN UTL_FILE.FILE_TYPE,
						   SLINHA          IN VARCHAR2) IS
	
	BEGIN
		UTL_FILE.PUT_LINE(FILE_HANDLE_LOG,
						  SLINHA);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Não Existem Dados');
			RAISE_APPLICATION_ERROR(-20500,
									SQLERRM);
		
		WHEN UTL_FILE.INVALID_PATH THEN
			DBMS_OUTPUT.PUT_LINE('Caminho Invalido');
			RAISE_APPLICATION_ERROR(-20500,
									SQLERRM);
		
		WHEN UTL_FILE.READ_ERROR THEN
			DBMS_OUTPUT.PUT_LINE('Erro na Leitura');
			RAISE_APPLICATION_ERROR(-20500,
									SQLERRM);
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			DBMS_OUTPUT.PUT_LINE('Erro Na Gravação');
			RAISE_APPLICATION_ERROR(-20500,
									SQLERRM);
		
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20500,
									SQLERRM);
		
	END SP_GRAVA_LOG;

	-- ====================================================================================                                                                                                                            
	-- ===================           SP_IMPORTA_FICHA_FABRAI   ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	-- ===================================================================                                                                                                                                             
	-- LAYOUT DO ARQUIVO TEXTO GERADO PELA FICHA DE INSCRIÇÃO                                                                                                                                                          
	-- ===================================================================                                                                                                                                             
	-- ==      CAMPO          ==    POSIÇÃO INICIAL    ==    TAMANHO    ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- == BRANCOS             ==           1           ==       40      ==                                                                                                                                             
	-- == CODIGO              ==          41           ==        6      ==                                                                                                                                             
	-- == NOME                ==          47           ==       39      ==                                                                                                                                             
	-- == SEXO                ==          86           ==        1      ==                                                                                                                                             
	-- == CANHOTO             ==          87           ==        1      ==                                                                                                                                             
	-- == LINGUA              ==          88           ==        1      ==                                                                                                                                             
	-- == DEFICIENTE          ==          89           ==        1      ==                                                                                                                                             
	-- == TIPO DO DOCUMENTO   ==          90           ==        2      ==                                                                                                                                             
	-- == NÚMERO DO DOCUMENTO ==          94           ==       12      ==                                                                                                                                             
	-- == ESTADO EMISSOR      ==         106           ==        2      ==                                                                                                                                             
	-- == DATA DE NASCIMENTO  ==         108           ==        6      ==                                                                                                                                             
	-- == DATA DE INSCRIÇÃO   ==         114           ==        6      ==                                                                                                                                             
	-- == CURSO/TURNO         ==         120           ==        3      ==                                                                                                                                             
	-- == SOCECO              ==         123           ==      250      ==                                                                                                                                             
	-- == ENDEREÇO            ==         373           ==       34      ==                                                                                                                                             
	-- == BAIRRO              ==         407           ==       22      ==                                                                                                                                             
	-- == CIDADE              ==         429           ==       23      ==                                                                                                                                             
	-- == CEP                 ==         452           ==        8      ==                                                                                                                                             
	-- == TELEFONE            ==         460           ==       10      ==                                                                                                                                             
	-- == ESTADO              ==         470           ==        2      ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             

	PROCEDURE SP_IMPORTA_FICHA_FABRAI(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
									  P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
									  P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
									  P_NUM_REGISTROS_LIDOS  OUT int,
									  P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VDATNASCAN_AUX CHAR(6);
		VDATINSCAN_AUX CHAR(6);
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VNOMCAN        CANDIDATO.NOMCAN%TYPE;
		VSEXCAN        CANDIDATO.SEXCAN%TYPE;
		VCODCUR        RCANDCURTUROPC.CODCUR%TYPE;
		VCODTUR        RCANDCURTUROPC.CODTUR%TYPE;
		VOPCLIN        RCANDCURTUROPC.OPCLIN%TYPE;
		VDEFCAN        TIPO_DEFICIENCIA.CODTPODEF%TYPE;
		VCODTPODEF     CANDIDATO.CODTPODEF%TYPE;
		VIND_TREINANTE CANDIDATO.IND_TREINANTE%TYPE;
		VCANHOTO       CANDIDATO.CANHOTO%TYPE;
		VTIPDOC        CANDIDATO.CODCAN%TYPE;
		VIDECAN        CANDIDATO.IDECAN%TYPE;
		VESTDOC        CANDIDATO.ESTCAN%TYPE;
		VNOMIDECAN     CANDIDATO.NOMIDECAN%TYPE;
		VEXPIDECAN     CANDIDATO.EXPIDECAN%TYPE;
		VSTRSOCECO     CANDIDATO.STR_SOCECO%TYPE;
		VDATNASCAN     CANDIDATO.DATNASCAN%TYPE;
		VDATINSCAN     CANDIDATO.DATINSCAN%TYPE;
		VENDCAN        CANDIDATO.ENDCAN%TYPE;
		VBAICAN        CANDIDATO.BAICAN%TYPE;
		VCIDCAN        CANDIDATO.CIDCAN%TYPE;
		VCEPCAN        CANDIDATO.CEPCAN%TYPE;
		VTELCAN        CANDIDATO.TELCAN%TYPE;
		VESTCAN        CANDIDATO.ESTCAN%TYPE;
		VFLGERRO       NUMBER;
		VDATPGTO       INSCRICAO.DATPGTO%TYPE;
		VEMAILCAN      CANDIDATO.EMAIL%TYPE;
	
	BEGIN
	
		UTL_FILE.FCLOSE_ALL;
	
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FI_' || TO_CHAR(SYSDATE,
												   'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
	
		-- Imprime o cabecalho                                                                                                                                                                                           
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - FICHAS DE INSCRICAO';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		IF LENGTH(SBUFFER) <> 471 THEN
			SLINHA := 'Arquivo nao e de fichas de inscricao';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
			
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF LENGTH(SBUFFER) <> 471 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN        := SUBSTR(SBUFFER,
										 41,
										 6);
				VNOMCAN        := SUBSTR(SBUFFER,
										 47,
										 39);
				VSEXCAN        := SUBSTR(SBUFFER,
										 86,
										 1);
				VCANHOTO       := SUBSTR(SBUFFER,
										 87,
										 1);
				VOPCLIN        := SUBSTR(SBUFFER,
										 88,
										 1);
				VDEFCAN        := SUBSTR(SBUFFER,
										 89,
										 1);
				VDATNASCAN_AUX := SUBSTR(SBUFFER,
										 108,
										 6);
				VDATINSCAN_AUX := SUBSTR(SBUFFER,
										 114,
										 6);
				VCODCUR        := SUBSTR(SBUFFER,
										 120,
										 2);
				VCODTUR        := SUBSTR(SBUFFER,
										 122,
										 1);
			
				-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                       
				-- Muitos candidatos marcam a opção de língua estrangeira, mesmo para os cursos que não tem.                                                                                                                 
				-- Portanto, coloco a opção 0 para os cursos diferentes de Letras.                                                                                                                                           
			
				-- Troca a opção de língua                                                                                                                                                                                   
				IF (VOPCLIN = 'I') THEN
					VOPCLIN := '1';
				ELSIF (VOPCLIN = 'F') THEN
					VOPCLIN := '2';
				ELSIF (VOPCLIN = 'E') THEN
					VOPCLIN := '3';
				ELSIF (VOPCLIN IS NULL)
					  OR (VOPCLIN = ' ') THEN
					VOPCLIN := '0';
				END IF;
			
				-- Canhoto ou Destro                                                                                                                                                                                         
				IF (VCANHOTO = 'D') THEN
					VCANHOTO := 'N';
				ELSIF (VCANHOTO = 'C') THEN
					VCANHOTO := 'S';
				END IF;
			
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
			
				-- Verificando se a data de nascimento do candidato é válida                                                                                                                                                 
				BEGIN
					SELECT TO_DATE(VDATNASCAN_AUX,
								   'DDMMRR')
					  INTO VDATNASCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Nascimento do Candidato (Posicao: 105) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se a data de inscrição do candidato é válida                                                                                                                                                  
				BEGIN
					SELECT TO_DATE(VDATINSCAN_AUX,
								   'DDMMYY')
					  INTO VDATINSCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Inscricao do Candidato (Posicao: 111) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se existe a opção de língua marcada pelo candidato                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM OPCLINGUA
				 WHERE OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 88';
					SLINHA := SLINHA || ' - Nao existe esta opcao de lingua estrangeira moderna. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se o Sexo eh igual a "F" ou "M"                                                                                                                                                               
				IF (VSEXCAN <> 'F' AND VSEXCAN <> 'M') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 86';
					SLINHA := SLINHA || ' - O Sexo esta diferente de "F" ou "M". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se o campo Canhoto eh igual a "S" ou "N"                                                                                                                                                      
				IF (VCANHOTO <> 'S' AND VCANHOTO <> 'N') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 87';
					SLINHA := SLINHA || ' - O campo Canhoto esta diferente de "S" ou "N". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o turno marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM TURNO
				 WHERE CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117';
					SLINHA := SLINHA || ' - Nao existe este turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CURSO
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 119';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno marcado pelo candidato                                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUR
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117 e 119';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno/opção de língua marcado pelo candidato                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUROPC
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR
					   AND OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117, 119 e 88';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno/opcao de lingua. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
			END LOOP;
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		IF VFLGERRO > 0 THEN
			DBMS_OUTPUT.PUT_LINE('NAO FOI IMPORTADO NENHUM REGISTRO.');
			SLINHA := 'NAO FORAM IMPORTADOS NENHUM REGISTRO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE(F);
			RAISE_APPLICATION_ERROR(-20500,
									'x');
		END IF;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF LENGTH(SBUFFER) <> 471 THEN
				-- Grava o resto da importação                                                                                                                                                                               
				COMMIT;
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				UTL_FILE.FCLOSE_ALL;
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN        := TRIM(SUBSTR(SBUFFER,
										  41,
										  6));
			VNOMCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												47,
												39)));
			VSEXCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												86,
												1)));
			VCANHOTO       := UPPER(TRIM(SUBSTR(SBUFFER,
												87,
												1)));
			VOPCLIN        := TRIM(SUBSTR(SBUFFER,
										  88,
										  1));
			VDEFCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												89,
												1)));
			VTIPDOC        := TRIM(SUBSTR(SBUFFER,
										  90,
										  2));
			VIDECAN        := TRIM(SUBSTR(SBUFFER,
										  94,
										  12));
			VESTDOC        := TRIM(SUBSTR(SBUFFER,
										  106,
										  2));
			VDATNASCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  108,
										  6));
			VDATINSCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  114,
										  6));
			VCODCUR        := TRIM(SUBSTR(SBUFFER,
										  120,
										  2));
			VCODTUR        := TRIM(SUBSTR(SBUFFER,
										  122,
										  1));
			VSTRSOCECO     := SUBSTR(SBUFFER,
									 123,
									 250);
			VENDCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												373,
												34)));
			VBAICAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   407,
													   22),
												1,
												20)));
			VCIDCAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   429,
													   23),
												1,
												20)));
			VCEPCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												452,
												5) || '-' || SUBSTR(SBUFFER,
																	457,
																	3)));
			VTELCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												460,
												10)));
			VESTCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												470,
												2)));
			--vInd_Treinante      := upper(trim(substr(sBuffer,469,1)));                                                                                                                                                   
		
			-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                         
		
			-- Converte para o formato data                                                                                                                                                                                
			VDATNASCAN := TO_DATE(VDATNASCAN_AUX,
								  'DDMMRR');
			VDATINSCAN := TO_DATE(VDATINSCAN_AUX,
								  'DDMMYY');
		
			VCODCAN := TRIM(VCODCAN);
			IF LENGTH(VCODCAN) = 3 THEN
				VCODCAN := '100' + VCODCAN;
			ELSIF LENGTH(VCODCAN) = 2 THEN
				VCODCAN := '1000' + VCODCAN;
			ELSIF LENGTH(VCODCAN) = 1 THEN
				VCODCAN := '10000' + VCODCAN;
			END IF;
		
			-- Troca a opção de língua                                                                                                                                                                                     
			IF (VOPCLIN = 'I') THEN
				VOPCLIN := '1';
			ELSIF (VOPCLIN = 'F') THEN
				VOPCLIN := '2';
			ELSIF (VOPCLIN = 'E') THEN
				VOPCLIN := '3';
			ELSIF (VOPCLIN IS NULL)
				  OR (VOPCLIN = ' ') THEN
				VOPCLIN := '0';
			END IF;
		
			-- Troca o tipo do documento                                                                                                                                                                                   
			IF TRIM(VTIPDOC) = 'CI' THEN
				VTIPDOC    := 'CI';
				VNOMIDECAN := 'Cart.de Identidade';
				VEXPIDECAN := 'SSP/' || VESTDOC;
			ELSIF TRIM(VTIPDOC) = 'CT' THEN
				VTIPDOC    := 'CT';
				VNOMIDECAN := 'Cart.de Trabalho';
				VEXPIDECAN := 'MT';
			END IF;
		
			IF ((TRIM(VIND_TREINANTE) = '') OR (VIND_TREINANTE IS NULL)) THEN
				VIND_TREINANTE := 'N';
			ELSIF VIND_TREINANTE = 'T' THEN
				VIND_TREINANTE := 'S';
			END IF;
		
			-- Troca o tipo de deficiencia                                                                                                                                                                                 
			IF (VDEFCAN IS NULL)
			   OR (VDEFCAN = ' ')
			   OR (VDEFCAN = 'N') THEN
				VDEFCAN := '03';
			ELSIF (VDEFCAN = 'V') THEN
				VDEFCAN := '01';
			ELSIF (VDEFCAN = 'F') THEN
				VDEFCAN := '02';
			END IF;
		
			-- Canhoto ou Destro                                                                                                                                                                                           
			IF (VCANHOTO = 'D') THEN
				VCANHOTO := 'N';
			ELSIF (VCANHOTO = 'C') THEN
				VCANHOTO := 'S';
			END IF;
		
			-- Se o local de pagamento for o circuito universitario entao a data de pagamento = data inscricao                                                                                                             
			IF P_CODLOCPAG = '003' THEN
				VDATPGTO := VDATINSCAN;
			END IF;
		
			-- Verifica se o candidato existe na tabela de candidato e opção de curso (rcandcurturopc)                                                                                                                     
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CANDIDATO
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
		
			IF (X = 0) THEN
				-- Insere o candidato na tabela de candidatos                                                                                                                                                                
				INSERT INTO CANDIDATO
					(CODCONC,
					 CODCAN,
					 NOMCAN,
					 SEXCAN,
					 DATNASCAN,
					 IDECAN,
					 NOMIDECAN,
					 EXPIDECAN,
					 TELCAN,
					 ENDCAN,
					 BAICAN,
					 CIDCAN,
					 ESTCAN,
					 CEPCAN,
					 DATINSCAN,
					 DATPAGCAN,
					 CODLOCPAG,
					 SITCAN,
					 CLACAN,
					 CLACAN2,
					 CODLOC,
					 CODSAL,
					 EMAIL,
					 TOTPON,
					 TOTPON2,
					 CANHOTO,
					 TAG,
					 CODCANANT,
					 REGFCH,
					 FLGMAT,
					 DATINCCAN,
					 str_soceco,
					 SITCAN2,
					 CODTPODEF,
					 IND_TREINANTE,
					 SITCANGER,
					 CLACANGER)
				
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VNOMCAN,
					 VSEXCAN,
					 VDATNASCAN,
					 VIDECAN,
					 VNOMIDECAN,
					 VEXPIDECAN,
					 VTELCAN,
					 VENDCAN,
					 VBAICAN,
					 VCIDCAN,
					 VESTCAN,
					 VCEPCAN,
					 VDATINSCAN,
					 VDATPGTO,
					 P_CODLOCPAG,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NVL(VCANHOTO,
						 'N'),
					 'N',
					 NULL,
					 'N',
					 'N',
					 SYSDATE,
					 VSTRSOCECO,
					 NULL,
					 NVL(VDEFCAN,
						 '03'),
					 'N',
					 NULL,
					 NULL);
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				INSERT INTO RCANDCURTUROPC
					(CODCONC,
					 CODCAN,
					 CODCUR,
					 CODTUR,
					 OPCLIN,
					 NROOPC)
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VCODCUR,
					 VCODTUR,
					 VOPCLIN,
					 '1');
			
			ELSE
				-- Atualiza os dados do candidato na tabela de candidatos                                                                                                                                                    
				UPDATE CANDIDATO
				   SET NOMCAN        = VNOMCAN,
					   SEXCAN        = VSEXCAN,
					   DATNASCAN     = VDATNASCAN,
					   IDECAN        = VIDECAN,
					   NOMIDECAN     = VNOMIDECAN,
					   EXPIDECAN     = VEXPIDECAN,
					   TELCAN        = VTELCAN,
					   ENDCAN        = VENDCAN,
					   BAICAN        = VBAICAN,
					   CIDCAN        = VCIDCAN,
					   ESTCAN        = VESTCAN,
					   CEPCAN        = VCEPCAN,
					   DATINSCAN     = VDATINSCAN,
					   DATPAGCAN     = VDATPGTO,
					   CODLOCPAG     = P_CODLOCPAG,
					   SITCAN        = NULL,
					   CLACAN        = NULL,
					   CLACAN2       = NULL,
					   CODLOC        = NULL,
					   CODSAL        = NULL,
					   EMAIL         = NULL,
					   TOTPON        = NULL,
					   TOTPON2       = NULL,
					   CANHOTO       = NVL(VCANHOTO,
										   'N'),
					   TAG           = 'N',
					   CODCANANT     = NULL,
					   REGFCH        = 'N',
					   FLGMAT        = 'N',
					   str_soceco    = VSTRSOCECO,
					   SITCAN2       = NULL,
					   CODTPODEF     = NVL(VDEFCAN,
										   '03'),
					   IND_TREINANTE = 'N',
					   SITCANGER     = NULL,
					   CLACANGER     = NULL
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				UPDATE RCANDCURTUROPC
				   SET CODCUR = VCODCUR,
					   CODTUR = VCODTUR,
					   OPCLIN = VOPCLIN
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND NROOPC = '1';
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END;

	-- ====================================================================================                                                                                                                            
	-- ===================        SP_IMPORTA_FICHA_INSC_FIAT   ============================                                                                                                                            
	-- ====================================================================================                                                                                                                            
	-- ===================================================================                                                                                                                                             
	-- LAYOUT DO ARQUIVO TEXTO GERADO PELA FICHA DE INSCRIÇÃO                                                                                                                                                          
	-- ===================================================================                                                                                                                                             
	-- ==      CAMPO          ==    POSIÇÃO INICIAL    ==    TAMANHO    ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- == BRANCOS             ==           1           ==       40      ==                                                                                                                                             
	-- == CODIGO              ==          41           ==        6      ==                                                                                                                                             
	-- == NOME                ==          47           ==       39      ==                                                                                                                                             
	-- == SEXO                ==          86           ==        1      ==                                                                                                                                             
	-- == REGISTRO EMPREGADO  ==          87           ==        9      ==                                                                                                                                             
	-- == DATA DE NASCIMENTO  ==          96           ==        6      ==                                                                                                                                             
	-- == SERIE ENSINO FUNDAME==         102           ==        1      ==                                                                                                                                             
	-- == TIPO DE ESCOLA      ==         103           ==        1      ==                                                                                                                                             
	-- == LOCAL DA ESCOLA     ==         104           ==        1      ==                                                                                                                                             
	-- == ELENCO              ==         105           ==        1      ==                                                                                                                                             
	-- == LOCAL TRABALHO      ==         106           ==        4      ==                                                                                                                                             
	-- == ENDERECO            ==         110           ==       34      ==                                                                                                                                             
	-- == BAIRRO              ==         144           ==       22      ==                                                                                                                                             
	-- == CIDADE              ==         166           ==       22      ==                                                                                                                                             
	-- == CEP                 ==         188           ==        8      ==                                                                                                                                             
	-- == TELEFONE            ==         196           ==       11      ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             

	PROCEDURE SP_IMPORTA_FICHA_INSC_FIAT(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
										 P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
										 P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
										 P_NUM_REGISTROS_LIDOS  OUT int,
										 P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X              NUMBER;
		VDATNASCAN_AUX CHAR(6);
		VDATINSCAN_AUX CHAR(6);
		VCODCAN        CANDIDATO.CODCAN%TYPE;
		VNOMCAN        CANDIDATO.NOMCAN%TYPE;
		VSEXCAN        CANDIDATO.SEXCAN%TYPE;
		VCODCUR        RCANDCURTUROPC.CODCUR%TYPE;
		VCODTUR        RCANDCURTUROPC.CODTUR%TYPE;
		VOPCLIN        RCANDCURTUROPC.OPCLIN%TYPE;
		VDEFCAN        TIPO_DEFICIENCIA.CODTPODEF%TYPE;
		VCODTPODEF     CANDIDATO.CODTPODEF%TYPE;
		VIND_TREINANTE CANDIDATO.IND_TREINANTE%TYPE;
		VCANHOTO       CANDIDATO.CANHOTO%TYPE;
		VTIPDOC        CANDIDATO.CODCAN%TYPE;
		VIDECAN        CANDIDATO.IDECAN%TYPE;
		VESTDOC        CANDIDATO.ESTCAN%TYPE;
		VNOMIDECAN     CANDIDATO.NOMIDECAN%TYPE;
		VEXPIDECAN     CANDIDATO.EXPIDECAN%TYPE;
		VSTRSOCECO     CANDIDATO.STR_SOCECO%TYPE;
		VDATNASCAN     CANDIDATO.DATNASCAN%TYPE;
		VDATINSCAN     CANDIDATO.DATINSCAN%TYPE;
		VENDCAN        CANDIDATO.ENDCAN%TYPE;
		VBAICAN        CANDIDATO.BAICAN%TYPE;
		VCIDCAN        CANDIDATO.CIDCAN%TYPE;
		VCEPCAN        CANDIDATO.CEPCAN%TYPE;
		VTELCAN        CANDIDATO.TELCAN%TYPE;
		VESTCAN        CANDIDATO.ESTCAN%TYPE;
		VFLGERRO       NUMBER;
		VDATPGTO       INSCRICAO.DATPGTO%TYPE;
		VEMAILCAN      CANDIDATO.EMAIL%TYPE;
		VREGISTRO      CANDIDATO.REG_EMPREGADO%TYPE;
		VTIPOESCOLA    CANDIDATO.TIP_ESCOLA%TYPE;
		VSERIE         CANDIDATO.TIP_ESCOLA%TYPE;
		VLOCALESCOLA   CANDIDATO.CODCIDPROVA%TYPE;
		VCODCIDESCOLHA CANDIDATO.CODCIDESCOLHA%TYPE;
		VCODCIDPROVA   CANDIDATO.CODCIDPROVA%TYPE;
		VLOCALTRABALHO CANDIDATO.LOC_TRABALHO%TYPE;
	
	BEGIN
	
		UTL_FILE.FCLOSE_ALL;
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FI_' || TO_CHAR(SYSDATE,
												   'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - FICHAS DE INSCRICAO';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		IF LENGTH(SBUFFER) <> 206 THEN
			SLINHA := 'Arquivo nao e de fichas de inscricao';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		--  UTL_FILE.FCLOSE(f);                                                                                                                                                                                            
	
		--  UTL_FILE.FCLOSE_ALL;                                                                                                                                                                                           
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		--  f := utl_file.fopen( f_DADOS_FTP( 5 ), p_nom_arquivo, 'r' );                                                                                                                                                   
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
			
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF LENGTH(SBUFFER) <> 206 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN        := SUBSTR(SBUFFER,
										 41,
										 6);
				VNOMCAN        := SUBSTR(SBUFFER,
										 47,
										 39);
				VSEXCAN        := SUBSTR(SBUFFER,
										 86,
										 1);
				VREGISTRO      := SUBSTR(SBUFFER,
										 87,
										 9);
				VDATNASCAN_AUX := SUBSTR(SBUFFER,
										 98,
										 6);
				VSERIE         := SUBSTR(SBUFFER,
										 102,
										 1);
				VTIPOESCOLA    := SUBSTR(SBUFFER,
										 103,
										 1);
				VLOCALESCOLA   := SUBSTR(SBUFFER,
										 104,
										 1);
				VLOCALTRABALHO := SUBSTR(SBUFFER,
										 105,
										 5);
				-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                       
			
			-- ===================================================================                                                                                                                                       
			-- Consistindo o arquivo a ser importado                                                                                                                                                                     
			-- ===================================================================                                                                                                                                       
			
			/*                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se a data de nascimento do candidato é válida                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      begin                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                         select to_date(vDatNasCan_Aux,'DDMMRR') into vDatNasCan from dual;                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                      exception                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                        when others then                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                          sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan;                                                                                                             
                                                                                                                                                                                                                                                                                                                                                          sLinha := sLinha || ' - Data de Nascimento do Candidato (Posicao: 105) e invalida. ';                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                          SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                          SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                      end;                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se a data de inscrição do candidato é válida                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                      begin                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                         select to_date(vDatInsCan_Aux,'DDMMYY') into vDatInsCan from dual;                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                      exception                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                        when others then                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                          sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan;                                                                                                             
                                                                                                                                                                                                                                                                                                                                                          sLinha := sLinha || ' - Data de Inscricao do Candidato (Posicao: 111) e invalida. ';                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                          SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                          SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                      end;                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o Sexo eh igual a "F" ou "M"                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                      if (vSexCan <> 'F' and vSexCan <> 'M') then                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan || ' - Posicao: 86';                                                                                          
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O Sexo esta diferente de "F" ou "M". ';                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Serie eh igual entre 1 e 8                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                      if (vSerie not in ('1','2','3','4','5','6','7','8')) then                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Série: ' || vSerie || ' - Posicao: 102';                                                                                              
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Serie esta diferente de 1,2,3,4,6,5,7,8 ';                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Tipo de escola eh igual entre 1,2,3,4                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                      if (vTipoEscola not in ('1','2','3','4')) then                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Tipo Escola: ' || vTipoEscola || ' - Posicao: 103';                                                                                   
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Tipo escola esta diferente de 1,2,3,4 ';                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Local escola eh igual entre 1,2,3,4                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                      if (vLocalEscola not in ('1','2','3','4')) then                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Local Escola : ' || vLocalEscola  || ' - Posicao: 104';                                                                               
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Tipo escola esta diferente de 1,2,3,4 ';                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Elenco escola eh igual entre 1,2,3                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      if (substr(vLocalTrabalho,1) not in ('1','2','3','4')) then                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Elenco : ' || vLocalEscola  || ' - Posicao: 105';                                                                                     
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Tipo escola esta diferente de 1,2,3 ';                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Local de trabalho eh igual entre 1,2,3                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                      if (vLocalTrabalho not in ('1','2','3','4')) then                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' vLocalTrabalho : ' || vLocalEscola  || ' - Posicao: 106';                                                                             
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Local Trabalho esta diferente de 1,2,3 ';                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                      -- Verificando se o campo Serie eh igual entre 1 e 8                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                      if (vSerie not in ('1','2','3','4','5','6','7','8')) then                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                         sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Série: ' || vSerie || ' - Posicao: 102';                                                                                              
                                                                                                                                                                                                                                                                                                                                                         sLinha := sLinha || ' - O campo Serie esta diferente de 1,2,3,4,6,5,7,8 ';                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                         SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                         vFlgErro := vFlgErro + 1;                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                      end if;                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                */
			
			/*      sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan ;                                                                                                              
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                */
			END LOOP;
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		IF VFLGERRO > 0 THEN
			DBMS_OUTPUT.PUT_LINE('NAO FORAM IMPORTADOS NENHUM REGISTRO.');
		
			SLINHA := 'NAO FORAM IMPORTADOS NENHUM REGISTRO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE(F);
			RAISE_APPLICATION_ERROR(-20500,
									'x');
		END IF;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF LENGTH(SBUFFER) <> 206 THEN
				-- Grava o resto da importação                                                                                                                                                                               
				COMMIT;
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				UTL_FILE.FCLOSE_ALL;
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN        := TRIM(SUBSTR(SBUFFER,
										  41,
										  6));
			VNOMCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												47,
												39)));
			VSEXCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												86,
												1)));
			VREGISTRO      := SUBSTR(SBUFFER,
									 87,
									 9);
			VDATNASCAN_AUX := SUBSTR(SBUFFER,
									 96,
									 6);
			VSERIE         := SUBSTR(SBUFFER,
									 102,
									 1);
			VTIPOESCOLA    := SUBSTR(SBUFFER,
									 103,
									 1);
			VLOCALESCOLA   := SUBSTR(SBUFFER,
									 104,
									 1);
			VLOCALTRABALHO := SUBSTR(SBUFFER,
									 105,
									 5);
			VDATNASCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  105,
										  6));
			VDATINSCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  111,
										  6));
			VENDCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												110,
												34)));
			VBAICAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   144,
													   22),
												1,
												20)));
			VCIDCAN        := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
													   166,
													   22),
												1,
												20)));
			VCEPCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												188,
												5) || '-' || SUBSTR(SBUFFER,
																	192,
																	3)));
			VTELCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												196,
												11)));
		
			-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                         
		
			-- Converte para o formato data                                                                                                                                                                                
			-- vDatNasCan := to_date(vDatNasCan_Aux,'DDMMRR');                                                                                                                                                             
			VDATNASCAN := TO_DATE(SYSDATE,
								  'DDMMRR');
			VDATINSCAN := TO_DATE(SYSDATE,
								  'DDMMYY');
		
			-- Troca a opção de língua                                                                                                                                                                                     
			VOPCLIN := '0';
		
			VTIPDOC := '01';
		
			-- FIAT                                                                                                                                                                                                        
			VCODTUR := '0';
		
			VIND_TREINANTE := 'N';
		
			-- Troca o tipo de deficiencia                                                                                                                                                                                 
			VDEFCAN := '03';
		
			-- Se o local de pagamento for o circuito universitario entao a data de pagamento = data inscricao                                                                                                             
			IF P_CODLOCPAG = '003' THEN
				VDATPGTO := VDATINSCAN;
			END IF;
		
			-- Verifica se o candidato existe na tabela de candidato e opção de curso (rcandcurturopc)                                                                                                                     
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CANDIDATO
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
		
			IF (X = 0) THEN
				-- Insere o candidato na tabela de candidatos                                                                                                                                                                
				INSERT INTO CANDIDATO
					(CODCONC,
					 CODCAN,
					 NOMCAN,
					 SEXCAN,
					 DATNASCAN,
					 IDECAN,
					 NOMIDECAN,
					 EXPIDECAN,
					 TELCAN,
					 ENDCAN,
					 BAICAN,
					 CIDCAN,
					 ESTCAN,
					 CEPCAN,
					 DATINSCAN,
					 DATPAGCAN,
					 CODLOCPAG,
					 SITCAN,
					 CLACAN,
					 CLACAN2,
					 CODLOC,
					 CODSAL,
					 EMAIL,
					 TOTPON,
					 TOTPON2,
					 CANHOTO,
					 TAG,
					 CODCANANT,
					 REGFCH,
					 FLGMAT,
					 DATINCCAN,
					 str_soceco,
					 SITCAN2,
					 CODTPODEF,
					 IND_TREINANTE,
					 SITCANGER,
					 CLACANGER,
					 CODCIDPROVA,
					 CODCIDESCOLHA,
					 NOM_PAI,
					 NOM_MAE,
					 IND_ALUNO_FUNCESI,
					 REG_EMPREGADO,
					 NOM_EMPREGADO,
					 LOC_TRABALHO,
					 TIP_ESCOLA)
				
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VNOMCAN,
					 VSEXCAN,
					 VDATNASCAN,
					 VIDECAN,
					 VNOMIDECAN,
					 VEXPIDECAN,
					 VTELCAN,
					 VENDCAN,
					 VBAICAN,
					 VCIDCAN,
					 VESTCAN,
					 VCEPCAN,
					 VDATINSCAN,
					 VDATPGTO,
					 P_CODLOCPAG,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 'N',
					 'N',
					 NULL,
					 'N',
					 'N',
					 SYSDATE,
					 NULL,
					 NULL,
					 '03',
					 'N',
					 NULL,
					 NULL,
					 VCODCIDPROVA,
					 VCODCIDESCOLHA,
					 NULL,
					 NULL,
					 NULL,
					 VREGISTRO,
					 NULL,
					 NULL,
					 NULL);
			
			ELSE
				-- Atualiza os dados do candidato na tabela de candidatos                                                                                                                                                    
				UPDATE CANDIDATO
				   SET NOMCAN            = VNOMCAN,
					   SEXCAN            = VSEXCAN,
					   DATNASCAN         = VDATNASCAN,
					   IDECAN            = VIDECAN,
					   NOMIDECAN         = VNOMIDECAN,
					   EXPIDECAN         = VEXPIDECAN,
					   TELCAN            = VTELCAN,
					   ENDCAN            = VENDCAN,
					   BAICAN            = VBAICAN,
					   CIDCAN            = VCIDCAN,
					   ESTCAN            = VESTCAN,
					   CEPCAN            = VCEPCAN,
					   DATINSCAN         = VDATINSCAN,
					   DATPAGCAN         = VDATPGTO,
					   CODLOCPAG         = P_CODLOCPAG,
					   SITCAN            = NULL,
					   CLACAN            = NULL,
					   CLACAN2           = NULL,
					   CODLOC            = NULL,
					   CODSAL            = NULL,
					   EMAIL             = NULL,
					   TOTPON            = NULL,
					   TOTPON2           = NULL,
					   CANHOTO           = NVL(VCANHOTO,
											   'N'),
					   TAG               = 'N',
					   CODCANANT         = NULL,
					   REGFCH            = 'N',
					   FLGMAT            = 'N',
					   str_soceco        = VSTRSOCECO,
					   SITCAN2           = NULL,
					   CODTPODEF         = NVL(VDEFCAN,
											   '03'),
					   IND_TREINANTE     = VIND_TREINANTE,
					   SITCANGER         = NULL,
					   CLACANGER         = NULL,
					   CODCIDPROVA       = NULL,
					   CODCIDESCOLHA     = NULL,
					   NOM_PAI           = NULL,
					   NOM_MAE           = NULL,
					   IND_ALUNO_FUNCESI = NULL,
					   REG_EMPREGADO     = NULL,
					   NOM_EMPREGADO     = NULL,
					   LOC_TRABALHO      = NULL,
					   TIP_ESCOLA        = NULL
				
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				UPDATE RCANDCURTUROPC
				   SET CODCUR = VSERIE, --vCodCur,                                                                                                                                                     
					   CODTUR = VCODTUR,
					   OPCLIN = VOPCLIN
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND NROOPC = '1';
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			UTL_FILE.FCLOSE_ALL;
		
	END;

	-- ===================================================================                                                                                                                                             
	-- ===============   SP_IMPORTA_FICHA_INSC_FUNCESI     ===============                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- LAYOUT DO ARQUIVO TEXTO GERADO PELA FICHA DE INSCRIÇÃO                                                                                                                                                          
	-- ===================================================================                                                                                                                                             
	-- ==      CAMPO          ==    POSIÇÃO INICIAL    ==    TAMANHO    ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             
	-- == BRANCOS             ==           1           ==       40      ==                                                                                                                                             
	-- == CODIGO              ==          41           ==        6      ==                                                                                                                                             
	-- == NOME                ==          47           ==       39      ==                                                                                                                                             
	-- == SEXO                ==          86           ==        1      ==                                                                                                                                             
	-- == CANHOTO             ==          87           ==        1      ==                                                                                                                                             
	-- == LINGUA              ==          88           ==        1      ==                                                                                                                                             
	-- == DEFICIENTE          ==          89           ==        1      ==                                                                                                                                             
	-- == TIPO DO DOCUMENTO   ==          90           ==        1      ==                                                                                                                                             
	-- == NÚMERO DO DOCUMENTO ==          91           ==       12      ==                                                                                                                                             
	-- == ESTADO EMISSOR      ==         103           ==        2      ==                                                                                                                                             
	-- == DATA DE NASCIMENTO  ==         105           ==        6      ==                                                                                                                                             
	-- == DATA DE INSCRIÇÃO   ==         111           ==        6      ==                                                                                                                                             
	-- == CURSO/TURNO         ==         117           ==        4      ==                                                                                                                                             
	-- == SOCECO              ==         121           ==      250      ==                                                                                                                                             
	-- == ENDEREÇO            ==         372           ==       34      ==                                                                                                                                             
	-- == BAIRRO              ==         406           ==       22      ==                                                                                                                                             
	-- == CIDADE              ==         427           ==       23      ==                                                                                                                                             
	-- == CEP                 ==         450           ==        8      ==                                                                                                                                             
	-- == TELEFONE            ==         458           ==       10      ==                                                                                                                                             
	-- == ESTADO              ==         468           ==        2      ==                                                                                                                                             
	-- == TREINANTE           ==         470           ==        1      ==                                                                                                                                             
	-- == CIDADE ESCOLHIDA    ==         471           ==        4      ==                                                                                                                                             
	-- == IND_ALUNO_FUNCESI   ==         475           ==        1      ==                                                                                                                                             
	-- ===================================================================                                                                                                                                             

	PROCEDURE SP_IMPORTA_FICHA_INSC_FUNCESI(P_CODCONC              IN CONCURSO.CODCONC%TYPE,
											P_NOM_ARQUIVO          IN CONCURSO.NOMCONC%TYPE,
											P_CODLOCPAG            IN CANDIDATO.CODLOCPAG%TYPE,
											P_NUM_REGISTROS_LIDOS  OUT int,
											P_NOM_ARQUIVO_LOG_ERRO OUT CONCURSO.NOMCONC%TYPE) IS
		SBUFFER    VARCHAR2(600);
		SDIRETORIO VARCHAR2(255);
		E_TIPO_ARQ_INVALIDO EXCEPTION;
		X                  NUMBER;
		VDATNASCAN_AUX     CHAR(6);
		VDATINSCAN_AUX     CHAR(6);
		VCODCAN            CANDIDATO.CODCAN%TYPE;
		VNOMCAN            CANDIDATO.NOMCAN%TYPE;
		VSEXCAN            CANDIDATO.SEXCAN%TYPE;
		VCODCUR            RCANDCURTUROPC.CODCUR%TYPE;
		VCODTUR            RCANDCURTUROPC.CODTUR%TYPE;
		VOPCLIN            RCANDCURTUROPC.OPCLIN%TYPE;
		VDEFCAN            TIPO_DEFICIENCIA.CODTPODEF%TYPE;
		VCODTPODEF         CANDIDATO.CODTPODEF%TYPE;
		VIND_TREINANTE     CANDIDATO.IND_TREINANTE%TYPE;
		VCANHOTO           CANDIDATO.CANHOTO%TYPE;
		VTIPDOC            CANDIDATO.CODCAN%TYPE;
		VIDECAN            CANDIDATO.IDECAN%TYPE;
		VESTDOC            CANDIDATO.ESTCAN%TYPE;
		VNOMIDECAN         CANDIDATO.NOMIDECAN%TYPE;
		VEXPIDECAN         CANDIDATO.EXPIDECAN%TYPE;
		VSTRSOCECO         CANDIDATO.STR_SOCECO%TYPE;
		VDATNASCAN         CANDIDATO.DATNASCAN%TYPE;
		VDATINSCAN         CANDIDATO.DATINSCAN%TYPE;
		VENDCAN            CANDIDATO.ENDCAN%TYPE;
		VBAICAN            CANDIDATO.BAICAN%TYPE;
		VCIDCAN            CANDIDATO.CIDCAN%TYPE;
		VCEPCAN            CANDIDATO.CEPCAN%TYPE;
		VTELCAN            CANDIDATO.TELCAN%TYPE;
		VESTCAN            CANDIDATO.ESTCAN%TYPE;
		VFLGERRO           NUMBER;
		VDATPGTO           INSCRICAO.DATPGTO%TYPE;
		VEMAILCAN          CANDIDATO.EMAIL%TYPE;
		VCID_ESCOLHIDA     CIDADE.COD_CIDADE%TYPE;
		VCODCIDPROVA       CANDIDATO.CODCIDPROVA%TYPE;
		VIND_ALUNO_FUNCESI CANDIDATO.IND_ALUNO_FUNCESI%TYPE;
	
	BEGIN
	
		UTL_FILE.FCLOSE_ALL;
		-- =====                                                                                                                                                                                                         
		-- Cria o arquivo de log em disco                                                                                                                                                                                
		P_NOM_ARQUIVO_LOG_ERRO := 'FI_' || TO_CHAR(SYSDATE,
												   'MMDDMISS') || '.LOG';
		FILE_HANDLE_LOG        := UTL_FILE.FOPEN(F_DADOS_FTP(5),
												 P_NOM_ARQUIVO_LOG_ERRO,
												 'w');
		SLINHABRANCO           := ' ';
		SLINHALIMITE           := RPAD('=',
									   120,
									   '=');
		-- =====                                                                                                                                                                                                         
		-- Imprime o cabecalho                                                                                                                                                                                           
		-- =====                                                                                                                                                                                                         
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SCABECALHO := 'Arquivo de Log: IMPORTACAO DE DADOS - FICHAS DE INSCRICAO';
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Usuario: ' || USER || ' Data: ' || TO_CHAR(SYSDATE,
																  'DD/MM/YYYY HH24:MI:SS');
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SCABECALHO := 'Arquivo: ' || P_NOM_ARQUIVO;
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SCABECALHO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHALIMITE);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
		SP_GRAVA_LOG(FILE_HANDLE_LOG,
					 SLINHABRANCO);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		UTL_FILE.GET_LINE(F,
						  SBUFFER);
	
		IF LENGTH(SBUFFER) <> 475 THEN
			SLINHA := 'Arquivo nao e de fichas de inscricao';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			RAISE E_TIPO_ARQ_INVALIDO;
		END IF;
	
		--UTL_FILE.FCLOSE(f);                                                                                                                                                                                            
		--UTL_FILE.FCLOSE_ALL;                                                                                                                                                                                           
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		--  f := utl_file.fopen( f_DADOS_FTP( 5 ), p_nom_arquivo, 'r' );                                                                                                                                                   
	
		P_NUM_REGISTROS_LIDOS := 0;
		VFLGERRO              := 0;
	
		BEGIN
		
			WHILE UTL_FILE.IS_OPEN(F) LOOP
				-- lê o arquivo até o final                                                                                                                                                    
			
				P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
			
				UTL_FILE.GET_LINE(F,
								  SBUFFER);
			
				IF LENGTH(SBUFFER) <> 475 THEN
					IF (VFLGERRO > 0) THEN
						SLINHA := 'ESTE ARQUIVO CONTEM ' || TO_CHAR(VFLGERRO,
																	'000000') || ' ERRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SLINHA := 'FORAM VERIFICADOS ' || TO_CHAR(P_NUM_REGISTROS_LIDOS - 1,
																  '000000') || ' REGISTRO(S). ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
					END IF;
					RAISE NO_DATA_FOUND;
				END IF;
			
				VCODCAN        := SUBSTR(SBUFFER,
										 41,
										 6);
				VNOMCAN        := SUBSTR(SBUFFER,
										 47,
										 39);
				VSEXCAN        := SUBSTR(SBUFFER,
										 86,
										 1);
				VCANHOTO       := SUBSTR(SBUFFER,
										 87,
										 1);
				VOPCLIN        := SUBSTR(SBUFFER,
										 88,
										 1);
				VDEFCAN        := SUBSTR(SBUFFER,
										 89,
										 1);
				VDATNASCAN_AUX := SUBSTR(SBUFFER,
										 105,
										 6);
				VDATINSCAN_AUX := SUBSTR(SBUFFER,
										 111,
										 6);
				-- ALTERADO PARA IMPORTAR A SEGUNDA OPCAO DE CURSO                                                                                                                                                           
				--vCodCur           := substr(sBuffer,119,2);                                                                                                                                                                
				VCODCUR        := SUBSTR(SBUFFER,
										 117,
										 2);
				VCODTUR        := SUBSTR(SBUFFER,
										 119,
										 1);
				VCID_ESCOLHIDA := SUBSTR(SBUFFER,
										 471,
										 4);
			
				-- Troca a opção de língua                                                                                                                                                                                   
				IF (VOPCLIN = 'I') THEN
					VOPCLIN := '1';
				ELSIF (VOPCLIN = 'F') THEN
					VOPCLIN := '2';
				ELSIF (VOPCLIN = 'E') THEN
					VOPCLIN := '3';
				ELSIF (VOPCLIN IS NULL)
					  OR (VOPCLIN = ' ') THEN
					VOPCLIN := '0';
				END IF;
			
				-- Verificando se existe a cidade cadastrada                                                                                                                                                                 
				-- Cidade Escolhida                                                                                                                                                                                          
				IF (VCID_ESCOLHIDA = '0806') THEN
					--or (vCid_Escolhida = '') then                                                                                                                                           
					VCID_ESCOLHIDA := 806;
				ELSIF VCID_ESCOLHIDA = '0177' THEN
					VCID_ESCOLHIDA := 177;
				ELSIF VCID_ESCOLHIDA = '0650' THEN
					VCID_ESCOLHIDA := 650;
				ELSIF VCID_ESCOLHIDA = '1514' THEN
					VCID_ESCOLHIDA := 1514;
				END IF;
			
				-- Curso diferente de Direito                                                                                                                                                                                
				IF (VCODCUR <> '94')
				   OR (VCODCUR <> '96') THEN
					VCODTUR := 5;
				ELSE
					VCODTUR := VCODTUR;
				END IF;
			
				-- ===================================================================                                                                                                                                       
				-- Consistindo o arquivo a ser importado                                                                                                                                                                     
				-- ===================================================================                                                                                                                                       
				-- Verificando se a data de nascimento do candidato é válida                                                                                                                                                 
				BEGIN
					SELECT TO_DATE(VDATNASCAN_AUX,
								   'DDMMRR')
					  INTO VDATNASCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Nascimento do Candidato (Posicao: 105) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se a data de inscrição do candidato é válida                                                                                                                                                  
				BEGIN
					SELECT TO_DATE(VDATINSCAN_AUX,
								   'DDMMYY')
					  INTO VDATINSCAN
					  FROM DUAL;
				EXCEPTION
					WHEN OTHERS THEN
						SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
													   '000000') || ' Inscricao: ' || VCODCAN;
						SLINHA := SLINHA || ' - Data de Inscricao do Candidato (Posicao: 111) e invalida. ';
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHA);
						SP_GRAVA_LOG(FILE_HANDLE_LOG,
									 SLINHALIMITE);
				END;
			
				-- Verificando se o Sexo eh igual a "F" ou "M"                                                                                                                                                               
				IF (VSEXCAN <> 'F' AND VSEXCAN <> 'M') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 86';
					SLINHA := SLINHA || ' - O Sexo esta diferente de "F" ou "M". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se o campo Canhoto eh igual a "S" ou "N"                                                                                                                                                      
				IF (VCANHOTO <> 'S' AND VCANHOTO <> 'N') THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 87';
					SLINHA := SLINHA || ' - O campo Canhoto esta diferente de "S" ou "N". ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a cidade cadastrada                                                                                                                                                                 
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CIDADE
				 WHERE COD_CIDADE = VCID_ESCOLHIDA;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Cidade Escolhida: ' || VCID_ESCOLHIDA || ' - Posicao: 471';
					--sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Cidade Escolhida: ' || vCid_Escolhida || ' - Posicao: 471';                                                                         
					SLINHA := SLINHA || ' - Nao existe esta cidade cadastrada. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe a opção de língua marcada pelo candidato                                                                                                                                            
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM OPCLINGUA
				 WHERE OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 88';
					SLINHA := SLINHA || ' - Nao existe esta opcao de lingua estrangeira moderna. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o turno marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM TURNO
				 WHERE CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Turno ' || VCODTUR; -- ' - Posicao: 119';                                                              
					SLINHA := SLINHA || ' - Nao existe este turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso marcado pelo candidato                                                                                                                                                      
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM CURSO
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno marcado pelo candidato                                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUR
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117 e 119';
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
				-- Verificando se existe o curso/turno/opção de língua marcado pelo candidato                                                                                                                                
				X := 0;
				SELECT COUNT(*)
				  INTO X
				  FROM RCURTUROPC
				 WHERE CODCONC = P_CODCONC
					   AND CODCUR = VCODCUR
					   AND CODTUR = VCODTUR
					   AND OPCLIN = VOPCLIN;
				IF (X = 0) THEN
					SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
												   '000000') || ' Inscricao: ' || VCODCAN || ' - Posicao: 117, 119 e 88 - ' || VCODCUR || '-' || VCODTUR || '-' || VOPCLIN;
					--sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan || ' - Posicao:  117, 119 e 88';                                                                            
					SLINHA := SLINHA || ' - Nao existe esta opcao de curso/turno/opcao de lingua. ';
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHA);
					SP_GRAVA_LOG(FILE_HANDLE_LOG,
								 SLINHALIMITE);
					VFLGERRO := VFLGERRO + 1;
				END IF;
			
			/*                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                      sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Inscricao: ' || vCodCan ;                                                                                                                
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinha );                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                      SP_GRAVA_LOG( file_handle_log, sLinhaLimite );                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                      */
			END LOOP;
		EXCEPTION
			WHEN OTHERS THEN
				-- fim da leitura do arquivo                                                                                                                                                                 
				SLINHA := 'FIM DE CONSISTENCIAS DO ARQUIVO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
		END;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- ==================================================================================                                                                                                                            
		-- Importa definitivamente os dados do arquivo texto.                                                                                                                                                            
		-- ==================================================================================                                                                                                                            
	
		IF VFLGERRO > 0 THEN
			DBMS_OUTPUT.PUT_LINE('NAO FORAM IMPORTADOS NENHUM REGISTRO.');
			SLINHA := 'NAO FORAM IMPORTADOS NENHUM REGISTRO.';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE(F);
			RAISE_APPLICATION_ERROR(-20500,
									'x');
		END IF;
	
		-- Fecha o arquivo de importação.                                                                                                                                                                                
		UTL_FILE.FCLOSE(F);
	
		-- Abre o arquivo de importação no modo leitura                                                                                                                                                                  
		F := UTL_FILE.FOPEN(F_DADOS_FTP(5),
							P_NOM_ARQUIVO,
							'r');
	
		P_NUM_REGISTROS_LIDOS := 0;
	
		WHILE UTL_FILE.IS_OPEN(F) LOOP
			-- lê o arquivo até o final                                                                                                                                                      
		
			P_NUM_REGISTROS_LIDOS := P_NUM_REGISTROS_LIDOS + 1;
		
			UTL_FILE.GET_LINE(F,
							  SBUFFER);
		
			IF LENGTH(SBUFFER) <> 475 THEN
				-- Grava o resto da importação                                                                                                                                                                               
				COMMIT;
				SLINHA := 'O ARQUIVO FOI IMPORTADO COM SUCESSO.';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				UTL_FILE.FCLOSE_ALL;
				RAISE NO_DATA_FOUND;
			END IF;
		
			VCODCAN        := TRIM(SUBSTR(SBUFFER,
										  41,
										  6));
			VNOMCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												47,
												39)));
			VSEXCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												86,
												1)));
			VCANHOTO       := UPPER(TRIM(SUBSTR(SBUFFER,
												87,
												1)));
			VOPCLIN        := TRIM(SUBSTR(SBUFFER,
										  88,
										  1));
			VDEFCAN        := UPPER(TRIM(SUBSTR(SBUFFER,
												89,
												1)));
			VTIPDOC        := TRIM(SUBSTR(SBUFFER,
										  90,
										  1));
			VIDECAN        := TRIM(SUBSTR(SBUFFER,
										  91,
										  12));
			VESTDOC        := TRIM(SUBSTR(SBUFFER,
										  103,
										  2));
			VDATNASCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  105,
										  6));
			VDATINSCAN_AUX := TRIM(SUBSTR(SBUFFER,
										  111,
										  6));
			-- ALTERADO PARA IMPORTAR A SEGUNDA OPCAO DE CURSO                                                                                                                                                             
			-- vCodCur          := substr(sBuffer,119,2);                                                                                                                                                                  
			VCODCUR    := TRIM(SUBSTR(SBUFFER,
									  117,
									  2));
			VCODTUR    := TRIM(SUBSTR(SBUFFER,
									  119,
									  1));
			VSTRSOCECO := SUBSTR(SBUFFER,
								 121,
								 250);
			VENDCAN    := UPPER(TRIM(SUBSTR(SBUFFER,
											371,
											34)));
			VBAICAN    := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
												   405,
												   22),
											1,
											20)));
			VCIDCAN    := UPPER(TRIM(SUBSTR(SUBSTR(SBUFFER,
												   427,
												   23),
											1,
											20)));
			-- OBSERVACAO CURSO DE DIREITO ERRADA A FICHA                                                                                                                                                                  
			/*                                                                                                                                                                                                             
            vCEPCan             := upper(trim(substr(sBuffer,449,5) || '-' || substr(sBuffer,454,3)));                                                                                                                     
            vTelCan             := upper(trim(substr(sBuffer,457,11)));                                                                                                                                                    
            FICHAS NORMAIS                                                                                                                                                                                                 
            */
			VCEPCAN            := UPPER(TRIM(SUBSTR(SBUFFER,
													450,
													5) || '-' || SUBSTR(SBUFFER,
																		455,
																		3)));
			VTELCAN            := UPPER(TRIM(SUBSTR(SBUFFER,
													458,
													10)));
			VESTCAN            := UPPER(TRIM(SUBSTR(SBUFFER,
													468,
													2)));
			VIND_TREINANTE     := UPPER(TRIM(SUBSTR(SBUFFER,
													470,
													1)));
			VCID_ESCOLHIDA     := SUBSTR(SBUFFER,
										 471,
										 4);
			VIND_ALUNO_FUNCESI := UPPER(TRIM(SUBSTR(SBUFFER,
													475,
													1)));
		
			-- Troca os dados do arquivo texto para o que existe no Banco de Dados                                                                                                                                         
			-- Converte para o formato data                                                                                                                                                                                
			VDATNASCAN := TO_DATE(VDATNASCAN_AUX,
								  'DDMMRR');
			VDATINSCAN := TO_DATE(VDATINSCAN_AUX,
								  'DDMMYY');
		
			-- Troca a opção de língua                                                                                                                                                                                     
			IF (VOPCLIN = 'I') THEN
				VOPCLIN := '1';
			ELSIF (VOPCLIN = 'F') THEN
				VOPCLIN := '2';
			ELSIF (VOPCLIN = 'E') THEN
				VOPCLIN := '3';
			ELSIF (VOPCLIN IS NULL)
				  OR (VOPCLIN = ' ') THEN
				VOPCLIN := '0';
			END IF;
		
			-- Curso diferente de Direito                                                                                                                                                                                  
			IF (VCODCUR <> '94' OR VCODCUR <> '96') THEN
				VCODTUR := 5;
			ELSE
				VCODTUR := VCODTUR;
			END IF;
		
			-- Troca o tipo do documento                                                                                                                                                                                   
			IF TRIM(VTIPDOC) = 1 THEN
				VTIPDOC    := '01';
				VNOMIDECAN := 'Cart.de Identidade';
				VEXPIDECAN := 'SSP/' || VESTDOC;
			ELSIF TRIM(VTIPDOC) = 2 THEN
				VTIPDOC    := '02';
				VNOMIDECAN := 'Cart.de Trabalho';
				VEXPIDECAN := 'MT';
			ELSIF TRIM(VTIPDOC) = 3 THEN
				VTIPDOC    := '03';
				VNOMIDECAN := 'Forçs Armadas';
				VEXPIDECAN := 'FA';
			ELSIF TRIM(VTIPDOC) = 4 THEN
				VTIPDOC    := '04';
				VNOMIDECAN := 'Polícia Militar';
				VEXPIDECAN := 'PM';
			ELSIF TRIM(VTIPDOC) = 5 THEN
				VTIPDOC    := '05';
				VNOMIDECAN := 'Cons.Regional';
				VEXPIDECAN := 'CR';
			ELSIF TRIM(VTIPDOC) = 6 THEN
				VTIPDOC    := '06';
				VNOMIDECAN := 'O.A.B';
				VEXPIDECAN := 'OAB';
			ELSIF TRIM(VTIPDOC) = 7 THEN
				VTIPDOC    := '07';
				VNOMIDECAN := 'Passaporte';
				VEXPIDECAN := 'PAS';
			END IF;
		
			IF ((TRIM(VIND_TREINANTE) = '') OR (VIND_TREINANTE IS NULL)) THEN
				VIND_TREINANTE := 'N';
			ELSIF VIND_TREINANTE = 'T' THEN
				VIND_TREINANTE := 'S';
			END IF;
		
			-- Troca o tipo de deficiencia                                                                                                                                                                                 
			IF (VDEFCAN IS NULL)
			   OR (VDEFCAN = ' ')
			   OR (VDEFCAN = 'N') THEN
				VDEFCAN := '03';
			ELSIF (VDEFCAN = 'V')
				  OR (VDEFCAN = 'S') THEN
				VDEFCAN := '01';
			ELSIF (VDEFCAN = 'F') THEN
				VDEFCAN := '02';
			END IF;
		
			-- Se o local de pagamento for o circuito universitario entao a data de pagamento = data inscricao                                                                                                             
			IF P_CODLOCPAG = '003' THEN
				VDATPGTO := VDATINSCAN;
			END IF;
		
			-- Verificando se existe a cidade cadastrada                                                                                                                                                                   
			-- Cidade Escolhida                                                                                                                                                                                            
			IF (VCID_ESCOLHIDA = '0806')
			   OR (VCID_ESCOLHIDA = '') THEN
				VCID_ESCOLHIDA := '806';
			ELSIF VCID_ESCOLHIDA = '0177' THEN
				VCID_ESCOLHIDA := '177';
			ELSIF VCID_ESCOLHIDA = '0650' THEN
				VCID_ESCOLHIDA := '650';
			ELSIF VCID_ESCOLHIDA = '1514' THEN
				VCID_ESCOLHIDA := '1514';
			END IF;
		
			-- Verificando se existe a cidade cadastrada                                                                                                                                                                   
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CIDADE
			 WHERE COD_CIDADE = VCID_ESCOLHIDA;
			IF (X = 0) THEN
				SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
											   '000000') || ' Cidade Escolhida: ' || VCID_ESCOLHIDA || ' - Posicao: 471';
				--sLinha := 'Linha: ' || to_char(p_num_registros_lidos,'000000') || ' Cidade Escolhida: ' || vCid_Escolhida || ' - Posicao: 471';                                                                           
				SLINHA := SLINHA || ' - Nao existe esta cidade cadastrada. ';
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHA);
				SP_GRAVA_LOG(FILE_HANDLE_LOG,
							 SLINHALIMITE);
				VFLGERRO := VFLGERRO + 1;
			END IF;
		
			-- Verifica se o candidato existe na tabela de candidato e opção de curso (rcandcurturopc)                                                                                                                     
			X := 0;
			SELECT COUNT(*)
			  INTO X
			  FROM CANDIDATO
			 WHERE CODCONC = P_CODCONC
				   AND CODCAN = VCODCAN;
		
			IF (X = 0) THEN
				-- Insere o candidato na tabela de candidatos                                                                                                                                                                
				INSERT INTO CANDIDATO
					(CODCONC,
					 CODCAN,
					 NOMCAN,
					 SEXCAN,
					 DATNASCAN,
					 IDECAN,
					 NOMIDECAN,
					 EXPIDECAN,
					 TELCAN,
					 ENDCAN,
					 BAICAN,
					 CIDCAN,
					 ESTCAN,
					 CEPCAN,
					 DATINSCAN,
					 DATPAGCAN,
					 CODLOCPAG,
					 SITCAN,
					 CLACAN,
					 CLACAN2,
					 CODLOC,
					 CODSAL,
					 EMAIL,
					 TOTPON,
					 TOTPON2,
					 CANHOTO,
					 TAG,
					 CODCANANT,
					 REGFCH,
					 FLGMAT,
					 DATINCCAN,
					 str_soceco,
					 SITCAN2,
					 CODTPODEF,
					 IND_TREINANTE,
					 SITCANGER,
					 CLACANGER,
					 CODCIDPROVA,
					 CODCIDESCOLHA,
					 NOM_PAI,
					 NOM_MAE,
					 IND_ALUNO_FUNCESI,
					 REG_EMPREGADO,
					 NOM_EMPREGADO,
					 LOC_TRABALHO,
					 TIP_ESCOLA)
				
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VNOMCAN,
					 VSEXCAN,
					 VDATNASCAN,
					 VIDECAN,
					 VNOMIDECAN,
					 VEXPIDECAN,
					 VTELCAN,
					 VENDCAN,
					 VBAICAN,
					 VCIDCAN,
					 VESTCAN,
					 VCEPCAN,
					 VDATINSCAN,
					 VDATPGTO,
					 P_CODLOCPAG,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NULL,
					 NVL(VCANHOTO,
						 'N'),
					 'N',
					 NULL,
					 'N',
					 'N',
					 SYSDATE,
					 VSTRSOCECO,
					 NULL,
					 NVL(VDEFCAN,
						 '03'),
					 NVL(VIND_TREINANTE,
						 'N'),
					 NULL,
					 NULL,
					 NULL,
					 VCID_ESCOLHIDA,
					 NULL,
					 NULL,
					 VIND_ALUNO_FUNCESI,
					 NULL,
					 NULL,
					 NULL,
					 NULL);
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				INSERT INTO RCANDCURTUROPC
					(CODCONC,
					 CODCAN,
					 CODCUR,
					 CODTUR,
					 OPCLIN,
					 NROOPC)
				VALUES
					(P_CODCONC,
					 VCODCAN,
					 VCODCUR,
					 VCODTUR,
					 VOPCLIN,
					 '1');
			
			ELSE
				-- Atualiza os dados do candidato na tabela de candidatos                                                                                                                                                    
				UPDATE CANDIDATO
				   SET NOMCAN            = VNOMCAN,
					   SEXCAN            = VSEXCAN,
					   DATNASCAN         = VDATNASCAN,
					   IDECAN            = VIDECAN,
					   NOMIDECAN         = VNOMIDECAN,
					   EXPIDECAN         = VEXPIDECAN,
					   TELCAN            = VTELCAN,
					   ENDCAN            = VENDCAN,
					   BAICAN            = VBAICAN,
					   CIDCAN            = VCIDCAN,
					   ESTCAN            = VESTCAN,
					   CEPCAN            = VCEPCAN,
					   DATINSCAN         = VDATINSCAN,
					   DATPAGCAN         = VDATPGTO,
					   CODLOCPAG         = P_CODLOCPAG,
					   SITCAN            = NULL,
					   CLACAN            = NULL,
					   CLACAN2           = NULL,
					   CODLOC            = NULL,
					   CODSAL            = NULL,
					   EMAIL             = NULL,
					   TOTPON            = NULL,
					   TOTPON2           = NULL,
					   CANHOTO           = NVL(VCANHOTO,
											   'N'),
					   TAG               = 'N',
					   CODCANANT         = NULL,
					   REGFCH            = 'N',
					   FLGMAT            = 'N',
					   str_soceco        = VSTRSOCECO,
					   SITCAN2           = NULL,
					   CODTPODEF         = NVL(VDEFCAN,
											   '03'),
					   IND_TREINANTE     = VIND_TREINANTE,
					   SITCANGER         = NULL,
					   CLACANGER         = NULL,
					   CODCIDPROVA       = VCODCIDPROVA,
					   CODCIDESCOLHA     = VCID_ESCOLHIDA,
					   NOM_PAI           = NULL,
					   NOM_MAE           = NULL,
					   IND_ALUNO_FUNCESI = VIND_ALUNO_FUNCESI,
					   REG_EMPREGADO     = NULL,
					   NOM_EMPREGADO     = NULL,
					   LOC_TRABALHO      = NULL,
					   TIP_ESCOLA        = NULL
				
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN;
			
				-- Insere a opção de Curso do Candidato                                                                                                                                                                      
				UPDATE RCANDCURTUROPC
				   SET CODCUR = VCODCUR,
					   CODTUR = VCODTUR,
					   OPCLIN = VOPCLIN
				 WHERE CODCONC = P_CODCONC
					   AND CODCAN = VCODCAN
					   AND NROOPC = '1';
			END IF;
		
			IF SUBSTR(TO_CHAR(P_NUM_REGISTROS_LIDOS),
					  -2) = '00' THEN
				COMMIT;
			END IF;
		
		END LOOP;
	
	EXCEPTION
		WHEN E_TIPO_ARQ_INVALIDO THEN
			-- Tipo de arquivo inválido para esta importação.                                                                                                                                  
			ROLLBACK;
			SLINHA := 'Linha: ' || TO_CHAR(P_NUM_REGISTROS_LIDOS,
										   '000000');
			SLINHA := SLINHA || ' - Tipo de arquivo e invalido';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN NO_DATA_FOUND THEN
			-- fim da leitura do arquivo                                                                                                                                                            
			COMMIT;
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_PATH THEN
			ROLLBACK;
			SLINHA := 'CAMINHO DO ARQUIVO E INVALIDO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.READ_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE LEITURA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.WRITE_ERROR THEN
			ROLLBACK;
			SLINHA := 'ERRO DE ESCRITA DO ARQUIVO';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_MODE THEN
			ROLLBACK;
			SLINHA := 'INVALID MODE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			ROLLBACK;
			SLINHA := 'INVALID FILE_HANDLE';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INVALID_OPERATION THEN
			ROLLBACK;
			SLINHA := 'OPERACAO INVALIDA';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN UTL_FILE.INTERNAL_ERROR THEN
			ROLLBACK;
			SLINHA := 'INTERNAL_ERROR';
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			UTL_FILE.FCLOSE_ALL;
		
		WHEN OTHERS THEN
			ROLLBACK;
			--sLinha := 'ROLLBACK';                                                                                                                                                                                        
			SLINHA := ('SQLCODE=  ' || SQLCODE || ' SQLERRM ' || SQLERRM);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHA);
			SP_GRAVA_LOG(FILE_HANDLE_LOG,
						 SLINHALIMITE);
			--raise_application_error(-20500, 'Rollback');                                                                                                                                                                 
			UTL_FILE.FCLOSE_ALL;
	END;

END PC_IMPORTA_DADOS;
/
