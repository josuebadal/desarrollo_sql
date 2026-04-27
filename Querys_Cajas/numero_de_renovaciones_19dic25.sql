DROP FUNCTION public.numero_renovados_reestructurados_focoop(integer,integer,integer);

CREATE OR REPLACE FUNCTION public.numero_renovados_reestructurados_focoop(integer,integer,integer)
RETURNS varchar as $$ 
DECLARE
  idorigenp_original  ALIAS FOR $1;
  idproducto_original ALIAS FOR $2;
  idauxiliar_original ALIAS FOR $3;

  v_contador   integer;
  idorigenp_r  integer;
  idproducto_r integer;
  idauxiliar_r integer;
  idorigenp_i  integer;
  idproducto_i integer;
  idauxiliar_i integer;
  v_idorigen   integer;
  v_idgrupo    integer;
  v_idsocio    integer;

  r integer;

  r_rev   record;
  r_rec   record;
  r_rec_1 record;
  r_rec_2 record;

  query_1 text;
  query_2 text;

  n_r integer;
  i   integer;

  v_atras    integer;
  v_adelante integer;

  resultado_f      varchar;
  posicion_actual  integer;
  credito_original varchar;
  total_r          integer;
BEGIN 

  v_contador := 0;

  select into v_idorigen, v_idgrupo ,v_idsocio  idorigen, idgrupo, idsocio 
  from v_auxiliares
  where (idorigenp,idproducto,idauxiliar) = (idorigenp_original, idproducto_original, idauxiliar_original);
/*
  for r_rec  in 
    select distinct rf.idorigenpr,rf.idproductor,rf.idauxiliarr,rf.idorigenp,rf.idproducto,rf.idauxiliar,
                    rf.tiporeferencia
    from v_auxiliares va
         inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                    rf.idauxiliarr=va.idauxiliar 
    where rf.tiporeferencia = 1 and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and va.estatus in (2,3)
   union 
select distinct rf.idorigenpr,rf.idproductor,rf.idauxiliarr,rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia
from v_auxiliares as va
inner join referenciasp as rf on rf.idorigenp= va.idorigenp and rf.idproducto= va.idproducto and rf.idauxiliar= va.idauxiliar
where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=( v_idorigen,v_idgrupo,v_idsocio) and va.estatus in (2,3)

  loop

    insert into historial_renovacion_reestructuracion
    values (r_rec.idorigenpr, r_rec.idproductor, r_rec.idauxiliarr,
            (case when (select estatus from v_auxiliares
                        where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar)) in (3,2)
                  then r_rec.idorigenp
             end),
            (case when (select estatus from v_auxiliares
                        where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar)) in (3,2)
                  then r_rec.idproducto
             end),
            (case when (select estatus from v_auxiliares
                        where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar)) in (3,2)
                  then r_rec.idauxiliar
             end),
            r_rec.tiporeferencia);

  end loop;

  delete from historial_renovacion_reestructuracion
  where idorigenp_despues is null or idproducto_despues is null or idauxiliar_despues is null;
*/

  select into v_atras 1
  from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes, ---antes
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idorigenp end) as idorigenp_despues,
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idproducto end) as idproducto_despues,
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idauxiliar end) as idauxiliar_despues
                       -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
        from v_auxiliares va
             inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                            rf.idauxiliarr=va.idauxiliar 
	where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
              va.estatus in (2,3)) as x
  where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
        (idorigenp_antes,idproducto_antes,idauxiliar_antes) = (idorigenp_original,idproducto_original,idauxiliar_original);
raise notice '------------------------------------------------->> v_atras : %', v_atras;
/*
	select into v_atras 1 
	from historial_renovacion_reestructuracion 
	where (idorigenp_antes,idproducto_antes,idauxiliar_antes) = (idorigenp_original ,idproducto_original,idauxiliar_original);
*/

  select into v_adelante 1
  from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idorigenp end) as idorigenp_despues,
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idproducto end) as idproducto_despues  ,
                        (case when (select estatus from v_auxiliares
                                    where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                              then rf.idauxiliar end) as idauxiliar_despues
        -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
        from v_auxiliares va
             inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                           rf.idauxiliarr=va.idauxiliar 
        where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
              va.estatus in (2,3)) as x
  where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
        (idorigenp_despues,idproducto_despues,idauxiliar_despues) = (idorigenp_original,idproducto_original,idauxiliar_original);
