SELECT p.idorigen||'-'||p.idgrupo||'-'||p.idsocio as "ogs",
nombre_x(p.appaterno,p.apmaterno,p.nombre) as "nombre",
tr.ing_mensual_neto as "ing_m_neto", 
ad.idorigenp||'-'||ad.idproducto||'-'||ad.idauxiliar as "opa",
(CASE 
        when ad.cargoabono = 1 THEN 'abono' ELSE 'cargo' 
END ) as "cargoabono", ad.periodo,
ad.monto, ad.montoio, ad.montoim, ad.montoiva,ad.montoivaim, ad.fecha 
FROM v_auxiliares_d ad
INNER JOIN v_auxiliares a ON a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
INNER JOIN personas p ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
LEFT JOIN trabajo tr ON p.idorigen = tr.idorigen AND tr.idgrupo = p.idgrupo AND tr.idsocio = p.idsocio
INNER JOIN productos pr ON a.idproducto = pr.idproducto
WHERE ad.cargoabono = 1 AND ad.idtipo = 1 AND ad.tipomov = 0 AND p.estatus = 't' AND p.idgrupo = 10 AND pr.tipoproducto IN (0,2,8,1)
and ad.periodo BETWEEN @@Periodo ini:|c|202502@@ AND @@Periodo fin:|c|202502@@
ORDER BY p.idorigen,p.idgrupo,p.idsocio;