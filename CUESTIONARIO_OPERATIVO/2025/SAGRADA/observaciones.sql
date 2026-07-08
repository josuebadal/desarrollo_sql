----- DEBIDO A QUE NO SE TUBO RESPUESTA SE GENERA LO SIGUIENTE

-----PRODUCTOS DE CAPTACION
select idproducto, nombre 
from productos 
where cuentaaplica LIKE '201%';

-----PRODCUTOS DEL TIPO PRESTAMO
select idproducto, nombre 
from productos 
where tipoproducto = 2;