------------------------------------------
-- ULTIMA MODIFICACION : 06/FEBRERO/2026  
-- REALIZO: JOSUE BADAL 
-- DESCRIPCION: Genera un archivo CSV y una tabla Temporal con todos los movimentos
-- superiores a la cantidad que ingrese en el parametro 3 
------------------------------------------

---------MANERA DE EJECUTAR EN SAICOOP
--select * from tipo_movimientos_superiores_mes(@@Fecha Inicial:|f|01/12/2024@@, @@Fecha Final:|f|31/03/2025@@,@@Monto:|e|150000@@ );

---------MANERA DE EJECUTAR EN TERMINAL
--select movimientos_superiores_mes('01/12/2025','31/01/2026',150000);

DROP TYPE IF EXISTS tipo_movimientos_superiores_mes CASCADE;

CREATE TYPE tipo_movimientos_superiores_mes AS (
   numerosocio                     text,
   numerocredito                   text,
   nombre                          text,
   fechaingreso                    text,
   nacionalidad                    text,
   fecha_nac                       text,
   ocupacion                       text,
   ingresos                        text,
   estado                          text,
   municipio                       text,
   colonia                         text,
   calle                           text,
   num_ext                         text,
   num_int                         text,
   monto                           text,
   fechamov                        text,
   sucursal                        text,
   poliza                          text,
   suma                            text
);


CREATE OR REPLACE FUNCTION public.movimientos_superiores_mes(date, date, integer )
RETURNS SETOF tipo_movimientos_superiores_mes
LANGUAGE plpgsql
AS $function$


declare
  p_fecha_ini alias for $1;
  p_fecha_fin alias for $2;
  p_monto_sup alias for $3;
  r tipo_movimientos_superiores_mes%rowtype;
  r_datos record;
  y                   integer;
  Encabezado          text;
  fecha               varchar;
begin

