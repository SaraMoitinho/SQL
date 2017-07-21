
 update dbsiaf.ass_documento set ind_entrega_doc = 'N' where cod_ass_contrato in 

(select distinct asd.cod_ass_contrato
/*,alu.dat_cadastro,
       nom_aluno,
       codconc,
       cod_sta_aluno,
       asd.cod_tpo_documento,
       asd.cod_usuario_log*/
  from dbsiaf.aluno alu
  join dbsiaf.ass_contrato ass on ass.cod_aluno = alu.cod_aluno
  join dbsiaf.ass_documento asd on asd.cod_ass_contrato =
                                   ass.cod_ass_contrato
                               and asd.ind_entrega_doc = 'S'
                               and cod_tpo_documento = 215
 where codconc = 2934) and cod_tpo_documento = 215 
