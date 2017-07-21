--consulta passo 
 select codconc
            from concurso
            where conconc = :codconc
            and not exists(
                select 1
                from estr_ins
                where idasdas
                and sdfas
                and ind_web = 'N'
                )
