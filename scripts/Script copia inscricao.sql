declare P_CODCONC_DES dbvestib.concurso.codconc%type;
 P_CODCONC_ORI dbvestib.concurso.codconc%type;

begin
  P_CODCONC_DES := '3327';
  P_CODCONC_ORI := '3237';

/*insert into dbvestib.inscricao
  (CODCONC, codinsc, codtipdoc, codestado, codcidade, codtpodef, nomcan, sexcan, datnascan, nrodoc, endcan, baican, cepcan, telcan, flgcanhoto, emailcan, datinscan, ind_treinante, formapgto, datpgto, logcan, sencan, codtrans, codaut, dsctpotrans, numcv, numped, indcaptura, logref, codcarta, paican, maecan, celcan, cpfcan, escola_origem, forma_ingresso, matricula, tipo_inscricao, dat_vencimento, cod_status_inscricao, dat_devolucao, codlocpag, dat_cancelamento, cod_tpo_inscricao, cod_banco, agencia_devolucao, operacao_devolucao, conta_devolucao, tit_conta_devolucao, numero, complemento, cod_loc_inscricao, cod_fis_inscricao, valpago, cod_usuario_log, dat_operacao_log, cod_tpo_envio, ind_visualizacao_boleto, codtel, indalteralogin, codcli, ind_email_enviado, html_boleto, email_alternativo, cod_instit_externa, indinscgratuita, dscresppromocao, indinscteste, codformaprova, anoenem, numinscenem, datprovaagendada, cod_desc_periodo, codestadocivil, codpaisnc, codcidadenat, telcomercial, indtrabalha, codturem, codtpoem, nomemp, indconveniado, nomempconveniado, dsctpoem, obsinsc, codescola, cod_tpo_teleinsc, indanalisedispensa, nomcursograduacao, anoconclusaoem, cod_escola_origem, cod_cursinho, nomcursinhooutro, cod_emp_conveniadas, nom_arquivo_curriculo, cod_grd_curricular, cod_grd_qualificacao, cod_ocorrencia, cod_instituicao_psvs, val_renda_mensal, cod_renda_mensal, codcamproxresidencia, cod_cor_raca, cod_telefonema_crm, ind_script_google, nom_tema_pesquisa, dsc_tema_pesquisa, anoconclusaograd, anoconclusaomest, cod_instit_externa_mest, nomcursomestrado, cod_idioma, ind_aluno_interno, num_chamado_hd)
select P_CODCONC_DES, codinsc, codtipdoc, codestado, codcidade, codtpodef, nomcan, sexcan, datnascan, nrodoc, endcan, baican, cepcan, telcan, flgcanhoto, emailcan, datinscan, ind_treinante, formapgto, datpgto, logcan, sencan, codtrans, codaut, dsctpotrans, numcv, numped, indcaptura, logref, codcarta, paican, maecan, celcan, cpfcan, escola_origem, forma_ingresso, matricula, tipo_inscricao, dat_vencimento, cod_status_inscricao, dat_devolucao, codlocpag, dat_cancelamento, cod_tpo_inscricao, cod_banco, agencia_devolucao, operacao_devolucao, conta_devolucao, tit_conta_devolucao, numero, complemento, cod_loc_inscricao, cod_fis_inscricao, valpago, cod_usuario_log, dat_operacao_log, cod_tpo_envio, ind_visualizacao_boleto, codtel, indalteralogin, codcli, ind_email_enviado, html_boleto, email_alternativo, cod_instit_externa, indinscgratuita, dscresppromocao, indinscteste, codformaprova, anoenem, numinscenem, datprovaagendada, cod_desc_periodo, codestadocivil, codpaisnc, codcidadenat, telcomercial, indtrabalha, codturem, codtpoem, nomemp, indconveniado, nomempconveniado, dsctpoem, obsinsc, codescola, cod_tpo_teleinsc, indanalisedispensa, nomcursograduacao, anoconclusaoem, cod_escola_origem, cod_cursinho, nomcursinhooutro, cod_emp_conveniadas, nom_arquivo_curriculo, cod_grd_curricular, cod_grd_qualificacao, cod_ocorrencia, cod_instituicao_psvs, val_renda_mensal, cod_renda_mensal, codcamproxresidencia, cod_cor_raca, cod_telefonema_crm, ind_script_google, nom_tema_pesquisa, dsc_tema_pesquisa, anoconclusaograd, anoconclusaomest, cod_instit_externa_mest, nomcursomestrado, cod_idioma, ind_aluno_interno, num_chamado_hd from dbvestib.inscricao
where codconc = P_CODCONC_ORI
and cod_status_inscricao = 2;

commit;
end;


DBVESTIB.PC_CONCURSO_MUT_TBL.bAtualizaOpcaoCandidato := FALSE;


insert into dbvestib.opcaocandidato
  (codconc, codinsc, nroopc, codcur, codtur, opclin, cod_usuario_log, dat_operacao_log, codcam, codinstituicao, indprincipal, indformacaoampliada, indprouni, indfies, ind_deseja_fies, ind_deseja_prouni)
select P_CODCONC_DES, codinsc, nroopc, codcur, codtur, opclin, cod_usuario_log, dat_operacao_log, codcam, codinstituicao, indprincipal, indformacaoampliada, indprouni, indfies, ind_deseja_fies, ind_deseja_prouni from dbvestib.opcaocandidato opc
where codconc = P_CODCONC_ORI
AND EXISTS (SELECT 1 FROM dbvestib.inscricao ins1
                   where ins1.codconc = P_CODCONC_DES 
                   and ins1.CODINSC = opc.CODINSC);
commit;
end;               
                   
DBVESTIB.PC_CONCURSO_MUT_TBL.bAtualizaOpcaoCandidato := FALSE;                  

insert into dbvestib.candidato
  (codconc, codcan, nomcan, sexcan, datnascan, idecan, nomidecan, expidecan, telcan, endcan, baican, cidcan, estcan, cepcan, datinscan, datpagcan, codlocpag, sitcan, clacan, clacan2, codloc, codsal, email, totpon, totpon2, canhoto, tag, codcanant, regfch, flgmat, datinccan, str_soceco, sitcan2, codtpodef, ind_treinante, sitcanger, clacanger, coddis, nom_pai, nom_mae, ind_aluno_funcesi, tip_escola, reg_empregado, nom_empregado, loc_trabalho, codcidprova, codcidescolha, celcan, cpfcan, seriecan, nomeesc, ramal, numero, matricula, forma_ingresso, escola_origem, sencan, telesc, numcresp, dsccresp, numequipe, dscequipe, indusatrans, indquantpassagem, inditiescolhido, codemp, indleescreve, endesc, complemento, numend, cod_loc_inscricao, cod_fis_inscricao, nom_setor, valpago, cod_usuario_log, dat_operacao_log, indconfirmado, baiesc, cepesc, cidesc, num_escola, complemento_escola, cod_instit_externa, codcamproxresidencia, codformaprova, anoenem, numinscenem, datprovaagendada, codestadocivil, codpaisnc, codcidadenat, telcomercial, indtrabalha, clacan3, totpon3, sitcan3, codescola, email_alternativo, nomcursograduacao, anoconclusaoem, cod_escola_origem, cod_cursinho, nomcursinhooutro, cod_emp_conveniadas, codbarras, cod_grd_curricular, cod_grd_qualificacao, cod_ocorrencia, cod_instituicao_psvs, canadvent, cod_cor_raca, codcad, nom_tema_pesquisa, dsc_tema_pesquisa, anoconclusaograd, anoconclusaomest, cod_instit_externa_mest, nomcursomestrado, cod_idioma, nom_civil, num_chamado_hd)
select P_CODCONC_DES, codcan, nomcan, sexcan, datnascan, idecan, nomidecan, expidecan, telcan, endcan, baican, cidcan, estcan, cepcan, datinscan, datpagcan, codlocpag, sitcan, clacan, clacan2, codloc, codsal, email, totpon, totpon2, canhoto, tag, codcanant, regfch, flgmat, datinccan, str_soceco, sitcan2, codtpodef, ind_treinante, sitcanger, clacanger, coddis, nom_pai, nom_mae, ind_aluno_funcesi, tip_escola, reg_empregado, nom_empregado, loc_trabalho, codcidprova, codcidescolha, celcan, cpfcan, seriecan, nomeesc, ramal, numero, matricula, forma_ingresso, escola_origem, sencan, telesc, numcresp, dsccresp, numequipe, dscequipe, indusatrans, indquantpassagem, inditiescolhido, codemp, indleescreve, endesc, complemento, numend, cod_loc_inscricao, cod_fis_inscricao, nom_setor, valpago, cod_usuario_log, dat_operacao_log, indconfirmado, baiesc, cepesc, cidesc, num_escola, complemento_escola, cod_instit_externa, codcamproxresidencia, codformaprova, anoenem, numinscenem, datprovaagendada, codestadocivil, codpaisnc, codcidadenat, telcomercial, indtrabalha, clacan3, totpon3, sitcan3, codescola, email_alternativo, nomcursograduacao, anoconclusaoem, cod_escola_origem, cod_cursinho, nomcursinhooutro, cod_emp_conveniadas, codbarras, cod_grd_curricular, cod_grd_qualificacao, cod_ocorrencia, cod_instituicao_psvs, canadvent, cod_cor_raca, codcad, nom_tema_pesquisa, dsc_tema_pesquisa, anoconclusaograd, anoconclusaomest, cod_instit_externa_mest, nomcursomestrado, cod_idioma, nom_civil, num_chamado_hd from dbvestib.candidato can
where codconc = P_CODCONC_ORI;
commit;
end;
insert into dbvestib.rcandcurturopc
  (codconc, codcan, codcur, codtur, opclin, nroopc, cod_usuario_log, dat_operacao_log, codcam, codinstituicao, indprincipal, indformacaoampliada, indprouni, indfies, ind_deseja_fies, ind_deseja_prouni)
select P_CODCONC_DES, codcan, codcur, codtur, opclin, nroopc, cod_usuario_log, dat_operacao_log, codcam, codinstituicao, indprincipal, indformacaoampliada, indprouni, indfies, ind_deseja_fies, ind_deseja_prouni from dbvestib.rcandcurturopc
where codconc = P_CODCONC_ORI;
commit;
end;*/
insert into dbvestib.nota_prova
  (codnotaprova, codconc, codcan, nroopc, cod_etapa, codpro, notaparcial, notafinal, cod_usuario_log, dat_operacao_log, arquivo_img_nota)
select DBVESTIB.NOTA_PROVA_S.NEXTVAL, P_CODCONC_DES, codcan, nroopc, cod_etapa, codpro, notaparcial, notafinal, cod_usuario_log, dat_operacao_log, arquivo_img_nota from dbvestib.nota_prova
where codconc = P_CODCONC_ORI;

insert into dbvestib.notaenem
  (codconc, codcan, codpro, valnota, cod_usuario_log, dat_operacao_log)
select P_CODCONC_DES, codcan, codpro, valnota, cod_usuario_log, dat_operacao_log from dbvestib.notaenem
Where codconc = P_CODCONC_ORI;
commit;

end;



