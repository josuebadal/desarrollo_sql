
--CONSULTA CON MODIFICACIONES SE AGREGA RANGO DE FECHA

select pe.fecha as "Fecha_Hora_Movimiento",
       substr(p.idorigen::text,4,2)||'-'||p.idgrupo::text||'-'||trim(to_char(p.idsocio,'099999'))||'  '||
       nombre_x(p.nombre,p.appaterno,p.apmaterno) as "Socio Ganador",
       substr(a.idorigenp::text,4,2)||'-'||trim(to_char(a.idproducto,'09999'))||'-'||trim(to_char(a.idauxiliar,'09999999')) as "Cuenta Ganadora",
       (select replace(idelemento,'premio','')||'-'||substr(dato2,1,20)
       from   tablas
       where  idtabla = 'sorteo_electronico' and idelemento like 'premio'||trim(to_char(pe.idpremio,'09'))) as "Premio",
       pe.num_boleto as "Num Boleto Rifa"
       from   premios_e pe
       inner join premios_h  ph using(fecha,idorigenp,idproducto,idauxiliar)
       inner join auxiliares  a using(idorigenp,idproducto,idauxiliar)
       inner join personas    p on (p.idorigen,p.idgrupo,p.idsocio) = (a.idorigen,a.idgrupo,a.idsocio)
where  date(pe.fecha) BETWEEN (@@Fecha ini:|f|04/08/2023@@) AND (@@Fecha fin:|f|04/09/2023@@)
and ph.idtipo = 3 
and pe.idorigen != 20701 and ph.idorigenc=20701;

--Nota el origen 20701 es para banca movil y se encontraba desactivado por lo cual no le salia informacio

select pe.fecha as "Fecha_Hora_Movimiento",
       substr(p.idorigen::text,4,2)||'-'||p.idgrupo::text||'-'||trim(to_char(p.idsocio,'099999'))||'  '||
       nombre_x(p.nombre,p.appaterno,p.apmaterno) as "Socio Ganador",
       substr(a.idorigenp::text,4,2)||'-'||trim(to_char(a.idproducto,'09999'))||'-'||trim(to_char(a.idauxiliar,'09999999')) as "Cuenta Ganadora",
       (select replace(idelemento,'premio','')||'-'||substr(dato2,1,20)
       from   tablas
       where  idtabla = 'sorteo_electronico' and idelemento like 'premio'||trim(to_char(pe.idpremio,'09'))) as "Premio",
       pe.num_boleto as "Num Boleto Rifa"
       from   premios_e pe
       inner join premios_h  ph using(fecha,idorigenp,idproducto,idauxiliar)
       inner join auxiliares  a using(idorigenp,idproducto,idauxiliar)
       inner join personas    p on (p.idorigen,p.idgrupo,p.idsocio) = (a.idorigen,a.idgrupo,a.idsocio)
where  date(pe.fecha) BETWEEN (@@Fecha ini:|f|04/08/2023@@) AND (@@Fecha fin:|f|04/09/2023@@)
and ph.idtipo = 3 ;

/*
Se desea asignar una nueva cantidad de premios a la tabla premios_a
para ello es necesario crear una copia de la tabla y nombrar como premios_a_agosto

En la tabla premios_a hay 18 y en premios_e premios entregados hay 10 se deberan restar
y se sumara la cantidad del layaout proporcionado por ellos dando un total 22 premios_a_agosto
por lo cual el resultado seran (18-10) + 22 = 30

para pruebas usamos el BEGIN para no perder la informacion de la tabla y validar unas pruebas
si sale erroneo se usa ABORT y es es correcto de aplica con COMMIT

Antes de actualizar usar un 
BEGIN; 
en caso de error se debera usar
ABORT;

SELECT * INTO premios_a_agosto FROM premios_a;
DELETE FROM premios_a_agosto;
copy premios_a_agosto from '/tmp/layout_premios_asignados.csv' delimiter '|';




DELETE  FROM premios_a_agosto;
*/
BEGIN;

SELECT * INTO premios_a_agosto FROM premios_a; --se selecciona toda la estructura de la tabla premios_a
DELETE FROM premios_a_agosto; --borramos los datos que vienen de la tabla original premios_a
copy premios_a_agosto from '/tmp/layout_premios_asignados.csv' delimiter '|'; --insertamos los datos del layout previamente cargado en el tmp de mi servidor

UPDATE premios_a AS a1
SET asignados = (a1.asignados - a1.entregados) + a2.asignados --operacion aritmetica
FROM premios_a_agosto AS a2
WHERE a1.idorigen = a2.idorigen 
AND a1.idpremio = a2.idpremio;

ABORT;
COMMIT;


-- se validan los resultados de la tabla =30 
SELECT * FROM premios_a 
WHERE idorigen = 20702
ORDER BY idorigen, idpremio
limit 5;

SELECT * FROM premios_a_agosto 
WHERE idorigen = 20702
ORDER BY idorigen, idpremio
limit 5;


Buen dia
Adjunto un archivo csv con los datos a actualizar para los --premios asignados
las columnas del archivo son: --idorigen, idpremio, cantidad premios asignados
Como dato relevante, para esta carga --NO se debe poner en cero la columna entregados 
de la tabla, solo necesitamos que se actualice la columna
de asignados.

si se necesita mas informacion favor de comunicarse conmigo.

Cel: 999-2335-873

saludos

BEGIN;

SELECT * INTO premios_a_agosto FROM premios_a; --se selecciona toda la estructura de la tabla premios_a
DELETE FROM premios_a_agosto; --borramos los datos que vienen de la tabla original premios_a
copy premios_a_agosto from '/tmp/layout_premios_asignados.csv' delimiter '|'; --insertamos los datos del layout previamente cargado en el tmp de mi servidor

UPDATE premios_a AS a1
SET asignados = a2.asignados --operacion aritmetica
FROM premios_a_agosto AS a2
WHERE a1.idorigen = a2.idorigen 
AND a1.idpremio = a2.idpremio;

ABORT;