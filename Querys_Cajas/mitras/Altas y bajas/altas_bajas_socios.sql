select * from 
(with fechas as 
(select date(@@Fecha_Inicial|f|01/08/2025@@) as fecha_inicial, date(@@Fecha_Final|f|31/08/2025@@) as fecha_final),
aux_d as (select idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, fecha, cargoabono
 from v_auxiliares_d
 inner join v_auxiliares using (idorigenp, idproducto, idauxiliar)
 where idproducto = 101 and cargoabono = 1 and saldoec = 2000 and date(fecha) between (select fecha_inicial from fechas) and (select fecha_final from fechas)
 union all
 select idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, fecha, cargoabono
 from v_auxiliares_d
 inner join v_auxiliares using (idorigenp, idproducto, idauxiliar)
 where idproducto = 101 and cargoabono = 0 and saldoec = 0 and date(fecha) between (select fecha_inicial from fechas) and (select fecha_final from fechas))
select p.idorigen||'-'||p.idgrupo||'-'||p.idsocio as "Numero_Socio",
  p.nombre||' '||p.appaterno||' '||p.apmaterno as "Nombre_Socio",
  (case when p.sexo = 1 THEN 'Masculino'
        WHEN p.sexo = 2 THEN 'Femenino' END) as "Sexo",
  (select est.nombre from estados est 
    INNER JOIN municipios mun
    ON mun.idestado = est.idestado
    INNER JOIN colonias col
    ON col.idcolonia = p.idcolonia
    AND col.idmunicipio = mun.idmunicipio
    ) as "Estado",
  (case when a.cargoabono = 1 then date(a.fecha) end) as "Fecha_Alta",
  (case when a.cargoabono = 0 then date(a.fecha) end) as "Fecha_Baja"
from vpersonas p
inner join aux_d a using (idorigen, idgrupo, idsocio)
order by a.fecha
) as x;
