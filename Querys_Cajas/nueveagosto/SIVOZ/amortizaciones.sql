SELECT 
        TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
        TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
        am.vence AS "fecha",
        am.idamortizacion,
        (CASE 
            WHEN am.todopag = 't' 
                AND am.atiempo = 't' 
                AND am.abonopag > 0 THEN 'VIGENTE'
            WHEN am.todopag = 't'
                AND am.atiempo != 't'
                AND am.diasvencidos >0
                AND am.abonopag >0 
                AND am.abono >0 THEN 'VENCIDO'
            WHEN am.todopag = 't'
                AND am.abonopag > 0 THEN 'PAGADO'
            WHEN am.todopag !='t'
                AND am.atiempo !='t'
                AND am.abonopag = 0
                AND am.diasvencidos IS  NULL THEN  'VIGENTE'
                ELSE 'PAGADO'
                END) AS "estatus",
        
        am.abono AS "Capital",
        am.abonopag AS "Capital_pagado",
        '' AS "fecha_pago_capital",
        am.io AS "Interes",
        am.iopag "Interes_pagado",
        ' ' AS "fecha_pago_interes",
        ' ' AS "iva_interes",
        ' ' AS "iva_interes_pagado",
        ' ' AS "interes_moratorio",
        ' ' AS "interes_moratorio_pagado",
        ' ' AS "iva_moratorio",
        ' ' AS "iva_moratorio_pagado" 
    FROM auxiliares a
        INNER JOIN amortizaciones am 
            ON a.idorigenp = am.idorigenp
            AND a.idproducto = am.idproducto
            AND a.idauxiliar = am.idauxiliar
    WHERE a.estatus = 2
        AND a.idproducto BETWEEN 30000 AND 39999
    ORDER BY a.fechaape,a.idorigenp,a.idproducto,a.idauxiliar,am.idamortizacion
    ;