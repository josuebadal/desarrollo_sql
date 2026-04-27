SELECT 
DISTINCT ON(a.idorigenp,a.idproducto,a.idauxiliar)
    ---SE DEBERA ELIMINAR EL NOMBRE Y EL OGS
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "Socio",
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    p.telefono,
    (CASE 
        WHEN p.telefono        !='' THEN 'Casa'  
        END) AS "tipo",
    p.celular,
    (CASE 
        WHEN p.celular         !=''THEN 'Celular'  
        END) AS "tipo",
    p.telefonorecados,
    (CASE 
        WHEN p.telefonorecados != '' THEN 'Oficina'  
        END) AS "tipo"
    /*
    CASE
    WHEN NULLIF(p.telefono,'') IS NULL 
         AND NULLIF(p.telefonorecados,'') IS NULL 
    THEN p.celular
    WHEN NULLIF(p.celular,'') IS NULL 
         AND NULLIF(p.telefono,'') IS NULL 
    THEN p.telefonorecados
    WHEN NULLIF(p.celular,'') IS NULL 
         AND NULLIF(p.telefonorecados,'') IS NULL 
    THEN p.telefono
    ELSE '0000000000'  
END AS "telefono",
    '0' AS "extension",
    CASE
    WHEN NULLIF(p.telefono,'') IS NULL 
         AND NULLIF(p.telefonorecados,'') IS NULL 
    THEN 'Celular'
    WHEN NULLIF(p.celular,'') IS NULL 
         AND NULLIF(p.telefono,'') IS NULL 
    THEN 'Oficina'
    WHEN NULLIF(p.celular,'') IS NULL 
         AND NULLIF(p.telefonorecados,'') IS NULL 
    THEN p.telefono
    ELSE 'NA'  
END AS "Tipo"
    (CASE 
        WHEN p.telefono        IS ''
        AND  p.telefonorecados IS '' THEN CELULAR
        WHEN p.celular         IS ''
        AND  p.telefono        IS '' THEN OFICINA
        WHEN p.celular         IS ''
        AND  p.telefonorecados IS '' THEN FIJO 
        ) AS "tipo"
        */
    FROM auxiliares a
    INNER JOIN personas p
    ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo
    AND a.idsocio = p.idsocio 
    where a.estatus = 2
    AND p.estatus = 't'
    AND a.idproducto between 30000 AND 39999;