SELECT y.*, monto_maximo_10_prc - prestamos_filtrados AS disponible
     FROM (
   SELECT x.idorigen, x.idgrupo, x.idsocio, x.nombre, x.appaterno, x.apmaterno, x.nombre_grupo,
   (CASE WHEN x.dependencia IS NOT NULL AND x.dependencia <> 0 
   THEN (select cm.descripcion from catalogo_menus as cm where x.dependencia= cm.opcion and cm.menu = 'referenciap' )ELSE 'ND' 
   END) as dependencia,
   (CASE WHEN x.consanguineidad IS NOT NULL AND x.consanguineidad <> 0 
   THEN (select cm.descripcion from catalogo_menus as cm where x.consanguineidad= cm.opcion and cm.menu = 'referenciap' )ELSE 'ND' 
   END) as consanguineidad,
          sai_token(1,grc,'|')::numeric AS monto_maximo_10_prc,
          sai_token(2,grc,'|')::numeric - 1 AS prestamos_sin_filtrar,
          sai_token(3,grc,'|')::numeric AS prestamos_filtrados
     FROM (SELECT g.idorigen, g.idgrupo, g.idsocio, 
                  p.nombre, p.appaterno, p.apmaterno,
                  g.nombre_grupo,g.consanguineidad,g.dependencia, 
                 (SELECT sai_monto_prestamo_por_riesgo_comun(g.idorigen, g.idgrupo, g.idsocio, 1) FROM grupos_riesgo_comun LIMIT 1) AS grc 
             FROM grupos_riesgo_comun AS g INNER JOIN personas AS p USING (idorigen, idgrupo, idsocio)
           ) AS x 
           ) AS y ORDER BY nombre_grupo;