/* SOCIOS QUE TENGAN MAS DE UN LAPSO DE TIEMPO SIN MOV, EXCLUYENDO AL 999 EN EL 110
Con las partes sociales completas 2000
--O-G-S, 
--Nombre completo, 
--OPA,
--FECHA UMA,
teléfono principal, 
teléfono celular, 
dirección completa
correo electrónico.

socios_que_no_tienen_movs_ahorros
socios_sin_movimientos
socios_sin_movimientos_2  */


SELECT DISTINCT
    p.idorigen || '-' || p.idgrupo || '-' || p.idsocio AS OGS,
    p.nombre || ' ' || p.appaterno || ' ' || p.apmaterno AS nombre,
    a.idorigenp || ' ' ||a.idproducto || ' ' ||a.idauxiliar AS producto,
    a.saldo as saldo, a.fechauma, p.telefono, p.celular, p.email, p.calle, coalesce(p.numeroext,'ND') as n_ext,coalesce(p.numeroint,'ND') as n_int, coalesce(p.entrecalles,'ND') 
FROM auxiliares  as a
INNER JOIN auxiliares a1
    ON a1.idorigen = a.idorigen
   AND a1.idgrupo  = a.idgrupo
   AND a1.idsocio  = a.idsocio
   AND a1.idproducto = 101
   AND a1.saldo >= 2000
INNER JOIN personas as p
    ON p.idorigen = a.idorigen
   AND p.idgrupo = a.idgrupo
   AND p.idsocio = a.idsocio
LEFT JOIN (
    SELECT DISTINCT ON (idorigenp,idproducto,idauxiliar)
           idorigenp,
           idproducto,
           idauxiliar,
           diasvencidos
    FROM carteravencida
    ORDER BY idorigenp,idproducto,idauxiliar,fechacalculo DESC
) cv
    ON a.idorigenp = cv.idorigenp
   AND a.idproducto = cv.idproducto
   AND a.idauxiliar = cv.idauxiliar

AND EXISTS (
    SELECT 1
    FROM (
        SELECT ad.idorigenp,
               ad.idproducto,
               ad.idauxiliar,
               COUNT(*) AS total_depositos
        FROM auxiliares_d ad
        WHERE ad.idproducto = 110
          AND ad.cargoabono = 1
          AND idtipo = 1
          AND tipomov = 0
          AND ad.fecha BETWEEN (
                (SELECT fechatrabajo::date FROM origenes LIMIT 1) - INTERVAL '1 year'
          )
          AND (SELECT fechatrabajo::date FROM origenes LIMIT 1)
        GROUP BY ad.idorigenp, ad.idproducto, ad.idauxiliar
    ) x
    WHERE x.idorigenp  = a.idorigenp
      AND x.idproducto = 110
      AND x.idauxiliar = a.idauxiliar
      --AND x.total_depositos >= 9
)
WHERE a.estatus = 2 AND a.idproducto = 110
        AND a.fechauma <= (
        (SELECT fechatrabajo::date FROM origenes LIMIT 1)
        - INTERVAL '10 years')
ORDER BY a.fechauma ;