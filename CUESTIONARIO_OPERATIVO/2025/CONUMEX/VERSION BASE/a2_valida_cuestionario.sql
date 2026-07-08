select * from cuestionario_a2(12345,2025);

-----------------------------------------------------------
--                    VALIDACIONES PARA CUESTIONARIO A2
-- Tabla temporal: a2_cuestionario_operatividad
-----------------------------------------------------------

-----SI SALEN DATOS ES PORQUE SE ESTA USANDO LA CLAVE DE EJEMPLO Y NO LA CORRESPONDIENTE

SELECT anio,clave_entidad 
FROM a2_cuestionario_operatividad
WHERE clave_entidad::numeric = 12345
OR anio IS NULL OR  anio != '2025';


SELECT *
FROM a2_cuestionario_operatividad
where producto_servicio IS NULL OR tipo_cliente_usuario IS NULL 
OR clasificacion_grado_riesgo IS NULL
--OR pais_nacionalidad IS NULL OR pais_residencia IS NULL 
OR entidad_federativa_residencia IS NULL 
OR actividad_economica is null OR numero_clientes_usuarios IS NULL ;
;