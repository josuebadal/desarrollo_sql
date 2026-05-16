-----------------------------------------------------------
--                    INCIO FUNCION CUESTIONARIO A1
-----------------------------------------------------------

DROP TYPE IF EXISTS numero_de_socios_de_la_entidad CASCADE;
CREATE TYPE numero_de_socios_de_la_entidad as (
anio                                       integer,
clave_formulario                           text,
clave_de_entidad                           integer,
tipo_cliente_o_usuario                     varchar,
clasificacion_grado_riesgo                 integer,
pais_nacionalidad                          integer,
pais_residencia                            varchar, 
entidad_federativa_residencia              integer,
actividad_economica                        varchar, -- ADD ENERO 2026
numero_total_clientes                      integer
);
                                     --clave entidad  --anio  
CREATE OR REPLACE FUNCTION cuestionario_a1 (integer,integer)
RETURNS SETOF numero_de_socios_de_la_entidad as $$
 DECLARE
 r                 numero_de_socios_de_la_entidad%rowtype;
 clave_enti        alias for  $1; 
 amo               alias for  $2;
 p_inicial         integer; -- // periodo Inicial ej. 202001
 p_final           integer; -- // periodo final ej. 202012
 r_aux             record;
 r_paso            record;
 r_perso           record;
 rec               record;
 y                 integer;
 fecha             varchar;
 pro_1             varchar;
 mon_1             varchar;
 pro_2             varchar;
 mon_2             varchar;

begin

 ----TABLA FISICA PARA CONSULTAS CUESTIONARIO A1 AGREGADO 2026
DROP table IF EXISTS a1_cuestionario_operatividad;
CREATE temp table a1_cuestionario_operatividad(
 anio                                                   text,              
 clave_formulario                                       text,                
 clave_de_entidad                                       text,           
 tipo_cliente_o_usuario                                 text,
 clasificacion_grado_riesgo                             text,                 
 pais_nacionalidad                                      text,    
 pais_residencia                                        text,                 
 entidad_federativa_residencia                          text,                  
 actividad_economica                                    text,             
 numero_total_clientes                                  text                                 
 );
RAISE NOTICE 'Se creo a1_cuestionario_operatividad';

 ----TABLA FISICA PARA CONSULTAS CUESTIONARIO A 1


DROP table IF EXISTS copiar;
CREATE temp table copiar(
  id    integer,
  fila  text);

y:=0;
insert into copiar values(y,'ANIO|CLAVE DEL FORMULARIO|CLAVE DE LA ENTIDAD|TIPO DE CLIENTE O USUARIO|CLASIFICACION POR GRADO DE RIESGO|PAIS DE NACIONALIDAD|PAIS DE RESIDENCIA|ENTIDAD FEDERATIVA DE RESIDENCIA|ACTIVIDAD ECONOMICA|NUMERO TOTAL DE CLIENTES O USUARIOS');
y:=1;


p_inicial :=(amo||'01')::integer;
p_final   :=(amo||'12')::integer;



------------------------------------------------------------------------------------------------------------------------
------------------------------TABLAS PARA OBTENER LOS SOCIOS 
------------------------------------------------------------------------------------------------------------------------
  drop table if exists tmp_act;
  create temp table tmp_act (
 idorigen            integer,
 idgrupo             integer,
 idsocio             integer
    );


  for rec in
    select * from tablas where lower(idtabla) = 'prod_base_cuestionario_op'
    order by idelemento::integer
  loop

    insert into tmp_act
        select idorigen,idgrupo,idsocio from auxiliares where idproducto = rec.dato1::integer and saldo  >=  rec.dato2::numeric;    
  end loop;


/*  drop table if exists temp_peps;
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
raise notice 'Se genero la tabla temp_peps';*/

