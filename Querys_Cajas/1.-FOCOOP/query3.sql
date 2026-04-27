/*
Sobre el query 3:

La columna "saldo_insoluto_ori" tiene montos negativos 
y considero que deberia ser cero porque ya esta liquidado 
el credito original. Revisando parece ser que los valores 
negativos los toma de ajustes de tickets (tipo de movimiento con valor 6)

R=se agrego un COALESCE ya no hay datos vacios

La columna "tipo_cartera_ori" tiene valores vacios o nulos, 
deberia tener valor siempre.

R= se agrega COALESCE validar si es tipo V,C,M 

La columna "dias_venc_cred" tiene valores vacios y no deberia tenerlos

R= se agrega COALESCE porque hay creditos recien aperturados
que no tienen diasvencidos ya que no han llegado a la 1ra AMORTIZACION

La columna "pago_sostenido" tiene el valor ND y si hay debe poder determinarse porque de lo contrario se estaria incumpliendo un tema regulatorio.
R= 


select * 
from numero_renovados_reestructurados_focoop(020702,30120,00000076);
*/

/*
020751-10-000148	
MARIA DEL ROSARIO RUIZ FERNANDEZ	 
020751-30119-00000062	
020751-30203-00000118

select distinct(fechacierre) 
from balancecred 
order by fechacierre 
desc limit 100;


SELECT * from balancecred where cartera= 'C' 
and carteraant = 'V' 
order by fechacierre desc;    

fechacierre      | 30/08/2025  
FECHA DE LA 
AMORTIZACION QUE 
DEBO OBTENER| 17/08/2025
idorigen         | 20709
idgrupo          | 10
idsocio          | 7985
idorigenp        | 20709
idproducto       | 30203
idauxiliar       | 177

select * from amortizaciones where 
(idorigenp,idproducto,idauxiliar) =
(20709,30203,177)
AND todopag = 't'
AND atiempo = 't'
order by idamortizacion
--AND idorigen =20709
--AND idgrupo =10
--AND idsocio =7985
--AND idorigenp =20709

;

 AND amortizacion.fecha <= balancecred.fecha_cierre ---

SELECT JUSTIFY_DAYS(INTERVAL '30 days')   AS conv1,
       JUSTIFY_DAYS(INTERVAL '60 days')   AS conv2;

SELECT ARRAY[1,2,3] AS ejemplo;


select * from finalidades
ORDER BY idfinalidad;

idfinalidad          | 120
descripcion          | RENEGOCIACION POR COBRANZA
dependede            | 1
clasif_contable_siti | 130174000000

select * from auxiliares where (idorigenp,idproducto,idauxiliar)
= (020705,30722,00000002);

where LOWER(descripcion)  LIKE '%COBRA%'  order by idfinalidad;


DISTINCT ON (tipoprestamo )* from auxiliares 
where tipoprestamo IN (0,1,2,3,4)
;

select v.fechaape,v.tipoprestamo,v.idfinalidad from v_auxiliares as v
inner join referenciasp as r using (idorigenp,idproducto,idauxiliar)
where r.tiporeferencia=3 and v.estatus in (2,3) and v.fechaape BETWEEN date('01-01-2024') and date('31-08-2025');
*/
SELECT 
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||
TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
TRIM(TO_CHAR(a.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "OPA",

(select  TRIM(TO_CHAR(v.idorigen, '099999'))||'-'||
TRIM(TO_CHAR(v.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(v.idauxiliar,'09999999')) AS "OPA1"
        from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr
            --AND (LOWER(pr.nombre) LIKE '%reno%' OR LOWER(pr.nombre) LIKE '%rees%')
        
        )as "opa_cred_ori",
-----------------------
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
(select (CASE 
        WHEN v.cartera = 'V' THEN 'Vencido'
        WHEN v.cartera !='V' THEN 'Corriente' 
        END)AS "estado_credito_ori1" from    v_auxiliares v 
        where   v.idorigenp=rp.idorigenpr 
            and v.idproducto=rp.idproductor 
			and v.idauxiliar=rp.idauxiliarr) AS "estado_cont_credito_ori",
---COMENTAN QUE TIENE DATOS VENCIDOS FALTA TIPO 3

(select (CASE 
        WHEN vd.diasvencidos =0   THEN 'Tipo 1'
        WHEN vd.diasvencidos >=1
        AND  vd.diasvencidos <=89 THEN 'Tipo 2' 
        WHEN vd.diasvencidos >=90 THEN 'Tipo 3' 
        END)AS "tipo_cartera1" FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenpr
           AND vd.idproducto = rp.idproductor
           AND vd.idauxiliar = rp.idauxiliarr
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC LIMIT 1) AS "tipo_cartera_ori",
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
'1' AS "veces_reno_rees",
(SELECT vd.diasvencidos
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenp
           AND vd.idproducto = rp.idproducto
           AND vd.idauxiliar = rp.idauxiliar
           AND vd.cargoabono = 1
           AND vd.monto > 0
           AND vd.montoio>0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "dias_venc_cred",
(SELECT v.idnc
        FROM v_auxiliares v
        WHERE v.idorigenp  = rp.idorigenp
           AND v.idproducto = rp.idproducto
           AND v.idauxiliar = rp.idauxiliar
           LIMIT 1) AS "mont_int_dev_pag",
(SELECT vd.monto
        FROM v_auxiliares_d vd
        WHERE vd.idorigenp  = rp.idorigenp
           AND vd.idproducto = rp.idproducto
           AND vd.idauxiliar = rp.idauxiliar
           AND vd.cargoabono = 1
           AND vd.monto > 0
           ORDER BY vd.fecha DESC
           LIMIT 1) AS "monto_ult_pag_cap",
a.idnc "int_dev_condonados",
(CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente' 
        END) AS "estado_cont_credito",
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
'ND' AS "pago_sostenido",
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
        AND rp.tiporeferencia in (2,3)
        AND a.fechaape::date BETWEEN '01/01/2020' and '31/08/2025' 
        AND ((LOWER(pr.nombre) LIKE '%reno%' OR LOWER(pr.nombre) LIKE '%rees%'))
        and a.tipoprestamo in (0,1,2,3,4)  
	    and f.dependede in(1,2,3)
    ORDER BY 
    p.idorigen,p.idgrupo,p.idsocio
    ,a.idorigen,a.idproducto,a.idauxiliar
    ;

/*QUERY PARA VER LAS VECES QUE UN CREDITO FUE RENOVADO HASTA LLEGAR
AL ORIGINAL Y MUESTR EL OPA ORIGINAL Y EL OPA NUEVO POR EL QUE SE RENOVO
O SE REESTRUCTURO TIENE 45877 REGISTROS*/ 

SELECT              
    TRIM(TO_CHAR(rp.idorigenp, '099999'))||'-'||
    TRIM(TO_CHAR(rp.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(rp.idauxiliar,'09999999')) AS "opa_nuevo",
    TRIM(TO_CHAR(rp.idorigenpr, '099999'))||'-'||
    TRIM(TO_CHAR(rp.idproductor,'09999'))||'-'||
    TRIM(TO_CHAR(rp.idauxiliarr,'09999999')) AS "opa_origen",
    rp.tiporeferencia
        FROM referenciasp rp
        INNER JOIN v_auxiliares v
        ON v.idorigenp= rp.idorigenpr 
        AND v.idproducto = rp.idproductor
        AND v.idauxiliar = rp.idauxiliarr
        INNER JOIN personas p 
        ON p.idorigen = v.idorigen
        AND p.idgrupo = v.idgrupo
        AND p.idsocio = v.idsocio
        WHERE rp.idproductor BETWEEN 30000 AND 39999
        AND rp.tiporeferencia in (2,3)
        AND p.estatus = 't'
        GROUP BY p.idorigen,p.idgrupo,p.idsocio,
            rp.idorigenp,rp.idproducto, rp.idauxiliar,rp.tiporeferencia,
            rp.idorigenpr,rp.idproductor,rp.idauxiliarr,rp.referencia
        order by  p.idorigen,p.idgrupo,p.idsocio
        ;
