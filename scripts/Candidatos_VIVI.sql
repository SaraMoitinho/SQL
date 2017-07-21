
                                 
 
 SELECT DISTINCT CC.CODCONC,
                 CC.CODCAN,
                 CC.NOMCAN "Candidato",
                 cur.nomcur "Curso",
                 TUR.DSCTUR "Turno",
                 CC.SITCAN "Situação dia 30/10",                
                 (SELECT DISTINCT CAN.SITCAN
                    FROM DBVESTIB.CANDIDATO_LOG CAN
                   WHERE CAN.CODCONC = '1433'
                         AND CAN.SITCAN <> CC.SITCAN
                         AND CC.CODCONC = CAN.CODCONC
                         AND CAN.CODCAN = CC.CODCAN
                         AND TRUNC(CAN.DAT_OPERACAO_LOG) > to_Date('01/11/2012','DD/MM/YYYY'))"situação dia atual"
   FROM DBVESTIB.CANDIDATO_LOG CC,
        DBVESTIB.CURSO CUR,
        DBVESTIB.RCANDCURTUROPC OPC,
        DBVESTIB.TURNO TUR
  WHERE CC.CODCONC = '1433'        
        AND CC.CODCONC = OPC.CODCONC
        AND OPC.CODCONC = CUR.CODCONC
        AND CUR.CODCUR = OPC.CODCUR
        AND OPC.NROOPC = '1'
        AND OPC.CODCAN = CC.CODCAN
        AND TUR.CODTUR = OPC.CODTUR
        AND TRUNC(CC.DAT_OPERACAO_LOG) = to_Date('30/10/2012','DD/MM/YYYY')
        AND CC.SITCAN <> (SELECT DISTINCT CAN.SITCAN
                            FROM DBVESTIB.CANDIDATO_LOG CAN
                           WHERE CAN.CODCONC = cc.codconc
                                 AND CAN.CODCAN = CC.CODCAN
                                 AND TRUNC(CAN.DAT_OPERACAO_LOG) >  to_Date('01/11/2012','DD/MM/YYYY')
                           AND CAN.COD_USUARIO_LOG = 13391
                          )                                
                                

