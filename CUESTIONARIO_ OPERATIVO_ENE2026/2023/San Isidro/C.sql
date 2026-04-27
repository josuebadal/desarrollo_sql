DROP TYPE IF EXISTS numero_de_cleintes_de_la_entidad CASCADE;
CREATE TYPE numero_de_cleintes_de_la_entidad as (
anio                                       text,
clave_del_formulario                       text,
clave_de_entidad		                   integer,
producto_servicio 					       integer,
pais_origen_envio_de_los_recursos          integer,
entrada_federativa                         integer,
operacion_entrada_salida                   integer,
numero_operaciones_entrada_salida          integer,
monto_de_operaciones_de_entrada_Salida     numeric

);

CREATE OR REPLACE FUNCTION numero_total_de_clientes_de_la_entidad (integer,integer)
RETURNS SETOF numero_de_cleintes_de_la_entidad as $$
 DECLARE
 r               numero_de_cleintes_de_la_entidad%rowtype;
 clave_enti      alias for $1; 
 amo             alias for  $2;
 p_inicial       integer; -- // periodo Inicial ej. 202001
 p_final         integer; -- //  periodo final ej. 202012
 r_origenes      record;
 r_paso          record;
 r_perso         record;
 r_prod          record;
 r_paso_pro      record;
 rec             record;
 y               integer;
 fecha           varchar;

 begin

DROP table IF EXISTS copiar;
CREATE temp table copiar(
	id    integer,
	fila  text);
y:=0;
insert into copiar values(y,'anio;clave_del_formulario;clave_de_entidad;producto_servicio;pais_origen_envio_de_los_recursos;entrada_federativa;operacion_entrada_salida;numero_operaciones_entrada_salida;monto_de_operaciones_de_entrada_Salida');
y:=1;

p_inicial :=(amo||'01')::integer;
p_final   :=(amo||'12')::integer;


	drop table if exists temp_productos;
	create temp table temp_productos (idcuestionario integer, idproducto integer);
		FOR rec in  select * from tablas 
					where  idtabla = 'cuestionario_opera_cnbv2023' 
					order by idelemento::integer
	loop
		FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
		loop
			if (r_paso_pro.idprodu <> '') then
				insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
			end if;
		end loop;
	end loop;


	drop table if exists temp_auxi;
	create temp table temp_auxi as 
		(select ad.cargoabono, (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as  monto_operaciones,
		        ad.idorigenp, te.idcuestionario
		 from auxiliares_d ad
		 inner join temp_productos te using (idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final
		 UNION ALL
		 select ad.cargoabono, (ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim) as  monto_operaciones,
		        ad.idorigenp, te.idcuestionario
		 from auxiliares_d_h ad
		 inner join temp_productos te using (idproducto)
		 where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final);
	raise notice 'Se genero la tabla temp_auxi';


	drop table if exists temp_ser;
	create temp table temp_ser as 
		(select sd.cargoabono, (sd.monto + sd.montoiva) as monto_operaciones,
		        idorigenc, te.idcuestionario 
		   from servicios_d sd 
		  inner join temp_productos te using(idproducto)
		  where tipomov = 0 and idtipo in (1,2) and periodo:: integer between p_inicial and p_final);
	raise notice 'Se genero la tabla temp_ser';

	for r_origenes 
	in  select distinct o.idestado
	from origenes o
	where matriz <>0 
	order by idestado

	loop

	for r_prod
	in  select   *
		from     tablas
		where    idtabla = 'cuestionario_opera_cnbv2023'
		order by idelemento::integer

	loop

	raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

	IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '') THEN

	for r_paso in
	(select count(*) as num_oper_entrada_salida,
	sum(monto_operaciones) as monto_oper_entrada_salida,
	(case when a.cargoabono=0 then 2
		when a.cargoabono=1 then 1 end) as flujo_entrada_salida
	from (select * from temp_auxi union all select * from temp_ser) a
	where (select distinct idestado from origenes where idorigen=a.idorigenp)=r_origenes.idestado
	and r_prod.idelemento::integer = a.idcuestionario
	group by flujo_entrada_salida)

	loop

	r.anio                                      :=trim(to_char(amo,'9999'));
	r.clave_del_formulario                      :='C';
	r.clave_de_entidad		                    :=clave_enti;
	r.producto_servicio 			            :=r_prod.idelemento;
	r.pais_origen_envio_de_los_recursos         :='157';
	r.entrada_federativa                        :=(case when r_origenes.idestado=7 then 5 else r_origenes.idestado end);
	r.operacion_entrada_salida                  :=r_paso.flujo_entrada_salida;
	r.numero_operaciones_entrada_salida         :=trim(to_char(r_paso.num_oper_entrada_salida,'99999999999999999'));
	r.monto_de_operaciones_de_entrada_Salida    :=trim(to_char(r_paso.monto_oper_entrada_salida::numeric,'99999999999999999'));

	return next r;

	insert into copiar values(y,
	coalesce(r.anio                                                   ::text,'')||';'||
	coalesce(r.clave_del_formulario                                   ::text,'')||';'||
	coalesce(r.clave_de_entidad                                       ::text,'')||';'||
	coalesce(r.producto_servicio                                      ::text,'')||';'||
	coalesce(r.pais_origen_envio_de_los_recursos                      ::text,'')||';'||
	coalesce(r.entrada_federativa                                     ::text,'')||';'||
	coalesce(r.operacion_entrada_salida                               ::text,'')||';'||
	coalesce(r.numero_operaciones_entrada_salida                      ::text,'')||';'||
	coalesce(r.monto_de_operaciones_de_entrada_Salida                 ::text,''));

	end loop;

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');

	execute 'copy (select fila from copiar order by id) to ''/tmp/C_con_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/C_sin_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';

	end IF;
	end loop;
	end loop;
	return;
	end;
$$ language 'plpgsql';
