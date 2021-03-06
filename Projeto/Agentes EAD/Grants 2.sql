GRANT SELECT ON DBSAG.PROCESSO_S TO DBSIAF;
GRANT SELECT, INSERT, UPDATE ON DBVESTIB.CONC_PROCESSO_AGENDAMENTO TO DBSIAF;
GRANT SELECT, INSERT, UPDATE ON DBSAG.CONFIGURACAO_PROCESSO TO DBSIAF;

GRANT SELECT, DELETE,INSERT, UPDATE ON DBSIAF.CONCURSO_ANO_SEMESTRE TO DBSIAF;
GRANT SELECT, DELETE,INSERT, UPDATE ON DBSIAF.CONCURSO_ANO_SEMESTRE TO DBVESTIB;
GRANT SELECT, DELETE,INSERT, UPDATE ON DBSIAF.CONCURSO_ANO_SEMESTRE TO user_SIAF;
GRANT SELECT, DELETE,INSERT, UPDATE ON DBSIAF.CONCURSO_ANO_SEMESTRE TO user_dbVESTIB;
GRANT SELECT, DELETE,INSERT, UPDATE ON DBSIAF.CONCURSO_ANO_SEMESTRE TO DESENV_DML;

GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO DBSIAF;
GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO DBVESTIB;

GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO USER_SIAF;
GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO USER_DBVESTIB;
GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO DESENV_DML;
GRANT SELECT ON DBSIAF.CONCURSO_ANO_SEMESTRE_S TO DESENV;

GRANT SELECT, INSERT,DELETE, UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO DBSIAF;
GRANT SELECT, INSERT, DELETE,UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO DBVESTIB;
GRANT SELECT, INSERT, DELETE,UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO DESENV_DML;
GRANT SELECT, INSERT, DELETE,UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO DESENV;
GRANT SELECT, INSERT, DELETE,UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO USER_SIAF;
GRANT SELECT, INSERT, DELETE,UPDATE ON DBSIAF.HORARIO_CONCURSO_ANO_SEM TO USER_DBVESTIB;


GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO DBSIAF;
GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO user_SIAF;
GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO user_DBvestib;
GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO DBVESTIB;
GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO DESENV_DML;
GRANT SELECT ON DBSIAF.HORARIO_CONCURSO_ANO_SEM_S TO DESENV;
GRANT SELECT, UPDATE, DELETE ON DBSIAF.ENDERECO_ESTRUTURA TO XCANDIDATO;

GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_PESSOA TO USER_SIAF;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_PESSOA TO USER_DBADM;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_PESSOA TO USER_DBVESTIB;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_PESSOA TO DBVESTIB with grant option;

GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB TO USER_SIAF;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB TO USER_DBADM;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB TO USER_DBVESTIB;
GRANT SELECT, INSERT, UPDATE ON DBSIAF.ESTRUTURA_CAMPUS_VESTIB TO DBVESTIB with grant option;


GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR TO DESENV;
GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR TO DESENV_DML;
GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR TO DBADM;
GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR TO USER_DBADM;
GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR TO USER_DBVESTIB;
GRANT SELECT ON  DBVESTIB.VW_ESTRUTURA_ENTREVISTADOR   TO DESENV;

GRANT SELECT ON DBSIAF.ESTRUTURA_CONCURSO TO dbvestib with grant option;

GRANT SELECT ON DBVESTIB.VW_ESTRUTURA_CONCURSO TO DESENV_dml;
GRANT SELECT ON DBVESTIB.VW_ESTRUTURA_CONCURSO TO DBADM;
GRANT SELECT ON DBVESTIB.VW_ESTRUTURA_CONCURSO TO USER_DBADM;
GRANT SELECT ON DBVESTIB.VW_ESTRUTURA_CONCURSO TO DESENV;

