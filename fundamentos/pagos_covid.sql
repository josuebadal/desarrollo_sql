
DROP TYPE IF EXISTS pagos_covid CASCADE;
CREATE TYPE pagos_covid AS (
    ogs                                          text, 
    nombre                                       text,
    opa_anterior                                 text,   
    fechaactivacion_actual                       text,
    finalidade 									 text,
    tipocartera									 text,
    monto_total                                  numeric,
    monto                                        numeric,
    montoio                                      numeric,
    iva                                          numeric,
    opa_actual                                   text,
    fechacubierta                                text,
    producto_pagando                             text,
    fecha_pago                                   text
 
);


CREATE OR REPLACE FUNCTION abonos_covid(date,date)
RETURNS SETOF pagos_covid
AS $$

DECLARE
fecha1      alias for $1;
fecha2     alias for $2;
r  pagos_covid%rowtype;
datosp  record;
datosad record;
r_rec  record;
r_fechaant date;
tipocredito text;
cartera text;


BEGIN
for r_rec in select a.idorigen,a.idgrupo,a.idsocio,a.idorigenp,a.idproducto,a.idauxiliar,a.fechaactivacion,rf.tiporeferencia,rf.idorigenpr,rf.idproductor,rf.idauxiliarr from referenciasp rf
inner join auxiliares a using(idorigenp,idproducto,idauxiliar)
where a.estatus=2 and rf.tiporeferencia in(7) loop

select into datosp nombre,appaterno,apmaterno,idorigen,idgrupo,idsocio from personas p 
where p.idorigen=r_rec.idorigen and p.idgrupo=r_rec.idgrupo and p.idsocio=r_rec.idsocio;

select into datosad * from auxiliares_d ad 
where ad.idorigenp=r_rec.idorigenpr and ad.idproducto=r_rec.idproductor and ad.idauxiliar=r_rec.idauxiliarr 
and date(fecha)>=r_rec.fechaactivacion and monto>0 and montoio>0 and montoiva>0 and date(fecha) between fecha1 and fecha2;

select into r_fechaant vence  from amortizaciones am 
where am.idorigenp=datosad.idorigenp and am.idproducto=datosad.idproducto and am.idauxiliar=datosad.idauxiliar 
and todopag='t' order by vence desc limit 1;

select into tipocredito (case when v.idfinalidad = 1 and f.dependede = 0 then 'Consumo'
					when  v.idfinalidad = 2 and f.dependede = 0 then 'Comercial'
					when  v.idfinalidad = 3 and f.dependede = 0 then 'Vivienda'
					when  v.idfinalidad >0  and f.dependede = 1 then 'Consumo'
					when  v.idfinalidad >0  and f.dependede = 2 then 'Comercial'
					when  v.idfinalidad >0  and f.dependede = 3 then 'Vivienda' 
					when  v.idfinalidad >0  and f.dependede = 4 then 'Microcreditos' end) from v_auxiliares v 
		            inner join finalidades f using(idfinalidad) where 
		            (v.idorigenp,v.idproducto,v.idauxiliar)=(r_rec.idorigenpr,r_rec.idproductor,r_rec.idauxiliarr); 

select into cartera (case when (ca.cartera='C' or ca.cartera='M') then 'Vigente' else 'Vencido' end) from carteravencida ca 
		    	       where (ca.idorigenp,ca.idproducto,ca.idauxiliar)=(r_rec.idorigenpr,r_rec.idproductor,r_rec.idauxiliarr);


--select into r_fechasig vence  from amortizaciones am where am.idorigenp=datosad.idorigenp and am.idproducto=datosad.idproducto and am.idauxiliar=datosad.idauxiliar and vence>date(datosad.fecha) order by vence asc limit 1;

--select into counta count(*) from generate_series((r_fechaant.vence),(select vence from amortizaciones am ) , '1 month'::interval) fecha1;
--select into counta count(*) from generate_series((r_fechaant.vence),(select vence from amortizaciones am ) , '1 month'::interval) fecha1;

--select fecha1::date from generate_series('10/09/2020', '12/07/2020', '-1 month'::interval) fecha1 order by fecha1 desc limit 1;

--if(date(r_fechaant)>)

r.ogs                         := datosp.idorigen||'-'||datosp.idgrupo||'-'||datosp.idsocio;
r.nombre                      := datosp.nombre||' '||datosp.appaterno||' '||datosp.apmaterno;
r.opa_anterior                := r_rec.idorigenpr||'-'||r_rec.idproductor||'-'||r_rec.idauxiliarr;
r.fechaactivacion_actual      := r_rec.fechaactivacion;
r.opa_actual                  := r_rec.idorigenp||'-'||r_rec.idproducto||'-'||r_rec.idauxiliar;
r.monto_total                 := (datosad.monto+datosad.montoio+datosad.montoiva+datosad.montoivaim);
r.monto                       := datosad.monto;
r.montoio                     := datosad.montoio;
r.iva                         := datosad.montoiva;
r.fechacubierta               := r_fechaant;
r.fecha_pago                  := date(datosad.fecha);
r.producto_pagando            := r_rec.idorigenp||'-'||r_rec.idproducto||'-'||r_rec.idauxiliar;
r.finalidade                  := tipocredito;
r.tipocartera                 := cartera;
return next r;

end loop;


END;
 
$$ LANGUAGE 'plpgsql';
