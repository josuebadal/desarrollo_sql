/*Se deberan generar los cuestinarios 1 x 1
mediante las siguientes consultas

select * from cuestionario_a1(29037,2025);

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

--OBSERVACIONES CONUMEX ----------------
----CUESTIONARIO A1----------------
------VALIDA NUMERO TOTAL DE SOCIOS QUE APLICAN AL FORMATO
--------LOS SOCIOS QUE SE INCLUYEN
SELECT * from tmp_act;
select COUNT(*) from tmp_act; ---TOTAL DE SOCIOS

select COUNT(*) as soc_grupo10 from tmp_act
where idgrupo = 10; ---TOTAL DE SOCIOS MAYORES

select COUNT(*) as soc_grupo20 from tmp_act
where idgrupo = 20;

select COUNT(*) as soc_grupo_dif from tmp_act
where idgrupo <> 10 and idgrupo <> 20; ---VALIDA SI HAY SOCIOS CONTEMPLADOS FUERA DEL GRUPO 10 Y 20


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
--------DATOS DE SOCIOS SIN TRABAJO
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
SELECT tact.idorigen, tact.idgrupo, tact.idsocio, est.idestado, est.nombre,ps.nombre as nom_pais,
tr.consecutivo, tr.actividad_economica_pld
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join trabajo as tr on tact.idorigen = tr.idorigen AND tact.idgrupo = tr.idgrupo AND tact.idsocio = tr.idsocio AND consecutivo = 1
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
inner join paises as ps ON est.idpais = ps.idpais
--WHERE mun.idestado = 1
WHERE --tr.actividad_economica_pld is null or tr.actividad_economica_pld = ''
--ps.nombre <> 'México' and 
est.idestado = '33'
;

------VALIDA ENTIDAD FEDERATIVA RESIDENCIA H
------------Valida el estado que tienen en catalogo de personas
SELECT tact.idorigen||'-'||tact.idgrupo||'-'||tact.idsocio as ogs, est.idestado, est.nombre,ps.nombre as nom_pais
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
inner join paises as ps ON est.idpais = ps.idpais
;
------VALIDA TODOS LOS ESTADOS PARA LA ENTIDAD FEDERATIVA Y COMPARAR CONTRA LO QUE DA LA BANCARIA
SELECT DISTINCT est.idestado, est.nombre,ps.nombre as nom_pais, 0 as CNBV
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
inner join paises as ps ON est.idpais = ps.idpais
;

 idestado |   nombre    | nom_pais | cnbv 
----------+-------------+----------+------
        0 | NO DEFINIDO | México   |    0
        7 | Coahuila    | México   |    5
        8 | Colima      | México   |    6
       11 | Guanajuato  | México   |    11
       12 | Guerrero    | México   |    12
       13 | Hidalgo     | México   |    13
       19 | Nuevo León  | México   |    19
       28 | Tamaulipas  | México   |    28
       30 | Veracruz    | México   |    30
       33 | Texas,USA   | México   |    0





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
