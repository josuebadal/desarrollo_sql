--SE ENVIO EL CORREO EL 27 DE ENERO
--ASUNTO:reportes para CNBV punto 83 cerro
/*OGS
**NOMBRE
**OPA
**TIPO DE CREDITO
**FECHA DE DISPOSICION	DD-MM-AAAA
HORA 
FECHA DE VENCIMIENTO
MONTO OTORGADO
FECHA LIQUIDACION
HORA LIQUIDACION*/
 
SELECT a.idorigen||'-'|| a.idgrupo ||'-'|| a.idsocio as "ogs", 
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "nombre",
a.idorigenp||'-'|| a.idproducto||'-'|| a.idauxiliar as "opa", 
pr.nombre, 
TO_CHAR(MIN(ad.fecha), 'DD-MM-YYYY') as "fecha_disposicion",
TO_CHAR(MIN(ad.fecha), 'HH24:MI:SS') as "hora_disposicion",
MAX(am.vence) as "fecha_vence", 
a.montoprestado as "monto_otorgado",
a.fechauma as "fecha_liquidacion",
TO_CHAR(MAX(ad.fecha), 'HH24:MI:SS')  as "hora_liquidacion"
FROM auxiliares as a
INNER JOIN personas as p ON  a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
LEFT JOIN productos as pr ON a.idproducto = pr.idproducto
LEFT JOIN amortizaciones as am ON  a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar
LEFT JOIN v_auxiliares_d as ad ON  a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto AND a.idauxiliar = ad.idauxiliar
WHERE a.idproducto between 30000 and 39999 and a.estatus = 3
and a.fechauma between '01/01/2024' and '30/11/2025'
GROUP BY a.idorigen,a.idgrupo,a.idsocio,p.appaterno,p.apmaterno,p.nombre,a.idorigenp,a.idproducto,a.idauxiliar,
a.fechaactivacion,pr.nombre,a.fechaape,a.montoprestado, a.fechauma
ORDER BY a.idorigen, a.idgrupo, a.idsocio
;