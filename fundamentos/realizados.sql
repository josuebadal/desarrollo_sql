BASE DE DATOS SAN ISIDRO
me puedes ayudar por favor con una consulta con las siguientes caracteristicas.
•€€€€€€€€ Antigüedad como socios de mas de 3 años.
•€€€€€€€€ Haber tenido <10 dias vencidos en cualquier producto de credito.
•€€€€€€€€ Casa propia, propia conyuge o pagandola.
•€€€€€€€€ Haber tenido algun credito con capital en riesgo.(ordinario, extraordinario, crediplus, temporada y  5 años) Productos 30102,30202,32602,32702,31802
Puede interpretarse como que tenga almenos 6 a 12 meses abonos al ahorro producto 110
tipo de produto = 0

/* INTENTO REALIZADO BASICO*/
en la tabla "polizas" el elemento  "idorigenc" 
corresponde tabla "origenes" elemento "idorigen"
corresponde tabla "auxiliares" elemento "idorigen"   

explain analyze 
SELECT DISTINCT
    socio.idorigen || ' ' || socio.idgrupo || ' ' || socio.idsocio AS OGS,
    socio.fechaingreso,
    socio.nombre || ' ' || socio.appaterno || ' ' || socio.apmaterno AS nombre,
    aux.idorigenp || ' ' ||aux.idproducto || ' ' ||aux.idauxiliar AS producto
FROM auxiliares aux
JOIN personas socio USING(idorigen,idgrupo,idsocio)
JOIN socioeconomicos casa USING (idorigen,idgrupo,idsocio)
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
    ;


/* INTENTO REALIZADO FINAL POR GABY alidar  nombre_x*/
select distinct on (a.idorigenp, a.idproducto, a.idauxiliar )
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || 
TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || 
TRIM(TO_CHAR(p.idsocio, '099999')) 
AS "Numero de Socio",
TRIM(TO_CHAR(a.idorigenp, '099999')) || '-' || 
TRIM(TO_CHAR(a.idproducto, '09999')) || '-' || 
TRIM(TO_CHAR(a.idauxiliar , '09999999')) 
AS "ID credito",
nombre_x(p.nombre, p.appaterno, p.apmaterno) 
AS "Nombre del Socio",
a.saldo as "saldo"
from auxiliares as a
inner join personas as p 
USING(idorigen,idgrupo,idsocio)
inner join socioeconomicos as s 
USING (idorigen,idgrupo,idsocio)
inner join auxiliares_d as ad 
USING (idorigenp,idproducto,idauxiliar)
where
EXTRACT(YEARS 
    FROM AGE((
        select date(fechatrabajo) 
        from origenes 
        limit 1) ,p.fechaingreso )) > 3 
    and a.idproducto in(select idproducto from productos where tipoproducto in(0,1,8)) 
        and exists (select 1 from auxiliares where  idorigen=a.idorigen and idgrupo=a.idgrupo and idsocio=a.idsocio and idproducto in(30102,30202,32602,32702,31802) limit 1 ) 
    and s.estatusvivienda in(1,2,3)
    and a.saldo > 100 
    and ad.diasvencidos < 10 
        and ((select count(*) from auxiliares_d where idorigenp=a.idorigenp and idproducto=a.idproducto and idauxiliar=a.idauxiliar and cargoabono=1 and fecha between a.fechaactivacion and a.fechaactivacion + interval '1 year') between 6 and 12)
order by a.idorigenp, a.idproducto, a.idauxiliar;


**CAJA MITRAS**
Solicito de su apoyo ya que requiero un reporte que contenga todos los depositos en efectivo 
realizados durante el 2024 con las siguientes columnas:
base: mitras30jun25_movimientos 

/* VALIDAR QUE LA UNION ES LA MISMA CONSULTA CON LOS MISMOS ELEMENTOS PERO APUNTANDO A OTRA TABLA
SE DIFERENCIA CON EL JOIN EN LA TABLA auxiliares_d y el segundo JOIN de la union con
auxiliares_d_h
*/

el dato "cargoabono" es diferente entre ahorro y prestamos
Rango de  fecha 01/01/2024 - 31/12/2024 se obtiene:
auxiliares_d con el dato "periodo"

donde sacar el cargo abono?
tabla auxiliares_d 
elemento cargo abono 1/0
Nota: Validar que es (efectivo) efectivo obtenido por el socio sin importa si es parcial o total
Nota: 
SELECT efectivo FROM auxiliares_d LIMIT 5 ;

