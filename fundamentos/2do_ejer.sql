CAJA FAMA  
    Buen dia Ingeniero,
Nos puede apoyar con un reporte donde podamos revisar la activad laboral de los socios que tenemos en Cartera morosa y vencida y los salarios registrados en sistema, para asi poder clasificar mejor la situacion de nuestros socios. 
Como le comente, de momento estamos interesados especificamente en los socios que son taxistas (taxi propio o en renta, con concesion a nombre propio o en renta), y conductores de aplicacion (Uber, Didi, Rappi, etc., tanto transporte como comida).
La informacion que me interesa es la siguiente:

Informacion del credito 
fecha de entrega,  --puede ser fecha de activacion o validar por medio de una poliza
estatus (M/V), 
dias vencidos, monto vencido, 
Actividad laboral

SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||TRIM(TO_CHAR(p.idsocio, '099999')) AS OGS,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(aux.idorigenp, '099999'))|| '-' ||TRIM(TO_CHAR(aux.idproducto, '09999'))|| '-' ||TRIM(TO_CHAR(aux.idauxiliar, '09999999'))AS OPA,
pdt.nombre,
org.nombre AS Sucursal,
aux.montoprestado,
auxd.diasvencidos,
auxd.montovencido,
aux.fechaactivacion,
aux.saldo,
aux.cartera, 
p.calle || '-' || p.numeroext|| '-' || p.numeroint || '-' || col.nombre || '-' || p.entrecalles AS Direccion
FROM auxiliares aux
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN colonias col ON col.idcolonia = p.idcolonia
JOIN productos pdt ON pdt.idproducto = aux.idproducto
JOIN origenes org ON org.idorigen = aux.idorigenp
JOIN auxiliares_d auxd ON auxd.idorigenp = aux.idorigenp
AND auxd.idproducto = aux.idproducto
AND auxd.idauxiliar = aux.idauxiliar
JOIN trabajo tbj ON tbj.idsocio = p.idsocio
WHERE p.estatus = 't'
AND aux.estatus = 2
AND pdt.tipoproducto = 2
AND p.idsocio = 356054
LIMIT 20;

=================================================================================0
SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||TRIM(TO_CHAR(p.idsocio, '099999')) AS OGS,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(aux.idorigenp, '099999'))|| '-' ||TRIM(TO_CHAR(aux.idproducto, '09999'))|| '-' ||TRIM(TO_CHAR(aux.idauxiliar, '09999999'))AS OPA,
org.nombre AS Sucursal,
aux.montoprestado,
auxd.diasvencidos,
auxd.montovencido,
auxd.fecha,
aux.fechaactivacion,
aux.saldo,
aux.cartera,
soceco.ingresosordinarios ,
p.calle || '-' || p.numeroext|| '-' || p.numeroint || '-' || col.nombre || '-' || p.entrecalles AS Direccion
FROM auxiliares aux
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN colonias col ON col.idcolonia = p.idcolonia
JOIN productos pdt ON pdt.idproducto = aux.idproducto
JOIN origenes org ON org.idorigen = aux.idorigenp
JOIN auxiliares_d auxd ON auxd.idorigenp = aux.idorigenp
AND auxd.idproducto = aux.idproducto
AND auxd.idauxiliar = aux.idauxiliar
JOIN trabajo tbj ON tbj.idsocio = p.idsocio
JOIN socioeconomicos soceco ON p.idorigen = soceco.idorigen
AND p.idgrupo = soceco.idgrupo
AND p.idsocio = soceco.idsocio
WHERE p.estatus = 't'
AND aux.estatus = 2
AND pdt.tipoproducto = 2
LIMIT 20;

=========================
SELECT DISTINCT ON(p.idorigen,p.idgrupo,p.idsocio, aux.idorigenp,aux.idproducto,aux.idauxiliar)
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||TRIM(TO_CHAR(p.idsocio, '099999')) AS OGS,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(aux.idorigenp, '099999'))|| '-' ||TRIM(TO_CHAR(aux.idproducto, '09999'))|| '-' ||TRIM(TO_CHAR(aux.idauxiliar, '09999999'))AS OPA,
org.nombre AS Sucursal,
aux.montoprestado,
aux.fechaactivacion,
aux.saldo,
aux.cartera,
soceco.ingresosordinarios ,
tbj.puesto,
p.calle || '-' || p.numeroext|| '-' || p.numeroint || '-' || col.nombre || '-' || p.entrecalles AS Direccion
FROM auxiliares aux
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
INNER JOIN colonias col ON col.idcolonia = p.idcolonia
INNER JOIN productos pdt ON pdt.idproducto = aux.idproducto
INNER JOIN origenes org ON org.idorigen = aux.idorigenp
INNER JOIN trabajo tbj ON tbj.idorigen = p.idorigen
AND tbj.idgrupo = p.idgrupo
AND tbj.idsocio = p.idsocio
INNER JOIN socioeconomicos soceco ON p.idorigen = soceco.idorigen
AND p.idgrupo = soceco.idgrupo
AND p.idsocio = soceco.idsocio
WHERE p.estatus = 't'
AND aux.estatus = 2
AND pdt.tipoproducto = 2
AND (UPPER(aux.cartera) = 'M' OR UPPER(aux.cartera) = 'V')
AND (LOWER(tbj.puesto) like '% uber %' 
OR LOWER(tbj.puesto) like '%didi%'
OR LOWER(tbj.puesto) like '%rappi%'  
OR LOWER(tbj.puesto) like '%taxi%' )
order by p.idorigen, p.idgrupo, p.idsocio
;

select * from carteravencida where (idorigenp,idproducto,idauxiliar)= (030209,32664,00002965);

activad laboral 
en Cartera morosa y vencida
salarios registrados en sistema,
socios que son taxistas (taxi propio o en renta, con concesion a nombre propio o en renta), y 
conductores de aplicacion Uber, Didi, Rappi, etc., 
tanto transporte como comida.

Datos del generales del socio (numero de socio, nombre, direccion, edad)

Informacion del credito (
    monto entregado, 
    fecha de entrega, 
    saldo actual, 
    estatus (M/V), 
    dias vencidos, 
    monto vencido, 
    sucursal que entrego el credito)
Actividad laboral 
Ingreso registrado

--El monto vencido y los dias vencidos se pueden sumar??
--limitar la fecha a fecha de trabajo
tbj.ocupacion
tbj.puesto
AND DATE(org.fechatrabajo) = CURRENT_DATE



SELECT tbj.puesto
from trabajo tbj
WHERE LOWER(puesto) like '% uber %' 
OR LOWER(puesto) like '%didi%'
OR LOWER(puesto) like '%rappi%'  
OR LOWER(puesto) like '%taxi%' 
ORDER BY tbj.puesto;

SELECT * from catalogo_menus 
where menu like '%puest%';

SELECT opcion,descripcion,orden 
FROM catalogo_menus
WHERE menu = 'tipo_ocupacion'
GROUP BY opcion,descripcion,orden
ORDER BY descripcion;

SELECT opcion,descripcion,orden 
FROM catalogo_menus
WHERE menu = 'tipo_ocupacion'
GROUP BY opcion,descripcion,orden
ORDER BY descripcion;

TRIM(TO_CHAR(p.idorigen, '099999')) 