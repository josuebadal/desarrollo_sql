/*
select * from personas where estatus = 't' and idgrupo = 10;

select * from catalogo_menus where menu = 'nacionalidad' order by opcion;
menu        | nacionalidad
opcion      | 1

Me pueden ayudar con 2 consultas por favor:
Relacion de socios activos al cierre de octubre que contenga lo siguientes datos:
--Numero del socio
--Nombre del socio
--Genero
--Fecha de nacimiento
--Entidad federativa
--Pais de Nacimiento
--Nacionalidad
Ocupacion
--Calle No.
--Colonia
--Delegacion o Municipio
--Ciudad Poblacion
--Entidad Federativa
--Codigo Postal
--Pais
--No. de Telefono
CURP
RFC
RFC con homoclave (P.F. Con Act. Emp.)*/

SELECT p.idorigen||'-'||p.idgrupo||'-'|| p.idsocio AS "Socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "Nombre",
'|' AS "|",
(CASE 
        WHEN p.sexo = 1 THEN 'Masculino'
        WHEN p.sexo = 2 THEN 'Femenino'
        Else 'NR' End) AS "Sexo",
'|' AS "|",
p.fechanacimiento AS "Fecha Nac",
'|' AS "|",
(SELECT est2.nombre from estados est2 where p.efnacimiento = est2.idestado) AS "Entidad Fed Nac",
'|' AS "|",
p.lugarnacimiento AS "Lugar Nac",
'|' AS "|",
(SELECT pai1.nombre from paises pai1 where p.pais_nacimiento  = pai1.idpais) AS "Pais Nac",
'|' AS "|",
(select  cm.descripcion from catalogo_menus cm where cm.menu = 'nacionalidad' AND p.nacionalidad = cm.opcion ) AS "Nacionalidad",
'|' AS "|",
tr.puesto AS "Ocupacion",
'|' AS "|",
p.calle AS "Calle",
'|' AS "|",
p.numeroint AS "Num Int",
'|' AS "|",
p.numeroext AS "Num Ext",
'|' AS "|",
col.nombre AS "Colonia",
'|' AS "|",
col.codigopostal  AS "Cod Postal",
'|' AS "|",
mun.nombre AS "Municipio",
'|' AS "|",
est.nombre AS "Estado",
'|' AS "|",
pai.nombre AS "Pais",
'|' AS "|",
p.telefono AS "Tel Casa",
'|' AS "|",
p.celular AS "Tel Celular",
'|' AS "|",
p.telefonorecados "Tel Recados",
'|' AS "|",
p.curp AS "Curp",
p.rfc AS "RFC"
FROM personas p
    INNER JOIN colonias col
    ON      p.idcolonia = col.idcolonia
    INNER JOIN municipios mun 
    ON      col.idmunicipio = mun.idmunicipio
    INNER JOIN estados est
    ON      mun.idestado = est.idestado
    INNER JOIN paises pai
    ON      est.idpais = pai.idpais
    INNER JOIN trabajo tr
    ON      p.idorigen = tr.idorigen
    AND     p.idgrupo  = tr.idgrupo
    AND     p.idsocio  = tr.idsocio
WHERE p.estatus = 't'
AND p.idgrupo IN  (10,20)
ORDER BY p.fechanacimiento DESC  
;
