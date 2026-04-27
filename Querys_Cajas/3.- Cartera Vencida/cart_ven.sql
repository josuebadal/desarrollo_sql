/*
Solicitando de su apoyo con la modificación al query 289 “Cartera total” de nuestro módulo de ejecución de querys, en el cual se requiere agregar el campo de saldo por producto.
QUERY ORIGINAL:

select idorigenp as "Sucursal", '$ '||trim(to_char(sum(saldo), '999,999,999.99')) as "Cartera" from carteravencida group by idorigenp order by idorigenp
*/
select 
    cv.idorigenp AS "Sucursal",
    cv.idproducto AS "Producto" ,
    trim(to_char(sum(saldo), '999,999,999.99')) as "Cartera",
    '' as "Suma"
from carteravencida cv
group by cv.idorigenp, cv.idproducto

UNION ALL

select
    cv.idorigenp AS "Sucursal",
    0 AS "Producto" ,
    '0' as "Cartera",
    trim(to_char(sum(saldo), '999,999,999.99')) as "Suma" 
from carteravencida cv
group by cv.idorigenp
ORDER BY "Sucursal", "Producto" 
;

