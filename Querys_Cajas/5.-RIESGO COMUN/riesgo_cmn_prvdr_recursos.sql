/*Socios considerados proveedor de recursos y sus beneficiarios,
proveedor de recursos
ogs 
nombre del socio
opa
saldo de opa
ogs referencia
nombre referencia


SOLICITADO POR SAN ISIDRO EN OCTUBRE 2024*/
select
(case when r.tiporeferencia = 4 then 'Proveedor de recursos' 
    end) as "Tipo de referencia", 
(TRIM(TO_CHAR(r.idorigenr,'099999')) ||'-' || r.idgrupor ||'-'|| TRIM(TO_CHAR(r.idsocior,'09999999'))) AS "Numero de socio",  
trim(nombre_x(p1.nombre, p1.appaterno,p1.apmaterno)) as "Nombre",
TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-' || TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999'))  as "Credito" ,
a.saldo as "saldo", 
(TRIM(TO_CHAR(r.idorigen,'099999')) ||'-' || r.idgrupo ||'-'|| TRIM(TO_CHAR(r.idsocio,'09999999'))) AS "Numero de socio beneficiario",  
(select trim(nombre_x(p2.nombre, p2.appaterno,p2.apmaterno)) from personas as p2 where p2.idorigen=r.idorigen and p2.idgrupo=r.idgrupo and p2.idsocio=r.idsocio) as "Nombre beneficiario",
(select TRIM(TO_CHAR(a2.idorigenp,'099999')) ||'-' || TRIM(TO_CHAR(a2.idproducto,'09999')) ||'-'|| TRIM(TO_CHAR(a2.idauxiliar,'09999999')) AS "cred_ben" from auxiliares as a2 where (a2.idorigen,a2.idgrupo,a2.idsocio) = (r.idorigen,r.idgrupo,r.idsocio)
and a2.idproducto between 30000 and 39999
    and a2.estatus = 2 
    order by a2.fechaape DESC 
    limit 1
) AS "Credito_bene",
(select a3.saldo AS "saldo_ben" from auxiliares as a3 where (a3.idorigen,a3.idgrupo,a3.idsocio) = (r.idorigen,r.idgrupo,r.idsocio)
and a3.idproducto between 30000 and 39999
    and a3.estatus = 2 
    order by a3.fechaape DESC
    limit 1
) AS "saldo_bene"
from referencias as r
inner join personas as p1 on r.idorigenr=p1.idorigen and r.idgrupor=p1.idgrupo and r.idsocior=p1.idsocio
LEFT JOIN auxiliares as a on  r.idorigenr= a.idorigen and r.idgrupor= a.idgrupo and r.idsocior = a.idsocio
where r.tiporeferencia = 4
and a.idproducto between 30000 and 39999
and p1.idgrupo = 10 ANd a.estatus = 2 --AND r.idgrupo = 10
ORDER BY p1.nombre
;
