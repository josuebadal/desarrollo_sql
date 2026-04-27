SELECT DISTINCT ON(
    p.idorigen,p.idgrupo,p.idsocio,
    a.idorigenp,a.idproducto,a.idauxiliar)  
    ----ELIMINAR OGS SOLO SE PUSO COMO REFERENCIA
    p.idorigen,p.idgrupo,p.idsocio,
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
    o.fechatrabajo AS "fecha",
    cv.montovencido AS "saldo",
    cv.abonosvencidos AS "omisos",
    cv.diasvencidos AS "dias_mora",
    (CASE 
        WHEN a.cartera = 'V' THEN a.saldo
        END) AS "capital_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.saldo
        END) AS "capital_vigente",
    a.ieco  AS "int_ctas_orden", 
    a.iecom AS "int_moratorio",
    '' AS "int_transitorio",
    (CASE 
        WHEN a.cartera = 'V' THEN a.idncm
        END) AS "int_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.idnc
        END) AS "int_vigente",
    ROUND((a.ieco * (16.00/100)),2) AS "iva_ctas_orden", 
    ROUND((a.iecom * (16.00/100)),2) AS "iva_moratorio",
    '' AS "iva_transitorio",
    (CASE 
        WHEN a.cartera = 'V' THEN ROUND(a.idncm * (16.00/100),2)
        END) AS "iva_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN ROUND(a.idnc* (16.00/100),2)
        END)  AS "iva_vigente",
    '0.00' AS "gastos_cobranza",
    (SELECT ROUND(am.abono +(a.idnc + (a.idnc * (16.00/100)) ),2) 
        from amortizaciones am
        WHERE am.atiempo = 'f'
            AND am.todopag = 'f'
            AND a.idorigenp = am.idorigenp
            AND a.idproducto= am.idproducto
            AND a.idauxiliar= am.idauxiliar
        ORDER BY am.vence DESC limit 1) AS "monto_amortizacion",
    a.montoprestado AS "monto_otorgado",
    (CASE WHEN a.pagodiafijo = 1 THEN '30'
        WHEN a.pagodiafijo = 0 THEN a.periodoabonos 
        END ) AS "periodicidad",
    (eprc_tmp2.e_parte_cub + eprc_tmp2.e_parte_exp +
    eprc_tmp2.e_parte_cub_i + eprc_tmp2.e_parte_exp_i)
    AS "reserva",
    (SELECT MIN(am.vence)
        FROM amortizaciones am
            WHERE 
                am.todopag = 'f'
                AND am.atiempo = 'f'
                AND am.idorigenp = a.idorigenp
                AND am.idproducto = a.idproducto
                AND am.idauxiliar = a.idauxiliar
                ) AS "fecha_prox_amortizacion",
    a.fechauma AS "fecha_ult_pago",
    ---SALDO A LIQUIDAR DEBE SER UN CASE PARA CUANDO ES 'V'
    ---Y PARA CUANDO NO LO ES
    (CASE 
        WHEN a.cartera = 'V' 
            THEN (SELECT 
            (cv.saldo + cv.io + cv.im))
        WHEN a.cartera != 'V'
            THEN (SELECT 
            (cv.saldo + cv.io + cv.im))
        END)
    AS "saldo_liquidar",  
    a.saldo AS "saldo_vigente"
from auxiliares a
    INNER JOIN personas p 
    USING (idorigen,idgrupo,idsocio)
    INNER JOIN carteravencida cv
        ON a.idorigenp = cv.idorigenp 
        AND a.idproducto = cv.idproducto
        AND a.idauxiliar = cv.idauxiliar
    INNER JOIN origenes o
        ON a.idorigenp = o.idorigen
    INNER JOIN productos pr
        ON a.idproducto = pr.idproducto
    INNER JOIN amortizaciones am
        ON a.idorigenp = am.idorigenp
        AND a.idproducto = am.idproducto
        AND a.idauxiliar = am.idauxiliar
    INNER JOIN eprc_tmp2
        ON a.idorigen= eprc_tmp2.idorigen AND a.idgrupo = eprc_tmp2.idgrupo 
        AND a.idsocio = eprc_tmp2.idsocio
        AND a.idorigenp= eprc_tmp2.idorigenp AND a.idproducto = eprc_tmp2.idproducto 
        AND a.idauxiliar = eprc_tmp2.idauxiliar
    WHERE p.estatus = 't'
        AND a.estatus = 2
        AND a.idproducto BETWEEN 30000 AND 39999
    ORDER BY p.idorigen,p.idgrupo,p.idsocio,
        a.idorigenp,a.idproducto,a.idauxiliar DESC 
    ;

