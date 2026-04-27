SELECT 
    DISTINCT ON(p.idorigen,p.idgrupo,p.idsocio,
    a.idorigenp,a.idproducto,a.idauxiliar)  
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) 
    AS "Cuenta",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) 
    AS "Socio",
    --TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    --TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    --TRIM(TO_CHAR(p.idsocio,'099999')) AS "Folio",
    nombre_x(p.nombre, p.appaterno, p.apmaterno) 
    AS "Nombre",
    cv.abonosvencidos::integer 
    AS "Omisos", 
    cv.diasvencidos 
    AS "Dias_Mora", 
    o.nombre AS "Plaza", 
    pr.nombre AS "Producto", 
    COALESCE(p.rfc,'No Registrado') AS "RFC", 
    o.fechatrabajo AS "FechaSaldo",
    --cv.montovencido AS "Saldo",
    (CASE 
        WHEN pr.tipofinalidad = 1 THEN 'Consumo'
        WHEN pr.tipofinalidad = 2 THEN 'Comercial'
        WHEN pr.tipofinalidad = 3 THEN 'Vivienda'
        END) AS "Subcuenta",
    (CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Vigente'
        END) AS "Estatus", 
    a.fechaactivacion AS "Fecha_Desembolso",
    -----ULTIMA AMORTIZACION
    (SELECT am.vence
        FROM amortizaciones am
            WHERE am.idorigenp = a.idorigenp
                AND am.idproducto = a.idproducto
                AND am.idauxiliar = a.idauxiliar
                AND am.todopag = 'f'
                AND am.atiempo = 'f'
            ORDER BY idamortizacion DESC LIMIT 1) 
            AS "Fecha_Cierre", 
    COALESCE(p.curp,'No Registrado') AS "Curp",
    mun.nombre AS "Ciudad",
    col.nombre AS "Colonia", 
    col.codigopostal AS "CP",
    '' AS "Delegacion", 
    es.nombre AS "Estado", 
    p.entrecalles  AS "Entre_Calle_A",
    '' AS "Entre_Calle_B", 
    '' AS "Referencia", 
    COALESCE(p.email,'No Registrado')AS "Correo_Electronico",
    p.telefono  AS "Telefono1", 
    'Casa(fijo)' AS "tipoTel1", 
    p.celular AS "Telefono2", 
    'Celular(fijo)' AS "tipoTel2",
    p.telefonorecados AS "Telefono3",
    'Recados(fijo)' AS "tipoTel3",
    tr.telefono AS "Telefono4",
    'Telefono 1 trabajo' AS "tipoTel4",
    tr.telefono2 AS "Telefono5",
    'Telefono 2 trabajo' AS "tipoTel5",
    '' AS "Telefono6",'' AS "tipoTel6",
    (CASE 
        WHEN a.cartera = 'V' THEN a.saldo
        END) AS "capital_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.saldo
        END) AS "capital_vigente",
    a.ieco  AS "int_ctas_orden", 
    a.iecom AS "int_moratorio",
    (CASE 
        WHEN a.cartera = 'V' THEN a.idncm
        END) AS "int_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.idnc
        END) AS "int_vigente",
    ROUND((a.ieco * (16.00/100)),2) AS "iva_ctas_orden", 
    ROUND((a.iecom * (16.00/100)),2) AS "iva_moratorio", 
    (CASE 
        WHEN a.cartera = 'V' THEN ROUND(a.idncm * (16.00/100),2)
        END) AS "iva_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN ROUND(a.idnc* (16.00/100),2)
        END)  AS "iva_vigente",
    '0.00' AS "gastos_cobranza",
    -------ESTE DATO REALENTIZA LA CONSULTA SOBRE PASANDO LOS
    -------13 MN  VALIDAR CON GABY SI SE PUEDE OPTIMIZAR
    -------SE COMENTA LA CORRECCION
    /*
    (SELECT ROUND(am.abono +(a.idnc + (a.idnc * (16.00/100)) ),2) 
        from amortizaciones am
        WHERE am.atiempo = 'f'
            AND am.todopag = 'f'
            AND a.idorigenp = am.idorigenp
            AND a.idproducto= am.idproducto
            AND a.idauxiliar= am.idauxiliar
        ORDER BY am.vence DESC limit 1)
    */
    (CASE 
        WHEN am.idamortizacion = 2 THEN am.abono
        END) AS "monto amortizacion", 
    a.montoprestado AS "monto_otorgado",
    (CASE WHEN a.pagodiafijo = 1 THEN '30'
        WHEN a.pagodiafijo = 0 THEN a.periodoabonos 
        END ) AS "periodicidad",
    eprc_tmp2.e_parte_cub AS "estimacion_capital_cubierto", 
    eprc_tmp2.e_parte_exp AS "estimacion_capital_expuesto",
    eprc_tmp2.e_parte_cub_i AS "estimacion_interes_cubierto", 
    eprc_tmp2.e_parte_exp_i AS "estimacion_interes_expuesto",
    (eprc_tmp2.e_parte_cub + eprc_tmp2.e_parte_exp +
    eprc_tmp2.e_parte_cub_i + eprc_tmp2.e_parte_exp_i)
    AS "reserva",
