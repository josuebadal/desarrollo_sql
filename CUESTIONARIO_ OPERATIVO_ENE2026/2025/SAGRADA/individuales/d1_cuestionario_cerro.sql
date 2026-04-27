-----------------------------------------------------------
--                    INICIO FUNCION CUESTIONARIO D1
-----------------------------------------------------------
--select * from tablas where idtabla='bankingly_banca_movil' and idelemento='usuario_banca_movil'; --CONFIGURACION PARA BANCA MOVIL

drop type if exists numero_operaciones_producto_servicio_por_canal_envio cascade;
create type numero_operaciones_producto_servicio_por_canal_envio as (
    anio                                integer,
    clave_formulario                    text,
    clave_entidad                       text,
    producto_servicio                   integer,
    tipo_canal                          integer,
    operacion_entrada_salida            integer,
    num_operaciones                     integer,
    monto_operaciones                   varchar
);

create or replace function cuestionario_d1 (integer,integer)
    returns setof numero_operaciones_producto_servicio_por_canal_envio as $$
    declare
    r           numero_operaciones_producto_servicio_por_canal_envio%rowtype;
    clave_ent   alias for $1;
    perio       alias for $2;
    p_inicial       integer;
    p_final             integer;
    p_inicial_r     integer;
    p_final_r     integer;
    r_prod              record;
    r_paso              record;
    rec                     record;
    rec_2               record;
    r_paso_pro      record;
    banca_usu     integer;
    y                       integer;
    fecha               varchar;

    begin

    p_inicial    :=(perio||'01')::integer;
    p_final        :=(perio||'12')::integer;
    p_inicial_r  :=(perio||'00')::integer; 
    p_final_r    := p_inicial_r + 100;



    DROP table IF EXISTS copiar;
    CREATE temp table copiar(
        id    integer,
        fila  text);
    y:=0;
    insert into copiar values(y,'anio;clave_formulario;clave_entidad;producto_servicio;tipo_canal;operacion_entrada_salida;num_operaciones;monto_operaciones');
    y:=1;

    banca_usu :=(select dato1 from tablas where idtabla='bankingly_banca_movil' and idelemento='usuario_banca_movil')::integer;

drop table if exists tmp_act_x;
  create temp table tmp_act_x (
    idorigen integer,
    idgrupo  integer,
    idsocio  integer
  );
  create index tmp_act_x_pkey on tmp_act_x (idorigen,idgrupo,idsocio);

  for rec in
    select * from tablas where lower(idtabla) = 'prod_base_cuestionario_op'
    order by idelemento::integer
  loop

    insert into tmp_act_x
      select distinct idorigen,idgrupo,idsocio
      from auxiliares
      where idproducto = rec.dato1::integer and saldo >= rec.dato2::numeric;

  end loop;


  drop table if exists tmp_act;
  create temp table tmp_act as
    select distinct idorigen,idgrupo,idsocio from tmp_act_x;
  create index tmp_act_pkey on tmp_act (idorigen, idgrupo, idsocio);

  drop table if exists tmp_act_x;
    raise notice 'Se genero la tabla TMP_ACT';


    drop table if exists temp_productos;
    create temp table temp_productos (idcuestionario integer, idproducto integer);
        FOR rec in  select * from tablas
                    where idtabla = 'cuestionario_opera_cnbv'
                    order by idelemento::integer
    loop
        FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
        loop
            if(r_paso_pro.idprodu <> '') then 
                insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
            end if;
        end loop;
    end loop;

    drop table if exists temp_auxi_d1;
    create temp table temp_auxi_d1 as 
        (select ad.*, te.idcuestionario, po.concepto
         from auxiliares_d ad 
         inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) 
         and ad.periodo:: integer between p_inicial and p_final
         UNION ALL 
         select ad.*, te.idcuestionario, po.concepto
         from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) 
         and ad.periodo:: integer between p_inicial and p_final);

        CREATE INDEX index_temp_auxi_d1
        ON temp_auxi_d1 (idorigenp,idproducto,idauxiliar);
    raise notice 'Se genero la tabla temp_auxi_d1';

        ---------------------------------------------------------------
        --BANCA MOVIL------
            drop table if exists temp_auxi_bk;
    create temp table temp_auxi_bk as 
        (select ad.*, te.idcuestionario, po.concepto
         from auxiliares_d ad 
         inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where po.idusuario=banca_usu 
         and ad.periodo:: integer between p_inicial and p_final
         UNION ALL 
         select ad.*, te.idcuestionario, po.concepto
         from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where po.idusuario=banca_usu 
         and ad.periodo:: integer between p_inicial and p_final);
        raise notice 'Se genero la tabla temp_auxi_bk';


      ----------------------------------------------------------------------------
      --TABLA TEMPORAL DE REMESAS PARA LOS PRODUCTOS DE ORDENES DE PAGO NACIONALES
      ----------------------------------------------------------------------------

        drop table if exists temp_remesas_d;
    create temp table temp_remesas_d  (
            idorigenc       integer,
            periodo             varchar,
            idtipo              numeric,
            idpoliza            integer,
            idproducto          integer,
            fecha_serv      timestamp,
            cargoabono          numeric,
            monto               numeric,
            montoiva            numeric,  
            tipomov         numeric,
            referencia          varchar,
            transaccion         integer,
            idorigen            integer,
            idgrupo             integer,
            idsocio             integer,
            efectivo            numeric,
            ticket              integer,
            idcuestionario  integer,
            concepto        varchar

  );


  for rec_2 in
