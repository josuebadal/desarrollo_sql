--select * from sai_movimientos_acumulados_superiores(@@Fecha Inicial:|f|01/12/2024@@, @@Fecha Final:|f|31/03/2025@@,@@Monto:|e|250000@@ );
-- public.tipo_sai_movimientos_acumulados_superiores_v2 definition
-- DROP TYPE public.tipo_sai_movimientos_acumulados_superiores_v2;

--DROP FUNCTION public.sai_movimientos_acumulados_superiores(date, date, integer );

CREATE OR REPLACE FUNCTION public.sai_movimientos_acumulados_superiores(date, date, integer )
 RETURNS SETOF tipo_sai_movimientos_acumulados_superiores_v3
 LANGUAGE plpgsql
AS $function$
declare
  p_fecha_ini alias for $1;
  p_fecha_fin alias for $2;
  p_monto_sup alias for $3;

  r tipo_sai_movimientos_acumulados_superiores_v3%rowtype;

  r_datos record;
begin

  for r_datos in
      select  trim(to_char(a.idorigen,'099999'))||'-'||a.idgrupo||'-'||
        trim(to_char(a.idsocio,'09999999')) as numerosocio,
        substr(trim(nombre_x( p.nombre, p.appaterno, p.apmaterno)),1,45) as nombre,
      -----  CAMPOS PLD Y PEPS
            coalesce((select (select pld.descripcion from actividades_economicas_pld pld
                    where pld.id_actividad = t.actividad_economica_pld)
                    from trabajo t
                    where (t.idorigen,t.idgrupo,t.idsocio) = (p.idorigen,p.idgrupo,p.idsocio)
                    order by t.consecutivo desc limit 1 ), '0') as "Actividad PLD",
      ----------------  TERMINA NIVEL
            p.fechanacimiento as "Fecha de Nacimiento",
             case p.tipo_idoficial
                  when 1 then 'INE/IFE'
                  when 2 then 'Pasaporte'
                  else 'Ninguno'
             end as  "Identificacion Oficial",
             (select descripcion from catalogo_menus
              where menu = 'nacionalidad' and opcion = p.nacionalidad) as "Nacionalidad",
             (select nombre from paises where idpais = p.pais_nacimiento) as "Pais de Nacimiento",
             p.clave_idoficial as "Clave Oficial",
             e.nombre as "Estado",
             m.nombre as "Municipio",
             c.nombre as "Colonia",
             p.calle as "Calle", 
             coalesce(p.numeroext,'Sin Numero') as "Num Ext",
             coalesce(p.numeroint,'Sin Numero') as "Num Int",
             (ad1.efectivo) as "Efectivo",
             ad1.fecha as "Fecha Mov",
             ord.nombre as sucursal,
             0::numeric as "Suma"
      from v_auxiliares_d as ad1
           inner join v_auxiliares a using (idorigenp, idproducto, idauxiliar)
           inner join personas p on a.idorigen=p.idorigen and a.idgrupo=p.idgrupo and a.idsocio=p.idsocio
           inner join origenes ord on ad1.idorigenc = ord.idorigen
           inner join colonias c on p.idcolonia = C.idcolonia
           inner join municipios m on c.idmunicipio = m.idmunicipio
           inner join estados e on m.idestado=e.idestado
           inner join (select au.idorigen, au.idgrupo, au.idsocio,
                            --ad.idorigenp, ad.idproducto, ad.idauxiliar,
                              sum (ad.efectivo ) as monto
                       from v_auxiliares_d as ad
                            inner join v_auxiliares as au
                            on au.idorigenp=ad.idorigenp and au.idproducto = ad.idproducto and
                               au.idauxiliar = ad.idauxiliar
                       where ad.fecha::date between p_fecha_ini and p_fecha_fin and
                             ad.idproducto in (110,111, 120, 130, 131,170, 200, 201, 202,203) and ad.cargoabono = 1
                       group by au.idorigen, au.idgrupo, au.idsocio
                              --ad.idorigenp, ad.idproducto, ad.idauxiliar
                       having sum (ad.efectivo ) > p_monto_sup
                      ) as grupi on p.idorigen=grupi.idorigen and p.idgrupo=grupi.idgrupo and p.idsocio = grupi.idsocio
      where ad1.fecha::date between p_fecha_ini and p_fecha_fin and
            ad1.idproducto in (110,111, 120, 130, 131,170, 200, 201, 202,203) and ad1.cargoabono = 1 and ad1.efectivo <> 0
    --------------------------------------------------------------------------------------------------------------------
    union
    --------------------------------------------------------------------------------------------------------------------
      select (trim(to_char(au.idorigen,'099999'))||'-' || au.idgrupo||'-'||
              trim(to_char(au.idsocio,'09999999'))) as numerosocio,
             '' as nombre,
             '' as "Actividad PLD",
             '01/01/1900' as "Fecha de Nacimiento",
             '' as "Identificacion Oficial",
             '' as "Nacionalidad",
             '' as "Pais de Nacimiento",
             '' as "Clave Oficial",
             '' as "Estado",
             '' as "Municipio",
             '' as "Colonia",
             '' as "Calle", 
             '' as "Num Ext",
             '' as "Num Int",
             0::numeric as "Efectivo",
  	         '1900-01-01 00:00:00' as "Fecha Mov",
             '' as sucursal,             
             sum (ad.efectivo )::numeric as "Suma"
      from v_auxiliares_d ad
           inner join v_auxiliares au 
           on au.idorigenp=ad.idorigenp 
           and au.idproducto = ad.idproducto 
           and au.idauxiliar = ad.idauxiliar
      where ad.fecha::date between p_fecha_ini and p_fecha_fin and
            ad.idproducto in (110,111, 120, 130, 131,170, 200, 201, 202,203) and ad.cargoabono = 1
      group by au.idorigen, au.idgrupo, au.idsocio
             --ad.idorigenp, ad.idproducto, ad.idauxiliar
      having sum (ad.efectivo ) > p_monto_sup
      order by numerosocio, nombre desc
  loop

    r.numero_socio           := r_datos.numerosocio;
    r.s1                     := '|';
    r.nombre                 := r_datos.nombre;
    r.s2                     := '|';
    r.actividad_pld          := r_datos."Actividad PLD";
    r.s3                     := '|';
    r.fecha_de_nacimiento    := r_datos."Fecha de Nacimiento";
    r.s4                     := '|';
    r.identificacion_oficial := r_datos."Identificacion Oficial";
    r.s5                     := '|';
    r.nacionalidad           := r_datos."Nacionalidad";
    r.s6                     := '|';
    r.pais_de_nacimiento     := r_datos."Pais de Nacimiento";
    r.s7                     := '|';
    r.clave_oficial          := r_datos."Clave Oficial";
    r.s8                     := '|';
    r.estado                 := r_datos."Estado";
    r.s9                     := '|';
    r.municipio              := r_datos."Municipio";
    r.s10                    := '|';
    r.colonia                := r_datos."Colonia";
    r.s11                    := '|';
    r.calle                  := r_datos."Calle";
    r.s12                    := '|';
    r.num_ext              := r_datos."Num Ext";
    r.s13                    := '|';
    r.num_int              := r_datos."Num Int";
    r.s14                    := '|';
    r.efectivo               := r_datos."Efectivo";
    r.s15                    := '|';
    r.fechamov               := r_datos."Fecha Mov";
    r.s16                    := '|';
    r.sucursal               := r_datos.sucursal;
    r.s17                    := '|';
    r.suma                   := r_datos."Suma";

    


    return next r;
  end loop;

  return;
end;
$function$
;

