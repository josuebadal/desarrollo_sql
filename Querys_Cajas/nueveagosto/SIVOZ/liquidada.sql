SELECT
        TRIM(TO_CHAR(ah.idorigenp,'09999'))||'-'||
        TRIM(TO_CHAR(ah.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(ah.idauxiliar,'09999999')) AS "OPA"
    FROM auxiliares_h ah
        INNER JOIN personas p
         ON p.idorigen = ah.idorigen
            AND p.idgrupo = ah.idgrupo
            AND p.idsocio = ah.idsocio
    WHERE  p.estatus = 't'
            AND ah.estatus = 3
            AND ah.idproducto BETWEEN 30000 AND 39999
            AND p.idgrupo = 10
            ORDER BY ah.fechaumi DESC 
    ;