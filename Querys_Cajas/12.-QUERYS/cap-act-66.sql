DROP FUNCTION public.query24() CASCADE;

-- public.query24 definition
-- DROP TYPE public.query24;

CREATE TYPE public.query24 AS (
	socio text,
	nom_socio text,
	folio text,
	correo text,
	fecha_vencimiento date,
	capturo text,
	monto text);


-- DROP FUNCTION public.query24();

CREATE OR REPLACE FUNCTION public.query24()
 RETURNS SETOF query24
 LANGUAGE plpgsql
AS $function$
	Declare
	query1			text;
	query2          text;
	r 				query24%rowtype;
	r2 				query24%rowtype;
	r_query 		record;
	r_query2		record;
        fecha_hoy date;
        fecha1    date;
        fecha2    date;
BEGIN

  -- CALCULO DE FECHAS DE BUSQUEDA
  -- select sai_ult_dia_del_mes(date((select date(fechatrabajo) from origenes limit 1) + '1 month'::interval));
  -- select sai_primer_dia_del_mes(date((select date(fechatrabajo) from origenes limit 1) + '1 month'::interval));

  select into fecha_hoy date(fechatrabajo) from origenes limit 1;
  if not found or fecha_hoy is NULL then fecha_hoy := date(now()); end if;

  -- Primer dia del siguiente mes
  fecha1 := sai_primer_dia_del_mes(date(fecha_hoy + '1 month'::interval));

  -- Ultimo dia del siguiente mes
  fecha2 := sai_ult_dia_del_mes(date(fecha_hoy + '1 month'::interval));


--fecha1 := ('01/01/2024')::date;
--fecha2 := ('31/01/2024')::date;

