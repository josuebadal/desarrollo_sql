SELECT * FROM csi_rentabilidad_por_sucursal(@@Periodo|e|202312@@,@@Sucursal|e|031001@@);
 
*SELECT * FROM csi_rentabilidad_por_sucursal(202206,031001);
 
* SELECT *, total_ingresos - total_gastos AS resultado
from   (select   o.idorigen AS sucursal, o.nombre,
                 (select count(*)
                  from   auxiliares
                  where  idorigen = o.idorigen and idproducto = 101 and saldo = 1000) AS socios,                                                               
                 (select count(*)
                  from   auxiliares
                  where  idorigenp = o.idorigen and estatus = 2 and saldo > 0 and
                         idproducto in (SELECT idproducto FROM productos WHERE cuentaaplica LIKE '201%%')) AS folios_captacion,
                 (select sum(saldo)
                  from   auxiliares
                  where  idorigenp = o.idorigen and estatus = 2 and saldo > 0 and
                         idproducto in (SELECT idproducto FROM productos WHERE cuentaaplica LIKE '201%%')) AS saldo_captacion,
                 (select count(*)
                  from   auxiliares
                  where  idorigenp = o.idorigen and idproducto between 30000 and 39999 and estatus = 2) AS folios_cartera,
                 (select sum(saldo + idnc + idncm)
                  from   auxiliares
                  where  idorigenp = o.idorigen and idproducto between 30000 and 39999 and estatus = 2) AS saldo_cartera,
                  ROUND
                 ((select sum(saldo + idnc + idncm)
                  from   auxiliares
                  where  idorigen = o.idorigen and idproducto between 30000 and 39999 and estatus = 2 and cartera = 'V') /
                 (select sum(saldo + idnc + idncm)
                  from   auxiliares
                  where  idorigen = o.idorigen and idproducto between 30000 and 39999 and estatus = 2) * 100,2) AS indice_mora,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta =  '401')::numeric AS ingresos_intereses,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta =  '501')::numeric AS gastos_intereses,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta =  '404')::numeric AS ingresos_res_intermediacion,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta IN ('402','403','405','406','407') )::numeric AS ingresos_otros,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta =  '502')::numeric AS gastos_eprc,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta =  '505')::numeric AS gastos_administracion,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta IN ('503','504') )::numeric AS gastos_otros,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta LIKE '4%%')::numeric AS total_ingresos,
                 (select sum(final)
                  from   x_balanza
                  where  idorigenc = o.idorigen AND cuenta LIKE '5%%')::numeric AS total_gastos
        from     origenes AS o
        where    o.matriz != 0
        group by o.idorigen,o.nombre) AS rent
order by sucursal;