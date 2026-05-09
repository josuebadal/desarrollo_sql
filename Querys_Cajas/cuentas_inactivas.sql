Contenga las cuentas inactivas de los socios.
Consideraciones:
no se debe considerar transacciones hechas por el usuario 999 --usuariorealiza !=999 || <>999 para fechas de ultimo movimiento.
se debe considerar cargo o abono (retiro o deposito) 
como fecha de ultimo movimiento.
se adjunto formato sugerido.
saludos


SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",COALESCE(p.rfc,'No Registrado')AS "RFC", COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre AS "PRODUCTO", a.fechauma AS "FECHAUMVT"
FROM auxiliares a 
JOIN personas p 
USING (idorigen, idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto 
WHERE p.estatus = 't' AND pr.idproducto IN(110,111,113,114,140)
;

------------------------------------------------------------------------
--VERSION 2 HACIENDO PRUEBAS PARA ULTIMO MOVIMIENTO 

SELECT TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",COALESCE(p.rfc,'No Registrado')AS "RFC", COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre AS "PRODUCTO",  
    (SELECT a1.fechauma 
    FROM auxiliares a1 
    JOIN auxiliares_d ad
    ON a.idorigenp = ad.idorigenp
    AND a.idproducto = ad.idproducto
    AND a.idauxiliar = ad.idauxiliar
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc
    AND ad.periodo   = pol.periodo
    AND ad.idtipo    = pol.idtipo
    AND ad.idpoliza  = pol.idpoliza
    where pol.idusuario <> 999
    ORDER BY pol.fecha DESC
    LIMIT 1
    )      AS "FECHAUMVT"
FROM auxiliares a 
JOIN personas p 
USING (idorigen, idgrupo,idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
WHERE p.estatus = 't' AND pr.idproducto IN(110,111,113,114,140)
ORDER BY p.idorigen, p.idgrupo, p.idsocio
LIMIT 10
;

--------------------------------------------------------
--VERSION 3 agregar el idtipo 1 y el tipomov 0 


WITH ultima_poliza AS (
    SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
    ad.idorigenp, ad.idproducto, ad.idauxiliar,pol.fecha, pol.idusuario
    FROM auxiliares_d ad
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc
    AND ad.periodo   = pol.periodo
    AND ad.idtipo    = pol.idtipo
    AND ad.idpoliza  = pol.idpoliza
    WHERE pol.idusuario <> 999
    ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
)
SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
COALESCE(p.rfc,'No Registrado')AS "RFC",
COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre AS "PRODUCTO",
up.fecha AS "FECHAUMVT"
FROM auxiliares a
JOIN personas p 
USING (idorigen, idgrupo, idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
JOIN ultima_poliza up
ON a.idorigenp = up.idorigenp
AND a.idproducto = up.idproducto
AND a.idauxiliar = up.idauxiliar
WHERE p.estatus = 't' 
AND pr.idproducto IN(110,111,113,114,140)
ORDER BY p.idorigen, p.idgrupo, p.idsocio
LIMIT 10;

--------------------------------------------------------
--VERSION 4 YA JALA PARA CREDITOS ACTIVOS

WITH ultima_poliza AS (
    SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
    ad.idorigenp, ad.idproducto, ad.idauxiliar,pol.fecha, pol.idusuario
    FROM auxiliares_d ad
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc
    AND ad.periodo   = pol.periodo
    AND ad.idtipo    = pol.idtipo
    AND ad.idpoliza  = pol.idpoliza
    WHERE pol.idusuario <> 999
    ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
)
SELECT DISTINCT ON (p.idorigen, p.idgrupo, p.idsocio)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
COALESCE(p.rfc,'No Registrado')AS "RFC",
COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre AS "PRODUCTO",
up.fecha AS "FECHAUMVT",
up.idusuario AS "APLICO"
FROM auxiliares a
JOIN personas p 
USING (idorigen, idgrupo, idsocio)
JOIN productos pr
ON a.idorigenp = pr.idorigen AND a.idproducto = pr.idproducto
JOIN ultima_poliza up
ON a.idorigenp = up.idorigenp
AND a.idproducto = up.idproducto
AND a.idauxiliar = up.idauxiliar
JOIN auxiliares_d ad2
ON a.idorigenp = ad2.idorigenp
AND a.idproducto = ad2.idproducto
AND a.idauxiliar = ad2.idauxiliar 
WHERE p.estatus = 't' 
AND pr.idproducto IN(110,111,113,114,140)
AND ad2.idtipo = 1 AND ad2.tipomov = 0
ORDER BY p.idorigen, p.idgrupo, p.idsocio
LIMIT 10;

--------------------------------------------------------
--VERSION 5 YA JALA PARA CREDITOS ACTIVOS
--APUNTAR A auxiliares_d y auxiliares_d_h

WITH ultima_poliza AS (
    SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
    ad.idorigenp, ad.idproducto, ad.idauxiliar,pol.fecha, pol.idusuario
    FROM auxiliares_d ad
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc
    AND ad.periodo   = pol.periodo
    AND ad.idtipo    = pol.idtipo
    AND ad.idpoliza  = pol.idpoliza
    WHERE pol.idusuario <> 999
    ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
)
SELECT DISTINCT ON (p.idorigen, p.idgrupo, p.idsocio)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
COALESCE(p.rfc,'No Registrado')AS "RFC",
COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(ad1.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(ad1.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(ad1.idauxiliar,'09999999')) AS "OPA",
pr.nombre AS "PRODUCTO",
up.fecha AS "FECHAUMVT",
up.idusuario AS "APLICO"
FROM auxiliares_d ad1
LEFT JOIN auxiliares a
ON ad1.idorigenp = a.idorigenp
AND ad1.idproducto = a.idproducto
AND ad1.idauxiliar = a.idauxiliar
LEFT JOIN auxiliares_d_h adh
ON adh.idorigenp = a.idorigenp
AND adh.idproducto = a.idproducto
AND adh.idauxiliar = a.idauxiliar
JOIN personas p 
ON a.idorigen = p.idorigen
AND a.idgrupo = p.idgrupo
AND a.idsocio = p.idsocio
JOIN productos pr
ON ad1.idorigenp  = pr.idorigen
AND ad1.idproducto  = pr.idproducto
JOIN ultima_poliza up
ON ad1.idorigenp = up.idorigenp
AND ad1.idproducto = up.idproducto
AND ad1.idauxiliar = up.idauxiliar 
WHERE p.estatus = 'FALSE' 
AND up.fecha IS NOT NULL
AND pr.idproducto IN(110,111,113,114,140)
ORDER BY p.idorigen, p.idgrupo, p.idsocio, up.fecha DESC
LIMIT 10;


--------------------------------------------------------
--VERSION 6 TRAER UNA POLIZA DE UN SOCIO DADO DE BAJA

WITH ultima_poliza AS (
    SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
    ad.idorigenp, ad.idproducto, ad.idauxiliar,pol.fecha, pol.idusuario
    FROM auxiliares_d ad
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc AND ad.periodo   = pol.periodo AND ad.idtipo    = pol.idtipo AND ad.idpoliza  = pol.idpoliza
    WHERE pol.idusuario <> 999 ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
)
SELECT DISTINCT ON (p.idorigen, p.idgrupo, p.idsocio)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
up.fecha AS "FEC-ULT-MOV"
FROM auxiliares a
--INNER JOIN auxiliares_h ah
--ON ah.idorigenp = a.idorigenp
--AND ah.idproducto = a.idproducto
--AND ah.idauxiliar = a.idauxiliar
--INNER JOIN auxiliares_d ad
--ON ad.idorigenp = a.idorigenp
--AND ad.idproducto = a.idproducto
--AND ad.idauxiliar = a.idauxiliar
--INNER JOIN productos pr
--ON a.idorigenp  = pr.idorigen
--AND a.idproducto  = pr.idproducto
INNER JOIN personas p 
ON a.idorigen = p.idorigen
AND a.idgrupo = p.idgrupo
AND a.idsocio = p.idsocio
INNER JOIN ultima_poliza up
ON a.idorigenp = up.idorigenp
AND a.idproducto = up.idproducto
AND a.idauxiliar = up.idauxiliar 
WHERE up.fecha IS NOT NULL
--AND pr.idproducto IN(110,111,113,114,140)
AND p.estatus = 'f'
ORDER BY p.idorigen, p.idgrupo, p.idsocio DESC
LIMIT 10;

--------------------------------------------------------------------------
--VERSION 7 AGREGANDO LOS INNER
--auxiliares a si trae info

WITH ultima_poliza AS (
    SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
    ad.idorigenp, ad.idproducto, ad.idauxiliar,pol.fecha, pol.idusuario, pol.idtipo, ad.tipomov
    FROM auxiliares_d ad
    JOIN polizas pol
    ON ad.idorigenc = pol.idorigenc AND ad.periodo = pol.periodo AND ad.idtipo    = pol.idtipo AND ad.idpoliza  = pol.idpoliza
    WHERE pol.idusuario <> 999 ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
)
SELECT DISTINCT ON (p.idorigen, p.idgrupo, p.idsocio)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
COALESCE(p.rfc,'No Registrado')AS "RFC",
COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
pr.nombre,
up.fecha AS "FEC-ULT-MOV",
up.idusuario AS "APLICO", up.tipomov, up.idtipo
FROM auxiliares a
LEFT JOIN auxiliares_h ah
ON ah.idorigenp = a.idorigenp
AND ah.idproducto = a.idproducto
AND ah.idauxiliar = a.idauxiliar
LEFT JOIN auxiliares_d ad
ON ad.idorigenp = a.idorigenp
AND ad.idproducto = a.idproducto
AND ad.idauxiliar = a.idauxiliar
INNER JOIN productos pr
ON a.idorigenp  = pr.idorigen
AND a.idproducto  = pr.idproducto
INNER JOIN personas p 
ON a.idorigen = p.idorigen
AND a.idgrupo = p.idgrupo
AND a.idsocio = p.idsocio
INNER JOIN ultima_poliza up
ON a.idorigenp = up.idorigenp
AND a.idproducto = up.idproducto
AND a.idauxiliar = up.idauxiliar 
WHERE up.fecha IS NOT NULL
AND pr.idproducto IN(110,111,113,114,140)
AND p.estatus = 'f'
AND up.idtipo = 1 
AND up.tipomov = 0
ORDER BY p.idorigen, p.idgrupo, p.idsocio DESC
;


--------------------------------------------------------------------------
--ADD

SELECT DISTINCT ON (ad.idorigenp, ad.idproducto, ad.idauxiliar)
TRIM(TO_CHAR(p.idorigen, '099999'))||'-'|| TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'|| TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.appaterno, p.apmaterno, p.nombre) AS "NOMBRE",
COALESCE(p.rfc,'No Registrado')AS "RFC",
COALESCE(p.curp,'No Registrado') AS "CURP",
TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(ad.idauxiliar,'09999999')) AS "OPA",
pol.fecha, pol.idusuario, pol.idtipo, ad.tipomov
FROM auxiliares_d_h ad
JOIN polizas pol
ON ad.idorigenc = pol.idorigenc 
AND ad.periodo = pol.periodo 
AND ad.idtipo = pol.idtipo 
AND ad.idpoliza  = pol.idpoliza
LEFT JOIN auxiliares_h ah
ON ah.idorigenp = ad.idorigenp
AND ah.idproducto = ad.idproducto
AND ah.idauxiliar = ad.idauxiliar
INNER JOIN personas p 
ON ah.idorigen = p.idorigen
AND ah.idgrupo = p.idgrupo
AND ah.idsocio = p.idsocio
WHERE pol.idusuario <> 999
AND p.estatus = 'f'
AND pol.idtipo = 1 
AND ad.tipomov = 0
ORDER BY ad.idorigenp, ad.idproducto, ad.idauxiliar, pol.fecha DESC
;

NOTA: Correr query en otra base que no sea la de final de mes 
ya que el super usuario corre las ultimas polizas

SELECT COUNT(*) FROM auxiliares_d;

--causa de baja diferente de cero o null
--apuntar a auxiliares_h y d_h
--debo traer la fecha del ultimo movimiento de auxiliares que no haya sido aplicado por el super usuario <>999

select * from auxiliares 
where idproducto =110; 

a.elaboro = 860
a.fechauma 10/03/2025 --indica el ultimo movimiento realizado por un usuario diferente al 999


select * from auxiliares_d 
where (idorigenp,idproducto,idauxiliar) = (30206,36664,184);


select * from polizas
where (idorigenc,idpoliza) = (30206,167)
AND idusuario !=999
ORDER BY fecha DESC;


JOIN auxiliares_d ad
ON a.idorigenp = ad.idorigenp
AND a.idproducto = ad.idproducto
AND a.idauxiliar = ad.idauxiliar
JOIN polizas pol
ON ad.idorigenc = pol.idorigenc
AND ad.periodo   = pol.periodo
AND ad.idtipo    = pol.idtipo
AND ad.idpoliza  = pol.idpoliza


INNER JOIN auxiliares_d_h adh
ON adh.idorigenp = a.idorigenp
AND adh.idproducto = a.idproducto
AND adh.idauxiliar = a.idauxiliar
parte social en 0

