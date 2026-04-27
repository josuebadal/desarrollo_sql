SAI_TOKEN()
SAI_FINDSTR()
conteo_renovado_reestructurado()
TO_CHAR()
TO_NUMBER()
REPLACE()
UPPER()
TRIM()





select distinct on (per.idorigen,per.idgrupo,per.idsocio) 
per.idorigen,per.idgrupo,per.idsocio, 
nombre_x(per.nombre,per.appaterno,per.apmaterno) as nombre_socio,
per.rfc,
per.curp, 
trim(to_char(aux110.idorigenp,'099999'))||'-'||
trim(to_char(aux110.idproducto,'09999'))||'-'||
trim(to_char(aux110.idauxiliar,'09999999')) as opa_110,
(select auxd110.fecha
from auxiliares_d as auxd110 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd110.idorigenp,auxd110.idproducto, auxd110.idauxiliar)=(aux110.idorigenp,aux110.idproducto, aux110.idauxiliar) and auxd110.tipomov=0 and pol.idusuario <> 999 order by auxd110.fecha desc limit 1 ) as fecha_ultimo_mov_110,
trim(to_char(aux111.idorigenp,'099999'))||'-'||
trim(to_char(aux111.idproducto,'09999'))||'-'||
trim(to_char(aux111.idauxiliar,'09999999')) as opa_111,
(select auxd111.fecha
from auxiliares_d as auxd111 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd111.idorigenp,auxd111.idproducto, auxd111.idauxiliar)=(aux111.idorigenp,aux111.idproducto, aux111.idauxiliar) and auxd111.tipomov=0 and pol.idusuario <> 999 order by auxd111.fecha desc limit 1 ) as fecha_ultimo_mov_111,
trim(to_char(aux113.idorigenp,'099999'))||'-'||
trim(to_char(aux113.idproducto,'09999'))||'-'||
trim(to_char(aux113.idauxiliar,'09999999')) as opa_113,
(select auxd113.fecha
from auxiliares_d as auxd113 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd113.idorigenp,auxd113.idproducto, auxd113.idauxiliar)=(aux113.idorigenp,aux113.idproducto, aux113.idauxiliar) and auxd113.tipomov=0 and pol.idusuario <> 999 order by auxd113.fecha desc limit 1 ) as fecha_ultimo_mov_113,
trim(to_char(aux114.idorigenp,'099999'))||'-'||
trim(to_char(aux114.idproducto,'09999'))||'-'||
trim(to_char(aux114.idauxiliar,'09999999')) as opa_114,
(select auxd114.fecha
from auxiliares_d as auxd114 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd114.idorigenp,auxd114.idproducto, auxd114.idauxiliar)=(aux114.idorigenp,aux114.idproducto, aux114.idauxiliar) and auxd114.tipomov=0 and pol.idusuario <> 999 order by auxd114.fecha desc limit 1 ) as fecha_ultimo_mov_114,
trim(to_char(aux140.idorigenp,'099999'))||'-'||
trim(to_char(aux140.idproducto,'09999'))||'-'||
trim(to_char(aux140.idauxiliar,'09999999')) as opa_140,
(select auxd140.fecha
from auxiliares_d  as auxd140 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd140.idorigenp,auxd140.idproducto, auxd140.idauxiliar)=(aux140.idorigenp,aux140.idproducto, aux140.idauxiliar) and auxd140.tipomov=0 and pol.idusuario <> 999 order by auxd140.fecha desc limit 1 ) as fecha_ultimo_mov_140
from personas as per 
full join auxiliares as aux110 on aux110.idorigen = per.idorigen and aux110.idgrupo = per.idgrupo and aux110.idsocio = per.idsocio and aux110.idproducto=110
full join auxiliares as aux111 on aux111.idorigen = per.idorigen and aux111.idgrupo = per.idgrupo and aux111.idsocio = per.idsocio and aux111.idproducto=111
full join auxiliares as aux113 on aux113.idorigen = per.idorigen and aux113.idgrupo = per.idgrupo and aux113.idsocio = per.idsocio and aux113.idproducto=113
full join auxiliares as aux114 on aux114.idorigen = per.idorigen and aux114.idgrupo = per.idgrupo and aux114.idsocio = per.idsocio and aux114.idproducto=114
full join auxiliares as aux140 on aux140.idorigen = per.idorigen and aux140.idgrupo = per.idgrupo and aux140.idsocio = per.idsocio and aux140.idproducto=140
where per.estatus = false and per.causa_baja <> 0
union
select distinct on (per.idorigen,per.idgrupo,per.idsocio) 
per.idorigen,per.idgrupo,per.idsocio, 
nombre_x(per.nombre,per.appaterno,per.apmaterno) as nombre_socio,
per.rfc,
per.curp, 
trim(to_char(aux110.idorigenp,'099999'))||'-'||
trim(to_char(aux110.idproducto,'09999'))||'-'||
trim(to_char(aux110.idauxiliar,'09999999')) as opa_110,
(select auxd110.fecha
from auxiliares_d_h as auxd110 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd110.idorigenp,auxd110.idproducto, auxd110.idauxiliar)=(aux110.idorigenp,aux110.idproducto, aux110.idauxiliar) and auxd110.tipomov=0 and pol.idusuario <> 999 order by auxd110.fecha desc limit 1 ) as fecha_ultimo_mov_110,
trim(to_char(aux111.idorigenp,'099999'))||'-'||
trim(to_char(aux111.idproducto,'09999'))||'-'||
trim(to_char(aux111.idauxiliar,'09999999')) as opa_111,
(select auxd111.fecha
from auxiliares_d_h as auxd111 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd111.idorigenp,auxd111.idproducto, auxd111.idauxiliar)=(aux111.idorigenp,aux111.idproducto, aux111.idauxiliar) and auxd111.tipomov=0 and pol.idusuario <> 999 order by auxd111.fecha desc limit 1 ) as fecha_ultimo_mov_111,
trim(to_char(aux113.idorigenp,'099999'))||'-'||
trim(to_char(aux113.idproducto,'09999'))||'-'||
trim(to_char(aux113.idauxiliar,'09999999')) as opa_113,
(select auxd113.fecha
from auxiliares_d_h as auxd113 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd113.idorigenp,auxd113.idproducto, auxd113.idauxiliar)=(aux113.idorigenp,aux113.idproducto, aux113.idauxiliar) and auxd113.tipomov=0 and pol.idusuario <> 999 order by auxd113.fecha desc limit 1 ) as fecha_ultimo_mov_113,
trim(to_char(aux114.idorigenp,'099999'))||'-'||
trim(to_char(aux114.idproducto,'09999'))||'-'||
trim(to_char(aux114.idauxiliar,'09999999')) as opa_114,
(select auxd114.fecha
from auxiliares_d_h as auxd114 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd114.idorigenp,auxd114.idproducto, auxd114.idauxiliar)=(aux114.idorigenp,aux114.idproducto, aux114.idauxiliar) and auxd114.tipomov=0 and pol.idusuario <> 999 order by auxd114.fecha desc limit 1 ) as fecha_ultimo_mov_114,
trim(to_char(aux140.idorigenp,'099999'))||'-'||
trim(to_char(aux140.idproducto,'09999'))||'-'||
trim(to_char(aux140.idauxiliar,'09999999')) as opa_140,
(select auxd140.fecha
from auxiliares_d_h as auxd140 
inner join polizas as pol using (idorigenc,periodo,idtipo,idpoliza) 
where (auxd140.idorigenp,auxd140.idproducto, auxd140.idauxiliar)=(aux140.idorigenp,aux140.idproducto, aux140.idauxiliar) and auxd140.tipomov=0 and pol.idusuario <> 999 order by auxd140.fecha desc limit 1 ) as fecha_ultimo_mov_140
from personas as per 
full join auxiliares_h as aux110 on aux110.idorigen = per.idorigen and aux110.idgrupo = per.idgrupo and aux110.idsocio = per.idsocio and aux110.idproducto=110
full join auxiliares_h as aux111 on aux111.idorigen = per.idorigen and aux111.idgrupo = per.idgrupo and aux111.idsocio = per.idsocio and aux111.idproducto=111
full join auxiliares_h as aux113 on aux113.idorigen = per.idorigen and aux113.idgrupo = per.idgrupo and aux113.idsocio = per.idsocio and aux113.idproducto=113
full join auxiliares_h as aux114 on aux114.idorigen = per.idorigen and aux114.idgrupo = per.idgrupo and aux114.idsocio = per.idsocio and aux114.idproducto=114
full join auxiliares_h as aux140 on aux140.idorigen = per.idorigen and aux140.idgrupo = per.idgrupo and aux140.idsocio = per.idsocio and aux140.idproducto=140
where per.estatus = false and per.causa_baja <> 0
;







