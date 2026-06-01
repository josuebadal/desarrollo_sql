SELECT * FROM (SELECT DISTINCT TRIM(TO_CHAR(a.idorigen,'099999')) ||'-'|| a.idgrupo ||'-'|| TRIM(TO_CHAR(a.idsocio,'09999999')) AS socio, 
       SUBSTR(TRIM(nombre_x(p.appaterno, p.apmaterno, p.nombre)),1,50) AS nombre_socio,
       EXTRACT(years FROM (AGE(CURRENT_TIMESTAMP, p.fechanacimiento))) AS edad, p.fechanacimiento, 
       (CASE WHEN p.sexo = 1 THEN 'M' ELSE CASE WHEN p.sexo = 2 THEN 'F' END END) AS sexo, p.fechaingreso,
       (SELECT SUM(saldo) FROM auxiliares 
        WHERE idorigen = a.idorigen AND idgrupo = a.idgrupo AND idsocio = a.idsocio 
        AND idproducto IN (110,111,115,200,201,202,101,103)) AS total_ahorro,
       (SELECT SUM(saldo) FROM carteravencida cv 
        INNER JOIN productos pr USING (idproducto) 
        WHERE pr.tipoproducto = 2 AND cv.idorigen = a.idorigen AND cv.idgrupo = a.idgrupo AND cv.idsocio = a.idsocio) AS total_prestamo
FROM auxiliares a
INNER JOIN personas p USING (idorigen, idgrupo, idsocio)
WHERE a.estatus = 2
  AND a.saldo > 0
  AND a.idgrupo IN (10, 11, 12, 13)
ORDER BY socio) ope WHERE edad < 91
UNION ALL
SELECT * FROM (SELECT DISTINCT TRIM(TO_CHAR(a.idorigen,'099999')) ||'-'|| a.idgrupo ||'-'|| TRIM(TO_CHAR(a.idsocio,'09999999')) AS socio, 
       SUBSTR(TRIM(nombre_x(p.appaterno, p.apmaterno, p.nombre)),1,50) AS nombre_socio,
       EXTRACT(years FROM (AGE(CURRENT_TIMESTAMP, p.fechanacimiento))) AS edad, p.fechanacimiento, 
       (CASE WHEN p.sexo = 1 THEN 'M' ELSE CASE WHEN p.sexo = 2 THEN 'F' END END) AS sexo, p.fechaingreso,
       (SELECT SUM(saldo) FROM auxiliares 
        WHERE idorigen = a.idorigen AND idgrupo = a.idgrupo AND idsocio = a.idsocio 
        AND idproducto IN (110,111,115,200,201,202,101,103)) AS total_ahorro,
       (SELECT SUM(saldo) FROM carteravencida cv 
        INNER JOIN productos pr USING (idproducto)
        WHERE pr.tipoproducto = 2 AND cv.idorigen = a.idorigen AND cv.idgrupo = a.idgrupo AND cv.idsocio = a.idsocio) AS total_prestamo
FROM auxiliares a
INNER JOIN personas p USING (idorigen, idgrupo, idsocio)
LEFT JOIN (SELECT ax.idorigen,ax.idgrupo,ax.idsocio 
  FROM auxiliares ax 
  INNER JOIN productos pr USING (idproducto)
  WHERE pr.tipoproducto = 2) ax USING (idorigen,idgrupo,idsocio)
WHERE a.estatus = 2
  AND a.saldo > 0
  AND a.idgrupo IN (10, 11, 12, 13)
  AND ax.idsocio IS NULL
ORDER BY socio) ope WHERE edad >= 71;
