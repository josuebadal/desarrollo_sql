select distinct on (p.idorigen,p.idgrupo,p.idsocio)
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || TRIM(TO_CHAR(p.idsocio, '099999')) AS "Numero de Socio",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
'1' as "tipo de socio",
to_char(p.fechanacimiento,'dd/MM/YYYY') as "fecha nacimiento",
o.nombre as "sucursal" ,
to_char(p.fechaingreso,'dd/MM/YYYY') as "fecha ingreso",
'10' as "numero de certificados de aportacion ordinario",
'100' as "monto de certificados de aportacion ordinario",
'0' as "numero de certificados de aportacion de excedentes",
'0' as "monto de certificados de aportacion de excedentes"
from auxiliares as a
inner join personas as p on a.idorigen=p.idorigen and a.idgrupo=p.idgrupo and a.idsocio=p.idsocio
inner join origenes as o on p.idorigen =o.idorigen
where idproducto = 101 and saldo = 1000
order by p.idorigen,p.idgrupo,p.idsocio; 





select
     a.idorigen, '|' as "|",
     a.idgrupo, '|' as "|",
     a.idsocio, '|' as "|",
     per.nombre , '|' as "|",
     per.appaterno , '|' as "|",
     per.apmaterno , '|' as "|",
     ad.idorigenp, '|' as "|",
     ad.idproducto, '|' as "|",
     ad.idauxiliar, '|' as "|",
     ad.fecha, '|' as "|",
     ad.cargoabono, '|' as "|",
     ad.idtipo, '|' as "|",
     ad.periodo, '|' as "|",
     ad.efectivo, '|' as "|"
     from   auxiliares_d ad
            inner join auxiliares   a  using (idorigenp,idproducto,idauxiliar)
            inner join personas per using (idorigen, idgrupo, idsocio)
     where  ad.tipomov = 0 and ad.idtipo=1 and ad.cargoabono =1 and
            ad.periodo:: integer between 202401 and 202412 and ad.efectivo != 0
     UNION
     select
     a.idorigen, '|' as "|",
     a.idgrupo, '|' as "|",
     a.idsocio, '|' as "|",
     per.nombre , '|' as "|",
     per.appaterno , '|' as "|",
     per.apmaterno , '|' as "|",
     ad.idorigenp, '|' as "|",
     ad.idproducto, '|' as "|",
     ad.idauxiliar,'|' as "|",
     ad.fecha, '|' as "|",
     ad.cargoabono, '|' as "|",
     ad.idtipo, '|' as "|",
     ad.periodo, '|' as "|",
     ad.efectivo, '|' as "|"
     from   auxiliares_d_h ad
            inner join auxiliares_h   a  using (idorigenp,idproducto,idauxiliar)
            inner join personas per using (idorigen, idgrupo, idsocio)
     where  ad.tipomov = 0 and ad.idtipo=1 and  ad.cargoabono =1 and
            ad.periodo:: integer between 202401 and 202412 and ad.efectivo != 0;