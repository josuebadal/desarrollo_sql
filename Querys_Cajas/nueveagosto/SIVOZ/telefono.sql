SELECT 
DISTINCT ON(a.idorigenp,a.idproducto,a.idauxiliar)
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
    /* SE AGREGO SOLO PARA VALIDACION SE DEBE ELIMINAR
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) AS "Socio",
    nombre_x(p.nombre,p.appaterno,p.apmaterno) AS "Nombre",
    */
    p.telefono,
    (CASE 
        WHEN p.telefono        !='' THEN 'Casa'  
        END) AS "tipo",
    p.celular,
    (CASE 
        WHEN p.celular         !=''THEN 'Celular'  
        END) AS "tipo",
    p.telefonorecados,
    length(p.telefonorecados) = 0 as longitud,
    (CASE 
        WHEN p.telefonorecados != '' THEN 'Oficina'  
        END) AS "tipo"
    FROM auxiliares a
    INNER JOIN personas p
    ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo
    AND a.idsocio = p.idsocio 
    where a.estatus = 2
    AND p.estatus = 't'
    AND a.idproducto between 30000 AND 39999;