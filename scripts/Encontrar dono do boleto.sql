UPDATE DBVESTIB.INSCRICAO INS
SET INS.COD_STATUS_INSCRICAO = 2,
    INS.DATPGTO = '12/06/2012'
  WHERE INS.CODCONC = 1278
  AND INS.CODINSC = 561434;
commit;

  select ins.cod_status_inscricao, ins.datpgto, ins.nomcan from dbvestib.inscricao ins
  where ins.CODCONC = 1278
   and ins.codinsc =538822
-- data da baixa
SELECT *
 FROM DBSIAF.TITULO_RECEBER TIT
WHERE trim (TIT.Num_Nosso_Numero) ='9000000194023'

--data do cancelamento

 SELECT ins.Cod_Status_Inscricao, ins.dat_operacao_log
 FROM DBVESTIB.INSCRICAO_log INS
WHERE ins.codconc = 1278 and INS.CODinsc =556683

select *
from dbsiaf.mapeamento_inscricao mis,
     dbsiaf.mapeamento_titulo a
where
     mis.codinsc = 559149
     and mis.cod_mapeamento = a.cod_mapeamento     



SELECT *
FROM DBSIAF.STATUS_INSCRICAO I


-- data da geração 
select *
from dbvestib.dados_boleto_inscricao dad
where dad.codconc = 1278
  and dad.codinsc = 538822
  --and trim( dad.numnossonumero) =  '9000000212788'--'9000000212788'


SELECT *  
  FROM DBVESTIB.INSCRICAO_LOG INS
 WHERE INS.CODCONC = 1278
  AND INS.CODINSC = 561434
 ORDER BY INS.DAT_OPERACAO_LOG
 
 
SELECT ins.cod_status_inscricao
  FROM DBVESTIB.Inscricao ins
 where ins.codinsc = 557670 


SELECT *
 FROM DBSIAF.TITULO_RECEBER_LOG TIT
WHERE TIT.COD_TITULO_RECEBER = 5997880



SELECT *
  FROM DBSIAF.MAPEAMENTO_INSCRICAO MAPE
 WHERE MAPE.CODINSC = 559602 
 
 
 select *
  from dbsiaf.status_inscricao i

 
 SELECT *
 FROM DBVESTIB.INSCRICAO INS
 WHERE INS.CODCONC = 1278
 AND INS.NOMCAN LIKE 'LAURENTINO %'

  
