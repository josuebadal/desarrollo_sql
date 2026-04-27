Buen dia, me estan solicitando alguna informacion del sistema, me pueden ayudar con las siguiente consulta por favor.

--Total de socios (mujeres y hombres) con transacciones realizadas de credito, ahorro, seguros o remesas, en los ultimos doce meses o vigentes.

CONDICIONES: Si la fecha de colocacion /*fechaape*/ o fecha de ultimo pago son >= al 01ene del año evaluado 
o la fecha de vencimiento es >= 31dic. 
--O la fecha de apertura o ultimo movimiento de ahorro es >= al 01ene 
o la fecha de vencimiento de un plazo fijo es >= 31dic. --producto 200 otra condicion
--O la fecha de ultima transaccion de remesa es >= al 01ene. 
-- NO APLICA FECHA VENCIMIENTO O la fecha de vencimiento de una poliza de seguro es >= 01ene o del 31dic. Todo del año evaluado. (ejercicio 2023)

Que como resultado aparezca 
--**no. de socio, 
--**nombre, 
--**genero,
--**producto, 

--tipo de poliza,
--**monto, --se refiere al saldo o al monto prestado??
--**fecha de movimiento. --se refiere a Fechauma?

informacion del 01 de Enero al 31 de diciembre 2023 --where rango de fecha, contra que dato se valida.?
cargos y abonos en los productos 110,120,130,200,160,163 y todos los productos de credito. --usar un OR como la vez pasada


Total de socias mujeres con transacciones realizadas de credito, ahorro, seguros o remesas, en los ultimos doce meses o vigentes.
ultima transaccion <= fecha de evaluacion 
 * Credito fecha ultimo pago o renovacion
 * Ahorro fecha ultimo deposito o retiro -- fecha uma NO REQUIERE SABER que tipo de movimiento fue
 * Remesas fecha ultima transaccion Fecha de vencimiento >= fecha de evaluacion 
 * Plazo fijo 
 * Seguros

En ambas consultas para nosotros no aplica las remesas.


SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "NOMBRE",
CASE 
    WHEN p.sexo = 1 THEN 'HOMBRE'
    WHEN p.sexo = 2 THEN 'MUJER'
    ELSE 'NO ESPECIFICADO'
END AS "GENERO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre,a.saldo, a.fechauma AS "ULT.MOV",
(select vence from amortizaciones am JOIN auxiliares a1 ON a.idorigenp= am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
ORDER BY idamortizacion DESC limit 1)
FROM auxiliares a 
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
WHERE p.estatus = 't' AND a.estatus = 2 AND (( pr.idproducto IN (110,120,130,160,163))) --OR (pr.tipoproducto = 2)
AND  ((a.fechaape::date BETWEEN '2023-01-01' AND '2023-12-31') OR (a.fechauma >= '01/01/2023') OR ((
    SELECT vence FROM amortizaciones am JOIN auxiliares a1 ON a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
    ORDER BY idamortizacion DESC LIMIT 1)::date BETWEEN '2023-01-01' AND '2023-12-31'))
;

-----------------------------------------------------------------------------------------------------------------------------------------------
Agregar la informacion de la poliza 
INTENTO 2
--se hago una subconsulta para la poliza me traera la ultima poliza al ordenar por DESC  

SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "NOMBRE",
CASE 
    WHEN p.sexo = 1 THEN 'HOMBRE'
    WHEN p.sexo = 2 THEN 'MUJER'
    ELSE 'NO ESPECIFICADO'
END AS "GENERO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre,a.fechaape,a.saldo, a.fechauma AS "ULT.MOV",
(select vence from amortizaciones am JOIN auxiliares a1 ON a.idorigenp= am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
ORDER BY idamortizacion DESC limit 1),
(select idtipo from polizas pol JOIN auxiliares a2 ON a.idorigen = pol.idorigenc LIMIT 1) AS "Tipo Poliza"
FROM auxiliares a 
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
WHERE p.estatus = 't' AND a.estatus = 2 AND (( pr.idproducto IN (110,120,130,160,163))) OR (pr.tipoproducto = 2)
AND  ((a.fechaape::date BETWEEN '2023-01-01' AND '2023-12-31') OR (a.fechauma::date >= '2023-01-01') OR ((
    SELECT vence FROM amortizaciones am JOIN auxiliares a1 ON a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
    ORDER BY idamortizacion DESC LIMIT 1)::date BETWEEN '2023-01-01' AND '2023-12-31'))