raise notice '------------------------------------------------->> v_adelante : %', v_adelante;

  if (v_atras is null and v_adelante = 1)   then                                               ------ nos dieron la cola 
    -------------------COLA
    select into idorigenp_r, idproducto_r, idauxiliar_r
                idorigenp_antes,idproducto_antes,idauxiliar_antes
    from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idorigenp end) as idorigenp_despues,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idproducto end) as idproducto_despues  ,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idauxiliar end) as idauxiliar_despues
          -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
          from v_auxiliares va
	       inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                             rf.idauxiliarr=va.idauxiliar 
          where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                va.estatus in (2,3)) as x
    where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
          (idorigenp_despues,idproducto_despues,idauxiliar_despues)=(idorigenp_original,idproducto_original,idauxiliar_original);

    v_contador :=1;
    for r_rec_1 in 
      select * 
      from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idorigenp end) as idorigenp_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idproducto end) as idproducto_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idauxiliar end) as idauxiliar_despues
            -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
            from v_auxiliares va
                 inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                               rf.idauxiliarr=va.idauxiliar
            where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                  va.estatus in (2,3)) as x
      where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)
    loop 

      if exists (select 1
                 from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idorigenp end) as idorigenp_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idproducto end) as idproducto_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idauxiliar end) as idauxiliar_despues
                       -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
                       from v_auxiliares va
                            inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                          rf.idauxiliarr=va.idauxiliar 
                       where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                             va.estatus in (2,3)) as x
                 where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
                       (idorigenp_despues,idproducto_despues,idauxiliar_despues)=(idorigenp_r,idproducto_r,idauxiliar_r))
      then

        v_contador := v_contador +1;

        select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes
	from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idorigenp end) as idorigenp_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idproducto end) as idproducto_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idauxiliar end) as idauxiliar_despues
              -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
              from v_auxiliares va
                   inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                 rf.idauxiliarr=va.idauxiliar 
              where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                    va.estatus in (2,3)) as x
        where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
              (idorigenp_despues,idproducto_despues,idauxiliar_despues)=(idorigenp_r,idproducto_r,idauxiliar_r);

      end if;

    end loop;

    resultado_f := v_contador::varchar||'|'||
                   idorigenp_r::varchar||'-'||idproducto_r::varchar||'-'||idauxiliar_r::varchar||'|'||
                   v_contador::varchar;

  else 
    v_contador := 1;
  end if;


  if v_atras = 1 and v_adelante is null then                                                 ------ nos dieron la cabeza

    select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues
    from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idorigenp end) as idorigenp_despues,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idproducto end) as idproducto_despues  ,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idauxiliar end) as idauxiliar_despues
          -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
          from v_auxiliares va
               inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                             rf.idauxiliarr=va.idauxiliar 
          where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                va.estatus in (2,3)) as x
    where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
          (idorigenp_antes,idproducto_antes,idauxiliar_antes)=(idorigenp_original,idproducto_original,idauxiliar_original);

    v_contador :=1;

    for r_rec_1 in 
      select *
      from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idorigenp end) as idorigenp_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idproducto end) as idproducto_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idauxiliar end) as idauxiliar_despues
            -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
            from v_auxiliares as va
                 inner join referenciasp as rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                  rf.idauxiliarr=va.idauxiliar
            where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                  va.estatus in (2,3)) as x
      where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)
    loop

      if exists (select 1
                 from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idorigenp end) as idorigenp_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idproducto end) as idproducto_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                            then rf.idauxiliar end) as idauxiliar_despues
                       -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
                       from v_auxiliares va
                            inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                          rf.idauxiliarr=va.idauxiliar 
                       where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                             va.estatus in (2,3)) as x
                 where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
                       (idorigenp_antes,idproducto_antes,idauxiliar_antes)=(idorigenp_r,idproducto_r,idauxiliar_r))
      then

        v_contador := v_contador +1;

        select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues
	from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idorigenp end) as idorigenp_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idproducto end) as idproducto_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idauxiliar end) as idauxiliar_despues
              -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
              from v_auxiliares va
                   inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                 rf.idauxiliarr=va.idauxiliar 
              where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                    va.estatus in (2,3)) as x
        where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
              (idorigenp_antes,idproducto_antes,idauxiliar_antes) =( idorigenp_r ,idproducto_r ,idauxiliar_r );

      end if;

    end loop;

    resultado_f := '0'||'|'||
                   idorigenp_original::varchar||'-'||idproducto_original::varchar||'-'||idauxiliar_original::varchar||'|'||
                   v_contador::varchar;

  else 
    v_contador := 1;
  end if;

  if v_atras = 1 and v_adelante = 1   ------ nos dieron una parte del cuerpo
  then 
--- VAMOS A LLEGAR A LA CABEZA PARA IR DESCENDIENDO EN ORDEN

------------------COLA
    select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes
    from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idorigenp end) as idorigenp_despues,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idproducto end) as idproducto_despues,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idauxiliar end) as idauxiliar_despues
          -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
          from v_auxiliares va
               inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                             rf.idauxiliarr=va.idauxiliar 
          where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                va.estatus in (2,3)) as x
    where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
          (idorigenp_despues,idproducto_despues,idauxiliar_despues) =(idorigenp_original,idproducto_original,idauxiliar_original);
