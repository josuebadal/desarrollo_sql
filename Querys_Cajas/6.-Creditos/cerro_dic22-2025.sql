/* CREDITOS ACTIVOS QUE ESTEN AL CORRIENTE Y 
Y TENGAN PAGOS DIRECTO A CAPITAL
*/
WITH abonos as (
SELECT ab.idorigenp,ab.idproducto,ab.idauxiliar,
COUNT(*) AS total_abonos
FROM auxiliares_d as ab
WHERE ab.periodo BETWEEN '202503' AND '202503'
AND UPPER(ab.cartera) = 'C'
AND ab.cargoabono = 1 and ab. idtipo  = 1 and ab.tipomov = 0 
and ab.diasvencidos = 0
GROUP BY
ab.idorigenp,ab.idproducto,ab.idauxiliar
HAVING COUNT(*) > 1
)
SELECT 
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "Nombre",
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'|| 
TRIM(TO_CHAR(a.idgrupo,'09'))||'-'|| 
TRIM(TO_CHAR(a.idsocio,'099999')) as "Socio",
ab.idorigenp,ab.idproducto,ab.idauxiliar,
ad.fecha AS "Fecha_abono",
ad.saldoec as "saldo",
ad.monto as "abono",
ad.montoio,
ad.montoiva,
ab.total_abonos AS "abonos_x_mes",
a.montoprestado as "mnt_prtm"
FROM abonos as ab
JOIN auxiliares_d ad
ON ad.idorigenp  = ab.idorigenp 
AND ad.idproducto = ab.idproducto 
AND ad.idauxiliar = ab.idauxiliar
JOIN auxiliares a
ON a.idorigenp  = ab.idorigenp
AND a.idproducto = ab.idproducto
AND a.idauxiliar = ab.idauxiliar
INNER JOIN personas as p
ON  p.idorigen = a.idorigen 
AND p.idgrupo = a.idgrupo 
AND p.idsocio = a.idsocio
WHERE a.idproducto BETWEEN 30000 AND 39999 
and a.estatus = 2 and UPPER(a.cartera) = 'C'
AND ad.periodo BETWEEN '202503' AND '202503'
ORDER BY ab.idorigenp,ab.idproducto,ab.idauxiliar,ad.fecha
;

----- VERSION DE SAICOOP -----
--COPIAR Y PEGAR LAS LINEAS SIGUIENTES EN UN QUERY NUEVO
--AL GUARDARLO Y VOLVER A ENRTAR AL NUM DE QUERY LE PEDIRA 4 VECES EL PERIODO
--LO CORRECTO ES PONER EL MISMO MERIODO EN TODOS LOS CAMPOS
SELECT * FROM (
WITH abonos as (
SELECT ab.idorigenp,ab.idproducto,ab.idauxiliar,
COUNT(*) AS total_abonos
FROM auxiliares_d as ab
WHERE ab.periodo BETWEEN @@Periodo ini:|e|202502@@  AND @@Periodo fin:|e|202502@@ 
AND UPPER(ab.cartera) = 'C'
AND ab.cargoabono = 1 and ab. idtipo  = 1 and ab.tipomov = 0 
and ab.diasvencidos = 0
GROUP BY
ab.idorigenp,ab.idproducto,ab.idauxiliar
HAVING COUNT(*) > 1
)
SELECT 
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "Nombre",
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'|| 
TRIM(TO_CHAR(a.idgrupo,'09'))||'-'|| 
TRIM(TO_CHAR(a.idsocio,'099999')) as "Socio",
ab.idorigenp,ab.idproducto,ab.idauxiliar,
ad.fecha AS "Fecha_abono",
ad.saldoec as "saldo",
ad.monto as "abono",
ad.montoio,
ad.montoiva,
ab.total_abonos AS "abonos_x_mes",
a.montoprestado as "mnt_prtm"
FROM abonos as ab
JOIN auxiliares_d ad
ON ad.idorigenp  = ab.idorigenp 
AND ad.idproducto = ab.idproducto 
AND ad.idauxiliar = ab.idauxiliar
JOIN auxiliares a
ON a.idorigenp  = ab.idorigenp
AND a.idproducto = ab.idproducto
AND a.idauxiliar = ab.idauxiliar
INNER JOIN personas as p
ON  p.idorigen = a.idorigen 
AND p.idgrupo = a.idgrupo 
AND p.idsocio = a.idsocio
WHERE a.idproducto BETWEEN 30000 AND 39999 
and a.estatus = 2 and UPPER(a.cartera) = 'C'
AND ad.periodo BETWEEN @@Periodo ini:|e|202502@@  AND @@Periodo fin:|e|202502@@ 
ORDER BY ab.idorigenp,ab.idproducto,ab.idauxiliar,ad.fecha
)AS X;