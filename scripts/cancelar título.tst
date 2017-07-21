PL/SQL Developer Test script 3.0
8
begin
  -- Call the procedure
  dbsiaf.pc_operacao_titulo.sp_cancelar_titulo(p_cod_titulo_receber => :p_cod_titulo_receber,
                                               p_cod_mot_alteracao => :p_cod_mot_alteracao,
                                               p_cod_tpo_integracao => :p_cod_tpo_integracao,
                                               p_msg_erro => :p_msg_erro,
                                               p_cancelar_recalculo => :p_cancelar_recalculo);
end;
5
p_cod_titulo_receber
1
9542004
4
p_cod_mot_alteracao
0
4
p_cod_tpo_integracao
0
4
p_msg_erro
1
Erro no cancelamento de titulo. O status do título e o status solicitado para alteração devem ser diferentes. Status Titulo:Cancelado Status Solicitado: Cancelado *@* SP_OPERACAO_TITULO(SP_VALIDA_OPERACAO). Status do Titulo: 4 Status Solicitado: 4
5
p_cancelar_recalculo
0
5
0
