/*
 -- Create table

create table dbvestib.STATUS_FORMA_INGRESSO
(
  cod_sta_forma_ingresso NUMBER(10) not null,
  cod_sta_aluno          NUMBER(10),
  cod_tpo_entrada        NUMBER(10)
)

  
grant  SELECT, insert, delete , ALTER on dbVESTIB.Status_Forma_Ingresso to desenv  ;

-- Create/Recreate primary, unique and foreign key constraints 
alter table dbvestib.STATUS_FORMA_INGRESSO 
  add constraint PK_COD_STA_FORMA_INGRESSO primary key (COD_STA_FORMA_INGRESSO) using index tablespace TS_INDX_DBVESTIB
  
\*alter table dbvestib.STATUS_FORMA_INGRESSO
  add constraint FK_COD_STA_ALUNO foreign key (COD_STA_ALUNO)
  references dbsiaf.status_aluno (COD_STA_ALUNO)*\
  
alter table dbvestib.STATUS_FORMA_INGRESSO
  add constraint FK_COD_TPO_ENTRADA foreign key (COD_TPO_ENTRADA) 
  references dbsiaf.tipo_entrada (COD_TPO_ENTRADA)  
 
-- Add comments to the columns 
comment on column dbvestib.STATUS_FORMA_INGRESSO.cod_sta_aluno
  is 'Armazena o status do aluno. Caso n�o seja aluno este campo � null ';

comment on column dbvestib.STATUS_FORMA_INGRESSO.cod_tpo_entrada
  is 'Armazena as formas de entradas possiveis de acordo com o status aluno ';  
  
-- Create sequence 
create sequence dbvestib.STATUS_FORMA_INGRESSO_S
minvalue 1
start with 1
increment by 1
order;

GRANT SELECT ON DBVESTIB.STATUS_FORMA_INGRESSO_S TO USER_DBVESTIB;

*/
---------------
-- Inserindo novos Tipos de entrada
----------------
insert into dbsiaf.tipo_entrada(cod_tpo_entrada,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,obs_tpo_entrada,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni)
select dbsiaf.tipo_entrada_s.nextval,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,null,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni
from dbsiaf.tipo_entrada tip
where tip.cod_tpo_entrada = 3;

insert into dbsiaf.tipo_entrada(cod_tpo_entrada,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,obs_tpo_entrada,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni)
select dbsiaf.tipo_entrada_s.nextval,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,null,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni
from dbsiaf.tipo_entrada tip
where tip.cod_tpo_entrada = 7;

insert into dbsiaf.tipo_entrada(cod_tpo_entrada,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,obs_tpo_entrada,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni)
select dbsiaf.tipo_entrada_s.nextval,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,null,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni
from dbsiaf.tipo_entrada tip
where tip.cod_tpo_entrada = 8;

insert into dbsiaf.tipo_entrada(cod_tpo_entrada,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,obs_tpo_entrada,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni)
select dbsiaf.tipo_entrada_s.nextval,cod_niv_curso,dsc_tpo_entrada,ind_transferencia,ind_validade_vaga,null,ind_remanejamento,ind_novo_aluno, ind_destrancamento, ind_outras_captacoes, ind_pro_uni
from dbsiaf.tipo_entrada tip
where tip.cod_tpo_entrada = 71;

------------------
------- Modificando os documentos para os novos tipo entrada UNIBH
-------------------

INSERT INTO DBVESTIB.CONCURSO_DOCUMENTO(CODCONC,COD_TPO_DOCUMENTO,COD_TPO_ENTRADA, IND_OBRIGATORIO)
    SELECT CD.CODCONC, CD.COD_TPO_DOCUMENTO, 94, CD.IND_OBRIGATORIO
      FROM DBVESTIB.CONCURSO_DOCUMENTO CD,
           DBSIAF.TIPO_ENTRADA         TE,
           DBSIAF.TIPO_DOCUMENTO       TD
     WHERE CD.COD_TPO_ENTRADA = TE.COD_TPO_ENTRADA
           AND CD.COD_TPO_DOCUMENTO = TD.COD_TPO_DOCUMENTO
           AND CD.CODCONC LIKE '1950%'
           AND CD.COD_TPO_ENTRADA = 3;


