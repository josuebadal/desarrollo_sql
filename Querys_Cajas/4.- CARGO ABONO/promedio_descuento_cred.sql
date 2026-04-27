/*
Promedio del porcentaje de descuento de abonos de todos los socios activos  por periodo, de todos los productos y solo los abonos de cada producto.


select * from  auxiliares_d ad
where ad.idtipo = 1
AND cargoabono = 1
order by fecha desc limit 10;

select * from  auxiliares_d ad
where (idorigenp,idproducto,idauxiliar) = (30103,32602,99);
*/

SELECT
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
    TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
    TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA",
    ROUND(SUM(ad.efectivo)::numeric, 4) AS "Suma Depositos",
    COUNT(ad.efectivo) AS "Num Depo",
    ROUND(AVG(ad.efectivo)::numeric, 4) AS "Promedio" 
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
LEFT JOIN personas p
ON      p.idorigen = a.idorigen
AND     p.idgrupo  = a.idgrupo
AND     p.idsocio  = a.idsocio
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo = 1
AND cargoabono = 1
AND ad.fecha::date BETWEEN '2025-01-01' AND '2025-06-30'
GROUP BY    p.nombre,p.appaterno,p.apmaterno,p.idorigen,p.idgrupo,p.idsocio,
            ad.idorigenp,ad.idproducto,ad.idauxiliar
UNION
SELECT
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
    TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
    TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA",
    ROUND(SUM(ad.efectivo)::numeric, 4) AS "Suma Depositos",
    COUNT(ad.efectivo) AS "Num Depo",
    ROUND(AVG(ad.efectivo)::numeric, 4) AS "Promedio" 
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
LEFT JOIN personas p
ON      p.idorigen = a.idorigen
AND     p.idgrupo  = a.idgrupo
AND     p.idsocio  = a.idsocio
WHERE ad.idproducto BETWEEN 100 AND 999
AND ad.idtipo = 1
AND cargoabono = 1
AND ad.fecha::date BETWEEN '2025-01-01' AND '2025-06-30'
GROUP BY    p.nombre,p.appaterno,p.apmaterno,p.idorigen,p.idgrupo,p.idsocio,
            ad.idorigenp,ad.idproducto,ad.idauxiliar
            ;

--=====================================================================
--VERSION DE SAICOOP

SELECT
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
    TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
    TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA",
    ROUND(SUM(efectivo)::numeric, 4) AS "Suma Depositos",
    COUNT(efectivo) AS "Num Depo",
    ROUND(AVG(efectivo)::numeric, 4) AS "Promedio" 
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
LEFT JOIN personas p
ON      p.idorigen = a.idorigen
AND     p.idgrupo  = a.idgrupo
AND     p.idsocio  = a.idsocio
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo = 1
AND cargoabono = 1
AND ad.fecha::date BETWEEN  @@Fecha ini:|f|01/01/2025@@  
                        AND @@Fecha fin:|f|30/06/2025@@ 
GROUP BY    p.nombre,p.appaterno,p.apmaterno,p.idorigen,p.idgrupo,p.idsocio,
            ad.idorigenp,ad.idproducto,ad.idauxiliar
;