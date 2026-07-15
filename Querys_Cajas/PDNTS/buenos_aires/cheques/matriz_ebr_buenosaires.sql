SELECT p.appaterno||'-'||p.apmaterno||'-'||p.nombre as socio, 
(case when p.estatus = true then 'activo' else 'inactivo' end) as estatus,
(case when p.nivel_riesgo = 1 then 'bajo' else 'alto' end)     as nries,
a.idorigen||'-'||a.idgrupo||'-'||a.idsocio AS ogs,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar AS opa,
(case   when ad.idtipo = 1 then 'ventanilla'
        when ad.idtipo = 2 then 'cheque'
        when ad.idtipo = 3 then 'traspaso'
        else 'ND' end) as tipo,
(case   when ad.tipomov = 0 then 'cargos-abonos'
        when ad.tipomov = 1 then 'castigos'
        when ad.tipomov = 2 then 'quita'
        when ad.tipomov = 3 then 'condonacion'
        when ad.tipomov = 4 then 'bonificacion'
        when ad.tipomov = 5 then 'descuento'
        when ad.tipomov = 6 then 'ajuste'
        else 'ND' end ) as tipomov,
pr.nombre as producto,ad.fecha, ad.monto, ad.montoio, ad.montoim, ad.montoiva,
(case 
        when ad.cargoabono = 0 then 'cargo'
        else 'abono' end ) as cargoabono,
'creditos' as tipoprod,
ad.idorigenc||'-'||ad.periodo||'-'||ad.idtipo||'-'||ad.idpoliza as poliza
FROM v_auxiliares AS a
INNER JOIN personas AS p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr 
ON a.idproducto = pr.idproducto
INNER JOIN v_auxiliares_d AS ad
ON  a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
WHERE a.idproducto BETWEEN 30000 AND 39999
AND ad.fecha BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'

UNION ALL

SELECT p.appaterno||'-'||p.apmaterno||'-'||p.nombre as socio, 
(case when p.estatus = true then 'activo' else 'inactivo' end) as estatus,
(case when p.nivel_riesgo = 1 then 'bajo' else 'alto' end)     as nries,
a.idorigen||'-'||a.idgrupo||'-'||a.idsocio AS ogs,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar AS opa,
(case   when ad.idtipo = 1 then 'ventanilla'
        when ad.idtipo = 2 then 'cheque'
        when ad.idtipo = 3 then 'traspaso'
        else 'ND' end) as tipo,
(case   when ad.tipomov = 0 then 'cargos-abonos'
        when ad.tipomov = 1 then 'castigos'
        when ad.tipomov = 2 then 'quita'
        when ad.tipomov = 3 then 'condonacion'
        when ad.tipomov = 4 then 'bonificacion'
        when ad.tipomov = 5 then 'descuento'
        when ad.tipomov = 6 then 'ajuste'
        else 'ND' end ) as tipomov,
pr.nombre as producto,ad.fecha, ad.monto, ad.montoio, ad.montoim, ad.montoiva,
(case 
        when ad.cargoabono = 1 then 'cargo'
        else 'abono' end ) as cargoabono,
'AHORRO' as tipoprod,
ad.idorigenc||'-'||ad.periodo||'-'||ad.idtipo||'-'||ad.idpoliza as poliza
FROM v_auxiliares AS a
INNER JOIN personas AS p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr 
ON a.idproducto = pr.idproducto
INNER JOIN v_auxiliares_d AS ad
ON  a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
WHERE pr.cuentaaplica like '201%' 
AND ad.fecha BETWEEN '2025-07-01 00:00:00' AND '2026-06-30 23:59:59'
;