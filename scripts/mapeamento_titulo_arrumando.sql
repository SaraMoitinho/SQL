SELECT TR.COD_TITULO_RECEBER,
               TR.NUM_TITULO,
               TR.DAT_VENCIMENTO,
               TR.DAT_PRORROGACAO,
               TR.VAL_TITULO,
               TR.COD_ALUNO,
               IC.NOMCAN,
               CU.NOMCUR,
               TT.DSC_TPO_TITULO,
               CC.COD_CURSO_SIAF,
               CON.ANOCONC || '/' || CON.SEMCONC SGL_PERIODO_LETIVO
          FROM DBSIAF.MAPEAMENTO_TITULO    MT,
               DBSIAF.TITULO_RECEBER       TR,
               DBSIAF.MAPEAMENTO_INSCRICAO MI,
               DBVESTIB.INSCRICAO          IC,
               DBVESTIB.OPCAOCANDIDATO     OC,
               DBVESTIB.CURSO              CU,
               DBSIAF.TIPO_TITULO          TT,
               DBVESTIB.CURSO_CAMPUS       CC,
               DBVESTIB.CONCURSO           CON
         WHERE MT.COD_MAPEAMENTO = 483612
               AND MT.COD_TITULO_RECEBER = 9377955
               AND MT.COD_TITULO_RECEBER = TR.COD_TITULO_RECEBER
               AND MT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO
               AND MI.CODCONC = IC.CODCONC
               AND MI.CODINSC = IC.CODINSC
               AND IC.CODCONC = OC.CODCONC
               AND IC.CODINSC = OC.CODINSC
               AND CC.CODCONC = OC.CODCONC
               AND CC.CODCUR = OC.CODCUR
               AND CC.CODCAM = OC.CODCAM
               AND OC.NROOPC = '1'
               AND OC.CODCUR = CU.CODCUR
               AND OC.CODCONC = CU.CODCONC
               AND TR.COD_TPO_TITULO = TT.COD_TPO_TITULO
               AND TR.COD_STA_TITULO <> 4
        UNION
        SELECT TR.COD_TITULO_RECEBER,
               TR.NUM_TITULO,
               TR.DAT_VENCIMENTO,
               TR.DAT_PRORROGACAO,
               TR.VAL_TITULO,
               TR.COD_ALUNO,
               IC.NOMCAN,
               CU.NOMCUR,
               TT.DSC_TPO_TITULO,
               CC.COD_CURSO_SIAF,
               CON.ANOCONC || '/' || CON.SEMCONC SGL_PERIODO_LETIVO
          FROM DBSIAF.HIST_MAPEAMENTO_TITULO MT,
               DBSIAF.TITULO_RECEBER         TR,
               DBSIAF.MAPEAMENTO_INSCRICAO   MI,
               DBVESTIB.INSCRICAO            IC,
               DBVESTIB.OPCAOCANDIDATO       OC,
               DBVESTIB.CURSO                CU,
               DBSIAF.TIPO_TITULO            TT,
               DBVESTIB.CURSO_CAMPUS         CC,
               DBVESTIB.CONCURSO             CON
         WHERE MT.COD_MAPEAMENTO = 483612
               AND MT.COD_TITULO_RECEBER = 9377955
               AND MT.COD_TITULO_RECEBER = TR.COD_TITULO_RECEBER
               AND MT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO
               AND MI.CODCONC = IC.CODCONC
               AND MI.CODINSC = IC.CODINSC
               AND IC.CODCONC = OC.CODCONC
               AND IC.CODINSC = OC.CODINSC
               AND CC.CODCONC = OC.CODCONC
               AND CC.CODCUR = OC.CODCUR
               AND CC.CODCAM = OC.CODCAM
               AND OC.NROOPC = '1'
               AND OC.CODCUR = CU.CODCUR
               AND OC.CODCONC = CU.CODCONC
               AND TR.COD_TPO_TITULO = TT.COD_TPO_TITULO
               AND TR.COD_STA_TITULO <> 4
               AND OC.CODCONC = CON.CODCONC;



SELECT i.nomcan, i.cpfcan, i.codinsc, mi.cod_mapeamento
  FROM DBVESTIB.INSCRICAO          I,
	   DBSIAF.MAPEAMENTO_INSCRICAO MI
 WHERE I.CODCONC = '1949'
	   AND I.COD_STATUS_INSCRICAO = 1
	   AND MI.CODCONC = I.CODCONC
	   AND MI.CODINSC = I.CODINSC 
    --  and i.codinsc = 170258
	   AND  EXISTS (SELECT 1
		  FROM DBSIAF.MAPEAMENTO_TITULO MT,
               DBSIAF.TITULO_RECEBER TIT
		 WHERE MT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO         
			   AND MT.COD_TITULO_RECEBER = TIT.COD_TITULO_RECEBER
               and tit.cod_sta_titulo = 1 )
               
select mt.*
 FROM DBSIAF.MAPEAMENTO_TITULO_log MT,
               DBSIAF.TITULO_RECEBER TIT,
               DBSIAF.MAPEAMENTO_INSCRICAO MI
where /*mi.codconc = '2094'               
and mi.codinsc = '170473'*/
 mi.cod_mapeamento = 483612
and mt.cod_mapeamento = mi.cod_mapeamento
and mt.cod_titulo_receber = tit.cod_titulo_receber;


select * from dbsiaf.mapeamento_titulo_log mm
where mm.cod_mapeamento = 483612

declare
cursor c_inserir is
SELECT *
  FROM DBSIAF.MAPEAMENTO_INSCRICAO  MI,
	   DBVESTIB.CONCURSO            CON,
	   DBSIAF.MAPEAMENTO_TITULO_LOG MIT
 WHERE CON.CODCONC = MI.CODCONC
	   AND CON.ANOCONC = 2014
	   AND MIT.COD_MAPEAMENTO = MI.COD_MAPEAMENTO
	   AND MI.COD_MAPEAMENTO = 483612;
begin
  insert into dbsiaf.hist_mapeamento_titulo(cod_hist_mapeamento_titulo,cod_mapeamento,cod_titulo_receber,codconc,codinsc)
  values(dbsiaf.hist
         
       
       
