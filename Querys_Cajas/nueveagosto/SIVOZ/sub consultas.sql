/*
select * from amortizaciones 
where (idorigenp,idproducto,idauxiliar)=(10403,32615,18)
AND idamortizacion IN (8,9,10); 
idorigen                | 10401
idgrupo                 | 10
idsocio                 | 1769
select * from auxiliares_d 
where (idorigenp,idproducto,idauxiliar)=(10403,32615,18); 
   select * from tablas where lower(idtabla) = 'dias_no_validos_para_pagos'
   SELECT sai_iva_segun_sucursal(10450, idproducto, 0) FROM productos WHERE idproducto=32615
   SELECT iva FROM productos WHERE idproducto=32615
   SELECT sai_iva_segun_sucursal(10450, idproducto, 1) FROM productos WHERE idproducto=32615
   SELECT ivaim FROM productos WHERE idproducto=32615
   SELECT sai_auxiliar(10403,32615,18,'31/08/2025')
   select sum(apagar + ivaapagar) from sai_prestamos_hipotecarios_calcula_seguro_a_pagar(10403,32615,18,'31/08/2025')
   SELECT monto FROM monto_pagos_fijos WHERE idorigenp=10403 AND idproducto=32615 AND idauxiliar=18
   SELECT * FROM sai_tabla_amortizaciones_t0_calculada('amortizaciones',10403,32615,18,'31/08/2025',0.16,0,'29/09/2025') ORDER BY idamortizacion

*/




SELECT DISTINCT ON(p.idorigen,p.idgrupo,p.idsocio,a.idorigenp,a.idproducto,a.idauxiliar)  
    p.idorigen,p.idgrupo,p.idsocio,
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
    o.fechatrabajo AS "fecha",
    cv.montovencido AS "saldo",
    cv.abonosvencidos AS "omisos",
    cv.diasvencidos AS "dias_mora",
    (CASE 
        WHEN am.idamortizacion = 2 THEN am.abono
        END) AS "monto_amortizacion",
    (SELECT MIN(am2.vence)
        FROM amortizaciones am2
            WHERE am2.idorigenp = a.idorigenp
                AND am2.idproducto = a.idproducto
                AND am2.idauxiliar = a.idauxiliar
                AND am2.todopag = 'f'
                AND am2.atiempo = 'f'
            ) AS "fecha_prox_amortizacion",
    a.fechauma AS "fecha_ult_pago",
    (SELECT SUM(a1.saldo + (a1.idnc +(a1.idnc * (pr.iva / 100.0))))
        FROM auxiliares a1
        WHERE a1.idorigenp = a.idorigenp
            AND a1.idproducto = a.idproducto
            AND a1.idauxiliar = a.idauxiliar
    )AS "saldo_liquidar",  
    a.saldo AS "saldo_vigente"
from auxiliares a
    INNER JOIN auxiliares_d ad
        ON    a.idorigenp = ad.idorigenp
        AND   a.idproducto = ad.idproducto
        AND   a.idauxiliar =ad.idauxiliar
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
    WHERE p.estatus = 't'
    GROUP BY p.idorigen,p.idgrupo,p.idsocio,a.idorigenp,a.idproducto,a.idauxiliar,o.fechatrabajo,
         cv.montovencido,cv.abonosvencidos,cv.diasvencidos,
         a.cartera,a.saldo,a.ieco,a.idncm,a.idnc,pr.iva, am.idamortizacion,
         am.abono,am.todopag,am.vence,am.abonopag,am.idorigenp,am.idproducto,
         am.idauxiliar
         ;

