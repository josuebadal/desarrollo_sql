-----------------------------------------------------------
--                    INCIO FUNCION CUESTIONARIO A2
-----------------------------------------------------------
drop type if exists numero_clientes_usuarios_operaron_periodo cascade;
create type numero_clientes_usuarios_operaron_periodo as (
  anio                                                    integer,
  clave_formulario                                        text,
  clave_entidad                                           integer,
  producto_servicio                                       integer,
  tipo_cliente_usuario                                    varchar,      
  clasificacion_grado_riesgo                              integer,
  pais_nacionalidad                                       integer,
  pais_residencia                                         integer,
  entidad_federativa_residencia                           varchar,
  actividad_economica                                     integer,
  numero_clientes_usuarios                                integer
);                 
 



create or replace function cuestionario_a2 (integer,integer)
returns setof numero_clientes_usuarios_operaron_periodo as $$
declare
  clave_ent   alias for $1;
  perio       alias for $2;

  r numero_clientes_usuarios_operaron_periodo%rowtype;

  p_inicial     integer;
  p_final       integer;
  p_inicial_r   integer;
  p_final_r     integer;  
  r_prod        record;
  r_paso        record;
  rec           record;
  rec_2         record;
  r_paso_pro    record;
  y             integer;
  fecha         varchar;



begin

 ----TABLA FISICA PARA CONSULTAS CUESTIONARIO A2
DROP table IF EXISTS a2_cuestionario_operatividad;
CREATE temp table a2_cuestionario_operatividad(
 anio                                                   text,              
 clave_formulario                                       text,                
 clave_entidad                                          text,
 producto_servicio                                      text,
 tipo_cliente_usuario                                   text,
 clasificacion_grado_riesgo                             text, 
 pais_nacionalidad                                      text,    
 pais_residencia                                        text, 
 entidad_federativa_residencia                          text,                  
 actividad_economica                                    text,                  
 numero_clientes_usuarios                               text                              
 );
RAISE NOTICE 'Se creo a2_cuestionario_operatividad';

  p_inicial_r   :=(perio||'00')::integer;
  p_inicial     :=(perio||'01')::integer;
  p_final       :=(perio||'12')::integer;
  p_final_r     := p_inicial_r + 100;

  DROP table IF EXISTS copiar;
  CREATE temp table copiar(
      id    integer,
      fila  text);
  y:=0;
  insert into copiar values(y,'ANIO|CLAVE DE FORMULARIO|CLAVE DE LA ENTIDAD|TIPO DE PRODUCTO O SERVICIO|TIPO DE CLIENTE O USUARIO|CLASIFICACION POR GRADO DE RIESGO|PAIS DE NACIONALIDAD|PAIS DE RESIDENCIA|ENTIDAD FEDERATIVA DE RESIDENCIA|ACTIVIDAD ECONOMICA|NUMERO DE CLIENTES O  USUARIOS ACTIVOS AL CIERRE');
  y:=1;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- MODIFICACION PARA PODER BUSCAR DE MANERA GENERAL A LOS SOCIOS, USANDO UNA TABLA DE CONFIGURACION --------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- PARA DEFINIR LA BASE DE SOCIOS QUE DEBEN USARSE EN LOS CUESTIONARIOS, LO
-- NORMAL SERIA USAR LA PARTE SOCIAL PERO EN LAS CAJAS MANEJAN DIFERENTES MONTOS
-- Y PRODUCTOS PARA ESTO, SE USARA LA SIGUIENTE TABLA :

-- idtabla    = prod_base_cuestionario_op
-- idelemento = 1, 2,... n
-- parametro1 = idproducto
-- parametro2 = monto minimo de ese producto

-- EJEMPLO :
--insert into tablas values ('prod_base_cuestionario_op', '1', NULL, '101', '500.0', NULL, NULL, NULL, 0);
--insert into tablas values ('prod_base_cuestionario_op', '2', NULL, '120', '1.0', NULL, NULL, NULL, 0);

