SELECT 
        TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
        TRIM(TO_CHAR(p.idgrupo, '09'))||'-'||
        TRIM(TO_CHAR(p.idsocio, '099999'))AS "OGS",
        TRIM(TO_CHAR(a.idorigenp,  '099999'))||'-'||
        TRIM(TO_CHAR(a.idproducto, '09999'))||'-'||
        TRIM(TO_CHAR(a.idauxiliar, '09999999'))AS "OPA",
        (SELECT nombre 
            from productos pr
            WHERE  a.idproducto = pr.idproducto
        ) AS "nombre",
        '' AS "estatus",
        (a.saldo - a.garantia) AS "saldo_disponible",
        a.garantia AS "saldo_retenido",
        (select a1.saldo 
            from auxiliares a1
            Where a1.idproducto = 101 
            LIMIT 1
        ) AS "saldo_sbc",
        a.saldo AS "saldo_total",
        '' AS "interes_dia"
    FROM auxiliares a
        INNER JOIN personas p 
        ON  a.idorigen = p.idorigen
        AND a.idgrupo  = p.idgrupo
        AND a.idsocio  = p.idsocio
    WHERE p.estatus = 't'
            AND a.estatus = 2
            AND a.idproducto IN (110,130,11208,11222)
    ORDER BY p.idorigen,p.idgrupo,p.idsocio DESC
    ;