SELECT o.nombre,'|' AS "|", o.idorigen, '|' AS "|", 
COUNT(u.idusuario) AS "usuarios",'|' AS "|",
(SELECT ((COUNT(DISTINCT p.idsocio))/12)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN auxiliares_d ad
            ON a.idorigenp = ad.idorigenp
            AND a.idproducto = ad.idproducto
            AND a.idauxiliar = ad.idauxiliar
    WHERE  ad.fecha::date BETWEEN '31/08/2024' AND '31/08/2025'
        AND ad.monto  > 0 AND a.idorigenp = o.idorigen) AS "socios_mes",
        '|' AS "|",
(SELECT COUNT(a.idauxiliar) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen
            AND p.estatus = 't') AS "num_cuentas_captacion_adscritas",
    '|' AS "|",
    (SELECT COUNT(a.idauxiliar)
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "num__contratos_creditos_adscritos",
    '|' AS "|",
    (SELECT SUM(a.saldo) 
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen) AS "monto_captacion",
    '|' AS "|",
    (SELECT ((COUNT(p.idsocio))/12)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto = 110 AND a.saldo >1000
        AND p.fechaingreso::date BETWEEN '31/08/2024' AND '31/08/2025'
        AND a.idorigenp = o.idorigen) AS "socios_afiliados_mes",
    '|' AS "|",
    (SELECT (COUNT(a.idauxiliar)/12) 
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen
            ) AS "promedio_captacion_adscritas",
    '|' AS "|",
    (SELECT ((COUNT(a.idauxiliar))/12)
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "promedio_contratos_creditos_adscritos",
    '|' AS "|",
    (SELECT ((SUM(a.saldo))/12) 
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
        INNER JOIN origenes o 
        ON a.idorigenp = o.idorigen
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen) AS "promedio_monto_captacion",
    '|' AS "|",
    (SELECT ((SUM(a.saldo))/12)
    FROM auxiliares a
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "promedio_contratos_creditos"
    FROM origenes o
        INNER JOIN usuarios u
        ON o.idorigen = u.idorigen
    WHERE o.estatus = 't'
        AND u.activo = 't' 
    GROUP BY o.nombre,o.idorigen;