-- CON ESTA CONFIGURACION, SE BUSCARAN TODOS LOS SOCIOS QUE TENGAN ESTE PRODUCTO
-- Y QUE SU SALDO SEA MAYOR O IGUAL AL MONTO ESPECIFICADO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  drop table if exists tmp_act_y;
  create temp table tmp_act_y  (
    idorigen integer,
    idgrupo  integer,
    idsocio  integer,
    idcuestionario  integer
  );

  for rec_2 in
select regexp_split_to_table((trim(dato2)),',') as productos from tablas where lower(idtabla)='cuestionario_opera_cnbv' 
and idelemento in ('27','28','29') order by idelemento::integer 

  loop

    insert into tmp_act_y
      select distinct idorigen,idgrupo,idsocio,  27 as idcuestionario
      from servicios_d
      where idproducto = rec_2.productos::integer and periodo::integer >= p_inicial_r::integer  and periodo::integer < p_final_r::integer;

      
  end loop;



  drop table if exists tmp_act_x;
  create temp table tmp_act_x (
    idorigen integer,
    idgrupo  integer,
    idsocio  integer
  );
  create index tmp_act_x_pkey on tmp_act_x (idorigen,idgrupo,idsocio);

  for rec in
    select * from tablas where lower(idtabla) = 'prod_base_cuestionario_op'
    order by idelemento::integer
  loop

    insert into tmp_act_x
      select distinct idorigen,idgrupo,idsocio
      from auxiliares
      where idproducto = rec.dato1::integer and saldo >= rec.dato2::numeric;

      
  end loop;
/*
  CREATE TEMP TABLE TMP_ACT AS (
    SELECT idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar FROM auxiliares
    where (idgrupo = 10 and idproducto = 101 and saldo = 500.0) or
          (idgrupo = 20 and idproducto = 120 and saldo > 0));
*/

  drop table if exists tmp_act;
  create temp table tmp_act as
    select distinct idorigen,idgrupo,idsocio from tmp_act_x
    --Hay que hacer un UNION con las remesas (producto 615) para traer los usuarios que hicieron esos movimientos--
    UNION
        select distinct idorigen,idgrupo,idsocio from tmp_act_y;
   -- select distinct idorigen, idgrupo, idsocio from servicios_d where idproducto=615   and periodo::integer >= p_inicial_r::integer  and periodo::integer < p_final_r::integer ;
  create index tmp_act_pkey on tmp_act (idorigen, idgrupo, idsocio);

--  drop table if exists tmp_act_x;

  raise notice 'Se genero la tabla TMP_ACT';
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------
-- IGUAL QUE ANTES, NO LO MODIFIQUE, SOLO AGREGUE EL create index ---
---------------------------------------------------------------------
  drop table if exists temp_peps;
  create temp table temp_peps as
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from (select i.idorigen,i.idgrupo,i.idsocio,a.idorigenp,a.idproducto,a.idauxiliar
          from peps_qeq_identificado_web as i
               inner join peps_qeq_catalogo_web as c using (id_persona)
               inner join auxiliares as a using(idorigen,idgrupo,idsocio)
          where lista = 'PPE' and c.fecha_cargo_ini is not NULL and c.fecha_cargo_ini != ''
         UNION ALL
          select i.idorigen,i.idgrupo,i.idsocio, a.idorigenp, a.idproducto, a.idauxiliar
          from peps_qeq_identificado_web as i
               inner join peps_qeq_catalogo_web as c using (id_persona)
               inner join auxiliares as a using(idorigen,idgrupo,idsocio)
          where lista = 'PPE') as te;
  create index temp_peps_pkey on temp_peps (idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar);
raise notice 'Se genero la tabla temp_peps';

------------------------------------------------------------------------------------------------------------------------
-- MODIFICADO ----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

  drop table if exists tmp_act_peps;
  create temp table tmp_act_peps as (
    select idorigen,idgrupo,idsocio, 1 as peps  from tmp_act
    where (idorigen,idgrupo,idsocio) in (select idorigen,idgrupo,idsocio from temp_peps)
   union all
    select idorigen,idgrupo,idsocio, 0 as peps from tmp_act 
    where (idorigen,idgrupo,idsocio) not in (select idorigen,idgrupo,idsocio from temp_peps) 
  order by idorigen,idgrupo,idsocio
  );
  create index tmp_act_peps_pkey on tmp_act_peps (idorigen,idgrupo,idsocio);
