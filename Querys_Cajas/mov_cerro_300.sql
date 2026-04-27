select  (aa.idorigen||'-'||aa.idgrupo||'-'||aa.idsocio)as "Socio",
        (p.nombre||' '||p.appaterno||' '||p.apmaterno)as "Nombre",
        (m.idorigenp||'-'||m.idproducto||'-'||m.idauxiliar)as "Folio",
        (m.ticket)as ticket,
        (m.efectivo)as "Deposito",
        (m.idorigenc)as Sucursal,
        (m.fechita)as fecha,
        (ni.observaciones)as "Mensaje"
        
from 
(select a.idorigenp,a.idproducto,a.idauxiliar,a.ticket,a.efectivo,ad.idorigenc,date(a.fecha)as fechita
from auxiliares_d a
inner join
 (select ad.idorigenc,ad.idpoliza,ad.ticket,
       (sum(ad.efectivo))as efect,ad.periodo
from auxiliares_d ad where  ad.periodo=@@Periodo:|t|202511@@
group by ad.ticket,ad.idorigenc, ad.idpoliza,ad.periodo
having  sum(ad.efectivo)>100000)ad on(a.periodo=ad.periodo and a.ticket=ad.ticket and a.idorigenc=ad.idorigenc and a.idpoliza=ad.idpoliza))m

left join(select * from auxiliares aa)aa on (aa.idorigenp=m.idorigenp and aa.idproducto=m.idproducto and aa.idauxiliar=m.idauxiliar)
left join(select * from personas p)p on(aa.idorigen=p.idorigen and aa.idgrupo=p.idgrupo and aa.idsocio=p.idsocio)


left join(select * from notas_relevantes_inusuales )ni on(aa.idorigen=ni.idorigen and aa.idsocio=ni.idsocio and aa.idgrupo=ni.idgrupo and m.idorigenc=ni.sucursal and m.fechita=ni.fecha );