------------------------------------------------------------------------------------------------------------------------
-- INICIA CONFIGURACION QEQ ENERO 2026----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

  drop table if exists tmp_qeq_registros_f1;
  create temp table tmp_qeq_registros_f1 as
    select i.*,
           h.fecha,tipo,
           c.nombre,c.paterno,c.materno,
           c.lista,c.estatus,c.fecha_cargo_ini,
           c.fecha_nacimiento,c.rfc,c.curp
    from   peps_qeq_identificado_web i
           inner join peps_qeq_historial_busquedas_web h using (idorigen,idgrupo,idsocio)
           inner join personas p using (idorigen,idgrupo,idsocio)
           inner join peps_qeq_catalogo_web c using (id_persona)
    where  h.aceptado;

  --LIMPIAR ---
  update tmp_qeq_registros_f1 f1
  set    fecha_nacimiento = NULL
  from   (select *
          from   tmp_qeq_registros_f1
          where  fecha_nacimiento is null or fecha_nacimiento = '' or length(fecha_nacimiento) != 10) z
  where  (f1.idorigen,f1.idgrupo,f1.idsocio,f1.fecha,f1.fecha_nacimiento) = (z.idorigen,z.idgrupo,z.idsocio,z.fecha,z.fecha_nacimiento);

  drop table if exists tmp_qeq_registros_f2;
  create temp table tmp_qeq_registros_f2 as
    select f.*,p.nombre as p_nombre,p.appaterno as p_appaterno,p.apmaterno as p_apmaterno,p.rfc as p_rfc,
           p.curp as p_curp,p.fechanacimiento as p_fechanacimiento
    from   personas p
           inner join tmp_qeq_registros_f1 f using(idorigen,idgrupo,idsocio)
    where  p.rfc = f.rfc or p.curp = f.curp or
           ((f.fecha_nacimiento is not null and f.fecha_nacimiento != '') and p.fechanacimiento = date(f.fecha_nacimiento));

  drop table if exists temp_peps;
  create temp table temp_peps as
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from   (select i.idorigen,i.idgrupo,i.idsocio,a.idorigenp,a.idproducto,a.idauxiliar
            from tmp_qeq_registros_f2 as i
                 inner join auxiliares as a using(idorigen,idgrupo,idsocio)
            where lista = 'PPE' and fecha_cargo_ini is not NULL and fecha_cargo_ini != ''
            UNION ALL
            select i.idorigen,i.idgrupo,i.idsocio, a.idorigenp, a.idproducto, a.idauxiliar
            from tmp_qeq_registros_f2 as i
                 inner join auxiliares as a using(idorigen,idgrupo,idsocio)
            where lista = 'PPE') as te;
  create index temp_peps_pkey on temp_peps (idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar);
  raise notice 'Se genero la tabla temp_peps';


------------------------------------------------------------------------------------------------------------------------
-- TERMINA CONFIGURACION QEQ ----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

  drop table if exists tmp_act_peps;
  create temp table tmp_act_peps as (
    select idorigen,idgrupo,idsocio, 1 as peps  from personas
    where (idorigen,idgrupo,idsocio) in (select idorigen,idgrupo,idsocio from temp_peps)
   union all
    select idorigen,idgrupo,idsocio, 0 as peps from personas 
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

drop table if exists temp_pfae;
create local temp table temp_pfae as
  select distinct idorigen, idgrupo, idsocio
  from negociopropio where act_empresarial;
create index temp_pfae_pkey on temp_pfae (idorigen, idgrupo, idsocio);
raise notice 'Se genero la tabla temp_pfae';








for r_paso in select * from
        (select tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia,sum(num_total_clien_usua) as num_total_clien_usua
        --,espep
        ,nacion, actividad_economica from
        (select
        /*(case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
            when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
            when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 1 */
        /*    when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
                    end) as tipo_clien_usua,*/
        /*(case when peps = 1 then 15
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
         end)*/ 
         
        (case when ac.peps = 1 then 15
                       ELSE 1 
        END)          as tipo_clien_usua, ----------DATO 4
        (case when p.nivel_riesgo = 1 then 1
                      when p.nivel_riesgo = 2 then 5
                      --when p.nivel_riesgo = 3 then 5
                            else 1
                end) as clasi_grado_riesgo, ----------DATO 5
        count(*) as num_total_clien_usua, ----------DATO 10
        e.idestado as enti_fede_residencia, ----------DATO 8
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
                        else  '157' end) as nacion, ----------DATO 6
        /*(case when peps=1 then 'PEP'
               else ' '
               end) as espep,*/
-----SE AGREGO LA ACTVIVIDAD ECONOMICA PLD PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS
        tr.actividad_economica_pld as actividad_economica ----------DATO 9
        from personas p
        left join tmp_act_peps ac ON p.idorigen = ac.idorigen AND p.idgrupo = ac.idgrupo AND p.idsocio = ac.idsocio
        left join (select * from tmp_act) as ax ON p.idorigen = ax.idorigen AND p.idgrupo = ax.idgrupo AND p.idsocio = ax.idsocio
        inner join colonias c on(c.idcolonia=p.idcolonia) 
        inner join municipios m on(m.idmunicipio=c.idmunicipio) 
        inner join estados e on(e.idestado=m.idestado)
        inner join paises pa on(pa.idpais=e.idpais)
-----SE AGREGO JOIN CON TRABAJOS PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS
        left  join trabajo tr on ax.idorigen = tr.idorigen and ax.idgrupo = tr.idgrupo and ax.idsocio = tr.idsocio AND tr.consecutivo = 1
        where ax.idsocio is not null 
        group by p.idorigen, p.idgrupo, p.idsocio,p.nacionalidad,p.razon_social,p.nivel_riesgo,e.idestado, peps, p.pais_nacimiento,tr.actividad_economica_pld) ope
        group by tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia--, espep
        , nacion,actividad_economica) aa
