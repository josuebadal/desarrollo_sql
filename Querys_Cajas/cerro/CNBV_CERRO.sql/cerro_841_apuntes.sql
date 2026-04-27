-----LOS CAMBIOS SE HICIERON EN LA FUNCION VIEJA DEBEMOS USAR LA VERSION DEL 12 DE JUN DE GABY
--EL TYPE YA ESTA DENTRO DE LA FUNCION
--SE DEBERA CORRER LA FUNCION NUEVAMENTE
select reg_841cerro();

--SE VALIDA LA TABLA CREADA PARA LA FUNCION
 SELECT * FROM regulatorio841;

--SE VALIDA PRODUCTOS A PLAZO FIJO
SELECT numero_de_cuenta,nombre_producto,idorigen,idgrupo,idsocio   FROM regulatorio841 where LOWER(nombre_producto) LIKE 'depo%'
--AND numero_reinversiones::NUMERIC >0
;


---TABLA TRABAJOS
OGS 
actividad_economica     | 61131
ocupacion_numero        | 136

--TABLA ACTIVIDADES_ECONOMICAS
t.actividad_economica = id_actividad | 61131
idrecursivo  | 474   el rango que ocupo para validar 

WHEN acte.idrecursivo between 1     AND 67  THEN 'Agricola'
WHEN acte.idrecursivo bweteen 68    AND 134 THEN 'Explotacion,Energia y Construccion'
WHEN acte.idrecursivo bweteen 135   AND 260    THEN 'Comercio'
WHEN acte.idrecursivo bweteen 261   AND 662  THEN 'Servicios'
ELSE 'sin clasificacion' END 

select distinct(nivel_riesgo) from personas ;
nivel_riesgo 
--------------
            9 falta informacion 
            1 bajo
            2 alto riesgo 
            0 sin asginador


lista_personas_bloqueadas_cnbv


Validar si existe dentro de esta lista sopar 

select * from sopar 
where tipo = 'lista_personas_bloqueadas_cnbv';

---------------------------VALIDAR LAS INVERSIONES------------------------------
SELECT rg.idorigen||','|| rg.idgrupo||','|| rg.idsocio as socio, a.idorigenp||','||a.idproducto||','||a.idauxiliar as opa
FROM regulatorio841 rg
inner join auxiliares a on rg.idorigen::integer = a.idorigen 
                     and rg.idgrupo::integer  = a.idgrupo
                     and rg.idsocio::integer  = a.idsocio
WHERE nombre_producto = 'Depositos a Plazo Fijo'
AND a.idproducto = 200 and a.estatus = 2 
order by a.idorigenp, a.idproducto, a.idauxiliar;

select * from numero_reinversiones_focoop(30401,200,30690);


select idorigenp,idproducto,idauxiliar
from auxiliares 
where idproducto = 200 and estatus = 2 and elaboro = 999
order by idorigenp;

-----DATOS DE PRUEBA PARA SOCIO EN LA BASE DE NOVIEMBRE PARA CERRO
--OGS 30401,10,383
--OPA:30401,200,30632
--select * from numero_reinversiones_focoop(30401,200,30632);


\i '/tmp/numero_inversiones_v5.sql'



select * from prd_captacion;
select * from tablas where idtabla = 'claves_reg841' and idelemento = 'productos_captacion';


UPDATE tablas
set dato2 = 200
where idtabla = claves_reg841 and idelemento = 'productos_captacion
' and tipo = 0;


conectarse al 99.200 del home/eliseo y usar el conc_captacion.sql 

erro30nov25_movimientos=# \i conc_captacion.sql 
    idcuenta    |                    nombre                    | saldo_final  | saldo_socios |   garantia   |          producto          | diferencia 