---------- ESTE DATO SIGUE ESTANDO MAL PERO
---------- REALENTIZA LA CONSULTA
---------- Se comenta la consulta correcta
/* 
(SELECT MIN(am.vence)
        FROM amortizaciones am
            WHERE 
                am.todopag = 'f'
                AND am.atiempo = 'f'
                AND am.idorigenp = a.idorigenp
                AND am.idproducto = a.idproducto
                AND am.idauxiliar = a.idauxiliar
                ) 
*/     
    (select MIN(am.vence) 
        from amortizaciones am
            INNER JOIN auxiliares_d ad
            ON ad.idorigenp = am.idorigenp
            AND ad.idproducto = am.idproducto
            AND ad.idauxiliar = am.idauxiliar 
        where am.abonopag = 0) AS "fecha_prox_amortizacion", 
    a.fechauma AS "fecha_ult_pago",
    (SELECT SUM(a.saldo + (a.idnc +(a.idnc * (pr.iva / 100.0))))) 
    AS "saldo_liquidar",
    a.saldo AS "saldo_vigente",
    --VALIDAR LAS FECHAS -- ULTIMO CAMBIO
    (SELECT MAX(ad.fecha) 
        from auxiliares_d ad
        WHERE ad.tipomov !=3 
            AND ad.cargoabono = 1
            AND ad.montoio >0
            AND a.idorigenp = ad.idorigenp
            AND a.idproducto= ad.idproducto
            AND a.idauxiliar= ad.idauxiliar
        limit 1) AS "fecha_ultimo_pago_interes_normal",

    (SELECT MAX(ad.fecha) 
        from auxiliares_d ad
        WHERE ad.tipomov !=3 
            AND ad.cargoabono = 1
            AND ad.montoim >0
            AND a.idorigenp = ad.idorigenp
            AND a.idproducto=   ad.idproducto
            AND a.idauxiliar=   ad.idauxiliar
        limit 1) AS "fecha_ultimo_pago_de_interes_moratorio",
        
    (SELECT MAX(ad.fecha) 
        from auxiliares_d ad
        WHERE ad.tipomov !=3 
            AND ad.cargoabono = 1
            AND ad.monto >0
            AND a.idorigenp =   ad.idorigenp
            AND a.idproducto=   ad.idproducto
            AND a.idauxiliar=   ad.idauxiliar
        limit 1) AS "fecha_ultimo_pago_a_capital",
