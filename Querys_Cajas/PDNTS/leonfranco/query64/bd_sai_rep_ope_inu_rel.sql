-- DROP FUNCTION public.sai_reporte_operacion_relevante_inusual_preocupante(int4, int4, int4, varchar);

CREATE OR REPLACE FUNCTION public.sai_reporte_operacion_relevante_inusual_preocupante(integer, integer, integer, character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

declare
  p_periodo_ini     alias for $1;
  p_periodo_fin     alias for $2;
  p_tipo_op         alias for $3;
  p_clave_ent_fin   alias for $4;
  --x_fecha_ini     date;
  x_fecha_fin       date;
  x_command         text;
  r_paso            record;
  ES_NVO_MEX        integer;
  x_cve_sujeto      text;
  b_iserr           boolean;
  b_reportar_libre  boolean;
  i_cont            integer;
begin
  
  select
  into   ES_NVO_MEX
         case when idorigen in (10100,20700) then 1 else 0 end
  from   origenes
  where  matriz = 0
  limit  1;
  
  --x_fecha_ini := ('01/'||substr(p_periodo_ini::text,5,2)||'/'||substr(p_periodo_ini::text,1,4))::date;
  --x_fecha_fin := sai_ult_dia_del_mes(x_fecha_ini);
  x_fecha_fin := sai_ult_dia_del_mes(('01/'||substr(p_periodo_fin::text,5,2)||'/'||substr(p_periodo_fin::text,1,4))::date);

  select
  into   r_paso *
  from   tablas
  where  idtabla = 'param' and idelemento = 'reportes_regulatorios';
  if not found then
    raise exception 'ERROR: NO EXISTE TABLA: param / reportes_regulatorios';
  end if;
  
  if r_paso.dato3 is not null and sai_findstr(r_paso.dato3,'|') = 0 and not es_numero(r_paso.dato3) then
    raise exception 'ERROR: EL PARAMETRO 3 DE LA TABLA: param / reportes_regulatorios NO ESTA CORRECTAMENTE DEFINIDO.\n'
                    'DEBE SER UNA LISTA DE IDGRUPOS ACEPTABLES, DELIMITADOS POR PIPAS. (EJ.: 10|20|30...).\n'
                    'SI NO REQUIERE DE UNA LISTA, DEJE EL PARAMETRO 3 VACIO';
  end if;

  if r_paso.dato2 is not null and r_paso.dato2 != '' then
    x_cve_sujeto := trim(to_char(r_paso.dato2::integer,'099999'));
  else
    if p_clave_ent_fin is not NULL then
      x_cve_sujeto := trim(to_char(p_clave_ent_fin::integer,'099999'));
    else
      raise exception 'ERROR: EL PARAMETRO 2 DE LA TABLA: param / reportes_regulatorios, NO ESTA DEFINIDA LA CLAVE '
                      'DE LA ENTIDAD FINANCIERA.';
    end if;
  end if;

  b_iserr := FALSE;
  b_reportar_libre := FALSE;
  if r_paso.dato4 is not null and r_paso.dato4 != '' then
    b_iserr := not (sai_findstr(r_paso.dato4,'|') between 0 and 2) or not es_numero(replace(r_paso.dato4,'|',''));
    if not b_iserr then
      for i_cont in 1..sai_findstr(r_paso.dato4,'|')+1
      loop
        b_iserr := split_part(r_paso.dato4,'|',i_cont)::integer not in (1,2,3);
        exit when b_iserr;
        b_reportar_libre := (p_tipo_op = split_part(r_paso.dato4,'|',i_cont)::integer);
        exit when b_reportar_libre;
      end loop;
    end if;
    if b_iserr then
      raise exception 'ERROR: EL PARAMETRO 4 DE LA TABLA: param / reportes_regulatorios, ESTA MAL CONFIGURADO. USE '
                      'OPCIONALMENTE DEL 1 AL 3 SEPARADOS CON PIPAS, O SI SOLO ES UN NUMERO, NO USE LA PIPA.';
    end if;
  end if;
raise notice 'b_reportar_libre: %', b_reportar_libre;
  x_command :=
  'copy (
        with t_op
          as (values('||p_tipo_op||'))
        select (select * from t_op) as "TIPO DE REPORTE", ----------------------------------------- 01
               case when (select * from t_op) = 1
                    then '''||p_periodo_fin::text||'''
                    else trim(to_char(sai_ult_dia_del_mes(i.fecha),''yyyymmdd''))
               end as "PERIODO DEL REPORTE", ------------------------------------------------------ 02
               trim(to_char(row_number() over(order by i.fecha),''099999'')) as "FOLIO", ---------- 03
               ''001002'' as "ORGANO SUPERVISOR", ------------------------------------------------- 04
               '''||x_cve_sujeto||''' as "CLAVE DEL SUJETO", -------------------------------------- 05

               case when '||ES_NVO_MEX||' = 1
                    then (select trim(to_char(mu.localidad_siti,''09999999''))
                          from   origenes ori
                          inner  join municipios mu using (idmunicipio)
                          where  ori.idorigen = i.sucursal) -------------------------------------- (06 NVO_MEX)
                    else o.codigopostal::varchar
               end as "LOCALIDAD", ---------------------------------------------------------------- 06

               case when '||ES_NVO_MEX||' = 1
                    then sucursal ---------------------------------------------------------------- (07 NVO_MEX)
                    else substr(sucursal::text,4,2)::integer
               end as "SUCURSAL", ----------------------------------------------------------------- 07

               ''01'' as "TIPO DE OPERACION", ----------------------------------------------------- 08

               case when '||ES_NVO_MEX||' = 1
                    then sai_reporte_operacion_rip_procesa_instmonetario_nvomex (i.idorigen,i.idgrupo,i.idsocio,
                           i.fecha_real,i.monto) ------------------------------------------------- (09 NVO_MEX)
                    else ''01''
               end as "INSTRUMENTO MONETARIO", ---------------------------------------------------- 09

               trim(to_char(p.idorigen,''099999''))||''-''||
                            p.idgrupo::text||''-''||trim(to_char(
                            p.idsocio,''099999'')) as "NUMERO CUENTA", ---------------------------- 10

               case when '||ES_NVO_MEX||' = 1 and '||p_tipo_op||' in (2,3)
                    then sai_reporte_operacion_rip_procesa_monto_nvomex(p.idorigen,p.idgrupo,p.idsocio,'''||
                           p_periodo_ini::text||''','''||p_periodo_fin::text||''','''||p_tipo_op::text||''') ------- (11 NVO_MEX)
                    else i.monto
               end as "MONTO", -------------------------------------------------------------------- 11
               ''1'' as "MONEDA", ----------------------------------------------------------------- 12
               trim(to_char(i.fecha,''yyyymmdd'')) as "FECHA DE LA OPERACION", -------------------- 13
               (case when reporte = ''R'' then ''''
                  else trim(to_char(i.fecha,''yyyymmdd'')) end) as "FECHA DE LA DETECCION", ------- 14

               case when '||ES_NVO_MEX||' = 1
                    then ''MX'' ------------------------------------------------------------------ (15 NVO_MEX)
                    else case when p.nacionalidad not in (0,1)
                              then ''2''  -- Nac: 0 Desconocido, 1: Mexicano, 2: Extranjero
                              else p.nacionalidad::varchar
                         end
               end as "NACIONALIDAD", ------------------------------------------------------------- 15
               (case when p.razon_social is not null and p.razon_social <> '''' 
                          then ''2'' 
                else ''1'' end) as "TIPO DE PERSONA", --------------------------------------------- 16
               p.razon_social as "RAZON SOCIAL", -------------------------------------------------- 17
               p.nombre as "NOMBRE", -------------------------------------------------------------- 18
               coalesce (p.appaterno, ''xxxx'') as "APELLIDO PATERNO", ---------------------------- 19
               coalesce (p.apmaterno, ''xxxx'') as "APELLIDO MATERNO", ---------------------------- 20
               p.rfc as "RFC", -------------------------------------------------------------------- 21
               p.curp as "CURP", ------------------------------------------------------------------ 22
               trim(to_char(p.fechanacimiento,''yyyymmdd'')) as "FECHA DE NACIMIENTO", ------------ 23
               p.calle||'' ''||
                 case when p.numeroext is not null and p.numeroext != ''''
                      then p.numeroext
                      else ''''
                 end||
                 case when p.numeroint is not null and p.numeroint != ''''
                      then '' ''||p.numeroint
                      else ''''
                 end||'' ''||c.codigopostal as "DOMICILIO", --------------------------------------- 24 (NVO_MEX, SOLO SE QUITO LA COMA)
               upper(
                     substr(
                            trim(
                                 replace(
                                         replace(
                                                 replace(
                                                         replace(
                                                                 reemplaza_letras(c.nombre)
                                                                 ,'','','''')
                                                         ,''-'','''')
                                                 ,''('','''')
                                         ,'')'','''')
                                 )
                            ,1,30)
                     ) as "COLONIA", -------------------------------------------------------------- 25
               case when '||ES_NVO_MEX||' = 1
                    then trim(to_char(m.localidad_siti,''09999999'')) ---------------------------- (26 NVO_MEX)
                    else o.codigopostal::varchar
               end as "CIUDAD", ------------------------------------------------------------------- 26
               (case when p.telefono is not null 
                      and p.telefonorecados is not null 
                      and p.telefono <> '''' 
                      and p.telefonorecados <> ''''
                          then trim(p.telefono)||''/''||trim(p.telefonorecados)
                     when p.telefono is not null and p.telefono <> ''''
                          then trim(p.telefono)
                     when p.telefonorecados is not null and p.telefonorecados <> ''''
                          then trim(p.telefonorecados)
                   else ''''
                end) as "TELEFONO", --------------------------------------------------------------- 27
               (select   actividad_economica_pld
                from     trabajo
                where    idorigen = p.idorigen and idgrupo = p.idgrupo and 
                         idsocio = p.idsocio and (actividad_economica_pld is not null or 
                         actividad_economica_pld != '''')
                order by consecutivo desc
                limit    1) as "ACTIVIDAD ECONOMICA", --------------------------------------------- 28
               '''' as "NOMBRE AGENTE APODERADO DE SEGUROS", -------------------------------------- 29
               '''' as "APELLIDO PATERNO (AAS)", -------------------------------------------------- 30
               '''' as "APELLIDO MATERNO (AAS)", -------------------------------------------------- 31
               '''' as "RFC (AAS)", --------------------------------------------------------------- 32
               '''' as "CURP (AAS)", -------------------------------------------------------------- 33
               '''' as "CONSECUTVO DE CUENTAS Y/O PERSONAS RELACIONADAS", ------------------------- 34
               '''' as "NUMERO DE CUENTA (PR)", --------------------------------------------------- 35
               '''' as "CLAVE SUJETO (PR)", ------------------------------------------------------- 36
               '''' as "NOMBRE TITULAR (PR)", ----------------------------------------------------- 37
               '''' as "APELLIDO PATERNO (PR)", --------------------------------------------------- 38
               '''' as "APELLIDO MATERNO (PR)", --------------------------------------------------- 39


               case when '||ES_NVO_MEX||' = 1
                    then sai_reporte_operacion_rip_procesa_observaciones_nvomex (i.validacion,1)-- (40 NVO_MEX)
                    else sai_reporte_operacion_rip_procesa_observaciones (i.observaciones)
               end as "DESCRIPCION DE LA OPERACION", ---------------------------------------------- 40


               case when '||ES_NVO_MEX||' = 1
                    then sai_reporte_operacion_rip_procesa_observaciones_nvomex (i.validacion,2)-- (41 NVO_MEX)
                    else sai_reporte_operacion_rip_procesa_observaciones (i.validacion)
               end as "RAZONES", ------------------------------------------------------------------ 41

               '''' as ";" ------------------------------------------------------------------------ 42
        from   notas_relevantes_inusuales as i
                 inner join personas      as p  using(idorigen,idgrupo,idsocio)
                 inner join colonias      as c  using(idcolonia)
                 inner join municipios    as m  using(idmunicipio)
                 inner join estados       as e  using(idestado)
                 inner join origenes      as o  on(o.idorigen = i.sucursal)
        where  TRIM(TO_CHAR(fecha,''yyyymm'')) between ('''||p_periodo_ini||''') and ('''||p_periodo_fin::text||''') and
               (((select * from t_op) = 1 and reporte = ''R'') or
                ((select * from t_op) = 2 and reporte = ''I'') or
                ((select * from t_op) = 3 and reporte = ''P'')) '||
               case when b_reportar_libre
                    then ''
                    else ' and i.reportar '
               end||
               case when r_paso.dato3 is not NULL and trim(r_paso.dato3) != ''
                    then ' and p.idgrupo in (select regexp_split_to_table('''||r_paso.dato3::text||''', ''\\\\|'')::integer)'
                    else ''
               end||'
        order by "FECHA DE LA OPERACION"
       ) to ''/tmp/'||p_tipo_op::text||x_cve_sujeto||
            case when p_tipo_op = 1
                 then substr(p_periodo_fin::text,3,4)
                 else trim(to_char(x_fecha_fin,'yymmdd'))
            end||'.'||'002'||''' delimiter '';'' ';

--raise notice 'x_command: %', x_command;
  execute x_command;

  return 1;
end;

$function$
;
