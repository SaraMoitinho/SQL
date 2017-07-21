
-- Add/modify columns 
alter table dbvestib.RCURTUR add ind_deseja_fies char(1);
alter table dbvestib.RCURTUR add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table dbvestib.RCURTUR_LOG add ind_deseja_fies char(1);
alter table dbvestib.RCURTUR_LOG add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table dbvestib.OPCAOCANDIDATO add ind_deseja_fies char(1);
alter table dbvestib.OPCAOCANDIDATO add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table dbvestib.OPCAOCANDIDATO_LOG add ind_deseja_fies char(1);
alter table dbvestib.OPCAOCANDIDATO_LOG add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table dbvestib.Rcandcurturopc add ind_deseja_fies char(1);
alter table dbvestib.Rcandcurturopc add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table dbvestib.Rcandcurturopc_LOG add ind_deseja_fies char(1);
alter table dbvestib.Rcandcurturopc_LOG add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table DBVESTIB.RCANDCURTUROPC_LOG_BI add ind_deseja_fies char(1);
alter table DBVESTIB.RCANDCURTUROPC_LOG_BI add ind_deseja_prouni CHAR(1);

-- Add/modify columns 
alter table DBVESTIB.OPCAOCANDIDATO_LOG_BI add ind_deseja_fies char(1);
alter table DBVESTIB.OPCAOCANDIDATO_LOG_BI add ind_deseja_prouni CHAR(1);

-- Ao ser candidato
DBVESTIB.SP_CONFIRMA_INSC_INTERNET

-- Atualiza opção de curso da inscrição
DBVESTIB.SP_ATUALIZA_OPCOES_CANDIDATO
-- Atualiza opção de curso do candidato
 DBVESTIB.SP_ATUALIZA_OPCAO
-- Prepara sistema para novo concurso 
 dbvestib.sp_prepara_novo_concurso
 
 
 
 
 -- Create table

create table dbvestib.STATUS_FORMA_INGRESSO
(
  cod_sta_forma_ingresso NUMBER(10) not null,
  cod_sta_aluno          NUMBER(10),
  cod_tpo_entrada        NUMBER(10)
)
tablespace TS_DATA_DBVESTIB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
  );
  
  
grant  SELECT , ALTER on dbVESTIB.Status_Forma_Ingresso_S to user_dbvestib  ;

-- Create/Recreate primary, unique and foreign key constraints 
alter table dbvestib.STATUS_FORMA_INGRESSO
  add constraint PK_COD_STA_FORMA_INGRESSO primary key (COD_STA_FORMA_INGRESSO);
/*alter table dbvestib.STATUS_FORMA_INGRESSO
  add constraint FK_COD_STA_ALUNO foreign key (COD_STA_ALUNO)*/
  references dbsiaf.status_aluno (COD_STA_ALUNO);
alter table dbvestib.STATUS_FORMA_INGRESSO
  add constraint FK_COD_TPO_ENTRADA foreign key (COD_TPO_ENTRADA)
  references dbsiaf.tipo_entrada (COD_TPO_ENTRADA);
 
-- Add comments to the columns 
comment on column dbvestib.STATUS_FORMA_INGRESSO.cod_sta_aluno
  is 'Armazena o status do aluno. Caso não seja aluno este campo é null ';

comment on column dbvestib.STATUS_FORMA_INGRESSO.cod_tpo_entrada
  is 'Armazena as formas de entradas possiveis de acordo com o status aluno ';  
  
-- Create sequence 
create sequence dbvestib.STATUS_FORMA_INGRESSO_S
minvalue 1
start with 1
increment by 1
order;



//select * from dbvestib.status_forma_ingresso


DECLARE
	CURSOR C_INGRESSO(TIPO_ENTRADA VARCHAR2) IS
		SELECT TT.COD_TPO_ENTRADA,
			   TT.DSC_TPO_ENTRADA
		  FROM DBSIAF.TIPO_ENTRADA TT
		 WHERE UPPER(TT.DSC_TPO_ENTRADA) LIKE UPPER(TIPO_ENTRADA || '%');

BEGIN

	-- ativo 

	FOR R_INGRESSO IN C_INGRESSO('reopção') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 1,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('transferência d') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 1,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('transferência u') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 1,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	-- trancado

	FOR R_INGRESSO IN C_INGRESSO('destranca') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 5,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 5,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 5,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	--Abandonado

	FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 4,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 4,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	-- cancelado

	FOR R_INGRESSO IN C_INGRESSO('retorno') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 3,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('reingresso') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 3,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	-- Formado
	FOR R_INGRESSO IN C_INGRESSO('Obtenção de Novo') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 2,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;
	-- Novo é aluno
	FOR R_INGRESSO IN C_DESTRANCA('Obtenção de Novo') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 NULL,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;

	FOR R_INGRESSO IN C_INGRESSO('transferência e') LOOP
		INSERT INTO DBVESTIB.STATUS_FORMA_INGRESSO
			(COD_STA_FORMA_INGRESSO,
			 COD_STA_ALUNO,
			 COD_TPO_ENTRADA)
		VALUES
			(DBVESTIB.STATUS_FORMA_INGRESSO_S.NEXTVAL,
			 NULL,
			 R_INGRESSO.COD_TPO_ENTRADA);
	END LOOP;
END;