/*
drop table if exists tmp_act_peps;
create temp table tmp_act_peps as (
select idorigen,idgrupo,idsocio , 1 as peps,idproducto  from tmp_act 
where (idorigen,idgrupo,idsocio) in (select idorigen,idgrupo,idsocio from temp_peps)
union all
select idorigen,idgrupo,idsocio , 0 as peps,idproducto  from tmp_act 
where (idorigen,idgrupo,idsocio) not in (select idorigen,idgrupo,idsocio from temp_peps) 
order by idorigen,idgrupo,idsocio
);
*/
raise notice 'Se genero la tabla tmp_act_peps';
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- CASI IGUAL QUE ANTES, SOLO MODIFIQUE LO SIGUIENTE
-- 1) AGREGUE EL create index
-- 2) ACOMODE LAS LINEAS
---------------------------------------------------------------------
  drop table if exists temp_productos;
  create temp table temp_productos (idcuestionario integer, idproducto integer);
  create index temp_productos_pkey on temp_productos (idcuestionario, idproducto);
  FOR rec in
    select * from tablas where  idtabla = 'cuestionario_opera_cnbv'
    order by idelemento::integer
  loop

    FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
    loop
      if (r_paso_pro.idprodu <> '') then
        insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
      end if;
    end loop;

  end loop;


---------------------------------------------------------------------
-- CASI IGUAL QUE ANTES, SOLO MODIFIQUE LO SIGUIENTE
-- 1) AGREGUE EL create index
-- 2) ACOMODE LAS LINEAS
-- 3) EN EL idtipo LE PUSE (1,2,3)
---------------------------------------------------------------------

  drop table if exists temp_auxi;
  create temp table temp_auxi as (select  * /*idcuestionario*/
                                  from (select a.idorigen, a.idgrupo, a.idsocio, te.idcuestionario, a.idproducto, ta.peps
                                        from auxiliares a 
                                             inner join temp_productos te using (idproducto)
                                             inner join tmp_act_peps ta using (idorigen, idgrupo, idsocio)
                                        where a.estatus=2) as f 
                                  group by idorigen, idgrupo, idsocio, idcuestionario, idproducto, peps);
  create index temp_auxi_pkey on temp_auxi (idorigen, idgrupo, idsocio, idcuestionario, idproducto, peps);
  raise notice 'Se genero la tabla temp_auxi';

  drop table if exists temp_pfae;
  create local temp table temp_pfae as
    select distinct idorigen, idgrupo, idsocio
    from negociopropio where act_empresarial;
  create index temp_pfae_pkey on temp_pfae (idorigen, idgrupo, idsocio);
  raise notice 'Se genero la tabla temp_pfae';


----------------------------------------------------------------------------
--TABLA TEMPORAL DE REMESAS PARA LOS PRODUCTOS DE ORDENES DE PAGO NACIONALES
----------------------------------------------------------------------------
drop table if exists temp_remesas;
create temp table temp_remesas as 
                                    select idorigen, idgrupo, idsocio, idcuestionario, peps
                                      from (
                                        select * from tmp_act_y
                                        --select distinct idorigen, idgrupo, idsocio, 27 as idcuestionario from servicios_d where idproducto=615 and periodo::integer >= p_inicial_r::integer  and periodo::integer <p_final_r::integer  
                                        ) rm
                                      left join tmp_act_peps ta using (idorigen, idgrupo, idsocio)
;
------------


/*
drop table if exists temp_auxi2;
create temp table temp_auxi2 as (
        select sd.idorigen,sd.idgrupo,sd.idsocio,te.idcuestionario, sd.peps, sd.idproducto
        from tmp_act_peps sd 
        left join temp_productos te using (idproducto)
            where (idorigen,idgrupo,idsocio) not in (select idorigen,idgrupo,idsocio from temp_auxi)
        UNION all
        select idorigen, idgrupo, idsocio, idcuestionario, peps, idproducto from temp_auxi
);
*/