----------------+----------------------------------------------+--------------+--------------+--------------+----------------------------+------------
 20100000000000 | CAPTACION TRADICIONAL                        | 491,933,062.94 |              |              |                            |           
 20101000000000 | DEPOSITOS DE EXIGIBILIDAD INMEDIATA          | 415886268.74 |              |              |                            |           
 20101010000000 | DEPOSITOS A LA VISTA                         |   8346587.56 |              |              |                            |           
 20101010100000 | Sin intereses                                |   8346587.56 |              |              |                            |           
 20101010101000 | Dep�sitos libres de gravamen                 |   8346587.56 |              |              |                            |           
 20101010101001 | Cuenta Corriente                             |   8346587.56 |   8,346,587.56 |         0.00 | 130-CUENTA CORRIENTE ***      |       0.00
 20101020000000 | DEPOSITOS DE AHORRO                          | 407539681.18 |              |              |                            |           
 20101020100000 | Dep�sitos libres de gravamen                 |   5250069.17 |              |              |                            |           
 20101020101000 | Dep�sitos libres de gravamen                 |   5250069.17 |              |              |                            |           
 20101020101001 | Ahorro de Menor                              |   5250069.17 |   5,250,069.17 |         0.00 | 120-AHORRO MENOR  ***         |       0.00
 20101020200000 | Dep�sitos que amparan cr�ditos otorgados     | 402289612.01 |              |              |                            |           
 20101020201000 | Dep�sitos que amparan cr�ditos otorgados     | 402289612.01 |              |              |                            |           
 20101020201001 | Ahorro de Mayor                              | 402289612.01 | 402,289,612.01 | 116,797,197.81 | 110-AHORRO                 |       0.00
 20102000000000 | DEPOSITOS A PLAZO                            |  74514047.84 |              |              |                            |           
 20102020000000 | OTROS DEPOSITOS A PLAZO                      |  74514047.84 |              |              |                            |           
 20102020100000 | Dep�sitos libres de gravamen                 |  74514047.84 |              |              |                            |           
 20102020101000 | Dep�sitos libres de gravamen                 |  74514047.84 |              |              |                            |           
 20102020101001 | Dep�sitos a Plazo 28 Dias libres de gravamen |  74022152.72 |  74,022,152.72 |     95789.30 | 200-Depositos a Plazo Fijo |       0.00
 20102020101004 | Interes                                      |    491895.12 |              |              |                            |           
 20103000000000 | CUENTAS SIN MOVIMIENTO                       |   1532746.36 |              |              |                            |           
 20103010000000 | Cuentas sin movimiento                       |   1532746.36 |              |              |                            |           
 20103010100000 | Cuentas sin movimiento                       |   1532746.36 |              |              |                            |           
 20103010101000 | Cuentas sin movimiento                       |   1532746.36 |              |              |                            |           
 20103010101001 | Haberes de Ex menores                        |   1450608.02 |   1,450,608.02 |         0.00 | 121-Exmenores  ***            |       0.00
 20103010101002 | Haberes de Ex mayores                        |     82138.34 |     82,138.34 |         0.00 | 197-Haberes de Ex mayores****  |       0.00


SALDO EN EL REPORTE 419,043,557.95
SALDO EN CAPTACION  491,933,062.94
DIFERENCIAS DE = 72,889,504.99  el reporte vizualiza menos


select count(idproducto) from regulatorio841 where idproducto = 130 and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;


---CONSULTAS ELISEO
SELECT count(1) AS c, sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) AS saldos 
FROM regulatorio841 
WHERE idproducto = 130 
AND saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
--resultado
c      | 2348
saldos | 8346587.56


SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 130 
AND saldo > 0;
c      | 2348
saldos | 8346587.56

---PRODUCTOS QUE SI CUADRAN, DATOS OBTENIDO CON LA VERSION ANTES DE TENER MODIFICACIONES, DEBERE VALIDAR CON LA NUEVA
130,120,121,197
regulatorio841_mensual


---CONSULTAS BADAL PARA 130 
select count(1), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 130 
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0; 
count | 2348
sum   | 8346587.56

--VERSION CON COLUMNAS EXTRA NO CUADRA
c      | 2415
saldos | 8496926.07


---CONSULTAS BADAL PARA 120 
select count(1), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 120 
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
-[ RECORD 1 ]-----
count | 1516
sum   | 5250069.17
--VERSION CON COLUMNAS EXTRA SI CUADRA
SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 120 
AND saldo > 0;

count | 1516
sum   | 5250069.17


---CONSULTAS BADAL PARA 121
select count(1), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 121 
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
-[ RECORD 1 ]-----
count | 4528
sum   | 1450608.02
--VERSION CON COLUMNAS EXRTA SI CUADRA
SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 121
AND saldo > 0;
count | 4528
sum   | 1450608.02


---CONSULTAS BADAL PARA 197
select count(1), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 197 
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
-[ RECORD 1 ]---
count | 335
sum   | 82138.34
--VERSION CON COLUMNAS EXTRA SI CUADRA
SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 197
AND saldo > 0;
count | 335
sum   | 82138.34



---SUMATORIA DE SALDO GENERAL FINAL DEL PERIODO
select count(1), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
count | 29465
sum   | 411658301.53
--VERSION CON COLUMNAS EXTRA
count | 29929
sum   | 419043557.95


---COLUMNAS QUE NO CUADRAN 
110,200
select count(idproducto), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 110 
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
count | 20079
sum   | 322204443.98
--VERSION CON COLUMNAS EXTRA
SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 110
AND saldo > 0;
count | 20471
sum   | 328472041.62


select count(idproducto), sum(saldo_de_la_cuenta_al_final_del_periodo::decimal) 
from regulatorio841 
where idproducto = 200
and saldo_de_la_cuenta_al_final_del_periodo::decimal > 0;
count | 659
sum   | 74324454.46
--VERSION CON COLUMNAS EXTRA
SELECT count(1) AS c, sum(saldo) AS saldos 
FROM auxiliares 
WHERE idproducto = 200
AND saldo > 0;
count | 664
sum   | 75291774.73