----------VALIDAR FECHA CON MIN LA FECHA NO ES CORRECTA
----------SE COMENTAL LAS CONDICIONES PARA VALIDAR EL DATO

    (SELECT MIN(am.vence)
        FROM amortizaciones am
        WHERE  am.todopag != 't'
            AND am.atiempo != 't'
            --AND am.idorigenp = a.idorigenp
            --AND am.idproducto = a.idproducto
            --AND am.idauxiliar = a.idauxiliar
    ) AS "fecha_de_primer_amortizacion_no_cubierta",


    a.fechaactivacion AS "fecha_de_otorgamiento", 
    p.fechanacimiento AS "fecha_de_nacimiento",
    (select COALESCE(a.saldo,0) 
        from auxiliares a 
        where a.idproducto=110 
            and a.idorigen=p.idorigen 
            and a.idgrupo =p.idgrupo 
            and a.idsocio = p.idsocio 
            order by fechaumi desc 
        limit 1) AS "ahorro_ordinario", 
    (select COALESCE(a.saldo,0) 
        from auxiliares a 
        where a.idproducto=130 
            and a.idorigen=p.idorigen 
            and a.idgrupo =p.idgrupo 
            and a.idsocio = p.idsocio 
            order by fechaumi desc limit 1) AS "cuenta_corriente",
    a.garantia AS "ahorro_garantia",
    (SELECT count(*)
        FROM auxiliares a
            INNER JOIN productos pr
            ON a.idproducto = pr.idproducto 
        WHERE a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
            AND a.estatus = 2
            AND pr.tipoproducto = 2
            ) AS "creditos_activos",
    --VALIDAR SI ES LA SUMA CORRECTA O FALTA SUMAR ALGUN DATO + OPAS
    --VALIDAR LA SUMA 
    (SELECT SUM(am.abono + am.io) 
        from amortizaciones am
        WHERE todopag = 'f'
            AND am.vence = 
                (SELECT MIN(am1.vence)
                FROM amortizaciones am1
                WHERE am1.diasvencidos >0 
                AND am1.atiempo = 'f')   
        ) AS  "saldo_1er_amortizacion_vencida",
    a.plazo AS "plazo", 
    tr.ing_mensual_neto AS "Ingresos_del_socio",
    tr.deducciones_deudas AS "gastos_del_socio",
    tr.telefono AS "telefono_del_trabajo",
    (CASE 
        WHEN a.plazo = 1 THEN 'Pago Unico' 
        WHEN a.plazo != 1 THEN 'Pago Periodico' 
        END) AS "modalidad_de_pago",
    (CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente'
        END) AS "situacion_contable", 
    f.descripcion AS "finalidad_del_credito", 
    tr.nombre AS "Donde_trabaja",
    tr.ocupacion AS "Ocupacion",
    (CASE 
        WHEN a.tipoprestamo = 0 THEN 'Normal' 
        WHEN a.tipoprestamo IN (1,3) THEN 'Renovado' 
        WHEN a.tipoprestamo IN (2,4) THEN 'Reestructurado'
        END) AS "tipo_de_credito",
    (p.calle ||' '||p.numeroext)  AS "direccion_del_socio",
    (tr.calle ||' '||tr.numero)  AS "direccion_trabajo",
    '' AS "referencias_de_direccion_de_trabajo"
    
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
INNER JOIN colonias col
ON p.idcolonia = col.idcolonia
INNER JOIN municipios mun
ON col.idmunicipio = mun.idmunicipio
INNER JOIN estados es
ON mun.idestado = es.idestado
INNER JOIN finalidades f
ON a.idfinalidad = f.idfinalidad
INNER JOIN trabajo tr
ON p.idorigen = tr.idorigen
AND p.idgrupo = tr.idgrupo
AND p.idsocio = tr.idsocio
INNER JOIN eprc_tmp2
ON a.idorigen= eprc_tmp2.idorigen AND a.idgrupo = eprc_tmp2.idgrupo AND a.idsocio = eprc_tmp2.idsocio
AND a.idorigenp= eprc_tmp2.idorigenp AND a.idproducto = eprc_tmp2.idproducto AND a.idauxiliar = eprc_tmp2.idauxiliar
WHERE p.estatus = 't'
    AND p.idgrupo = 10
    AND a.idproducto BETWEEN 30000 AND 39999
    AND a.estatus = 2
GROUP BY p.idorigen,p.idgrupo,p.idsocio,a.idorigenp,a.idproducto,a.idauxiliar,
         cv.abonosvencidos, cv.diasvencidos,o.nombre,pr.nombre,o.fechatrabajo,
         cv.montovencido,pr.tipofinalidad,am.vence,mun.nombre,col.nombre,
         col.codigopostal,es.nombre,tr.telefono,tr.telefono2,am.idamortizacion,
         am.abono,eprc_tmp2.e_parte_cub,eprc_tmp2.e_parte_exp,eprc_tmp2.e_parte_cub_i,
         eprc_tmp2.e_parte_exp_i,tr.ing_mensual_neto,tr.deducciones_deudas,f.descripcion,
         tr.nombre,tr.ocupacion,tr.calle,tr.numero,ad.fecha,am.diasvencidos,
         am.atiempo
         ;
