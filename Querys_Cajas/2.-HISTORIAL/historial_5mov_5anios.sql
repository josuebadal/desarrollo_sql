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
--Ocupacion
--Calle No.
--Colonia
--Delegacion o Municipio
--Ciudad Poblacion
--Entidad Federativa
--Codigo Postal
--Pais
--No. de Telefono
--CURP
--RFC
*/

SELECT p.idorigen||'-'||p.idgrupo||'-'|| p.idsocio AS "Socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "Nombre",
'|' AS "|",
(CASE 
        WHEN p.sexo = 1 THEN 'Masculino'
        WHEN p.sexo = 2 THEN 'Femenino'
        Else 'NR' End) AS "Sexo",
'|' AS "|",
TRIM(to_char(a.idorigenp,'099999'))||'-'||
TRIM(to_char(a.idproducto,'09999'))||'-'||
TRIM(to_char(a.idauxiliar,'09999999')) AS "OPA", 
'|' AS "|",
a.fechaape,
'|' AS "|",
p.fechanacimiento AS "Fecha Nac",
'|' AS "|",
p.lugarnacimiento AS "Lugar Nac",
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
'|' AS "|",
p.rfc AS "RFC"
FROM personas p
    INNER JOIN auxiliares a
    ON      p.idorigen = a.idorigen
    AND     p.idgrupo  = a.idgrupo
    AND     p.idsocio  = a.idsocio
    LEFT JOIN auxiliares_d ad 
    ON      a.idorigenp = ad.idorigenp
    AND     a.idproducto = ad.idproducto
    AND     a.idauxiliar = ad.idauxiliar
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
AND p.idgrupo = 10
AND a.idproducto BETWEEN 30000 AND 39999
AND a.fechaape::date > (CURRENT_DATE - INTERVAL '5 years')
AND ad.fecha::date > (CURRENT_DATE - INTERVAL '5 days') 
;
