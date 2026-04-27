/*
create table claves_regulatorios (
  idorigenp     integer,
  idproducto    integer,
  idauxiliar    integer,
  fecha         date,
  clave         varchar,
  idorigenp_a   integer,
  idproducto_a  integer,
  idauxiliar_a  integer,
  primary key (idorigenp, idproducto, idauxiliar)
);
*/
create or replace function
sai_genera_clave_regulatorio(integer, integer, integer, integer, integer, integer)
returns varchar as $$
declare
  p_idorigen   alias for $1;
  p_idgrupo    alias for $2;
  p_idsocio    alias for $3;
  p_idorigenp  alias for $4;
  p_idproducto alias for $5;
  p_idauxiliar alias for $6;

  x_idorigenpr  integer;
  x_idproductor integer;
  x_idauxiliarr integer;

  x integer;
  y integer;

  r_clave record;
  x_clave varchar;

  x_referencia varchar;
  x_entidad    varchar;
  x_periodo    varchar;
  x_rfc        varchar;
  x_3dig       varchar;

  px1 text;

  fecha_hoy date;
begin

  select into x count(*) from auxiliares
  where (idorigenp,idproducto,idauxiliar) = (p_idorigenp,p_idproducto,p_idauxiliar);
  if x is NULL then x := 0; end if;

  select into y count(*) from auxiliares_h
  where (idorigenp,idproducto,idauxiliar) = (p_idorigenp,p_idproducto,p_idauxiliar);
  if y is NULL then y := 0; end if;

  x := x + y;

  if x = 0 then
    return '0|EL FOLIO NO EXISTE !!!';
  end if;

  select into fecha_hoy date(fechatrabajo)
  from origenes
  limit 1;

  if not found then
    fecha_hoy := date(now());
  end if;

  ---------------------------
  -- YA EXISTE LA CLAVE ?? --
  ---------------------------
  select into r_clave *
  from claves_regulatorios
  where (idorigenp,idproducto,idauxiliar) = (p_idorigenp,p_idproducto,p_idauxiliar);

  if found then
    return '1|'||r_clave.clave;
  end if;
  ---------------------------
  ---------------------------


  --- TIPO DE REFERENCIA ---
  x := 0;
  select into x tiporeferencia
  from v_auxiliares
  where (idorigenp,idproducto,idauxiliar) = (p_idorigenp,p_idproducto,p_idauxiliar);

  if not found then
    return '0|NO EXISTE EL CAMPO tiporeferencia !!!';
  end if;

  if x > 0 then

    -- PRIMERO busca usando la funcion que hizo Gaby ...
    px1 := numero_renovados_reestructurados_focoop(p_idorigenp, p_idproducto, p_idauxiliar);

    if px1 is NULL or px1 like '0|%' or px1 like '%|0|%' then
      return '0|(1) NO EXISTE REGISTRO DE UN FOLIO PREVIO !!!';
    end if;

    x_idorigenpr  := trim(sai_token(1,trim(sai_token(2,px1,'|')),'-'))::integer;
    x_idproductor := trim(sai_token(2,trim(sai_token(2,px1,'|')),'-'))::integer;
    x_idauxiliarr := trim(sai_token(3,trim(sai_token(2,px1,'|')),'-'))::integer;

-- raise notice '------------------------------------------>> (1) REFERENCIA : % --- %-%-%', px1, x_idorigenpr, x_idproductor, x_idauxiliarr;

    select into r_clave *
    from claves_regulatorios
    where (idorigenp,idproducto,idauxiliar) = (x_idorigenpr,x_idproductor,x_idauxiliarr);

    if found then
      if length(r_clave.clave) < 10 then
        return '0|(2) NO EXISTE REGISTRO DE UN FOLIO PREVIO !!!';
      end if;

      x_idorigenpr := NULL; x_idproductor := NULL; x_idauxiliarr := NULL;
      select into x_idorigenpr, x_idproductor, x_idauxiliarr
                  idorigenp, idproducto, idauxiliar
      from v_auxiliares
      where (idorigenp,idproducto,idauxiliar) in
            (select idorigenpr,idproductor,idauxiliarr
             from referenciasp
             where (idorigenp,idproducto,idauxiliar) = (p_idorigenp,p_idproducto,p_idauxiliar) and
                   tiporeferencia in (2,3));
      if not found then
        return '0|(3) NO EXISTE REGISTRO DE UN FOLIO PREVIO !!!';
      end if;

      insert into claves_regulatorios values (p_idorigenp, p_idproducto, p_idauxiliar, fecha_hoy, x_clave,
                                              x_idorigenpr, x_idproductor, x_idauxiliarr);

      return '1|'||r_clave.clave;
    end if;
  else
    x_idorigenpr  := NULL;
    x_idproductor := NULL;
    x_idauxiliarr := NULL;
  end if;

  x_referencia := (case when x_idorigenpr is not NULL and x_idproductor is not NULL and x_idauxiliarr is not NULL
                        then (select case when dependede = 1
                                          then 3
                                          when dependede = 3
                                          then 1
                                          else dependede
                                     end
                              from finalidades f
                                   inner join v_auxiliares ax using (idfinalidad)
                              where ax.idorigenp = x_idorigenpr and ax.idproducto = x_idproductor and
                                    ax.idauxiliar = x_idauxiliarr)
                        else (case when x in (2,3)
                                   then (select case when dependede = 1
                                                     then 3
                                                     when dependede = 3
                                                     then 1
                                                     else dependede
                                                end
                                         from finalidades f
                                              inner join v_auxiliares ax using (idfinalidad)
                                              inner join referenciasp rf on (ax.idorigenp=rf.idorigenpr and
                                                                             ax.idproducto=rf.idproductor and
                                                                             ax.idauxiliar=rf.idauxiliarr)
                                         where ax.idorigenp = p_idorigenp and ax.idproducto = p_idproducto and
                                               ax.idauxiliar = p_idauxiliar
                                         limit 1)
                                   else (select case when dependede = 1
                                                     then 3
                                                     when dependede = 3
                                                     then 1
                                                     else dependede
                                                end
                                         from finalidades f
                                              inner join v_auxiliares ax using (idfinalidad)
                                         where ax.idorigenp = p_idorigenp and ax.idproducto = p_idproducto and
                                               ax.idauxiliar = p_idauxiliar)
                              end)
                   end)::varchar;
