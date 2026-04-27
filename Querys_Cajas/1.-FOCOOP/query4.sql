Query 4

b.Numero de personas que laboran (usuarios activos asignados al origen o sucursal)
SELECT o.nombre,'|' AS "|", o.idorigen, COUNT(u.idusuario) AS "usuarios",

c.Numero de socios que se atienden al mes,
(SELECT (COUNT(p.idsocio)/12)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN auxiliares_d ad
            ON a.idorigenp = ad.idorigenp
            AND a.idproducto = ad.idproducto
            AND a.idauxiliar = ad.idauxiliar
    WHERE  ad.fecha::date BETWEEN '31/08/2024' AND '31/08/2025'
        AND ad.monto  > 0 AND a.idorigenp = o.idorigen) AS "socios_mes", 

d.    Numero de cuentas de captacion adscritas, (suma del numero de cuentas con saldo de lo socios, productos a considerar 110,111,113,114,115, 128, 129, 130, 131,140,200,201)
--Cuenta todos los movimientos que tuvo el socio en almenos un producto
(SELECT COUNT(a.idauxiliar) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        --INNER JOIN productos pr 
            --ON a.idproducto = pr.idproducto
    WHERE a.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201)
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025' 
            AND a.idorigenp = o.idorigen
            --AND a.saldo > 0
            AND p.estatus = 't') AS "num_cuentas_captacion_adscritas",


e.     Numero de contratos de credito adscritos, (suma del numero de cuentas con saldo de lo socios, productos a considerar los que empiezan con 3 o tipo credito)
(SELECT COUNT(a.idauxiliar)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.saldo >0
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "num__contratos_creditos_adscritos",



f.      Monto de la captacion, (suma del saldo de cuentas de los socios, productos a considerar 110,111,113,114,115, 128, 129, 130, 131,140,200,201)
(SELECT SUM(a.saldo) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
        INNER JOIN origenes o 
        ON a.idorigenp = o.idorigen
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen) AS "monto_captacion"


g.    Promedio mensual de nuevos socios afiliados en los ultimos 12meses, (numero de socios inscritos con capital social, producto 100, de agosto 2024 a agosto 2025. Se debe considerar que abonaron 1000 al producto 100; el numero de socios dividirlo entre 12)
(SELECT (COUNT(p.idsocio)/12) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto = 100 AND a.saldo >= 1000
        AND p.fechaingreso::date BETWEEN '31/08/2024' AND '31/08/2025'
        AND a.idorigenp = o.idorigen) AS "socios_afiliados_mes"


h.    Promedio mensual de nuevos contratos de captacion tradicional generados en los ultimos 12 meses, (numero de opas de ahorros de los productos mencionados en el inciso d,  de agosto 2024 a agosto 2025. El numero de opas dividirlo entre 12)
(SELECT (COUNT(a.idauxiliar)/12) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201)
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025' 
            AND a.idorigenp = o.idorigen
            AND p.estatus = 't') AS "promedio_captacion_adscritas"

i.      Promedio mensual de nuevos contratos de credito generados en los ultimos 12 meses,  (numero de opas de creditos de los productos mencionados en el inciso d,  de agosto 2024 a agosto 2025. El numero de opas dividirlo entre 12) --Los de credito estan en el inciso E

(SELECT (COUNT(a.idauxiliar)/12)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "promedio_contratos_creditos_adscritos",

j.       Saldo promedio mensual de captacion tradicional administrada en los ultimos 12 meses.
(SELECT (SUM(a.saldo)/12) 
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
        INNER JOIN origenes o 
        ON a.idorigenp = o.idorigen
    WHERE pr.idproducto in (110,111,113,114,115, 128, 129, 130, 131,140,200,201) 
            AND a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND a.idorigenp = o.idorigen) AS "promedio_monto_captacion"

k.     Saldo promedio mensual de cartera de credito administrada en los ultimos 12 meses.
(SELECT (SUM(a.saldo)/12)
    FROM auxiliares a
        INNER JOIN personas p 
            ON a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
        INNER JOIN productos pr 
            ON a.idproducto = pr.idproducto
    WHERE  a.fechaape::date BETWEEN '31/08/2024' AND '31/08/2025'
            AND pr.tipoproducto = 2
            AND a.idorigenp = o.idorigen
            ) AS "promedio_contratos_creditos",




SELECT o.nombre,'|' AS "|", o.idorigen, '|' AS "|", COUNT(u.idusuario) 
    FROM origenes o
        INNER JOIN usuarios u
        ON o.idorigen = u.idorigen
    WHERE o.estatus = 't'
        AND u.activo = 't'
    GROUP BY o.nombre,o.idorigen ;

@@Fecha Inicial:|f|01/12/2024@@ AS "fecha_ini", 
@@Fecha Final:|f|31/03/2025@@ AS "fecha_fin",