SELECT 
 'D' AS "TABLA",
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || 
TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || 
TRIM(TO_CHAR(p.idsocio, '099999')) 
AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) 
AS "NOMBRE",
TRIM(TO_CHAR(a.idorigenp, '099999')) || '-' || 
TRIM(TO_CHAR(a.idproducto, '09999')) || '-' || 
TRIM(TO_CHAR(a.idauxiliar, '09999999'))
AS "OPA",
TO_CHAR(auxd.fecha, 'YYYY-MM-DD') AS fecha_movimiento,
auxd.cargoabono,
auxd.idtipo,
auxd.periodo,
auxd.efectivo
from auxiliares a 
JOIN personas p
USING (idorigen, idgrupo, idsocio)
JOIN auxiliares_d auxd
USING (idproducto,idauxiliar)
WHERE 
auxd.cargoabono = 1
AND auxd.fecha::date BETWEEN '2024-01-01' AND '2024-12-01' 
AND auxd.efectivo > 0
UNION 
SELECT 
 'H' AS "TABLA",
TRIM(TO_CHAR(p.idorigen, '099999')) || '-' || 
TRIM(TO_CHAR(p.idgrupo, '09')) || '-' || 
TRIM(TO_CHAR(p.idsocio, '099999')) 
AS "OGS",
nombre_x(p.nombre, p.appaterno, p.apmaterno) 
AS "NOMBRE",
TRIM(TO_CHAR(a.idorigenp, '099999')) || '-' || 
TRIM(TO_CHAR(a.idproducto, '09999')) || '-' || 
TRIM(TO_CHAR(a.idauxiliar, '09999999'))
AS "OPA",
TO_CHAR(auxd.fecha, 'YYYY-MM-DD') AS fecha_movimiento,
auxd.cargoabono,
auxd.idtipo,
auxd.periodo,
auxd.efectivo
from auxiliares a 
JOIN personas p
USING (idorigen, idgrupo, idsocio)
JOIN auxiliares_d_h auxd
USING (idproducto,idauxiliar)
WHERE 
auxd.cargoabono = 1
AND auxd.fecha::date BETWEEN '2024-01-01' AND '2024-12-01' 
AND auxd.efectivo > 0





















Base de datos de capital social al 30 de junio de 2024, que contenga las siguientes columnas de datos:
a)    Numero de socio.
b)    Nombre del socio.
c)    Tipo de socio (1 Socio personas fisica o 2 Socio persona moral).
d)    Fecha de nacimiento (en formato dd/mm/aaaa).
e)    Sucursal a la que pertenece el socio.
f)       Fecha de ingreso (en formato dd/mm/aaaa).
g)    Numero de certificados de aportacion ordinarios.
h)    Monto de certificados de aportacion ordinarios.
i)        Numero de certificados de aportacion excedentes o voluntarios.
j)        Montos de certificados de aportacion excedentes o voluntarios.


SELECT 
TRIM(TO_CHAR(p.idsocio, '099999')) AS num_socio,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
'1' as "tipo de socio",
TRIM(TO_CHAR(p.idorigen, '099999')) AS origen,
o.nombre AS suc_origen,
TO_CHAR(p.fechanacimiento, 'DD-MM-YYYY') AS fecha_nac,
TO_CHAR(p.fechaingreso, 'DD-MM-YYYY') AS fecha_ing,
'10' as "numero de certificados de aportacion ordinario",
'100' as "monto de certificados de aportacion ordinario",
'0' as "numero de certificados de aportacion de excedentes",
'0' as "monto de certificados de aportacion de excedentes" 
FROM personas p
JOIN origenes o
USING (idorigen)
where idproducto = 101 and saldo = 1000
order by p.idorigen,p.idgrupo,p.idsocio; 


/* INTENTO REALIZADO FINAL POR GABY validar
NOTA: se agrega el tipo de socio 1 Porque en la tabla GRUPOS No tienen personas morales unicamente fisicas
Esta caja ocupa 10 certificados de aportacion de 100 cada una  se agrega una columna
por ende no contiene certificados de apotaciones excedentes y menos el monto de excedentes
En total se agregaron 5 columnas
*/
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












SELECT nombre, idproducto from productos 
where LOWER(nombre) like '%apor%';

SELECT * from personas 
where  LOWER(categoria) like '%mora%'
LIMIT 5;

SELECT 
TRIM(TO_CHAR(p.idsocio, '099999')) AS num_socio,
nombre_x(p.nombre, p.appaterno, p.apmaterno) 
AS "NOMBRE",
TRIM(TO_CHAR(p.idorigen, '099999')) AS origen,
o.nombre AS suc_origen,
TO_CHAR(p.fechanacimiento, 'DD-MM-YYYY') AS fecha_nac,
TO_CHAR(p.fechaingreso, 'DD-MM-YYYY') AS fecha_ing,
p.categoria  
FROM personas p
JOIN origenes o
USING (idorigen)
WHERE 
idorigen =31001
AND idgrupo =10
AND idsocio= 4;
/* INTENTO REALIZADO FINAL POR GABY validar*/


