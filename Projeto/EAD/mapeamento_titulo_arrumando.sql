-- Add/modify columns 
alter table dbvestib.CLASSIFICACAO_EAD add num_posicao number(6);
-- Add comments to the columns 
comment on column dbvestib.CLASSIFICACAO_EAD.num_posicao
  is 'Armazena a posi��o de classifica��o do candidato';
