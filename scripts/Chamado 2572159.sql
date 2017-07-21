
update
set ins.formapgto = 'B'
from dbvestib.inscricao ins
where ins.codconc = '3123'
and ins.codinc IN ('720194', '722019')