/*INICIA QUERY PARA LA OBTENCION DE DATOS, LOS DATOS 1-2 SE LLENAN AL EJECUTAR LA FUNCIO
EL DATO 3 ES FIJO POR LA CLAVE DEL REPORTE*/
  for r_prod in
    select * from tablas
    where idtabla = 'cuestionario_opera_cnbv'
    order by idelemento::integer
  loop
    raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

    for r_paso in
      select *
      from (select count(*) as num_cli, tipoc, nries,nacion ,entidad_federativa_residencia,actividad_economica
            from (select /* (case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
                               when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
                               when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 3
                               when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
                               when (select count(*) from temp_pfae
                                     where idorigen = p.idorigen and idgrupo = p.idgrupo and
                                           idsocio = p.idsocio) > 0 then 5
                               when a.peps = 1 then 15
                          end) tipoc,*/
                         (case when a.peps = 1 then 15
                               else (case when (select count(*) from temp_pfae
                                                where idorigen = p.idorigen and idgrupo = p.idgrupo and
                                                      idsocio = p.idsocio) > 0 then 5
                                          else (case when p.nacionalidad != 3 and
                                                          (p.razon_social is NULL or p.razon_social = '') then 1
                                                     when p.nacionalidad != 3 and
                                                          (p.razon_social is not NULL and p.razon_social != '')then 2
                                                     when p.nacionalidad  = 3 and
                                                          (p.razon_social is NULL or p.razon_social = '') then 3
                                                     when p.nacionalidad  = 3 and
                                                          (p.razon_social is not NULL and p.razon_social != '') then 4
                                                end)
                                     end)
                          end) as tipoc, -----DATO 5
                          (case
                            --when a.peps = 1 then 15/*es pep*/ 
                            when p.nivel_riesgo = 1 then 1
                            when p.nivel_riesgo = 2 then 5
                            --when p.nivel_riesgo = 3 then 5
                            else 1
                       end) nries,        -----DATO 6
                       (case when p.pais_nacimiento=2 and p.nacionalidad  = 3 then  '3'--afganistan
					                   when p.pais_nacimiento=1  and p.nacionalidad  = 3 then  '157'--México
					                   when p.pais_nacimiento=61  and p.nacionalidad  = 3 then  '67'--EUA
					                   when p.pais_nacimiento=70  and p.nacionalidad  = 3 then  '76'--Georgia
					              else  '157' end) as nacion, ----------DATO 7
        
                   (CASE 
                        WHEN e.idestado = '7' THEN '5'
                        ELSE '7'
                        END ) as entidad_federativa_residencia, ----------DATO 9
                   tr.actividad_economica_pld as actividad_economica ----------DATO 10     
                  from temp_auxi a 
                        inner join personas p ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
-----SE AGREGARON JOINS PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS 
                        inner join colonias c on(c.idcolonia=p.idcolonia) 
                        inner join municipios m on(m.idmunicipio=c.idmunicipio) 
                        inner join estados e on(e.idestado=m.idestado)
                        inner join paises pa on(pa.idpais=e.idpais)
                        left join trabajo tr on a.idorigen = tr.idorigen and a.idgrupo = tr.idgrupo and a.idsocio = tr.idsocio AND tr.consecutivo = 1
                  where a.idcuestionario = r_prod.idelemento::integer
                   
                  -- hay que hacer un UNION con la tabla temps_act_peps y de ahi sacar los datos de los usuarios en remesas

                  UNION all

                  select 
                       (case when a.peps = 1 then 15
                             else (case when (select count(*) from temp_pfae
                                              where idorigen = p.idorigen and idgrupo = p.idgrupo and
                                                    idsocio = p.idsocio) > 0 then 5
                                        else (case when p.nacionalidad != 3 and
                                                        (p.razon_social is NULL or p.razon_social = '') then 1
                                                   when p.nacionalidad != 3 and
                                                        (p.razon_social is not NULL and p.razon_social != '')then 2
                                                   when p.nacionalidad  = 3 and
                                                        (p.razon_social is NULL or p.razon_social = '') then 3
                                                   when p.nacionalidad  = 3 and
                                                        (p.razon_social is not NULL and p.razon_social != '') then 4
                                              end)
                                   end)
                        end) as tipoc,      -----DATO 5
                        (case
                          --when a.peps = 1 then 15/*es pep*/ 
                          when p.nivel_riesgo = 1 then 1
                          when p.nivel_riesgo = 2 then 5
                          --when p.nivel_riesgo = 3 then 5
                          else 1
                     end) nries,             -----DATO 6
                     (case when p.pais_nacimiento=2 and p.nacionalidad  = 3 then  '3'--afganistan
					                   when p.pais_nacimiento=1  and p.nacionalidad  = 3 then  '157'--México
					                   when p.pais_nacimiento=61  and p.nacionalidad  = 3 then  '67'--EUA
					                   when p.pais_nacimiento=70  and p.nacionalidad  = 3 then  '76'--Georgia
					              else  '157' end) as nacion, ----------DATO 7
        
                   (CASE 
                        WHEN e.idestado = '7' THEN '5'
                        ELSE '7'
                        END ) as entidad_federativa_residencia, ----------DATO 9
                 tr.actividad_economica_pld as actividad_economica ----------DATO 10     
                from temp_remesas a 
                      inner join personas p ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
-----SE AGREGARON JOINS PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS 
                      inner join colonias c on(c.idcolonia=p.idcolonia) 
                      inner join municipios m on(m.idmunicipio=c.idmunicipio) 
                      inner join estados e on(e.idestado=m.idestado)
                      inner join paises pa on(pa.idpais=e.idpais)
                      left join trabajo tr on a.idorigen = tr.idorigen and a.idgrupo = tr.idgrupo and a.idsocio = tr.idsocio AND tr.consecutivo = 1
                where a.idcuestionario = r_prod.idelemento::integer   

                   ) x 
            group by tipoc,nries,nacion,entidad_federativa_residencia,actividad_economica
            order by tipoc) aa
    loop

      r.anio                              := perio;
      r.clave_formulario                  := 'A2';
      r.clave_entidad                     := clave_ent;
      r.producto_servicio                 := r_prod.idelemento;
      r.tipo_cliente_usuario              := r_paso.tipoc;
      r.clasificacion_grado_riesgo        := r_paso.nries;
      r.pais_nacionalidad                 :=r_paso.nacion;
      r.pais_residencia                   :=157;
      r.entidad_federativa_residencia     :=r_paso.entidad_federativa_residencia;
      r.actividad_economica               := CASE WHEN r_paso.actividad_economica IS NULL OR
                                                       r_paso.actividad_economica = ''
                                                  THEN '00000000'
                                                  ELSE r_paso.actividad_economica
                                              END;
      r.numero_clientes_usuarios          := r_paso.num_cli;

