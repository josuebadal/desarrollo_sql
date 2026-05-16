
-----------------------------------------------------------
--                    INICIO FUNCION CUESTIONARIO C
-----------------------------------------------------------
DROP TYPE IF EXISTS tipo_cuestionario_c CASCADE;
CREATE TYPE tipo_cuestionario_c as (
anio                                       text,
clave_del_formulario                       text,
clave_de_entidad                           integer,
producto_servicio                          integer,
tipo_cliente_o_usuario                     varchar, -- AGREGADO 2026
tipo_moneda                                integer, -- AGREGADO 2026
tipo_instrumento_monetario                 integer, -- AGREGADO 2026
pais_origen_envio_de_los_recursos          integer,
entrada_federativa                         integer,
operacion_entrada_salida                   integer,
numero_operaciones_entrada_salida          integer,
monto_de_operaciones_de_entrada_salida     numeric
);

CREATE OR REPLACE FUNCTION cuestionario_c_2026(integer,integer)
RETURNS SETOF tipo_cuestionario_c as $$
 DECLARE
 r               tipo_cuestionario_c%rowtype;
 clave_enti      alias for $1; 
 amo             alias for  $2;
 p_inicial       integer; -- // periodo Inicial ej. 202001
 p_final         integer; -- //  periodo final ej. 202012
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
DROP table IF EXISTS cuestionario_operatividad_c;
CREATE temp table cuestionario_operatividad_c (
anio                                       text,
clave_del_formulario                       text,
clave_de_entidad                           text,
producto_servicio                          text,
tipo_cliente_o_usuario                     text, -- AGREGADO 2026
tipo_moneda                                text, -- AGREGADO 2026
tipo_instrumento_monetario                 text, -- AGREGADO 2026
pais_origen_envio_de_los_recursos          text,
entrada_federativa                         text,
operacion_entrada_salida                   text,
numero_operaciones_entrada_salida          text,
monto_de_operaciones_de_entrada_salida     text,
monto_de_operaciones_de_entrada_salida_numeric numeric  --GUS
);
raise notice 'Se genero la tabla c_cuestionario_operatividad';

----------------------------------------
--- SOCIOS MENORES O CON CERTIFICADO SOCIAL
----------------------------------------
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


----
-- En tmp_act_x se trajeron todos los ogs
-- En tmp_act se hizo un distinct para que no repetir ogs
-----
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

----------------------------------------
--TABLAS PARA OBTENER LOS SOCIOS PEP
----------------------------------------

drop table if exists temp_pfae;
create local temp table temp_pfae as
  select distinct idorigen, idgrupo, idsocio
  from negociopropio where act_empresarial;
create index temp_pfae_pkey on temp_pfae (idorigen, idgrupo, idsocio);
raise notice 'Se genero la tabla temp_pfae';




----------------------------------------
-- TABLAS EN DONDE SE ALMACENAN LOS SOCIOS

-- La tabla tmp_act       son los socios menores o con certificado social
-- La tabla tmp_act_peps  son los socios pep
-- La tabla temp_pfae     son los que tienen actividad empresarial


----------------------------------------
-- SE JUNTAN LAS TABLAS DE LOS SOCIOS CON BASE DE LOS SOCIOS CON CERTIFICADO SOCIAL


  drop table if exists tmp_clientes;
  create temp table tmp_clientes as
(

select general.*,pe.peps, 
(case when empresarial.idorigen is null and empresarial.idgrupo is null and empresarial.idsocio is null
then false 
else true
end) as actividad_empresarial, p.nacionalidad
from tmp_act as general
left join tmp_act_peps as pe on pe.idorigen=general.idorigen and pe.idgrupo=general.idgrupo and pe.idsocio=general.idsocio
left join temp_pfae as empresarial on empresarial.idorigen=general.idorigen and empresarial.idgrupo=general.idgrupo and empresarial.idsocio=general.idsocio
left join personas as p on general.idorigen=p.idorigen and general.idgrupo=p.idgrupo and general.idsocio=p.idsocio

);
  create index tmp_clientes_pkey on tmp_clientes (idorigen, idgrupo, idsocio);

       drop table if exists tmp_act     ;
       drop table if exists tmp_act_peps;
       drop table if exists temp_pfae   ;








