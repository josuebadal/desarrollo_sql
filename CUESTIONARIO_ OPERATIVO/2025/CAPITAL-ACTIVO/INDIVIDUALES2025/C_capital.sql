-----------------------------------------------------------
--                    INICIO FUNCION CUESTIONARIO C
-----------------------------------------------------------
DROP TYPE IF EXISTS numero_de_cleintes_de_la_entidad CASCADE;
CREATE TYPE numero_de_cleintes_de_la_entidad as (
anio                                       text,
clave_del_formulario                       text,
clave_de_entidad                           integer,
producto_servicio                          integer,
tipo_cliente_o_usuario                     varchar,---ADD ENERO 2026
tipo_moneda                                integer,---ADD ENERO 2026
tipo_instrumento_monetario                 integer,---ADD ENERO 2026
pais_origen_envio_de_los_recursos          integer,
entrada_federativa                         integer,
operacion_entrada_salida                   integer,
numero_operaciones_entrada_salida          integer,
monto_de_operaciones_de_entrada_salida     numeric

);


DROP TABLE IF EXISTS cuestionario_c;
CREATE TABLE cuestionario_c (

anio                                       text,
clave_del_formulario                       text,
clave_de_entidad                           integer,
producto_servicio                          integer,
tipo_cliente_o_usuario                     varchar,---ADD ENERO 2026
tipo_moneda                                integer,---ADD ENERO 2026
tipo_instrumento_monetario                 integer,---ADD ENERO 2026
pais_origen_envio_de_los_recursos          integer,
entrada_federativa                         integer,
operacion_entrada_salida                   integer,
numero_operaciones_entrada_salida          integer,
monto_de_operaciones_de_entrada_salida     numeric


  );



CREATE OR REPLACE FUNCTION cuestionario_c(integer,integer)
RETURNS SETOF numero_de_cleintes_de_la_entidad as $$
 DECLARE
 r               numero_de_cleintes_de_la_entidad%rowtype;
 clave_enti      alias for  $1; 
 amo             alias for  $2;
 p_inicial       integer; -- //  periodo Inicial ej. 202501
 p_final         integer; -- //  periodo final ej.   202512
 p_inicial_r     integer; 
 p_final_r       integer;
 r_origenes      record;
 r_paso          record;
 r_perso         record;
 r_prod          record;
 r_paso_pro      record;
 rec             record;
 rec_2           record;
 y               integer;
 fecha           varchar;

 begin

DROP table IF EXISTS copiar;
CREATE temp table copiar(
    id    integer,
    fila  text);
y:=0;
insert into copiar values(y,'anio(1);clave_del_formulario(2);clave_de_entidad(3);tipo_producto_servicio(4);tipo_cliente(5);tipo_moneda(6);tipo_instrumento_monetario(7);pais_origen_envio_de_los_recursos(8);entidad_federativa(9);operacion_entrada_salida(10);numero_operaciones_entrada_salida(11);monto_de_operaciones_de_entrada_salida(12)');
--tipo_cliente_o_usuario
--tipo_moneda
--tipo_instrumento_monetario
y:=1;

p_inicial_r   :=(amo||'00')::integer;
p_inicial     :=(amo||'01')::integer;
p_final       :=(amo||'12')::integer;
p_final_r     := p_inicial_r + 100;




----------------------------------------
--- SOCIOS PEPS
----------------------------------------
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
      select distinct a.idorigen,a.idgrupo,a.idsocio
      from auxiliares as a
      where a.idproducto = rec.dato1::integer and saldo >= rec.dato2::numeric;
  end loop;

