-- NUEVO MEXICO
La base de datos a utilizar es la nm31dic2024_informativa cargada en el servidor 192.168.30.9
El reporte debe cumplir los siguientes criterios.

Ser socios del grupo 10
Los socios deben Tener 10 años sin movimientos
El reporte requiere los siguientes campos: 
numero de socio, 
nombre, 
productos, 
monto, 
telefono, 
correo electronico, 
fecha del ultimo movimiento, 
fecha de cumplimiento del plazo 
y si tiene creditos con los mismos datos.

--Para validaciones debe sacarse la fecha de trabajo de origenes, convertir en formato
Origenes 
elemento: fechatrabajo


SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,a.saldo,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", 
COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO"
FROM auxiliares a 
INNER JOIN personas p
USING (idorigen, idgrupo, idsocio)
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '9 years')
AND (a.tipoprestamo IN (2) OR a.tipoprestamo IN (0,1,8) )
AND a.idproducto NOT IN (101, 60001, 60002, 60003)

UNION ALL 

SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,a.saldo,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", 
COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO"
FROM auxiliares_d ad
INNER JOIN auxiliares_d_h adh
ON  ah.idorigenp= ad.idorigenp AND ah.idproducto = ad.idproducto AND  ah.idauxiliar = ad.idauxiliar 
INNER JOIN personas p
USING (idorigen, idgrupo, idsocio)
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years')
AND (a.tipoprestamo IN (2) OR a.tipoprestamo IN (0,1,8) )
AND a.idproducto NOT IN (101, 60001, 60002, 60003);

--------------------------------------------------------------------------------------------------------------------------------------------------------
--PRUEBA 2 AFINAR EL UNION


SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO",
a.saldo, pr.nombre
FROM auxiliares a 
INNER JOIN auxiliares_d ad
ON  a.idorigenp= ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar 
INNER JOIN auxiliares_d_h adh
ON  adh.idorigenp= a.idorigenp AND adh.idproducto = a.idproducto AND  adh.idauxiliar = a.idauxiliar 
INNER JOIN personas p
USING (idorigen, idgrupo, idsocio)
INNER JOIN productos pr
ON adh.idproducto = pr.idproducto
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years')
AND (a.tipoprestamo IN (2) OR a.tipoprestamo IN (0,1,8) )
AND a.idproducto NOT IN (101, 60002, 60003)

UNION ALL 

SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO",
a.saldo, pr.nombre
FROM auxiliares_h
INNER JOIN auxiliares_d_h ad
ON  adh.idorigenp= ad.idorigenp AND adh.idproducto = ad.idproducto AND adh.idauxiliar = ad.idauxiliar 
INNER JOIN auxiliares a
ON  adh.idorigenp= a.idorigenp AND adh.idproducto = a.idproducto AND  adh.idauxiliar = a.idauxiliar 
INNER JOIN personas p
USING (idorigen, idgrupo, idsocio)
INNER JOIN productos pr
ON adh.idproducto = pr.idproducto
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years')
AND (a.tipoprestamo IN (2) OR a.tipoprestamo IN (0,1,8) )
AND a.idproducto NOT IN (101, 60002, 60003);



--------------------------------------------------------------------------------------------------------------------------------------------------------
--PRUEBA 3 APUNTAR A auxilires_h

SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,a.saldo, pr.nombre,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO"
FROM auxiliares_h ah
INNER JOIN auxiliares a
ON  a.idorigenp= ah.idorigenp AND a.idproducto = ah.idproducto AND a.idauxiliar = ah.idauxiliar 
INNER JOIN personas p
ON  a.idorigen = p.idorigen AND  a.idgrupo = p.idgrupo AND  a.idsocio = p.idsocio
INNER JOIN productos pr
ON a.idproducto = pr.idproducto
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years')
AND (pr.tipoproducto IN (2,0,1,8))

UNION ALL 

SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
a.fechauma,a.saldo, pr.nombre,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO"
FROM auxiliares a 
INNER JOIN auxiliares_h ah
ON  a.idorigenp= ah.idorigenp AND a.idproducto = ah.idproducto AND a.idauxiliar = ah.idauxiliar 
INNER JOIN personas p
ON  a.idorigen = p.idorigen AND  a.idgrupo = p.idgrupo AND  a.idsocio = p.idsocio
INNER JOIN productos pr
ON ah.idproducto = pr.idproducto
WHERE p.idgrupo = 10 AND p.estatus = 't' AND a.estatus = 2 AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years')
AND (pr.tipoproducto IN (2,0,1,8));


-------------------
select count(*) from auxiliares as aux 
inner join auxiliares_d using(idorigenp,idproducto,idauxiliar);



select count(*) from auxiliares as aux 
inner join auxiliares_d_h using(idorigenp,idproducto,idauxiliar);

select count(*) from auxiliares_h as aux 
inner join auxiliares_d_h using(idorigenp,idproducto,idauxiliar);



---------------------------------------------------------------------------------------------------------------------
--INTENTO 4 tipoprestamo es diferente a tipo producto se requiero la tabla productos o subconsultas


select "OPA" from (
SELECT DISTINCT ON (a.idorigenp, a.idproducto, a.idauxiliar)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
pr.nombre, a.fechauma,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO",
a.saldo
FROM auxiliares a 
INNER JOIN auxiliares_d ad
ON  a.idorigenp= ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar 
INNER JOIN personas p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos pr
ON a.idproducto = pr.idproducto
WHERE p.idgrupo = 10 
AND p.estatus = 't' 
AND a.estatus in (2,3) 
AND a.fechauma <= ((select date(fechatrabajo) from origenes limit 1) - INTERVAL '10 years')
AND pr.tipoproducto IN (2,0,1,8)

UNION

SELECT DISTINCT ON (a.idorigenp, a.idproducto, a.idauxiliar)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) ||'|' AS "SOCIO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto, '09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar, '09999999'))||'-'|| '|' AS "OPA",
pr.nombre, a.fechauma,
COALESCE(p.email,'No Registrado')||'|' AS "CORREO", COALESCE(p.telefono,'No Registrado') ||'|' AS "TELEFONO",
a.saldo
FROM auxiliares_h a
INNER JOIN auxiliares_d_h ah
ON  a.idorigenp= ah.idorigenp AND a.idproducto = ah.idproducto AND a.idauxiliar = ah.idauxiliar 
INNER JOIN personas p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos pr
ON a.idproducto = pr.idproducto
WHERE p.idgrupo = 10 
AND p.estatus = 't' 
AND a.estatus in (2,3)
AND pr.tipoproducto IN (2,0,1,8)
AND a.fechauma <= ((select date(fechatrabajo) from origenes limit 1) - INTERVAL '20 years');
) as x where nombre <> 'CAPITAL';


ORDER BY p.idorigen, p.idgrupo, p.idsocio;
COALESCE ( p.telefono, 'No Registrado')
select * from auxiliares where idsocio= 356054 and idproducto = 36644 and estatus =2;
(select  AND a.fechauma <= (CURRENT_DATE - INTERVAL '10 years'))
and idproducto in(30102,30202,32602,32702,31802)

El reporte requiere los siguientes campos: 
productos, 
monto,   
fecha de cumplimiento del plazo 
y si tiene creditos con los mismos datos.

LEFT JOIN producto pr 
ON a.idproducto = pr.idproducto AND a.idorigenp = pr.idorigen
AND pr.tipo_producto IN (1,2,8) 