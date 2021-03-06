
/*
Aluno: Janssen Corr�a dos Santos � RA: 91510568 
Indicou: Ant�nio Francisco Correa Neto (Gradua��o) concurso: 3202 
*/
    
insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nummatricula) 
SELECT CODCONC,
	   CODCAN,
       6125,
      '91510568'
  FROM DBVESTIB.CANDIDATO CAN
  WHERE CODCONC = '3202'
 and codcan  = '747202'-- Ant�nio Francisco Correa Neto (Gradua��o) concurso: 3202
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
/*
Aluno: Wagner Ferreira da Silva � RA: 91510374 
Indicou: Juliano Augusto Leite Soares (P�s) 3144 
*/ 

insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nummatricula) 
SELECT CODCONC,
	   CODCAN,
       6125,
      '91510374'
  FROM DBVESTIB.CANDIDATO CAN
  WHERE CODCONC = '3144'
 and codcan  = '747369'-- uliano Augusto Leite Soares: 3202
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
  
 /*
 Aluno: Filipe Pires da Costa � RA: 91520326 
Indicou: Morzani Gon�alves (P�s) 3144 
 */
 

insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nummatricula) 
SELECT CODCONC,
	   CODCAN,
       6125,
       '91520326'
  FROM DBVESTIB.CANDIDATO CAN
  WHERE CODCONC = '3144'
 and codcan  = '750682'-- Morzani Gon�alves 
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
 /*
 Aluno: Solange Gon�alves Teixeira - RA: 91510604 
Indicou: Karla Aparecida Gon�alves Teixeira (P�s) 3144
 */

insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nummatricula) 
SELECT CODCONC,
	   CODCAN,
       6125,
       '91510604'
  FROM DBVESTIB.candidato CAN
  WHERE CODCONC = '3144'
 and codcan  = '740407'-- Carla Aparecida Gon�alves Teixeira
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
 
 /*
 Maires Carlaine Nogueira � RA: 91610289 � concurso 3085 
 */
 
update dbvestib.inscricao
set  cod_loc_inscricao = '001', cod_fis_inscricao = 315
where codconc = '3085' and codinsc = '734970';

/*
Guilherme Fl�vio Fran�a Costa � RA: 91620041 � concurso 3103 
Indica��o da colaboradora: Juliana Nunes � matr�cula 010009428
*/


insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nomfuncionario, codfuncionario) 
SELECT CODCONC,
	   CODCAN,--nomcan,
       6019,
       'JULIANA SILVA NUNES',
       36756
  FROM DBVESTIB.candidato CAN
  WHERE CODCONC = '3103'
 and codcan  = '729403'-- Guilherme Fl�vio Fran�a Costa
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
 
update dbvestib.inscricao
set  cod_loc_inscricao = '001', cod_fis_inscricao = 118
where codconc = '3103' and codinsc = '729403';

/*
Vin�cius Dur�es Torres � RA: 91610278 � concurso 3085 
Indica��o da colaboradora: Juliana Nunes � matr�cula 010009428 
*/

insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nomfuncionario, codfuncionario) 
SELECT CODCONC,
	   CODCAN,
       5961,
       'JULIANA SILVA NUNES',
       36756
  FROM DBVESTIB.candidato CAN
  WHERE CODCONC = '3085'
 and codcan  = '728473'--Vin�cius Dur�es Torres
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
update dbvestib.inscricao
set  cod_loc_inscricao = '001', cod_fis_inscricao = 315
where codconc = '3085' and codinsc = '728473';
 
/*
Gianni Capri � CPF: 050.535.496-99 RA: 91610229 - concurso 3085 
Indica��o da colaboradora: Juliana Nunes � matr�cula 010009428 
*/
 
insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nomfuncionario, codfuncionario) 
SELECT CODCONC,
	   CODCAN,
       5961,
       'JULIANA SILVA NUNES',
       36756
  FROM DBVESTIB.candidato CAN
  WHERE CODCONC = '3085'
 and codcan  = '730387'-- Gianni Capri
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
update dbvestib.inscricao
set  cod_loc_inscricao ='001', cod_fis_inscricao = 315
where codconc = '3085' and codinsc = 730387;

/*
Helton Wippel � CPF: 070.332.696-17 RA: 91620028 � concurso 3103 
Indica��o da colaboradora: Juliana Nunes � matr�cula 010009428
*/

insert into dbvestib.promocao_inscricao(codconc,codinsc,coddescpromocao,nomfuncionario, codfuncionario) 
SELECT CODCONC,
	   CODCAN,
       5961,
       'JULIANA SILVA NUNES',
       36756
  FROM DBVESTIB.candidato CAN
  WHERE CODCONC = '3103'
 and codcan = '724477'-- Gianni Capri
 and not exists (select 1 from dbvestib.promocao_inscricao pro
 where pro.codconc = can.codconc and pro.codinsc = can.codcan);
 
update dbvestib.inscricao
set  cod_loc_inscricao = '001', cod_fis_inscricao = 118
where codconc = '3103' and codinsc ='724477';

