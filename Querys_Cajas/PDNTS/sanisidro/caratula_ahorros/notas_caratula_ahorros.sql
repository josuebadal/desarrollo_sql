--UBICAMOS EL FORMATO
SELECT nombre,dato1,dato3,dato4,dato5,tipo
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

--ACTUALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

----- EXTRAEMOS LA INFORMACION A UN ARCHIVO-----
SELECT dato2 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

----- DATOS DE SOCIO A CONSULTAR
Buen dia, socio 31001-10-3357 
opa producto 110 31001-110-2588
opa producto 130 31001-130-1120
opa producto 200 31001-200-1014073


-----DATOS DEL SOCIO 
RECA ACTUAL PROD 110 > 5021-003-008988/09-01751-0724 
NO. RECA NUEVO PROD 110 >  5021-003-008988/10-01065-0526

RECA ACTUAL PROD 130 > 5021-003-012959/07-04810-1122 
NO. RECA NUEVO PROD 130 >  5021-003-012959/08-01066-0526

RECA ACTUAL PROD 200 > 5021-003-015025/05-00969-0217
NO. RECA NUEVO PROD 200 >  5021-003-015025/07-01067-0526