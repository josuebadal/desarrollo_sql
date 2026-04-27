select distinct on (a.idorigenp, a.idproducto, a.idauxiliar )
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || TRIM(TO_CHAR(p.idsocio, '099999')) AS "Numero de Socio",
TRIM(TO_CHAR(a.idorigenp, '099999')) || '-' || TRIM(TO_CHAR(a.idproducto, '09999')) || '-' || TRIM(TO_CHAR(a.idauxiliar , '09999999')) AS "ID credito",
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
a.saldo as "saldo"
from auxiliares as a
inner join personas as p using(idorigen,idgrupo,idsocio)
inner join socioeconomicos as s using (idorigen,idgrupo,idsocio)
inner join auxiliares_d as ad using (idorigenp,idproducto,idauxiliar)
where
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,p.fechaingreso )) > 3 and
a.idproducto in(select idproducto from productos where tipoproducto in(0,1,8)) and exists
(select 1 from auxiliares where  idorigen=a.idorigen and idgrupo=a.idgrupo and idsocio=a.idsocio and idproducto in(30102,30202,32602,32702,31802) limit 1 ) and
s.estatusvivienda in(1,2,3) and
a.saldo > 100 and
ad.diasvencidos < 10 and
((select count(*) from auxiliares_d where idorigenp=a.idorigenp and idproducto=a.idproducto and idauxiliar=a.idauxiliar and cargoabono=1 and fecha between a.fechaactivacion and a.fechaactivacion + interval '1 year') between 6 and 12)
order by a.idorigenp, a.idproducto, a.idauxiliar;

/*
Buen día Karen, me puedes ayudar por favor con una consulta con las siguientes características.
 
•€€€€€€€€ Antigüedad como socios de más de 3 años.
•€€€€€€€€ Haber tenido <10 días vencidos en cualquier producto de crédito.
•€€€€€€€€ Casa propia, propia cónyuge o pagándola.
•€€€€€€€€ Haber tenido algún crédito con capital en riesgo.(ordinario, extraordinario, crediplus, temporada y  5 años) Productos 30102,30202,32602,32702,31802
*/

SELECT DISTINCT
    socio.idorigen || ' ' || socio.idgrupo || ' ' || socio.idsocio AS OGS,
    socio.fechaingreso,
    socio.nombre || ' ' || socio.appaterno || ' ' || socio.apmaterno AS nombre,
    aux.idorigenp || ' ' ||aux.idproducto || ' ' ||aux.idauxiliar AS producto
FROM auxiliares aux
JOIN personas socio using(idorigen,idgrupo,idsocio)
JOIN socioeconomicos casa using (idorigen,idgrupo,idsocio)
WHERE
    aux.idproducto in(30102,30202,32602,32702,31802)
    AND EXISTS (
    SELECT 1
    FROM auxiliares aux2
    WHERE aux2.idsocio = socio.idsocio
      AND aux2.idproducto = 101
      AND aux2.estatus = 2
      AND aux2.saldo = 1000)
    AND socio.fechaingreso <= (CURRENT_DATE - INTERVAL '3 years')
    AND CAST(coalesce(split_part(sai_auxiliar(aux.idorigenp, aux.idproducto, aux.idauxiliar, date('2025-05-13')), '|', 4), '0') AS INTEGER) <= 10
    AND casa.estatusvivienda IN (1, 2, 3)
    AND aux.idsocio = socio.idsocio
    AND (SELECT count(*) from auxiliares_d as ad1
    inner join auxiliares as ax2 on ad1.idorigenp = ax2.idorigenp and ad1.idproducto = ax2.idproducto and ad1.idauxiliar = ax2.idauxiliar
     where (ax2.idorigen,ax2.idgrupo,ax2.idsocio) = (socio.idorigen,socio.idgrupo,socio.idsocio) and ad1.idproducto in (select idproducto from productos where tipoproducto=0) and ad1.cargoabono=1) between 6 and 12