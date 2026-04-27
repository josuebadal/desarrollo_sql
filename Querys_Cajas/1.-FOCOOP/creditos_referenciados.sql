SELECT      
    TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||
    TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||
    TRIM(TO_CHAR(p.idsocio, '099999')) AS "ogs",
    nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "nombre" ,        
    TRIM(TO_CHAR(rp.idorigenp, '099999'))||'-'||
    TRIM(TO_CHAR(rp.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(rp.idauxiliar,'09999999')) AS "opa_nuevo",
    --TRIM(TO_CHAR(rp.idorigenpr, '099999'))||'-'||
    --TRIM(TO_CHAR(rp.idproductor,'09999'))||'-'||
    --TRIM(TO_CHAR(rp.idauxiliarr,'09999999')) AS "opa_origen",
    COALESCE((select    bc.fechaumi::date FROM balancecred bc 
        where  bc.idorigenp= rp.idorigenp 
        AND bc.idproducto = rp.idproducto
        AND bc.idauxiliar = rp.idauxiliar 
        AND bc.cartera = 'C' AND bc.carteraant = 'V'
        ORDER BY bc.fechaumi DESC LIMIT 1),'01/01/1900') as "fechaumi",

    COALESCE((select    bc.cartera ||'-'|| bc.carteraant FROM balancecred bc 
        where  bc.idorigenp= a.idorigenp 
        AND bc.idproducto = a.idproducto
        AND bc.idauxiliar = a.idauxiliar 
        AND bc.cartera = 'C' AND bc.carteraant = 'V'),'NA') 
        as "carteras",

    COALESCE((select    bc.fechacierre::date FROM balancecred bc 
        where  bc.idorigenp= rp.idorigenp 
        AND bc.idproducto = rp.idproducto
        AND bc.idauxiliar = rp.idauxiliar 
        AND bc.cartera = 'C' AND bc.carteraant = 'V'),'01/01/1900') 
    as "fecha_cierre_ant",
    (CASE 
    WHEN a.tipoprestamo = 1 THEN 'seps'
    WHEN a.tipoprestamo = 2 THEN 'seps'
    WHEN a.tipoprestamo = 3 THEN 'ceps'
    WHEN a.tipoprestamo = 4 THEN 'ceps' 
    END )AS "pago_sostenido_tipo"
    
        FROM auxiliares a
        INNER JOIN personas p
            ON a.idorigen = p.idorigen 
            AND a.idgrupo = p.idgrupo 
            AND a.idsocio = p.idsocio 
        INNER JOIN productos pr
            ON a.idproducto =  pr.idproducto
        LEFT JOIN referenciasp AS rp 
                ON a.idorigenp = rp.idorigenp 
                AND a.idproducto = rp.idproducto 
                AND a.idauxiliar = rp.idauxiliar
	inner join finalidades f on (a.idfinalidad=f.idfinalidad)
    WHERE pr.tipoproducto= 2
        AND p.idgrupo = 10
        AND a.estatus IN(2,3)
        AND a.idproducto BETWEEN 30000 and 39999
        AND rp.tiporeferencia in (2,3)
        and f.dependede in(1,2,3)
        AND (LOWER(pr.nombre) LIKE '%%reno%%' OR LOWER(pr.nombre) LIKE '%%rees%%')
        AND a.fechaactivacion ::date BETWEEN '01/01/2024' and '31/08/2025' 
        and a.tipoprestamo in (1,2,3,4)
    ORDER BY 
    p.idorigen,p.idgrupo,p.idsocio
    ,a.idorigen,a.idproducto,a.idauxiliar desc  
    ;
