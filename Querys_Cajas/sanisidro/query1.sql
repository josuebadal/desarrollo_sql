--ORIGINAL
select  u.idusuario ,p_idorigen, p_idgrupo, p_idsocio ,p.nombre,p.appaterno,p.apmaterno,
p.fechanacimiento,p.calle,p.numeroext,p.colonia,p.municipio,p.estado,p.telefono
from usuarios u
inner join vpersonas p on (p.idorigen, p.idgrupo, p.idsocio)=(p_idorigen, p_idgrupo, p_idsocio)
where activo='t';
/*
    QUERY SAN ISIDRO
    Se agrego la columna ACTIVO para poder filtrar por
    usuario activo = t
    usuario inactivo = f
*/

select  u.idusuario , activo ,p_idorigen,p_idgrupo, p_idsocio ,p.nombre,p.appaterno,p.apmaterno,
p.fechanacimiento,p.calle,p.numeroext,p.colonia,p.municipio,p.estado,p.telefono
from usuarios u
inner join vpersonas p on (p.idorigen, p.idgrupo, p.idsocio)=(p_idorigen, p_idgrupo, p_idsocio)
ORDER BY activo DESC;