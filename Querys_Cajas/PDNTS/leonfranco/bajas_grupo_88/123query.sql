select 
cv.idorigen||'-'||cv.idgrupo||'-'||cv.idsocio as "Socio", '|' as "|",
 trim(nombre_x(ps.nombre, ps.appaterno,ps.apmaterno)) as "Nombre",'|' as "|",
cv.idorigenp||'-'||cv.idproducto||'-'||cv.idauxiliar as "Prestamo",'|' as "|",
pr.nombre as "Producto",'|' as "|",
cv.fechaprestamo as "Fecha Prestamo",'|' as "|",
(select vence from amortizaciones where idorigenp = cv.idorigenp and idproducto = cv.idproducto and idauxiliar = cv.idauxiliar 
order by vence desc limit 1) as "Fecha Vencimiento",'|' as "|",
cv.montoprestado as "Monto Prestamo",'|' as "|",
cv.saldo as "Saldo Actual",'|' as "|",
cv.montovencido as "Monto Vencido",'|' as "|",
round((cv.io) / 1.16::numeric,2)   as "Interes Ordinario",'|' as "|",
round((cv.io)-(cv.io/1.16)::numeric,2) as "IVA Int. Ord1",'|' as "|", 
round((cv.im) / 1.16::numeric,2)   as "Interes Moratorio",'|' as "|",
round((cv.im)-(cv.im/1.16)::numeric,2) as "IVA Int. Mor1",'|' as "|", 
cv.montovencido + cv.io + cv.im as "Monto V + Int + IVA",'|' as "|",
cv.diasvencidos as "Dias Vencidos",'|' as "|",
case cv.cartera
when 'M' then 'Morosa'
when 'C' then 'Corriente'
when 'V' then 'Vencida'
end as "Estatus Catrera",'|' as "|",
ps.calle|| ' No '||ps.numeroext as "Domicilio",'|' as "|",
cl.nombre as "Colonia",'|' as "|",
ps.entrecalles as "Entre Calles",'|' as "|",
mn.nombre as "Municipio",'|' as "|",
ed.nombre as "Estado",'|' as "|",
ps.telefono as "Telefono 1",'|' as "|",
ps.telefonorecados as "Telefono 2",'|' as "|",
ps.celular as "Celular",'|' as "|",
av1.idorigenr||'-'||av1.idgrupor||'-'||av1.idsocior as "No Aval 1",'|' as "|",
av1.nomav as "Nombre Aval 1",'|' as "|",
av1.domav as "Domicilio Aval 1",'|' as "|",
av1.colav as "Colonia del Aval 1",'|' as "|",
av1.betcall as "Entre Calles Aval 1",'|' as "|",
av1.munava as "Municipio Aval 1",'|' as "|",
av1.edoava as "Estado Aval 1",'|' as "|",
av1.telava as "Telefono Aval 1",'|' as "|",
av2.idorigenr||'-'||av2.idgrupor||'-'||av2.idsocior as "No Aval 2",'|' as "|",
av2.nomav as "Nombre Aval 2",'|' as "|",
av2.domav as "Domicilio Aval 2",'|' as "|",
av2.colav as "Colonia del Aval 2",'|' as "|",
av2.betcall as "Entre Calles Aval 2",'|' as "|",
av2.munava as "Municipio Aval 2",'|' as "|",
av2.edoava as "Estado Aval 2",'|' as "|",
av2.telava as "Telefono Aval 2"
from carteravencida as cv
inner join personas as ps
on cv.idorigen = ps.idorigen and
    cv.idgrupo = ps.idgrupo and
	cv.idsocio = ps.idsocio 
inner join productos as pr
on cv.idproducto = pr.idproducto
inner join colonias as cl
on ps.idcolonia = cl.idcolonia
inner join municipios as mn
on cl.idmunicipio = mn.idmunicipio
inner join estados as ed
on mn.idestado = ed.idestado

left join  
  (
	  select  
	  rf.idorigen,rf.idgrupo,rf.idsocio,
	  rf.idorigenr,rf.idgrupor,rf.idsocior,
	  to_number(coalesce(sai_token(2,referencia ,'|')),'999999') as idorigenp,
	  to_number(coalesce(sai_token(3,referencia ,'|')),'99999') as idproducto,
	  to_number(coalesce(sai_token(4,referencia ,'|')),'999999999') as idauxiliar,
	  trim(nombre_x(px1.nombre, px1.appaterno,px1.apmaterno)) as nomav,
	  px1.calle|| ' No '||px1.numeroext as domav,
	  cla.nombre as colav,
	  px1.entrecalles betcall,
	  mnav.nombre as munava,
	  edav.nombre as edoava,
      px1.telefono as telava
    from referencias as rf
    inner join personas as px1
    on rf.idorigenr = px1.idorigen and
	rf.idgrupor = px1.idgrupo and
	rf.idsocior = px1.idsocio
	
    inner join colonias as cla
    on px1.idcolonia = cla.idcolonia
	  
    inner join municipios as mnav
    on cla.idmunicipio = mnav.idmunicipio

    inner join estados as edav
    on mnav.idestado = edav.idestado 

  where 
 to_number(coalesce(sai_token(1,referencia ,'|')),'99')=1 and
 tiporeferencia = 8 
  ) as AV1
  on cv.idorigen =av1.idorigen and
     cv.idgrupo = av1.idgrupo and
	 cv.idsocio = av1.idsocio and
	 cv.idorigenp=av1.idorigenp and
	 cv.idproducto= av1.idproducto and
	 cv.idauxiliar = av1.idauxiliar
 -------
  left join
  (
	  select  
	  rf.idorigen,rf.idgrupo,rf.idsocio,
	  rf.idorigenr,rf.idgrupor,rf.idsocior,
	  to_number(coalesce(sai_token(2,referencia ,'|')),'999999') as idorigenp,
	  to_number(coalesce(sai_token(3,referencia ,'|')),'99999') as idproducto,
	  to_number(coalesce(sai_token(4,referencia ,'|')),'999999999') as idauxiliar,
	  trim(nombre_x(px1.nombre, px1.appaterno,px1.apmaterno)) as nomav,
	  px1.calle|| ' No '||px1.numeroext as domav,
	  cla.nombre as colav,
	  px1.entrecalles betcall,
	  mnav.nombre as munava,
	  edav.nombre as edoava,
      px1.telefono as telava
  from referencias as rf
    inner join personas as px1
    on rf.idorigenr = px1.idorigen and
	rf.idgrupor = px1.idgrupo and
	rf.idsocior = px1.idsocio
    inner join colonias as cla
    on px1.idcolonia = cla.idcolonia
    inner join municipios as mnav
    on cla.idmunicipio = mnav.idmunicipio

    inner join estados as edav
    on mnav.idestado = edav.idestado  
  where 
to_number(coalesce(sai_token(1,referencia ,'|')),'99')=2 and
 tiporeferencia = 8 
  ) as AV2
 
 
  on cv.idorigen =av2.idorigen and
     cv.idgrupo = av2.idgrupo and
	 cv.idsocio = av2.idsocio and
	 cv.idorigenp=av2.idorigenp and
	 cv.idproducto= av2.idproducto and
	 cv.idauxiliar = av2.idauxiliar
