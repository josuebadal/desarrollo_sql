drop type if exists numero_clientes_aperturaron_cuenta_por_canal_envio cascade;
create type numero_clientes_aperturaron_cuenta_por_canal_envio as (
	anio    							integer,
	clave_formulario 					text,
	clave_entidad 						text,
	tipo_canal 							integer,
	num_clientes_aper 					integer
);

create or replace function numero_clientes_aperturaron_cuenta_por_canal (integer,integer)
	returns setof numero_clientes_aperturaron_cuenta_por_canal_envio as $$
	declare
	r 			numero_clientes_aperturaron_cuenta_por_canal_envio%rowtype;
	clave_ent 	alias for $1;
	perio 		alias for $2;
	p_inicial 	integer;
	p_final 	integer;
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
	insert into copiar values(y,'anio;clave_formulario;clave_entidad;tipo_canal;num_clientes_aper');
	y:=1;

	/*drop table if exists temp_productos;
	create temp table temp_productos (idcuestionario integer, idproducto integer);
		FOR rec in  select * from tablas
					where idtabla = 'cuestionario_opera_cnbv2021'
					order by idelemento::integer
	loop
		FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
		loop
			if(r_paso_pro.idprodu <> '') then
				insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
			end if;
		end loop;
	end loop;*/

	/*drop table if exists temp_auxi;
	create temp table temp_auxi as 
		(select a.*, te.idcuestionario
		 from auxiliares a
		 inner join temp_productos te using (idproducto)
		 where to_char(date(a.fechaape),'YYYYMM'):: integer between p_inicial and p_final
		 UNION
		 select a.*, te.idcuestionario
		 from auxiliares_h a
		 inner join temp_productos te using (idproducto)
		 where to_char(date(a.fechaape),'YYYYMM'):: integer between p_inicial and p_final);

		 		 

		CREATE INDEX index_temp_auxi
		ON temp_auxi (idorigenp,idproducto,idauxiliar);
	raise notice 'Se genero la tabla temp_auxi';*/

	select into r_paso sum(ts.total) as total_cli
			from(
			select count(*) as total
			from auxiliares_d ad
			where ad.idproducto=101 
			and ad.monto=1000 
			and ad.cargoabono=1 
			and to_char(date(ad.fecha),'YYYYMM'):: integer between p_inicial and p_final) as ts;

	r.anio  							:= trim(to_char(perio,'9999'));
	r.clave_formulario 					:= 'D2';
	r.clave_entidad 					:= clave_ent;
	r.tipo_canal 						:= '1';
	r.num_clientes_aper 				:= trim(to_char(r_paso.total_cli::numeric,'99999999999999999'));

	return next r;

	insert into copiar values(y,
		coalesce(r.anio 							::text,'')||';'||
		coalesce(r.clave_formulario 				::text,'')||';'||
		coalesce(r.clave_entidad 					::text,'')||';'||
		coalesce(r.tipo_canal 						::text,'')||';'||
		coalesce(r.num_clientes_aper 				::text,''));

	select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
	execute 'copy (select fila from copiar order by id) to ''/tmp/D2_con_encabezados_'||fecha||'.csv''  ';
	execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/D2_sin_encabezados_'||fecha||'.csv''  ';

	end;
$$ language 'plpgsql';
