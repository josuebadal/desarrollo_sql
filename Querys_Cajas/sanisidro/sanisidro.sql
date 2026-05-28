/*SAN ISIDRO SOLICITA UN QUERY DONDE CONTENGA LA SIGUIENTE INFORMACION
ogs             | 031006-10-00001103
nombre          | LEIJA GOMEZ CRISTIAN DARIO
--No. de socio, 
--Nombre, 
--RFC, 
--CURP, 
--Fecha Nacimiento, 
--Lugar Nacimiento,
--Genero, 
--Nacionalidad,
--Pais residencia, 
--Estado residencia, 
Act. economica pld Registrada, 
Grado de riesgo */

 SELECT 
        TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||TRIM(TO_CHAR(p.idsocio,'09999999')) AS ogs,                                           
        nombre_x(p.apmaterno, p.appaterno,p.nombre) AS nombre,
        p.curp,p.rfc,p.fechanacimiento,p.lugarnacimiento,
        (CASE 
            WHEN p.sexo = 2 then 'Femenino'
            WHEN p.sexo = 1 then 'Masculino' ELSE 'ND'
        END) as genero,
        ct.descripcion as nacionalidad,
        ps.nombre as pais_residencia,
        es.nombre as estado_residencia,
        (CASE 
            WHEN acte.idrecursivo BETWEEN 1     AND 67      THEN 'Agricola'
            WHEN acte.idrecursivo BETWEEN 68    AND 134     THEN 'Explotacion,Energia y Construccion'
            WHEN acte.idrecursivo BETWEEN 135   AND 260     THEN 'Comercio'
            WHEN acte.idrecursivo BETWEEN 261   AND 662     THEN 'Servicios'
            ELSE 'sin clasificacion' 
        END  ) as "act_eco_socio",

        (CASE WHEN a1.idproducto IS NOT NULL THEN a1.idproducto ELSE NULL END) AS producto,    
        (CASE WHEN a1.saldo IS NOT NULL THEN a1.saldo ELSE NULL END) AS saldo,             
        (case when p.nivel_riesgo=0 then 'SIN CLASIFICAR' 
             when p.nivel_riesgo=1 then 'ALTO RIESGO' 
             when p.nivel_riesgo=2 then 'BAJO RIESGO' 
             when p.nivel_riesgo=9 then 'SIN CLASIFICAR, FALTA INFORMACION' 
        END) as nivel_riesgo
 FROM personas p                                                                              
      LEFT JOIN (SELECT idorigen,idgrupo,idsocio,idproducto,saldo FROM  auxiliares             
        WHERE idproducto = 101 AND saldo >= 1000) a1
      ON (a1.idorigen = p.idorigen AND a1.idgrupo = p.idgrupo AND a1.idsocio = p.idsocio)    
      LEFT JOIN (SELECT descripcion,opcion from catalogo_menus where menu = 'nacionalidad' ) ct
      ON p.nacionalidad = ct.opcion
      LEFT JOIN colonias c on p.idcolonia = c.idcolonia
      LEFT JOIN municipios m on c.idmunicipio = m.idmunicipio
      LEFT JOIN estados es on m.idestado = es.idestado
      LEFT JOIN paises ps on es.idpais = ps.idpais
      LEFT JOIN trabajo tr ON tr.idorigen = p.idorigen and tr.idgrupo = p.idgrupo and tr.idsocio = p.idsocio AND tr.consecutivo = 1
      LEFT JOIN actividades_economicas acte on tr.actividad_economica =  acte.id_actividad
 WHERE a1.saldo > 0 and p.estatus = 't' and p.idgrupo = 10                                                           
 -----------------------------------------
 UNION
 -----------------------------------------
 SELECT 
        TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||TRIM(TO_CHAR(p.idgrupo,'09'))
        ||'-'||TRIM(TO_CHAR(p.idsocio,'09999999')) AS ogs,                                           
        nombre_x(p.apmaterno, p.appaterno,p.nombre) AS nombre,
        p.curp,p.rfc,p.fechanacimiento,p.lugarnacimiento,
        (CASE 
            WHEN p.sexo = 2 then 'Femenino'
            WHEN p.sexo = 1 then 'Masculino' ELSE 'ND'
        END) as genero,
       ct.descripcion as nacionalidad,
        ps.nombre as pais_residencia,
        es.nombre as estado_residencia,
        (CASE 
            WHEN acte.idrecursivo BETWEEN 1     AND 67      THEN 'Agricola'
            WHEN acte.idrecursivo BETWEEN 68    AND 134     THEN 'Explotacion,Energia y Construccion'
            WHEN acte.idrecursivo BETWEEN 135   AND 260     THEN 'Comercio'
            WHEN acte.idrecursivo BETWEEN 261   AND 662     THEN 'Servicios'
            ELSE 'sin clasificacion' 
        END  ) as "act_eco_socio",

        (CASE WHEN a1.idproducto IS NOT NULL THEN a1.idproducto ELSE NULL END) AS producto,    
        (CASE WHEN a1.saldo IS NOT NULL THEN a1.saldo ELSE NULL END) AS saldo,             
        (case when p.nivel_riesgo=0 then 'SIN CLASIFICAR' 
             when p.nivel_riesgo=2 then 'ALTO RIESGO' 
             when p.nivel_riesgo=1 then 'BAJO RIESGO' 
             when p.nivel_riesgo=9 then 'SIN CLASIFICAR, FALTA INFORMACION' 
        END) as nivel_riesgo
 FROM personas p                                                                              
      LEFT JOIN (SELECT idorigen,idgrupo,idsocio,idproducto,saldo FROM  auxiliares             
        WHERE idproducto = 120 AND saldo > 0.0) a1
      ON (a1.idorigen = p.idorigen AND a1.idgrupo = p.idgrupo AND a1.idsocio = p.idsocio)    
      LEFT JOIN (SELECT descripcion,opcion from catalogo_menus where menu = 'nacionalidad' ) ct
      ON p.nacionalidad = ct.opcion
      LEFT JOIN colonias c on p.idcolonia = c.idcolonia
      LEFT JOIN municipios m on c.idmunicipio = m.idmunicipio
      LEFT JOIN estados es on m.idestado = es.idestado
      LEFT JOIN paises ps on es.idpais = ps.idpais
      LEFT JOIN trabajo tr ON tr.idorigen = p.idorigen and tr.idgrupo = p.idgrupo and tr.idsocio = p.idsocio AND tr.consecutivo = 1
      LEFT JOIN actividades_economicas acte on tr.actividad_economica =  acte.id_actividad
 WHERE a1.saldo > 0 and p.estatus = 't' and p.idgrupo = 20                                                           
 ORDER BY ogs desc;