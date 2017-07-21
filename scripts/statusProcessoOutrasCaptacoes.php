<?php
	function convert($size)
	 {
	    $unit=array('b','kb','mb','gb','tb','pb');
	    return @round($size/pow(1024,($i=floor(log($size,1024)))),2).' '.$unit[$i];
	 }
	
	include_once("phpxmlconf.inc");
	define("PHPXML_EXIBIR_SQL",'2');
	include_once(PHPXML_ROOT_DIR . "classes/Vestib/class.Inscricao.php");
	include_once(PHPXML_ROOT_DIR . "classes/Vestib/class.RegistroDeferimento.php");
	include_once(PHPXML_ROOT_DIR . "classes/Vestib/class.TipoConcurso.php");
	include_once(PHPXML_ROOT_DIR . "classes/Vestib/class.TipoEventoConcurso.php");
	include_once(PHPXML_ROOT_DIR . "classes/Siaf/class.Aluno.php");
	include_once(PHPXML_ROOT_DIR . "classes/webService/class.AlunoUna.php");
	include_once(PHPXML_ROOT_DIR . "classes/webService/class.AlunoSiaf.php");
	include_once(PHPXML_ROOT_DIR."classes/Vestib/class.InstituicaoEnsino.php");
	include_once(PHPXML_ROOT_DIR."classes/Vestib/class.Candidato.php");
	//Retira o tempo limite do script
	set_time_limit(0);
	//statusProcessoVESTIB

	 //busca inscricoes deferidas
	 $objInscricao = new Inscricao("xvestib",null);
	 
	 if (empty($_REQUEST['cpfcan']))
	 {
		 $objInscricao->iniciarLogWebservice();
	 }
	 $strFiltro = " 
	 EXISTS (
	 	SELECT 
			EVE.CODCONC 
		FROM 
			DBVESTIB.EVENTO_CONCURSO EVE 
		WHERE 
			EVE.CODCONC = INSCRICAO.CODCONC AND
			EVE.CODTPOEVENTO = ".CODIGO_TIPO_EVENTO_CONCURSO_VERIFICACAO_POS_DEFERIMENTO." AND
			TRUNC(DATINIEVENTO) <= TRUNC(SYSDATE) AND
			TRUNC(DATFIMEVENTO) >= TRUNC(SYSDATE) 
			)
			";
			
		if (empty($_REQUEST['cpfcan']))
		{
			$strFiltro .= "
	 		AND EXISTS(
	 			SELECT 1
	 			FROM DBVESTIB.LOG_WEBSERVICE LWB
	 			WHERE LWB.CODCONC = INSCRICAO.CODCONC
	 				 AND LWB.CODINSC = INSCRICAO.CODINSC
	 				 AND TRUNC(LWB.DATINICIO) = TRUNC(SYSDATE)
	 		)
AND INSCRICAO.CODCONC = '2551'";
		}
	 
	 //if (!empty($_REQUEST['cpfcan']))
	// {
	//	 $strFiltro .= " AND INSCRICAO.CPFCAN = '".$_REQUEST['cpfcan']."' ";
	 //}

         // if (!empty($_REQUEST['codconc']))
         // {
         //     $strFiltro .= " AND INSCRICAO.CODCONC = '".$_REQUEST['codconc']."' ";
         // }
	 //$strFiltro .= " AND INSCRICAO.CODCONC = '1079' ";
	 //AND dbvestib.F_STATUS_INSCRICAO_PROCESSOCOD(INSCRICAO.CODINSC,INSCRICAO.CODCONC) in (13,14,15,16,17,18,21)	 
	 //$strFiltro .= "and inscricao.codinsc in(408174)";
   //$strFiltro .= " order by NOMCAN ";
	 $arrDados = $objInscricao->buscarTodos($strFiltro);
	 $arrDados = $arrDados->getRows();
	 //print count($arrDados);
	 //exit();
	 
	 $gstrInfomacaoLogCron = " Candidatos encontrados: ".count($arrDados)."
	 
