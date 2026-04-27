select * 
from carteravencida 
where 
(idorigenp,idproducto,idauxiliar)
= 
(010401,30805,00722777);

select * 
from carteravencida
where
(idorigenp,idproducto,idauxiliar)
=
(10401,30705,722553);

saldo              | 346.25
io                 | 0.00
idnc               | 4.06
ieco               | 0.00
im                 | 0.00
iva                | 0.00


/*
ESTE ES EL MODULO DE HISTORIAL DONDE LLEVAN SU COBRANZA
*/

Message: valida_ogs_socio
DEBUG_DB: Query:
   SELECT idgrupo FROM grupos WHERE idgrupo=10
DEBUG_DB: Query:
   SELECT appaterno,apmaterno,personas.nombre,calle,estatus,numeroext,numeroint,colonias.nombre as colonia,colonias.codigopostal,entrecalles,municipios.nombre as municipio,estados.nombre as estado,razon_social,categoria, nivel_riesgo, fechanacimiento, int4(extract(year from age(fechanacimiento))) as edad, email,celular,telefono,telefonorecados,curp,rfc FROM   personas, colonias, municipios, estados WHERE  idorigen=10401 AND idgrupo=10 AND idsocio=116306 AND colonias.idcolonia=personas.idcolonia AND municipios.idmunicipio=colonias.idmunicipio AND estados.idestado=municipios.idestado
DEBUG_DB: Function:
   select sai_obliga_exista_datos_personales (10401,10,116306)
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'aviso_cumplimiento_edad' limit  1
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'listas_personas_bloq_forzoso' and case when dato1 is not NULL and dato1 = '1' then 1 else 0 end = 1
DEBUG_DB: Query:
   select s.*, p.nombre, p.appaterno, p.apmaterno, p.fechanacimiento, p.rfc, p.curp from   sopar as s inner join personas as p using(idorigen,idgrupo,idsocio) where  s.tipo = 'lista_personas_bloqueadas_cnbv' and (p.nombre,p.appaterno,p.apmaterno) = ('JOSE ARMANDO','MARTINEZ','SANCHEZ') limit  1
DEBUG_DB: Query:
   select case when dato1 is NULL or dato1 = '' then '0' else dato1 end as dato1, case when dato2 is NULL or dato2 = '' then '0' else dato2 end as dato2, case when dato3 is NULL or dato3 = '' then '0' else dato3 end as dato3, case when dato4 is NULL or dato4 = '' then '0' else dato4 end as dato4 from   tablas where  idtabla = 'param' and idelemento = 'verificacion_datos_personales' 
DEBUG_DB: Query:
   select    case when date('30/09/2025') >= (date(fecha) + 365) then 1 else 0 end as actualizar_ya,date('30/09/2025') - date(fecha) as dias_desde from      verificacion_datos_personales where     idorigen = 10401 and idgrupo = 10 and idsocio = 116306 order by  fecha desc limit     1
Message: valida_ogs_no_ahorro
Message: valida_ogs_cheque_rebotado
Message: valida_socios_avalados
Message: valida_ogs_avisos...
Message: valida_ogs_vencidos...
Message: recuperacion_provision_eprc...
DEBUG_DB: Query:
   select sai_findstr(dato1,'|') as xd1,sai_findstr(dato2,'|') as xd2,sai_findstr(dato3,'|') as xd3,dato1,dato2,dato3 from tablas where idtabla='param' and idelemento='recuperacion_eprc'
DEBUG_DB: Query:
   select idproducto,nombre from productos as p where ((p.idproducto = 60001 and p.tipoproducto = 4) or (p.idproducto = 70001 and p.tipoproducto = 5) or (p.idproducto = 601 and p.tipoproducto = 3)) order by tipoproducto
DEBUG_DB: Query:
   select saldo from auxiliares as a where (a.idproducto = 60001 or a.idproducto = 70001) and a.idorigen = 10401 and a.idgrupo = 10 and a.idsocio = 116306 and a.estatus = 2 
DEBUG_DB: Query:
   select idproducto,nombre from productos as p where ((p.idproducto = 60002 and p.tipoproducto = 4) or (p.idproducto = 70002 and p.tipoproducto = 5) or (p.idproducto = 602 and p.tipoproducto = 3)) order by tipoproducto
DEBUG_DB: Query:
   select saldo from auxiliares as a where (a.idproducto = 60002 or a.idproducto = 70002) and a.idorigen = 10401 and a.idgrupo = 10 and a.idsocio = 116306 and a.estatus = 2 
DEBUG_DB: Query:
   select idproducto,nombre from productos as p where ((p.idproducto = 60003 and p.tipoproducto = 4) or (p.idproducto = 70003 and p.tipoproducto = 5) or (p.idproducto = 603 and p.tipoproducto = 3)) order by tipoproducto
DEBUG_DB: Query:
   select saldo from auxiliares as a where (a.idproducto = 60003 or a.idproducto = 70003) and a.idorigen = 10401 and a.idgrupo = 10 and a.idsocio = 116306 and a.estatus = 2 
Message: Resultado de SELECT sai_auxiliar(10401,32809,893,NULL,'30/09/2025',0,FALSE,10450): 2|30/09/2025|0.00|0|0.00|0|4.25|0.00|15/01/2026|0.00|15/10/2025|249.84|0.00|C|0|0|27/12/2025|0.68|0|0.00|0.00|0.00|0|0|f|f
Message: vencidos_termina...
Message: valida_ogs_saldos...
Message: saldos_termina...
DEBUG_DB: Query:
   select h.oid, h.*, trim(to_char(fecha,'dd/mm/yyyy hh:mi:ss')) as fecha_hora,(case when h.idorigenp is not null and h.idorigenp > 0 and h.idproducto is not null and h.idproducto > 0 and h.idauxiliar is not null and h.idauxiliar > 0 then text(h.idorigenp)||'-'||text(h.idproducto)||'-'||text(h.idauxiliar) else '' end) as opa,(case when h.monto is not null and h.monto > 0  then trim(to_char(h.monto, '999,999,999.99')) else '' end) as montox from historial h where h.idorigen = 10401 and h.idgrupo = 10 and h.idsocio = 116306 and h.tipomensaje in (3,4) order by h.fecha
Message: valida_ogs_categoria...
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'nivel_riesgo_lavado' and idelemento = '2' and trim(dato5) = '1'
DEBUG_DB: Query:
   select * from   sopar where  idusuario = 999 and lower(tipo) like 'cuentas_asignadas_a_despacho_externo' and idorigen = 10401 and idgrupo = 10 and idsocio = 116306

