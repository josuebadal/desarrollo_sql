SELECT distinct on (per.idorigen,per.idgrupo,per.idsocio,ref.idorigenr,ref.idgrupor,ref.idsocior)
trim(to_char(per.idorigen,'099999'))||'-'||per.idgrupo||'-'||
trim(to_char(per.idsocio,'099999')) as "Numero de socio", 
nombre_x(per.nombre,per.appaterno,per.apmaterno) as "Nombre socio", 
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
INNER JOIN referencias as ref using (idorigen,idgrupo,idsocio)
INNER JOIN trabajo as tra using (idorigen,idgrupo,idsocio)
INNER JOIN catalogo_menus cm  on cm.menu ='tipo_ocupacion' and cm.opcion=tra.tipo_ocupacion
WHERE ref.tiporeferencia in (24,25,7,39,1) ;