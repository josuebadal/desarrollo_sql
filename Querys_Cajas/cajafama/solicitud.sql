--CAJA FAMA 27 AGOSTO 2025

Buen dia esperando y se encuentren de lo mejor.
Solicitando de su apoyo en la generacion de un reporte en donde los resultados me arrojen los socios que fueron dados de alta solamente por recomendacion, asi tambien el nombre del socio de quien recomendo del año 2024 a la fecha.

--AGREGAR RANGOS DE FECHA
socios que fueron dados de alta solamente por recomendacion, asi tambien el nombre del socio de quien recomendo del año 2024 a la fecha

(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) as nombre_socio,

SELECT * from catalogo_menus 
where LOWER(descripcion) like '%reco%';


   menu     | opcion |  descripcion  | orden | activo  
-------------+--------+---------------+-------+-------+
 medio_inf   |      6 | Recomendacion |     6 | t
 referenciap |     23 | Recomendante  |    24 | t

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'referencias';

column_name   |     data_type     
----------------+-------------------
 idorigen       | integer
 idgrupo        | integer
 idsocio        | integer
 tiporeferencia | numeric
 referencia     | character varying
 idorigenr      | integer
 idgrupor       | integer
 idsocior       | integer


SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(p.idgrupo, '09'))||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'||
TRIM(TO_CHAR(r.idgrupor, '09'))||'-'||
TRIM(TO_CHAR(r.idsocior, '099999')) AS "OGS RECOMENDANTE",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) AS "RECOMENDANTE"
FROM personas p
INNER JOIN referencias r
USING (idorigen,idgrupo,idsocio)
WHERE p.medio_inf = 6
--AND p.causa_baja <>0
AND r.tiporeferencia = 23
AND p.fechaingreso > date('31/12/2023')
between
@@Fecha ini:|f|01/12/2023@@ 
and 
@@Fecha fin:|f|31/07/2025@@;

---------------------------------------------------------
SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(p.idgrupo, '09'))||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'||
TRIM(TO_CHAR(r.idgrupor, '09'))||'-'||
TRIM(TO_CHAR(r.idsocior, '099999')) AS "OGS RECOMENDANTE",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) AS "RECOMENDANTE"
FROM personas p
INNER JOIN referencias r
USING (idorigen,idgrupo,idsocio)
WHERE p.medio_inf = 6
AND r.tiporeferencia = 23
AND p.fechaingreso > date('31/12/2023');

--------------------------------------------------
--------------------------------------------------
(select 
    TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || 
    TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || 
    TRIM(TO_CHAR(p.idsocio, '099999'))
    from personas p1
    WHERE nombre_x(p1.nombre, p1.appaterno, p1.apmaterno)  = (select nombre_x(p.nombre,p.appaterno,p.apmaterno) 
                from personas p
                where p.idorigen=u.p_idorigen 
                and p.idgrupo =u.p_idgrupo 
                and p.idsocio = u.p_idsocio)
        AND p.idgrupo = 10) AS "socio_mayor"