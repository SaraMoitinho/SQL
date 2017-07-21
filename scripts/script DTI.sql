DECLARE
V_OCORRENCIA CHAR(1);
BEGIN

    DBSIAF.PC_MUTANTE_TABLE.SP_INSERE('OCR',
                                      'OCORRENCIA',
                                      'S');
                                      
    UPDATE DBSIAF.OCORRENCIA O
       SET O.COD_TPO_SEQUENCIA = 10
     WHERE O.COD_OCORRENCIA = 37;

    DBSIAF.PC_MUTANTE_TABLE.SP_LIMPA_TEMPORARIA('OCR',
                                                'OCORRENCIA');
END;
