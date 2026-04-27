create or replace function
sai_formato_analisis_credito_nombre_periodo (varchar) returns text as $$
declare
  p_periodo alias for $1;
  x_ano     varchar;
  x_mes     varchar;
  x_dim     _text;
begin
  if p_periodo is NULL or p_periodo = '' then
    return '';
  end if;
  x_ano := substr(p_periodo,1,4);
  x_mes := substr(p_periodo,5,2);
  
  x_dim := '{ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC}'::_text;
  
  return x_dim[x_mes::int]||'-'||x_ano;
end;
$$ language 'plpgsql';


create or replace function
sai_formato_analisis_credito (integer,integer,integer,varchar) returns text as $$
declare
  p_idorigenp               alias for $1;
  p_idproducto              alias for $2;
  p_idauxiliar              alias for $3;
  p_formato                 alias for $4;
  x_formato                 text;
  r_aux                     record;
  r_aux_d                   record;
  r_flujo_ah                record;
  r_flujo_pr                record;
  r_per                     record;
  r_params                  record;
  r_sec                     record;
  r_tra                     record;
  r_cod                     record;
  r_usr                     record;
  r_sec_cod                 record;
  x_fecha_hoy               date;
  x_fechauma_pr             date;
  x_periodo_ah              integer;
  x_periodo_pr              integer;
  x_periodo_ah_ini          integer;
  x_periodo_ah_fin          integer;
  x_periodo_pr_ini          integer;
  x_periodo_pr_fin          integer;
  x_cont                    integer;
  x_ab_reales               integer;
  x_max_dv                  integer;
  x_mes                     text;
  x_monto                   text;
  x_monto_abonos            numeric;
  x_suma_abonos             numeric;
  x_suma_ingresos           numeric;
  x_suma_gastos             numeric;
  x_prom_flujo_ah           numeric;
  x_prom_flujo_pr           numeric;
  x_suma_prom_flujos_pr_ah  numeric;
  x_ing_men_neto_cod        numeric;
  x_cod_gasto1              numeric;
  x_cod_gasto2              numeric;
  x_cod_gasto3              numeric;
  x_cod_gasto4              numeric;
  x_cod_gasto5              numeric;
  x_cod_gasto6              numeric;
  x_inegi                   numeric; ---ADD ABRIL 2026 FAMA
begin

  select
  into   x_formato dato2
  from   tablas
  where  idtabla = 'param' and idelemento = p_formato;
  if not found then
    raise notice 'NO EXISTE LA TABLA: param / %', p_formato;
    return NULL;
  end if;