-----------------------------


DROP table IF EXISTS copiar;
CREATE temp table copiar(
    id    integer,
    fila  text);
y:=0;
insert into copiar values
(y,'anio|clave_del_formulario|clave_de_entidad|producto_servicio|tipo_cliente_o_usuario|tipo_moneda|tipo_instrumento_monetario|pais_origen_envio_de_los_recursos|entidad_federativa|operacion_entrada_salida|numero_operaciones_entrada_salida|monto_de_operaciones_de_entrada_Salida');
y:=1;
                     
                                
                
p_inicial_r   :=(amo||'00')::integer;
p_inicial     :=(amo||'01')::integer;
p_final       :=(amo||'12')::integer;
p_final_r     := p_inicial_r + 100;



  



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


--tipo_cliente_o_usuario     
--tipo_moneda                
--tipo_instrumento_monetario 

    drop table if exists temp_auxi_c;
    create temp table temp_auxi_c as 
        (select ad.*, te.idcuestionario, 
        (case 
            -- NO PEPS
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 1 -- Cliente: Persona Física Nacional
            /* SE COMENTAN ESTAS LINEAS PORQUE LA CAJA SOLO TIENE TIPO CLIENTE 1 Y 15
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 2 -- Cliente: Persona Moral Nacional
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 3 -- Cliente: Persona Física Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 4 -- Cliente: Persona Moral Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 5 -- Cliente: Persona Física Nacional con Actividad Empresarial
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 6 -- Cliente: Persona Física Extranjera con Actividad Empresarial */
     
            -- PEPS 
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 15 -- Cliente: Persona Física Nacional Pep
            /* SE COMENTAN ESTAS LINEAS PORQUE LA CAJA SOLO TIENE TIPO CLIENTE 1 Y 15
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 16 -- Cliente: Persona Moral Nacional Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 17 -- Cliente: Persona Física Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 18 -- Cliente: Persona Moral Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 19 -- Cliente: Persona Física Nacional con Actividad Empresarial Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 20 -- Cliente: Persona Física Extranjera con Actividad Empresarial Pep*/
            else 1
            end)
            as tipo_cliente,

         (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
               when ad.idtipo = 2 then 2 -- CHEQUE
               when ad.idtipo = 1
               then (case when ad.cargoabono = 1
                        then (case when ad.efectivo > 0
                              then 1 -- EFECTIVO
                              else  (case when lower(po.concepto) like '%spei%'
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
          end)
          as instrumento_monetario

         from auxiliares_d ad 
         inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_clientes ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) 
         and ad.periodo:: integer between p_inicial and p_final

         UNION ALL 

         select ad.*, te.idcuestionario,
                 (case 
            -- NO PEPS
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 1 -- Cliente: Persona Física Nacional
            /* SE COMENTAN ESTAS LINEAS PORQUE LA CAJA SOLO TIENE TIPO CLIENTE 1 Y 15
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 2 -- Cliente: Persona Moral Nacional
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 3 -- Cliente: Persona Física Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 4 -- Cliente: Persona Moral Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 5 -- Cliente: Persona Física Nacional con Actividad Empresarial
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 6 -- Cliente: Persona Física Extranjera con Actividad Empresarial*/
         
            -- PEPS 
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 15 -- Cliente: Persona Física Nacional Pep
            /* SE COMENTAN ESTAS LINEAS PORQUE LA CAJA SOLO TIENE TIPO CLIENTE 1 Y 15
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 16 -- Cliente: Persona Moral Nacional Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 17 -- Cliente: Persona Física Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 18 -- Cliente: Persona Moral Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 19 -- Cliente: Persona Física Nacional con Actividad Empresarial Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 20 -- Cliente: Persona Física Extranjera con Actividad Empresarial Pep*/
            else 1
            end)
            as tipo_cliente,
         (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
               when ad.idtipo = 2 then 2 -- CHEQUE
               when ad.idtipo = 1
               then (case when ad.cargoabono = 1
                        then (case when ad.efectivo > 0
                              then 1 -- EFECTIVO
                              else  (case when lower(po.concepto) like '%spei%'
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
          end)
          as instrumento_monetario
         from auxiliares_d_h ad 
         inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
         inner join temp_productos te using(idproducto)
         inner join tmp_clientes ta using (idorigen, idgrupo, idsocio)
         inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
         where ad.tipomov = 0 and ad.idtipo in (1,2) and ad.periodo:: integer between p_inicial and p_final);

        CREATE INDEX index_temp_auxi_c
        ON temp_auxi_c (idorigenp,idproducto,idauxiliar);
    raise notice 'Se genero la tabla temp_auxi_c';


  ----------------------------------------------------------------------------
  --TABLA TEMPORAL DE REMESAS PARA LOS PRODUCTOS DE ORDENES DE PAGO NACIONALES
  ----------------------------------------------------------------------------
  drop table if exists temp_remesas_c;
    create temp table temp_remesas_c  (
            idorigenc              integer,
            periodo                varchar,
            idtipo                 numeric,
            idpoliza               integer,
            idproducto             integer,
            fecha_serv             timestamp,
            cargoabono             numeric,
            monto                  numeric,
            montoiva               numeric,  
            tipomov                numeric,
            referencia             varchar,
            transaccion            integer,
            idorigen               integer,
            idgrupo                integer,
            idsocio                integer,
            efectivo               numeric,
            ticket                 integer,
            idcuestionario         integer,
            tipo_cliente           integer,
            instrumento_monetario  integer

  );

  for rec_2 in
select regexp_split_to_table((trim(dato2)),',') as productos from tablas where lower(idtabla)='cuestionario_opera_cnbv' 
and idelemento in ('27','28','29') order by idelemento::integer 

  loop

    insert into temp_remesas_c
      select distinct idorigenc,periodo,idtipo,idpoliza,idproducto ,sd.fecha,cargoabono,monto,montoiva,tipomov,referencia,transaccion,idorigen,idgrupo,idsocio,efectivo,ticket , 27 as idcuestionario,
            (case 
            -- NO PEPS
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 1 -- Cliente: Persona Física Nacional
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 2 -- Cliente: Persona Moral Nacional
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 3 -- Cliente: Persona Física Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 4 -- Cliente: Persona Moral Extranjera
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 5 -- Cliente: Persona Física Nacional con Actividad Empresarial
            when ta.peps = 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 6 -- Cliente: Persona Física Extranjera con Actividad Empresarial
          
            -- PEPS 
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 15 -- Cliente: Persona Física Nacional Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 16 -- Cliente: Persona Moral Nacional Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 17 -- Cliente: Persona Física Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is false and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 18 -- Cliente: Persona Moral Extranjera Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad in (1,2) and ta.idgrupo not in (select idgrupo from grupos where tipogrupo = 3)
            then 19 -- Cliente: Persona Física Nacional con Actividad Empresarial Pep
            when ta.peps != 0 and ta.actividad_empresarial is true and ta.nacionalidad not in (1,2) and ta.idgrupo in (select idgrupo from grupos where tipogrupo = 3)
            then 20 -- Cliente: Persona Física Extranjera con Actividad Empresarial Pep
            else 0
            end)
            as tipo_cliente,
      (case when sd.idtipo = 3 then 8
            when sd.idtipo = 2 then 2
                               else 1 
       end) as instrumento_monetario
      from servicios_d as sd
      left join tmp_clientes as ta using (idorigen, idgrupo, idsocio)
      where sd.idproducto = rec_2.productos::integer and periodo::integer >= p_inicial_r::integer  and periodo::integer < p_final_r::integer;

      
 end loop; 



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
        select count(*) as num_oper_entrada_salida,
              -- GUS (round)
               sum(round((monto+montoio+montoim+montoiva+montoivaim),0)) as monto_oper_entrada_salida,
               (case when a.cargoabono=0 then 2 
                     when a.cargoabono=1 then 1 end) as flujo_entrada_salida,
               a.tipo_cliente, 
               a.instrumento_monetario
        from temp_auxi_c a
            where (select distinct idestado from origenes 
                  where idorigen=a.idorigenp)=r_origenes.idestado 
                  and r_prod.idelemento::integer = a.idcuestionario
            group by a.cargoabono,a.tipo_cliente, a.instrumento_monetario 

                   UNION

        select  count(*) as numero_oper_entrada_salida,
                -- GUS (round)
                sum(round((monto+montoiva),0)) as monto_oper_entrada_salida,
                (case when cargoabono=0 then 2
                      when cargoabono=1 then 1 end) as flujo_entrada_salida,
                        tipo_cliente,
                        instrumento_monetario
                        
        from temp_remesas_c rc
            where (select distinct idestado from origenes where idorigen=rc.idorigenc)=r_origenes.idestado and
                        r_prod.idelemento::integer = rc.idcuestionario

            group by cargoabono,tipo_cliente,instrumento_monetario)

    loop

    r.anio                                      :=trim(to_char(amo,'9999'));
    r.clave_del_formulario                      :='C';
    r.clave_de_entidad                          :=clave_enti;
    r.producto_servicio                         :=r_prod.idelemento;

    r.tipo_cliente_o_usuario                    :=r_paso.tipo_cliente; 
    r.tipo_moneda                               :='1'; -- MONEDA NACIONAL POR DEFECTO, HAY MANERA DE IDENTIFICAR UNA OPERACION CON UNA MONEDA EXTRANJERA? 
    r.tipo_instrumento_monetario                :=r_paso.instrumento_monetario;
    
    r.pais_origen_envio_de_los_recursos         :='157';
    r.entrada_federativa                        :=r_origenes.idestado_c;
    r.operacion_entrada_salida                  :=r_paso.flujo_entrada_salida;
    r.numero_operaciones_entrada_salida         :=r_paso.num_oper_entrada_salida;
    r.monto_de_operaciones_de_entrada_salida    :=r_paso.monto_oper_entrada_salida;
    
  INSERT INTO  cuestionario_operatividad_c VALUES(
    r.anio,
    r.clave_del_formulario,
    r.clave_de_entidad,
    r.producto_servicio,
    r.tipo_cliente_o_usuario,
    r.tipo_moneda,
    r.tipo_instrumento_monetario,
    r.pais_origen_envio_de_los_recursos,
    r.entrada_federativa,
    r.operacion_entrada_salida,
    r.numero_operaciones_entrada_salida::text,
    trim(to_char(r_paso.monto_oper_entrada_salida::numeric,'99999999999999999')),
    r.monto_de_operaciones_de_entrada_salida  --GUS
);



    return next r;


    insert into copiar values(y,
    coalesce(r.anio                                                   ::text,'')||'|'||
    coalesce(r.clave_del_formulario                                   ::text,'')||'|'||
    coalesce(r.clave_de_entidad                                       ::text,'')||'|'||
    coalesce(r.producto_servicio                                      ::text,'')||'|'||
    coalesce(r.tipo_cliente_o_usuario                                 ::text,'')||'|'||
    coalesce(r.tipo_moneda                                            ::text,'')||'|'||
    coalesce(r.tipo_instrumento_monetario                             ::text,'')||'|'||
    coalesce(r.pais_origen_envio_de_los_recursos                      ::text,'')||'|'||
    coalesce(r.entrada_federativa                                     ::text,'')||'|'||
    coalesce(r.operacion_entrada_salida                               ::text,'')||'|'||
    coalesce(r.numero_operaciones_entrada_salida                      ::text,'')||'|'||
    coalesce(trim(to_char(r.monto_de_operaciones_de_entrada_salida,'99999999999999999')),''));

    y:= y + 1;

    end loop;

    select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');

    execute 'copy (select fila from copiar order by id) to ''/tmp/formulario_c_con_encabezados_'||fecha||'.csv''  ';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/formulario_c_sin_encabezados_'||fecha||'.csv'' ';

    end IF;
    end loop;
    end loop;
    return;
    end;
$$ language 'plpgsql';


-----------------------------------------------------------
--                    FIN FUNCION CUESTIONARIO C
-----------------------------------------------------------