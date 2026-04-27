(case when finalidad.dependede=1 then 'Consumo' 
                                          when f.dependede=2 then 'Comercial' 
                                          when f.dependede=3 then 'Vivienda' 
                                          when f.dependede=0 then '(*)' end) "FINALIDAD",

---CUANTO NO SALE UN DATO EN UNA TABLA 
ndices:io  | integer  
--se aplica lo siguiente 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'polizas';

--pobremos ver que tipo de dato es el correcto
column_name | idusuario
data_type   | integer

--Configuraciones para el contrato de pagare de algunas cajas
UPDATE tablas
SET dato2 = '33302|33312|33322'
where idtabla = 'lista_pagares' and idelemento = 'pagare_general_3';

--Configuraciones para la solicitud de prestamo de un producto
UPDATE tablas
SET dato2 = '30302|30303|31802|30803|30402|30412|33202|33212|30502|30702|33402|33112|33312|33302|33102|33112|30112|30102|32602|33602|33612|33702|33712|33801|32702|33322'
where idtabla = 'param' and idelemento = 'productos_sol_prestamo_html';

--Maneras de usar la funcion de nombre, como subconsulta
1.- (select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) as nombre_socio,

--Trayendolos directo de la tabla personas
2.-nombre_x(nombre,appaterno,apmaterno)

--CORRER UNA FUNCION DESDE TERMINAL
\i + arrastrar el archivo a la terminal
--poner la ruta en terminal es mas tardado
\i '/home/jjbadal/Documentos/REGULATORIOS/841new.sql'
--Despues de cargarla se ejecuta con los () vacios pues obtiene toda la info del sistema
select * from reg_841();

--ACTUALIZAR PAGARE Y SOLICITUD NO APLICA TODAS LAS CAJAS
UPDATE tablas
SET dato2 = '33302|33312|33322'
where idtabla = 'lista_pagares' and idelemento = 'pagare_general_3';
 
UPDATE tablas
SET dato2 = '30302|30303|31802|30803|30402|30412|33202|33212|30502|30702|33402|33112|33312|33302|33102|33112|30112|30102|32602|33602|33612|33702|33712|33801|32702|33322'
where idtabla = 'param' and idelemento = 'productos_sol_prestamo_html';


/* LIKES se recomienda usar lower o UPPER para una mejor busqueda, no todo tiene CAMELLCASE*/
select nombre from productos where idproducto in(30102,30202,32602,32702,31802);
select * from split_part(sai_auxiliar(30214,36644,1344,date('13/05/2025')),'|',4);
select nombre from productos;
select * from productos where lower(nombre) like '%capital%';
select * from productos where lower(nombre) like '%social%';
select * from productos where tipoproducto=0;
select nombre from productos where tipoproducto=0;
select nombre,idproducto from productos where tipoproducto=0;
select saldo from auxiliares where idproducto = 101 and estatus=2 order by fechaactivacion desc;

TO_DATE(’aux.fecha’,’DD/MM/YYYY’)

/* MANERA DE USAR UN OR DENTRO DE UN WHERE QUE SI O SI DE CUMPLAN*/
AND (UPPER(aux.cartera) = 'M' OR UPPER(aux.cartera) = 'V')
AND (LOWER(tbj.puesto) like '% uber %' 
OR LOWER(tbj.puesto) like '%didi%'
OR LOWER(tbj.puesto) like '%rappi%'  
OR LOWER(tbj.puesto) like '%taxi%' )

/*EXTRAER AÑOS DE INGRESO DEL SOCIO*/
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,p.fechaingreso )) > 3

--DONDE SE UBICAN LOS QUERYS EN SAICOOP
select * from notas where idnota like 'mireporte%138%' and nota like '%@@%';


/*saber que tipo de datos me trae cada elementos*/
SELECT
    pg_typeof(socio.idorigen || ' ' || socio.idgrupo || ' ' || socio.idsocio) AS tipo_ogs,
    pg_typeof(socio.fechaingreso) AS tipo_fechaingreso,
    pg_typeof(socio.nombre || ' ' || socio.appaterno || ' ' || socio.apmaterno) AS tipo_socio,
    pg_typeof(credito.idorigenp || ' ' || credito.idproducto || ' ' || credito.idauxiliar) AS tipo_producto,
    pg_typeof(aux.estatus) AS tipo_rev_lib_activo,
    pg_typeof(split_part(sai_auxiliar(credito.idorigenp, credito.idproducto, credito.idauxiliar, date('2025-05-13')), '|', 4)) AS tipo_dato_split,
    pg_typeof(aux.saldo) AS saldo_dato
FROM 
    personas socio
JOIN socioeconomicos casa ON socio.idsocio = casa.idsocio
JOIN prestamos credito ON credito.idsocio = socio.idsocio
JOIN auxiliares aux ON aux.idsocio = socio.idsocio
WHERE 
    socio.idgrupo = 10
LIMIT 1;


--OBTENER DATOS DE UNA FUNCION***
SELECT sai_auxiliar(30214,36644,1344,date('13/05/2025'));

Genera:
2|31/03/2025|2.00|33|1334.58|33|6788.20|0.00|10/12/2029|157.81|13/05/2025|654.36|4484.55|M|0|157.81|09/08/2025|1086.11|25.25|0.00|0.00|0.00|33|0|f|t
(1 fila)

split_part(cadena,'|', lugar)
select * from split_part(sai_auxiliar(30214,36644,1344,date('13/05/2025')),'|',4);
se requiere el dato 33 en el lugar 4


select * from split_part(sai_auxiliar(30214,36644,1344,date('13/05/2025')),'|',4);