RAISE NOTICE 'Value: %', fecha1;
RAISE NOTICE 'Value: %', fecha2;


		drop table if exists tmp_sai_fecha_ven;
		create local temp table tmp_sai_fecha_ven as 
		(Select 	a.idorigen 		, 
					a.idgrupo		, 
					a.idsocio 		, 
					a.idorigenp		, 
					a.idproducto	, 
					a.idauxiliar	,
					a.elaboro 		,
					a.nombre 		,
					a.appaterno 	,
					a.apmaterno		,
					a.uenombre as uenombre,
					email as correo,
					a.fecha_vencimiento1
					--,a.fecha_sig_pago
					--(sai_token(11, saiaux, '|')) as fecha_vencimiento1
			from ( 	select 	a.idorigen 		,
							a.idgrupo		, 
							a.idsocio 		,
							a.idorigenp		,
							a.idproducto	,
							a.idauxiliar	,
							a.elaboro 		,
							p.nombre 		,
							p.appaterno 	,
							p.apmaterno		,
							ue.nombre as uenombre		,
							email,
							--sai_auxiliar(a.idorigenp, a.idproducto, a.idauxiliar, fecha_hoy) AS saiaux
							(sai_token(11, sai_auxiliar(a.idorigenp, a.idproducto, a.idauxiliar, fecha_hoy) , '|')) as fecha_vencimiento1
							--,(sai_token(11, sai_auxiliar(a.idorigenp, a.idproducto, a.idauxiliar, fecha_hoy) , '|')) as fecha_sig_pago
					from auxiliares a
					INNER JOIN personas p USING (idorigen, idgrupo, idsocio)
					INNER JOIN productos pr USING (idproducto)
					INNER JOIN usuarios ue ON (a.elaboro = ue.idusuario)
					where pr.tipoproducto=2 and a.estatus = 2
			) as a
                         where a.fecha_vencimiento1::date between fecha1 and fecha2
                        );
		create index tmp_sai_fecha_ven_idx on tmp_sai_fecha_ven (idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar);	
		raise notice 'Tabla temporal fecha';


		drop table if exists tmp_sai_aux;
		create local temp table tmp_sai_aux as
		(	Select	a.idorigen 		, 
					a.idgrupo		, 
					a.idsocio 		, 
					a.idorigenp		, 
					a.idproducto	, 
					a.idauxiliar	,
					a.elaboro 		,
					a.uenombre 		,
					a.appaterno 	,
					a.apmaterno		,
					a.nombre 		,
					a.correo		, 
					a.fecha_vencimiento1,
					--(sai_token( 11, montos, '|')) as fecha_sig_pago,
					(sai_token (5, montos, '|')) as monto_vencido,
					(sai_token (7, montos, '|')) as monto_io_total,
					(sai_token (12, montos,'|')) as monto_por_vencer,
					(sai_token (16, montos,'|')) as monto_im_calculado,
					(sai_token (18, montos,'|')) as iva_io_total,
					(sai_token (19, montos,'|')) as iva_im_total,
					(sai_token (22, montos,'|')) as comision_np_total					
/*------------------------------------------------------------------------------
        LAS POSICIONES DEL sai_auxiliar() DE DONDE SALEN ESTOS VALORES SON:
        montovencido      --> pos. 5
        io                --> pos. 7
        ivaiotot          --> pos. 18
        im                --> pos. 16
        ivaimtot          --> pos. 19
        proximoabono      --> pos. 12
        comision_np_total --> pos. 22
------------------------------------------------------------------------------*/
			from (	select 	a.idorigen 		, 
							a.idgrupo		, 
							a.idsocio 		, 
							a.idorigenp		, 
							a.idproducto	, 
							a.idauxiliar	,
							a.elaboro 		,
							a.uenombre 		,
							a.appaterno 	,
							a.apmaterno		,
							a.nombre 		,
							a.correo		,
							a.fecha_vencimiento1,
							
							sai_auxiliar(a.idorigenp,a.idproducto,a.idauxiliar,a.fecha_vencimiento1::DATE) as montos
					from tmp_sai_fecha_ven a
			) as a
			 --where a.fecha_vencimiento1::date between fecha1 and fecha2
		);
		create index tmp_sai_aux_idx on tmp_sai_aux (idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar);	
		raise notice 'tabla temporal sai_aux';


		drop table if exists tmp_amortizaciones;
		create local temp table tmp_amortizaciones as 
			(	Select idorigenp, idproducto, idauxiliar, idamortizacion, vence, ((abono-abonopag)+(io-iopag)*16) as monto_amort
				from amortizaciones am
				where /*(vence>a.fecha_vencimiento1) and*/ (vence between fecha1 and fecha2) 
				--and (am.idorigenp, am.idproducto, am.idauxiliar) = (au.idorigenp,au.idproducto,au.idauxiliar)
			);
		create index tmp_amortizaciones_idx on tmp_amortizaciones (idorigenp, idproducto, idauxiliar, idamortizacion);
		raise notice 'tabla temporal amortizaciones'; 


		query1='Select 	
		a.idorigen,
		a.idgrupo,
		a.idsocio,
		(a.nombre||'' ''||a.appaterno||'' ''||a.apmaterno) as nom_socio,
		a.idorigenp, 
		a.idproducto,
		a.idauxiliar,
		a.correo as correo,
		a.fecha_vencimiento1 as fecha_vencimiento,
		/*fecha_sig_pago as fecha_sig_pago,*/
		(a.elaboro || '' - '' || a.uenombre) AS capturo,
		(monto_vencido::NUMERIC + 
		monto_io_total::NUMERIC + 
		monto_por_vencer::NUMERIC +
		monto_im_calculado::NUMERIC +
		iva_io_total::NUMERIC +
		iva_im_total::NUMERIC +
		comision_np_total::NUMERIC ) as monto
		from tmp_sai_aux a
		/*where (idorigenp, idproducto, idauxiliar) = (20110, 30102, 2895)*/
		ORDER BY idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar;';

		
		/*query2='select idorigenp, idproducto, idauxiliar, idamortizacion, vence, (abono-abonopag)+(io-iopag)*16 as monto
		from amortizaciones where (vence>a.fecha_vencimiento1) and (vence between fecha1 and fecha2)
		and (idorigenp, idproducto, idauxiliar)=(20110,30102,2895) order by idorigenp, idproducto, idauxiliar, idamortizacion, vence desc;';*/
		/*
		for r_query2 in execute query2 looop
		*/

	for r_query in execute query1 loop
			r.socio				:= 	TRIM(TO_CHAR(r_query.idorigen,'09999')) || '-'||
									r_query.idgrupo || '-' ||
									TRIM(TO_CHAR(r_query.idsocio,'09999999'));		
			r.nom_socio			:= 	r_query.nom_socio;
			r.folio				:= 	TRIM(TO_CHAR(r_query.idorigenp,'099999')) ||'-'|| 
									TRIM(TO_CHAR(r_query.idproducto,'09999')) ||'-'||
									TRIM(TO_CHAR(r_query.idauxiliar, '09999999'));
			r.correo			:= r_query.correo;
			r.fecha_vencimiento	:= r_query.fecha_vencimiento;
			r.capturo			:= r_query.capturo;
			r.monto				:= r_query.monto;	
	
		return next r;

			--for r_query2 in execute query2 loop
            --round(((am.abono-am.abonopag)+(am.io-am.iopag)*1.16), 2)
            --se quita el iva
			select into r_query2  
				am.idorigenp, am.idproducto, am.idauxiliar, am.idamortizacion, am.vence, round(((am.abono-am.abonopag)+(am.io-am.iopag)*1.16), 2) as monto
			from amortizaciones am where (am.vence>(r_query.fecha_vencimiento)::date) and (am.vence between fecha1 and fecha2)
				and (am.idorigenp, am.idproducto, am.idauxiliar)=(r_query.idorigenp,r_query.idproducto,r_query.idauxiliar) order by idorigenp, idproducto, idauxiliar, idamortizacion, vence desc;

			if r_query2.vence is NOT NULL then 
				r.socio 			:= r.socio;
				r.nom_socio			:= r.nom_socio;
				r.folio				:= 	TRIM(TO_CHAR(r_query2.idorigenp,'099999')) ||'-'|| 
										TRIM(TO_CHAR(r_query2.idproducto,'09999')) ||'-'||
										TRIM(TO_CHAR(r_query2.idauxiliar, '09999999'));
				r.correo			:= r.correo;
				r.fecha_vencimiento	:= r_query2.vence;
				--r.capturo			:= r.capturo;
				r.monto				:= r_query2.monto;	

			return next r;
			end if;
			
--Hacer la consulta a amortizaciones con los datos de la persona que vienen en el loop para ver si cae otro pago de ese prestamo en ese mismo mes 

	end loop;

return;

	END;
$function$
;
