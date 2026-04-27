select
trim(to_char(ah.idorigen,'099999'))||'-'||ah.idgrupo||'-'||
trim(to_char(ah.idsocio,'099999')) as no_socio, '|' as "|",
nombre_x(per.appaterno,per.apmaterno,per.nombre) as nombre, '|' as "|",
trim(to_char(adh.idorigenp,'099999'))||'-'||
trim(to_char(adh.idproducto,'09999'))||'-'||
trim(to_char(adh.idauxiliar,'09999999')) as credito,'|' as "|",
adh.fecha,adh.monto,adh.cargoabono
from auxiliares_d_h adh  
inner join auxiliares_h as ah using (idorigenp,idproducto,idauxiliar)
inner join personas as per using(idorigen,idgrupo,idsocio)
where ah.idgrupo =20 and date(adh.fecha) between date('01-01-2024') and date('31-12-2024')
    union
select
trim(to_char(ah.idorigen,'099999'))||'-'||ah.idgrupo||'-'||
trim(to_char(ah.idsocio,'099999')) as no_socio, '|' as "|",
nombre_x(per.appaterno,per.apmaterno,per.nombre) as nombre, '|' as "|",
trim(to_char(adh.idorigenp,'099999'))||'-'||
trim(to_char(adh.idproducto,'09999'))||'-'||
trim(to_char(adh.idauxiliar,'09999999')) as credito,'|' as "|",
adh.fecha,adh.monto,adh.cargoabono
from auxiliares_d adh  
inner join auxiliares as ah using (idorigenp,idproducto,idauxiliar)
inner join personas as per using(idorigen,idgrupo,idsocio)
where ah.idgrupo =20 and date(adh.fecha) between date('01-01-2024') and date('31-12-2024');