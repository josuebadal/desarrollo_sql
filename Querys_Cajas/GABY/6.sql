SELECT TRIM(TO_CHAR(r.idorigenr,'099999'))||'-'||TRIM(TO_CHAR(r.idgrupor,'09'))||'-'||TRIM(TO_CHAR(r.idsocior,'099999')) AS "No. socio de aval o codeudor",
       '|' AS "|", TRIM(p.nombre||' '||p.appaterno||' '||p.apmaterno) AS "Nombre de aval o codeudor",
       '|' AS "|", TRIM(p.calle) as "Calle del aval o codeudor",
       '|' AS "|", TRIM(p.numeroext) as "Numero Ext del aval o codeudor",
       '|' AS "|", TRIM(p.numeroint) as "Num Int del aval o codeudor",
       '|' AS "|", col.nombre as "Colonia del aval o codeudor",
  '|' AS "|", mun.nombre as "Municipio del aval o codeudor",
  '|' AS "|", est.nombre as "Estado del aval o codeudor",
  '|' AS "|", col.codigopostal as "Codigo Postal del aval o codeudor",
  '|' AS "|",  'Aval' || ' ' || trim(substr(r.referencia,1,1)) AS "Tipo de referencia",    
       '|' AS "|",  TRIM(split_part(r.referencia,'|',2)) ||'-'|| TRIM(split_part(r.referencia,'|',3)) ||'-'|| TRIM(split_part(r.referencia,'|',4)) as "Folio de credito avalado",
       '|' AS "|", (SELECT pr.nombre from productos pr WHERE pr.idproducto = a.idproducto) AS "tipo de credito avalado",
       '|' AS "|", a.saldo AS "monto del credito avalado",
       '|' AS "|", TRIM(TO_CHAR(r.idorigen,'099999'))||'-'||trim(to_char(r.idgrupo,'09'))||'-'||trim(TO_CHAR(r.idsocio,'099999')) AS "No. socio avalado",
       '|' AS "|", (SELECT pa.nombre||' '||pa.appaterno||' '||pa.apmaterno
                      FROM personas pa
                     WHERE pa.idorigen = r.idorigen
                       AND pa.idgrupo = r.idgrupo
                       AND pa.idsocio = r.idsocio) AS "Nombre de socio avalado",                    
            '|' AS "|", (CASE WHEN a.estatus = 0 THEN 'Capturado'
                            WHEN a.estatus = 1 THEN 'Autorizado'
                            WHEN a.estatus = 2 THEN 'Activo'
                            WHEN a.estatus = 3 THEN 'Pagado'
                            WHEN a.estatus = 4 THEN 'Cancelado' END) AS "estatus del credito",
            '|' AS "|", (SELECT count(*)
                         FROM auxiliares au
                         WHERE au.idorigen = r.idorigenr
                          AND au.idgrupo = r.idgrupor
                          AND au.idsocio = r.idsocior
                          AND au.estatus = 2
                          AND au.idproducto BETWEEN 30000 AND 39999) AS "Numero de creditos",
       '|' AS "|", (SELECT sum(saldo) FROM auxiliares au
            WHERE au.idorigen = r.idorigenr
              AND au.idgrupo = r.idgrupor
              AND au.idsocio = r.idsocior
              AND au.idproducto BETWEEN 30000 AND 39999) as "Monto de creditos"
  FROM referencias r
INNER JOIN personas p ON (p.idorigen = r.idorigenr AND p.idgrupo = r.idgrupor AND p.idsocio = r.idsocior)
INNER JOIN colonias as col on p.idcolonia=col.idcolonia
INNER JOIN municipios as mun on col.idmunicipio =mun.idmunicipio
INNER JOIN estados as est on mun.idestado=est.idestado
INNER JOIN v_auxiliares a ON (split_part(r.referencia,'|',2) = TRIM(TO_CHAR(a.idorigenp,'099999'))
                              AND split_part(r.referencia,'|',3) = TRIM(TO_CHAR(a.idproducto,'09999'))
                              AND split_part(r.referencia,'|',4) = TRIM(TO_CHAR(a.idauxiliar,'09999999')))
