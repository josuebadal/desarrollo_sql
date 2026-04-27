SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(p.idgrupo, '09'))||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
CASE 
    WHEN p.sexo = 1 THEN 'HOMBRE'
    WHEN p.sexo = 2 THEN 'MUJER'
END AS "GENERO",
p.fechaingreso AS "INGRESO", 
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'||
TRIM(TO_CHAR(r.idgrupor, '09'))||'-'||
TRIM(TO_CHAR(r.idsocior, '099999')) AS "OGS RECOMENDANTE",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) AS "RECOMENDANTE",
CASE 
    WHEN (select p.sexo 
            from personas 
                where idorigen=r.idorigenr 
                and idgrupo =r.idgrupor 
                and idsocio = r.idsocior)= 1 THEN 'HOMBRE'
    WHEN (select p.sexo 
            from personas 
                where idorigen=r.idorigenr 
                and idgrupo =r.idgrupor 
                and idsocio = r.idsocior) = 2 THEN 'MUJER'
END AS "GENERO"
    FROM personas p
        INNER JOIN referencias r
        USING (idorigen,idgrupo,idsocio)
    WHERE p.medio_inf = 6
            AND r.tiporeferencia = 23
            AND p.fechaingreso 
            between @@Fecha Inicial:|f|01/01/2025@@ 
            AND @@Fecha Final:|f|31/03/2025@@ ;