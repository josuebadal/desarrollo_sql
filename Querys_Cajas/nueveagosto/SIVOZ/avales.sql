SELECT DISTINCT ON (a.idorigenp, a.idproducto, a.idauxiliar)
        TRIM(TO_CHAR(r.idorigenr,'099999'))||'-'||
        TRIM(TO_CHAR(r.idgrupor,'09'))||'-'||
        TRIM(TO_CHAR(r.idsocior,'099999')) AS "cuenta",
        (select nombre_x(nombre,appaterno,apmaterno) from personas where idorigen=r.idorigenr and idgrupo =r.idgrupor and idsocio = r.idsocior) AS "nombre",
        (select p.calle from personas p 
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio )AS "calle",
        (select col.nombre from colonias col
            INNER JOIN personas p 
            on p.idcolonia=col.idcolonia  
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) AS "colonia",
        (select mun.nombre from municipios mun
            INNER JOIN colonias col  
            on col.idmunicipio =mun.idmunicipio 
            INNER JOIN personas p 
            on p.idcolonia=col.idcolonia 
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) AS "ciudad",
        (select col.codigopostal from colonias col
            INNER JOIN municipios mun  
            on col.idmunicipio =mun.idmunicipio 
            INNER JOIN personas p 
            on p.idcolonia=col.idcolonia   
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) AS "cp",
        'NA' AS "delegacion",
        (select est.nombre from estados est
            INNER JOIN municipios mun  
            ON mun.idestado = est.idestado
            INNER JOIN colonias col
            ON mun.idmunicipio = col.idmunicipio
            INNER JOIN personas p 
            on p.idcolonia=col.idcolonia 
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) as "estado",
        (select descripcion from catalogo_menus cat
              where menu = 'referenciap' 
              and opcion = r.tiporeferencia
              AND r.tiporeferencia in (8,0,1,6,7,9,11,12,13,14,15,16,21)) 
              as "relacion",
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
        ----
        (select p.telefono from personas p 
            WHERE p.idorigen=r.idorigen 
                and p.idgrupo =r.idgrupo 
                and p.idsocio = r.idsocio ) AS "Telefono1",
        (select p.celular from personas p 
            WHERE p.idorigen=r.idorigen 
                and p.idgrupo =r.idgrupo 
                and p.idsocio = r.idsocio )AS "Telefono2",
        (select p.telefonorecados from personas p 
            WHERE p.idorigen=r.idorigen 
                and p.idgrupo =r.idgrupo 
                and p.idsocio = r.idsocio ) AS "Telefono3",

        (select COALESCE(p.entrecalles,'NA') from personas p 
            WHERE p.idorigen=r.idorigen and p.idgrupo =r.idgrupo and p.idsocio = r.idsocio ) AS "Entre_Calle_A",
        '' AS "Entre_Calle_B" 
        FROM referencias r
    INNER JOIN personas p ON (p.idorigen = r.idorigenr AND p.idgrupo = r.idgrupor AND p.idsocio = r.idsocior)
    INNER JOIN v_auxiliares a ON (split_part(r.referencia,'|',2) = TRIM(TO_CHAR(a.idorigenp,'099999'))
                              AND split_part(r.referencia,'|',3) = TRIM(TO_CHAR(a.idproducto,'09999'))
                              AND split_part(r.referencia,'|',4) = TRIM(TO_CHAR(a.idauxiliar,'09999999')))
    RIGHT JOIN catalogo_menus cat
        ON menu = 'referenciap'
    WHERE r.tiporeferencia in (8) 
        AND p.estatus = 't'
        AND a.estatus= 2
ORDER BY a.idorigenp, a.idproducto, a.idauxiliar DESC 
;   