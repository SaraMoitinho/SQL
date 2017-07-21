declare
 cursor c_data is
SELECT DPE.CODCONC,
	   DPE.COD_DESC_PERIODO,
	   DPE.DAT_INI_PERIODO,
	   DPE.DAT_FIM_PERIODO,
	   DPE.VAL_DESCONTO,
	   DPE.NUM_DIAS_VENC_BOLETO,
       (select t.dsc_concurso
       from dbvestib.tipo_concurso t
       where t.cod_tpo_concurso = con.cod_tpo_concurso)
  FROM DBVESTIB.DESCONTO_PERIODO DPE,
  dbvestib.concurso con
 WHERE  con.codconc between'1630' and '1696'
 and con.codconc = dpe.codconc
 and con.cod_tpo_concurso = 1
 and dpe.val_desconto > 0;
 
 data_certa dbvestib.desconto_periodo.dat_fim_periodo%type;
 begin
   for r_data in c_data loop
     select pp.dat_prova_1a_etapa -1
     into data_certa
     from dbvestib.parametros_concurso pp
     where pp.codconc = r_data.codconc;
     
     update dbvestib.desconto_periodo p
     set p.dat_fim_periodo = data_certa
     where p.codconc = r_data.codconc
     and p.cod_desc_periodo = r_data.cod_desc_periodo;     
          commit;
     end loop;

  end;   

     
          
