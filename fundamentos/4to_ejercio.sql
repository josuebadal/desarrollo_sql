CAJA SAN ISIDRO

Sobre este tema, se contara con alguna consulta en donde
como resultado muestre no de socio y las personas que tiene 
registradas como familiar directo (padre, hijos, conyugue, 
concubina) saldo de su aportacion social (producto 101), 
saldo ahorro (producto 110), 
saldo total si cuenta con prestamos 
(sumatoria de todos sus creditos activos).

PRELACIONADAS, SALDO101socio, 
SALDO110SOCIO,SUMSALDOPRESTIPO2


SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x (p.nombre, p.appaterno, p.apmaterno) AS "nombresocio",
r.idorigenr, r.idgrupor, r.idsocior

FROM auxiliares a
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN referencias r
USING (idorigen,idgrupo,idsocio)
WHERE p.estatus = 't'
AND r.tiporeferencia in (25,24, 7,1,39)
;

================================================================
--INTENTO 2 ¿No siempre se releaciona todo con aux esta vez pude ser solo personas y referencias?

SELECT
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "nombresocio",
to_char(r.idorigen,'FM099999')||'-'||
to_char(r.idgrupo,'FM09')||'-'||
to_char(r.idsocio,'FM099999')||'     
'||p.nombre||' '||p.appaterno||' '||p.apmaterno AS rels,
cat.descripcion
FROM personas p 
INNER JOIN referencias r
ON r.idorigen = p.idorigen AND r.idgrupo = p.idgrupo AND r.idsocio = p.idsocio
RIGHT JOIN catalogo_menus cat
ON menu = 'referenciap'
WHERE p.estatus = 't'
AND cat.menu = 'referenciap' AND cat.opcion = r.tiporeferencia
AND r.tiporeferencia in (25,24, 7,1)
ORDER BY p.idorigen, p.idgrupo, p.idsocio
;

================================================================
--INTENTO 3 se saca la informacion directamente de referencias pero haremos una UNION
--O se va a desbordar la informacion


SELECT 
to_char(r.idorigenr,'FM099999')||'-'||
to_char(r.idgrupor,'FM09')||'-'||
to_char(r.idsocior,'FM099999')||'     
'||p.nombre||' '||p.appaterno||' '||p.apmaterno as "socio referencia",
r.tiporeferencia,
to_char(r.idorigen,'FM099999')||'-'||
to_char(r.idgrupo,'FM09')||'-'||
to_char(r.idsocio,'FM099999')||'     
'||p.nombre||' '||p.appaterno||' '||p.apmaterno as "relacionado a",
(select descripcion from catalogo_menus where menu = 'referenciap' 
and opcion = r.tiporeferencia) as nom_ref
FROM referencias r 
inner join personas p 
on (p.idorigen = r.idorigen 
and p.idgrupo = r.idgrupo 
and p.idsocio = r.idsocio) 
WHERE p.estatus = 't'
AND r.tiporeferencia in (25,24, 7,1)
ORDER BY p.idorigen, p.idgrupo, p.idsocio
;

================================================================
/*INTENTO 4
1.- TRAER TODOS LOS SOCIOS QUE ESTEN EN REFERENCIAS Y SU NOMBRE*/

