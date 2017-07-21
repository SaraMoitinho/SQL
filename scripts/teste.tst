PL/SQL Developer Test script 3.0
17
-- Created on 25/07/2016 by SARA.MOITINHO 
declare 
  -- Local variables here
  i integer;
begin
  -- Test statements here
  UPDATE DBSIAF.END_ALUNO SET
  COD_CIDADE = 4009,
  NOM_LOGRADOURO = 'Rua José Henrique Tomaz De Lima, 110',
  NOM_COMPLEMENTO = '40',
  NOM_BAIRRO = 'Vila Verde',
	CEP_ENDERECO = '08.230-850',
	TEL_ENDERECO = '1120528067'
WHERE
	COD_ALUNO = 1701612 AND
	COD_TPO_ENDERECO = 3;
end;
0
0
