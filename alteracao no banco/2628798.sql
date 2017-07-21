
    
    UPDATE DBSIAF.PARAMETRO_INST PAR
    SET PAR.VAL_PARAMETRO = 'https://trocasenha.animaeducacao.com.br/EsqueciMinhaSenha/Index'
    WHERE PAR.COD_TPO_PARAMETRO in (1,2);
