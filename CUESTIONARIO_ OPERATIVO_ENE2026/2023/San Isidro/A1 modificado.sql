DROP TYPE IF EXISTS numero_de_socios_de_la_entidad CASCADE;
CREATE TYPE numero_de_socios_de_la_entidad as (
anio                                       text,
clave_formulario                           text,
clave_de_entidad		                   integer,
tipo_cliente_o_usuario	                   integer,
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

for r_paso in select * from
			  (select tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia,sum(num_total_clien_usua) as num_total_clien_usua from
			  (select
				(case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
					  when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
					  when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 1 /*3*/
					  when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
									  end) as tipo_clien_usua,
				(case when p.nivel_riesgo = 1 then 1
					  when p.nivel_riesgo = 2 then 5
				else 3
				      end) as clasi_grado_riesgo,
				count(*) as num_total_clien_usua,
				(case when e.idestado= 7 then 5 else e.idestado end) as enti_fede_residencia
				from personas p
				left join (select * from auxiliares where idproducto = 101 and saldo = 1000
							union all 
					   	   select * from auxiliares where idproducto=120 and saldo>0) as ax 
					using (idorigen,idgrupo,idsocio)
				inner join colonias c on(c.idcolonia=p.idcolonia) 
				inner join municipios m on(m.idmunicipio=c.idmunicipio) 
				inner join estados e on(e.idestado=m.idestado)
				inner join paises pa on(pa.idpais=e.idpais)
				where ax.idsocio is not null and p.idgrupo=10
				group by p.nacionalidad,p.razon_social,p.nivel_riesgo,e.idestado) ope
			  group by tipo_clien_usua,clasi_grado_riesgo,enti_fede_residencia) aa
loop

r.anio                                    :=amo;
r.clave_formulario                        :='A1';
r.clave_de_entidad                        :=clave_enti;
r.tipo_cliente_o_usuario                  :=trim(to_char(r_paso.tipo_clien_usua,'99'));
r.clasificacion_grado_riesgo              :=trim(to_char(r_paso.clasi_grado_riesgo,'9'));
r.pais_nacionalidad                       :=157;
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