INSERT INTO DBVESTIB.CONCURSO_DOCUMENTO(CODCONC,COD_TPO_DOCUMENTO,COD_TPO_ENTRADA,IND_OBRIGATORIO)
    SELECT CD.CODCONC,CD.COD_TPO_DOCUMENTO,95,CD.IND_OBRIGATORIO
      FROM DBVESTIB.CONCURSO_DOCUMENTO CD,
           DBSIAF.TIPO_ENTRADA         TE,
           DBSIAF.TIPO_DOCUMENTO       TD
     WHERE CD.COD_TPO_ENTRADA = TE.COD_TPO_ENTRADA
           AND CD.COD_TPO_DOCUMENTO = TD.COD_TPO_DOCUMENTO
           AND CD.CODCONC LIKE '1950%'
           AND CD.COD_TPO_ENTRADA = 7;

INSERT INTO DBVESTIB.CONCURSO_DOCUMENTO(CODCONC,COD_TPO_DOCUMENTO,COD_TPO_ENTRADA,IND_OBRIGATORIO)
    SELECT CD.CODCONC,CD.COD_TPO_DOCUMENTO,96,CD.IND_OBRIGATORIO
	  FROM DBVESTIB.CONCURSO_DOCUMENTO CD,
		   DBSIAF.TIPO_ENTRADA         TE,
		   DBSIAF.TIPO_DOCUMENTO       TD
	 WHERE CD.COD_TPO_ENTRADA = TE.COD_TPO_ENTRADA
		   AND CD.COD_TPO_DOCUMENTO = TD.COD_TPO_DOCUMENTO
		   AND CD.CODCONC LIKE '1950%'
		   AND CD.COD_TPO_ENTRADA = 8;

INSERT INTO DBVESTIB.CONCURSO_DOCUMENTO(CODCONC,COD_TPO_DOCUMENTO,COD_TPO_ENTRADA,IND_OBRIGATORIO)
	SELECT CD.CODCONC,CD.COD_TPO_DOCUMENTO,97, CD.IND_OBRIGATORIO
	  FROM DBVESTIB.CONCURSO_DOCUMENTO CD,
		   DBSIAF.TIPO_ENTRADA         TE,
		   DBSIAF.TIPO_DOCUMENTO       TD
	 WHERE CD.COD_TPO_ENTRADA = TE.COD_TPO_ENTRADA
		   AND CD.COD_TPO_DOCUMENTO = TD.COD_TPO_DOCUMENTO
		   AND CD.CODCONC LIKE '1950%'
		   AND CD.COD_TPO_ENTRADA = 71;                        
           
-----
---modificando os tipos de entrada dos concursos UNIBH
-----
update DBVESTIB.CONCURSO_ENTRADA set   COD_TPO_ENTRADA = 94 where CODCONC = '1950' and COD_TPO_ENTRADA = 3;
update DBVESTIB.CONCURSO_ENTRADA set   COD_TPO_ENTRADA = 95 where CODCONC = '1950' and COD_TPO_ENTRADA = 7;
update DBVESTIB.CONCURSO_ENTRADA set   COD_TPO_ENTRADA = 96 where CODCONC = '1950' and COD_TPO_ENTRADA =8;
update DBVESTIB.CONCURSO_ENTRADA set   COD_TPO_ENTRADA = 97 where CODCONC = '1950' and COD_TPO_ENTRADA = 71;  

delete from dbvestib.tipo_concurso_entrada ttt where ttt.cod_tpo_concurso = 3 and ttt.cod_tpo_entrada in (3,8,7,71);

delete from dbvestib.concurso_entrada eee where eee.codconc = '1950' and eee.cod_tpo_entrada in (3,8,7,71);
       
update dbvestib.tipo_concurso_entrada tip  set tip.cod_tpo_entrada = 94 where tip.cod_tpo_concurso = 3 and tip.cod_tpo_entrada = 3;
update dbvestib.tipo_concurso_entrada tip  set tip.cod_tpo_entrada = 95 where tip.cod_tpo_concurso = 3 and tip.cod_tpo_entrada = 7;
update dbvestib.tipo_concurso_entrada tip  set tip.cod_tpo_entrada = 96 where tip.cod_tpo_concurso = 3 and tip.cod_tpo_entrada = 8;
update dbvestib.tipo_concurso_entrada tip  set tip.cod_tpo_entrada = 97 where tip.cod_tpo_concurso = 3 and tip.cod_tpo_entrada = 71;
  

----
--  UNA
------
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL, 1,7);-- Ativo -> reop��o curso UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL, 1,81);-- Ativo -> Transfer�ncia UNA/UNA Contagem/Una Betim   

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,2 ,8);-- Formado -> Obten��o de Novo T�tulo UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,72);-- Cancelado -> Retorno UNA
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,74);-- Cancelado -> Retorno com Reop��o UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,81);-- Cancelado ->Transfer�ncia UNA/UNA Contagem/Una Betim

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,72);-- abandonado -> Retorno UNA    

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,74);-- abandonado -> Retorno com Reop��o UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,81);-- abandonado ->Transfer�ncia UNA/UNA Contagem/Una Betim         

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,71);-- trancado -> Destrancamento UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,73);-- trancado -> Destrancamento com reop��o UNA        

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,81);-- trancado ->Transfer�ncia UNA/UNA Contagem/Una Betim
               
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,NULL ,3);-- N�O � ALUNO -> transfer�ncia externa UNA

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,NULL ,8);-- N�o � aluno -> Obten��o de Novo T�tulo UNA    
    