select regexp_split_to_table((trim(dato2)),',') as productos from tablas where lower(idtabla)='cuestionario_opera_cnbv' 
and idelemento in ('27','28','29') order by idelemento::integer 

  loop

    insert into temp_remesas_d
      select distinct sd.idorigenc,sd.periodo,sd.idtipo,sd.idpoliza,sd.idproducto ,sd.fecha,sd.cargoabono,sd.monto,sd.montoiva,sd.tipomov,sd.referencia,sd.transaccion,sd.idorigen,sd.idgrupo,sd.idsocio,sd.efectivo,sd.ticket , 27 as idcuestionario,
      po.concepto
      from servicios_d as sd
      left join polizas po using (idorigenc, periodo, idtipo, idpoliza)
      where sd.idproducto = rec_2.productos::integer and sd.periodo::integer >= p_inicial_r::integer  and sd.periodo::integer < p_final_r::integer;

      
 end loop; 




    /*    drop table if exists temp_remesas_d1;
      create temp table temp_remesas_d1 as 
            select distinct sd.*, 27 as idcuestionario, po.concepto
            from servicios_d sd
            left join polizas po using (idorigenc, periodo, idtipo, idpoliza)
            where sd.idproducto=615 and sd.periodo::integer >= 202400 and sd.periodo::integer <202500;

*/

    for r_prod
    in  select   *
        from     tablas
        where    idtabla = 'cuestionario_opera_cnbv'
        order by idelemento::integer
    loop

    raise notice 'Cuestionario Operativo CNBV por CLIENTE:  %', r_prod.nombre;

    IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '' or r_prod.idelemento::integer=27) THEN --****Agregué el or para que permita ingresar el prod 27 (ordenes de pagos nacionales)****

    for r_paso in 
    (select canal,count(*) numero_operaciones,sum(monto_operaciones) monto_operaciones,flujo_entrada_salida 
                 from (select (case when ad.idtipo = 3 and ad.cargoabono=1 and (ad.concepto = 'Traspaso Cuentas Propias Mitras Movil' 
                                                            or ad.concepto = 'Traspaso Cuentas Terceros Mitras Movil') then 7 /*Banca Móvil*/
                                    else 1 /*Ventanilla (sucursales, agencias u oficinas)*/ end) as canal,
                              -- GUS (round)
                              round((ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim),0) as monto_operaciones,
                              (case when ad.cargoabono=0 then 2
                                    when ad.cargoabono=1 then 1 end) as flujo_entrada_salida
                       from temp_auxi_d1 ad 
                       --inner join polizas as po using (idorigenc, periodo, idtipo, idpoliza)
                       where r_prod.idelemento::integer = ad.idcuestionario

                       UNION ALL

                       select (case when rc.idtipo = 3 and rc.cargoabono=1 and (rc.concepto = 'Traspaso Cuentas Propias Mitras Movil' 
                                                                                or rc.concepto = 'Traspaso Cuentas Terceros Mitras Movil') then 7 /*Banca Móvil*/
                                                        else 1 /*Ventanilla (sucursales, agencias u oficinas)*/ end) as canal,
                                                  -- GUS (round)
                                                  round((rc.monto + rc.montoiva),0) as monto_operaciones,
                                                  (case when rc.cargoabono=0 then 2
                                                        when rc.cargoabono=1 then 1 end) as flujo_entrada_salida
                                           from temp_remesas_d rc 
                                           --inner join polizas as po using (idorigenc, periodo, idtipo, idpoliza)
                                           where r_prod.idelemento::integer = rc.idcuestionario
                       ) ax 
                 group by canal,flujo_entrada_salida
                 order by canal,flujo_entrada_salida)

    loop

    r.anio                                          := trim(to_char(perio,'9999'));
    r.clave_formulario                  := 'D1';
    r.clave_entidad                         := clave_ent;
    r.producto_servicio                 := trim(to_char(r_prod.idelemento::numeric,'99'));
    r.tipo_canal                                := trim(to_char(r_paso.canal::numeric,'99'));
    r.operacion_entrada_salida  := r_paso.flujo_entrada_salida;
    r.num_operaciones                   := r_paso.numero_operaciones;
                                           --trim(to_char(r_paso.numero_operaciones::numeric,'99999999999999999'));
    r.monto_operaciones                 := r_paso.monto_operaciones;
                                           --trim(to_char(r_paso.monto_operaciones::numeric,'99999999999999999'));

    return next r;

    insert into copiar values(y,
        coalesce(r.anio                             ::text,'')||';'||
        coalesce(r.clave_formulario                 ::text,'')||';'||
        coalesce(r.clave_entidad                    ::text,'')||';'||
        coalesce(r.producto_servicio                ::text,'')||';'||
        coalesce(r.tipo_canal                       ::text,'')||';'||
        coalesce(r.operacion_entrada_salida         ::text,'')||';'||
        coalesce(r.num_operaciones                  ::text,'')||';'||
        coalesce(r.monto_operaciones                ::text,''));

    end loop;

    select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');
    execute 'copy (select fila from copiar order by id) to ''/tmp/D1_con_encabezados_'||fecha||'.csv''  ';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/D1_sin_encabezados_'||fecha||'.csv''  ';

    end IF;
    end loop;
    return;
    end;
$$ language 'plpgsql';

-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO D1
-----------------------------------------------------------