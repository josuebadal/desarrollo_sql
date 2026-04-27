/*1.1.-Relacion de socios de nuevo ingreso activos e inactivos de enero a septiembre de 2025 con los siguientes datos: numero de socio, nombre completo, aportacion social, 
domicilio (calle, numero, colonia, municipio, estado), 
telefono, sexo, entidad, fecha de nacimiento, fecha de baja en su caso.*/

SELECT p.idorigen||'-'||p.idgrupo||'-'|| p.idsocio AS "Socio",
'|' AS "|",
nombre_x(p.appaterno,p.apmaterno,p.nombre) AS "Nombre",
'|' AS "|",
a.saldo AS "Partes Sociales",
'|' AS "|",
p.calle||','||p.numeroext||','||col.nombre||','||mun.nombre||','||
est.nombre AS "Domicilio",
'|' AS "|",
p.celular AS "Telefono",
'|' AS "|",
(CASE 
        WHEN p.sexo = 1 THEN 'Masculino'
        WHEN p.sexo = 2 THEN 'Femenino'
        Else 'NR' End) AS "Sexo",
'|' AS "|",
p.fechanacimiento AS "Fecha Nac",
'|' AS "|",
p.fechaingreso AS "Fecha Ingreso",
'|' AS "|",
p.fecharetiro  AS "Fecha Baja"
FROM personas p
    INNER JOIN auxiliares a 
    ON      p.idorigen      = a.idorigen
    AND     p.idgrupo       = a.idgrupo
    AND     p.idsocio       = a.idsocio
    INNER JOIN colonias col
    ON      p.idcolonia = col.idcolonia
    INNER JOIN municipios mun 
    ON      col.idmunicipio = mun.idmunicipio
    INNER JOIN estados est
    ON      mun.idestado = est.idestado
WHERE a.idproducto = 101
AND p.fechaingreso 
            between @@Fecha Ini:|f|01/01/2025@@ 
            AND @@Fecha Fin:|f|31/03/2025@@ 
;