CAST(coalesce(<column>, '0') AS integer)
select saldo from auxiliares where idproducto = 101 and estatus=2;
select pg_typeof(saldo) AS tipo from auxiliares where idproducto = 101 and estatus=2
LIMIT 1;




-- buscar una tabla en la bd
SELECT * FROM tablas WHERE (LOWER(idtabla)='texto_contratos' OR LOWER(idtabla)='texto_html_contratos') AND idelemento='ahorro_110_contrato'

-- hacer un update a los datos de una tabla
UPDATE texto_contratos
set dato2 'TEXTO CONTRATO kkkk'
WHERE idtabla = 'ahorro_110_contratos'



UPDATE TELEFONO SET PRECIO = 99 WHERE PRECIO = 49;
UPDATE TELEFONO SET PRECIO = 99 WHERE PRECIO > 19 AND PRECIO < 100;
-- en el SET se pueden poner cuantos datos se requieran separados por una coma con su respectiva iformacion a actualizar
UPDATE <nombre tabla> SET <nombre columna 1> = <valor 1>,
<nombre columna 2> = <valor 2>,
<nombre columna 3> = <valor 3>,
WHERE ...AND... ;

https://www.youtube.com/watch?v=vherxh5ypiY

--VALDACION CON SUBCONSULTA PARA BUSCAR DATOS EN UN INTERVALO DE TIEMPO 
AND a.fechauma <= ((select distinct date(fechatrabajo) from origenes limit 1) - INTERVAL '1 years')
-- CONSULTA PARA SABER QUE SOCIOS TIENES MENOS DE 6 MESES

select idorigen,idgrupo,idsocio,fechaingreso
from personas
where idorigen > 0 
    and idgrupo = 10 
    and idsocio > 0 
    and (select distinct saldo from auxiliares
        where idorigen = personas.idorigen 
        and idgrupo = personas.idgrupo 
        and idsocio = personas.idsocio 
        and idproducto = 101 
        and saldo = 1000.0) > 0 
        and fechaingreso > date((select distinct date(fechatrabajo) from origenes) - '6 month'::interval);

-- CONSULTA PARA SABER SI UN SOCIO PAGO O NO EL 50%
select idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar,saldo/montoprestado as x
from auxiliares
where idorigen > 0 
and idgrupo = 10 
and idsocio > 0 
and idproducto in (33044,33064) 
and estatus = 2
order by idorigen,idgrupo,idsocio; 

-- CONSULTA PARA SABER SI UN SOCIO DEBE 6000X/7000X
select idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar,saldo
from auxiliares
where idorigen > 0 
    and idgrupo = 10 
    and idsocio > 0 
    and idproducto in (60001, 60002, 60003, 70001, 70002, 70003) 
    and saldo > 0
order by idorigen,idgrupo,idsocio;


(select COALESCE(p.curp,'NA') from personas p 
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) AS "curp",
        TRIM(TO_CHAR(r.idorigen,'099999'))||'-'||
        trim(to_char(r.idgrupo,'09'))||'-'||
        trim(TO_CHAR(r.idsocio,'099999')) AS "socio",
        (select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigen and idgrupo =r.idgrupo and idsocio = r.idsocio) as "nombre_socio",
        (CASE 
            WHEN r.tiporeferencia = 8  THEN 'Aval'
            WHEN r.tiporeferencia != 8 THEN 'Referencia' 
            END) AS "tipo",
        (CASE 
        WHEN p.telefono IS NULL OR p.telefono = '' 
        THEN COALESCE(NULLIF((SELECT p.telefono
        from personas p where idorigen=r.idorigen 
        and idgrupo =r.idgrupo and idsocio = r.idsocio),''),'0000000000') ||' '||'Tel Referencia'
        ELSE p.telefono ||' '|| 'Tel Aval'
        END )AS "Telefono1",


        (CASE 
        WHEN p.celular IS NULL OR p.celular = '' 
        THEN COALESCE(NULLIF((SELECT p.celular
        from personas p where idorigen=r.idorigen 
        and idgrupo =r.idgrupo and idsocio = r.idsocio),''),'0000000000') ||' '||'Tel Referencia'
        ELSE p.celular ||' '|| 'Tel Aval'
        END )AS "Telefono2",
        (CASE 
        WHEN p.telefonorecados IS NULL OR p.telefonorecados = '' 
        THEN COALESCE(NULLIF((SELECT p.telefonorecados
        from personas p where idorigen=r.idorigen 
        and idgrupo =r.idgrupo and idsocio = r.idsocio),''),'0000000000') ||' '||'Tel Referencia'
        ELSE p.telefonorecados ||' '|| 'Tel Aval'
        END )AS "Telefono3",

----- AGREGAR DATOS EN SAICOOP -----

--La estructura es la siguiente:
 1| texto a mostrar en saicoop 
|2| tipo de datos (puede ser fecha,char,integer)
|3| texto de ejemplo en saicoop 
@@Fecha ini:|f|01/01/2025@@  
AND @@Fecha fin:|f|30/06/2025@@ 

--PARA SAICOOP CON EL DATO DE TIPO NUMERO
@@Periodo ini:|e|202502@@ AND @@Periodo fin:|e|202502@@ 

--PARA SAICOOP CON EL DATO DE TIPO CHAR
@@Periodo ini:|c|202502@@ AND @@Periodo fin:|c|202502@@ 

----- ESTIMACION PREVENTIVA DE RIESGOS EPRC -----

crea_tabla_temporal_eprcc_2(date) --tabla tmporl para cajas
crea_tabla_temporal_eprcc(date)   --tabla tmporl para sofipos