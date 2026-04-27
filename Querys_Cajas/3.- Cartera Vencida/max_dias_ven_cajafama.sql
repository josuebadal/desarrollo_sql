/*
OGS
Historial de creditos (OPA)
Fecha de ingreso (Antiguedad en Cooperativa)
Maximo de dias vencidos por OPA */

SELECT 
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'|| TRIM(TO_CHAR(a.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(a.idsocio,'099999')) AS "socio",
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "nombre", p.fechaingreso as "ingreso",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "opa", 
MAX(bc.diasvencidos) AS "dias_ven", bc.fechaprest, bc.montoprest, bc.periodo
FROM auxiliares as a  
LEFT JOIN balancecred as bc 
ON a.idorigenp = bc.idorigenp AND a.idproducto = bc.idproducto AND a.idauxiliar = bc.idauxiliar
LEFT JOIN auxiliares_h as ah 
ON a.idorigenp = ah.idorigenp AND a.idproducto = ah.idproducto AND a.idauxiliar = ah.idauxiliar
INNER JOIN personas as p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
where  a.estatus IN (2,3) AND bc.periodo BETWEEN '202501' AND '202502'
--AND bc.diasvencidos >0 
GROUP BY a.idorigen, a.idgrupo, a.idsocio, p.appaterno, p.apmaterno, p.nombre, p.fechaingreso, a.idorigenp, a.idproducto, a.idauxiliar, bc.fechaprest, bc.montoprest, bc.periodo
ORDER BY a.idorigen, a.idgrupo, a.idsocio;


---------- VERSION PARA SAICOOP ----------
SELECT 
TRIM(TO_CHAR(a.idorigen,'099999'))||'-'|| TRIM(TO_CHAR(a.idgrupo,'09'))||'-'|| TRIM(TO_CHAR(a.idsocio,'099999')) AS "socio",
nombre_x(p.appaterno, p.apmaterno, p.nombre) as "nombre", p.fechaingreso as "ingreso", 
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(a.idproducto,'09999'))||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "opa", 
MAX(bc.diasvencidos) AS "dias_ven", bc.fechaprest, bc.montoprest, bc.periodo
FROM auxiliares as a  
LEFT JOIN balancecred as bc 
ON a.idorigenp = bc.idorigenp AND a.idproducto = bc.idproducto AND a.idauxiliar = bc.idauxiliar
LEFT JOIN auxiliares_h as ah 
ON a.idorigenp = ah.idorigenp AND a.idproducto = ah.idproducto AND a.idauxiliar = ah.idauxiliar
INNER JOIN personas as p
ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo AND a.idsocio = p.idsocio
where  a.estatus IN (2,3) AND bc.periodo BETWEEN @@Periodo ini:|c|202502@@ AND @@Periodo fin:|c|202502@@ 
--AND bc.diasvencidos >0 
GROUP BY a.idorigen, a.idgrupo, a.idsocio, p.appaterno, p.apmaterno, p.nombre, p.fechaingreso, a.idorigenp, a.idproducto, a.idauxiliar, bc.fechaprest, bc.montoprest, bc.periodo
ORDER BY a.idorigen, a.idgrupo, a.idsocio;