/*Se deberan generar los cuestinarios 1 x 1
mediante las siguientes consultas

select * from cuestionario_a1(12345,2025);

select * from cuestionario_a2(12345,2025);

select * from cuestionario_b(12345,2025);

select * from cuestionario_c_2026(12345,2025);

select * from cuestionario_d1(12345,2025);

select * from cuestionario_d2(12345,2025);
*/

-----------------------------------------------------------
--                    VALIDACIONES PARA CUESTIONARIO A1
-- Tabla temporal: a1_cuestionario_operatividad
-----------------------------------------------------------

*****VALIDAR TABLAS TEMPORALES CREADAS CON ACT ECO PLD****
tmp_act
temp_peps
tmp_act_peps

--OBSERVACIONES SANISIDRO ----------------
----CUESTIONARIO A1----------------
------VALIDA NUMERO TOTAL DE SOCIOS QUE APLICAN AL FORMATO
--------LOS SOCIOS QUE SE INCLUYEN
SELECT * from tmp_act; ---LISTADO DE SOCIOS QUE APLICAN
select COUNT(*) from tmp_act; ---CANTIDAD DE SOCIOS QUE APLICAN 8643

/*FORMULARIO A1 Y A2 en la entidad federativa a todos les aparece con clave 7 que pertenece a Nuevo Leon 
nuestros socios tienen capturado que son de Coahuila se les debe de asignar clave 5.*/

SELECT sa.*, p.lugarnacimiento,pais_nacimiento, p.nacionalidad, c.nombre as colonia, m.nombre as municipio, 
e.nombre as estado, e.idestado as enti_fede_residencia  
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
inner join colonias c on(c.idcolonia=p.idcolonia) 
inner join municipios m on(m.idmunicipio=c.idmunicipio) 
inner join estados e on(e.idestado=m.idestado);

/*Hay socios que en el reporte tienen tipo de cliente 5 (Nacional con act. empresarial), 
esta la duda de como el sistema lo clasifica con esa clave, me comenta el oficial de cumplimiento 
ella se basa en tipo de actividad economica las que son vunerables por lo que solamente tiene identificado 1 
socio con act.empresarial.*/

SELECT * FROM temp_pfae INNER JOIN negociopropio as negp USING (idorigen,idgrupo,idsocio);
SELECT * FROM temp_pfae;

/*FORMULARIO A1 hay socios que estan como extranjeros y en la columna pais de nacimiento les aparece la clave 157 (mexico).*/
SELECT sa.*, p.lugarnacimiento,p.pais_nacimiento,pn.nombre as paisnac,
p.nacionalidad, c.nombre as colonia, m.nombre as municipio, 
e.nombre as estado, e.idestado as enti_fede_residencia, ps.idpais, ps.nombre as pais   
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
inner join colonias c on(c.idcolonia=p.idcolonia) 
inner join municipios m on(m.idmunicipio=c.idmunicipio) 
inner join estados e on(e.idestado=m.idestado)
inner join paises ps on (e.idpais= ps.idpais)
left join paises pn on (p.pais_nacimiento = pn.idpais);

SELECT sa.*, p.pais_nacimiento as paisnac, p.nacionalidad, pn.nombre ,
m.nombre as municipio, e.nombre as estado, e.idestado as enti_fede_residencia, 
ps.idpais, ps.nombre as pais   
from tmp_act sa
inner join personas p using (idorigen,idgrupo,idsocio)
inner join colonias c on(c.idcolonia=p.idcolonia) 
inner join municipios m on(m.idmunicipio=c.idmunicipio) 
inner join estados e on(e.idestado=m.idestado)
inner join paises ps on (e.idpais= ps.idpais)
left join paises pn on (p.pais_nacimiento = pn.idpais)
where nacionalidad <> 1;

















SELECT tr.idorigen,tr.idgrupo,tr.idsocio, tr.actividad_economica_pld 
FROM tmp_act as t
INNER JOIN trabajo as tr ON t.idorigen = tr.idorigen
AND t.idgrupo = tr.idgrupo AND t.idsocio = tr.idsocio AND tr.consecutivo= 1
WHERE tr.actividad_economica_pld IS NULL;