raise notice '---------------------------------------------->> (1) %-%-%',idorigenp_r ,idproducto_r ,idauxiliar_r;
    v_contador :=1;

    for r_rec_1 in 
      select * 
      from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idorigenp end) as idorigenp_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idproducto end) as idproducto_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idauxiliar end) as idauxiliar_despues
            -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
            from v_auxiliares va
                 inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                               rf.idauxiliarr=va.idauxiliar
            where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                  va.estatus in (2,3)) as x
      where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)
    loop 

      if exists (select 1
                 from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idorigenp end) as idorigenp_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idproducto end) as idproducto_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idauxiliar end) as idauxiliar_despues
                       -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
                       from v_auxiliares va
                            inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                          rf.idauxiliarr=va.idauxiliar 
                       where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                             va.estatus in (2,3)) as x
                 where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
                       (idorigenp_despues,idproducto_despues,idauxiliar_despues)=(idorigenp_r ,idproducto_r ,idauxiliar_r))
      then

        v_contador := v_contador +1;

        select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes
        from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idorigenp end) as idorigenp_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idproducto end) as idproducto_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idauxiliar end) as idauxiliar_despues
              -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
              from v_auxiliares va
                   inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                 rf.idauxiliarr=va.idauxiliar 
              where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                    va.estatus in (2,3)) as x
        where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
              (idorigenp_despues,idproducto_despues,idauxiliar_despues) =( idorigenp_r ,idproducto_r ,idauxiliar_r );

      end if;

    end loop;

    credito_original := idorigenp_r::varchar||'-'||idproducto_r::varchar||'-'||idauxiliar_r::varchar;
raise notice '---------------------------------------------->> (1) CREDITO : %', credito_original;
    select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues
    from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idorigenp end) as idorigenp_despues,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idproducto end) as idproducto_despues  ,
                          (case when (select estatus from v_auxiliares
                                      where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                then rf.idauxiliar end) as idauxiliar_despues
          -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
          from v_auxiliares va
               inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                             rf.idauxiliarr=va.idauxiliar 
          where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and
                va.estatus in (2,3)) as x
    where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
          (idorigenp_antes,idproducto_antes,idauxiliar_antes) =(idorigenp_r ,idproducto_r ,idauxiliar_r);

    v_contador :=1;
    for r_rec_1 in
      select *
      from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idorigenp end) as idorigenp_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idproducto end) as idproducto_despues,
                            (case when (select estatus from v_auxiliares
                                        where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                  then rf.idauxiliar end) as idauxiliar_despues
            -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
            from v_auxiliares va
                 inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                               rf.idauxiliarr=va.idauxiliar 
            where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                  va.estatus in (2,3)) as x
      where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)
    loop

      if exists (select 1
                 from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idorigenp end) as idorigenp_despues,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idproducto end) as idproducto_despues  ,
                                       (case when (select estatus from v_auxiliares
                                                   where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                             then rf.idauxiliar end) as idauxiliar_despues
                       -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
                       from v_auxiliares as va
                            inner join referenciasp as rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                             rf.idauxiliarr=va.idauxiliar 
                       where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                             va.estatus in (2,3)) as x
                 where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
                       (idorigenp_antes,idproducto_antes,idauxiliar_antes)=(idorigenp_r,idproducto_r,idauxiliar_r))
      then

        posicion_actual := 0;
        v_contador := v_contador +1;

        select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues
	from (select distinct rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idorigenp end) as idorigenp_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idproducto end) as idproducto_despues,
                              (case when (select estatus from v_auxiliares
                                          where (idorigenp,idproducto,idauxiliar)=(rf.idorigenp,rf.idproducto,rf.idauxiliar)) in (3,2)
                                    then rf.idauxiliar end) as idauxiliar_despues
              -- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
              from v_auxiliares va
                   inner join referenciasp rf on rf.idorigenpr=va.idorigenp and rf.idproductor=va.idproducto and
                                                 rf.idauxiliarr=va.idauxiliar 
              where rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and
                    va.estatus in (2,3)) as x
        where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
              (idorigenp_antes,idproducto_antes,idauxiliar_antes) = (idorigenp_r,idproducto_r,idauxiliar_r);

        if idorigenp_r = idorigenp_original and idproducto_r = idproducto_original and
           idauxiliar_r = idauxiliar_original
        then 
          posicion_actual := v_contador;
        end if;

      end if;

    end loop;

    if posicion_actual = 0 and v_contador > 0 then
      posicion_actual := v_contador;
    end if;

    resultado_f := posicion_actual::varchar||'|'||credito_original::varchar||'|'||v_contador::varchar;
raise notice '---------------------------------------------->> (1) RESULTADO FINAL : %', resultado_f;
  end if;

  if resultado_f is null then
    resultado_f := '0|0|0';
  end if;

  return resultado_f;

END;
$$ language 'plpgsql';

/*
select va.idorigen,va.idgrupo,va.idsocio, numero_renovados_reestructurados_focoop(va.idorigenp,va.idproducto,va.idauxiliar) as funcion 
from v_auxiliares as va
inner join referenciasp as rf on va.idorigenp=rf.idorigenp and va.idproducto=rf.idproducto and va.idauxiliar=rf.idauxiliar
where va.estatus in (2,3) and rf.tiporeferencia in (2,3);
*/


----- reemplazo de la primera tabla temporal
/*
	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(20713,10,5074) and va.estatus in (2,3) 

*/


/*

	select *, count(idauxiliar_antes) as contador from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(20713,10,5074) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) 

group by idorigenp_antes,idproducto_antes,idauxiliar_antes,idorigenp_despues,idproducto_despues,idauxiliar_despues ;


*/