INSERT INTO  a2_cuestionario_operatividad  VALUES (
 r.anio,              
 r.clave_formulario,                
 r.clave_entidad,
 r.producto_servicio,
 r.tipo_cliente_usuario,
 r.clasificacion_grado_riesgo, 
 r.pais_nacionalidad,  
 r.pais_residencia, 
 r.entidad_federativa_residencia,                 
 r.actividad_economica,                  
 r.numero_clientes_usuarios
 );


      return next r;

      insert into copiar values(y,
          coalesce(r.anio                             ::text,'')||'|'||
          coalesce(r.clave_formulario                 ::text,'')||'|'||
          coalesce(r.clave_entidad                    ::text,'')||'|'||
          coalesce(r.producto_servicio                ::text,'')||'|'||
          coalesce(r.tipo_cliente_usuario             ::text,'')||'|'||
          coalesce(r.clasificacion_grado_riesgo       ::text,'')||'|'||
          coalesce(r.pais_nacionalidad                ::text,'')||'|'||
          coalesce(r.pais_residencia                  ::text,'')||'|'||
          coalesce(r.entidad_federativa_residencia    ::text,'')||'|'||
          coalesce(r.actividad_economica              ::text,'')||'|'||
          coalesce(r.numero_clientes_usuarios         ::text,''));

    end loop;

    select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
    execute 'copy (select fila from copiar order by id) to ''/tmp/formularioA2_con_encabezados_'||fecha||'.csv''';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/formularioA2_sin_encabezados_'||fecha||'.csv''';

  end loop;

  return;

end;
$$ language 'plpgsql';
-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO A2
-----------------------------------------------------------