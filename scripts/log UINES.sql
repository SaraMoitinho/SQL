
select c.nomcur, o.nroopc, cam.nomcam, t.dsctur, o.dat_operacao_log, o.cod_usuario_log
from dbvestib.opcaocandidato_log o,
dbvestib.curso c,
dbvestib.turno t,
dbvestib.campus cam
where o.codconc = '1582'
and o.codinsc = '748669'
and c.codconc = o.codconc
and c.codcur = o.codcur
and t.codtur = o.codtur
and cam.codcam = o.codcam