ORDER BY p.idorigen, p.idgrupo, p,idsocio
;

-----------------------------------------------------------------------------------------------------------------------------------------------
INTENTO 3 
-- se intento hacer un INNER a POLIZAS tarda demasiado se usara la subconsulta

SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "NOMBRE",
CASE 
    WHEN p.sexo = 1 THEN 'HOMBRE'
    WHEN p.sexo = 2 THEN 'MUJER'
    ELSE 'NO ESPECIFICADO'
END AS "GENERO",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre,a.fechaape,a.saldo, a.fechauma AS "ULT.MOV",
(select vence from amortizaciones am JOIN auxiliares a1 ON a.idorigenp= am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
ORDER BY idamortizacion DESC limit 1),
(select idtipo from polizas pol JOIN auxiliares a2 ON a.idorigen = pol.idorigenc LIMIT 1) AS "Tipo Poliza"
FROM auxiliares a 
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
WHERE p.estatus = 't' AND a.estatus = 2 AND (( pr.idproducto IN (110,120,130,160,163))) OR (pr.tipoproducto = 2)
AND  ((a.fechaape::date BETWEEN '2023-01-01' AND '2023-12-31') OR (a.fechauma::date >= '2023-01-01') OR ((
    SELECT vence FROM amortizaciones am JOIN auxiliares a1 ON a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
    ORDER BY idamortizacion DESC LIMIT 1)::date BETWEEN '2023-01-01' AND '2023-12-31'))
ORDER BY p.idorigen, p.idgrupo, p,idsocio
;
--- SEGUNDO QUERY SOLO PARA MUJERES

SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigenp, '099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre,a.fechaape,a.saldo, a.fechauma AS "ULT.MOV",
(select vence from amortizaciones am JOIN auxiliares a1 ON a.idorigenp= am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
ORDER BY idamortizacion DESC limit 1),
(select idtipo from polizas pol JOIN auxiliares a2 ON a.idorigen = pol.idorigenc LIMIT 1) AS "Tipo Poliza"
FROM auxiliares a 
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
WHERE p.estatus = 't' AND p.sexo = 2 AND a.estatus = 2 
AND (( pr.idproducto IN (110,120,130,160,163) AND (a.fechaape > '2023-01-01' OR a.fechauma > '2023-01-01'))
OR  (pr.tipoproducto = 2 AND (a.fechaape > '2023-01-01' OR a.fechauma > '2023-01-01'
OR ((SELECT vence FROM amortizaciones am JOIN auxiliares a1 ON a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
ORDER BY idamortizacion DESC LIMIT 1)::date BETWEEN '2023-01-01' AND '2023-12-31'))))
ORDER BY p.idorigen, p.idgrupo, p,idsocio
;



AND (( pr.idproducto IN (110,120,130,160,163) AND (pr.fechaape > '2023-01-01' OR pr.fechauma > '2023-01-01'))OR (pr.tipoproducto = 2))



SELECT nombre, idproducto from productos
where (LOWER(nombre) like '%seguro%');

-- OBTENEMOS EL DATO DE LA ULTIMA FECHA DE LA AMORTIZACION DE CREDITOS
amortizaciones_para_contratos - auxiliares
idorigenp      | 31001
idproducto     | 30102
idauxiliar     | 1002116
(select * from amortizaciones where idorigenp = 30214 AND idproducto = 36644 AND idauxiliar =1344
ORDER BY idamortizacion DESC limit 1;)

fechaape = fecha de entrega --debo meter eso en mi condicion para fecha
select  idproducto,nombre, tipoproducto from productos where idproducto;

select DATE(a.fechaape) + INTERVAL '84 days';
,200 AND a.fechaape <= ((select distinct date(fechatrabajo) from origenes limit 1) - INTERVAL '1 years')
--traer todas las polizas auxilires_d
select distinct(plazo) from auxiliares where idproducto = 200;
select distinct(plazo) from auxiliares WHERE idproducto >= 30000 AND idproducto <= 39909;;
