RE: Requisitos cotizacion seguro Deudor Ahorrador Caja San Isidro

**Fecha de ingreso a la cooperativa
**Fecha de nacimiento del socio
**Edad del socio
**Parte social  -- deben ser 10 de 100 c/u 
**Saldo de ahorros 
**(ahorro mayor + ahorro disponible + dpf) --tipos 0, 1 , 8
**Fecha de otorgamiento de credito --validar fecha activacion
**Monto original otorgado --validar si quiere ahorro o prestamos, los ahorros no tienen saldo otorgados
**Saldo capital
Saldo vencido
Interes generado
Interes moratorio
Fecha de vencimiento --VALIDAR DONDE SALE ESTE DATO


SELECT
p.fechaingreso,  
p.fechanacimiento,
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(p.idorigen, '099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "O-G-S",
a.fechaactivacion,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'|| 
TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| 
TRIM(TO_CHAR(a.idauxiliar, '09999999' ))AS "O-P-A",
a.saldo,
pr.tipoproducto
FROM auxiliares a
JOIN personas p
USING (idorigen,idgrupo,idsocio)
JOIN productos pr ON a.idproducto = pr.idproducto
AND a.idorigenp = pr.idorigen
WHERE a.estatus =2
AND pr.tipoproducto IN (0, 1, 8)
AND a.saldo != 0
AND p.estatus = 't'
ORDER BY p.fechaingreso
LIMIT 20
;


===========================================================================
-- INTENTO 2
SELECT
p.fechaingreso,  
p.fechanacimiento,
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(p.idorigen, '099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "O-G-S",
a.fechaactivacion,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'|| 
TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| 
TRIM(TO_CHAR(a.idauxiliar, '09999999' ))AS "O-P-A",
pr.tipoproducto, pr.nombre,
a.saldo, a.montoprestado
FROM auxiliares a
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN productos pr 
ON a.idproducto = pr.idproducto AND a.idorigenp = pr.idorigen
WHERE a.estatus =2
AND pr.tipoproducto IN (0, 1, 2, 8) AND a.saldo != 0 AND p.estatus = 't'
ORDER BY p.fechaingreso;
LIMIT 20
;

===========================================================================
--INTENTO 3 SI AGREGO CV DEJA DE TRAER LOS AHORRO
SELECT
p.fechaingreso,  p.fechanacimiento,
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(p.idorigen, '099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "O-G-S",
a.fechaactivacion,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'|| 
TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| 
TRIM(TO_CHAR(a.idauxiliar, '09999999' ))AS "O-P-A",
pr.tipoproducto,
a.saldo AS "Saldo Actual", a.montoprestado,
cv.montoapagar, cv.montovencido AS "Saldo Vencido", cv.io AS "iordionario", cv.im "imoratorio"
FROM auxiliares a
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN productos pr ON a.idproducto = pr.idproducto
AND a.idorigenp = pr.idorigen
INNER JOIN carteravencida cv ON a.idorigenp = cv.idorigenp
AND a.idproducto = cv.idproducto AND a.idauxiliar = cv.idauxiliar
WHERE a.estatus =2
AND pr.idproducto IN (
    SELECT idproducto 
    FROM productos 
    WHERE tipoproducto IN (0, 1, 2, 8)
                    )
AND a.saldo != 0
AND p.estatus = 't'
AND a.idauxiliar IN (
    SELECT cv1.idauxiliar
    FROM carteravencida cv1, auxiliares a1
    WHERE a1.idorigenp = cv1.idorigenp 
    AND a1.idproducto = cv1.idproducto 
    AND a1.idauxiliar = cv1.idauxiliar
)
ORDER BY p.fechaingreso;

--INTENTO 4
SELECT
p.fechaingreso,  p.fechanacimiento,
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(p.idorigen, '099999')) ||'-'||
TRIM(TO_CHAR(p.idgrupo, '09')) ||'-'||
TRIM(TO_CHAR(p.idsocio, '099999')) AS "O-G-S",
a.fechaactivacion,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "Nombre del Socio",
TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'|| 
TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| 
TRIM(TO_CHAR(a.idauxiliar, '09999999' ))AS "O-P-A",
pr.tipoproducto,pr.nombre,
a.saldo AS "Saldo Actual",
cv.montoprestado, cv.montoapagar, cv.montovencido, cv.io, cv.im
FROM auxiliares a
INNER JOIN personas p
USING (idorigen,idgrupo,idsocio)
INNER JOIN productos pr ON a.idproducto = pr.idproducto
AND a.idorigenp = pr.idorigen
LEFT JOIN carteravencida cv
  ON cv.idorigenp = a.idorigenp
 AND cv.idproducto = a.idproducto
 AND cv.idauxiliar = a.idauxiliar
WHERE a.estatus =2
AND a.saldo !=0
AND pr.idproducto IN (
    SELECT idproducto 
    FROM productos 
    WHERE tipoproducto IN (1,2,8,0)
                    )
AND p.estatus = 't'
ORDER BY p.idorigen,p.idgrupo,p.idsocio;


031001,32602,00000203

select aux.idorigen,aux.idgrupo,aux.idsocio,aux.idproducto,aux.saldo as "saldo credito", 
(select sum(aux2.saldo) from auxiliares as aux2 where aux2.idproducto=101 and aux2.idorigen=aux.idorigen and aux2.idgrupo=aux.idgrupo and aux2.idsocio=aux.idsocio ) as "Parte social"
from auxiliares aux where 
idproducto in 
(select idproducto from productos where tipoproducto=2);





--HACER UNA SUB CONSULTA A ESTOS DATOS
AND pr.tipoproducto IN (0, 1, 2, 8)
INNER JOIN carteravencida cv ON a.idorigenp = cv.idorigenp
AND a.idproducto = cv.idproducto AND a.idauxiliar = cv.idauxiliar

RE: Requisitos cotizacion seguro Deudor Ahorrador Caja San Isidro

**Fecha de ingreso a la cooperativa
**Fecha de nacimiento del socio
**Edad del socio
**Parte social  -- deben ser 10 de 100 c/u 
**Saldo de ahorros 
**(ahorro mayor + ahorro disponible + dpf) --tipos 0, 1 , 8
**Fecha de otorgamiento de credito --validar fecha activacion
**Monto original otorgado --validar si quiere ahorro o prestamos, los ahorros no tienen saldo otorgados
**Saldo capital
**Saldo vencido --viene de cv
**Interes generado --viene de cv
**Interes moratorio --viene de cv
Fecha de vencimiento --VALIDAR DONDE SALE ESTE DATO

carteravencida
cv.montoapagar
cv.montovencido 

(SELECT cv.montoprestado, cv.montoapagar,cv.montovencido,cv.io,cv.im FROM carteravencida cv WHERE cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar),
(SELECT cv.montoapagar FROM carteravencida cv WHERE cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar LIMIT 1) AS montoapagar,
(SELECT cv.montovencido FROM carteravencida cv WHERE cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar LIMIT 1) AS "Saldo Vencido",
(SELECT cv.io FROM carteravencida cv WHERE cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar LIMIT 1),
(SELECT cv.im FROM carteravencida cv WHERE cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar LIMIT 1)


idproducto
nombre
select * 
from productos 
where lower(nombre) like '%social%';


JOIN productos pr ON a.idproducto = pr.idproducto
AND a.idorigenp = pr.idorigen 


https://www.youtube.com/watch?v=rGPb5E1UAJA