-- 757 clientes totales
  drop table if exists tmp_act_peps;
  create temp table tmp_act_peps as (
    select idorigen,idgrupo,idsocio, 1 as peps  from tmp_act_x
    where (idorigen,idgrupo,idsocio) in (select idorigen,idgrupo,idsocio from temp_peps)
   union all
    select idorigen,idgrupo,idsocio, 0 as peps from tmp_act_x 
    where (idorigen,idgrupo,idsocio) not in (select idorigen,idgrupo,idsocio from temp_peps) 
  order by idorigen,idgrupo,idsocio
  );
  create index tmp_act_peps_pkey on tmp_act_peps (idorigen,idgrupo,idsocio);


  drop table if exists tmp_act;
  create temp table tmp_act (
    idorigen     integer,
    idgrupo      integer,
    idsocio      integer,
    tipo_cliente integer
  );


  drop table if exists tmp_act;
  create temp table tmp_act as
    select distinct x.idorigen,x.idgrupo,x.idsocio,
    (case 
            -- NO PEPS
            when x.peps = 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 1 -- Cliente: Persona Física Nacional
            when x.peps = 0 and (n.act_empresarial is false or n.act_empresarial is null or n.act_empresarial is true ) and p.nacionalidad in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 2 -- Cliente: Persona Moral Nacional
            when x.peps = 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 3 -- Cliente: Persona Física Extranjera
            when x.peps = 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 4 -- Cliente: Persona Moral Extranjera
            when x.peps = 0 and n.act_empresarial is true and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 5 -- Cliente: Persona Física Nacional con Actividad Empresarial
            when x.peps = 0 and n.act_empresarial is true and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 6 -- Cliente: Persona Física Extranjera con Actividad Empresarial
     
            -- PEPS 
            when x.peps != 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 15 -- Cliente: Persona Física Nacional Pep
            when x.peps != 0 and (n.act_empresarial is false or n.act_empresarial is null or n.act_empresarial is true) and p.nacionalidad in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 16 -- Cliente: Persona Moral Nacional Pep
            when x.peps != 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 17 -- Cliente: Persona Física Extranjera Pep
            when x.peps != 0 and (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 18 -- Cliente: Persona Moral Extranjera Pep
            when x.peps != 0 and n.act_empresarial is true and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 19 -- Cliente: Persona Física Nacional con Actividad Empresarial Pep
            when x.peps != 0 and n.act_empresarial is true and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 20 -- Cliente: Persona Física Extranjera con Actividad Empresarial Pep
            else 0
    end) as tipo_cliente 
    from tmp_act_peps as x
    inner join personas as p on (x.idorigen,x.idgrupo,x.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
    left join trabajo as t on (t.idorigen,t.idgrupo,t.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
    left join negociopropio as n on (n.idorigen,n.idgrupo,n.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
    ;
  create index tmp_act_pkey on tmp_act (idorigen, idgrupo, idsocio);

  drop table if exists tmp_act_x;
  raise notice 'Se genero la tabla TMP_ACT';



    drop table if exists temp_productos;
    create temp table temp_productos (idcuestionario integer, idproducto integer);
        FOR rec in  select * from tablas 
                    where  idtabla = 'cuestionario_opera_cnbv' 
                    order by idelemento::integer
    loop
        FOR r_paso_pro in (select idprodu FROM regexp_split_to_table((trim(rec.dato2)),',') as idprodu) 
        loop
            if (r_paso_pro.idprodu <> '') then
                insert into temp_productos values(rec.idelemento::integer, r_paso_pro.idprodu::integer);
            end if;
        end loop;
    end loop;


    drop table if exists temp_auxi_c;
    create temp table temp_auxi_c as 
        (select ad.*, te.idcuestionario,ta.tipo_cliente, (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
                                                   when ad.idtipo = 2 then 2 -- CHEQUE
                                                   when ad.idtipo = 1
                                                   then (case when ad.cargoabono = 1
                                                              then (case when ad.efectivo > 0
                                                                         then 1 -- EFECTIVO
                                                                         else (case when lower(po.concepto) like '%spei%'
                                                                                    then 6 -- TRANSFERENCIA ELECTRONICA
                                                                                    else 1
                                                                             end)
                                                                    end)
                                                              else 1 -- EFECTIVO
                                                         end)
                                               end) as instrumento_monetario
         from auxiliares_d ad 
         inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2,3) 
         and ad.periodo:: integer between p_inicial and p_final
         UNION  
         select ad.*, te.idcuestionario,ta.tipo_cliente, (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
                                                   when ad.idtipo = 2 then 2 -- CHEQUE
                                                   when ad.idtipo = 1
                                                   then (case when ad.cargoabono = 1
                                                              then (case when ad.efectivo > 0
                                                                         then 1 -- EFECTIVO
                                                                         else (case when lower(po.concepto) like '%spei%'
                                                                                    then 6 -- TRANSFERENCIA ELECTRONICA
                                                                                    else 1
                                                                             end)
                                                                    end)
                                                              else 1 -- EFECTIVO
                                                         end)
                                               end) as instrumento_monetario
         from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_act ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2,3) and ad.periodo:: integer between p_inicial and p_final);

        CREATE INDEX index_temp_auxi_c
        ON temp_auxi_c (idorigenp,idproducto,idauxiliar);
    raise notice 'Se genero la tabla temp_auxi_c';


  ----------------------------------------------------------------------------
  --TABLA TEMPORAL DE REMESAS PARA LOS PRODUCTOS DE ORDENES DE PAGO NACIONALES
  ----------------------------------------------------------------------------
  drop table if exists temp_remesas_c;
    create temp table temp_remesas_c  (
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
            idcuestionario      integer,
            tipo_cliente        integer, 
            instrumento_monetario integer

  );

  for rec_2 in
select regexp_split_to_table((trim(dato2)),',') as productos from tablas where lower(idtabla)='cuestionario_opera_cnbv' 
and idelemento in ('27','28','29') order by idelemento::integer 

  loop

    insert into temp_remesas_c
      select distinct idorigenc,periodo,idtipo,idpoliza,idproducto ,sd.fecha,cargoabono,monto,montoiva,tipomov,referencia,transaccion,sd.idorigen,sd.idgrupo,sd.idsocio,efectivo,ticket , 27 as idcuestionario,
      (case 
           
            when (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 1 -- Cliente: Persona Física Nacional
            when (n.act_empresarial is false or n.act_empresarial is null or n.act_empresarial is true ) and p.nacionalidad in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 2 -- Cliente: Persona Moral Nacional
            when (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 3 -- Cliente: Persona Física Extranjera
            when (n.act_empresarial is false or n.act_empresarial is null) and p.nacionalidad not in (1,2) and p.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 4 -- Cliente: Persona Moral Extranjera
            when n.act_empresarial is true and p.nacionalidad in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 5 -- Cliente: Persona Física Nacional con Actividad Empresarial
            when n.act_empresarial is true and p.nacionalidad not in (1,2) and p.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 6 -- Cliente: Persona Física Extranjera con Actividad Empresarial

            else 0
    end) as tipo_cliente,

      (case when sd.idtipo = 3 then 8
                                                  when sd.idtipo=2 then 2
                                                  else 1 
                                            end) as instrumento_monetario
      from servicios_d as sd
    inner join personas as p on (sd.idorigen,sd.idgrupo,sd.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
    left join trabajo as t on (t.idorigen,t.idgrupo,t.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
    left join negociopropio as n on (n.idorigen,n.idgrupo,n.idsocio)=(p.idorigen,p.idgrupo,p.idsocio)
      where idproducto = rec_2.productos::integer and periodo::integer >= p_inicial_r::integer  and periodo::integer < p_final_r::integer;

      
 end loop; 




/*

      drop table if exists temp_remesas_c;
  create temp table temp_remesas_c as 
        select distinct sd.*, 27 as idcuestionario
        from servicios_d sd
        where idproducto=615 and periodo::integer >= 202400 and periodo::integer <202500;

*/




    for r_origenes 
    in  select distinct o.idestado,o.idestado_c
    from estados_cuestionario o
    order by idestado

    loop

    for r_prod
    in  select   *
        from     tablas
        where    idtabla = 'cuestionario_opera_cnbv'
        order by idelemento::integer

    loop


    IF (r_prod.dato2 is not null and TRIM(r_prod.dato2) <> '' or r_prod.idelemento::integer=27) THEN --****Agregué el or para que permita ingresar el prod 27 (ordenes de pagos nacionales)****

    for r_paso in(
        select count(*)                                                         as num_oper_entrada_salida,
               sum(monto+montoio+montoim+montoiva+montoivaim)                   as monto_oper_entrada_salida,
               (case when a.cargoabono=0 then 2 when a.cargoabono=1 then 1 end) as flujo_entrada_salida,
               a.tipo_cliente                                                   as tipo_clientes,
               a.instrumento_monetario                                     
        from temp_auxi_c a
            where (select distinct idestado from origenes where idorigen=a.idorigenp)=r_origenes.idestado and 
                   r_prod.idelemento::integer = a.idcuestionario

        group by cargoabono,tipo_cliente,instrumento_monetario

        UNION

        select  count(*) as numero_oper_entrada_salida,
                        sum(monto+montoiva) as monto_oper_entrada_salida,
                        (case when cargoabono=0 then 2
                              when cargoabono=1 then 1 
                        end) as flujo_entrada_salida,
                         rc.tipo_cliente  as tipo_clientes,
                         rc.instrumento_monetario
        from temp_remesas_c rc
        where (select distinct idestado from origenes 
               where idorigen=rc.idorigenc)=r_origenes.idestado 
               and r_prod.idelemento::integer = rc.idcuestionario

            group by cargoabono,tipo_cliente,instrumento_monetario)

    loop

    r.anio                                              :=trim(to_char(amo,'9999'));
    r.clave_del_formulario                              :='C';
    r.clave_de_entidad                                  :=clave_enti;
    r.producto_servicio                                 :=r_prod.idelemento;
    ---ADD 3 ELEMENTOS ENERO 2026
    r.tipo_cliente_o_usuario                            :=trim(to_char(r_paso.tipo_clientes,'99'));
    r.tipo_moneda                                       := '1';
    r.tipo_instrumento_monetario                        := trim(to_char(r_paso.instrumento_monetario::numeric,'99'));
    ---FIN ELEMENTOS ENERO 2026
    r.pais_origen_envio_de_los_recursos                 :='157';
    r.entrada_federativa                                :=r_origenes.idestado_c;
    r.operacion_entrada_salida                          :=r_paso.flujo_entrada_salida;
    r.numero_operaciones_entrada_salida                 :=trim(to_char(r_paso.num_oper_entrada_salida,'99999999999999999'));
    r.monto_de_operaciones_de_entrada_salida            :=trim(to_char(r_paso.monto_oper_entrada_salida::numeric,'99999999999999999'));
    
    return next r;

    insert into copiar values(y,
    coalesce(r.anio                                                 ::text,'')||';'||
    coalesce(r.clave_del_formulario                                 ::text,'')||';'||
    coalesce(r.clave_de_entidad                                     ::text,'')||';'||
    coalesce(r.producto_servicio                                    ::text,'')||';'||
    coalesce(r.tipo_cliente_o_usuario                               ::text,'')||';'||
    coalesce(r.tipo_moneda                                          ::text,'')||';'||
    coalesce(r.tipo_instrumento_monetario                           ::text,'')||';'||
    coalesce(r.pais_origen_envio_de_los_recursos                    ::text,'')||';'||
    coalesce(r.entrada_federativa                                   ::text,'')||';'||
    coalesce(r.operacion_entrada_salida                             ::text,'')||';'||
    coalesce(r.numero_operaciones_entrada_salida                    ::text,'')||';'||
    coalesce(r.monto_de_operaciones_de_entrada_salida               ::text,''));

    end loop;

    select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');

    execute 'copy (select fila from copiar order by id) to ''/tmp/C_con_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/C_sin_encabezados_'||fecha||'.csv'' with csv DELIMITER ''|'' ';

    end IF;
    end loop;
    end loop;
    return;
    end;
$$ language 'plpgsql';


-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO C
-----------------------------------------------------------


