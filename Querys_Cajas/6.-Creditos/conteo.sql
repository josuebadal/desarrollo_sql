/*
REPORTE QUE ME INDIQUE QUE SOCIOS TIENEN 3 O MAS LINEAS DE CREDITO ACTIVAS 
Y QUE TENGAN 1 O MAS CON DIAS VENCIDOS Y QUE PORCENTAJE ME REPRESENTA.

SERIA TOMANDO COMO BASE LOS SIGUIENTE PRODUCTOS:
--30202-CREDICUMPLIDO
--30302-AUTOMOVIL
--30402-CONFIANZA
--30502-ADICIONAL
--30602-MAXIMO
--30802-HIPOTECARIO CONSUMO
--30902-MAXIMO ESPECIAL
--31302-PREAUTORIZADO
--31402-ADICIONAL ESCOLAR
--31612-COVID19
--31703-HIPOTECARIO VIVIENDA
--31902-MOTOCICLETA
--32102-CREDINOMINA
--32202-CREDIJOVEN
33102-REVOLVENTE
*/

-----SOCIOS CON ALMENOS UN CREDITO CON DIAS VENCIDOS MAYOR A 0
select nombre_x(p.appaterno,p.apmaterno,p.nombre) as "nombre",
'|' AS "|", 
TRIM(TO_CHAR(a.idorigen,'09999'))||'-'|| 
TRIM(TO_CHAR(a.idgrupo,'09'))||'-'||
TRIM(TO_CHAR(a.idsocio,'099999')) AS "OGS",
'|' AS "|",
TRIM(TO_CHAR(cv.idorigenp,'099999'))||'-'||
TRIM(TO_CHAR(cv.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(cv.idauxiliar,'09999999')) AS "OPA",
'|' AS "|",
cv.diasvencidos 
from carteravencida as cv
LEFT JOIN auxiliares as  a 
using (idorigenp,idproducto,idauxiliar)
LEFT JOIN personas as p
ON  a.idorigen = p.idorigen
AND a.idgrupo  = p.idgrupo
AND a.idsocio  = p.idsocio
where cv.idproducto in (30202,30302,30402,30502,30602,30802,30902,31302,31402,31612,31703,31902,32102,32202,33102)
AND cv.diasvencidos > 0
order by a.idorigen,a.idgrupo,a.idsocio desc;




-----VERSION CON HAVING
SELECT * FROM (
WITH socios_con_3 AS (
    SELECT 
        a.idorigen,
        a.idgrupo,
        a.idsocio
    FROM auxiliares a
    WHERE a.idproducto IN (30202,30302,30402,30502,30602,30802,30902,31302,31402,31612,31703,31902,32102,32202,33102)
      AND a.estatus = 2
    GROUP BY a.idorigen, a.idgrupo, a.idsocio
    HAVING COUNT(*) >= 3
)
SELECT 
    nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "nombre",
    '|' AS "|",
    TRIM(TO_CHAR(a.idorigen,'09999'))||'-'||TRIM(TO_CHAR(a.idgrupo,'09'))||'-'||TRIM(TO_CHAR(a.idsocio,'099999')) AS "OGS",
    '|' AS "|",
    TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
    '|' AS "|",
    a.saldo
FROM auxiliares a
JOIN socios_con_3 s
  ON s.idorigen = a.idorigen
 AND s.idgrupo  = a.idgrupo
 AND s.idsocio  = a.idsocio
LEFT JOIN personas p
       ON a.idorigen = p.idorigen
      AND a.idgrupo  = p.idgrupo
      AND a.idsocio  = p.idsocio
WHERE a.idproducto IN (30202,30302,30402,30502,30602,30802,30902,31302,31402,31612,31703,31902,32102,32202,33102)
  AND a.estatus = 2
ORDER BY a.idorigen,a.idgrupo,a.idsocio DESC
) as x;





-----VERSION FINAL PARA CONTAR 3 PRODUCTOS SIN HAVING
SELECT *
FROM (
    SELECT 
        nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "nombre", 
        a.idorigen, a.idgrupo, a.idsocio,
        a.idproducto, a.idauxiliar
    FROM auxiliares a
    LEFT JOIN personas p
           ON a.idorigen = p.idorigen
          AND a.idgrupo  = p.idgrupo
          AND a.idsocio  = p.idsocio
    WHERE a.idproducto IN (30202,30302,30402,30502,30602,30802,30902,31302,31402,31612,31703,31902,32102,32202,33102)
      AND a.estatus = 2
) t
WHERE (
    SELECT COUNT(*)
    FROM auxiliares a2
    WHERE a2.idorigen = t.idorigen
      AND a2.idgrupo  = t.idgrupo
      AND a2.idsocio  = t.idsocio
      AND a2.idproducto IN (30202,30302,30402,30502,30602,30802,30902,31302,31402,31612,31703,31902,32102,32202,33102)
      AND a2.estatus = 2
) >= 3
ORDER BY t.idorigen, t.idgrupo, t.idsocio DESC;
