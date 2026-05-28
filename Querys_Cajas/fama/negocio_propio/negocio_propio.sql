SELECT p.idorigen||'-'||p.idgrupo||'-'||p.idsocio as ogs, tr.puesto, tr.nombre,(CASE
    when tipo_empleo = 4 then 'Negocio Propio'
    ELSE 'Otro' END
) as tipo_empleo, 
COALESCE(tr.ocupacion,'ND') as ocupacion, 
COALESCE(tr.actividad_economica::varchar,'ND') as id_actividad_eco, 
COALESCE(act_eco.descripcion,'ND') as actividad_eco,
COALESCE(tr.actividad_economica_pld::varchar, 'ND') as id_actividad_eco_pld,
COALESCE(act_pld.descripcion,'ND') as actividad_eco_pld
FROM personas as p
INNER JOIN trabajo as tr ON  p.idorigen = tr.idorigen AND p.idgrupo = tr.idgrupo AND p.idsocio = tr.idsocio
INNER JOIN actividades_economicas as act_eco ON tr.actividad_economica::varchar = act_eco.id_actividad::varchar
INNER JOIN actividades_economicas_pld AS act_pld ON act_pld.id_actividad = tr.actividad_economica_pld::varchar 
where tr.tipo_empleo = 4 AND p.estatus = 't' AND p.idgrupo = 10
;