----- INDICADOR DEL INEGI EDITABLE POR EL USUARIO EN EL ANEXO B ANALIS DE CREDITO
  select dato2::numeric
  into   x_inegi 
  from   tablas
  where  idtabla = 'param' and idelemento = 'indicador_inegi';
  if not found then
    raise notice 'NO EXISTE LA TABLA: param / %', p_formato;
    return NULL;
  end if;


  if p_formato = 'formato_analisis_credito_b' then
    select
    into   r_params *
    from   tablas
    where  idtabla = p_formato and idelemento = 'parametros';
    if not found then
      raise notice 'NO EXISTE LA TABLA: % / parametros', p_formato;
      return NULL;
    end if;
  end if;

  select
  into   x_fecha_hoy date(fechatrabajo)
  from   origenes
  limit  1;
  
  select
  into   r_aux
         a.idorigen,a.idgrupo,a.idsocio,

         trim(to_char(p.idorigen,'099999'))||'-'||trim(to_char(p.idgrupo,'09'))||'-'||trim(to_char(p.idsocio,'099999')) as ogs,

         case when g.tipogrupo = 3
              then razon_social
              else p.appaterno||' '||p.apmaterno||' '||p.nombre
         end as nombre,

         fechanacimiento,
         extract (years from age(fechanacimiento))::text as edad,
         (select descripcion
          from   catalogo_menus
          where  menu = 'estadocivil' and opcion = p.estadocivil) as estado_civil,

         (select descripcion
          from   catalogo_menus
          where  menu = 'estatusvivienda' and opcion = s.estatusvivienda) as estatus_vivienda,

         coalesce(p.calle,'????????') as calle,
         coalesce(p.numeroext,'ND')||
           (case when p.numeroint is NULL or p.numeroint = ''
                 then ''
                 else '-'||p.numeroint
            end) as numero_casa,
         p.colonia, p.municipio, p.codigopostal,

         coalesce(p.telefono,'') as telefono,

         trim(to_char(a.idorigenp,'099999'))||'-'||trim(to_char(a.idproducto,'09999'))||'-'||
           trim(to_char(a.idauxiliar,'09999999')) as opa,

         a.idorigenp,a.idproducto,a.idauxiliar,

         (select nombre
          from   productos
          where  idproducto = a.idproducto) as nom_producto,
          
         t.nombre as nombre_trabajo, 
         a.plazo, a.tasaio, a.montosolicitado,a.tipoamortizacion,
         
         case when a.tipoamortizacion = 0
              then (select 
                   (select abono from amortizaciones amm where amm.idorigenp=am.idorigenp and amm.idproducto=am.idproducto and amm.idauxiliar=am.idauxiliar order by vence desc limit 1)
                    from   amortizaciones am
                    where  am.idorigenp = a.idorigenp and am.idproducto = a.idproducto and am.idauxiliar = a.idauxiliar and
                           am.idamortizacion = 1) +
                   ((a.montosolicitado * (a.tasaio/100/30) *
                     ((select vence
                       from   amortizaciones
                       where  idorigenp = a.idorigenp and idproducto = a.idproducto and idauxiliar = a.idauxiliar and
                              idamortizacion = 1) - a.fechaape)) * (1+(pr.iva/100)))
              else ((select sai_datos_tabla_amortizaciones(a.idorigenp,a.idproducto,a.idauxiliar,'abono_1')::numeric) +
                    ((select sai_datos_tabla_amortizaciones(a.idorigenp,a.idproducto,a.idauxiliar,'interes_1')::numeric) * (1+(pr.iva/100))))
         end as monto_mensualidad

  from   auxiliares as a
         inner join productos       as pr using (idproducto)
         inner join vpersonas       as p  on    (p.idorigen = a.idorigen and p.idgrupo = a.idgrupo and p.idsocio = a.idsocio)
         inner join grupos          as g  on    (g.idgrupo  = a.idgrupo)
         inner join trabajo         as t  on    (t.idorigen = a.idorigen and t.idgrupo = a.idgrupo and t.idsocio = a.idsocio)
         inner join socioeconomicos as s  on    (s.idorigen = a.idorigen and s.idgrupo = a.idgrupo and s.idsocio = a.idsocio)
  where  idorigenp = p_idorigenp and idproducto = p_idproducto and idauxiliar = p_idauxiliar and a.estatus <= 2;

  if not found then
    raise exception 'EL AUXILIAR: %-%-% NO EXISTE O YA NO ESTA NI ACTIVO, NI APERTURADO',p_idorigenp,p_idproducto,p_idauxiliar;
  end if;
  
------------------BADAL
    select
    into     r_sec *
    from     socioeconomicos
    where    idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio;

    select
    into     r_tra *
    from     trabajo
    where    idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio and ing_mensual_neto > 0
    order by consecutivo desc
    limit    1;
