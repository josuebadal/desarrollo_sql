/*
CAPITAL ACTIVO   26 NOVIEMBRE 2025
1. Listado de la totalidad de 
****clientes activos 
con una cuenta de credito 
aperturada o activa durante 
enero 2025 a octubre 2025 (en Excel, SOLAMENTE CON LOS SIGUIENTES DATOS: 
con el 
--numero consecutivo, 
--nombre del socio, 
--monto del credito, 
--tipo de credito, 
--plazo, 
--fecha de apertura, 
--si esta vigente, pagado o en mora, 
--el monto mayor del pago realizado al credito 
y bajo que metodo de pago se realizo el pago mayor. */

----- CTE EN CASO DE NECESITAR -----
/*
select ad.idorigenp, ad.idproducto, ad.idauxiliar, MAX(ad.monto)
, a.idorigen, a.idgrupo, a.idsocio
from auxiliares_d as ad
LEFT JOIN auxiliares as  a 
ON ad.idorigenp = a.idorigenp
AND ad.idproducto = a.idproducto
AND ad.idauxiliar = a.idauxiliar
where a.fechaape::date between '01-01-2025' and '31-10-2025'
AND ad.cargoabono = 1
AND ad.idproducto between 30000 and 39999  
GROUP BY ad.idorigenp, ad.idproducto, ad.idauxiliar 
,a.idorigen, a.idgrupo, a.idsocio
;*/

----- VERSION CONSULTA -----
/*
select ad.idorigenp, ad.idproducto, ad.idauxiliar, MAX(ad.monto)
, a.idorigen, a.idgrupo, a.idsocio
from auxiliares_d as ad
LEFT JOIN auxiliares as  a 
ON ad.idorigenp = a.idorigenp
AND ad.idproducto = a.idproducto
AND ad.idauxiliar = a.idauxiliar
LEFT JOIN personas as p 
ON a.idorigen = p.idorigen 
AND a.idgrupo = p.idgrupo
AND a.idsocio = p.idsocio
where a.fechaape::date between '01-01-2025' and '31-10-2025'
AND ad.cargoabono = 1
AND ad.idproducto between 30000 and 39999
AND p.estatus = 't'  
GROUP BY ad.idorigenp, ad.idproducto, ad.idauxiliar 
,a.idorigen, a.idgrupo, a.idsocio
;*/


----- VERSION FINAL PARA SAICOOP -----

SELECT * FROM (
WITH montos AS (
    SELECT 
        ad.idorigenp, ad.idproducto, ad.idauxiliar, 
        MAX(ad.monto) AS montomax,
        a1.idorigen, a1.idgrupo, a1.idsocio, ad.idtipo, ad.tipomov
    FROM auxiliares_d ad
    INNER JOIN auxiliares a1 
           ON ad.idorigenp = a1.idorigenp
          AND ad.idproducto = a1.idproducto
          AND ad.idauxiliar = a1.idauxiliar
    WHERE a1.fechaape::date BETWEEN '2025-01-01' AND '2025-10-31'
      AND ad.cargoabono = 1
      AND ad.idproducto BETWEEN 30000 AND 39999  
    GROUP BY 
        ad.idorigenp, ad.idproducto, ad.idauxiliar,
        a1.idorigen, a1.idgrupo, a1.idsocio, ad.idtipo, ad.tipomov
)
SELECT 
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "Nombre",
'|' AS "|",
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'|| 
TRIM(TO_CHAR(a.idgrupo,'09'))||'-'|| 
TRIM(TO_CHAR(a.idsocio,'099999')) as "Socio",
'|' AS "|",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'||
TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) as "Credito",
'|' AS "|",
a.montoprestado as "mnt_prtm",
'|' AS "|", 
pr.nombre as "tipo_crdt",
'|' AS "|", 
a.plazo as "plazo",
'|' AS "|", 
a. fechaape  as "apertura",
'|' AS "|",
(CASE 
    WHEN UPPER(a.cartera) = 'C' THEN 'VIGENTE'
    ELSE 'VENCIDO'
    END) as "cartera",
'|' AS "|",
(CASE 
    WHEN a.estatus = 0 THEN 'CAPTURADO'
    WHEN a.estatus = 1 THEN 'AUTORIZADO'
    WHEN a.estatus = 2 THEN 'ACTIVO'
    WHEN a.estatus = 3 THEN 'PAGADO'
    WHEN a.estatus = 4 THEN 'CANCELADO'
    END) as "estatus",
'|' AS "|",
m.montomax as "monto",
'|' AS "|",
(CASE 
    WHEN m.idtipo = 1 THEN 'Ventanilla'
    WHEN m.idtipo = 2 THEN 'Cheque'
    WHEN m.idtipo = 3 THEN 'Traspaso'
    ELSE 'Otro' END) as "Tipo",
'|' AS "|",
(CASE 
    WHEN m.tipomov = 0 THEN 'Abono'
    WHEN m.tipomov = 1 THEN 'Castigo'
    WHEN m.tipomov = 2 THEN 'Quita'
    WHEN m.tipomov = 3 THEN 'Condonacion'
    WHEN m.tipomov = 4 THEN 'Bonificacion'
    WHEN m.tipomov = 6 THEN 'Ajuste'
    ELSE 'ND' END) as "Movimiento"
FROM auxiliares as a
INNER JOIN montos as m 
ON m.idorigenp = a.idorigenp
AND m.idproducto = a.idproducto
AND m.idauxiliar = a.idauxiliar
INNER JOIN personas as p
ON  p.idorigen = a.idorigen
AND p.idgrupo = a.idgrupo
AND p.idsocio = a.idsocio
INNER JOIN productos pr
ON pr.idproducto = a.idproducto
WHERE p.estatus = 't'
) as x;