SELECT
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'||
TRIM(TO_CHAR(r.idgrupor, '09')) ||'-'||
TRIM(TO_CHAR(r.idsocior, '099999'))||'-'||
nombre_x (p.nombre, p.appaterno, p.apmaterno) AS "socio",
TRIM(TO_CHAR(r.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(r.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(r.idsocio, '099999')) AS "referencia",
(select descripcion from catalogo_menus where menu = 'referenciap' 
and opcion = r.tiporeferencia) AS "relacion",
(select a.saldo from auxiliares a where a.idproducto = 101 limit 1) AS "101",
(select a2.saldo from auxiliares a2 where a2.idproducto = 110 and a2.idorigen = r.idorigenr AND a2.idgrupo = r.idgrupor AND a2.idsocio = r.idsocior limit 1) AS "110",
(select SUM(a3.saldo) from auxiliares a3 INNER JOIN productos pr ON a3.idorigenp = pr.idorigen where pr.tipoproducto = 2 and a3.estatus = 2 and a3.idorigen = r.idorigenr and a3.idgrupo = r.idgrupor and a3.idsocio = r.idsocior) as "sum_creditos" ,
(select t.puesto from trabajo t where t.idorigen = p.idorigen AND t.idgrupo = p.idgrupo AND t.idsocio = p.idsocio LIMIT 1) AS "trb-socio",
(select t2.puesto from trabajo t2 where t2.idorigen = r.idorigenr AND t2.idgrupo = r.idgrupor AND t2.idsocio = r.idsocior LIMIT 1 ) AS "trb-referencia"
FROM referencias r 
INNER JOIN personas p ON  r.idorigen = p.idorigen AND r.idgrupo = p.idgrupo AND r.idsocio = p.idsocio
WHERE r.tiporeferencia in (25,24, 7,1,39) AND p.estatus = 't'
ORDER BY r.idorigenr, r.idgrupor, r.idsocior
;


================================================================
/*INTENTO 5 ADD OCUPACION y nombre de socios,referencias
1.- TRAER TODOS LOS SOCIOS QUE ESTEN EN REFERENCIAS Y SU NOMBRE
2.- Se puede aplicar un COALESCE(saldo,0) a la ocupacion en caso de nober capturado alguna
*/

SELECT TRIM(TO_CHAR(r.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(r.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(r.idsocio, '099999')) ||'-'||
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen = r.idorigen and idgrupo = r.idgrupo and idsocio = r.idsocio) as nombre_referencia,
(select COALESCE(t2.puesto,'No Registrado') from trabajo t2 where t2.idorigen = r.idorigen AND t2.idgrupo = r.idgrupo AND t2.idsocio = r.idsocio LIMIT 1 ) AS "trb-referencia",
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'|| TRIM(TO_CHAR(r.idgrupor, '09')) ||'-'|| TRIM(TO_CHAR(r.idsocior, '099999')) AS "referencia",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) as nombre_socio,
(select descripcion from catalogo_menus where menu = 'referenciap' and opcion = r.tiporeferencia) AS "relacion",
(select a.saldo from auxiliares a where a.idproducto = 101 limit 1) AS "101",
(select a2.saldo from auxiliares a2 where a2.idproducto = 110 and a2.idorigen = r.idorigenr AND a2.idgrupo = r.idgrupor AND a2.idsocio = r.idsocior limit 1) AS "110",
(select SUM(a3.saldo) from auxiliares a3 INNER JOIN productos pr ON a3.idorigenp = pr.idorigen where pr.tipoproducto = 2 and a3.estatus = 2 and a3.idorigen = r.idorigenr and a3.idgrupo = r.idgrupor and a3.idsocio = r.idsocior) as "sum_creditos" ,
(select COALESCE (t.puesto, 'No Registrado') from trabajo t where t.idorigen = r.idorigenr AND t.idgrupo = r.idgrupor AND t.idsocio = r.idsocior LIMIT 1) AS "trb-socio"
FROM referencias r 
INNER JOIN personas p ON  r.idorigen = p.idorigen AND r.idgrupo = p.idgrupo AND r.idsocio = p.idsocio
WHERE r.tiporeferencia in (25,24, 7,1,39) AND p.estatus = 't'
ORDER BY r.idorigenr, r.idgrupor, r.idsocior;


SELECT TRIM(TO_CHAR(r.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(r.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(r.idsocio, '099999')) ||'-'||
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen = r.idorigen and idgrupo = r.idgrupo and idsocio = r.idsocio) as nombre_referencia,
(select COALESCE(t2.puesto,'No Registrado') from trabajo t2 where t2.idorigen = r.idorigen AND t2.idgrupo = r.idgrupo AND t2.idsocio = r.idsocio LIMIT 1 ) AS "trb-referencia",
TRIM(TO_CHAR(r.idorigenr, '099999'))||'-'|| TRIM(TO_CHAR(r.idgrupor, '09')) ||'-'|| TRIM(TO_CHAR(r.idsocior, '099999')) AS "referencia",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) as nombre_socio,
(select descripcion from catalogo_menus where menu = 'referenciap' and opcion = r.tiporeferencia) AS "relacion",
(select COALESCE (t.puesto, 'No Registrado') from trabajo t where t.idorigen = r.idorigenr AND t.idgrupo = r.idgrupor AND t.idsocio = r.idsocior LIMIT 1) AS "trb-socio"
FROM referencias r 
INNER JOIN personas p ON  r.idorigen = p.idorigen AND r.idgrupo = p.idgrupo AND r.idsocio = p.idsocio
WHERE r.tiporeferencia in (25,24, 7,1,39) AND p.estatus = 't'
ORDER BY r.idorigenr, r.idgrupor, r.idsocior;

-------------------------------------------------------------------

SELECT distinct on (per.idorigen,per.idgrupo,per.idsocio,ref.idorigenr,ref.idgrupor,ref.idsocior)
per.idorigen,per.idgrupo,per.idsocio, 
nombre_x(per.nombre,per.appaterno,per.apmaterno), 
(case when ref.tiporeferencia = 1 then 'Conyuge' 
      when ref.tiporeferencia = 24 then 'Madre'
      when ref.tiporeferencia = 25 then 'Padre'
      when ref.tiporeferencia = 7 then 'Hijo(a)'
      when ref.tiporeferencia = 39 then 'Concubina'
end) as referencia,	
ref.idorigenr,ref.idgrupor,ref.idsocior,
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=ref.idorigenr and idgrupo =ref.idgrupor and idsocio = ref.idsocior) as nombre_referencia,
(select COALESCE(saldo,0) from auxiliares  where idproducto=101 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1)as saldo_101,
(select COALESCE(saldo,0) from auxiliares where idproducto=110 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1) as saldo_110,
(select coalesce(SUM(saldo),0) from auxiliares where idproducto in (select idproducto from productos where tipoproducto =2) and estatus =2 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio)as saldo_prestamos
FROM personas as per 
INNER JOIN referencias as ref using (idorigen,idgrupo,idsocio)
WHERE ref.tiporeferencia in (24,25,7,39,1);




*****************NOTAS*************************
obre este tema, se contara con alguna consulta en donde como resultado muestre 
no de socio
las personas que tiene registradas como familiar directo 
(padre, hijos, conyugue, concubina) --r.tiporeferencia
saldo de su aportacion social (producto 101), 
saldo ahorro (producto 110), 
saldo total si cuenta con prestamos (sumatoria de todos sus creditos activos).



--hacer una sub consulta a catalogo_menus para ver cual selecciono 
(select menu,opcion,descripcion 
from catalogo_menus 
WHERE menu = 'referenciap' AND opcion in (25,24, 7,1,39))

(select descripcion from catalogo_menus cat JOIN referencia r1 ON r1.tiporeferencia = cat.opcion WHERE menu = 'referenciap' AND opcion in (25,24, 7,1)),


=======================================================


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