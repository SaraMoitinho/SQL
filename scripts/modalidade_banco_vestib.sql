-- inserir a modalidade de banco no concurso
select * from dbsiaf.modalidade_tipo_concurso
where cod_tpo_concurso =43--  for update
--223, 246, 201, 274, 221

insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
values (223,43);

insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
values (246,43);

insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
values (201,43);

insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
values (274,43);

insert into dbsiaf.modalidade_tipo_concurso(cod_modalidade,cod_tpo_concurso)
values (221,43);


select c.cod_tpo_concurso, t.dsc_concurso
from dbvestib.concurso c
inner join dbvestib.tipo_concurso t on t.cod_tpo_concurso = c.cod_tpo_concurso
where codconc = '3329'


-- combo de banco
SELECT BAN.COD_BANCO,
	   BAN.NOM_BANCO
  FROM DBSIAF.BANCO BAN
 WHERE EXISTS (SELECT 1
		  FROM DBSIAF.MODALIDADE_TIPO_CONCURSO MTC,
			   DBSIAF.MOD_COBRANCA             MCO,
			   DBSIAF.CONTA_CORRENTE           CCO,
			   DBSIAF.AGENCIA_BANCARIA         AGB,
			   DBVESTIB.CONCURSO               CON
		 WHERE MTC.COD_MODALIDADE = MCO.COD_MODALIDADE
			   AND MCO.COD_CONTA_CORRENTE = CCO.COD_CONTA_CORRENTE
			   AND CCO.COD_AG_BANCARIA = AGB.COD_AG_BANCARIA
			   AND AGB.COD_BANCO = BAN.COD_BANCO
         and ban.cod_banco = 65
			   AND MTC.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
			   AND CON.CODCONC = '3242')
 ORDER BY BAN.NOM_BANCO;
 
 
 --combo de agencia
 SELECT AGB.COD_AG_BANCARIA,
		AGB.NUM_AG_BANCARIA
   FROM DBSIAF.AGENCIA_BANCARIA AGB
  WHERE COD_BANCO = 65
		AND EXISTS (SELECT 1
		   FROM DBSIAF.MODALIDADE_TIPO_CONCURSO MTC,
				DBSIAF.MOD_COBRANCA             MCO,
				DBSIAF.CONTA_CORRENTE           CCO,
				DBVESTIB.CONCURSO               CON
		  WHERE MTC.COD_MODALIDADE = MCO.COD_MODALIDADE
				AND MCO.COD_CONTA_CORRENTE = CCO.COD_CONTA_CORRENTE
				AND CCO.COD_AG_BANCARIA = AGB.COD_AG_BANCARIA
				AND MTC.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
				AND CON.CODCONC = '3242')
  ORDER BY AGB.NUM_AG_BANCARIA;
  
  -- combo conta
  SELECT CCO.COD_CONTA_CORRENTE,
		 CCO.NUM_CONTA_CORRENTE,
		 CCO.NUM_DIGITO_CONTA, cco.cod_instituicao, ies.sgl_instituicao
	FROM DBSIAF.CONTA_CORRENTE CCO
  inner join dbsiaf.instituicao_ensino ies on ies.cod_instituicao = cco.cod_instituicao
   WHERE CCO.COD_AG_BANCARIA = 206
		-- AND CCO.COD_INSTITUICAO = 9
		 AND EXISTS (SELECT 1
			FROM DBSIAF.MODALIDADE_TIPO_CONCURSO MTC,
				 DBSIAF.MOD_COBRANCA             MCO,
				 DBVESTIB.CONCURSO               CON
		   WHERE MTC.COD_MODALIDADE = MCO.COD_MODALIDADE
				 AND MCO.COD_CONTA_CORRENTE = CCO.COD_CONTA_CORRENTE
				 AND MTC.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
				 AND CON.CODCONC = '3329')
   ORDER BY CCO.DSC_CONTA_CORRENTE;
   
   
   select * from DBSIAF.MOD_COBRANCA m
   where m.


SELECT agb.cod_banco, mco.cod_modalidade, mco.dsc_modalidade, cco.cod_instituicao, cco.cod_conta_corrente
		  FROM DBSIAF.MODALIDADE_TIPO_CONCURSO MTC,
			   DBSIAF.MOD_COBRANCA             MCO,
			   DBSIAF.CONTA_CORRENTE           CCO,
			   DBSIAF.AGENCIA_BANCARIA         AGB,
			   DBVESTIB.CONCURSO               CON
		 WHERE MTC.COD_MODALIDADE = MCO.COD_MODALIDADE
			   AND MCO.COD_CONTA_CORRENTE = CCO.COD_CONTA_CORRENTE
			   AND CCO.COD_AG_BANCARIA = AGB.COD_AG_BANCARIA
			  -- AND AGB.COD_BANCO = BAN.COD_BANCO
         --and ban.cod_banco = 65
			   AND MTC.COD_TPO_CONCURSO = CON.COD_TPO_CONCURSO
			   AND CON.CODCONC = '3242'