WHERE r.tiporeferencia in (8, 35)
   AND p.estatus = TRUE
   union all
SELECT TRIM(TO_CHAR(split_part(n.descripcion,'|',1)::int4,'099999'))||'-'||TRIM(TO_CHAR(split_part(n.descripcion,'|',2)::int4,'09'))||'-'||TRIM(TO_CHAR(split_part(n.descripcion,'|',3)::int4,'099999')) AS "No. socio de aval o codeudor",
       '|' AS "|", TRIM(p.nombre||' '||p.appaterno||' '||p.apmaterno) AS "Nombre de aval o codeudor",
       '|' AS "|", TRIM(p.calle) as "Calle del aval o codeudor",
       '|' AS "|", TRIM(p.numeroext) as "Numero Ext del aval o codeudor",
       '|' AS "|", TRIM(p.numeroint) as "Num Int del aval o codeudor",
       '|' AS "|", col.nombre as "Colonia del aval o codeudor",
  '|' AS "|", mun.nombre as "Municipio del aval o codeudor",
  '|' AS "|", est.nombre as "Estado del aval o codeudor",
  '|' AS "|", col.codigopostal as "Codigo Postal del aval o codeudor",
  '|' AS "|",  'Codeudor' AS "Tipo de referencia",    
       '|' AS "|",  TRIM(split_part(r.referencia,'|',2)) ||'-'|| TRIM(split_part(r.referencia,'|',3)) ||'-'|| TRIM(split_part(r.referencia,'|',4)) as "Folio de credito avalado",
       '|' AS "|", (SELECT pr.nombre from productos pr WHERE pr.idproducto = a.idproducto) AS "tipo de credito avalado",
       '|' AS "|", a.saldo AS "monto del credito avalado",
       '|' AS "|", TRIM(TO_CHAR(r.idorigen,'099999'))||'-'||trim(to_char(r.idgrupo,'09'))||'-'||trim(TO_CHAR(r.idsocio,'099999')) AS "No. socio avalado",
       '|' AS "|", (SELECT pa.nombre||' '||pa.appaterno||' '||pa.apmaterno
                      FROM personas pa
                     WHERE pa.idorigen = r.idorigen
                       AND pa.idgrupo = r.idgrupo
                       AND pa.idsocio = r.idsocio) AS "Nombre de socio avalado",                    
            '|' AS "|", (CASE WHEN a.estatus = 0 THEN 'Capturado'
                            WHEN a.estatus = 1 THEN 'Autorizado'
                            WHEN a.estatus = 2 THEN 'Activo'
                            WHEN a.estatus = 3 THEN 'Pagado'
                            WHEN a.estatus = 4 THEN 'Cancelado' END) AS "estatus del credito",
            '|' AS "|", (SELECT count(*)
                         FROM auxiliares au
                         WHERE au.idorigen = split_part(n.descripcion,'|',1)::int4
                          AND au.idgrupo = split_part(n.descripcion,'|',2)::int4
                          AND au.idsocio = split_part(n.descripcion,'|',3)::int4
                          AND au.estatus = 2
                          AND au.idproducto BETWEEN 30000 AND 39999) AS "Numero de creditos",
       '|' AS "|", (SELECT sum(saldo) FROM auxiliares au
            WHERE au.idorigen = split_part(n.descripcion,'|',1)::int4
              AND au.idgrupo = split_part(n.descripcion,'|',2)::int4
              AND au.idsocio = split_part(n.descripcion,'|',3)::int4
              AND au.idproducto BETWEEN 30000 AND 39999) as "Monto de creditos"
  FROM referencias as r
INNER JOIN notas n ON TRIM(split_part(n.idnota,'|',2)) = TRIM(split_part(r.referencia,'|',2)) and
 TRIM(split_part(n.idnota,'|',3)) = TRIM(split_part(r.referencia,'|',3)) and
 TRIM(split_part(n.idnota,'|',4)) = TRIM(split_part(r.referencia,'|',4))