----
--  UNIBH
------            
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL, 1,95);-- Ativo -> reop��o curso UNIBH    

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,2 ,96);-- Formado -> Obten��o de Novo T�tulo UNIBH    
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,38);-- Cancelado -> Reingresso UNIBH

/*INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,63);-- Cancelado -> Reingresso UNIBH    
  */  
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3 ,90);-- Cancelado -> Reingresso com Reop��o de curso UNIBH
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,38);-- Abandonado -> Reingresso UNIBH
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,90);-- Abandonado -> Reingresso com Reop��o de curso UNIBH
/*
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4 ,63);-- Cancelado -> Reingresso UNIBH    
*/
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,97);-- trancado -> Destrancamento UNIBH     
     
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,91);-- trancado -> Destrancamento com reop��o UNIBH         
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,NULL ,94);-- N�O � ALUNO -> transfer�ncia externa UNIBH
    
----
--  UNIMONTE
------                   
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL, 1,85);-- Ativo -> reop��o curso Unimonte
        
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,2 ,88);-- Formado -> Obten��o de Novo T�tulo Unimonte
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3,83);-- Cancelado -> Retorno Unimonte        
    
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,3,84);-- Cancelado -> Retorno com reop��o Unimonte    

INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4,83);-- Cancelado -> Retorno Unimonte
        
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,4,84);-- Cancelado -> Retorno com reop��o Unimonte    
        
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,87);-- Cancelado -> Destrancamento Unimonte
  
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,5 ,86);-- Cancelado -> Destrancamento  com reop��o Unimonte
        
INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO(COD_STA_FORMA_INGRESSO,COD_STA_ALUNO, COD_TPO_ENTRADA)
    VALUES(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,NULL ,89);-- N�O � ALUNO -> transfer�ncia externa Unimonte

    /*
    
select INSCRICAO.FORMA_INGRESSO FORMAINGRESSO,
                                    '{\"codtpoentrada\":\"'|| TE.COD_TPO_ENTRADA ||'\",\"obstpoentrada\":\"'|| replace(TE.OBS_TPO_ENTRADA,chr(13) || chr(10), '<br />') ||'\" }' CODTPOENTRADAJSON
                                From DBVESTIB.INSCRICAO INSCRICAO,
                                     DBSIAF.TIPO_ENTRADA TE
                                Where INSCRICAO.CODCONC = '1949' And 
                                inscricao.cpfcan = '03572313686'
                                          -- INSCRICAO.CODINSC = :CODINSC
                                           and INSCRICAO.FORMA_INGRESSO = TE.COD_TPO_ENTRADA    
     */

 
/*
DECLARE
  CURSOR C_INGRESSO(TIPO_ENTRADA VARCHAR2) IS
    SELECT TT.COD_TPO_ENTRADA,
         TT.DSC_TPO_ENTRADA
      FROM DBSIAF.TIPO_ENTRADA TT
     WHERE UPPER(TT.DSC_TPO_ENTRADA) LIKE UPPER(/*TIPO_ENTRADA || 'TRANSF%');

BEGIN

  -- ativo 
  
  FOR R_INGRESSO IN C_INGRESSO('reop��o') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       1,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('transfer�ncia d') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       1,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('transfer�ncia u') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       1,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  -- trancado

  FOR R_INGRESSO IN C_INGRESSO('destranca') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       5,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       5,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       5,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  --Abandonado

  FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       4,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       4,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  -- cancelado

  FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       3,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       3,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  -- Formado
  FOR R_INGRESSO IN C_INGRESSO('Obten��o de Novo') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       2,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;
  -- Novo � aluno
  FOR R_INGRESSO IN C_DESTRANCA('Obten��o de Novo') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       NULL,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;

  FOR R_INGRESSO IN C_INGRESSO('transfer�ncia e') LOOP
    INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
      (COD_STA_FORMA_INGRESSO,
       COD_STA_ALUNO,
       COD_TPO_ENTRADA)
    VALUES
      (DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
       NULL,
       R_INGRESSO.COD_TPO_ENTRADA);
  END LOOP;
END;
*/
