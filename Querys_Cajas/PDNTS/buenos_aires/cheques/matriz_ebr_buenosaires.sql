SELECT p.appaterno||'-'||p.apmaterno||'-'||p.nombre as socio,
a.idorigen||'-'||a.idgrupo||'-'||a.idsocio AS ogs,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar AS opa,
pr.nombre as producto,ad.fecha, --ad.cargoabono,
ad.idorigenc||'-'||ad.periodo||'-'||ad.idtipo||'-'||ad.idpoliza as poliza
FROM v_auxiliares AS a
INNER JOIN personas AS p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr 
ON a.idproducto = pr.idproducto
INNER JOIN v_auxiliares_d AS ad
ON  a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
WHERE a.estatus = 2
AND a.idproducto BETWEEN 30000 AND 39999 AND ad.tipomov = 0 AND ad.cargoabono = 1 AND ad.idtipo = 2
ORDER BY ad.fecha DESC;

UNION 

SELECT p.appaterno||'-'||p.apmaterno||'-'||p.nombre as socio,
a.idorigen||'-'||a.idgrupo||'-'||a.idsocio AS ogs,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar AS opa,
pr.nombre as producto,ad.fecha, --ad.cargoabono,
ad.idorigenc||'-'||ad.periodo||'-'||ad.idtipo||'-'||ad.idpoliza as poliza
FROM v_auxiliares AS a
INNER JOIN personas AS p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr 
ON a.idproducto = pr.idproducto
INNER JOIN v_auxiliares_d AS ad
ON  a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
WHERE a.estatus = 2
AND pr.cuentaaplica like '201%' 
AND ad.tipomov = 0 
AND ad.cargoabono = 0 
AND ad.idtipo = 2
ORDER BY ad.fecha DESC;