INNER JOIN personas p ON (p.idorigen = split_part(n.descripcion,'|',1)::int4  AND p.idgrupo = split_part(n.descripcion,'|',2)::int4 AND p.idsocio = split_part(n.descripcion,'|',3)::int4)
INNER JOIN colonias as col on p.idcolonia=col.idcolonia
INNER JOIN municipios as mun on col.idmunicipio =mun.idmunicipio
INNER JOIN estados as est on mun.idestado=est.idestado
INNER JOIN v_auxiliares a ON (split_part(n.idnota,'|',2) = TRIM(TO_CHAR(a.idorigenp,'099999'))
                              AND split_part(n.idnota,'|',3) = TRIM(TO_CHAR(a.idproducto,'09999'))
                              AND split_part(n.idnota,'|',4) = TRIM(TO_CHAR(a.idauxiliar,'09999999')))
where
trim(substr(n.idnota,1,1)) = 'C' and (n.descripcion != '' or n.descripcion is not null) and
   p.estatus = TRUE
   union all
  SELECT '' AS "No. socio de aval o codeudor",
       '|' AS "|", UPPER(n.nota) AS "Nombre de aval o codeudor",
       '|' AS "|", '' as "Calle del aval o codeudor",
       '|' AS "|", '' as "Numero Ext del aval o codeudor",
       '|' AS "|", '' as "Num Int del aval o codeudor",
       '|' AS "|", '' as "Colonia del aval o codeudor",
  '|' AS "|", '' as "Municipio del aval o codeudor",
  '|' AS "|", '' as "Estado del aval o codeudor",
  '|' AS "|", '' as "Codigo Postal del aval o codeudor",
  '|' AS "|",  'Codeudor' AS "Tipo de referencia",    
       '|' AS "|",  TRIM(split_part(r.referencia,'|',2)) ||'-'|| TRIM(split_part(r.referencia,'|',3)) ||'-'|| TRIM(split_part(r.referencia,'|',4)) as "Folio de credito avalado",
       '|' AS "|", (SELECT pr.nombre from productos pr WHERE pr.idproducto = a.idproducto) AS "tipo de credito avalado",
       '|' AS "|", a.saldo AS "monto del credito avalado",
       '|' AS "|", TRIM(TO_CHAR(r.idorigen,'099999'))||'-'||trim(to_char(r.idgrupo,'09'))||'-'||trim(TO_CHAR(r.idsocio,'099999')) AS "No. socio avalado",
       '|' AS "|", TRIM(p.nombre||' '||p.appaterno||' '||p.apmaterno) AS "Nombre de socio avalado",                    
            '|' AS "|", (CASE WHEN a.estatus = 0 THEN 'Capturado'
                            WHEN a.estatus = 1 THEN 'Autorizado'
                            WHEN a.estatus = 2 THEN 'Activo'
                            WHEN a.estatus = 3 THEN 'Pagado'
                            WHEN a.estatus = 4 THEN 'Cancelado' END) AS "estatus del credito",
       '|' AS "|", 0 AS "Numero de creditos",
       '|' AS "|", 0 as "Monto de creditos"
  FROM referencias as r
INNER JOIN notas n ON TRIM(split_part(n.idnota,'|',2)) = TRIM(split_part(r.referencia,'|',2)) and
 TRIM(split_part(n.idnota,'|',3)) = TRIM(split_part(r.referencia,'|',3)) and
 TRIM(split_part(n.idnota,'|',4)) = TRIM(split_part(r.referencia,'|',4))
INNER JOIN personas p ON (p.idorigen = r.idorigen AND p.idgrupo = r.idgrupo AND p.idsocio = r.idsocio)
INNER JOIN v_auxiliares a ON (split_part(n.idnota,'|',2) = TRIM(TO_CHAR(a.idorigenp,'099999'))
                              AND split_part(n.idnota,'|',3) = TRIM(TO_CHAR(a.idproducto,'09999'))
                              AND split_part(n.idnota,'|',4) = TRIM(TO_CHAR(a.idauxiliar,'09999999')))
where
trim(substr(n.idnota,1,1)) = 'C' and (n.descripcion = '' or n.descripcion is null) and length(n.nota) > 6 ORDER BY "No. socio de aval o codeudor";