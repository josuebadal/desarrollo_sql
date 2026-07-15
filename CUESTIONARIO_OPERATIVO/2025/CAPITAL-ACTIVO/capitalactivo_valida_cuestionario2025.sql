-----------------------------------------------------------
--                    VALIDACIONES PARA CUESTIONARIO A1
-- Tabla temporal: a1_cuestionario_operatividad
-----------------------------------------------------------

*****VALIDAR TABLAS TEMPORALES CREADAS CON ACT ECO PLD****
tmp_act
temp_peps
tmp_act_peps

-----VALIDA TRABAJOS SIN ACTIVIDAD ECONOMICAS-----
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

----CUESTIONARIO A1----------------
------VALIDA NUMERO TOTAL DE SOCIOS QUE APLICAN AL FORMATO
SELECT * from tmp_act;
select COUNT(*) from tmp_act;

--------VALIDA TOTAL DE SOCIOS SIN TRABAJO
select count(*)
from tmp_act ax
left join trabajo tr
on ax.idorigen = tr.idorigen
and ax.idgrupo  = tr.idgrupo
and ax.idsocio  = tr.idsocio
and tr.consecutivo = 1
where tr.idsocio is null;

select ax.*
from tmp_act ax
left join trabajo tr
on ax.idorigen = tr.idorigen
and ax.idgrupo = tr.idgrupo
and ax.idsocio = tr.idsocio
and tr.consecutivo = 1
where tr.idorigen is null;

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

 select sum(monto + montoio + montoim + montoiva + montoivaim) from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_clientes ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) 
         and ad.periodo:: integer between 202501 and 202512;
 130258464.91
(1 fila)

nuevomexico31dic25_cuestionario=# select 554247034.28+130258464.91;
 684505499.19
(1 fila)

---------- VALIDACION  JULIO 2026 ----------
----- ERROR AL REPORTAR A LA SIGUIENTE PERSONA EXTRANJERA COMO PF-NACIONAL TIPO 3
tipo_cliente_o_usuario	                5
clasificacion_grado_riesgo	            1
pais_nacionalidad	                    47
pais_residencia	                        47
entidad_federativa_residencia	        2
act_eco_pld	numero_total_clientes       43322

SELECT tact.idorigen, tact.idgrupo, tact.idsocio, 
est.idestado, est.nombre,
p.lugarnacimiento,p.nacionalidad,p.razon_social,
tr.consecutivo, tr.actividad_economica_pld
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join trabajo as tr on tact.idorigen = tr.idorigen AND tact.idgrupo = tr.idgrupo AND tact.idsocio = tr.idsocio AND consecutivo = 1
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
where p.pais_nacimiento = 43  and p.nacionalidad  = 3;
idorigen                | 20110
idgrupo                 | 10
idsocio                 | 396
idestado                | 2
nombre                  | Baja California Norte
lugarnacimiento         | colombia
nacionalidad            | 3
razon_social            | 
consecutivo             | 1
actividad_economica_pld | 0043322

-----SEGUNDO ERROR 


SELECT tact.idorigen, tact.idgrupo, tact.idsocio,
col.idcolonia, col.nombre, 
mun.idmunicipio, mun.nombre,
est.idestado, est.nombre,
pa.idpais, pa.nombre,
p.lugarnacimiento,p.nacionalidad,p.razon_social,
tr.consecutivo, tr.actividad_economica_pld
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join trabajo as tr on tact.idorigen = tr.idorigen AND tact.idgrupo = tr.idgrupo AND tact.idsocio = tr.idsocio AND consecutivo = 1
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
inner join paises  as pa on est.idpais = pa.idpais
where p.nacionalidad  = 3;

--------- VALIDACIONES PARA EL CUESTIONARIO D1 -----------
capitalactivo31dic25_movimientos=# select count(*) from tmp_act;
757


SELECT tact.idorigen, tact.idgrupo, tact.idsocio,
col.idcolonia, col.nombre, 
mun.idmunicipio, mun.nombre,
est.idestado, est.nombre,
pa.idpais, pa.nombre,
p.lugarnacimiento,p.nacionalidad,p.razon_social,
tr.consecutivo, tr.actividad_economica_pld
FROM tmp_act as tact
inner join personas as p on tact.idorigen = p.idorigen AND tact.idgrupo = p.idgrupo AND tact.idsocio = p.idsocio
inner join trabajo as tr on tact.idorigen = tr.idorigen AND tact.idgrupo = tr.idgrupo AND tact.idsocio = tr.idsocio AND consecutivo = 1
inner join colonias as col ON p.idcolonia = col.idcolonia
inner join municipios as mun ON col.idmunicipio = mun.idmunicipio
inner join estados as est ON mun.idestado = est.idestado
inner join paises  as pa on est.idpais = pa.idpais
;



-----CAMBIO DE PASWWORD -----
update usuario set passwd = md5('497cambio')
where idusuario = 497;

DELETE intentos_fallidos where idusuario = 497;