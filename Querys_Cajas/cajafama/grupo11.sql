SELECT DISTINCT ON (p.idorigen,p.idgrupo,p.idsocio)
        TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
        TRIM(TO_CHAR(p.idgrupo, '09'))||'-'||
        TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
        nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE"
FROM personas p
    INNER JOIN auxiliares a 
        ON a.idorigen = p.idorigen
        AND a.idgrupo = p.idgrupo
        AND a.idsocio = p.idsocio
WHERE p.idgrupo = 11 
        ;