-- raise notice '------------------------------------------------>> REFERENCIA : %', x_referencia;

  --- ENTIDAD ---
  select into x_entidad dato2::varchar
  from tablas
  where lower(idtabla) = 'param' and lower(idelemento) = 'reportes_regulatorios';

  if not found then
    return '0|NO EXISTE LA ENTIDAD (param/reportes_regulatorios)';
  end if;
-- raise notice '------------------------------------------------>> ENTIDAD : %', x_entidad;

  --- PERIODO ---
  if x in (2,3) then
    x_periodo := (case when x_idorigenpr is not NULL and x_idproductor is not NULL and x_idauxiliarr is not NULL
                       then trim(to_char((select fechaactivacion from v_auxiliares
                                          where idorigenp = x_idorigenpr and idproducto = x_idproductor and
                                                idauxiliar = x_idauxiliarr),
                                         'yyyymm'))
                       else trim(to_char((select ax.fechaactivacion
                                          from v_auxiliares ax
                                               inner join referenciasp rf on (ax.idorigenp  = rf.idorigenpr and
                                                                              ax.idproducto = rf.idproductor and
                                                                              ax.idauxiliar = rf.idauxiliarr)
                                          where rf.idorigenp = p_idorigenp and rf.idproducto = p_idproducto and
                                                rf.idauxiliar = p_idauxiliar and rf.tiporeferencia in (2,3)),
                                         'yyyymm'))
                  end);
  else
    x_periodo := trim(to_char((select fechaactivacion from v_auxiliares
                               where idorigenp=p_idorigenp and idproducto=p_idproducto and idauxiliar=p_idauxiliar),
                              'yyyymm'));
  end if;
--raise notice '------------------------------------------------>> PERIODO : %', x_periodo;

  --- RFC ---
  select into x_rfc rfc
  from personas
  where (idorigen,idgrupo,idsocio) = (p_idorigen,p_idgrupo,p_idsocio);

  if not found then
    return '0|NO EXISTE EL RFC !!!';
  end if;

  if p_idgrupo = 30 then
    x_rfc := '_'||x_rfc;
  end if;
-- raise notice '------------------------------------------------>> RFC : %', x_rfc;

  --- ULTIMOS 3 DIGITOS DEL IDAUXILIAR ---
  x_3dig := (case when x in (2,3)
                  then (case when x_idorigenpr is not NULL and x_idproductor is not NULL and x_idauxiliarr is not NULL
                             then substr(trim(to_char(x_idauxiliarr,'09999999')),6)
                             else (select substr(trim(to_char(ax.idauxiliar,'09999999')),6)
                                   from v_auxiliares ax
                                        inner join referenciasp rf on (ax.idorigenp=rf.idorigenpr and
                                                                       ax.idproducto=rf.idproductor and
                                                                       ax.idauxiliar=rf.idauxiliarr)
                                   where rf.idorigenp = p_idorigenp and rf.idproducto = p_idproducto and
                                         rf.idauxiliar = p_idauxiliar and rf.tiporeferencia in (2,3))
                        end)
                  else substr(trim(to_char(p_idauxiliar,'09999999')),6)
             end);
-- raise notice '------------------------------------------------>> 3 DIGITOS : %', x_3dig;

  x_clave := x_referencia||x_entidad||x_periodo||x_rfc||x_3dig;

  insert into claves_regulatorios values (p_idorigenp, p_idproducto, p_idauxiliar, fecha_hoy, x_clave,
                                          x_idorigenpr, x_idproductor, x_idauxiliarr);

  ------------------------------------------------------------------------------
  -- ULTIMA MODIFICACION : 18/DICIEMBRE/2025 -----------------------------------
  ------------------------------------------------------------------------------

  return '1|'||x_clave;
end;
$$ language 'plpgsql';

