SELECT DISTINCT
    p.idorigen || '-' || p.idgrupo || '-' || p.idsocio AS OGS,
    p.fechaingreso,
    p.nombre || ' ' || p.appaterno || ' ' || p.apmaterno AS nombre,
    a.idorigenp || ' ' ||a.idproducto || ' ' ||a.idauxiliar AS producto,
    a.saldo as saldo,
    cv.diasvencidos as diasven
FROM auxiliares  as a
INNER JOIN auxiliares a1
    ON a1.idorigen = a.idorigen
   AND a1.idgrupo  = a.idgrupo
   AND a1.idsocio  = a.idsocio
   AND a1.idproducto = 101
   AND a1.saldo >= 1000
INNER JOIN personas as p
    ON p.idorigen = a.idorigen
   AND p.idgrupo = a.idgrupo
   AND p.idsocio = a.idsocio
INNER JOIN socioeconomicos as se
    ON p.idorigen = se.idorigen
   AND p.idgrupo = se.idgrupo
   AND p.idsocio = se.idsocio
   AND se.estatusvivienda = 1
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
      AND x.total_depositos >= 9
)
WHERE p.fechaingreso <= (
        (SELECT fechatrabajo::date FROM origenes LIMIT 1)
        - INTERVAL '3 years'
    )
    AND a.idproducto IN (30102,30112,30202,30212,32602,32612,32702,32712)
    AND a.estatus = 2
    AND a.fechaape <= (
        (SELECT fechatrabajo::date FROM origenes LIMIT 1)
        - INTERVAL '6 month'
    )
    AND COALESCE(cv.diasvencidos,0) = 0
;