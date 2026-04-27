/*11.   Listado de los creditos renovados y/o reestructurados en el periodo del 01 de enero de 2024 al 31 de agosto de 2025, que contenga por lo menos las siguientes columnas de datos, en archivo electronico de formato Excel:
*/

SELECT --DISTINCT ON (a.idorigenp,a.idproducto,a.idauxiliar)
/*
a.    Numero del socio. b.    Nombre del socio. c.    Numero de credito.
*/
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||
TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",
--d.    Fecha del credito original.
(select v.fechaape 
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr)as "fecha_cred_ori",
--e.    Monto del credito original.
(SELECT v.montoprestado
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        ) AS "monto_prest_cred_Reno_Ress",
--f.      Modalidad de pago del credito original.
(select (CASE 
        WHEN v.plazo = 1 THEN 'Pago Unico'

        WHEN v.plazo != 1 THEN 'Pago Periodico' 
        END)AS "modalidad_de_pago" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr) AS "modalidad_de_pago",
--g.    Saldo del capital del credito original.
(SELECT v.saldo
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        ) AS "saldo_cred_ori"
--h.    Saldo Insoluto del credito original.
((SELECT v.montoprestado
     FROM v_auxiliares v
     WHERE v.idorigenp  = rp.idorigenpr
       AND v.idproducto = rp.idproductor
       AND v.idauxiliar = rp.idauxiliarr)
    -
COALESCE(
    (SELECT SUM(vd.monto)
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1), 0)) AS "saldo_insoluto_ori",
--i.       Fecha del ultimo pago de capital.
(SELECT MAX(vd.fecha::date) 
        from    v_auxiliares_d vd 
        where   vd.idorigenp=rp.idorigenpr 
            and vd.idproducto=rp.idproductor 
			and vd.idauxiliar=rp.idauxiliarr
            AND vd.monto > 0 
            AND vd.cargoabono = 1
        ) AS "fech_ult_pag_cap_original",
--j.      Monto del ultimo pago de capital.
(SELECT vd.monto
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "monto_ult_pag_cap",
--k.     Fecha del ultimo pago de interes.
(SELECT vd.fecha::date
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio >0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "monto_ult_pag_int",
--l.      Monto del ultimo pago de interes.
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
--m.  Dias mora del credito original al momento de la 
--renovacion o reestructura. 
(SELECT vd.diasvencidos
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "dias_venc_cred_ori",
--n.    Estado contable del credito original (vigente, vencido).
(select (CASE 
        WHEN v.cartera = 'V' THEN 'Vencido'
        WHEN v.cartera!='V' THEN 'Corriente' 
        END)AS "estado_credito_ori1" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr) AS "estado_credito_ori",
--o.    Tipo de cartera del credito original (1o 2).
(select (CASE 
        WHEN vd.diasvencidos =0 THEN 'Tipo 1'
        WHEN vd.diasvencidos >=1
        AND  vd.diasvencidos <=89 THEN 'Tipo 2' 
        END)AS "tipo_cartera1" FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC LIMIT 1) AS "tipo_cartera",
--p.    Renovacion/Reestructura.
(SELECT (CASE 
    WHEN rp.tiporeferencia= 2 THEN 'Renovacion'
    WHEN rp.tiporeferencia= 3 THEN 'Reestructuracion'
    END) AS "reno_rees1"
    from productos pr
    WHERE a.idproducto =  pr.idproducto) AS "reno_rees",
--q.    Fecha del credito renovado o reestructurado.
a.fechaape AS "fecha_cred_actual",
--r.      Monto del credito renovado o reestructurado.
a.montoprestado AS "monto_prst_reno_rees",
--s.    Modalidad de pago del credito renovado o reestructurado.
(select (CASE 
        WHEN v.plazo = 1 THEN 'Pago Unico'

        WHEN v.plazo != 1 THEN 'Pago Periodico' 
        END)AS "modalidad_de_pago" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenp 
            and v.idproducto=rp.idproducto 
			and v.idauxiliar=rp.idauxiliar) AS "modalidad_de_pago",


--z.     Estado contable del credito renovado o reestructurado(vigente, vencido).
-- se valida con 020703-10-013360
(CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente' 
        END) AS "estado_cont_credito",

--aa.     Tipo de cartera del credito renovado o reestructurado (1 o 2).
(SELECT (CASE 
        WHEN vd.diasvencidos =0 THEN 'Tipo 1'
        WHEN vd.diasvencidos >=1
        AND  vd.diasvencidos <=89 THEN 'Tipo 2' 
        END)AS "tipo_cartera1" FROM v_auxiliares_d vd 
        WHERE vd.idorigenp  = rp.idorigenp
           AND vd.idproducto = rp.idproducto
           AND vd.idauxiliar = rp.idauxiliar
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC LIMIT 1) AS "tipo_cartera_ori",



rp.tiporeferencia


/*
SELECT * from v_auxiliares where (idorigenp, idproducto,idauxiliar)=
(020704,30119,00000658);

SELECT * from v_auxiliares_d where (idorigenp, idproducto,idauxiliar)=
(020713,30120,00000051) order by fecha desc;

(CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente'
        END) AS "Estatus", 
(CASE 
        WHEN a.cartera = 'V' THEN a.saldo
        END) AS "capital_vencido",
(CASE 
        WHEN a.cartera != 'V' THEN a.saldo
        END) AS "capital_vigente",

(CASE WHEN a.pagodiafijo = 1 THEN '30'
        WHEN a.pagodiafijo = 0 THEN a.periodoabonos 
        END ) AS "periodicidad",
rp.tiporeferencia AS "tipo de referencia",
(SELECT montoprestado
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        ) AS "Monto_Cred_Reno_Ress",



(SELECT (v.montoprestado)
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr  
        )
        AS "saldo_insoluto_ori",

(SELECT SUM(vd.monto)
        from    v_auxiliares_d vd 
        where   vd.idorigenp=rp.idorigenpr 
            and vd.idproducto=rp.idproductor 
			and vd.idauxiliar=rp.idauxiliarr
            AND vd.cargoabono = 1  
        )
        AS "suma_montos_abonados"

        
--p.Renovacion/Reestructura
pr.nombre AS "Nombre_Producto",
--SE AGREGA PARA CORROBORAR LA INFOR DEL OPA QUE NACIO
--SE AGREGA ESTE APARTADO PARA VALIDAR SI TRAEN LOS AUXILIARES
rp.idorigenpr||'-'||rp.idproductor||'-'||rp.idauxiliarr AS "opa_cred_nacio",

rp.tiporeferencia AS "tipo de referencia"
--q.Fecha del credito renovado o reestructurado
--r.Monto del credito renovado o reestructurado
*/
    ----------------------
    --CONSULTA GENERAL
    ----------------------    
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
        AND rp.tiporeferencia in (2,3)
        AND a.fechaape::date BETWEEN '01/01/2024' and '31/08/2025' 
        AND (LOWER(pr.nombre) LIKE '%reno%' OR LOWER(pr.nombre) LIKE '%rees%')
        and a.tipoprestamo in (2,3)  
	    and f.dependede in(1,2,3);            
    ;

