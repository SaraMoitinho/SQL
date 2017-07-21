select c.codconc, c.codcan, c.celcan, c.telcan, c.telcomercial  
from dbvestib.candidato c
--dbvestib.opcaocandidato o
where (((c.celcan is not null) and(length (c.celcan) <=7)) or ((c.telcan is not null) and (length (c.telcan)<=7)) or((c.telcomercial is not null)and (length(c.telcomercial)<=7)))
and o.codconc = c.codconc
and o.codinsc = c.codcan
                   
select i.codconc, i.codinsc,i.celcan, i.telcan, i.telcomercial
from  dbvestib.inscricao i,
      dbvestib.opcaocandidato o
where (((i.celcan is not null) and (length (i.celcan)<=7)) or ((i.telcan is not null) and (length (i.telcan)<=7)) or ((i.telcomercial is not null) and (length(i.telcomercial)<=7)))
and o.codconc = i.codconc
and o.codinsc = i.codinsc
and o.nroopc = '1'


select ena.cod_aluno, ena.tel_endereco, ena.fax_numero
from dbsiaf.end_aluno ena
where ena.cod_tpo_endereco = 1
and (((ena.tel_endereco is not null) and (length (ena.tel_endereco)<=7))
    or ((ena.fax_numero is not null) and (length(ena.fax_numero)<=7)))    

select * 
from dbsiaf.aluno al
where ((al.tel_celular is not null) and (length (al.tel_celular)<=7))