------------------BADAL  

  SELECT
  INTO   r_aux_d *
  FROM   auxiliares_d as ad
  WHERE  ad.idorigenp = p_idorigenp AND ad.idproducto = p_idproducto AND ad.idauxiliar = p_idauxiliar and cargoabono = 1
  LIMIT  1;
  if found then
    raise exception 'EL AUXILIAR: %-%-% YA TIENE MOVIMIENTOS DE ABONOS, YA NO SE PUEDE REALIZAR UN ANALISIS EXACTO !!',p_idorigenp,p_idproducto,p_idauxiliar;
  end if;

  raise notice 'r_aux: %', r_aux;
  x_formato := replace(x_formato,'@@indicador_inegi@@', trim(to_char(coalesce(x_inegi,0),             '00.00')));
  x_formato := replace(x_formato,'@@fecha_impresion_de@@',    replace(sai_fecha_mes_con_letra(x_fecha_hoy), '/', ' DE '));
raise notice '%', case when x_formato is NULL then 'a) x_formato is NULL' else '' end;
  x_formato := replace(x_formato,'@@nombre_socio@@',          r_aux.nombre);
  x_formato := replace(x_formato,'@@idsocio@@',               trim(to_char(r_aux.idsocio, '099999')));
  x_formato := replace(x_formato,'@@telefono@@',              r_aux.telefono);
  x_formato := replace(x_formato,'@@fecha_nacimiento@@',      r_aux.fechanacimiento::text);
  x_formato := replace(x_formato,'@@edad@@',                  r_aux.edad);
  x_formato := replace(x_formato,'@@calle@@',                 r_aux.calle);
  x_formato := replace(x_formato,'@@numero_casa@@',           r_aux.numero_casa);
  x_formato := replace(x_formato,'@@codigo_postal@@',         r_aux.codigopostal);
  x_formato := replace(x_formato,'@@colonia@@',               r_aux.colonia);
  x_formato := replace(x_formato,'@@municipio@@',             r_aux.municipio);
  x_formato := replace(x_formato,'@@estado_civil@@',          r_aux.estado_civil);
  x_formato := replace(x_formato,'@@estatus_vivienda@@',      r_aux.estatus_vivienda);
  x_formato := replace(x_formato,'@@nombre_trabajo@@',        coalesce(r_aux.nombre_trabajo,''));
  x_formato := replace(x_formato,'@@idproducto@@',            r_aux.idproducto::text);
  x_formato := replace(x_formato,'@@nombre_producto@@',       r_aux.nom_producto);
  x_formato := replace(x_formato,'@@monto_solicitado@@',      trim(to_char(r_aux.montosolicitado,'999,999,999.99')));
  x_formato := replace(x_formato,'@@plazo_meses@@',           r_aux.plazo::text);
  x_formato := replace(x_formato,'@@tasaio_mensual@@',        trim(to_char(r_aux.tasaio,'9.99')));
raise notice '%', case when x_formato is NULL then 'b) x_formato is NULL' else '' end;
  x_formato := replace(x_formato,'@@monto_mensual_credito@@', trim(to_char(r_aux.monto_mensualidad, '999,999,999.99')));
raise notice '%', case when x_formato is NULL then 'c) x_formato is NULL' else '' end;
raise notice 'ogs: %-%-%', r_aux.idorigen, r_aux.idgrupo, r_aux.idsocio;
-------------------------BADAL
-- Gastos: ----------
  x_formato := replace(x_formato,'@@gto_men_alimentos@@',        trim(to_char(coalesce(r_sec.gastos_tipo1,0), '999,999,990.00')));
  x_formato := replace(x_formato,'@@gto_men_servicios@@',        trim(to_char(coalesce(r_sec.gastos_tipo2,0), '999,999,990.00')));
  x_formato := replace(x_formato,'@@gto_men_transporte@@',       trim(to_char(coalesce(r_sec.gastos_tipo3,0), '999,999,990.00')));
  x_formato := replace(x_formato,'@@gto_men_escolares@@',        trim(to_char(coalesce(r_sec.gastos_tipo4,0), '999,999,990.00')));
  x_formato := replace(x_formato,'@@gto_men_vivienda@@',         trim(to_char(coalesce(r_sec.gastos_tipo5,0), '999,999,990.00')));
  x_formato := replace(x_formato,'@@gto_men_otros@@',            trim(to_char(coalesce(r_sec.gastos_tipo6,0), '999,999,990.00')));

  x_suma_gastos := coalesce(r_sec.gastos_tipo1,0) + coalesce(r_sec.gastos_tipo2,0) + coalesce(r_sec.gastos_tipo3,0) + coalesce(r_sec.gastos_tipo4,0) +
                     coalesce(r_sec.gastos_tipo5,0) + coalesce(r_sec.gastos_tipo6,0) + coalesce(x_cod_gasto1,0) + coalesce(x_cod_gasto2,0) +
                     coalesce(x_cod_gasto3,0) + coalesce(x_cod_gasto4,0) + coalesce(x_cod_gasto5,0) + coalesce(x_cod_gasto6,0);
  x_formato := replace(x_formato,'@@suma_gastos@@',              trim(to_char(coalesce(x_suma_gastos,0),      '999,999,990.00')));
    

