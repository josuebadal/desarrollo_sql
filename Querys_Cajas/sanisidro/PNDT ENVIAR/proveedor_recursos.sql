select
(case when r.tiporeferencia = 4 then 'Proveedor de recursos'
	when r.tiporeferencia=32 then 'Propietario real' 
    end) 
as "Tipo de referencia",
'|' AS "|", 
(TRIM(TO_CHAR(r.idorigenr,'099999')) ||'-' || r.idgrupor ||'-'|| TRIM(TO_CHAR(r.idsocior,'099999'))) AS "Numero de socio", 
'|' AS "|", 
trim(nombre_x(p1.nombre, p1.appaterno,p1.apmaterno)) as "Nombre",
'|' AS "|", 
(TRIM(TO_CHAR(r.idorigen,'099999')) ||'-' || r.idgrupo ||'-'|| TRIM(TO_CHAR(r.idsocio,'099999'))) AS "Numero de socio beneficiario", 
'|' AS "|", 
(select trim(nombre_x(p2.nombre, p2.appaterno,p2.apmaterno)) from personas as p2 where p2.idorigen=r.idorigen and p2.idgrupo=r.idgrupo and p2.idsocio=r.idsocio) as "Nombre beneficiario"
from referencias as r
inner join personas as p1 on r.idorigenr=p1.idorigen and r.idgrupor=p1.idgrupo and r.idsocior=p1.idsocio 
where tiporeferencia in(4,32)
;
