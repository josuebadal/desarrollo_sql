DROP TYPE IF EXISTS numero_de_socios_de_la_entidad CASCADE;
CREATE TYPE numero_de_socios_de_la_entidad as (
anio                                       text,
clave_formulario                           text,
clave_de_entidad		                   integer,
tipo_cliente_o_usuario	                   varchar,--integer,
clasificacion_grado_riesgo                 integer,
pais_nacionalidad                          integer,
pais_residencia                            integer,
entidad_federativa_residencia              integer,
numero_total_clientes                      integer);

CREATE OR REPLACE FUNCTION numero_total_de_socios_por_la_entidad (integer,integer)
RETURNS SETOF numero_de_socios_de_la_entidad as $$
 DECLARE
 r               numero_de_socios_de_la_entidad%rowtype;
 clave_enti      alias for $1; 
 amo             alias for  $2;
 p_inicial       integer; -- // periodo Inicial ej. 202001
 p_final         integer; -- //  periodo final ej. 202012
 r_aux           record;
 r_paso          record;
 r_perso         record;
 y               integer;
 fecha           varchar;
 w integer;
 z integer;

 begin

DROP table IF EXISTS copiar;
CREATE temp table copiar(
	id    integer,
	fila  text);
y:=0;
insert into copiar values(y,'anio;clave_formulario;clave_de_entidad;tipo_cliente_o_usuario;clasificacion_grado_riesgo;pais_nacionalidad;pais_residencia;entidad_federativa_residencia;numero_total_clientes');
y:=1;

p_inicial :=(amo||'01')::integer;
p_final   :=(amo||'12')::integer;

w:=0;
z:=0;








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

------------------------------------------------------------------------------------------------------------------------
------------------------------TABLAS PARA OBTENER LOS SOCIOS PEP
------------------------------------------------------------------------------------------------------------------------



drop table if exists temp_pfae;
create local temp table temp_pfae as
  select distinct idorigen, idgrupo, idsocio
  from negociopropio where act_empresarial;
create index temp_pfae_pkey on temp_pfae (idorigen, idgrupo, idsocio);
raise notice 'Se genero la tabla temp_pfae';
-----
-----Ver como meter esta busqueda a r_paso para obtener si cada usuario entra en PEP o No
-----
-----
/*select into w count(*) from peps_qeq_historial_busquedas_web 
where idorigen = p_idorigen and idgrupo = p_idgrupo and idsocio = p_idsocio;
if not found or w is NULL then w := 0; end if;

if w > 0 then

  select into z count(*)
  from peps_qeq_identificado_web i inner join peps_qeq_catalogo_web c using (id_persona)
  where i.idorigen = p_idorigen and i.idgrupo = p_idgrupo and i.idsocio = p_idsocio and lista = 'PPE'
  limit 1;
  if not found or z is NULL then z := 0; end if;

  if z > 0 then persona_pep := TRUE; end if;
end if;*/

for r_paso in select * from
			  (select tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia,sum(num_total_clien_usua) as num_total_clien_usua, nacion, espep from
			  (select
				
				(	
					(case when peps = 1 then 15
					      else 
					      	(case when (select count(*) from temp_pfae
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
					 end)
				  /*case when peps =1 then 15
					else 1
					end*/
					
					/*case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
					  when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
					  when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 1   3
					  when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
									  end*/) as tipo_clien_usua,

				(case when p.nivel_riesgo = 1 then 1
					  when p.nivel_riesgo = 2 then 5
				else 1
				      end) as clasi_grado_riesgo,
				
				count(*) as num_total_clien_usua,


-----------------------------
----- Buscar si el socio entra en la categoria pep
-----------------------------


				(case when peps=1 then 'PEP'
				       else ' '
				       end) as espep,
-------------------------------
-------------------------------



				(case when e.idestado= 7 then 5 else e.idestado end) as enti_fede_residencia,

				(case when p.pais_nacimiento=2 and p.nacionalidad  = 3 then  '3'--afganistan
					  when p.pais_nacimiento=1  and p.nacionalidad  = 3 then  '157'--México
					  when p.pais_nacimiento=61  and p.nacionalidad  = 3 then  '67'--EUA
					  when p.pais_nacimiento=70  and p.nacionalidad  = 3 then  '76'--Georgia
					  else  '157' end) as nacion


					


				from personas p
				join tmp_act_peps ac using (idorigen, idgrupo, idsocio)
				left join (select * from auxiliares where idproducto = 101 and saldo = 1000
							union all 
					   	   select * from auxiliares where idproducto=120 and saldo>0) as ax 
					using (idorigen,idgrupo,idsocio)
				inner join colonias c on(c.idcolonia=p.idcolonia) 
				inner join municipios m on(m.idmunicipio=c.idmunicipio) 
				inner join estados e on(e.idestado=m.idestado)
				inner join paises pa on(pa.idpais=e.idpais)
				where ax.idsocio is not null and p.idgrupo IN (10,20)
				group by idorigen, idgrupo, idsocio, p.nacionalidad,p.razon_social,p.nivel_riesgo,e.idestado,p.pais_nacimiento,peps) ope
			  group by tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia,nacion,espep) aa
loop

r.anio                                    :=amo;
r.clave_formulario                        :='A1';
r.clave_de_entidad                        :=clave_enti;
r.tipo_cliente_o_usuario                  :=trim(to_char(r_paso.tipo_clien_usua,'99')) ||' '||r_paso.espep;
r.clasificacion_grado_riesgo              :=trim(to_char(r_paso.clasi_grado_riesgo,'9'));
r.pais_nacionalidad                       :=r_paso.nacion;
r.pais_residencia                         :=157;
r.entidad_federativa_residencia           :=trim(to_char(r_paso.enti_fede_residencia,'99'));
r.numero_total_clientes                   :=trim(to_char(r_paso.num_total_clien_usua,'99999999999999999'));

return next r;

insert into copiar values(y,
		coalesce(r.anio                                                   ::text,'')||';'||
		coalesce(r.clave_formulario                                       ::text,'')||';'||
		coalesce(r.clave_de_entidad                                       ::text,'')||';'||
		coalesce(r.tipo_cliente_o_usuario                                 ::text,'')||';'||
		coalesce(r.clasificacion_grado_riesgo                             ::text,'')||';'||
		coalesce(r.pais_nacionalidad                                      ::text,'')||';'||
		coalesce(r.pais_residencia                                        ::text,'')||';'||
		coalesce(r.entidad_federativa_residencia                          ::text,'')||';'||
		coalesce(r.numero_total_clientes                                  ::text,''));

end loop;

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
	execute 'copy (select fila from copiar order by id) to ''/tmp/A1_con_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/A1_sin_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';

end;
$$ language 'plpgsql';
