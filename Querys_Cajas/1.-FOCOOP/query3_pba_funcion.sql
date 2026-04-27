--numero_renovados_reestructurados_focoop(p1,p2,p3)
--    numero_renovados_reestructurados_focoop(a.idorigen::numeric,a.idproducto::numeric,
--    a.idauxiliar::numeric)
--substr(a.idorigenp,0,6)::integer, substr(a.idproducto,0,5)::integer, substr(a.idauxiliar,0,8)::integer
--numero_renovados_reestructurados_focoop(a.idorigen::int,a.idproducto::int, a.idauxiliar::int)
/*
        select 
        numero_renovados_reestructurados_focoop(20702,30112,30)
        split_part(numero_renovados_reestructurados_focoop(20702,30112,30),'|',1)::int4 ;
*/
--split_part(numero_renovados_reestructurados_focoop(a.idorigen::int,a.--idproducto::int, a.idauxiliar::int),',',1)::int4
SELECT
(select bc.fechacierre 
    from balancecred bc
    where UPPER(bc.carteraant) ='C'
    AND   UPPER(bc.cartera)    ='V'
    AND     vd.idorigenp=rp.idorigenpr 
    and vd.idproducto=rp.idproductor 
	and vd.idauxiliar=rp.idauxiliarr
    ) as "fecha_eps",
    (CASE 
    WHEN a.tipoprestamo = 1 THEN 'seps'
    WHEN a.tipoprestamo = 2 THEN 'seps'
    WHEN a.tipoprestamo = 3 THEN 'ceps'
    WHEN a.tipoprestamo = 4 THEN 'ceps' 
    END )AS "pago_sostenido",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
TRIM(TO_CHAR(rp.idorigenpr, '099999'))||'-'||
TRIM(TO_CHAR(rp.idproductor,'09999'))||'-'||
TRIM(TO_CHAR(rp.idauxiliarr,'09999999')) AS "opa_origen"
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
        INNER JOIN v_auxiliares_d vd 
        ON vd.idorigenp=rp.idorigenpr 
        and vd.idproducto=rp.idproductor 
		and vd.idauxiliar=rp.idauxiliarr
	inner join finalidades f on (a.idfinalidad=f.idfinalidad)
    INNER JOIN balancecred bc
    ON rp.idorigenp = bc.idorigenp 
    AND rp.idproducto = bc.idproducto 
    AND rp.idauxiliar = bc.idauxiliar
    WHERE pr.tipoproducto= 2
        AND p.idgrupo = 10
        AND a.estatus IN(2,3)
        AND a.idproducto BETWEEN 30000 and 39999
        AND rp.tiporeferencia in (2,3)
        and f.dependede in(1,2,3)
        AND (LOWER(pr.nombre) LIKE '%reno%' OR LOWER(pr.nombre) LIKE '%rees%')
        AND a.fechaape::date BETWEEN '01/01/2024' and '31/08/2025' 
        and a.tipoprestamo in (1,2,3,4)
    ORDER BY 
    p.idorigen,p.idgrupo,p.idsocio
    ,a.idorigen,a.idproducto,a.idauxiliar
    ;




