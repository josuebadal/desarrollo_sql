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
  entidad_federativa_residencia                           integer,
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
                            when p.nivel_riesgo = 3 then 3
                            else 1
                       end) nries,        -----DATO 6
                       (case 
                  when p.pais_nacimiento= 2   and p.nacionalidad  = 3 then  '3'
                  when p.pais_nacimiento= 3   and p.nacionalidad  = 3 then  '4'
                  when p.pais_nacimiento= 4   and p.nacionalidad  = 3 then  '5'
                  when p.pais_nacimiento= 5   and p.nacionalidad  = 3 then  '6'
                  when p.pais_nacimiento= 6   and p.nacionalidad  = 3 then  '7'
                  when p.pais_nacimiento= 7   and p.nacionalidad  = 3 then  '10'
                  when p.pais_nacimiento= 8   and p.nacionalidad  = 3 then  '12'
                  when p.pais_nacimiento= 9   and p.nacionalidad  = 3 then  '13'
                  when p.pais_nacimiento= 10  and p.nacionalidad  = 3 then  '14'
                  when p.pais_nacimiento= 11  and p.nacionalidad  = 3 then  '15'
                  when p.pais_nacimiento= 12  and p.nacionalidad  = 3 then  '17'
                  when p.pais_nacimiento= 13  and p.nacionalidad  = 3 then  '18'
                  when p.pais_nacimiento= 14  and p.nacionalidad  = 3 then  '19'
                  when p.pais_nacimiento= 15  and p.nacionalidad  = 3 then  '20'
                  when p.pais_nacimiento= 16  and p.nacionalidad  = 3 then  '22'
                  when p.pais_nacimiento= 17  and p.nacionalidad  = 3 then  '23'
                  when p.pais_nacimiento= 18  and p.nacionalidad  = 3 then  '21'
                  when p.pais_nacimiento= 19  and p.nacionalidad  = 3 then  '24'
                  when p.pais_nacimiento= 20  and p.nacionalidad  = 3 then  '25'
                  when p.pais_nacimiento= 21  and p.nacionalidad  = 3 then  '26'
                  when p.pais_nacimiento= 22  and p.nacionalidad  = 3 then  '28'
                  when p.pais_nacimiento= 23  and p.nacionalidad  = 3 then  '29'
                  when p.pais_nacimiento= 24  and p.nacionalidad  = 3 then  '30'
                  when p.pais_nacimiento= 25  and p.nacionalidad  = 3 then  '31'
                  when p.pais_nacimiento= 26  and p.nacionalidad  = 3 then  '32'
                  when p.pais_nacimiento= 27  and p.nacionalidad  = 3 then  '33'
                  when p.pais_nacimiento= 28  and p.nacionalidad  = 3 then  '34'
                  when p.pais_nacimiento= 29  and p.nacionalidad  = 3 then  '35'
                  when p.pais_nacimiento= 30  and p.nacionalidad  = 3 then  '36'
                  when p.pais_nacimiento= 31  and p.nacionalidad  = 3 then  '37'
                  when p.pais_nacimiento= 32  and p.nacionalidad  = 3 then  '38'
                  when p.pais_nacimiento= 33  and p.nacionalidad  = 3 then  '39'
                  when p.pais_nacimiento= 34  and p.nacionalidad  = 3 then  '40'
                  when p.pais_nacimiento= 35  and p.nacionalidad  = 3 then  '41'
                  when p.pais_nacimiento= 36  and p.nacionalidad  = 3 then  '42'
                  when p.pais_nacimiento= 37  and p.nacionalidad  = 3 then  '187'
                  when p.pais_nacimiento= 38  and p.nacionalidad  = 3 then  '43'
                  when p.pais_nacimiento= 39  and p.nacionalidad  = 3 then  '44'
                  when p.pais_nacimiento= 40  and p.nacionalidad  = 3 then  '197'
                  when p.pais_nacimiento= 41  and p.nacionalidad  = 3 then  '45'
                  when p.pais_nacimiento= 42  and p.nacionalidad  = 3 then  '46'
                  when p.pais_nacimiento= 43  and p.nacionalidad  = 3 then  '47'
                  when p.pais_nacimiento= 44  and p.nacionalidad  = 3 then  '48'
                  when p.pais_nacimiento= 45  and p.nacionalidad  = 3 then  '49'
                  when p.pais_nacimiento= 46  and p.nacionalidad  = 3 then  '50'
                  when p.pais_nacimiento= 47  and p.nacionalidad  = 3 then  '51'
                  when p.pais_nacimiento= 48  and p.nacionalidad  = 3 then  '52'
                  when p.pais_nacimiento= 49  and p.nacionalidad  = 3 then  '53'
                  when p.pais_nacimiento= 50  and p.nacionalidad  = 3 then  '54'
                  when p.pais_nacimiento= 51  and p.nacionalidad  = 3 then  '56'
                  when p.pais_nacimiento= 52  and p.nacionalidad  = 3 then  '57'
                  when p.pais_nacimiento= 53  and p.nacionalidad  = 3 then  '58'
                  when p.pais_nacimiento= 54  and p.nacionalidad  = 3 then  '59'
                  when p.pais_nacimiento= 55  and p.nacionalidad  = 3 then  '60'
                  when p.pais_nacimiento= 56  and p.nacionalidad  = 3 then  '61'
                  when p.pais_nacimiento= 57  and p.nacionalidad  = 3 then  '62'
                  when p.pais_nacimiento= 58  and p.nacionalidad  = 3 then  '63'
                  when p.pais_nacimiento= 59  and p.nacionalidad  = 3 then  '64'
                  when p.pais_nacimiento= 60  and p.nacionalidad  = 3 then  '65'
                  when p.pais_nacimiento= 61  and p.nacionalidad  = 3 then  '67'
                  when p.pais_nacimiento= 62  and p.nacionalidad  = 3 then  '68'
                  when p.pais_nacimiento= 63  and p.nacionalidad  = 3 then  '69'
                  when p.pais_nacimiento= 64  and p.nacionalidad  = 3 then  '70'
                  when p.pais_nacimiento= 65  and p.nacionalidad  = 3 then  '71'
                  when p.pais_nacimiento= 66  and p.nacionalidad  = 3 then  '72'
                  when p.pais_nacimiento= 67  and p.nacionalidad  = 3 then  '73'
                  when p.pais_nacimiento= 68  and p.nacionalidad  = 3 then  '74'
                  when p.pais_nacimiento= 69  and p.nacionalidad  = 3 then  '75'
                  when p.pais_nacimiento= 70  and p.nacionalidad  = 3 then  '76'
                  when p.pais_nacimiento= 71  and p.nacionalidad  = 3 then  '77'
                  when p.pais_nacimiento= 72  and p.nacionalidad  = 3 then  '79'
                  when p.pais_nacimiento= 73  and p.nacionalidad  = 3 then  '80'
                  when p.pais_nacimiento= 74  and p.nacionalidad  = 3 then  '84'
                  when p.pais_nacimiento= 75  and p.nacionalidad  = 3 then  '90'
                  when p.pais_nacimiento= 76  and p.nacionalidad  = 3 then  '87'
                  when p.pais_nacimiento= 77  and p.nacionalidad  = 3 then  '88'
                  when p.pais_nacimiento= 78  and p.nacionalidad  = 3 then  '89'
                  when p.pais_nacimiento= 79  and p.nacionalidad  = 3 then  '91'
                  when p.pais_nacimiento= 80  and p.nacionalidad  = 3 then  '92'
                  when p.pais_nacimiento= 81  and p.nacionalidad  = 3 then  '94'
                  when p.pais_nacimiento= 82  and p.nacionalidad  = 3 then  '95'
                  when p.pais_nacimiento= 83  and p.nacionalidad  = 3 then  '96'
                  when p.pais_nacimiento= 84  and p.nacionalidad  = 3 then  '97'
                  when p.pais_nacimiento= 85  and p.nacionalidad  = 3 then  '98'
                  when p.pais_nacimiento= 86  and p.nacionalidad  = 3 then  '99'
                  when p.pais_nacimiento= 87  and p.nacionalidad  = 3 then  '104'
                  when p.pais_nacimiento= 88  and p.nacionalidad  = 3 then  '112'
                  when p.pais_nacimiento= 89  and p.nacionalidad  = 3 then  '115'
                  when p.pais_nacimiento= 90  and p.nacionalidad  = 3 then  '120'
                  when p.pais_nacimiento= 91  and p.nacionalidad  = 3 then  '121'
                  when p.pais_nacimiento= 92  and p.nacionalidad  = 3 then  '122'
                  when p.pais_nacimiento= 93  and p.nacionalidad  = 3 then  '123'
                  when p.pais_nacimiento= 94  and p.nacionalidad  = 3 then  '125'
                  when p.pais_nacimiento= 95  and p.nacionalidad  = 3 then  '126'
                  when p.pais_nacimiento= 96  and p.nacionalidad  = 3 then  '127'
                  when p.pais_nacimiento= 97  and p.nacionalidad  = 3 then  '128'
                  when p.pais_nacimiento= 98  and p.nacionalidad  = 3 then  '129'
                  when p.pais_nacimiento= 99  and p.nacionalidad  = 3 then  '131'
                  when p.pais_nacimiento= 100 and p.nacionalidad  = 3 then  '133'
                  when p.pais_nacimiento= 101 and p.nacionalidad  = 3 then  '134'
                  when p.pais_nacimiento= 102 and p.nacionalidad  = 3 then  '135'
                  when p.pais_nacimiento= 103 and p.nacionalidad  = 3 then  '136'
                  when p.pais_nacimiento= 104 and p.nacionalidad  = 3 then  '137'
                  when p.pais_nacimiento= 105 and p.nacionalidad  = 3 then  '138'
                  when p.pais_nacimiento= 106 and p.nacionalidad  = 3 then  '139'
                  when p.pais_nacimiento= 107 and p.nacionalidad  = 3 then  '140'
                  when p.pais_nacimiento= 108 and p.nacionalidad  = 3 then  '142'
                  when p.pais_nacimiento= 109 and p.nacionalidad  = 3 then  '145'
                  when p.pais_nacimiento= 110 and p.nacionalidad  = 3 then  '147'
                  when p.pais_nacimiento= 111 and p.nacionalidad  = 3 then  '148'
                  when p.pais_nacimiento= 112 and p.nacionalidad  = 3 then  '149'
                  when p.pais_nacimiento= 113 and p.nacionalidad  = 3 then  '150'
                  when p.pais_nacimiento= 114 and p.nacionalidad  = 3 then  '151'
                  when p.pais_nacimiento= 115 and p.nacionalidad  = 3 then  '152'
                  when p.pais_nacimiento= 116 and p.nacionalidad  = 3 then  '154'
                  when p.pais_nacimiento= 117 and p.nacionalidad  = 3 then  '155'
                  when p.pais_nacimiento= 118 and p.nacionalidad  = 3 then  '66'
                  when p.pais_nacimiento= 119 and p.nacionalidad  = 3 then  '158'
                  when p.pais_nacimiento= 120 and p.nacionalidad  = 3 then  '159'
                  when p.pais_nacimiento= 121 and p.nacionalidad  = 3 then  '160'
                  when p.pais_nacimiento= 122 and p.nacionalidad  = 3 then  '161'
                  when p.pais_nacimiento= 123 and p.nacionalidad  = 3 then  '163'
                  when p.pais_nacimiento= 124 and p.nacionalidad  = 3 then  '164'
                  when p.pais_nacimiento= 125 and p.nacionalidad  = 3 then  '165'
                  when p.pais_nacimiento= 126 and p.nacionalidad  = 3 then  '166'
                  when p.pais_nacimiento= 127 and p.nacionalidad  = 3 then  '167'
                  when p.pais_nacimiento= 128 and p.nacionalidad  = 3 then  '168'
                  when p.pais_nacimiento= 129 and p.nacionalidad  = 3 then  '169'
                  when p.pais_nacimiento= 130 and p.nacionalidad  = 3 then  '171'
                  when p.pais_nacimiento= 131 and p.nacionalidad  = 3 then  '174'
                  when p.pais_nacimiento= 132 and p.nacionalidad  = 3 then  '174'
                  when p.pais_nacimiento= 133 and p.nacionalidad  = 3 then  '141'
                  when p.pais_nacimiento= 134 and p.nacionalidad  = 3 then  '177'
                  when p.pais_nacimiento= 135 and p.nacionalidad  = 3 then  '178'
                  when p.pais_nacimiento= 136 and p.nacionalidad  = 3 then  '179'
                  when p.pais_nacimiento= 137 and p.nacionalidad  = 3 then  '180'
                  when p.pais_nacimiento= 138 and p.nacionalidad  = 3 then  '181'
                  when p.pais_nacimiento= 139 and p.nacionalidad  = 3 then  '182'
                  when p.pais_nacimiento= 140 and p.nacionalidad  = 3 then  '184'
                  when p.pais_nacimiento= 141 and p.nacionalidad  = 3 then  '185'
                  when p.pais_nacimiento= 142 and p.nacionalidad  = 3 then  '189'
                  when p.pais_nacimiento= 143 and p.nacionalidad  = 3 then  '132'
                  when p.pais_nacimiento= 144 and p.nacionalidad  = 3 then  '190'
                  when p.pais_nacimiento= 145 and p.nacionalidad  = 3 then  '144'
                  when p.pais_nacimiento= 146 and p.nacionalidad  = 3 then  '194'
                  when p.pais_nacimiento= 147 and p.nacionalidad  = 3 then  '195'
                  when p.pais_nacimiento= 148 and p.nacionalidad  = 3 then  '196'
                  when p.pais_nacimiento= 149 and p.nacionalidad  = 3 then  '224'
                  when p.pais_nacimiento= 150 and p.nacionalidad  = 3 then  '200'
                  when p.pais_nacimiento= 151 and p.nacionalidad  = 3 then  '201'
                  when p.pais_nacimiento= 152 and p.nacionalidad  = 3 then  '202'
                  when p.pais_nacimiento= 153 and p.nacionalidad  = 3 then  '204'
                  when p.pais_nacimiento= 154 and p.nacionalidad  = 3 then  '207'
                  when p.pais_nacimiento= 155 and p.nacionalidad  = 3 then  '208'
                  when p.pais_nacimiento= 156 and p.nacionalidad  = 3 then  '211'
                  when p.pais_nacimiento= 157 and p.nacionalidad  = 3 then  '213'
                  when p.pais_nacimiento= 158 and p.nacionalidad  = 3 then  '214'
                  when p.pais_nacimiento= 159 and p.nacionalidad  = 3 then  '215'
                  when p.pais_nacimiento= 160 and p.nacionalidad  = 3 then  '216'
                  when p.pais_nacimiento= 161 and p.nacionalidad  = 3 then  '217'
                  when p.pais_nacimiento= 162 and p.nacionalidad  = 3 then  '218'
                  when p.pais_nacimiento= 163 and p.nacionalidad  = 3 then  '219'
                  when p.pais_nacimiento= 164 and p.nacionalidad  = 3 then  '220'
                  when p.pais_nacimiento= 165 and p.nacionalidad  = 3 then  '221'
                  when p.pais_nacimiento= 166 and p.nacionalidad  = 3 then  '223'
                  when p.pais_nacimiento= 167 and p.nacionalidad  = 3 then  '188'
                  when p.pais_nacimiento= 168 and p.nacionalidad  = 3 then  '225'
                  when p.pais_nacimiento= 169 and p.nacionalidad  = 3 then  '226'
                  when p.pais_nacimiento= 170 and p.nacionalidad  = 3 then  '227'
                  when p.pais_nacimiento= 171 and p.nacionalidad  = 3 then  '228'
                  when p.pais_nacimiento= 172 and p.nacionalidad  = 3 then  '229'
                  when p.pais_nacimiento= 173 and p.nacionalidad  = 3 then  '230'
                  when p.pais_nacimiento= 174 and p.nacionalidad  = 3 then  '232'
                  when p.pais_nacimiento= 175 and p.nacionalidad  = 3 then  '233'
                  when p.pais_nacimiento= 176 and p.nacionalidad  = 3 then  '237'
                  when p.pais_nacimiento= 177 and p.nacionalidad  = 3 then  '238'
                  when p.pais_nacimiento= 178 and p.nacionalidad  = 3 then  '240'
                  when p.pais_nacimiento= 179 and p.nacionalidad  = 3 then  '242'
                  when p.pais_nacimiento= 180 and p.nacionalidad  = 3 then  '243'
                  when p.pais_nacimiento= 181 and p.nacionalidad  = 3 then  '244'
                  when p.pais_nacimiento= 182 and p.nacionalidad  = 3 then  '245'
                  when p.pais_nacimiento= 183 and p.nacionalidad  = 3 then  '246'
                  when p.pais_nacimiento= 184 and p.nacionalidad  = 3 then  '247'
                  when p.pais_nacimiento= 185 and p.nacionalidad  = 3 then  '248'
                  when p.pais_nacimiento= 186 and p.nacionalidad  = 3 then  '249'
                  when p.pais_nacimiento= 187 and p.nacionalidad  = 3 then  '250'
                  when p.pais_nacimiento= 188 and p.nacionalidad  = 3 then  '251'
                  when p.pais_nacimiento= 189 and p.nacionalidad  = 3 then  '252'
                  when p.pais_nacimiento= 190 and p.nacionalidad  = 3 then  '253'
                  when p.pais_nacimiento= 191 and p.nacionalidad  = 3 then  '255'
                  when p.pais_nacimiento= 192 and p.nacionalidad  = 3 then  '192'
                  when p.pais_nacimiento= 193 and p.nacionalidad  = 3 then  '256'
                  when p.pais_nacimiento= 194 and p.nacionalidad  = 3 then  '193'
                  when p.pais_nacimiento= 195 and p.nacionalidad  = 3 then  '83'
                  when p.pais_nacimiento= 196 and p.nacionalidad  = 3 then  '117'                        
                  else  '157' end) as nacion, ----------DATO 7
        
                  (CASE WHEN e.idestado = 7 then 5
                        WHEN e.idestado = 8 then 6
                        ELSE e.idestado 
                  END) as entidad_federativa_residencia, ----------DATO 9
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
                     (case 
                  when p.pais_nacimiento= 2   and p.nacionalidad  = 3 then  '3'
                  when p.pais_nacimiento= 3   and p.nacionalidad  = 3 then  '4'
                  when p.pais_nacimiento= 4   and p.nacionalidad  = 3 then  '5'
                  when p.pais_nacimiento= 5   and p.nacionalidad  = 3 then  '6'
                  when p.pais_nacimiento= 6   and p.nacionalidad  = 3 then  '7'
                  when p.pais_nacimiento= 7   and p.nacionalidad  = 3 then  '10'
                  when p.pais_nacimiento= 8   and p.nacionalidad  = 3 then  '12'
                  when p.pais_nacimiento= 9   and p.nacionalidad  = 3 then  '13'
                  when p.pais_nacimiento= 10  and p.nacionalidad  = 3 then  '14'
                  when p.pais_nacimiento= 11  and p.nacionalidad  = 3 then  '15'
                  when p.pais_nacimiento= 12  and p.nacionalidad  = 3 then  '17'
                  when p.pais_nacimiento= 13  and p.nacionalidad  = 3 then  '18'
                  when p.pais_nacimiento= 14  and p.nacionalidad  = 3 then  '19'
                  when p.pais_nacimiento= 15  and p.nacionalidad  = 3 then  '20'
                  when p.pais_nacimiento= 16  and p.nacionalidad  = 3 then  '22'
                  when p.pais_nacimiento= 17  and p.nacionalidad  = 3 then  '23'
                  when p.pais_nacimiento= 18  and p.nacionalidad  = 3 then  '21'
                  when p.pais_nacimiento= 19  and p.nacionalidad  = 3 then  '24'
                  when p.pais_nacimiento= 20  and p.nacionalidad  = 3 then  '25'
                  when p.pais_nacimiento= 21  and p.nacionalidad  = 3 then  '26'
                  when p.pais_nacimiento= 22  and p.nacionalidad  = 3 then  '28'
                  when p.pais_nacimiento= 23  and p.nacionalidad  = 3 then  '29'
                  when p.pais_nacimiento= 24  and p.nacionalidad  = 3 then  '30'
                  when p.pais_nacimiento= 25  and p.nacionalidad  = 3 then  '31'
                  when p.pais_nacimiento= 26  and p.nacionalidad  = 3 then  '32'
                  when p.pais_nacimiento= 27  and p.nacionalidad  = 3 then  '33'
                  when p.pais_nacimiento= 28  and p.nacionalidad  = 3 then  '34'
                  when p.pais_nacimiento= 29  and p.nacionalidad  = 3 then  '35'
                  when p.pais_nacimiento= 30  and p.nacionalidad  = 3 then  '36'
                  when p.pais_nacimiento= 31  and p.nacionalidad  = 3 then  '37'
                  when p.pais_nacimiento= 32  and p.nacionalidad  = 3 then  '38'
                  when p.pais_nacimiento= 33  and p.nacionalidad  = 3 then  '39'
                  when p.pais_nacimiento= 34  and p.nacionalidad  = 3 then  '40'
                  when p.pais_nacimiento= 35  and p.nacionalidad  = 3 then  '41'
                  when p.pais_nacimiento= 36  and p.nacionalidad  = 3 then  '42'
                  when p.pais_nacimiento= 37  and p.nacionalidad  = 3 then  '187'
                  when p.pais_nacimiento= 38  and p.nacionalidad  = 3 then  '43'
                  when p.pais_nacimiento= 39  and p.nacionalidad  = 3 then  '44'
                  when p.pais_nacimiento= 40  and p.nacionalidad  = 3 then  '197'
                  when p.pais_nacimiento= 41  and p.nacionalidad  = 3 then  '45'
                  when p.pais_nacimiento= 42  and p.nacionalidad  = 3 then  '46'
                  when p.pais_nacimiento= 43  and p.nacionalidad  = 3 then  '47'
                  when p.pais_nacimiento= 44  and p.nacionalidad  = 3 then  '48'
                  when p.pais_nacimiento= 45  and p.nacionalidad  = 3 then  '49'
                  when p.pais_nacimiento= 46  and p.nacionalidad  = 3 then  '50'
                  when p.pais_nacimiento= 47  and p.nacionalidad  = 3 then  '51'
                  when p.pais_nacimiento= 48  and p.nacionalidad  = 3 then  '52'
                  when p.pais_nacimiento= 49  and p.nacionalidad  = 3 then  '53'
                  when p.pais_nacimiento= 50  and p.nacionalidad  = 3 then  '54'
                  when p.pais_nacimiento= 51  and p.nacionalidad  = 3 then  '56'
                  when p.pais_nacimiento= 52  and p.nacionalidad  = 3 then  '57'
                  when p.pais_nacimiento= 53  and p.nacionalidad  = 3 then  '58'
                  when p.pais_nacimiento= 54  and p.nacionalidad  = 3 then  '59'
                  when p.pais_nacimiento= 55  and p.nacionalidad  = 3 then  '60'
                  when p.pais_nacimiento= 56  and p.nacionalidad  = 3 then  '61'
                  when p.pais_nacimiento= 57  and p.nacionalidad  = 3 then  '62'
                  when p.pais_nacimiento= 58  and p.nacionalidad  = 3 then  '63'
                  when p.pais_nacimiento= 59  and p.nacionalidad  = 3 then  '64'
                  when p.pais_nacimiento= 60  and p.nacionalidad  = 3 then  '65'
                  when p.pais_nacimiento= 61  and p.nacionalidad  = 3 then  '67'
                  when p.pais_nacimiento= 62  and p.nacionalidad  = 3 then  '68'
                  when p.pais_nacimiento= 63  and p.nacionalidad  = 3 then  '69'
                  when p.pais_nacimiento= 64  and p.nacionalidad  = 3 then  '70'
                  when p.pais_nacimiento= 65  and p.nacionalidad  = 3 then  '71'
                  when p.pais_nacimiento= 66  and p.nacionalidad  = 3 then  '72'
                  when p.pais_nacimiento= 67  and p.nacionalidad  = 3 then  '73'
                  when p.pais_nacimiento= 68  and p.nacionalidad  = 3 then  '74'
                  when p.pais_nacimiento= 69  and p.nacionalidad  = 3 then  '75'
                  when p.pais_nacimiento= 70  and p.nacionalidad  = 3 then  '76'
                  when p.pais_nacimiento= 71  and p.nacionalidad  = 3 then  '77'
                  when p.pais_nacimiento= 72  and p.nacionalidad  = 3 then  '79'
                  when p.pais_nacimiento= 73  and p.nacionalidad  = 3 then  '80'
                  when p.pais_nacimiento= 74  and p.nacionalidad  = 3 then  '84'
                  when p.pais_nacimiento= 75  and p.nacionalidad  = 3 then  '90'
                  when p.pais_nacimiento= 76  and p.nacionalidad  = 3 then  '87'
                  when p.pais_nacimiento= 77  and p.nacionalidad  = 3 then  '88'
                  when p.pais_nacimiento= 78  and p.nacionalidad  = 3 then  '89'
                  when p.pais_nacimiento= 79  and p.nacionalidad  = 3 then  '91'
                  when p.pais_nacimiento= 80  and p.nacionalidad  = 3 then  '92'
                  when p.pais_nacimiento= 81  and p.nacionalidad  = 3 then  '94'
                  when p.pais_nacimiento= 82  and p.nacionalidad  = 3 then  '95'
                  when p.pais_nacimiento= 83  and p.nacionalidad  = 3 then  '96'
                  when p.pais_nacimiento= 84  and p.nacionalidad  = 3 then  '97'
                  when p.pais_nacimiento= 85  and p.nacionalidad  = 3 then  '98'
                  when p.pais_nacimiento= 86  and p.nacionalidad  = 3 then  '99'
                  when p.pais_nacimiento= 87  and p.nacionalidad  = 3 then  '104'
                  when p.pais_nacimiento= 88  and p.nacionalidad  = 3 then  '112'
                  when p.pais_nacimiento= 89  and p.nacionalidad  = 3 then  '115'
                  when p.pais_nacimiento= 90  and p.nacionalidad  = 3 then  '120'
                  when p.pais_nacimiento= 91  and p.nacionalidad  = 3 then  '121'
                  when p.pais_nacimiento= 92  and p.nacionalidad  = 3 then  '122'
                  when p.pais_nacimiento= 93  and p.nacionalidad  = 3 then  '123'
                  when p.pais_nacimiento= 94  and p.nacionalidad  = 3 then  '125'
                  when p.pais_nacimiento= 95  and p.nacionalidad  = 3 then  '126'
                  when p.pais_nacimiento= 96  and p.nacionalidad  = 3 then  '127'
                  when p.pais_nacimiento= 97  and p.nacionalidad  = 3 then  '128'
                  when p.pais_nacimiento= 98  and p.nacionalidad  = 3 then  '129'
                  when p.pais_nacimiento= 99  and p.nacionalidad  = 3 then  '131'
                  when p.pais_nacimiento= 100 and p.nacionalidad  = 3 then  '133'
                  when p.pais_nacimiento= 101 and p.nacionalidad  = 3 then  '134'
                  when p.pais_nacimiento= 102 and p.nacionalidad  = 3 then  '135'
                  when p.pais_nacimiento= 103 and p.nacionalidad  = 3 then  '136'
                  when p.pais_nacimiento= 104 and p.nacionalidad  = 3 then  '137'
                  when p.pais_nacimiento= 105 and p.nacionalidad  = 3 then  '138'
                  when p.pais_nacimiento= 106 and p.nacionalidad  = 3 then  '139'
                  when p.pais_nacimiento= 107 and p.nacionalidad  = 3 then  '140'
                  when p.pais_nacimiento= 108 and p.nacionalidad  = 3 then  '142'
                  when p.pais_nacimiento= 109 and p.nacionalidad  = 3 then  '145'
                  when p.pais_nacimiento= 110 and p.nacionalidad  = 3 then  '147'
                  when p.pais_nacimiento= 111 and p.nacionalidad  = 3 then  '148'
                  when p.pais_nacimiento= 112 and p.nacionalidad  = 3 then  '149'
                  when p.pais_nacimiento= 113 and p.nacionalidad  = 3 then  '150'
                  when p.pais_nacimiento= 114 and p.nacionalidad  = 3 then  '151'
                  when p.pais_nacimiento= 115 and p.nacionalidad  = 3 then  '152'
                  when p.pais_nacimiento= 116 and p.nacionalidad  = 3 then  '154'
                  when p.pais_nacimiento= 117 and p.nacionalidad  = 3 then  '155'
                  when p.pais_nacimiento= 118 and p.nacionalidad  = 3 then  '66'
                  when p.pais_nacimiento= 119 and p.nacionalidad  = 3 then  '158'
                  when p.pais_nacimiento= 120 and p.nacionalidad  = 3 then  '159'
                  when p.pais_nacimiento= 121 and p.nacionalidad  = 3 then  '160'
                  when p.pais_nacimiento= 122 and p.nacionalidad  = 3 then  '161'
                  when p.pais_nacimiento= 123 and p.nacionalidad  = 3 then  '163'
                  when p.pais_nacimiento= 124 and p.nacionalidad  = 3 then  '164'
                  when p.pais_nacimiento= 125 and p.nacionalidad  = 3 then  '165'
                  when p.pais_nacimiento= 126 and p.nacionalidad  = 3 then  '166'
                  when p.pais_nacimiento= 127 and p.nacionalidad  = 3 then  '167'
                  when p.pais_nacimiento= 128 and p.nacionalidad  = 3 then  '168'
                  when p.pais_nacimiento= 129 and p.nacionalidad  = 3 then  '169'
                  when p.pais_nacimiento= 130 and p.nacionalidad  = 3 then  '171'
                  when p.pais_nacimiento= 131 and p.nacionalidad  = 3 then  '174'
                  when p.pais_nacimiento= 132 and p.nacionalidad  = 3 then  '174'
                  when p.pais_nacimiento= 133 and p.nacionalidad  = 3 then  '141'
                  when p.pais_nacimiento= 134 and p.nacionalidad  = 3 then  '177'
                  when p.pais_nacimiento= 135 and p.nacionalidad  = 3 then  '178'
                  when p.pais_nacimiento= 136 and p.nacionalidad  = 3 then  '179'
                  when p.pais_nacimiento= 137 and p.nacionalidad  = 3 then  '180'
                  when p.pais_nacimiento= 138 and p.nacionalidad  = 3 then  '181'
                  when p.pais_nacimiento= 139 and p.nacionalidad  = 3 then  '182'
                  when p.pais_nacimiento= 140 and p.nacionalidad  = 3 then  '184'
                  when p.pais_nacimiento= 141 and p.nacionalidad  = 3 then  '185'
                  when p.pais_nacimiento= 142 and p.nacionalidad  = 3 then  '189'
                  when p.pais_nacimiento= 143 and p.nacionalidad  = 3 then  '132'
                  when p.pais_nacimiento= 144 and p.nacionalidad  = 3 then  '190'
                  when p.pais_nacimiento= 145 and p.nacionalidad  = 3 then  '144'
                  when p.pais_nacimiento= 146 and p.nacionalidad  = 3 then  '194'
                  when p.pais_nacimiento= 147 and p.nacionalidad  = 3 then  '195'
                  when p.pais_nacimiento= 148 and p.nacionalidad  = 3 then  '196'
                  when p.pais_nacimiento= 149 and p.nacionalidad  = 3 then  '224'
                  when p.pais_nacimiento= 150 and p.nacionalidad  = 3 then  '200'
                  when p.pais_nacimiento= 151 and p.nacionalidad  = 3 then  '201'
                  when p.pais_nacimiento= 152 and p.nacionalidad  = 3 then  '202'
                  when p.pais_nacimiento= 153 and p.nacionalidad  = 3 then  '204'
                  when p.pais_nacimiento= 154 and p.nacionalidad  = 3 then  '207'
                  when p.pais_nacimiento= 155 and p.nacionalidad  = 3 then  '208'
                  when p.pais_nacimiento= 156 and p.nacionalidad  = 3 then  '211'
                  when p.pais_nacimiento= 157 and p.nacionalidad  = 3 then  '213'
                  when p.pais_nacimiento= 158 and p.nacionalidad  = 3 then  '214'
                  when p.pais_nacimiento= 159 and p.nacionalidad  = 3 then  '215'
                  when p.pais_nacimiento= 160 and p.nacionalidad  = 3 then  '216'
                  when p.pais_nacimiento= 161 and p.nacionalidad  = 3 then  '217'
                  when p.pais_nacimiento= 162 and p.nacionalidad  = 3 then  '218'
                  when p.pais_nacimiento= 163 and p.nacionalidad  = 3 then  '219'
                  when p.pais_nacimiento= 164 and p.nacionalidad  = 3 then  '220'
                  when p.pais_nacimiento= 165 and p.nacionalidad  = 3 then  '221'
                  when p.pais_nacimiento= 166 and p.nacionalidad  = 3 then  '223'
                  when p.pais_nacimiento= 167 and p.nacionalidad  = 3 then  '188'
                  when p.pais_nacimiento= 168 and p.nacionalidad  = 3 then  '225'
                  when p.pais_nacimiento= 169 and p.nacionalidad  = 3 then  '226'
                  when p.pais_nacimiento= 170 and p.nacionalidad  = 3 then  '227'
                  when p.pais_nacimiento= 171 and p.nacionalidad  = 3 then  '228'
                  when p.pais_nacimiento= 172 and p.nacionalidad  = 3 then  '229'
                  when p.pais_nacimiento= 173 and p.nacionalidad  = 3 then  '230'
                  when p.pais_nacimiento= 174 and p.nacionalidad  = 3 then  '232'
                  when p.pais_nacimiento= 175 and p.nacionalidad  = 3 then  '233'
                  when p.pais_nacimiento= 176 and p.nacionalidad  = 3 then  '237'
                  when p.pais_nacimiento= 177 and p.nacionalidad  = 3 then  '238'
                  when p.pais_nacimiento= 178 and p.nacionalidad  = 3 then  '240'
                  when p.pais_nacimiento= 179 and p.nacionalidad  = 3 then  '242'
                  when p.pais_nacimiento= 180 and p.nacionalidad  = 3 then  '243'
                  when p.pais_nacimiento= 181 and p.nacionalidad  = 3 then  '244'
                  when p.pais_nacimiento= 182 and p.nacionalidad  = 3 then  '245'
                  when p.pais_nacimiento= 183 and p.nacionalidad  = 3 then  '246'
                  when p.pais_nacimiento= 184 and p.nacionalidad  = 3 then  '247'
                  when p.pais_nacimiento= 185 and p.nacionalidad  = 3 then  '248'
                  when p.pais_nacimiento= 186 and p.nacionalidad  = 3 then  '249'
                  when p.pais_nacimiento= 187 and p.nacionalidad  = 3 then  '250'
                  when p.pais_nacimiento= 188 and p.nacionalidad  = 3 then  '251'
                  when p.pais_nacimiento= 189 and p.nacionalidad  = 3 then  '252'
                  when p.pais_nacimiento= 190 and p.nacionalidad  = 3 then  '253'
                  when p.pais_nacimiento= 191 and p.nacionalidad  = 3 then  '255'
                  when p.pais_nacimiento= 192 and p.nacionalidad  = 3 then  '192'
                  when p.pais_nacimiento= 193 and p.nacionalidad  = 3 then  '256'
                  when p.pais_nacimiento= 194 and p.nacionalidad  = 3 then  '193'
                  when p.pais_nacimiento= 195 and p.nacionalidad  = 3 then  '83'
                  when p.pais_nacimiento= 196 and p.nacionalidad  = 3 then  '117'                        
                        else  '157' end) as nacion, ----------DATO 7
        
                (CASE WHEN e.idestado = 7 then 5
                      WHEN e.idestado = 8 then 6
                      ELSE e.idestado 
                END) as entidad_federativa_residencia, ----------DATO 9
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
      r.pais_residencia                   :=r_paso.nacion;
      r.entidad_federativa_residencia     :=trim(to_char(r_paso.entidad_federativa_residencia,'99'));
      r.actividad_economica               := CASE WHEN r_paso.actividad_economica IS NULL OR
                                                       r_paso.actividad_economica = ''
                                                  THEN '000000'
                                                  ELSE trim(to_char(r_paso.actividad_economica::numeric,'99999999'))
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