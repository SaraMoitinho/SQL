update dbvestib.inscricao  i
set i.formapgto = 4, valpago = 0
where codconc  ='3028'
and codinsc in (
'708685',
'708036',
'708046',
'708017');

UPDATE DBVESTIB.INSCRICAO I
   SET I.FORMAPGTO = 4,
	   VALPAGO     = 0
 WHERE CODCONC = '3027'
	   AND CODINSC IN ('708692',
					   '708027',
					   '707987',
					   '707885',
					   '708096',
					   '708696',
					   '708678',
					   '708092',
					   '708077',
					   '708066',
					   '707982',
					   '708083',
					   '708038',
					   '707869',
					   '708011',
					   '708700',
					   '707994',
					   '708680',
					   '707875');
