declare

cursor c_cand is

SELECT CAN.CODCAN,
       can.codconc,
       can.nomcan,
                           (SELECT COUNT(1)
                               FROM DBVESTIB.DISTRIBUICAO_CANDIDATO DDC
                             WHERE DDC.CODCAN = CAN.CODCAN
                                      AND DDC.CODCONC = CAN.CODCONC) AS TOTAL_DISTRIBUICAO
        FROM DBVESTIB.CANDIDATO      CAN,
           DBVESTIB.RCANDCURTUROPC RCT
       WHERE CAN.CODCONC in ('3135', '3136','3141')
           AND CAN.CODCONC = RCT.CODCONC
           AND CAN.CODCAN = RCT.CODCAN
           AND RCT.NROOPC = '1'
          --Se for candidato da primeira etapa e n�o tive sido distribuido na primeira etapa
           AND ((1 = 1 AND NOT EXISTS (SELECT 1
                               FROM DBVESTIB.DISTRIBUICAO_CANDIDATO DCA
                              WHERE DCA.CODCONC = CAN.CODCONC
                                AND DCA.CODCAN = CAN.CODCAN
                                AND DCA.COD_ETAPA = 1)) OR
           -- ou se for candidato da segunda etapa e n�o tiver distribui��o na segunda ou  for ENEM
           (1 > 1 AND (NOT EXISTS (SELECT 1
                              FROM DBVESTIB.DISTRIBUICAO_CANDIDATO DCA
                               WHERE DCA.CODCONC = CAN.CODCONC
                                 AND DCA.CODCAN = CAN.CODCAN
                                 AND DCA.COD_ETAPA = 1)) OR CAN.CODFORMAPROVA = 2))
          
           AND EXISTS (SELECT 1
            FROM DBVESTIB.CURSOSCADERNO CCAD,
               DBVESTIB.CADERNO       CAD
           WHERE CCAD.CODCONC = RCT.CODCONC
               AND CCAD.CODCUR = RCT.CODCUR
               AND CCAD.CODCONC = CAD.CODCONC
               AND CCAD.CODCAD = CAD.CODCAD
               AND CAD.COD_ETAPA = 1
          
          )
       ORDER BY CODCAN;
       
       
       begin
         
       FOR R_INSC IN c_cand LOOP
                              DBVESTIB.PC_DISTRIBUICAO.SP_DISTRIBUIR_CANDIDATO(R_INSC.codconc,
                                                                                                    R_INSC.CODCAN,
                                                                                                    1,
                                                                                                    'S');
                        END LOOP;
        
        commit;
       end;
/*
select * from 
DBVESTIB.CANDIDATO      CAN
--           DBVESTIB.RCANDCURTUROPC RCT
       WHERE CAN.CODCONC in ('3135', '3136','3141')
*/
