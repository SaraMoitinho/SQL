-- Add/modify columns 
alter table dbvestib.CLASSIFICACAO_EAD add num_posicao number(6);
-- Add comments to the columns 
comment on column dbvestib.CLASSIFICACAO_EAD.num_posicao
  is 'Armazena a posição de classificação do candidato';
  
  -- Add/modify columns 
alter table dbvestib.CLASSIFICACAO_EAD_LOG add num_posicao number(6);
