
-----------------------------------------------------------
--                    INICIO FUNCION CUESTIONARIO B
-----------------------------------------------------------
drop type if exists numero_operaciones_producto_servicio_por_moneda_instmonetario cascade;
create type numero_operaciones_producto_servicio_por_moneda_instmonetario as (
  anio                        integer,
  clave_formulario            text,
  clave_entidad               text,
  producto_servicio           integer,
  --tipo_cli_usr                varchar,-- ADD ENERO 2026
  --actividad_economica         varchar,-- ADD ENERO 2026
  tipo_moneda                 integer,
  tipo_instrumento_monetario  integer,
  operac_entr_salida          integer,
  numero_operaciones          integer,  
  monto_operaciones           numeric
);

create or replace function
cuestionario_b (integer,integer)returns setof numero_operaciones_producto_servicio_por_moneda_instmonetario as $$
declare
  r           numero_operaciones_producto_servicio_por_moneda_instmonetario%rowtype;
  clave_ent   alias for $1;
  perio       alias for $2;
  p_inicial    integer;
  p_final     integer;

  p_inicial_r   integer;
  p_final_r     integer;

  r_prod       record;
  r_paso      record;
  rec         record;
  rec_2       record;
  r_paso_pro  record;
  y           integer;
  fecha       varchar;

begin

 ----TABLA FISICA PARA CONSULTAS CUESTIONARIO B
DROP table IF EXISTS b_cuestionario_operatividad;
CREATE temp table b_cuestionario_operatividad(
  anio                         text,
  clave_formulario            text,
  clave_entidad               text,
  producto_servicio           text,
  --tipo_cli_usr                text,
  --actividad_economica       text,
  tipo_moneda                 text,
  tipo_instrumento_monetario  text,
  operac_entr_salida          text,
  numero_operaciones          text,  
  monto_operaciones           text,
  monto_operaciones_numeric   numeric --GUS
 );
RAISE NOTICE 'Se creo b_cuestionario_operatividad';

------------------------------------------------------
-- INICIA TABLA PARA TIPO USUARIO CLIENTE
------------------------------------------------------
  drop table if exists temp_peps;
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
raise notice 'Se genero la tabla temp_peps';

  drop table if exists tmp_act_peps;
  create temp table tmp_act_peps as (
    select idorigen,idgrupo,idsocio, 1 as peps  from personas
    where (idorigen,idgrupo,idsocio) in (select idorigen,idgrupo,idsocio from temp_peps)
   union all
    select idorigen,idgrupo,idsocio, 0 as peps from personas 
    where (idorigen,idgrupo,idsocio) not in (select idorigen,idgrupo,idsocio from temp_peps) 
  order by idorigen,idgrupo,idsocio
  );
  create index tmp_act_peps_pkey on tmp_act_peps (idorigen,idgrupo,idsocio);

raise notice 'Se genero la tabla tmp_act_peps';


------------------------------------------------------------------------------------------------------------------------
------------------------------TABLAS PARA OBTENER LOS SOCIOS PEP
------------------------------------------------------------------------------------------------------------------------



drop table if exists temp_pfae;
create local temp table temp_pfae as
  select distinct idorigen, idgrupo, idsocio
  from negociopropio where act_empresarial;
create index temp_pfae_pkey on temp_pfae (idorigen, idgrupo, idsocio);
raise notice 'Se genero la tabla temp_pfae';


