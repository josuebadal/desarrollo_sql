--UBICAMOS EL FORMATO
SELECT nombre,dato1,dato3,dato4,dato5 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

--ACTALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';

----- EXTRAEMOS LA INFORMACION A UN ARCHIVO-----
SELECT dato2 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';


producto 110
socio 31001 - 10 - 3357