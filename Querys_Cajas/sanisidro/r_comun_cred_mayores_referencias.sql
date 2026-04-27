SELECT
trim(to_char(per.idorigen,'099999'))||'-'||per.idgrupo||'-'||
trim(to_char(per.idsocio,'099999')) as "Numero de socio", 
nombre_x(per.nombre,per.appaterno,per.apmaterno) as "Nombre socio",
pr.nombre AS "Tipo Producto", 
TRIM(to_char(a.idorigenp,'099999'))||'-'||TRIM(to_char(a.idproducto,'09999'))||'-'||
TRIM(to_char(a.idauxiliar,'09999999')) AS "Credito Otorgado",
a.montoprestado  AS "Saldo Otorgado",
a.saldo AS "Saldo Actual",
a.garantia AS "Garantia de Prestamo",
(select COALESCE(saldo,0) from auxiliares  where idproducto=101 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1)as "Saldo 101",
(select COALESCE(saldo,0) from auxiliares where idproducto=110 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1) as "Saldo 110",
(select coalesce(SUM(saldo),0) from auxiliares where idproducto in (select idproducto from productos where tipoproducto =2) and estatus =2 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio)as "Saldo prestamos",
cm.descripcion as "Ocupacion del socio",
(case when ref.tiporeferencia = 1 then 'Conyuge' 
      when ref.tiporeferencia = 24 then 'Madre'
      when ref.tiporeferencia = 25 then 'Padre'
      when ref.tiporeferencia = 7 then 'Hijo(a)'
      when ref.tiporeferencia = 39 then 'Concubina'
end) as "Referencia",
trim(to_char(ref.idorigenr,'099999'))||'-'||ref.idgrupor||'-'||
trim(to_char(ref.idsocior,'099999')) as "Numero de socio referencia",
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=ref.idorigenr and idgrupo =ref.idgrupor and idsocio = ref.idsocior) as "Nombre referencia",
(select cm1.descripcion 
from trabajo as tra1 
inner join catalogo_menus cm1 on cm1.menu = 'tipo_ocupacion'  and cm1.opcion=tra1.tipo_ocupacion and (tra1.idorigen,tra1.idgrupo,tra1.idsocio) = (ref.idorigenr,ref.idgrupor,ref.idsocior) order by fechaingreso desc limit 1)
as "ocupacion referencia"
FROM personas as per
INNER JOIN auxiliares a
ON  per.idorigen = a.idorigen
AND per.idgrupo = a.idgrupo
AND per.idsocio = a.idsocio
INNER JOIN productos pr 
ON a.idorigenp = pr.idorigen
AND a.idproducto = pr.idproducto
INNER JOIN referencias as ref
ON  per.idorigen = ref.idorigen
AND per.idgrupo = ref.idgrupo
AND per.idsocio = ref.idsocio 
INNER JOIN trabajo as tra
ON  per.idorigen = tra.idorigen
AND per.idgrupo = tra.idgrupo
AND per.idsocio = tra.idsocio 
INNER JOIN catalogo_menus cm  on cm.menu ='tipo_ocupacion' and cm.opcion=tra.tipo_ocupacion
WHERE ref.tiporeferencia in (24,25,7,39,1)
AND a.estatus = 2
AND pr.tipoproducto = 2
AND per.idorigen = 031001
AND per.idgrupo  =10
AND per.idsocio  = 005160

ORDER BY 
per.idorigen,per.idgrupo,per.idsocio;