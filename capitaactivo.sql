---------------------SE BUSCABA VACIO ACT_ECO VACIO NO ERA ESE DATO------------------------
/*
select DISTINCT(a.idorigen, a.idgrupo, a.idsocio) as ogs, nombre_x(p.apmaterno,p.appaterno, p.nombre) as nombresocio,
tr.actividad_economica, tr.actividad_economica_pld
from v_auxiliares as a
INNER JOIN personas as p
ON a.idorigen = p.idorigen and a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr ON a.idproducto = pr.idproducto
LEFT JOIN trabajo as tr on tr.idorigen = p.idorigen AND tr.idgrupo = p.idgrupo AND tr.idsocio = p.idsocio
where pr.tipoproducto IN (0,1,8) AND a.estatus = 2 and a.saldo > 0
AND pr.cuentaaplica like '201%' AND tr.actividad_economica IS NULL
ORDER BY ogs
;
*/

-------------SE DEBEN CUMPLIR CON ESAS CONDICIONES PERO SIN ACT_ECO_PLD------------------
select DISTINCT(a.idorigen, a.idgrupo, a.idsocio) as ogs, nombre_x(p.apmaterno,p.appaterno, p.nombre) as nombresocio,
tr.actividad_economica_pld
from v_auxiliares as a
INNER JOIN personas as p 
ON a.idorigen = p.idorigen and a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
INNER JOIN productos as pr ON a.idproducto = pr.idproducto
LEFT JOIN trabajo as tr on tr.idorigen = p.idorigen AND tr.idgrupo = p.idgrupo AND tr.idsocio = p.idsocio 
where pr.tipoproducto IN (0,1,8) AND a.estatus = 2 and a.saldo > 0
AND pr.cuentaaplica like '201%'  
AND (tr.actividad_economica_pld IS NULL OR tr.actividad_economica_pld = '')
ORDER BY ogs
; 



