SELECT DISTINCT ON --(r.idorigen, r.idgrupo, r.idsocio)
        (a.idorigenp, a.idproducto, a.idauxiliar)
        TRIM(TO_CHAR(r.idorigenr,'099999'))||'-'||
        TRIM(TO_CHAR(r.idgrupor,'09'))||'-'||
        TRIM(TO_CHAR(r.idsocior,'099999')) AS "cuenta",
        TRIM(p.nombre||' '||p.appaterno||' '||p.apmaterno) AS "nombre",
        TRIM(p.calle) as "calle",
        col.nombre as "colonia",
        mun.nombre as "ciudad",
        col.codigopostal as "cp",
        'NA' AS "delegacion",
        est.nombre as "estado",
        (select descripcion from catalogo_menus cat
              where menu = 'referenciap' 
              and opcion = r.tiporeferencia
              AND r.tiporeferencia in (8,0,1,6,7,9,11,12,13,14,15,16,21)) 
              as "relacion",
        COALESCE(p.curp,'NA') AS "curp",
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
        COALESCE(NULLIF(p.entrecalles,''),'No Capturado')  AS "Entre_Calle_A",
        '' AS "Entre_Calle_B" 
        FROM referencias r
INNER JOIN personas p ON (p.idorigen = r.idorigenr AND p.idgrupo = r.idgrupor AND p.idsocio = r.idsocior)
INNER JOIN colonias as col on p.idcolonia=col.idcolonia
INNER JOIN municipios as mun on col.idmunicipio =mun.idmunicipio
INNER JOIN estados as est on mun.idestado=est.idestado
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