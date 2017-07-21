select num_matricula, nom_aluno,cod_aluno, cod_sta_aluno, alu.dat_operacao_log
from dbsiaf.aluno alu
where /*alu.cod_sta_aluno = 4
and alu.cod_instituicao = 8
and */alu.num_matricula in ('81521905', '81522506')




SELECT *
  FROM DBSIAF.ACAO_PROTOCOLO
 WHERE COD_ACAO_PROTOCOLO = 8


SELECT DBADM.PC_CONSULTAS.F_OBTER_CONSULTA(2153)
  FROM DUAL
  
  
  

SELECT *
  FROM DBSISPEX.MAPEAMENTO_SOLICITACAO
  
  
  
  
 WHERE COD_SOLICITACAO = 4683377

BEGIN        DBSIAF.PC_ACAO_PROTOCOLO.SP_REALIZAR_CANCELAMENTO( 3597822 ); END;

SELECT * FROM DBSIAF.SERVICO_SECRETARIA WHERE COD_SOLICITACAO = 4683377


				SELECT SF.NNOVOCODSTAALUNO
				  --INTO N_NOVO_COD_STA_ALUNO
				  FROM TABLE(CAST(PC_SITUACAO_FINANCEIRA.F_SITUACAO_FINANCEIRA(NULL,
																			   2544,
																			   NULL,
																			   982774,
																			   'S',
																			   4683377,
																			   '28/07/2015') AS DBSIAF.T_TAB_SIT_FINANC)) SF
