/*
Socio    31001,10,3924 
prestamo 31001,32612,45

select * from auxiliares_d
where (idorigenp,idproducto,idauxiliar) = (31001,32612,45)
order by fecha;

select * from amortizaciones
where (idorigenp,idproducto,idauxiliar) = (31001,32612,45)
AND todopag = 't' AND atiempo = 't'
order by idamortizacion;

SELECT
a.idorigen,a.idgrupo, a.idauxiliar,a.idorigenp,a.idproducto,a.idauxiliar

select idproducto,nombre,tipoproducto,tasaio, tasaiod from productos
where tasaiod > 0
AND idproducto between 30000 and 39999
AND tipoproducto = 2;

SELECT
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "OGS",
    TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
    TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA"
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
LEFT JOIN personas p
ON      p.idorigen = a.idorigen
AND     p.idgrupo  = a.idgrupo
AND     p.idsocio  = a.idsocio
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo != 3
AND cargoabono = 1
AND ad.fecha::date BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY    p.nombre,p.appaterno,p.apmaterno,p.idorigen,p.idgrupo,p.idsocio,
            ad.idorigenp,ad.idproducto,ad.idauxiliar

SELECT
ad.*,a.idorigen,a.idgrupo,a.idsocio     
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo != 3
AND cargoabono = 1
AND diasvencidos > 0
AND ad.fecha::date BETWEEN '2025-01-01' AND '2025-02-28'
ORDER BY ad.idauxiliar
;
*/

SELECT
TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA",
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'||TRIM(TO_CHAR(a.idgrupo,'09'))||'-'||TRIM(TO_CHAR(a.idsocio,'099999')) AS "OGS",
ad.periodo, 
a.tasaio,a.tasaim,a.tasaiod,ad.diasvencidos,ad.montoio,ad.montoim,
CASE
        WHEN ad.diasvencidos > 0 THEN ROUND((ad.montoio + montoim),4)
        WHEN ad.diasvencidos = 0 THEN ROUND(((montoio/tasaiod)*tasaio),4)
        ELSE 0 
END     AS "Interes",
ad.fecha     
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo != 3
AND cargoabono = 1
AND periodo = @@Producto:|c|202501@@
GROUP BY ad.idorigenp, ad.idproducto, ad.idauxiliar,
        a.idorigen,a.idgrupo,a.idsocio, ad.fecha,ad.periodo, 
        ad.diasvencidos,ad.montoio,ad.montoim,a.tasaio,a.tasaim,a.tasaiod
ORDER BY ad.fecha
;

SELECT
ad.idorigenp,ad.idproducto,ad.idauxiliar,
--a.idorigen,a.idgrupo,a.idsocio,
a.tasaio,a.tasaim,a.tasaiod,
ad.diasvencidos,
ad.monto,ad.montoio,ad.montoim,ad.montoiva,ad.montoivaim,
SUM(ad.diasvencidos + ad.monto + ad.montoio + ad.montoim + ad.montoiva + ad.montoivaim) as "int_sdesc"     
FROM auxiliares_d ad
LEFT JOIN auxiliares a
USING (idorigenp,idproducto,idauxiliar)
WHERE ad.idproducto BETWEEN 30000 AND 39999
AND ad.idtipo != 3
AND cargoabono = 1
AND diasvencidos > 0
AND ad.fecha::date BETWEEN '2025-01-01' AND '2025-01-30'
GROUP BY ad.idorigenp, ad.idproducto, ad.idauxiliar, ad.diasvencidos,
        ad.monto,ad.montoio,ad.montoim,ad.montoiva,ad.montoivaim
        ,a.tasaio,a.tasaim,a.tasaiod 
ORDER BY ad.idauxiliar
;