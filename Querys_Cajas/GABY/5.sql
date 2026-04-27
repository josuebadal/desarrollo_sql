SELECT distinct on (per.idorigen,per.idgrupo,per.idsocio,ref.idorigenr,ref.idgrupor,ref.idsocior)
per.idorigen,per.idgrupo,per.idsocio, 
nombre_x(per.nombre,per.appaterno,per.apmaterno), 
(case when ref.tiporeferencia = 1 then 'Conyuge' 
      when ref.tiporeferencia = 24 then 'Madre'
      when ref.tiporeferencia = 25 then 'Padre'
      when ref.tiporeferencia = 7 then 'Hijo(a)'
      when ref.tiporeferencia = 39 then 'Concubina'
end) as referencia,	
ref.idorigenr,ref.idgrupor,ref.idsocior,
(select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=ref.idorigenr and idgrupo =ref.idgrupor and idsocio = ref.idsocior) as nombre_referencia,
(select COALESCE(saldo,0) from auxiliares  where idproducto=101 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1)as saldo_101,
(select COALESCE(saldo,0) from auxiliares where idproducto=110 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio order by fechaumi desc limit 1) as saldo_110,
(select coalesce(SUM(saldo),0) from auxiliares where idproducto in (select idproducto from productos where tipoproducto =2) and estatus =2 and idorigen=per.idorigen and idgrupo =per.idgrupo and idsocio = per.idsocio)as saldo_prestamos
FROM personas as per 
INNER JOIN referencias as ref using (idorigen,idgrupo,idsocio)
WHERE ref.tiporeferencia in (24,25,7,39,1);