----TABLA FISICA DE MOVIMIENTOS PARA VALIDACION EN TERMINAL
    DROP TABLE IF EXISTS mov_sup_mes;
    CREATE TEMP TABLE mov_sup_mes(
        numerosocio                     text,
        numerocredito                   text,
        nombre                          text,
        fechaingreso                    text,
        --identificacion_oficial          text,
        nacionalidad                    text,
        fecha_nac                       text,
        ocupacion                       text,
        ingresos                        text,
        estado                          text,
        municipio                       text,
        colonia                         text,
        calle                           text,
        num_ext                         text,
        num_int                         text,
        monto                           text,
        fechamov                        text,
        sucursal                        text,
        poliza                          text,
        suma                            text
    );

    DROP TABLE IF EXISTS COPIAR;
    CREATE TEMP TABLE COPIAR (
      id                integer,
      fila              text
    );
  
  Y:= 0;
  ENCABEZADO:= 'OGS|OPA|NOMBRE|FECHAINGRESO|NACIONALIDAD|FECHA NACIMIENTO|OCUPACION|ESTADO'
               ||'|MUNICIPIO|COLONIA|CALLE|NUM EXT| NUM INT|MONTO|FECHA|SUCURSAL|POLIZA|SUMA';
  RAISE NOTICE 'GENERACION DE REPORTE: %', ENCABEZADO;
  RAISE NOTICE 'OBTENIENDO DATOS';

    INSERT INTO COPIAR VALUES(0,ENCABEZADO);
  

  for r_datos in

      select  trim(to_char(a.idorigen,'099999'))||'-'||a.idgrupo||'-'||
        trim(to_char(a.idsocio,'09999999')) as numerosocio,
        a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar as numerocredito,
        nombre_x( p.nombre, p.appaterno, p.apmaterno) as nombre,
        p.fechaingreso as "fechaingreso",
             /*case p.tipo_idoficial
                  when 1 then 'INE/IFE'
                  when 2 then 'Pasaporte'
                  else 'Ninguno'
             end as  "Identificacion Oficial",*/
             (select descripcion from catalogo_menus
              where menu = 'nacionalidad' and opcion = p.nacionalidad) as "Nacionalidad",
             p.fechanacimiento as "fecha_nac",
            -----  CAMPOS PLD Y PEPS
            coalesce((select (select pld.descripcion from actividades_economicas_pld pld
                    where pld.id_actividad = t.actividad_economica_pld)
                    from trabajo t
                    where (t.idorigen,t.idgrupo,t.idsocio) = (p.idorigen,p.idgrupo,p.idsocio)
                    order by t.consecutivo desc limit 1 ), '0') as "ocupacion",
      ----------------  TERMINA NIVEL
      t.ing_mensual_neto as "ingresos",
             e.nombre as "Estado",
             m.nombre as "Municipio",
             c.nombre as "Colonia",
             p.calle as "Calle", 
             coalesce(p.numeroext,'Sin Numero') as "Num Ext",
             coalesce(p.numeroint,'Sin Numero') as "Num Int",
             ad1.efectivo as "monto",
             to_char(ad1.fecha, 'DD-MM-YYYY HH24:MI:SS') as "Fecha Mov",
             ord.nombre as sucursal,
             ad1.idorigenc||'-'||ad1.periodo||'-'||ad1.idtipo||'-'||ad1.idpoliza as "poliza",
             0::numeric as "Suma"
      from v_auxiliares_d as ad1
           inner join v_auxiliares a using (idorigenp, idproducto, idauxiliar)
           inner join personas p on a.idorigen=p.idorigen and a.idgrupo=p.idgrupo and a.idsocio=p.idsocio
           inner join origenes ord on ad1.idorigenc = ord.idorigen
           inner join colonias c on p.idcolonia = C.idcolonia
           inner join municipios m on c.idmunicipio = m.idmunicipio
           inner join estados e on m.idestado=e.idestado
           inner join trabajo t on t.idorigen = p.idorigen AND t.idgrupo = p.idgrupo AND t.idsocio = p.idsocio AND consecutivo = 1
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
             '' as numerocredito, 
             '' as nombre,
             '01/01/1900' AS "fechaingreso",
             --'' as "Identificacion Oficial",
             '' as "Nacionalidad",
             '01/01/1900' as "Fecha de Nacimiento",
             '' as "ocupacion",
             0 as "ingresos",
             '' as "Estado",
             '' as "Municipio",
             '' as "Colonia",
             '' as "Calle", 
             '' as "Num Ext",
             '' as "Num Int",
             0::numeric as "monto",
  	         '1900-01-01 00:00:00' as "Fecha Mov",
             '' as sucursal,
             '' as poliza,             
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

    r.numerosocio            := r_datos.numerosocio;
    r.numerocredito          := r_datos.numerocredito;
    r.nombre                 := r_datos.nombre;
    r.fechaingreso           := r_datos."fechaingreso";
    r.nacionalidad           := r_datos."Nacionalidad";
    r.fecha_nac              := r_datos."fecha_nac";
    r.ocupacion              := r_datos."ocupacion";
    r.ingresos               := r_datos."ingresos";
    r.estado                 := r_datos."Estado";
    r.municipio              := r_datos."Municipio";
    r.colonia                := r_datos."Colonia";
    r.calle                  := r_datos."Calle";
    r.num_ext                := r_datos."Num Ext";
    r.num_int                := r_datos."Num Int";
    r.monto                  := r_datos."monto";
    r.fechamov               := r_datos."Fecha Mov";
    r.sucursal               := r_datos.sucursal;
    r.poliza                 := r_datos."poliza";
    r.suma                   := r_datos."Suma";

  -----INSERTAMOS DATOS EN LA TABLA TEMPORAL
  INSERT INTO mov_sup_mes VALUES (
    r.numerosocio,
    r.numerocredito,
    r.nombre,
    r.fechaingreso,
    r.nacionalidad,
    r.fecha_nac,
    r.ocupacion,
    r.estado,
    r.municipio,
    r.colonia,
    r.calle,
    r.num_ext,
    r.num_int,
    r.monto,
    r.fechamov,
    r.sucursal,
    r.poliza,
    r.suma  
    );

  INSERT INTO COPIAR VALUES (Y,
    COALESCE(r.numerosocio,'')                   ||'|'||
    COALESCE(r.numerocredito,'')                 ||'|'||
    COALESCE(r.nombre,'')                        ||'|'||
    COALESCE(r.fechaingreso,'')                  ||'|'||
    COALESCE(r.nacionalidad,'')                  ||'|'||
    COALESCE(r.fecha_nac,'')                     ||'|'||
    COALESCE(r.ocupacion,'')                     ||'|'||
    COALESCE(r.estado,'')                        ||'|'||
    COALESCE(r.municipio,'')                     ||'|'||
    COALESCE(r.colonia,'')                       ||'|'||
    COALESCE(r.calle,'')                         ||'|'||
    COALESCE(r.num_ext,'')                       ||'|'||
    COALESCE(r.num_int,'')                       ||'|'||
    COALESCE(r.monto,'')                      ||'|'||
    COALESCE(r.fechamov,'')                      ||'|'||
    COALESCE(r.sucursal,'')                      ||'|'||
    COALESCE(r.poliza,'')                        ||'|'||
    COALESCE(r.suma,'')
  );

  y := y+1;

    return next r;
    end loop;
    SELECT INTO fecha TO_CHAR(CURRENT_DATE,'DD-MM-YYYY');

    EXECUTE 'copy (select fila from copiar order by id) to ''/tmp/mov_sup_mes_ce_'||fecha||'.csv'' ';
    EXECUTE 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/mov_sup_mes_se_'||fecha||'.csv'' ';

    return;
end;
$function$
;