";
	 $strMsgRetorno = "";
	 $totalInscricoes = count($arrDados);
	 for ($x=0; $x<$totalInscricoes; $x++)
	 {
		//limpa datas
		$strDataLiquidacao = null;
		$strDataGeracao = null;
		// recuperando aluno
		$arrDadosAluno = $arrDados[$x];
		$objAlunoUna = null;
		$objDeferimento = null;
		
		
		
		
		
		$objAluno = new Aluno("xvestib");
		$objAluno->_strCodCan = $arrDadosAluno['CODINSC'];
		$objAluno->_strCodConc = $arrDadosAluno['CODCONC'];
		
		
		//inicia classe do aluno
		
		$objAlunoUna = new AlunoSiaf();
		$gstrInfomacaoLogCron .= " Aluno  Siaf ";
			

		
		//define parametros
		$objAlunoUna->atualizaCpf($arrDadosAluno['CPFCAN']);
		$objAlunoUna->atualizaCurso($arrDadosAluno["CODCURSOCADSOFT1"]);			
		if(empty($arrDadosAluno["INDFIESPROUNI"]))
			$arrDadosAluno["INDFIESPROUNI"] = "N";
		
		
		// verificando cadastrado
		$objResultado = $objAlunoUna->verificarCadastroAluno($arrDadosAluno["ANOCONC"], $arrDadosAluno["SEMCONC"],$arrDadosAluno["CODCONC"],$arrDadosAluno["CODINSC"]);		
		if(!empty($objResultado[0]["RA"]))
		{
			$objResultado = $objResultado[0]; 
		}
		$gstrInfomacaoLogCron .= "(".$x.") ".$arrDadosAluno['NOMCAN']." (".$arrDadosAluno['CODCONC'].")  / CPF: ".$arrDadosAluno['CPFCAN']." Curso: ".$arrDadosAluno['CODCURSOCADSOFT1']." - ";
			
			 
		if (!empty($objResultado['RA']))
		{
			$gstrInfomacaoLogCron .= "aluno cadastrado (".$objResultado['RA'].") ";
			$intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_CADASTRO_CADSOFT;			
			$objResultado['RA'] = "";
			if ($arrDadosAluno["INDFIESPROUNI"]=="N")
			{		
				//verifica se já tem boleto de matricula				
				$objResultadoBoletaMatricula = $objAlunoUna->verificarGeracaoBoletoMatricula($arrDadosAluno["DATINIINS"],null);				
				if(!empty($objResultadoBoletaMatricula[0]['DATA_GERACAO']))
				{
					$objResultadoBoletaMatricula = $objResultadoBoletaMatricula[0];
				}			
				
				if (!empty($objResultadoBoletaMatricula['DATA_GERACAO']))
				{			 				 
					$strDataGeracao = $objResultadoBoletaMatricula['DATA_GERACAO'];
					$intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_BOLETO_MATRICULA_GERADO;
					$gstrInfomacaoLogCron .= " - boleta matricula gerada (".$objResultadoBoletaMatricula['DATA_GERACAO'].")";
				}
				else
				{
					// VERIFICA PENDENCIA FINANCEIRA
                    
                   $objResultadoPendencia = $objAlunoUna->verificarPendenciaFinanceiraAlunoProprio($arrDadosAluno['COD_PERIODO_LETIVO']);
					if ($objResultadoPendencia)
					{
					 $intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_PENDENCIA_FINANCEIRA;
					 $gstrInfomacaoLogCron .= " - aluno com pendencia";
					}
					else
					{
						$retBoleto = $objAluno->disponibilizarBoletoMatricula();
						if ($retBoleto["MSG_ERRO"]["valor"] != null) {
							 $gstrInfomacaoLogCron .= " - boleto do aluno não disponibilizado";
							$strMsgRetorno .= " Não foi possivel disponibilizar o boleto de matricula do aluno: ".$retBoleto["MSG_ERRO"]["valor"];
						}
					}
				}	
			}
			else
			{
				
				
				
				
				$intStatusInscricao = CODIGO_STATUS_AGUARDANDO_FIES_PROUNI;
				
				$objCandidato = new Candidato("xvestib",null,$objAluno->_strCodConc,$objAluno->_strCodCan);
				$objDadosBoleta = $objCandidato->buscarBoletaMatriculaDisp();
				$objDadosBoleta = $objDadosBoleta->getRows();
				//print('>>>>>>>>>>>>>>');
				//print_r($objDadosBoleta);
				if (!empty($objDadosBoleta[0]['DATGERACAO']))
				{
					$strDataGeracao = $objResultadoBoletaMatricula['DATA_GERACAO'];
					$intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_BOLETO_MATRICULA_GERADO;
					$gstrInfomacaoLogCron .= " - boleta matricula gerada (".$objResultadoBoletaMatricula['DATA_GERACAO'].")";
				}
				
				
			}
						
						 
			 //sem pendencia, vamos aos status de pagamento e enturmacao
			 if ($intStatusInscricao != CODIGO_STATUS_DEFERIMENTO_PENDENCIA_FINANCEIRA)
			 {
				 //$gstrInfomacaoLogCron .= " - aluno sem pendencias";
				 
				 // verificando liquidação do boleto
				 $objResultadoLiquidacaoBoletaMatricula = $objAlunoUna->verificarLiquidacaoBoletoMatricula($arrDadosAluno["DATINIINS"],null);				 
				 if(!empty($objResultadoLiquidacaoBoletaMatricula[0]['DATA_LIQUIDACAO']))
				 {
				 	$objResultadoLiquidacaoBoletaMatricula = $objResultadoLiquidacaoBoletaMatricula[0];
				 }
				 if (!empty($objResultadoLiquidacaoBoletaMatricula['DATA_LIQUIDACAO']))
				 {
					 $strDataLiquidacao = $objResultadoLiquidacaoBoletaMatricula['DATA_LIQUIDACAO'];
					 
					 $intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_BOLETO_MATRICULA_LIQUIDADO;
					 $gstrInfomacaoLogCron .= " - boleta paga (".$strDataLiquidacao.")";					 					 					 
					 
					 // verificando enturmação
					 $objResultadoBoletaEnturmacao = $objAlunoUna->verificarEnturmacaoAluno($arrDadosAluno["ANOCONC"],$arrDadosAluno["SEMCONC"]);
					 
					 
					//print "Enturmacao: ". (time() - $intInicio)."<BR>";
				 	 if(!empty($objResultadoBoletaEnturmacao[0]['DATA_MATRICULA']))
					 {
					 	$objResultadoBoletaEnturmacao = $objResultadoBoletaEnturmacao[0];
					 }
					 if (!empty($objResultadoBoletaEnturmacao['DATA_MATRICULA']))
					 {
						 $intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_ENTURMADO;
						 $gstrInfomacaoLogCron .= " - aluno enturmado";
					 }					 
				 }				 				
		     }
		 }  
		 else
		 {
			
			 print ' - verifica pendencia '.$arrDadosAluno["ANOCONC"].' e '.$arrDadosAluno["SEMCONC"].' ';
			 
		  	//se nao gerou, pode ter pendencia
		  	$objResultadoPendencia = false;
            $objResultadoPendencia = $objAlunoUna->verificarPendenciaFinanceiraAlunoProprio($arrDadosAluno['COD_PERIODO_LETIVO']);
		  			
			
			if ($objResultadoPendencia)
			{
				$intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_PENDENCIA_FINANCEIRA;
				$gstrInfomacaoLogCron .= " - aluno com pendencia";
			}
		  	else
			{
				$gstrInfomacaoLogCron .= " - aluno sem pendencias";
				 
				// verificando liquidação do boleto
				$objResultadoLiquidacaoBoletaMatricula = $objAlunoUna->verificarLiquidacaoBoletoMatricula($arrDadosAluno["DATINIINS"]);				 
				if(!empty($objResultadoLiquidacaoBoletaMatricula[0]['DATA_LIQUIDACAO']))
				{
					$objResultadoLiquidacaoBoletaMatricula = $objResultadoLiquidacaoBoletaMatricula[0];
				}
				if (!empty($objResultadoLiquidacaoBoletaMatricula['DATA_LIQUIDACAO']))
				{
					 $strDataLiquidacao = $objResultadoLiquidacaoBoletaMatricula['DATA_LIQUIDACAO'];
					 $intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_BOLETO_MATRICULA_LIQUIDADO;
					 $gstrInfomacaoLogCron .= " - boleta paga (".$strDataLiquidacao.")";
					 if($arrDadosAluno["INDFIESPROUNI"]=="S")
					 {
						  // verificando enturmação
						 $objResultadoBoletaEnturmacao = $objAlunoUna->verificarEnturmacaoAluno($arrDadosAluno["ANOCONC"],$arrDadosAluno["SEMCONC"]);						 						 
					 	 if(!empty($objResultadoBoletaEnturmacao[0]['DATA_MATRICULA']))
						 {
						 	$objResultadoBoletaEnturmacao = $objResultadoBoletaEnturmacao[0];
						 }
						 if (!empty($objResultadoBoletaEnturmacao['DATA_MATRICULA']))
						 {
							 $intStatusInscricao = CODIGO_STATUS_DEFERIMENTO_ENTURMADO;
							 $gstrInfomacaoLogCron .= " - aluno enturmado";
						 }
					 }					 
				}
				else
			 	{ 
			 		$gstrInfomacaoLogCron .= " - aluno não cadastrado";
			 		$intStatusInscricao = 'null';
			 	}				 				
			}		 	
		 }
		 		 
		 //verifica as datas recebidas
		 $strDataLiquidacao = trim($strDataLiquidacao);
		 $strDataGeracao = trim($strDataGeracao);
		 $bolDatasOk=false;
		 if ((empty($strDataGeracao) | strlen($strDataGeracao)==10) && (empty($strDataLiquidacao) | strlen($strDataLiquidacao)==10))
		 {
			 $bolDatasOk=true;
		 }
		 
		 if ((!empty($intStatusInscricao) | $intStatusInscricao=='null') && $bolDatasOk)
		 {
			print $x." de ".$totalInscricoes.": ".$arrDadosAluno['CODINSC']."  ".$arrDadosAluno['CPFCAN']." -> ".$intStatusInscricao." - !".$strDataGeracao."! - !".$strDataLiquidacao."<BR>";//." Memoria: ".convert(memory_get_peak_usage())." !<BR>";			
		 	$gstrInfomacaoLogCron .= " - Status: ".$intStatusInscricao."
			 "; 
			 $objDeferimento = new RegistroDeferimento("xvestib",null,$arrDadosAluno['CODCONC'],$arrDadosAluno['CODINSC'],null,null,null,null,null,
			 null,null,$intStatusInscricao,null,$strDataGeracao,$strDataLiquidacao);
			 $objDeferimento->atualizarStatus();	
			 
			 //print $x." de ".$totalInscricoes.": ".$arrDadosAluno['CODINSC']."  ".$arrDadosAluno['CPFCAN']." -> ".$intStatusInscricao." - !".$strDataGeracao."! - !".$strDataLiquidacao." ";//." Memoria: ".convert(memory_get_peak_usage())." !<BR>";
			 ob_flush();
			 flush();
			 //print (time() - $intTime)."<BR>";		 			 
		 }
		 else if (!$bolDatasOk)
		 {
		 	 print $x." de ".$totalInscricoes.": ".$arrDadosAluno['CODINSC']."  ".$arrDadosAluno['CPFCAN']." -> * data de liquidacao/geracao boleto inválida retornada pelo webservice ";
			 ob_flush();
			 flush();
			 $strMsgRetorno .= " * data de liquidacao/geracao boleto inválida retornada pelo webservice";
		 }
		 
		 // atualizando dados webservice		 
		 $objInscricao->_strCodConc = $arrDadosAluno['CODCONC'];
		 $objInscricao->_strCodInsc= $arrDadosAluno['CODINSC'];
		 $objInscricao->atualizaWebService($strMsgRetorno);
		 $objInscricao->_strCodConc = "";
		 $objInscricao->_strCodInsc= "";
		 
		 unset($objAlunoUna);	
		 	 		
	 }
	 print '<PRE>'.$gstrInfomacaoLogCron.'</PRE>';
?>
