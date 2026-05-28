--UBICAMOS EL FORMATO
SELECT nombre,dato1,dato3,dato4,dato5 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';

--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';

--ACTALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';

----- EXTRAEMOS LA INFORMACION A UN ARCHIVO-----
SELECT dato2 
FROM tablas 
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';