loop

r.anio                                    :=amo;
r.clave_formulario                        :='A1';
r.clave_de_entidad                        :=clave_enti;
r.tipo_cliente_o_usuario                  :=trim(to_char(r_paso.tipo_clien_usua,'99'))||' ';--||r_paso.espep;
r.clasificacion_grado_riesgo              :=trim(to_char(r_paso.clasi_grado_riesgo,'9'));
r.pais_nacionalidad                       :=r_paso.nacion;
r.pais_residencia                         :=r_paso.nacion;

r.entidad_federativa_residencia           :=trim(to_char(r_paso.enti_fede_residencia,'99'));
-----SE AGREGO LA ACTVIVIDAD ECONOMICA PLD PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS
r.actividad_economica                     := CASE WHEN r_paso.actividad_economica IS NULL OR
                                                       r_paso.actividad_economica = ''
                                                  THEN '00000000'
                                                  ELSE trim(to_char(r_paso.actividad_economica::numeric,'999999999'))
                                              END;                                             


r.numero_total_clientes                   :=trim(to_char(r_paso.num_total_clien_usua::integer,'99999999999999999'));

INSERT INTO  a1_cuestionario_operatividad  VALUES (
 r.anio,                                                                 
 r.clave_formulario,                                                       
 r.clave_de_entidad,                                                  
 r.tipo_cliente_o_usuario,                                 
 r.clasificacion_grado_riesgo,                                             
 r.pais_nacionalidad,                                          
 r.pais_residencia,                                                         
 r.entidad_federativa_residencia,                                            
 r.actividad_economica,                                                 
 r.numero_total_clientes                                      
 --paso.espep                                                                            
 );

return next r;

insert into copiar values(y,
    coalesce(r.anio                                                   ::text,'')||'|'||
    coalesce(r.clave_formulario                                       ::text,'')||'|'||
    coalesce(r.clave_de_entidad                                       ::text,'')||'|'||
    coalesce(r.tipo_cliente_o_usuario                                 ::text,'')||'|'||
    coalesce(r.clasificacion_grado_riesgo                             ::text,'')||'|'||
    coalesce(r.pais_nacionalidad                                      ::text,'')||'|'||
    coalesce(r.pais_residencia                                        ::text,'')||'|'||
    coalesce(r.entidad_federativa_residencia                          ::text,'')||'|'||
-----SE AGREGO LA ACTVIVIDAD ECONOMICA PLD PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS
    coalesce(r.actividad_economica                                    ::text,'00000000')||'|'||
    coalesce(r.numero_total_clientes                                  ::text,''));

end loop;

  select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
  execute 'copy (select fila from copiar order by id) to ''/tmp/formularioA1_con_encabezados_'||fecha||'.csv''';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/formularioA1_sin_encabezados_'||fecha||'.csv''';

end;
$$ language 'plpgsql';


-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO A1
-----------------------------------------------------------