-- Ingresos: --------
  x_formato := replace(x_formato,'@@ing_men_sueldo_neto@@',      trim(to_char(coalesce(r_sec.ingresosordinarios,0),       '999,999,990.00')));
  x_formato := replace(x_formato,'@@ing_men_otro_empleo@@',      trim(to_char(coalesce(r_sec.ingresosextraordinarios,0),  '999,999,990.00')));
  x_formato := replace(x_formato,'@@ing_men_ingreso_familiar@@', trim(to_char(coalesce(x_ing_men_neto_cod,0),             '999,999,990.00')));
  x_suma_ingresos := coalesce(r_sec.ingresosordinarios,0) + coalesce(r_sec.ingresosextraordinarios,0) + coalesce(x_ing_men_neto_cod,0);
  x_formato := replace(x_formato,'@@suma_ingresos@@',            trim(to_char(coalesce(x_suma_ingresos,0),    '999,999,990.00')));

-------------------------BADAL    



  if p_formato = 'formato_analisis_credito_b' then
    -- Ahorros --------------------------------------------------------------------------------------
raise notice '%', case when x_formato is NULL then 'd) x_formato is NULL' else '' end;
    x_cont := 0;  x_suma_abonos := 0;  x_monto_abonos := 0.00;
    for x_cont in reverse 12..1
    loop
      x_periodo_ah := trim(to_char(date(x_fecha_hoy - ((x_cont)::text||' month')::interval),'yyyymm'))::integer;

      x_monto_abonos := coalesce((select     coalesce(sum(monto),0) as abonos
                                  from       auxiliares_d
                                  inner join auxiliares as a using(idorigenp,idproducto,idauxiliar)
                                  where      a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                                             a.idproducto = r_params.dato1::integer and periodo::integer = x_periodo_ah and idtipo = 1 and cargoabono = 1
                                  group by   periodo), 0) +
                        coalesce((select     coalesce(sum(monto),0) as abonos
                                  from       auxiliares_d
                                  inner join auxiliares as a using(idorigenp,idproducto,idauxiliar)
                                  where      a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                                             a.idproducto = r_params.dato1::integer and periodo::integer = x_periodo_ah and cargoabono = 1 and
                                             (idorigenc,periodo,idtipo,idpoliza) in
                                               (select   idorigenc,periodo,idtipo,idpoliza
                                                from     polizas_d
                                                where    periodo::integer = x_periodo_ah and cargoabono = 0 and
                                                         sai_texto1_like_texto2(idcuenta,NULL,r_params.dato3,'|') > 0
                                                group by idorigenc,periodo,idtipo,idpoliza)
                                  group by periodo), 0);

      x_mes   := '@@flujo_ah_mes_'||x_cont::text||'@@';
      x_monto := '@@flujo_ah_monto_'||x_cont::text||'@@';
      x_formato := replace(x_formato,x_mes,   sai_formato_analisis_credito_nombre_periodo (x_periodo_ah::text));
      x_formato := replace(x_formato,x_monto, case when x_periodo_ah is NULL then '' else trim(to_char(x_monto_abonos, '999,999,999.00')) end);

      x_suma_abonos := x_suma_abonos + x_monto_abonos;
    end loop;
    x_prom_flujo_ah :=  x_suma_abonos / 12;

    x_formato := replace(x_formato,'@@promedio_flujo_ah@@', trim(to_char(x_prom_flujo_ah, '999,999,999.00')));
