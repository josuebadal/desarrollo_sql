-----COMO SE CORRE ESE REGULATORIO???
vamos a ejecutar el archivo :
r_451cartera_a_tabla

Crea una tabla:
regulatorio_451

se consulta de la siguiente manera:
SELECT * FROM regulatorio_451;

nota agrega 30356 registros para validar los cambios 

--AL TENER ESA TABLA TEMPORAL PUEDO SACAR LOS DATOS MAS RAPIDO 
30119,10,156651

--NAA) NOMBRE COMPLETO de la empresa 
--NAB) ACTIVIDAD ECONOMICA de la empresa 
--C) ACT ECO DEL ACREDITADO
D) OGS QUE CONFORMA EL RIESGO COMUN
--EXTRA NOMBRE GRC
--E) INGRESOS DECLARADOS POR EL SOCIO 
-- F) INGRESOS COMPROBADOS POR EL SOCIO 
--G) PERIODICIDAD DE LOS INGRESOS DEL SOCIO 
--H) DOCUMENTO PARA ACREDITAR INGRESOS
I) NOMBRE DEL AVAL U OBLIGADO SOLIDARIO
J) OGS AVAL U OBLIGADO SOLIDARIO


select nombre_x(p.appaterno,p.apmaterno,p.nombre)
from personas as p 
LEFT JOIN regulatorio_451 as rpg on rpg.idorigen = p.idorigen and rpg.idgrupo = p.idgrupo and rpg.idsocio = p.idsocio 
;

select nombre_grupo,idorigen,idgrupo,idsocio,
consanguineidad::text||' ('||(select descripcion 
from catalogo_menus 
where menu = 'referenciap' 
and opcion = x.consanguineidad)||')' as  consanguineidad,
dependencia::text||' ('||(select descripcion 
from catalogo_menus 
where menu = 'referenciap' 
and opcion = x.dependencia)||')' as dependencia ,
fecha_registro,fecha_baja 
from grupos_riesgo_comun x order by nombre_grupo;