SELECT tr.idorigen,tr.idgrupo,tr.idsocio, tr.actividad_economica_pld 
FROM temp_peps as t
INNER JOIN trabajo as tr ON t.idorigen = tr.idorigen
AND t.idgrupo = tr.idgrupo AND t.idsocio = tr.idsocio AND tr.consecutivo= 1
WHERE tr.actividad_economica_pld IS NULL;

SELECT tr.idorigen,tr.idgrupo,tr.idsocio, tr.actividad_economica_pld 
FROM tmp_act_peps as t
INNER JOIN trabajo as tr ON t.idorigen = tr.idorigen
AND t.idgrupo = tr.idgrupo AND t.idsocio = tr.idsocio AND tr.consecutivo= 1
WHERE tr.actividad_economica_pld IS NULL;

-----VALIDAR QUE NINGUN DATO VENGA VACIO O QUE SE REPORTE LA CLAVE DE EJEMPLO 12345
SELECT * FROM a1_cuestionario_operatividad
where anio IS NULL OR  anio != '2025' OR clave_formulario IS NULL 
OR  clave_de_entidad = '12345'
OR tipo_cliente_o_usuario IS NULL OR clasificacion_grado_riesgo IS NULL
OR pais_nacionalidad IS NULL OR pais_residencia IS NULL 
OR entidad_federativa_residencia IS NULL 
OR actividad_economica is null OR numero_total_clientes IS NULL 
;



--------TOTAL DE  SOCIOS QUE SE INCLUYEN
select SUM(numero_total_clientes::integer) from a1_cuestionario_operatividad;

--------VALIDA TOTAL DE SOCIOS SIN TRABAJO
select count(*)
from tmp_act ax
left join trabajo tr
on ax.idorigen = tr.idorigen
and ax.idgrupo  = tr.idgrupo
and ax.idsocio  = tr.idsocio
and tr.consecutivo = 1
where tr.idsocio is null;
 count 
-------
    58
(1 fila)

select ax.*
from tmp_act ax
left join trabajo tr
on ax.idorigen = tr.idorigen
and ax.idgrupo = tr.idgrupo
and ax.idsocio = tr.idsocio
and tr.consecutivo = 1
where tr.idorigen is null;


------VALIDA CLASIFICACION POR GRADO DE RIESGO
El grado de Riesgo también es incorrecto ya que no manejamos grado de riesgo 3, solo manejamos 1 y 5.
--NO DEBE SALIR clasificacion_grado_riesgo    | 3
SELECT * from a1_cuestionario_operatividad where clasificacion_grado_riesgo::numeric != 1;

------VALIDA CLASIFICACION POR GRADO DE RIESGO
PEP: Reportan 112 PEP lo que es un dato erróneo

Se estan reportando 272 haciendo un filtro en la columna D y contabilizando la columna J 


------VALIDA ENTIDAD FEDERATIVA RESIDENCIA H
SELECT tact.idorigen, tact.idgrupo, tact.idsocio, est.idestado, est.nombre,tr.consecutivo, tr.actividad_economica_pld
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join trabajo as tr on tact.idorigen = tr.idorigen AND tact.idgrupo = tr.idgrupo AND tact.idsocio = tr.idsocio AND consecutivo = 1
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
--WHERE mun.idestado = 1
WHERE tr.actividad_economica_pld is null or tr.actividad_economica_pld = ''
;




nuevomexico31dic25_cuestionario=# 
nuevomexico31dic25_cuestionario=# select sum(monto + montoio + montoim + montoiva + montoivaim) from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_clientes ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) 
         and ad.periodo:: integer between 202501 and 202512;
     sum      
--------------
 130258464.91
(1 fila)

nuevomexico31dic25_cuestionario=# select 554247034.28+130258464.91;
   ?column?   
--------------
 684505499.19
(1 fila)
