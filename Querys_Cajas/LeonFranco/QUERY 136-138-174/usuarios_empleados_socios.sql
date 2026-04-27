select u.idusuario AS "usuario_saicoop",u.nombre AS "nombre_saicoop",
u.activo AS "estatus", 
TRIM(TO_CHAR(u.p_idorigen, '099999')) || '-' || 
TRIM(TO_CHAR(u.p_idgrupo, '09')) || '-' || 
TRIM(TO_CHAR(u.p_idsocio, '099999')) AS "socio_empleado",

(select nombre_x(p.nombre,p.appaterno,p.apmaterno) 
    from personas p
    where p.idorigen=u.p_idorigen 
        and p.idgrupo =u.p_idgrupo 
        and p.idsocio = u.p_idsocio) as "nombre_empleado_g80",

( SELECT p1.idorigen
    from personas p1
    where nombre_x(p1.nombre, p1.appaterno, p1.apmaterno)  =
            (select nombre_x(p.nombre,p.appaterno,p.apmaterno) 
            from personas p
            where p.idorigen=u.p_idorigen 
            and p.idgrupo =u.p_idgrupo 
            and p.idsocio = u.p_idsocio)
        AND p1.idgrupo = 10
        LIMIT 1
    ) AS "idorigen_g10",
        
( SELECT p1.idgrupo
    from personas p1
    where nombre_x(p1.nombre, p1.appaterno, p1.apmaterno)  =
            (select nombre_x(p.nombre,p.appaterno,p.apmaterno) 
            from personas p
            where p.idorigen=u.p_idorigen 
            and p.idgrupo =u.p_idgrupo 
            and p.idsocio = u.p_idsocio)
        AND p1.idgrupo = 10
        LIMIT 1
    ) AS "idgrupo_g10",

( SELECT p1.idsocio
    from personas p1
    where nombre_x(p1.nombre, p1.appaterno, p1.apmaterno)  =
            (select nombre_x(p.nombre,p.appaterno,p.apmaterno) 
            from personas p
            where p.idorigen=u.p_idorigen 
            and p.idgrupo =u.p_idgrupo 
            and p.idsocio = u.p_idsocio)
        AND p1.idgrupo = 10
        LIMIT 1
    ) AS "idsocio_g10"    
from usuarios as u
where u.activo = 't'
ORDER BY u.idusuario
;

