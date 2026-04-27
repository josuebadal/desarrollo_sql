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
entidad_federativa_residencia              varchar,
actividad_economica                        varchar, -- AGREGADO 2026
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
        (select tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia,sum(num_total_clien_usua) as num_total_clien_usua,espep,nacion, actividad_economica from
        (select
        /*(case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
            when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
            when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 1 */
        /*    when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
                    end) as tipo_clien_usua,*/
        (case when peps = 1 then 15
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
         end) as tipo_clien_usua, ----------DATO 4
        (case when p.nivel_riesgo = 1 then 1
                      when p.nivel_riesgo = 2 then 5
                      --when p.nivel_riesgo = 3 then 5
                            else 1
                end) as clasi_grado_riesgo, ----------DATO 5
        count(*) as num_total_clien_usua, ----------DATO 10
        -----ESTE DATO SE FORMA ACORDE A LO ENVIADO POR LA BANCARIA NO POR LA TABLA ESTADOS
        (CASE 
              WHEN e.idestado = '7' THEN '5'
        ELSE '7'
        END )as enti_fede_residencia, ----------DATO 8

        (case when p.pais_nacimiento=2 and p.nacionalidad  = 3 then  '3'--afganistan
					  when p.pais_nacimiento=1  and p.nacionalidad  = 3 then  '157'--México
					  when p.pais_nacimiento=61  and p.nacionalidad  = 3 then  '67'--EUA
					  when p.pais_nacimiento=70  and p.nacionalidad  = 3 then  '76'--Georgia
					  else  '157' end) as nacion, ----------DATO 6

        (case when peps=1 then 'PEP'
               else ' '
               end) as espep,
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
        group by tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia, espep, nacion,actividad_economica) aa
loop

r.anio                                    :=amo;
r.clave_formulario                        :='A1';
r.clave_de_entidad                        :=clave_enti;
r.tipo_cliente_o_usuario                  :=trim(to_char(r_paso.tipo_clien_usua,'09'))||' '||r_paso.espep;
r.clasificacion_grado_riesgo              :=trim(to_char(r_paso.clasi_grado_riesgo,'9'));
r.pais_nacionalidad                       :=r_paso.nacion;
r.pais_residencia                         :=157;

r.entidad_federativa_residencia           :=r_paso.enti_fede_residencia;
-----SE AGREGO LA ACTVIVIDAD ECONOMICA PLD PARA SU GENERACION EN LAS BASES DIC 2025 DE LAS COOPERATIVAS
r.actividad_economica                     := CASE WHEN r_paso.actividad_economica IS NULL OR
                                                       r_paso.actividad_economica = ''
                                                  THEN '00000000'
                                                  ELSE trim(to_char(r_paso.actividad_economica::numeric,'09999999999999999'))
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