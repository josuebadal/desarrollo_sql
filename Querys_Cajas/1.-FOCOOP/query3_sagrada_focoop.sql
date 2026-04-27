SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||
TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "opa_act",
--TRIM(TO_CHAR(rp.idorigenpr, '099999'))||'-'||
--TRIM(TO_CHAR(rp.idproductor,'09999'))||'-'||
--TRIM(TO_CHAR(rp.idauxiliarr,'09999999')) AS "opa_origen",
(select v.fechaape 
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr)as "fecha_cred_ori",
(SELECT v.montoprestado
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        ) AS "monto_prest_cred_Reno_Ress",
(select (CASE 
        WHEN v.plazo = 1 THEN 'Pago Unico'
        WHEN v.plazo != 1 THEN 'Pago Periodico' 
        END)AS "modalidad_de_pago" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr) AS "modalidad_de_pago_ori",
(SELECT v.saldo
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        ) AS "saldo_cred_ori",
(SELECT v.saldo
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        )  AS "saldo_insoluto_ori",
(SELECT MAX(vd.fecha::date) 
        from    v_auxiliares_d vd 
        where   vd.idorigenp=rp.idorigenpr 
            and vd.idproducto=rp.idproductor 
			and vd.idauxiliar=rp.idauxiliarr
            AND vd.monto > 0 
            AND vd.cargoabono = 1
        ) AS "fech_ult_pag_cap_original",
(SELECT vd.monto
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "monto_ult_pag_cap_ori",
(SELECT vd.fecha::date
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio >0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "fech_ult_pag_int_io",
(SELECT vd.montoio
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "monto_ult_pag_int_io",
COALESCE((SELECT vd.diasvencidos
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC
           LIMIT 1),0 )AS "dias_venc_cred_ori",
(select (CASE 
        WHEN v.cartera = 'V' THEN 'Vencido'
        WHEN v.cartera !='V' THEN 'Corriente' 
        END)AS "estado_credito_ori1" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr) AS "estado_cont_credito_ori",
COALESCE((
    SELECT 'Tipo 2'
    FROM folios_particulares fp
    WHERE rp.idorigenpr  = fp.idorigenp
      AND rp.idproductor = fp.idproducto
      AND rp.idauxiliarr = fp.idauxiliar
      AND LOWER(fp.lista) LIKE '%%folios_emproblemados%%'
    LIMIT 1
), 'Tipo 1') AS "tipo_cartera_ori",
(SELECT (CASE 
    WHEN rp.tiporeferencia= 2 THEN 'Renovacion'
    WHEN rp.tiporeferencia= 3 THEN 'Reestructuracion'
    END) AS "reno_rees1"
    from productos pr
    WHERE a.idproducto =  pr.idproducto) AS "reno_rees",
a.fechaape AS "fecha_cred_actual",
a.montoprestado AS "monto_prst_reno_rees",
(select (CASE 
        WHEN v.plazo = 1 THEN 'Pago Unico'
        WHEN v.plazo != 1 THEN 'Pago Periodico' 
        END)AS "modalidad_de_pago" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenp 
            and v.idproducto=rp.idproducto 
			and v.idauxiliar=rp.idauxiliar) AS "modalidad_de_pago",
(select case when f.dependede=1 then 'Consumo'
							 when f.dependede=2 then 'Comercial'
							 when f.dependede=3 then 'Vivienda' 
							 when f.dependede=0 then '(*)' end 
				from v_auxiliares v 
				inner join finalidades f using(idfinalidad)
				where v.idorigenp=rp.idorigenpr 
                and v.idproducto=rp.idproductor 
                and v.idauxiliar=rp.idauxiliarr)as "Finalidad Anterior",
---VECES QUE SE RENOVO O REESTRUCTURO UN CREDITO
split_part(numero_renovados_reestructurados_focoop(a.idorigenp,a.idproducto,a.idauxiliar),'|',1)::int4 
AS "veces_reno_rees",

COALESCE((
   SELECT vd.diasvencidos
   FROM v_auxiliares_d vd
   WHERE vd.idorigenp  = rp.idorigenp
     AND vd.idproducto = rp.idproducto
     AND vd.idauxiliar = rp.idauxiliar
     AND vd.cargoabono = 1
     AND vd.monto > 0
     AND vd.montoio > 0
   ORDER BY vd.fecha DESC
   LIMIT 1
), 0) AS "dias_venc_cred",
(SELECT v.idnc
        FROM v_auxiliares v
        WHERE v.idorigenp  = rp.idorigenp
           AND v.idproducto = rp.idproducto
           AND v.idauxiliar = rp.idauxiliar
           LIMIT 1) AS "mont_int_dev_pag",
COALESCE((SELECT vd.monto
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenp
           AND vd.idproducto = rp.idproducto
           AND vd.idauxiliar = rp.idauxiliar
           AND vd.cargoabono = 1
           AND vd.monto > 0
           ORDER BY vd.fecha DESC
           LIMIT 1),0) AS "monto_ult_pag_cap",
a.idnc "int_dev_condonados",
(CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente' 
        END) AS "estado_cont_credito",
COALESCE((
    SELECT 'Tipo 2'
    FROM folios_particulares fp
    WHERE a.idorigenp  = fp.idorigenp
      AND a.idproducto = fp.idproducto
      AND a.idauxiliar = fp.idauxiliar
      AND LOWER(fp.lista) LIKE '%%folios_emproblemados%%'
    LIMIT 1
), 'Tipo 1') AS "tipo_cartera_reno_rees",
---LA EVIDENCIA DE PAGO SOSTENIDO ----
(CASE 
    WHEN a.tipoprestamo = 1 THEN 'seps'
    WHEN a.tipoprestamo = 2 THEN 'seps'
    WHEN a.tipoprestamo = 3 THEN 'ceps'
    WHEN a.tipoprestamo = 4 THEN 'ceps' 
    END )AS "pago_sostenido",
COALESCE((select    bc.cartera ||'-'|| bc.carteraant FROM balancecred bc 
        where  bc.idorigenp= a.idorigenp 
        AND bc.idproducto = a.idproducto
        AND bc.idauxiliar = a.idauxiliar 
        AND bc.cartera = 'C' AND bc.carteraant = 'V'),'NA') 
        as "cartera_carteraant",
COALESCE((select    bc.fechacierre::date FROM balancecred bc 
        where  bc.idorigenp= rp.idorigenp 
        AND bc.idproducto = rp.idproducto
        AND bc.idauxiliar = rp.idauxiliar 
        AND bc.cartera = 'C' AND bc.carteraant = 'V'),'01/01/1900') 
    as "fecha_cambio_cartera",



(SELECT MAX(vd.fecha::date) 
        from    v_auxiliares_d vd 
        where   vd.idorigenp=rp.idorigenpr 
            and vd.idproducto=rp.idproductor 
			and vd.idauxiliar=rp.idauxiliarr
            AND vd.monto > 0 
            AND vd.cargoabono = 1
        ) AS "fech_ult_liq_original"
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

