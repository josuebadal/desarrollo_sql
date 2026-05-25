--UBICAMOS EL FORMATO
SELECT nombre,dato1,dato3,dato4,dato5 
FROM tablas 
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';

--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';

--ACTALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';

----- EXTRAEMOS LA INFORMACION A UN ARCHIVO-----
SELECT dato2 
FROM tablas 
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';



Buenas tardes
solo son en los productos de ahorro 
idorigen           | 10101
idgrupo            | 10
idsocio            | 20121

010101-112-6750

SELECT nombre,dato1,dato2,dato3,dato4,dato5 
FROM tablas 
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';
   

