select pr.cuentaaplica as cuenta_contable,p.idorigen, p.idgrupo, p.idsocio, nombre_x(p.appaterno, p.apmaterno, p.nombre) as nombre_socio,
p.fechaingreso,pr.nombre as producto, a.saldo, ad.idorigenp,ad.idproducto,ad.idauxiliar, 
MAX(CASE WHEN ad.cargoabono = 1 THEN ad.fecha::date END) AS fecha_ult_deposito,
MAX(CASE WHEN ad.cargoabono = 0 THEN ad.fecha::date END) AS fecha_ult_retiro
from v_auxiliares_d as ad
INNER JOIN v_auxiliares as a ON ad.idorigenp = a.idorigenp AND ad.idproducto = a.idproducto AND ad.idauxiliar = a.idauxiliar
INNER JOIN personas as p ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr ON a.idproducto = pr.idproducto
WHERE a.estatus = 2 and p.idgrupo = 10 and pr.tipoproducto in (0,1,8)
GROUP BY cuenta_contable,p.idorigen, p.idgrupo, p.idsocio,nombre_socio,p.fechaingreso,producto, a.saldo, 
ad.idorigenp,ad.idproducto,ad.idauxiliar
ORDER BY p.idorigen, p.idgrupo, p.idsocio;


/*QUERY PARA LA CNBV PARA CAJA CERRO DE LA SILLA Debera contener los siguietnes datos:
--cuenta contable
--numero de socio
--nombre
--fecha de ingreso a la sociedad
--tipo de producto
--fecha ult deposito
fecha ult retiro
saldo insoluto de la cuenta

*/

---------------------ABONOS