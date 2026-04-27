/*Necesito lo siguiente, relacion de creditos otorgados en un periodo determinado a empleados y directivos de la cooperativa.
Que el reporte tenga la posibilidad de capturar el periodo y que contenga los siguientes campos:
--Numero de socio
--Nombre
Puesto
--Folio del prestamo entregado
--Fecha de entrega
--Estatus
--Monto entregado
--Saldo actual
--Plazo 
AND p.fechaingreso 
            between @@Fecha Ini:|f|01/01/2025@@ 
            AND @@Fecha Fin:|f|31/03/2025@@ 

empleados
diryemp

select * 
    from tablas td 
    where td.idtabla = 'catalogo_departamentos'

    and td.idelemento = lower(s.departamento 
*/

select * 
    from   sopar s 
    inner join tablas td 
    on (td.idtabla = 'catalogo_departamentos' 
    and td.idelemento = lower(s.departamento)) 
    inner join tablas tp 
    on (tp.idtabla = 'catalogo_puestos'  
    and tp.idelemento = lower(s.puesto)) 
    where  s.tipo = 'diryemp'
--nombre_x((SELECT p.appaterno,p.apmaterno,p.nombre from personas p where 
--s.idorigen = p.idorigen AND s.idgrupo = p.idgrupo AND s.idsocio = p.idsocio) ) AS "Nombre",


SELECT s.idorigen||'-'||s.idgrupo||'-'|| s.idsocio AS "Socio",
(select nombre_x(p.appaterno,p.apmaterno,p.nombre) from personas p where p.idorigen = s.idorigen and p.idgrupo = s.idgrupo and p.idsocio = s.idsocio) as "Nombre",
s.puesto AS "Puesto",
a.idorigenp ||'-'||a.idproducto||'-'||a.idauxiliar AS "Folio",
a.fechaactivacion AS "Fecha Entrega",
a.cartera AS "Estatus",
a.montoprestado AS "Monto Entregado",
a.saldo AS "Saldo Actual",
a.plazo AS "Plazo"
FROM sopar s
    INNER JOIN auxiliares a  
        ON      a.idorigen      = s.idorigen
        AND     a.idgrupo       = s.idgrupo
        AND     a.idsocio       = s.idsocio
    INNER JOIN tablas tp 
    on (tp.idtabla = 'catalogo_puestos'  
    and tp.idelemento = lower(s.puesto)) 
WHERE a.idproducto BETWEEN 30000 AND 39999
        AND a.estatus in (1,2,3)
ORDER BY s.idorigen,s.idgrupo,s.idsocio
;
