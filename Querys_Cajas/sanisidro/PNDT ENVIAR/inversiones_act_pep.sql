select 
(TRIM(TO_CHAR(per.idorigen,'099999')) ||'-' || per.idgrupo ||'-'|| TRIM(TO_CHAR(per.idsocio,'099999'))) AS "Numero de socio", 
'|' AS "|", 
trim(nombre_x(per.nombre, per.appaterno,per.apmaterno)) as "Nombre",
'|' AS "|",
TRIM(TO_CHAR(aux.idorigenp, '099999')) || '-' || TRIM(TO_CHAR(aux.idproducto, '09999')) || '-' || TRIM(TO_CHAR(aux.idauxiliar , '09999999')) AS "Numero de folio",
'|' AS "|",
aux.plazo as "Plazo",
'|' AS "|",
aux.saldo as "Saldo",
'|' AS "|",
per.nivel_riesgo as "Nivel de riesgo",
'|' AS "|",
(case when exists 
   (  select 1
from   peps_qeq_identificado_web as i
       inner join peps_qeq_catalogo_web as c using (id_persona)
where  i.idorigen = per.idorigen and i.idgrupo = per.idgrupo and i.idsocio = per.idsocio and lista = 'PPE' and
       c.fecha_cargo_ini is not NULL and c.fecha_cargo_ini != ''
     ) then TRUE 
     else FALSE END  ) as "PPE"
from auxiliares as aux 
inner join personas as per using (idorigen,idgrupo,idsocio) 
where aux.estatus =2
AND aux.fechaactivacion::date < '30-09-2025'   
and aux.idproducto in (select pro.idproducto from productos as pro where pro.tipoproducto in(0,1,8));


