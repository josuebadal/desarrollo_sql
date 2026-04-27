Reporte de menores
CAJA: NUEVO MEXICO
Buen dia Equipo Fenoreste,
Me podrian a poyar en generarme un query de menores ahorradores grupo 20  de todas las 
transacciones que hicieron durante el año 2024 el cual contenga lo siguiente:
**Numero de socio| 
**Nombre|
fecha de transaccion|
monto de transaccion = efectivo
--NOTA COMPRAR CON auxilires_d_h por el historico
**CARGO
**ABONO
**rango de fecha 2024
el ahorro menor es el 120 en productos
 
SELECT
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' ||
TRIM(TO_CHAR(p.idgrupo, '09' )) || '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE"
FROM auxiliares aux
JOIN personas p
USING (idorigen,idgrupo,idsocio)
WHERE p.idgrupo = 20
AND aux.idproducto= 120
LIMIT 5;

============================================

SELECT
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' ||
TRIM(TO_CHAR(p.idgrupo, '09' )) || '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
pto.idproducto,
pto.nombre AS nombre_producto
FROM auxiliares aux
JOIN personas p
USING (idorigen,idgrupo,idsocio)
JOIN productos pto 
USING (idproducto)
JOIN auxiliares_d auxd
USING (idproducto,idauxiliar)
WHERE p.idgrupo = 20
AND aux.idproducto= 120
AND auxd.fecha::date BETWEEN '2024-01-01' AND '2024-12-31'
LIMIT 5;

============================================
SELECT
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' ||
TRIM(TO_CHAR(p.idgrupo, '09' )) || '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
pto.idproducto,
pto.nombre AS nombre_producto,
auxd.efectivo,
TO_CHAR(auxd.fecha, 'YYYY-MM-DD') AS fecha_movimiento,
auxd.cargoabono
FROM auxiliares aux
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN productos pto 
USING (idproducto)
INNER JOIN auxiliares_d auxd
USING (idproducto,idauxiliar)
INNER JOIN auxiliares_d_h auxdh
USING (idproducto,idauxiliar)
WHERE p.idgrupo = 20
AND aux.idproducto= 120
AND auxd.fecha::date BETWEEN '2024-01-01' AND '2024-12-31'
LIMIT 5;


============================================
--se agrego la edad con un EXTRACT 
SELECT
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' ||
TRIM(TO_CHAR(p.idgrupo, '09' )) || '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
pto.idproducto,
pto.nombre AS nombre_producto,
auxd.monto,
TO_CHAR(auxd.fecha, 'YYYY-MM-DD') AS fecha_movimiento,
trim(to_char(aux.saldo,'99,999,990.99')) as saldo,
auxd.cargoabono
FROM auxiliares aux
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN productos pto 
USING (idproducto)
INNER JOIN auxiliares_d auxd
USING (idorigenp,idproducto,idauxiliar)
WHERE p.idgrupo = 20
AND auxd.fecha::date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.idorigen, p.idgrupo, p.idsocio, p.nombre, p.appaterno, p.apmaterno,
p.fechanacimiento, pto.idproducto, pto.nombre, auxd.monto, auxd.fecha, aux.saldo, auxd.cargoabono
ORDER BY auxd.fecha;


select
trim(to_char(ah.idorigen,'099999'))||'-'||ah.idgrupo||'-'||
trim(to_char(ah.idsocio,'099999')) as no_socio, '|' as "|",
nombre_x(per.appaterno,per.apmaterno,per.nombre) as nombre, '|' as "|",
trim(to_char(adh.idorigenp,'099999'))||'-'||
trim(to_char(adh.idproducto,'09999'))||'-'||
trim(to_char(adh.idauxiliar,'09999999')) as credito,'|' as "|",
adh.fecha,adh.monto,adh.cargoabono
from auxiliares_d_h adh  
inner join auxiliares_h as ah using (idorigenp,idproducto,idauxiliar)
inner join personas as per using(idorigen,idgrupo,idsocio)
where ah.idgrupo =20 and date(adh.fecha) between date('01-01-2024') and date('31-12-2024')
    union
select
trim(to_char(ah.idorigen,'099999'))||'-'||ah.idgrupo||'-'||
trim(to_char(ah.idsocio,'099999')) as no_socio, '|' as "|",
nombre_x(per.appaterno,per.apmaterno,per.nombre) as nombre, '|' as "|",
trim(to_char(adh.idorigenp,'099999'))||'-'||
trim(to_char(adh.idproducto,'09999'))||'-'||
trim(to_char(adh.idauxiliar,'09999999')) as credito,'|' as "|",
adh.fecha,adh.monto,adh.cargoabono
from auxiliares_d adh  
inner join auxiliares as ah using (idorigenp,idproducto,idauxiliar)
inner join personas as per using(idorigen,idgrupo,idsocio)
where ah.idgrupo =20 and date(adh.fecha) between date('01-01-2024') and date('31-12-2024');















CAST(coalesce(split_part(sai_auxiliar(aux.idorigenp, aux.idproducto, aux.idauxiliar, date('2025-05-13')), '|', 4), '0') AS INTEGER)
Saldo actual en su cuenta de ahorro|
validar que la busqueda en auxiliares, auxiliares_d, auxiliares_d_h
¿Que es mas rapido hacer una union para auxdh o un JOIN ?
Como valido que un socio menor este activo?? 
--no se requiere validar porque es una busqueda de movimientos en un rango de fecha