raise notice '%', case when x_formato is NULL then 'e) x_formato is NULL' else '' end;
    -- Prestamos ------------------------------------------------------------------------------------
/*    
    select
    into     x_fechauma_pr fechauma
    from     (select   fechauma
              from     auxiliares as a
              where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                       idproducto between 30000 and 39999 and estatus in (2,3)
              union    
              select   fechauma
              from     auxiliares_h as a
              where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                       idproducto between 30000 and 39999 and estatus = 3) as z
    order by fechauma desc
    limit    1;
*/
    x_cont := 0;  x_suma_abonos := 0;  x_monto_abonos := 0.00;  x_max_dv := 0; x_periodo_pr := NULL;
    x_ab_reales := 0;
    for x_cont in reverse 12..1
    loop
  --    if x_fechauma_pr is not NULL then
  --      x_periodo_pr := trim(to_char(date(x_fechauma_pr - ((x_cont-1)::text||' month')::interval),'yyyymm'))::integer;
         x_periodo_pr := trim(to_char(date(x_fecha_hoy - ((x_cont-1)::text||' month')::interval),'yyyymm'))::integer;

        select
        into     x_monto_abonos, x_max_dv
                 coalesce(sum(abonos),0), coalesce(max(max_dv),0)
        from     (select   coalesce(sum(monto+montoio+montoiva+montoim+montoivaim),0) as abonos, max(diasvencidos) as max_dv, 1 as dif
                  from     auxiliares_d
                           inner join auxiliares as a using(idorigenp,idproducto,idauxiliar)
                  where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                           periodo::integer = x_periodo_pr and idtipo = 1 and idproducto between 30000 and 39999 and cargoabono = 1
                  UNION
                  select   coalesce(sum(monto+montoio+montoiva+montoim+montoivaim),0) as abonos, max(diasvencidos) as max_dv, 11 as dif
                  from     auxiliares_d_h
                           inner join auxiliares_h as a using(idorigenp,idproducto,idauxiliar)
                  where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                           periodo::integer = x_periodo_pr and idtipo = 1 and idproducto between 30000 and 39999 and cargoabono = 1
                  UNION
                  select   coalesce(sum(monto+montoio+montoiva+montoim+montoivaim),0) as abonos, max(diasvencidos) as max_dv, 2 as dif
                  from     auxiliares_d
                           inner join auxiliares as a using(idorigenp,idproducto,idauxiliar)
                  where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                           periodo::integer = x_periodo_pr and idproducto between 30000 and 39999 and cargoabono = 1 and
                           (idorigenc,periodo,idtipo,idpoliza) in
                             (select   idorigenc,periodo,idtipo,idpoliza
                              from     polizas_d
                              where    periodo::integer = x_periodo_pr and cargoabono = 0 and
                                       sai_texto1_like_texto2(idcuenta,NULL,r_params.dato3,'|') > 0
                              group by idorigenc,periodo,idtipo,idpoliza)
                  UNION
                  select   coalesce(sum(monto+montoio+montoiva+montoim+montoivaim),0) as abonos, max(diasvencidos) as max_dv, 22 as dif
                  from     auxiliares_d_h
                           inner join auxiliares_h as a using(idorigenp,idproducto,idauxiliar)
                  where    a.idorigen = r_aux.idorigen and a.idgrupo = r_aux.idgrupo and a.idsocio = r_aux.idsocio and
                           periodo::integer = x_periodo_pr and idproducto between 30000 and 39999 and cargoabono = 1 and
                           (idorigenc,periodo,idtipo,idpoliza) in
                             (select   idorigenc,periodo,idtipo,idpoliza
                              from     polizas_d
                              where    periodo::integer = x_periodo_pr and cargoabono = 0 and
                                       sai_texto1_like_texto2(idcuenta,NULL,r_params.dato3,'|') > 0
                              group by idorigenc,periodo,idtipo,idpoliza)) as z;

