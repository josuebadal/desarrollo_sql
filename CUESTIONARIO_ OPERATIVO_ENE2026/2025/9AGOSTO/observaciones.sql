
---------------------------------------------------------------------
-- IGUAL QUE ANTES, NO LO MODIFIQUE, SOLO AGREGUE EL create index ---
---------------------------------------------------------------------
  /*drop table if exists temp_peps;
  create temp table temp_peps as
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from (select i.idorigen,i.idgrupo,i.idsocio,a.idorigenp,a.idproducto,a.idauxiliar
          from peps_qeq_identificado_web as i
               inner join peps_qeq_catalogo_web as c using (id_persona)
               inner join auxiliares as a using(idorigen,idgrupo,idsocio)
          where lista = 'PPE' and c.fecha_cargo_ini is not NULL and c.fecha_cargo_ini != ''
         UNION ALL
          select i.idorigen,i.idgrupo,i.idsocio, a.idorigenp, a.idproducto, a.idauxiliar
          from peps_qeq_identificado_web as i
               inner join peps_qeq_catalogo_web as c using (id_persona)
               inner join auxiliares as a using(idorigen,idgrupo,idsocio)
          where lista = 'PPE') as te;
  create index temp_peps_pkey on temp_peps (idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar);
raise notice 'Se genero la tabla temp_peps';*/

------------------------------------------------------------------------------------------------------------------------
-- INICIA CONFIGURACION QEQ ENERO 2026----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

  drop table if exists tmp_qeq_registros_f1;
  create temp table tmp_qeq_registros_f1 as
    select i.*,
           h.fecha,tipo,
           c.nombre,c.paterno,c.materno,
           c.lista,c.estatus,c.fecha_cargo_ini,
           c.fecha_nacimiento,c.rfc,c.curp
    from   peps_qeq_identificado_web i
           inner join peps_qeq_historial_busquedas_web h using (idorigen,idgrupo,idsocio)
           inner join personas p using (idorigen,idgrupo,idsocio)
           inner join peps_qeq_catalogo_web c using (id_persona)
    where  h.aceptado;

  --LIMPIAR ---
  update tmp_qeq_registros_f1 f1
  set    fecha_nacimiento = NULL
  from   (select *
          from   tmp_qeq_registros_f1
          where  fecha_nacimiento is null or fecha_nacimiento = '' or length(fecha_nacimiento) != 10) z
  where  (f1.idorigen,f1.idgrupo,f1.idsocio,f1.fecha,f1.fecha_nacimiento) = (z.idorigen,z.idgrupo,z.idsocio,z.fecha,z.fecha_nacimiento);

  drop table if exists tmp_qeq_registros_f2;
  create temp table tmp_qeq_registros_f2 as
    select f.*,p.nombre as p_nombre,p.appaterno as p_appaterno,p.apmaterno as p_apmaterno,p.rfc as p_rfc,
           p.curp as p_curp,p.fechanacimiento as p_fechanacimiento
    from   personas p
           inner join tmp_qeq_registros_f1 f using(idorigen,idgrupo,idsocio)
    where  p.rfc = f.rfc or p.curp = f.curp or
           ((f.fecha_nacimiento is not null and f.fecha_nacimiento != '') and p.fechanacimiento = date(f.fecha_nacimiento));

  drop table if exists temp_peps;
  create temp table temp_peps as
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from   (select i.idorigen,i.idgrupo,i.idsocio,a.idorigenp,a.idproducto,a.idauxiliar
            from tmp_qeq_registros_f2 as i
                 inner join auxiliares as a using(idorigen,idgrupo,idsocio)
            where lista = 'PPE' and fecha_cargo_ini is not NULL and fecha_cargo_ini != ''
            UNION ALL
            select i.idorigen,i.idgrupo,i.idsocio, a.idorigenp, a.idproducto, a.idauxiliar
            from tmp_qeq_registros_f2 as i
                 inner join auxiliares as a using(idorigen,idgrupo,idsocio)
            where lista = 'PPE') as te;
  create index temp_peps_pkey on temp_peps (idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar);
  raise notice 'Se genero la tabla temp_peps';


------------------------------------------------------------------------------------------------------------------------
-- TERMINA CONFIGURACION QEQ ----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

