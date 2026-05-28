BASE DE TRABAJO: nueveagosto30abr26_movimientos

OGS: 010401-10-105548
Nombre: Miriam Razo Vega
OPA:010411-33101-00000023

OGS: 010413-10-105009
NOMBRE: Adrian Martinez Mendoza
OPA: 010413-33201-00000073

OGS: 010420-10-115856
NOMBRE: Juan Jose Daniel Figueroa Palacios
OPA: 010420-33301-00000006

33101: semanal      --SI SALE ANTES DEL CAMBIO
33201:catorcenal    --SI SALE ANTES DEL CAMBIO
33301:quincenal     --SI SALE ANTES DEL CAMBIO
33401:mensual.      --SI SALE ANTES DEL CAMBIO

UPDATE tablas
set tipo = -456
where idtabla ='param' and idelemento ='formato_caratula_prestamo';

UPDATE tablas
set tipo = 0
where idtabla ='param' and idelemento ='formato_caratula_prestamo';

UPDATE tablas
set dato2 =''      
where idtabla ='param' and idelemento ='formato_caratula_prestamo';