drop type if exists numero_operaciones_producto_servicio_por_moneda_instmonetario cascade;
create type numero_operaciones_producto_servicio_por_moneda_instmonetario as (
	anio     							integer,
	clave_formulario 					text,
	clave_entidad 						text,
	producto_servicio 					integer,
	tipo_moneda 						integer,
	tipo_instrumento_monetario 			integer,
	operac_entr_salida					integer,
	numero_operaciones                  integer,  
	monto_operaciones					integer
);

create or replace function numero_operaciones_producto_servicio (integer,integer)
	returns setof numero_operaciones_producto_servicio_por_moneda_instmonetario as $$
	declare
	r 			numero_operaciones_producto_servicio_por_moneda_instmonetario%rowtype;
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
	insert into copiar values(y,'anio;clave_formulario;clave_entidad;producto_servicio;tipo_moneda;tipo_instrumento_monetario;operac_entr_salida;numero_operaciones;monto_operaciones');
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
		(select ad.cargoabono, (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as monto_operaciones,
		        ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.ticket,
                aux.idorigen,aux.idgrupo,aux.idsocio, te.idcuestionario
		  from auxiliares_d ad 
		 inner join auxiliares aux using(idorigenp, idproducto, idauxiliar)
		 inner join temp_productos te using(idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final
		 UNION 
		 select ad.cargoabono, (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as monto_operaciones,
		        ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.ticket,
               aux.idorigen,aux.idgrupo,aux.idsocio, te.idcuestionario
		 from auxiliares_d_h ad 
		 inner join auxiliares_h aux using(idorigenp, idproducto, idauxiliar)
		 inner join temp_productos te using(idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final
		 );

		/*CREATE INDEX index_temp_auxi
		ON temp_auxi (idorigenp,idproducto,idauxiliar);*/
	raise notice 'Se genero la tabla temp_auxi';



drop table if exists temp_ser;
	create temp table temp_ser as 
		(select sd.cargoabono, (sd.monto + sd.montoiva) as monto_operaciones,
		        sd.idorigenc,sd.periodo,sd.idtipo,sd.idpoliza,sd.ticket,
				sd.idorigen,sd.idgrupo,sd.idsocio, te.idcuestionario 
		   from servicios_d sd 
		inner join temp_productos te using(idproducto)
		 where tipomov = 0 and idtipo in (1,2) and periodo:: integer between p_inicial and p_final);

	for r_prod
	in  select   *
		from     tablas
		where    idtabla = 'cuestionario_opera_cnbv2023'
		order by idelemento::integer
	loop

	raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

	IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '') THEN

	for r_paso in 
	(select insm, sum(entradas_monto+salidas_monto) monto_entr_sali, sum(entradas_numero+salidas_numero) num_entr_sali,tipo_oper
	 from (select (case when cargoabono=0 THEN monto_operaciones else 0 end) salidas_monto,
				  (case when cargoabono=1 THEN monto_operaciones else 0 end) entradas_monto,
				  (case when cargoabono=0 THEN numero_operaciones else 0 end) salidas_numero,
				  (case when cargoabono=1 THEN numero_operaciones else 0 end) entradas_numero,
				  (case when cargoabono=0 then 2
				    	when cargoabono=1 then 1 end) tipo_oper,
				  insm 
		   from (select insm,cargoabono,count(*) numero_operaciones,sum(monto_operaciones) monto_operaciones 
				 from (select --(case when ad.idtipo=3 then 8 /*Traspaso de Fondos*/
									--when ad.ticket = de.ticket and de.monto_tj > 0  then 10 /*Pagarés (incluye tarjeta de crédito o débito)*/
									--when ad.ticket = de.ticket and de.monto_ch > 0  then 2 /*Cheques Nominativo o al Portador girado en territorio nacional*/
									--else 1 /*Efectivo*/ end) 
							   1 as insm,
							   ad.cargoabono,
							   monto_operaciones
					   from (select * from temp_auxi
					   		union 
					   		select * from temp_ser) ad 
					   left join detalle_ie as de on ((de.idorigenc,de.periodo,de.idtipo,de.idpoliza,de.ticket)=
													  (ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.ticket) and 
													   de.ogs=ad.idorigen||'-'||ad.idgrupo||'-'||ad.idsocio)
					   where r_prod.idelemento::integer = ad.idcuestionario) ax 
				 group by insm,cargoabono) aux) mont_num 
	 group by insm,tipo_oper
	 order by insm,tipo_oper) 

	loop

	r.anio  							:= trim(to_char(perio,'9999'));
	r.clave_formulario 					:= 'B';
	r.clave_entidad 					:= clave_ent;
	r.producto_servicio 				:= trim(to_char(r_prod.idelemento::numeric,'99'));
	r.tipo_moneda 						:= '1';
	r.tipo_instrumento_monetario 		:= trim(to_char(r_paso.insm::numeric,'99'));
	r.operac_entr_salida                := r_paso.tipo_oper;
	r.numero_operaciones                := trim(to_char(r_paso.num_entr_sali,'99999999999999999'));
	r.monto_operaciones                 := trim(to_char(r_paso.monto_entr_sali,'99999999999999999'));

	return next r;

	insert into copiar values(y,
		coalesce(r.anio 							::text,'')||';'||
		coalesce(r.clave_formulario 				::text,'')||';'||
		coalesce(r.clave_entidad 					::text,'')||';'||
		coalesce(r.producto_servicio 				::text,'')||';'||
		coalesce(r.tipo_moneda 						::text,'')||';'||
		coalesce(r.tipo_instrumento_monetario 		::text,'')||';'||
		coalesce(r.operac_entr_salida    			::text,'')||';'||
		coalesce(r.numero_operaciones           	::text,'')||';'||
		coalesce(r.monto_operaciones    			::text,''));

	end loop;

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
	execute 'copy (select fila from copiar order by id) to ''/tmp/B_con_encabezados_'||fecha||'.csv''  ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/B_sin_encabezados_'||fecha||'.csv''  ';

	end IF;
	end loop;
	return;
	end;
$$ language 'plpgsql';
