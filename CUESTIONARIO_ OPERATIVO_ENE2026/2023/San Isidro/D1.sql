drop type if exists numero_operaciones_producto_servicio_por_canal_envio cascade;
create type numero_operaciones_producto_servicio_por_canal_envio as (
	anio     							integer,
	clave_formulario 					text,
	clave_entidad 						text,
	producto_servicio 					integer,
	tipo_canal 							integer,
	operacion_entrada_salida            integer,
	num_operaciones 					integer,
	monto_operaciones 					varchar
);

create or replace function numero_operaciones_producto_por_canal (integer,integer)
	returns setof numero_operaciones_producto_servicio_por_canal_envio as $$
	declare
	r 			numero_operaciones_producto_servicio_por_canal_envio%rowtype;
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
	insert into copiar values(y,'anio;clave_formulario;clave_entidad;producto_servicio;tipo_canal;operacion_entrada_salida;num_operaciones;monto_operaciones');
	y:=1;

	drop table if exists temp_productos;
	create temp table temp_productos (idcuestionario integer, idproducto integer);
		FOR rec in  select * from tablas
					where idtabla = 'cuestionario_opera_cnbv2023'
					order by idelemento::integer
	loop
		FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
		loop
			if(r_paso_pro.idprodu <> '') then
				insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
			end if;
		end loop;
	end loop;

	drop table if exists temp_auxi;
	create temp table temp_auxi as 
		(select ad.cargoabono,
		        (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as monto_operaciones,
		        ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,
		        ad.idorigenp, te.idcuestionario
		 from auxiliares_d ad 
		 inner join temp_productos te using(idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final
		 UNION ALL 
		 select ad.cargoabono,
		        (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as monto_operaciones,
		        ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza, 
		        ad.idorigenp, te.idcuestionario
		 from auxiliares_d_h ad 
		 inner join temp_productos te using(idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final);

		--CREATE INDEX index_temp_auxi
		--ON temp_auxi (idorigenp,idproducto,idauxiliar);
	raise notice 'Se genero la tabla temp_auxi';

	drop table if exists temp_ser;
	create temp table temp_ser as 
		(select sd.cargoabono, (sd.monto + sd.montoiva) as monto_operaciones,
		        sd.idorigenc,sd.periodo,sd.idtipo,sd.idpoliza,
		        0 as idorigenp, te.idcuestionario 
		   from servicios_d sd 
		  inner join temp_productos te using(idproducto)
		  where tipomov = 0 and idtipo in (1,2) and periodo:: integer between p_inicial and p_final);
	raise notice 'Se genero la tabla temp_ser';

	for r_prod
	in  select   *
		from     tablas
		where    idtabla = 'cuestionario_opera_cnbv2023'
		order by idelemento::integer
	loop

	raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

	IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '') THEN

	for r_paso in 
	(select canal,count(*) numero_operaciones,sum(monto_operaciones) monto_operaciones ,flujo_entrada_salida
				 from (select (case when ad.idtipo = 3 and ad.cargoabono=1 and (po.concepto = 'Traspaso Cuentas Propias Mitras Movil' 
															or po.concepto = 'Traspaso Cuentas Terceros Mitras Movil') then 7 /*Banca Móvil*/
									else 1 /*Ventanilla (sucursales, agencias u oficinas)*/ end) as canal,
							  ad.monto_operaciones,
							  (case when ad.cargoabono=0 then 2
									when ad.cargoabono=1 then 1 end) as flujo_entrada_salida
					   from (select * from temp_auxi union all select * from temp_ser) ad 
					   inner join polizas as po using (idorigenc, periodo, idtipo, idpoliza)
					   where r_prod.idelemento::integer = ad.idcuestionario) ax 
				 group by canal,flujo_entrada_salida
				 order by canal,flujo_entrada_salida)

	loop

	r.anio  							:= trim(to_char(perio,'9999'));
	r.clave_formulario 					:= 'D1';
	r.clave_entidad 					:= clave_ent;
	r.producto_servicio 				:= trim(to_char(r_prod.idelemento::numeric,'99'));
	r.tipo_canal 						:= trim(to_char(r_paso.canal::numeric,'99'));
	r.operacion_entrada_salida			:= r_paso.flujo_entrada_salida;
	r.num_operaciones 					:= trim(to_char(r_paso.numero_operaciones::numeric,'99999999999999999'));
	r.monto_operaciones 				:= trim(to_char(r_paso.monto_operaciones::numeric,'99999999999999999'));

	return next r;

	insert into copiar values(y,
		coalesce(r.anio 							::text,'')||';'||
		coalesce(r.clave_formulario 				::text,'')||';'||
		coalesce(r.clave_entidad 					::text,'')||';'||
		coalesce(r.producto_servicio 				::text,'')||';'||
		coalesce(r.tipo_canal 						::text,'')||';'||
		coalesce(r.operacion_entrada_salida         ::text,'')||';'||
		coalesce(r.num_operaciones 					::text,'')||';'||
		coalesce(r.monto_operaciones 				::text,''));

	end loop;

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
	execute 'copy (select fila from copiar order by id) to ''/tmp/D1_con_encabezados_'||fecha||'.csv''  ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/D1_sin_encabezados_'||fecha||'.csv''  ';

	end IF;
	end loop;
	return;
	end;
$$ language 'plpgsql';
