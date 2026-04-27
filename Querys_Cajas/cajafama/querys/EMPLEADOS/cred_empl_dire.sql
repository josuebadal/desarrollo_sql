SELECT TRIM(TO_CHAR(s.idorigen,'099999'))||'-'||TRIM(TO_CHAR(s.idgrupo,'09'))||'-'||TRIM(TO_CHAR(s.idsocio,'099999')) AS "Socio",
(select nombre_x(p.appaterno,p.apmaterno,p.nombre) from personas p where p.idorigen = s.idorigen and p.idgrupo = s.idgrupo and p.idsocio = s.idsocio) as "Nombre",
s.puesto AS "Puesto",
TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Folio",
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
        AND a.fechaactivacion::date 
        BETWEEN @@Fecha Ini:|f|01/01/2025@@ 
        AND @@Fecha Fin:|f|31/03/2025@@
ORDER BY s.idorigen,s.idgrupo,s.idsocio
;