--      end if; -- if x_fechauma_pr is not NULL then

      if x_monto_abonos > 0 then
        x_ab_reales := x_ab_reales + 1;      
      end if;
      
      x_mes   := '@@flujo_pr_mes_'||x_cont::text||'@@';
      x_monto := '@@flujo_pr_monto_'||x_cont::text||'@@';
      x_formato := replace(x_formato,x_mes,   sai_formato_analisis_credito_nombre_periodo (x_periodo_pr::text));
      x_formato := replace(x_formato,x_monto, case when x_periodo_pr is NULL then '' else trim(to_char(x_monto_abonos, '999,999,999.00')) end);
     
      x_suma_abonos := x_suma_abonos + x_monto_abonos;
    end loop;

    x_prom_flujo_pr :=  0.00;
    if x_ab_reales > 0 then
      x_prom_flujo_pr :=  x_suma_abonos / x_ab_reales; --** Abonos reales --12;
    end if;

raise notice '%', case when x_formato is NULL then 'f) x_formato is NULL' else '' end;

    x_formato := replace(x_formato,'@@promedio_flujo_pr@@', trim(to_char(x_prom_flujo_pr, '999,999,999.00')));
    
    x_suma_prom_flujos_pr_ah := x_prom_flujo_pr + x_prom_flujo_ah;
    
    x_formato := replace(x_formato,'@@dif_promedio_flujos_pr_ah@@', trim(to_char(x_suma_prom_flujos_pr_ah, '999,999,999.00')));
  
  end if;


raise notice '%', case when x_formato is NULL then 'g) x_formato is NULL' else '' end;
  if p_formato = 'formato_analisis_credito_a' then
