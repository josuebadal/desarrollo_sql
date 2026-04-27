SELECT p.idorigen||'-'||p.idgrupo||'-'||p.idsocio AS ogs, nombre_x(p.appaterno, p.appaterno, p.nombre) as nombre ,p.fecharetiro, 'Defuncion' as causa_baja FROM personas as p
where causa_baja = 40
ORDER BY p.fecharetiro DESC;  