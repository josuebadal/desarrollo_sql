/* SOCIOS QUE TENGAN MAS DE UN LAPSO DE TIEMPO SIN MOV, EXCLUYENDO AL 999 EN EL 110
Con las partes sociales completas 2000
--O-G-S, 
--Nombre completo, 
--OPA,
--FECHA UMA,
--teléfono principal, 
--teléfono celular, 
dirección completa
correo electrónico.

socios_que_no_tienen_movs_ahorros
socios_sin_movimientos
socios_sin_movimientos_2  */


select a.idorigen,a.idgrupo,a.idsocio, nombre_x(p.appaterno,p.apmaterno, p.nombre) as nombre, a.idorigenp, a.idproducto, a.idauxiliar, a.saldo, a.fechauma
, coalesce(p.telefono,'0000000000') as telefono, coalesce(p.celular,'0000000000') as celular, coalesce(p.calle,'ND') as calle, coalesce(p.numeroext,'ND') as numeroext, coalesce(p.numeroint,'ND') as numeroint, p.email   
from v_auxiliares as a
inner join personas as p ON a.idorigen = p.idorigen AND a.idgrupo  = p.idgrupo AND a.idsocio  = p.idsocio
INNER JOIN v_auxiliares a1
    ON a1.idorigen = a.idorigen AND a1.idgrupo  = a.idgrupo AND a1.idsocio  = a.idsocio AND a1.idproducto = 101 AND a1.saldo >= 2000
AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
--INNER JOIN v_auxiliares_d as ad ON a.idorigenp =  
where a.idproducto = 110
;

