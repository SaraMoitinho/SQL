SELECT IEN.SGL_INSTITUICAO AS "Instituicao",
	   GS.DSC_GRP_SOLICITACAO AS "Grupo de solicitacao",
	   TSO.COD_TPO_SOLICITACAO AS "Cod. solicitacao",
	   TSO.DSC_TPO_SOLICITACAO AS "Tipo de solicitacao",
	   DECODE(TSO.IND_DOCUMENTO,
			  'S',
			  'Servico',
			  'D',
			  'Documento') AS " Tipo",
	   DECODE(TSO.IND_PERM_COPIA_DISCIPLINA,
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Permite copia disciplina",
	   DECODE(TSO.IND_INSERE_TODAS_DISCIPLINAS,
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Insere todas disciplinas",
	   DECODE(TSO.IND_CAMPUS_SOLICITACAO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Selecionar campus",
	   DECODE(TSO.IND_UPLOAD,
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Permitir anexar arquivo",
	   TSO.NUM_MAX_ARQ_UPLOAD "Qtd. max. de arquivos",
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  6),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Resultado protocolo via web",
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  24),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') "Biblioteca impede abertura",
	   DECODE(TSO.IND_EXTERNO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Reg. Acompanhamento Externo",
	   DECODE(TSO.IND_DISCIPLINA,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Requer Disciplina",
	   
	   DECODE(TSO.IND_EXIBIR_WEB,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Disponivel na Web",
	   DECODE(TSO.IND_EXIBE_OBSERVACAO_WEB,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Exibe Observacao na Web",
	   DECODE(TSO.IND_PERIODO_FECHADO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Permite Per.Letivo Fechado",
	   DECODE(TSO.IND_LIBERACAO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Libera��o de cadastro",
	   DECODE(TSO.IND_EMAIL_PROFESSOR,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Enviar email professor",
	   
	   DECODE(TSO.IND_DILATACAO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Dilata��o TCC",
	   
	   DECODE(TSO.IND_MOTIVO_OBRIGATORIO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Motivo obrigatorio solicitacao",
	   
	   DECODE(TSO.IND_PERM_SOL_ABERTO,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Uma solic. deste tipo aberta",
	   
	   DECODE(TSO.IND_PERM_ATUALIZA_EMAIL,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Atualiza email/contato aluno",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  8),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Escolha opcao curso",
	   DECODE(TSO.IND_BLOQ_PROC_JUDIC,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Bloq. por processo Judicial",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  21),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Exibe movimenta��o disciplina",
	   
	   DECODE(TSO.IND_INTEGRA_CLIENTE,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Integra cliente Datasul",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  17),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Escolha Periodo Letivo",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  18),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Escolha Curso",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  19),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Escolha de Campus",
	   
	   DECODE(SUBSTR(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
											  20),
					 1,
					 1),
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Escolha de Turno",
	   TSO.NUM_MAX_DISCIPLINAS "Max. disciplinas per.Letivo",
	   TSO.NUM_MAX_DISC_SOL "Max. disciplina solicitacao",
	   TSO.IDT_RESPONSAVEL "Responsavel",
	   
	   (SELECT CNF.DSC_CNF_RELATORIO
		  FROM DBADM.CONFIG_RELATORIO CNF
		 WHERE CNF.COD_CNF_RELATORIO = TSO.COD_CNF_RELATORIO) "Relatorio Solicitacao",
         
         (SELECT REL.COD_STATUS_ETAPA FROM DBSIAF.CONFIG_REL_PROTOCOLO REL
	   
	   (SELECT CRP.QTD_DIAS_PRAZO
		  FROM DBSIAF.CONFIG_REL_PROTOCOLO CRP
		 WHERE CRP.COD_TPO_SOLICITACAO = TSO.COD_TPO_SOLICITACAO) "Quant. Dias Prazo",
	   (SELECT CRP.IND_FINALIZA_APOS_IMPRESSAO
		  FROM DBSIAF.CONFIG_REL_PROTOCOLO CRP
		 WHERE CRP.COD_TPO_SOLICITACAO = TSO.COD_TPO_SOLICITACAO) "Finaliza ap�s impressao",
	   (SELECT TLA.DSC_TPO_LANCAMENTO
		  FROM DBSIAF.TIPO_LANCAMENTO TLA
		 WHERE TLA.COD_TPO_LANCAMENTO = DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
																 23)) "Tipo Lancamento",
	   TO_NUMBER(DBSIAF.F_PARAMETRO_SOLIC(TSO.COD_TPO_SOLICITACAO,
										  22)) "Valor Evento",
	   DECODE(TSI.IND_COBRANCA,
			  'S',
			  'Sim',
			  'N',
			  'Nao') AS "Possui cobranca",
	   DECODE(TSI.IND_INSERIR_BOLETA,
			  'S',
			  'Sim',
			  'Nao') "Insere no boleto",
	   DECODE(TSI.IND_CONCLUI_AUTOMATICO,
			  'S',
			  'Sim',
			  'Nao') AS "Conclui apos pagamento",
	   DECODE(TSI.IND_CONCLUI_SOL_PGTO,
			  'S',
			  'Sim',
			  'Nao') AS "Conclui somente apos pagto?",
	   DECODE(TSI.IND_VERIFICA_DEBITO,
			  'S',
			  'Sim',
			  'Nao') AS "Verifica D�bitos do aluno?",
	   DECODE(TSI.IDT_INSERE_BOLETA,
			  'I',
			  'Inclusao',
			  'Aprovacao') AS "Insere Boleta",
	   DECODE(TSI.VAL_TAXA,
			  NULL,
			  'Nao Possui',
			  TSI.VAL_TAXA) AS "Valor da Taxa",
	   DECODE(TSI.NUM_INI_COBRANCA,
			  NULL,
			  'Nao possui',
			  TSI.NUM_INI_COBRANCA) "Cobrar a partir da via:",
	   DECODE(TSI.IND_COBRANCA_PL,
			  NULL,
			  'Nao possui',
			  'S',
			  'Sim',
			  'N',
			  'Nao',
			  TSI.IND_COBRANCA_PL) "Por periodo Letivo",
	   DECODE(TSI.IDT_FORMA_COBRANCA,
			  'I',
			  'Independente',
			  'D',
			  'Disciplina',
			  'F',
			  'Num. Copias',
			  NULL,
			  'Nao possui') AS "Forma Cobranca",
	   DECODE(TSI.NUM_DIAS_VENC_BOLETA,
			  NULL,
			  'Nao possui',
			  TSI.NUM_DIAS_VENC_BOLETA) "Dias adicionais no boleto",
	   DECODE(TL.DSC_TPO_LANCAMENTO,
			  NULL,
			  'Nao possui',
			  TL.DSC_TPO_LANCAMENTO) AS "Tipo lancamento",
	   DECODE(MC.DSC_MODALIDADE,
			  NULL,
			  'Nao possui',
			  MC.DSC_MODALIDADE) AS "Modalidade",
	   DECODE(TSI.PRAZO_DILATACAO,
			  NULL,
			  'Nao possui',
			  TSI.PRAZO_DILATACAO) AS "Prazo dilatacao",
	   DECODE(TSI.DAT_PRAZO,
			  NULL,
			  'Nao possui',
			  TSI.DAT_PRAZO) AS "Prazo para solicitacao",
	   (SELECT CCT.DSC_CNF_CONSULTA
		  FROM DBADM.CONFIG_CONSULTA CCT
		 WHERE CCT.COD_CNF_CONSULTA = TSO.COD_CONS_PERMISSAO
			   AND EXISTS (SELECT 1
				  FROM DBADM.CONFIG_CONS_ITEM_MENU CCI
				 WHERE CCI.COD_CNF_CONSULTA = CCT.COD_CNF_CONSULTA
					   AND CCI.COD_ITEM_MENU = 3622)) AS "Permissao",
	   (SELECT CASE
				   WHEN TSO.DSC_INFORMACAO IS NULL THEN
					'Nao Possui'
				   ELSE
					'Possui'
			   END
		  FROM DUAL) AS "Inform. ao Aluno/Documentos"

  FROM DBSIAF.TIPO_SOLICITACAO             TSO,
	   DBSIAF.TIPO_SOLICITACAO_INSTITUICAO TSI,
	   DBSIAF.INSTITUICAO_ENSINO           IEN,
	   DBSIAF.TIPO_LANCAMENTO              TL,
	   DBSIAF.MOD_COBRANCA                 MC,
	   GRP_SOLICITACAO                     GS
       
 WHERE TSO.IND_LIBERACAO = 'S'
	   AND TSO.COD_TPO_SOLICITACAO = TSI.COD_TPO_SOLICITACAO
	   AND TSI.COD_INSTITUICAO = IEN.COD_INSTITUICAO
	   AND TSO.COD_TPO_SOLICITACAO = NVL(&P_COD_TPO_SOLICITACAO,
										 TSO.COD_TPO_SOLICITACAO)
	   AND TSI.COD_TPO_LANCAMENTO = TL.COD_TPO_LANCAMENTO(+)
	   AND TSI.COD_MODALIDADE = MC.COD_MODALIDADE(+)
	   AND GS.COD_GRP_SOLICITACAO = TSO.COD_GRP_SOLICITACAO
 ORDER BY IEN.COD_INSTITUICAO,
		  TSO.COD_TPO_SOLICITACAO