/*  
    select
    into     r_tra *
    from     trabajo
    where    idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio and ing_mensual_neto > 0
    order by consecutivo desc
    limit    1;

    select
    into     r_sec *
    from     socioeconomicos
    where    idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio;
*/    
    select
    into   r_cod *
    from   notas
    where  idnota like 'C|'||trim(to_char(p_idorigenp,'099999'))||'|'||trim(to_char(p_idproducto,'09999'))||'|'||trim(to_char(p_idauxiliar,'09999999'));
    if found then
      select 
      into     x_ing_men_neto_cod ing_mensual_neto
      from     trabajo
      where    idorigen = split_part(r_cod.descripcion,'|',1)::integer and
               idgrupo  = split_part(r_cod.descripcion,'|',2)::integer and
               idsocio  = split_part(r_cod.descripcion,'|',3)::integer and
               ing_mensual_neto > 0
      order by consecutivo desc
      limit    1;

      SELECT into x_cod_gasto1, x_cod_gasto2, x_cod_gasto3, x_cod_gasto4, x_cod_gasto5, x_cod_gasto6
                  gastos_tipo1, gastos_tipo2, gastos_tipo3, gastos_tipo4, gastos_tipo5, gastos_tipo6
        FROM socioeconomicos 
       WHERE idorigen = split_part(r_cod.descripcion,'|',1)::integer 
         and idgrupo  = split_part(r_cod.descripcion,'|',2)::integer 
         and idsocio  = split_part(r_cod.descripcion,'|',3)::integer;

    end if;
    
    -- Ingresos: --------
    x_formato := replace(x_formato,'@@ing_men_sueldo_neto@@',      trim(to_char(coalesce(r_sec.ingresosordinarios,0),       '999,999,990.00')));
    x_formato := replace(x_formato,'@@ing_men_otro_empleo@@',      trim(to_char(coalesce(r_sec.ingresosextraordinarios,0),  '999,999,990.00')));
    x_formato := replace(x_formato,'@@ing_men_ingreso_familiar@@', trim(to_char(coalesce(x_ing_men_neto_cod,0),             '999,999,990.00')));
    x_suma_ingresos := coalesce(r_sec.ingresosordinarios,0) + coalesce(r_sec.ingresosextraordinarios,0) + coalesce(x_ing_men_neto_cod,0);
    x_formato := replace(x_formato,'@@suma_ingresos@@',            trim(to_char(coalesce(x_suma_ingresos,0),    '999,999,990.00')));

    -- Gastos: ----------
    x_formato := replace(x_formato,'@@gto_men_alimentos@@',        trim(to_char(coalesce(r_sec.gastos_tipo1,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_servicios@@',        trim(to_char(coalesce(r_sec.gastos_tipo2,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_transporte@@',       trim(to_char(coalesce(r_sec.gastos_tipo3,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_escolares@@',        trim(to_char(coalesce(r_sec.gastos_tipo4,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_vivienda@@',         trim(to_char(coalesce(r_sec.gastos_tipo5,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_otros@@',            trim(to_char(coalesce(r_sec.gastos_tipo6,0), '999,999,990.00')));

    -- Gastos codeudor: ----------
    x_formato := replace(x_formato,'@@gto_men_alimentos_cod@@',        trim(to_char(coalesce(x_cod_gasto1,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_servicios_cod@@',        trim(to_char(coalesce(x_cod_gasto2,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_transporte_cod@@',       trim(to_char(coalesce(x_cod_gasto3,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_escolares_cod@@',        trim(to_char(coalesce(x_cod_gasto4,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_vivienda_cod@@',         trim(to_char(coalesce(x_cod_gasto5,0), '999,999,990.00')));
    x_formato := replace(x_formato,'@@gto_men_otros_cod@@',            trim(to_char(coalesce(x_cod_gasto6,0), '999,999,990.00')));   
    
    x_suma_gastos := coalesce(r_sec.gastos_tipo1,0) + coalesce(r_sec.gastos_tipo2,0) + coalesce(r_sec.gastos_tipo3,0) + coalesce(r_sec.gastos_tipo4,0) +
                     coalesce(r_sec.gastos_tipo5,0) + coalesce(r_sec.gastos_tipo6,0) + coalesce(x_cod_gasto1,0) + coalesce(x_cod_gasto2,0) +
                     coalesce(x_cod_gasto3,0) + coalesce(x_cod_gasto4,0) + coalesce(x_cod_gasto5,0) + coalesce(x_cod_gasto6,0);
    x_formato := replace(x_formato,'@@suma_gastos@@',              trim(to_char(coalesce(x_suma_gastos,0),      '999,999,990.00')));
    
  end if;
  
raise notice '%', case when x_formato is NULL then 'h) x_formato is NULL' else '' end;
  x_formato := replace(x_formato,'@@morosidad_gt_30@@', case when x_max_dv > 0 then 'SI' else 'NO' end);
raise notice '%', case when x_formato is NULL then 'i) x_formato is NULL' else '' end;  
  select
  into   r_usr *
  from   usuarios
  where  sai_texto1_like_texto2 (text(pg_backend_pid()),NULL, sai_lista_procpids_conectados(idusuario),',') > 0;
  
  x_formato := replace(x_formato,'@@elaboro@@', coalesce(r_usr.nombre,' '));
raise notice '%', case when x_formato is NULL then 'j) x_formato is NULL' else '' end;
  return x_formato;
end;
$$ language 'plpgsql';
