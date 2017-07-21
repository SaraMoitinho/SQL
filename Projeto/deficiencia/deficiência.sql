insert into dbvestib.passos_inscricao(cod_passo_inscricao,cod_tpo_concurso,end_tela,dsc_tela,ord_passo,cod_cnf_consulta,ind_exibir,dsc_funcao_before,dsc_funcao_after)
values 
(dbvestib.passos_inscricao_s.nextval,1,'deficiencia/index/index', 'Deficiência', 6, null, 'S', 'deficiencia.beforeNextStep', 'deficiencia.afterLoadStep')
;
UPDATE
DBVESTIB.PASSOS_INSCRICAO PP
SET ORD_PASSO = 3
WHERE PP.COD_TPO_CONCURSO = 3
AND PP.COD_PASSO_INSCRICAO = 51;


UPDATE
DBVESTIB.PASSOS_INSCRICAO PP
SET ORD_PASSO = 4
WHERE PP.COD_TPO_CONCURSO =3
AND PP.COD_PASSO_INSCRICAO = 191;


UPDATE
DBVESTIB.PASSOS_INSCRICAO PP
SET ORD_PASSO = 5
WHERE PP.COD_TPO_CONCURSO = 3
AND PP.COD_PASSO_INSCRICAO = 16;


UPDATE
DBVESTIB.PASSOS_INSCRICAO PP
SET ORD_PASSO = 6
WHERE PP.COD_TPO_CONCURSO = 3
AND PP.COD_PASSO_INSCRICAO = 19;


UPDATE
DBVESTIB.PASSOS_INSCRICAO PP
SET ORD_PASSO = 2
WHERE PP.COD_TPO_CONCURSO = 3
AND PP.COD_PASSO_INSCRICAO = 216;

commit;


/*
select ppp.ord_passo,PPP.DSC_TELA, PPP.END_TELA, ppp.dsc_funcao_before, ppp.dsc_funcao_after
from dbvestib.passos_inscricao ppp
where ppp.cod_tpo_concurso = 1 for update ;*/

DBVESTIB.INSCRICAO_DEFICIENCIA

INSERT INTO DBVESTIB.INSCRICAO_INST_EXTERNA
	(CODCONC,
	 CODINSC,
	 COD_INSTIT_EXTERNA)

VALUES
	(:CODCONC,
	 :CODINSC,
	 :COD_INSTIT_EXTERNA)
     
     DELETE FROM DBVESTIB.INSCRICAO_INST_EXTERNA IND
WHERE  IND.CODCONC = '1940' AND IND.CODINSC = :CODINSC;



select *
from dbvestib.configuracao_concurso c
where c.codconc = '2099'
