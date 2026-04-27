drop type if exists numero_clientes_usuarios_operaron_periodo cascade;
create type numero_clientes_usuarios_operaron_periodo as (
	anio 							integer,
	clave_formulario 					text,
	clave_entidad 						text,
	producto_servicio 					integer,
	tipo_cliente_usuario 				integer,
	clasificacion_grado_riesgo 			integer,
	numero_clientes_usuarios 			integer
);

create or replace function numero_clientes_usuarios_operaron (integer,integer)
	returns setof numero_clientes_usuarios_operaron_periodo as $$
	declare
	r 			numero_clientes_usuarios_operaron_periodo%rowtype;
	clave_ent 	alias for $1;
	perio 		alias for $2;
	p_inicial 	integer;
	p_final 	integer;
	r_prod 		record;
	r_paso		record;
	rec 		record;
	r_paso_pro	record;
	y 			integer;
	fecha 		varchar;

	begin

	p_inicial 	:=(perio||'01')::integer;
	p_final 	:=(perio||'12')::integer;

	DROP table IF EXISTS copiar;
	CREATE temp table copiar(
		id    integer,
		fila  text);
	y:=0;
	insert into copiar values(y,'anio;clave_formulario;clave_entidad;producto_servicio;tipo_cliente_usuario;clasificacion_grado_riesgo;numero_clientes_usuarios');
	y:=1;

	drop table if exists temp_productos;
     create temp table temp_productos (idcuestionario integer, idproducto integer);
       FOR rec in  select * from tablas where  idtabla = 'cuestionario_opera_cnbv2023' order by idelemento::integer
       loop
           FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
           loop
               if (r_paso_pro.idprodu <> '') then
                   insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
               end if;
           end loop;
       end loop;
     
     drop table if exists temp_auxi;
     create temp table temp_auxi as (select distinct idorigen, idgrupo, idsocio, idcuestionario
                                       from (select a.idorigen, a.idgrupo, a.idsocio, te.idcuestionario 
                                       		  from auxiliares_d ad
                                              inner join auxiliares a using (idorigenp, idproducto, idauxiliar)
                                              inner join temp_productos te using (idproducto)
                                              where ad.tipomov = 0 and ad.periodo:: integer between p_inicial and p_final
                                             UNION
                                             select a.idorigen, a.idgrupo, a.idsocio, te.idcuestionario 
                                              from auxiliares_d_h ad
                                              inner join auxiliares_h a using (idorigenp, idproducto, idauxiliar)
                                              inner join temp_productos te using (idproducto)
                                              where ad.tipomov = 0 and ad.periodo:: integer between p_inicial and p_final) as f 
                                     group by idorigen, idgrupo, idsocio, idcuestionario);
     raise notice 'Se genero la tabla temp_auxi';

	for r_prod
	in  select   *
      from     tablas
      where    idtabla = 'cuestionario_opera_cnbv2023'
      order by idelemento::integer
	loop

	raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

	IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '') THEN

	for r_paso in (select * from (select count(*) as num_cli, tipoc, nries
						from (select (case when p.nacionalidad != 3 and (p.razon_social is NULL or p.razon_social = '') then 1
										   when p.nacionalidad != 3 and (p.razon_social is not NULL and p.razon_social != '')then 2
										   when p.nacionalidad  = 3 and (p.razon_social is NULL or p.razon_social = '') then 1 /*3*/
										   when p.nacionalidad  = 3 and (p.razon_social is not NULL and p.razon_social != '')then 4
									  end) tipoc,
									 (case when p.nivel_riesgo = 1 then 1
									 	   when p.nivel_riesgo = 2 then 5
									 	   else 3
									  end) nries
							  from temp_auxi a 
							  inner join personas p using (idorigen,idgrupo,idsocio)
							  where a.idcuestionario = r_prod.idelemento::integer)too 
						group by tipoc,nries
						order by tipoc) aa)
	loop
	
	r.anio 		     					:= perio;
	r.clave_formulario 					:= 'A2';
	r.clave_entidad 					:= clave_ent;
	r.producto_servicio 				:= r_prod.idelemento;
	r.tipo_cliente_usuario 				:= r_paso.tipoc;
	r.clasificacion_grado_riesgo 		:= r_paso.nries;
	r.numero_clientes_usuarios 			:= r_paso.num_cli;

	return next r;

	insert into copiar values(y,
		coalesce(r.anio 							::text,'')||';'||
		coalesce(r.clave_formulario 				::text,'')||';'||
		coalesce(r.clave_entidad 					::text,'')||';'||
		coalesce(r.producto_servicio 				::text,'')||';'||
		coalesce(r.tipo_cliente_usuario 			::text,'')||';'||
		coalesce(r.clasificacion_grado_riesgo 		::text,'')||';'||
		coalesce(r.numero_clientes_usuarios 		::text,''));

	end loop;

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
	execute 'copy (select fila from copiar order by id) to ''/tmp/A2_con_encabezados_'||fecha||'.csv''  ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/A2_sin_encabezados_'||fecha||'.csv''  ';

	end IF;
	end loop;
	return;
	end;
$$ language 'plpgsql';
