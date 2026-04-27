--Reporte de socios que tienen desde 55 años en adelante (tercera edad), en donde viven y fecha que ingresó a la cooperativa y teléfono.

SELECT 
TRIM(TO_CHAR(p.idorigen,'099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo,'09'))|| '-'||
TRIM(TO_CHAR(p.idsocio,'099999')) AS "socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "nombre",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) AS "Edad",
'|' AS "|",
p.fechaingreso "f_ingreso",
'|' AS "|",
p.telefono AS "telefono",
'|' AS "|",
p.telefonorecados AS "recados",
'|' AS "|",
p.celular AS "celular",
'|' AS "|",
COALESCE(p.calle,'NR') AS "calle",
'|' AS "|",
COALESCE(p.numeroext,'NR') AS "num_ext",
'|' AS "|",
COALESCE(p.numeroint,'NR') AS "num_int",
'|' AS "|",
COALESCE(p.entrecalles,'NR') AS "entrecalles",
'|' AS "|",
col.nombre AS "colonia"
FROM personas p
INNER JOIN colonias col
ON col.idcolonia = p.idcolonia
WHERE p.estatus = 't'
AND p.idgrupo= 10
AND  EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) > 55;




--Reporte de socios menores que están entre los 6 años y 13 años,colonia donde viven y fecha de ingreso a la cooperativa.

SELECT 
TRIM(TO_CHAR(p.idorigen,'099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo,'09'))|| '-'||
TRIM(TO_CHAR(p.idsocio,'099999')) AS "socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "nombre",
'|' AS "|",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) AS "Edad",
'|' AS "|",
p.fechaingreso "f_ingreso",
'|' AS "|",
COALESCE(p.calle,'NR') AS "calle",
'|' AS "|",
COALESCE(p.numeroext,'NR') AS "num_ext",
'|' AS "|",
COALESCE(p.numeroint,'NR') AS "num_int",
'|' AS "|",
COALESCE(p.entrecalles,'NR') AS "entrecalles",
'|' AS "|",
col.nombre AS "colonia"
FROM personas p
INNER JOIN colonias col
ON col.idcolonia = p.idcolonia
WHERE p.estatus = 't'
AND p.idgrupo = 20
AND  EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) BETWEEN 6 AND 13;



--Reporte de socios con escolaridad profesional, edad entre los 24 a 45 años, y con antigüedad de más de un año dentro de la cooperativa


SELECT 
TRIM(TO_CHAR(p.idorigen,'099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo,'09'))|| '-'||
TRIM(TO_CHAR(p.idsocio,'099999')) AS "socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "nombre",
'|' AS "|",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) AS "edad",
'|' AS "|",
(CASE 
        WHEN p.grado_estudios = 6 THEN 'Profesional'
        WHEN p.grado_estudios = 8 THEN 'Profesional Tecnico'
        END) AS "escolaridad",
'|' AS "|",
p.fechaingreso "f_ingreso",
'|' AS "|",
COALESCE(p.calle,'NR') AS "calle",
'|' AS "|",
COALESCE(p.numeroext,'NR') AS "num_ext",
'|' AS "|",
COALESCE(p.numeroint,'NR') AS "num_int",
'|' AS "|",
COALESCE(p.entrecalles,'NR') AS "entrecalles",
'|' AS "|",
col.nombre AS "colonia"
FROM personas p
INNER JOIN colonias col
ON col.idcolonia = p.idcolonia
WHERE p.estatus = 't'
AND p.grado_estudios IN (6,8)
AND p.idgrupo = 10
AND p.fechaingreso <=((select distinct date(fechatrabajo) from origenes limit 1) - INTERVAL '1 years')
AND  EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) BETWEEN 24 AND 45;