------------------------------------------------------
-- FIN TABLA PARA TIPO USUARIO CLIENTE
------------------------------------------------------

  p_inicial_r   :=(perio||'00')::integer;
  p_inicial     :=(perio||'01')::integer;
  p_final       :=(perio||'12')::integer;
  p_final_r     := p_inicial_r + 100;

  drop table if exists copiar;
  create temp table copiar(
    id    integer,
    fila  text);

  y := 0;
  insert
  into   copiar
  values (y,'ANIO|CLAVE DEL FORMULARIO|CLAVE DE LA ENTIDAD|TIPO DE PRODUCTO O SERVICIO UTILIZADO|TIPO CLIENTE O USUARIO|ACTIVIDAD ECONOMICA|TIPO MONEDA|TIPO DE INSTRUMENTO MONETARIO|OPERACION DE ENTRADA-SALIDA|NUMERO DE OPERACIONES|MONTO DE LAS OPERACIONES');

  y := 1;

  drop table if exists tmp_act_x;
  create temp table tmp_act_x
  (
    idorigen integer,
    idgrupo  integer,
    idsocio  integer
  );
  create index tmp_act_x_pkey on tmp_act_x (idorigen,idgrupo,idsocio);

  for rec
  in  select   *
      from     tablas
      where    lower(idtabla) = 'prod_base_cuestionario_op'
      order by idelemento::integer
  loop
    insert
    into   tmp_act_x
           (select distinct idorigen,idgrupo,idsocio
            from   auxiliares
            where  idproducto = rec.dato1::integer and saldo >= rec.dato2::numeric);
  end loop;


  drop table if exists tmp_act;
  create temp table tmp_act as
  (
    select distinct idorigen,idgrupo,idsocio
     from   tmp_act_x
  );
  create index tmp_act_pkey on tmp_act (idorigen, idgrupo, idsocio);

  drop table if exists tmp_act_x;

  --------------------------------------------------
  raise notice 'Se genero la tabla TMP_ACT';
  --------------------------------------------------

  ------------------------------------------------------------
  -- temp_productos
  ------------------------------------------------------------
  drop table if exists temp_productos;
  create temp table temp_productos
  (  idcuestionario integer,
     idproducto integer
  );
  for rec
  in  select   *
      from     tablas
      where    idtabla = 'cuestionario_opera_cnbv'
      order by idelemento::integer
  loop


    for r_paso_pro
    in  (select idprodu
         from   regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
    loop
      if r_paso_pro.idprodu <> ''  then
        insert
        into   temp_productos
        values (rec.idelemento::integer, r_paso_pro.idprodu::integer);
      end if;
    end loop;
  end loop;

  ------------------------------------------------------------
  -- temp_auxi : aux_d y auxd_h  +  temp_productos.idcuestionario
  ------------------------------------------------------------
  drop table if exists temp_auxi;
  create temp table temp_auxi as 
  (  select a.idorigen,a.idgrupo,a.idsocio,ad.*, te.idcuestionario, po.concepto as concepto_pol
     from   auxiliares_d ad 
            inner join auxiliares     a  using (idorigenp,idproducto,idauxiliar)
            inner join temp_productos te using (idproducto)
            inner join tmp_act        ta using (idorigen, idgrupo, idsocio)
            inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
     where  ad.tipomov = 0 and ad.idtipo in (1,2,3) and
            ad.periodo:: integer between p_inicial and p_final

     UNION ALL 

     select a.idorigen,a.idgrupo,a.idsocio,ad.*, te.idcuestionario, po.concepto as concepto_pol
     from   auxiliares_d_h ad 
            inner join auxiliares_h     a  using (idorigenp,idproducto,idauxiliar)
            inner join temp_productos te using (idproducto)
            inner join tmp_act        ta using (idorigen, idgrupo, idsocio)
            inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
     where  ad.tipomov = 0 and ad.idtipo in (1,2,3) and
            ad.periodo:: integer between p_inicial and p_final
  );
  create index index_temp_auxi on temp_auxi (idorigenp,idproducto,idauxiliar);

  --------------------------------------------------
  raise notice 'Se genero la tabla temp_auxi';
  --------------------------------------------------

  ----------------------------------------------------------------------------
  --TABLA TEMPORAL DE REMESAS PARA LOS PRODUCTOS DE ORDENES DE PAGO NACIONALES
  ----------------------------------------------------------------------------

  drop table if exists temp_remesas_b;
  create temp table temp_remesas_b  (
    idorigen        integer,
    idgrupo         integer,
    idsocio         integer,
    idcuestionario  integer,
    idtipo          numeric, 
    cargoabono      integer,
    monto           numeric,
    montoiva        numeric,
    efectivo        numeric,
    ticket          integer
  );

  for rec_2 in
select regexp_split_to_table((trim(dato2)),',') as productos from tablas where lower(idtabla)='cuestionario_opera_cnbv' 
and idelemento in ('27','28','29') order by idelemento::integer 

  loop

    insert into temp_remesas_b
      select distinct idorigen,idgrupo,idsocio,  27 as "idcuestionario", idtipo, cargoabono, monto, montoiva, efectivo, ticket
      from servicios_d
      where idproducto = rec_2.productos::integer and periodo::integer >= p_inicial_r::integer  and periodo::integer < p_final_r::integer;

      
 end loop; 




/*
   drop table if exists temp_remesas_b;
  create temp table temp_remesas_b as 
        select distinct idorigen, idgrupo, idsocio, 27 as idcuestionario, idtipo, cargoabono, monto, montoiva, efectivo, ticket
        from servicios_d 
        where idproducto=615 and periodo::integer >= p_inicial_r and periodo::integer <p_final_r;

*/


  for r_prod
  in  select   *
      from     tablas
      where    idtabla = 'cuestionario_opera_cnbv'
      order by idelemento::integer
  loop

    --------------------------------------------------
    raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;
    --------------------------------------------------


    if (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '' 
      or r_prod.idelemento::integer=27) then --****Agregué el or para que permita ingresar el prod 27 (ordenes de pagos nacionales)****
      for r_paso ------- FOR (B)
      in  select   insm,
                   sum (monto_operaciones)  as monto_entr_sali,
                   sum (entradas_numero) as num_entr_sali,
                   tipo_oper,
                   --tipo_clien_usua,act_eco_pld,
                   espep
                   
          from     (select monto_operaciones,
                           numero_operaciones as entradas_numero,
                            ------------------------------------------------- 
                           case when cargoabono = 0
                                then 2
                                when cargoabono = 1
                                then 1
                           end tipo_oper,
                           -------------------------------------------------
                           insm, --act_eco_pld,tipo_clien_usua,
                           espep 
                    from   (select   insm, cargoabono,
                                     --act_eco_pld,tipo_clien_usua,
                                     espep,
                                     count(*) numero_operaciones,
                                     sum(monto_operaciones) monto_operaciones
                                     --idcuestionario
                            from     (select (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
                                                   when ad.idtipo = 2 then 2 -- CHEQUE
                                                   when ad.idtipo = 1
                                                   then (case when ad.cargoabono = 1
                                                              then (case when ad.efectivo > 0
                                                                         then 1 -- EFECTIVO
                                                                         else (case when lower(ad.concepto_pol) like 'Transferencia de banca movil%'
                                                                                    then 6 -- TRANSFERENCIA ELECTRONICA
                                                                                    else 1/*(case when de.monto_tj > 0
                                                                                               then 9 -- PAGARES TARJETA DE CREDITO O DEBITO
                                                                                               when de.monto_ch > 0
                                                                                               then 2 -- CHEQUE
                                                                                               else 1 -- EFECTIVO (por si las dudas)
                                                                                          end)*/
                                                                             end)
                                                                    end)
                                                              else 1 -- EFECTIVO
                                                         end)
                                               end) as insm,
                                             ad.cargoabono,
                                             (case when peps=1 then 'PEP'
                                                  else ' '
                                            end) as espep, ---DATO QUE VALIDA SI ES POLITICAMENTE EXPUESTO
--------------------------------------------------------------------------------------------------------------------
                                            /* tr.actividad_economica_pld as act_eco_pld,
                                             (case when peps = 1 then 15
                                                   ELSE 1 
                                              END)as tipo_clien_usua, ----------DATO 5*/
--------------------------------------------------------------------------------------------------------------------
                                            
                                            /*(case when peps = 1 then 15
                                            else (case when (select count(*) from temp_pfae
                                                  where idorigen = p.idorigen and idgrupo = p.idgrupo and
                                                        idsocio = p.idsocio) > 0 then 5
                                            else (case when p.nacionalidad != 3 and
                                                           (p.razon_social is NULL or p.razon_social = '') then 1
                                            when p.nacionalidad != 3 and
                                                (p.razon_social is not NULL and p.razon_social != '')then 2
                                            when p.nacionalidad  = 3 and
                                                (p.razon_social is NULL or p.razon_social = '') then 3
                                            when p.nacionalidad  = 3 and
                                                (p.razon_social is not NULL and p.razon_social != '') then 4
                                                end)
                                            end)
                                        end) as tipo_clien_usua, ----------DATO 5 */
                                             -- GUS (round)
                                             round((ad.monto + ad.montoio + ad.montoim + ad.montoiva + ad.montoivaim),0) as monto_operaciones
                                             -- GUS
                                             --ad.idcuestionario
                                      from   temp_auxi ad
                                      INNER JOIN personas as p ON ad.idorigen = p.idorigen AND ad.idgrupo = p.idgrupo AND 
                                                ad.idsocio = p.idsocio
                                      LEFT JOIN trabajo as tr ON tr.idorigen = ad.idorigen AND tr.idgrupo = ad.idgrupo AND 
                                                tr.idsocio = ad.idsocio AND tr.consecutivo = 1
                                      left join tmp_act_peps ac ON p.idorigen = ac.idorigen AND p.idgrupo = ac.idgrupo AND p.idsocio = ac.idsocio
                                             /*left  join detalle_ie   as de  on    ((de.idorigenc,de.periodo,de.idtipo,de.idpoliza,de.ticket) =
                                                                                   (ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.ticket) and 
                                                                                   de.ogs = ad.idorigen||'-'||ad.idgrupo||'-'||ad.idsocio)*/
                                      where  r_prod.idelemento::integer = ad.idcuestionario  
                             

                              UNION all

                             
                                     select (case when ar.idtipo = 3 then 8
                                                  when ar.idtipo=2 then 2
                                                  else 1 
                                            end) as insm,
                                     ar.cargoabono,
                                     (case when peps=1 then 'PEP'
                                                  else ' '
                                            end) as espep, ---DATO QUE VALIDA SI ES POLITICAMENTE EXPUESTO
--------------------------------------------------------------------------------------------------------------------

                                     /* tr.actividad_economica_pld as act_eco_pld,
                                      (case when peps = 1 then 15
                                      ELSE 1 
                                      END)as tipo_clien_usua, ----------DATO 5*/
--------------------------------------------------------------------------------------------------------------------
 
                                     -- GUS (ROUND)
                                     round((ar.monto+ar.montoiva),0) as monto_operaciones
                                     --ar.idcuestionario
                                     from temp_remesas_b ar
                                     INNER JOIN personas as p ON ar.idorigen = p.idorigen AND ar.idgrupo = p.idgrupo AND 
                                                ar.idsocio = p.idsocio
                                     LEFT JOIN trabajo as tr ON tr.idorigen = ar.idorigen AND tr.idgrupo = ar.idgrupo AND 
                                              tr.idsocio = ar.idsocio AND tr.consecutivo = 1
                                     left join tmp_act_peps ac ON p.idorigen = ac.idorigen AND p.idgrupo = ac.idgrupo AND p.idsocio = ac.idsocio   
                                     where r_prod.idelemento::integer = ar.idcuestionario 
                                    

                                      ) ax 
                            group by insm,cargoabono,espep--,act_eco_pld,tipo_clien_usua
                            ) aux
                    ) mont_num 

          group by insm, tipo_oper,espep--,act_eco_pld,tipo_clien_usua
          order by insm, tipo_oper
      loop      ------- LOOP (B)



        r.anio                        := trim(to_char(perio,'9999'));
        r.clave_formulario            := 'B';
        r.clave_entidad               := clave_ent;
        r.producto_servicio           := trim(to_char(r_prod.idelemento::numeric,'99'));
        /*r.tipo_cli_usr                := trim(to_char(r_paso.tipo_clien_usua::integer,'09'));---||' '||r_paso.espep;
        r.actividad_economica         := CASE 
                                         WHEN r_paso.act_eco_pld IS NULL 
                                         OR   r_paso.act_eco_pld ='' THEN '0'
                                         ELSE trim(to_char(r_paso.act_eco_pld::numeric,'99999999'))
                                         END; */
        r.tipo_moneda                 := '1';
        r.tipo_instrumento_monetario  := trim(to_char(r_paso.insm::numeric,'99'));
        r.operac_entr_salida          := r_paso.tipo_oper;
        r.numero_operaciones          := r_paso.num_entr_sali;
        r.monto_operaciones           := r_paso.monto_entr_sali;
        
        
        INSERT INTO  b_cuestionario_operatividad  VALUES (
        r.anio,
        r.clave_formulario,
        r.clave_entidad,
        r.producto_servicio,
        --r.tipo_cli_usr,
        --r.actividad_economica,
        r.tipo_moneda,
        r.tipo_instrumento_monetario,
        r.operac_entr_salida,
        r.numero_operaciones::text,  
        trim(to_char(r.monto_operaciones,'99999999999999999')),
        r.monto_operaciones  --GUS
 );
        
        return next r;

        insert into   copiar
        values (y,
                coalesce(r.anio                       ::text,'')||'|'||
                coalesce(r.clave_formulario           ::text,'')||'|'||
                coalesce(r.clave_entidad              ::text,'')||'|'||
                coalesce(r.producto_servicio          ::text,'')||'|'||
                --coalesce(r.tipo_cli_usr               ::text,'')||'|'||
                --coalesce(r.actividad_economica        ::text,'')||'|'||
                coalesce(r.tipo_moneda                ::text,'')||'|'||
                coalesce(r.tipo_instrumento_monetario ::text,'')||'|'||
                coalesce(r.operac_entr_salida         ::text,'')||'|'||
                coalesce(r.numero_operaciones         ::text,'')||'|'||
                coalesce(trim(to_char(r.monto_operaciones,'99999999999999999')),''));
      end loop; ------- END LOOP (B)

      select
      into   fecha to_char(CURRENT_DATE,'dd-mm-yyyy');

      execute 'copy (select fila from copiar order by id)              to ''/tmp/Bv2_con_encabezados_'||fecha||'.csv''';
      execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/Bv2_sin_encabezados_'||fecha||'.csv''';

    end if;

  end loop;

  return;
 end;
$$ language 'plpgsql';

-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO B
-----------------------------------------------------------