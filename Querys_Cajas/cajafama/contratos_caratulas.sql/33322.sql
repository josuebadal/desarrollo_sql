base:fama30jun25_soporte  
producto 33322
ori 30550
aux 200
contrato_crediauto_restructura
OGS de socio : 
30505-10-559368
En el modulo de aperturas encontraran que ya cuenta con el producto aperturado con el estatus de Autorizado.
Quedamos atentos ante cualquier comentario.

33312 -159  (CrediAuto Pagos fijos)
30503-10-338029

/* QUERYS CORRECTOS PARA ACTUALIZAR*/
--PAGARE
SELECT dato2 from tablas
WHERE idtabla = 'lista_pagares'
AND idelemento = 'pagare_general_3';

UPDATE tablas
SET dato2 = '33302|33312|33322'
WHERE idtabla = 'lista_pagares'
AND idelemento = 'pagare_general_3';

--SOLICITUD
SELECT dato2 from tablas
WHERE idtabla = 'param'
AND idelemento = 'productos_sol_prestamo_html';

UPDATE tablas
SET dato2 = '30302|30303|31802|30803|30402|30412|33202|33212|30502|30702|33402|33112|33312|33322|33302|33102|33112|30112|30102|32602|33602|33612|33702|33712|33801|32702'
WHERE idtabla = 'param'
AND idelemento = 'productos_sol_prestamo_html';