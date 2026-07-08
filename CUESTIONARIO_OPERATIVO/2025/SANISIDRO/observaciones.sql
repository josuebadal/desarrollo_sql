/*FORMULARIO A1 Y A2 en la entidad federativa a todos les aparece con clave 7 que pertenece a Nuevo Leon 
nuestros socios tienen capturado que son de Coahuila se les debe de asignar clave 5.*/

SELECT sa.*, p.lugarnacimiento, p.pais_nacimiento, pa2.nombre as nom_pais_nac, p.nacionalidad, c.nombre as colonia, m.nombre as municipio, 
e.nombre as estado, e.idestado as enti_fede_residencia, pa.nombre as pais_residencia  
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
inner join colonias c on(c.idcolonia=p.idcolonia) 
inner join municipios m on(m.idmunicipio=c.idmunicipio) 
inner join estados e on(e.idestado=m.idestado)
inner join paises pa on (e.idpais = pa.idpais)
left  join paises pa2 on (p.pais_nacimiento = pa2.idpais)
--where p.pais_nacimiento <> 1;
--p.nacionalidad <> 1;
;

(case when e.idestado= 7 then 5 else e.idestado end) as enti_fede_residencia,


/*Hay socios que en el reporte tienen tipo de cliente 5 (Nacional con act. empresarial), 
esta la duda de como el sistema lo clasifica con esa clave, me comenta el oficial de cumplimiento 
ella se basa en tipo de actividad economica las que son vunerables por lo que solamente tiene identificado 1 
socio con act.empresarial.*/

SELECT * FROM temp_pfae INNER JOIN negociopropio as negp USING (idorigen,idgrupo,idsocio);
SELECT * FROM temp_pfae;



/*FORMULARIO A1 hay socios que estan como extranjeros y en la columna pais de nacimiento les aparece la clave 157 (mexico).*/

SELECT sa.*, p.lugarnacimiento, p.pais_nacimiento, pa2.nombre as nom_pais_nac, p.nacionalidad, c.nombre as colonia, m.nombre as municipio, 
e.nombre as estado, e.idestado as enti_fede_residencia, pa.nombre as pais_residencia  
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
inner join colonias c on(c.idcolonia=p.idcolonia) 
inner join municipios m on(m.idmunicipio=c.idmunicipio) 
inner join estados e on(e.idestado=m.idestado)
inner join paises pa on (e.idpais = pa.idpais)
left  join paises pa2 on (p.pais_nacimiento = pa2.idpais)
where p.pais_nacimiento <> 1;
--p.nacionalidad <> 1;
;

(case when p.pais_nacimiento=2 and p.nacionalidad  = 3 then  '3'--afganistan
					  when p.pais_nacimiento=1  and p.nacionalidad  = 3 then  '157'--México
					  when p.pais_nacimiento=61  and p.nacionalidad  = 3 then  '67'--EUA
					  when p.pais_nacimiento=70  and p.nacionalidad  = 3 then  '76'--Georgia
					  else  '157' end) as nacion, ----------DATO 6



/*Las actividades economicas que aparecen en los formularios hay algunas que no coinciden o no se encuentran 
dentro del catalogo que envio la cnbv, 
la duda es si en el sistema en actividad economica pld no estan las mismas que las del catalogo que tiene la cnbv?.*/

SELECT sa.*, coalesce(tr.actividad_economica_pld,'0000000') as act_eco_pld 
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
left  join trabajo tr ON tr.idorigen = p.idorigen and tr.idgrupo = p.idgrupo and tr.idsocio = p.idsocio and tr.consecutivo =1
;
-----COMO SE LLENARON LAS ACTIVIDADES ECONOMICAS PLD de la tabla trabajos???


/*FORMULARIO A2 falta las columnas 7 Pais nacionalidad y Columna 8 Pais de residencia de acuerdo 
a como viene en el instructivo del cuestionario operativo.*/

mismas validaciones que el A1

/*FORMULARIO D2 comparando con los informes de altas nosotros tenemos que fueron 375 
alta al cierre de diciembre y en el formulario da como resultado 391*/

SELECT COUNT(*) as socios_alta FROM (
SELECT sa.*, p.fechaingreso 
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
WHERE p.fechaingreso::date > '01/01/2025' 
) AS X; 

SELECT sa.*, p.fechaingreso 
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
WHERE p.fechaingreso::date > '01/01/2025' 
order by p.fechaingreso;