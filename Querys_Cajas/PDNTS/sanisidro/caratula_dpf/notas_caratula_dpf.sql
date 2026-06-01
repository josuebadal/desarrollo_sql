--UBICAMOS EL FORMATO
SELECT idtabla,idelemento,nombre,dato1,dato3,dato4,dato5 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';

--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';

--ACTALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';

----- EXTRAEMOS LA INFORMACION A UN ARCHIVO-----
SELECT dato2 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';


producto 200
socio 31001 - 10 - 3357