-- DROP FUNCTION public.reg_841();
------NOTA IMPORTANTE-----

--ESTA FUNCION ES VIEJA Y NO SE VEN LOS CAMBIOS PARA LOS NUMEROS DE CUENTA EN LA COLUMNA T
--ESTA FUNCION LLEVA SEPARADO EL TYPE 
CREATE OR REPLACE FUNCTION public.reg_841cerro()
 RETURNS SETOF tipo_reg_841cerro
 LANGUAGE plpgsql
AS $function$

DECLARE
query       text;
r           tipo_reg_841cerro%rowtype;
rec         record;
x           integer;
px1         varchar;
px2         varchar;
i           integer;
r_lista     record;
var         text;
var_capta   text;
fecha       varchar;
nom  varchar;
y  integer;
Encabezado  text;
x_numero_cuenta  text; 
BEGIN



DROP table IF EXISTS reg_841;
CREATE table reg_841 (
 formulario                                          text ,              
 numero_de_identificacion                            text,                
 tipo_de_socio                                       text,             
 nombre_razon_o_denominacion_social                  text  ,                
 apellido_paterno_del_socio                          text ,                 
 apellido_materno_del_socio                          text  ,                
 rfc_del_socio                                       character varying ,    
 curp_del_acreditado_persona_fisica                  text ,                 
 genero                                              text,                  
 fechanacimiento_o_constitucion_de_persona_moral     text ,             
 codigo_postal_del_domicilio                         character varying(5)  ,
 localidad_del_domicilio                             bigint ,              
 estado_del_domicilio                                text   ,               
 pais_del_domicilio                                  text ,              
 numero_de_certificados_de_aportacion_ordinaria      text  ,             
 monto_de_certificados_de_aportacion_ordinaria       text  ,             
 numero_de_certificados_exedentes_o_voluntarios      text  ,  
 monto_de_certificados_exedentes_o_voluntarios       text  ,               
 numero_de_contrato                                  text   ,               
 numero_de_cuenta                                    text ,                 
 nombre_de_sucursal_que_opera_el_deposito            integer ,                
 fecha_de_contratacion                               text ,              
 tipo_de_producto                                    text ,              
 tipo_de_modalidad                                   text ,              
 tasa_de_rendimiento_anual                           text  ,             
 moneda                                              text  ,             
 plazo                                               text ,         
 fecha_de_vencimiento                                text ,              
 saldo_de_la_cuenta_al_inicio_del_periodo            text ,              
 monto_de_deposito_de_dinero                         text ,              
 monto_del_retiro_de_dinero                          text ,              
 interes_devengados_no_pagado_en_el_periodo          text ,             
 saldo_de_la_cuenta_al_final_del_periodo             text ,        
 fecha_del_ultimo_movimiento                         text ,                 
 tipo_de_apertura_de_cuenta                          text,               
 idorigen  integer,
 idgrupo  integer,
 idsocio  integer,
 --------------------------------SE AGREGAN LAS COLUMNAS ADICIONALES PARA EL REPORTE DE CERRO CON FECHA 15 DE ENERO 2026      
fecha_ingreso                                       text,
actividad_economica                                 text,
clasificacion_riesgo                                text,
estatus                                             text,
nombre_producto                                     text,
saldo_promedio                                      text,
numero_reinversiones                                 text
);



------se crea tabla temporal para lista de productos de captacion
drop table if exists prd_captacion;
create temp table prd_captacion(idproducto   integer);
select into var_capta dato2 from tablas where idtabla='claves_reg841' and idelemento='productos_captacion';


     RAISE NOTICE '%', 'Lista de productos captacion: '||var_capta;
     x := 1;
   
    px1 := SAI_TOKEN(x, var_capta, '|');
                    WHILE px1 != '' LOOP
                    px2 := px1;                     
                        insert into prd_captacion (idproducto) values(px2::integer);                      
                    x := x + 1;
                    px1 := SAI_TOKEN(x, var_capta, '|');
                     
                    END LOOP;   

------se crea tabla temporal para lista de productos de captacion para pago de interes
drop table if exists prd_pago_int;
create temp table prd_pago_int(idproducto   integer);
select into var_capta dato2 from tablas where idtabla='claves_reg841' and idelemento='pago_interes';


     RAISE NOTICE '%', 'Lista de productos para pago de interes: '||var_capta;
     x := 1;
   
    px1 := SAI_TOKEN(x, var_capta, '|');
                    WHILE px1 != '' LOOP
                    px2 := px1;                     
                        insert into prd_pago_int (idproducto) values(px2::integer);                      
                    x := x + 1;
                    px1 := SAI_TOKEN(x, var_capta, '|');
                     
  

            END LOOP; 
    drop table if exists refe;
    create temp table refe as (
    with ref_tutor as (select * from personas p 
                   inner join referencias ref 
                   using (idorigen, idgrupo, idsocio) 
                   where idgrupo = 20 
                   and tiporeferencia = 0 
                   and p.estatus = 't')
     select idorigenr,idgrupor,idsocior,idorigen,idgrupo,idsocio,cons_socio
     from ref_tutor as rr 
     left join (select idorigenr,idgrupor,idsocior, idorigen, idgrupo, idsocio, row_number() OVER(PARTITION by rr.idorigenr,rr.idgrupor,rr.idsocior) cons_socio 
            from ref_tutor as rr 
            group by idorigenr,idgrupor,idsocior, idorigen, idgrupo, idsocio) ref_tutor2
            using (idorigenr,idgrupor,idsocior, idorigen, idgrupo, idsocio) 
            order by idorigenr,idgrupor,idsocior, cons_socio
            );

/*(case when a.idgrupo=20 then
(select (CASE  WHEN 
                    re.idorigenr is not null and re.idgrupor is not null and re.idsocior is not null THEN
                    TRIM(TO_CHAR(re.idorigenr,''0999999999''))||TRIM(TO_CHAR(re.idgrupor,''09''))||TRIM(TO_CHAR(re.idsocior,''099999''))||''m''||cons_socio 
          ELSE TRIM(TO_CHAR(re.idorigenr,''0999999999'')) end) from refe re 
where a.idorigen=re.idorigen and a.idgrupo=re.idgrupo and a.idsocio=re.idsocio limit 1)else
 (TRIM(to_char(a.idorigen,''099999999999'')) ||TRIM(TO_CHAR(a.idgrupo,''09'')) ||TRIM(TO_CHAR(a.idsocio,''099999''))) end) AS "NUMERO_DE_IDENTIFICACION",
*/
query:=
'SELECT * FROM (
SELECT distinct ''0841'' as "FORMULARIO",-----------------------------------------------------------------------------------------3
/*==========================================================INFORMACION DEL SOCIO============================================*/
(case when a.idgrupo=20 and (select TRIM(TO_CHAR(re.idorigenr,''099999999999''))||TRIM(TO_CHAR(re.idgrupor,''09''))||TRIM(TO_CHAR(re.idsocior,''099999''))
                            from refe re where a.idorigen=re.idorigen and a.idgrupo=re.idgrupo and a.idsocio=re.idsocio and re.idgrupor = 10  limit 1) is not null 
THEN
(select TRIM(TO_CHAR(re.idorigenr,''099999999999''))||TRIM(TO_CHAR(re.idgrupor,''09''))||TRIM(TO_CHAR(re.idsocior,''099999''))||''m''||cons_socio 
           from refe re where a.idorigen=re.idorigen and a.idgrupo=re.idgrupo and a.idsocio=re.idsocio and re.idgrupor = 10 limit 1)
ELSE
(TRIM(to_char(a.idorigen,''09999999999999'')) ||TRIM(TO_CHAR(a.idgrupo,''09'')) ||TRIM(TO_CHAR(a.idsocio,''099999'')))END)AS "NUMERO_DE_IDENTIFICACION",------------------------------4


case when a.idgrupo=20 then                
                   (case when (select TRIM(TO_CHAR(re.idorigenr,''0999999999''))||TRIM(TO_CHAR(re.idgrupor,''09''))||TRIM(TO_CHAR(re.idsocior,''099999'')) 
                            from refe re where a.idorigen=re.idorigen and a.idgrupo=re.idgrupo and a.idsocio=re.idsocio and re.idgrupor=10  limit 1) is not null 
                   then 3 else 4 end)   ----VALIDA QUE EL MENOR TENGA TUTORES EN REF PARA PONERLE 4
when (p.razon_social <> null and p.razon_social <> '''') then 2 
when  p.nacionalidad=3 then 5 else 1 end AS "TIPO_DE_SOCIO",----------------5




UPPER(p.nombre) AS"NOMBRE_RAZON_O_DENOMINACION_SOCIAL",-------------------------------------------6
UPPER(p.appaterno) AS"APELLIDO_PATERNO_DEL_SOCIO",------------------------------------------------7

(CASE WHEN p.apmaterno ='''' or p.apmaterno is null then ''NO APLICA'' else upper(p.apmaterno)end)"APELLIDO_MATERNO_DEL_SOCIO",-----------------------------------------------8

/* SE AGREGO "p.idgrupo" YA QUE NO TENIA LA TABLA DE LA CUAL PROVIENE*/
(CASE WHEN p.idgrupo IN(20,25) AND  LENGTH(p.rfc)=10 THEN RPAD(p.rfc,13,''_'') ELSE p.rfc END)as "RFC_DEL_SOCIO",--------------9
       trim(case when p.curp is not null then p.curp else ''0'' end) as "CURP_DEL_ACREDITADO_PERSONA_FISICA",----------------------------------------------------------------10
(CASE when (p.razon_social <> null or p.razon_social <> '''') then ''0'' 
      WHEN p.sexo =1 then ''2'' when p.sexo=2 then ''1'' 
 else ''N/D'' end ) AS "GENERO",--------------------------------------------------------------------------------------------11
 TO_CHAR(p.fechanacimiento,''YYYY-MM-DD'')::text as "FECHA_DE_NACIMIENTO_O_CONSTITUCION_DE_PERSONA_MORAL",-----------------12
 c.codigopostal as "CODIGO_POSTAL_DEL_DOMICILIO",---------------------------------------------------------------------------13
m.localidad_siti AS "LOCALIDAD_DEL_DOMICILIO",-----------------------------------------------------------------------------14
(case when upper(e.nombre) like ''AGUA%'' THEN ''0001''
      when upper(e.nombre) like ''BAJA CALIFORNIA NORTE'' OR upper(e.nombre) like ''BAJA CALIFORNIA'' THEN ''0002'' 
      when upper(e.nombre) like ''BAJA CALIFORNIA SUR'' THEN ''0003'' 
      when upper(e.nombre) like ''CAMP%'' THEN ''00004''   
      when upper(e.nombre) like ''COAH%'' THEN ''00005''   
      when upper(e.nombre) like ''COLI%'' THEN ''00006''   
      when upper(e.nombre) like ''CHIA%'' THEN ''00007''   
      when upper(e.nombre) like ''CHIH%'' THEN ''00008''   
      when upper(e.nombre) like ''DIST%'' THEN ''00009''   
      when upper(e.nombre) like ''CIUD%MEX%'' THEN ''00009''
      when upper(e.nombre) like ''CD%MEX%'' THEN ''00009''
      when upper(e.nombre) like ''DURA%'' THEN ''00010''  
      when upper(e.nombre) like ''GUAN%'' THEN ''00011''  
      when upper(e.nombre) like ''GUER%'' THEN ''00012''  
      when upper(e.nombre) like ''HIDA%'' THEN ''00013''  
      when upper(e.nombre) like ''JALI%'' THEN ''00014''  
      when upper(e.nombre) like ''MEXI%'' THEN ''00015''
      when upper(e.nombre) like ''ESTADO%MEX%'' THEN ''00015''
      when upper(e.nombre) like ''EDO%MEX%'' THEN ''00015''  
      when upper(e.nombre) like ''MICH%'' THEN ''00016''  
      when upper(e.nombre) like ''MORE%'' THEN ''00017''  
      when upper(e.nombre) like ''NAYA%'' THEN ''00018''  
      when upper(e.nombre) like ''NUEV%'' THEN ''00019''  
      when upper(e.nombre) like ''OAXA%'' THEN ''00020''  
      when upper(e.nombre) like ''PUEB%'' THEN ''00021''  
      when upper(e.nombre) like ''QUER%'' THEN ''00022''  
      when upper(e.nombre) like ''QUIN%'' THEN ''00023''  
      when upper(e.nombre) like ''SAN%'' THEN ''00024''   
      when upper(e.nombre) like ''SINA%'' THEN ''00025''  
      when upper(e.nombre) like ''SONO%'' THEN ''00026''  
      when upper(e.nombre) like ''TABA%'' THEN ''00027''  
      when upper(e.nombre) like ''TAMA%'' THEN ''00028''  
      when upper(e.nombre) like ''TLAX%'' THEN ''00029''  
      when upper(e.nombre) like ''VERA%'' THEN ''00030''  
      when upper(e.nombre) like ''YUCA%'' THEN ''00031''  
      when upper(e.nombre) like ''ZACA%'' THEN ''00032'' END) AS "ESTADO_DEL_DOMICILIO",------------------------------------15
''00484'' AS "PAIS_DEL_DOMICILIO",---------------------------------------------------------------------------------------------16
/*==========================================================CERTIFICADOS SOCIALES========================================*/
case when a.idproducto in(select dato1::integer 
                           from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados_ordinarios%'') 
     then 1 else 0 end as "NUMERO_DE_CERTIFICADOS_DE_APORTACION_ORDINARIA",----------------------------------------------17
case when a.idproducto in(select dato1::integer 
                           from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados_ordinarios%'')
        then a.saldo else 0 end as "MONTO_DE_CERTIFICADO_DE_APORTACION_ORDINARIA",---------------------------------------18

case when a.idproducto in(select dato1::integer 
                            from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados_excedentes%'') 
     then a.saldo/(select dato2::numeric 
                            from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados_excedentes%'') 
     else 0 end as "NUMERO_DE_CERTIFICADOS_EXEDENTES_O_VOLUMTARIOS",-----------------------------------------------------19

case when a.idproducto in(select dato1::integer 
                            from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados_excedentes%'') 
     then a.saldo else 0 end as "MONTO_DE_CERTIFICADO_EXEDENTES_O_VOLUNTARIOS",------------------------------------------20

''NO APLICA'' AS "NUMERO_DE_CONTRATO",-----------------------------------------------------------------------------------21

/*======================================================CUENTA PRODUCTO==================================================*/
(trim(to_char(substr(a.idorigenp::varchar, 4, 2)::integer,''09'')) ||TRIM(TO_CHAR(a.idproducto,''09999''))||
TRIM(TO_CHAR(a.idauxiliar,''09999999'')))AS "NUMERO_DE_CUENTA",----------------------------------------------------------22

(select  cr.clave_regularorio from claves_regulatorios_sucursales as cr where cr.idorigen=a.idorigenp limit 1) 
as "NOMBRE_DE_LA_SUCURSAL_QUE_OPERA_EL_DEPÃSITO",-------------23

to_char(coalesce(a.fechaactivacion,a.fechaape),''yyyy-mm-dd'')::text as "FECHA_DE_CONTRATACION",-----------------------24
 COALESCE((CASE WHEN pr.cuentaaplica LIKE ''20101010101%'' THEN ''001''
                WHEN pr.cuentaaplica LIKE ''20101010102%'' THEN ''002''
                WHEN pr.cuentaaplica LIKE ''20101010201%'' THEN ''003''
                WHEN pr.cuentaaplica LIKE ''20101010202%'' THEN ''004''
                WHEN pr.cuentaaplica LIKE ''201010201%'' THEN ''005''
                WHEN pr.cuentaaplica LIKE ''20101020201%'' THEN ''006''
                WHEN pr.cuentaaplica LIKE ''201020101%'' THEN ''007''
                WHEN pr.cuentaaplica LIKE ''20102010201%'' THEN ''008''
                WHEN pr.cuentaaplica LIKE ''201020201%''   THEN ''009''
                WHEN pr.cuentaaplica LIKE ''201020202%''   THEN ''010'' 
                WHEN pr.cuentaaplica LIKE ''201030101%''   THEN ''011'' END),''000'') as "TIPO_DE_PRODUCTO",----------------------25

(CASE WHEN a.idgrupo in (20,25,44)
and idproducto in(SELECT distinct p.idproducto FROM gruposproductos AS gp 
                                                      INNER JOIN productos AS p USING (idproducto) 
                                                      WHERE gp.idgrupo IN (20,25,44) AND p.cuentaaplica LIKE ''201%'')

then ''005'' else ''002'' end) as "TIPO_DE_MODALIDAD",-------------------------------------------------------------------------------26

(a.tasaio * 12) as "TASA_DE_RENDIMIENTO_ANUAL",---------------------------------------------------------------------27

''014'' as "MONEDA",----------------------------------------------------------------------------------------------------------28


coalesce((case when (pr.cuentaaplica like ''20101010102%'' or pr.cuentaaplica like ''20101010202%'' or
                     pr.cuentaaplica like ''20101020201%'' or pr.cuentaaplica like ''201020101%'' or 
                     pr.cuentaaplica like ''20102010201%'' or pr.cuentaaplica like ''201020201%'' or 
                     pr.cuentaaplica like ''201020202%'') and a.garantia > 0
               then (case when not exists
                               (select vence from amortizaciones
                                where idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                      (idorigenp,idproducto,idauxiliar) in
                                      (select idorigenp,idproducto,idauxiliar from auxiliares
                                       where estatus = 2 and idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                             (idorigenp,idproducto,idauxiliar) in
                                             (select idorigenp,idproducto,idauxiliar
                                              from referenciasp
                                              where tiporeferencia = 4 and idorigenpr = a.idorigenp and
                                                    idproductor = a.idproducto and idauxiliarr = a.idauxiliar)
                                       order by garantia desc limit 1)
                                order by vence desc limit 1)
                         then a.plazo
                         else (case when ((select vence from amortizaciones
                                           where idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                                 (idorigenp,idproducto,idauxiliar) in
                                                 (select idorigenp,idproducto,idauxiliar from auxiliares
                                                  where estatus = 2 and idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                                        (idorigenp,idproducto,idauxiliar) in
                                                        (select idorigenp,idproducto,idauxiliar
                                                         from referenciasp
                                                         where tiporeferencia = 4 and idorigenpr = a.idorigenp and
                                                               idproductor = a.idproducto and idauxiliarr = a.idauxiliar)
                                                  order by garantia desc limit 1)
                                           order by vence desc limit 1) -
                                           (select distinct date(fechatrabajo) from origenes)) < 0
                                    then a.plazo
                                    else ((select vence from amortizaciones
                                           where idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                                 (idorigenp,idproducto,idauxiliar) in
                                                 (select idorigenp,idproducto,idauxiliar from auxiliares
                                                  where estatus = 2 and idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                                        (idorigenp,idproducto,idauxiliar) in
                                                        (select idorigenp,idproducto,idauxiliar
                                                         from referenciasp
                                                         where tiporeferencia = 4 and idorigenpr = a.idorigenp and
                                                               idproductor = a.idproducto and idauxiliarr = a.idauxiliar)
                                                  order by garantia desc limit 1)
                                           order by vence desc limit 1) -
                                           (select distinct date(fechatrabajo) from origenes))
                               end)
                    end)
               else a.plazo
          end), 0)  as "PLAZO",
----------------------------------------------------------------------------------------------------------------------29


/*COALESCE((CASE  
                WHEN pr.cuentaaplica LIKE ''20101010102%'' THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes order by desc limit 1),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
                
                WHEN pr.cuentaaplica LIKE ''20101010202%'' THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigenp),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
                
                WHEN pr.cuentaaplica LIKE ''20101020201%'' THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigenp),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
                
                WHEN pr.cuentaaplica LIKE ''201020101%''   THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigenp),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))

                WHEN pr.cuentaaplica LIKE ''20102010201%'' THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigenp),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
                
                WHEN pr.cuentaaplica LIKE ''201020201%''   THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigen),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
               
                WHEN pr.cuentaaplica LIKE ''201020202%''   THEN 
                (select count(*) from generate_series((select date(fechatrabajo) from origenes ori where ori.idorigen=a.idorigenp),
                (select am.vence from amortizaciones am where (am.idorigenp,am.idproducto,am.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar) order by am.vence desc limit 1), ''1 day''::interval))
 
                else 0 END),0)  as "PLAZO",----------------------------------29*/

COALESCE(
            case when pr.cuentaaplica LIKE ''201020201%'' /*and
            a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841'' and
                            idelemento=''vencimiento_1'')*/
            then to_char(SAI_TOKEN(3, (sai_auxiliar (a.idorigenp, a.idproducto, a.idauxiliar,
            (SELECT DISTINCT DATE(fechatrabajo) FROM origenes))), ''|'')::DATE,''yyyy-mm-dd'')::text 
            else
           (case when a.garantia > 0
              then (case when not exists
                              (select vence from amortizaciones
                               where idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                     (idorigenp,idproducto,idauxiliar) in
                                     (select idorigenp,idproducto,idauxiliar from auxiliares
                                      where estatus = 2 and idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                            (idorigenp,idproducto,idauxiliar) in
                                            (select idorigenp,idproducto,idauxiliar
                                             from referenciasp
                                             where tiporeferencia = 4 and idorigenpr = a.idorigenp and
                                                   idproductor = a.idproducto and idauxiliarr = a.idauxiliar)
                                      order by garantia desc limit 1)
                               order by vence desc limit 1)
                         then (select to_char(fechatrabajo::date,''yyyy-mm-dd'') from origenes ori where ori.idorigen = a.idorigen) 
                         else to_char(
                                 (select vence from amortizaciones
                                  where idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                        (idorigenp,idproducto,idauxiliar) in
                                        (select idorigenp,idproducto,idauxiliar from auxiliares
                                         where estatus = 2 and idorigenp > 0 and idproducto > 0 and idauxiliar > 0 and
                                               (idorigenp,idproducto,idauxiliar) in
                                               (select idorigenp,idproducto,idauxiliar
                                                from referenciasp
                                                where tiporeferencia = 4 and idorigenpr = a.idorigenp and
                                                      idproductor = a.idproducto and idauxiliarr = a.idauxiliar)
                                         order by garantia desc limit 1)
                                  order by vence desc limit 1),''yyyy-mm-dd'')::text
                    end)
              else

            (CASE WHEN pr.cuentaaplica LIKE ''301010101%''   THEN   ''9999-12-31''
                  WHEN pr.cuentaaplica LIKE ''20101010101%'' THEN   ''9999-12-31''
                  WHEN pr.cuentaaplica LIKE ''20101010201%'' THEN   ''9999-12-31''
                  WHEN pr.cuentaaplica LIKE ''201010201%''   THEN   ''9999-12-31''
                  WHEN pr.cuentaaplica LIKE ''201030101%''   THEN   ''9999-12-31''
                       else (CASE WHEN pr.tipoproducto in(1,8)
                                       then to_char(SAI_TOKEN(3, (sai_auxiliar (a.idorigenp, a.idproducto, a.idauxiliar,
                                                       (SELECT DISTINCT DATE(fechatrabajo) FROM origenes))), ''|'')::DATE,''yyyy-mm-dd'')::text
                                  when pr.tipoproducto = 0 and
                                       a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841'' and
                                                               idelemento=''vencimiento_1'')
                                       then TO_CHAR(((select dato2::date from tablas where idtabla=''claves_reg841'' and
                                                             idelemento=''vencimiento_1'')::DATE),''YYYY-MM-DD'')::text
                                  when pr.tipoproducto = 0 and
                                       a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841'' and
                                                               idelemento=''vencimiento_2'')
                                       then TO_CHAR(((select dato2::date from tablas where idtabla=''claves_reg841'' and
                                                             idelemento=''vencimiento_2'')::DATE),''YYYY-MM-DD'')::text
                                  when pr.tipoproducto = 0 and
                                       a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841'' and
                                                               idelemento=''vencimiento_3'')
                                       then TO_CHAR(((select dato2::date from tablas where idtabla=''claves_reg841'' and
                                                             idelemento=''vencimiento_3'')::DATE),''YYYY-MM-DD'')::text
                                  when pr.tipoproducto = 0 and
                                       a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841''
                                                               and idelemento=''vencimiento_4'')
                                       then TO_CHAR(((select dato2::date from tablas where idtabla=''claves_reg841'' and
                                                             idelemento=''vencimiento_4'')::DATE),''YYYY-MM-DD'')::text
                                  when pr.tipoproducto = 0 and
                                       a.idproducto in (select dato1::INTEGER from tablas where idtabla=''claves_reg841'' and
                                                               idelemento=''vencimiento_5'')
                                       then TO_CHAR(((select dato2::date from tablas where idtabla=''claves_reg841'' and
                                                             idelemento=''vencimiento_5'')::DATE),''YYYY-MM-DD'')::text 
                                  else to_char((SELECT DISTINCT DATE(fechatrabajo) FROM origenes),''yyyy-mm-dd'')::text
                             end)
                  end)
         end)
  end)
 as "FECHA_DE_VENCIMIENTO",-------------------------------------------------30


/*======================================================SALDOS PRODUCTO=================================================*/
(case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
     then 0.00 else a.saldo end+
  case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
    then 0.00  else
coalesce((select sum(monto) from v_auxiliares_d ad where ad.cargoabono=0 and ad.periodo::integer between
(select distinct to_char(date(fechatrabajo) ,''yyyymm'')::integer-2 from origenes) and
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes) and (ad.idorigenp,ad.idproducto,
ad.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar)),0) end)-
case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
    then 0.00  else
coalesce((select sum(monto) from v_auxiliares_d ad where ad.cargoabono=1 and ad.periodo::integer between
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer-2 from origenes) and
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes) and (ad.idorigenp,ad.idproducto,
ad.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar)),0.00) end
as "SALDO_DE_LA_CUENTA_AL_INICIO_DEL_PERIODO",--------------------------------------------------------------------------31
case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
    then 0.00  else
coalesce((select sum(monto) from v_auxiliares_d ad where ad.cargoabono=1 and ad.periodo::integer between
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer-2 from origenes) and
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes) and (ad.idorigenp,ad.idproducto,
ad.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar)),0.00) end "MONTO DEL DEPOSITO DE DINERO",------------------------------32

case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
    then 0.00  else
coalesce((select sum(monto) from v_auxiliares_d ad where ad.cargoabono=0 and ad.periodo::integer between
(select distinct to_char(date(fechatrabajo) ,''yyyymm'')::integer-2 from origenes) and
(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes) and (ad.idorigenp,ad.idproducto,
ad.idauxiliar)=(a.idorigenp,a.idproducto,a.idauxiliar)),0.00) end "MONTO DEL RETIRO DE DINERO",--------------------------------33
                                -----INTERES DEVENGADO NO PAGADO

case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
           then 0.00  
           when (a.saldo > 0.00 or (a.saldo = 0.00 and a.idproducto = 111)) ------------------------------------------------------------------ se agrego para fama para que considerara  el saldo promedio el producto 111 anque el saldo fuera 0 29/07/2019 fredy
            and idproducto in (select * from prd_pago_int)
           then
                SAI_TOKEN(2, (sai_auxiliar (a.idorigenp, a.idproducto, a.idauxiliar,
                                  (SELECT DISTINCT DATE(fechatrabajo) FROM origenes))), ''|'')::numeric
                                  else 0.00  END  AS "INTERESES_DEVENGADOS_NO_PAGADOS_EN_EL_PERIODO",----------------------------------------------------------------------34

               (case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
                              then 0 else a.saldo end)
                              +
                             (case when a.idproducto in (select dato1::integer 
                             from tablas where idtabla=''claves_reg841'' and idelemento like ''certificados%'' ) 
                             then 0  
                             when (a.saldo > 0 or (a.saldo = 0 and a.idproducto = 111))
                              and idproducto in (select * from prd_pago_int)
                             then
                             SAI_TOKEN(2, (sai_auxiliar (a.idorigenp, a.idproducto, a.idauxiliar,
                             (SELECT DISTINCT DATE(fechatrabajo) FROM origenes))), ''|'')::numeric
                                  else 0  END) as "SALDO_DE_LA_CUENTA_AL_FINAL_DEL_PERIODO",------------------------------------------------------------------------------35 

(CASE WHEN  pr.cuentaaplica LIKE ''301010101%''  THEN  ''9999-12-31''
      WHEN a.fechauma IS NOT NULL THEN  to_char(a.fechauma,''yyyy-mm-dd'') else ''9999-12-31''end)  AS "FECHA_DE_ULTIMO_MOVIMIENTO",-------------------------------------------------------36

''001'' AS "TIPO_DE_APERTURA_DE_CUENTA",--------------------------------------------------------------------------------------37
    a.idorigenp, a.idproducto, a.idauxiliar, a.idorigen, a.idgrupo, a.idsocio,
p.fechaingreso as "fecha_ingreso",
(CASE 
      WHEN acte.idrecursivo BETWEEN 1     AND 67      THEN ''Agricola''
      WHEN acte.idrecursivo BETWEEN 68    AND 134     THEN ''Explotacion,Energia y Construccion''
      WHEN acte.idrecursivo BETWEEN 135   AND 260     THEN ''Comercio''
      WHEN acte.idrecursivo BETWEEN 261   AND 662     THEN ''Servicios''
      ELSE ''sin clasificacion'' 
END  ) as "actividad_economica",

(CASE 
            WHEN p.nivel_riesgo = 0 THEN ''Sin Asignar''
            WHEN p.nivel_riesgo = 1 THEN ''Bajo''
            WHEN p.nivel_riesgo = 2 THEN ''Alto''
            WHEN p.nivel_riesgo = 9 THEN ''Falta Informacion''
            
END ) as "clasificacion_riesgo",

----------ESTA CASE CHOCA CON UN LOOP DE REFERENCIAS ----------
(CASE
      WHEN EXISTS (SELECT 1 FROM sopar sp 
            WHERE sp.idorigen = a.idorigenp
            AND sp.idgrupo    = a.idgrupo 
            AND sp.idsocio    = a.idsocio
            AND sp.idsocio    = 999 AND sp.tipo = ''lista_personas_bloqueadas_cnbv''
      ) THEN ''bloqueado''
      WHEN p.estatus = ''t'' THEN ''activo''
        ELSE ''inactivo'' 
END  ) AS "estatus",

pr.nombre as "nombre_producto",

ROUND(coalesce((select AVG(monto) 
        from v_auxiliares_d ad 
        where ad.cargoabono=1 
        and ad.periodo::integer between
                            (select distinct to_char(date(fechatrabajo),''yyyymm'')::integer-2 from origenes) 
                        and (select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes) 
                        and (ad.idorigenp,ad.idproducto, ad.idauxiliar) = 
                            (a.idorigenp,a.idproducto,a.idauxiliar)),0.00),4) as "saldo_promedio",
numero_reinversiones_focoop(a.idorigenp, a.idproducto, a.idauxiliar) as "numero_reinversiones"

FROM 
(select * from v_auxiliares
  where estatus=2 
    and idproducto in (select * from prd_captacion) 
   -- AND (saldo > 0 or (saldo = 0 and idproducto = 111))
  union
 select * from v_auxiliares 
  where estatus=3 
    and to_char(fechauma,''yyyymm'')::integer  between
               (select distinct to_char(date(fechatrabajo),''yyyymm'')::integer-2 from origenes) 
               and
               (select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes)
    and idproducto in (select * from prd_captacion)
) as a
INNER JOIN personas p using (idorigen,idgrupo,idsocio)
 left join colonias c using(idcolonia)
 left JOIN municipios m using(idmunicipio)
 left join estados e using(idestado)
INNER JOIN productos pr using(idproducto)
INNER JOIN origenes o on (o.idorigen=idorigenp)
LEFT JOIN trabajo tr ON tr.idorigen = p.idorigen and tr.idgrupo = p.idgrupo and tr.idsocio = p.idsocio
LEFT JOIN actividades_economicas acte 
      on tr.actividad_economica =  acte.id_actividad
) AS F 
WHERE "SALDO_DE_LA_CUENTA_AL_INICIO_DEL_PERIODO" > 0
   OR "MONTO DEL DEPOSITO DE DINERO" > 0
   OR "MONTO DEL RETIRO DE DINERO" > 0
   OR "INTERESES_DEVENGADOS_NO_PAGADOS_EN_EL_PERIODO" > 0
   OR "SALDO_DE_LA_CUENTA_AL_FINAL_DEL_PERIODO" > 0
   OR "MONTO_DE_CERTIFICADO_DE_APORTACION_ORDINARIA" > 0
   OR "MONTO_DE_CERTIFICADO_EXEDENTES_O_VOLUNTARIOS" > 0';

--SE CREA TABLA PARA CAMPO TIPO DE PRODUCTO
/*
i:=1;
  WHILE i <= 11 LOOP
20702-120-683


   execute 'drop table if EXISTS  t_lista_'||i||'';
   execute 'create temp table t_lista_'||i||' (idproducto  integer)';

     x := 1;
     select into var dato2 from tablas where idelemento=i::varchar and idtabla='reg_captacion_tipo_de_producto';
     px1 := SAI_TOKEN(x, var, '|');
     ---RAISE NOTICE '%', 'Lista de productos para el tipo: '||i||'  '||var;
                    WHILE px1 != '' LOOP
                    px2 := px1;

                     
                        execute 'insert into t_lista_'||i||' (idproducto) values('||px2||')';
                        

                    x := x + 1;
                    px1 := SAI_TOKEN(x, var, '|');


                      
                    END LOOP; 
i:=i+1;
  END LOOP; 
   */

----TABLA FISICA REGULATORIO841
drop table if exists regulatorio841;
CREATE TABLE regulatorio841 (
 formulario                                          text ,              
 numero_de_identificacion                            text  ,                
 tipo_de_socio                                       text ,           
 nombre_razon_o_denominacion_social                  text  ,                
 apellido_paterno_del_socio                          text ,                 
 apellido_materno_del_socio                          text  ,                
 rfc_del_socio                                       character varying ,    
 curp_del_acreditado_persona_fisica                  text ,                 
 genero                                              text,                  
 fechanacimiento_o_constitucion_de_persona_moral     text ,             
 codigo_postal_del_domicilio                         character varying(6)  ,
 localidad_del_domicilio                             bigint ,              
 estado_del_domicilio                                text   ,               
 pais_del_domicilio                                  text ,              
 numero_de_certificados_de_aportacion_ordinaria      text  ,             
 monto_de_certificados_de_aportacion_ordinaria       text  ,             
 numero_de_certificados_exedentes_o_voluntarios      text  ,  
 monto_de_certificados_exedentes_o_voluntarios       text  ,               
 numero_de_contrato                                  text   ,               
 numero_de_cuenta                                    text ,                 
 nombre_de_sucursal_que_opera_el_deposito            text  ,                
 fecha_de_contratacion                               text ,              
 tipo_de_producto                                    text ,              
 tipo_de_modalidad                                   text ,              
 tasa_de_rendimiento_anual                           text  ,             
 moneda                                              text  ,             
 plazo                                               text ,         
 fecha_de_vencimiento                                text ,              
 saldo_de_la_cuenta_al_inicio_del_periodo            text ,              
 monto_de_deposito_de_dinero                         text ,              
 monto_del_retiro_de_dinero                          text ,              
 interes_devengados_no_pagado_en_el_periodo          text ,             
 saldo_de_la_cuenta_al_final_del_periodo             text ,        
 fecha_del_ultimo_movimiento                         text ,                 
 tipo_de_apertura_de_cuenta                          text ,
 idorigen  integer,
 idgrupo  integer,
 idsocio  integer,
  --------------------------------SE AGREGAN LAS COLUMNAS ADICIONALES PARA EL REPORTE DE CERRO CON FECHA 15 DE ENERO 2026      
fecha_ingreso                                       text,
actividad_economica                                 text,
clasificacion_riesgo                                text,
estatus                                             text,
nombre_producto                                     text,
saldo_promedio                                      text,
numero_reinversiones                                text      
);



   ---PARA TABLA CONCATENADA
  drop table if exists copiar;
  create temp table copiar(
  id  integer,
  fila   text
  );

    y:=0;


   insert into copiar values(y,'subreporte;numero_de_identificacion;tipo_de_socio;nombre_razon_o_denominacion_social;'
                              ||'apellido_paterno_del_socio;apellido_materno_del_socio;rfc_del_socio;curp_del_acreditado_persona_fisica;'
                              ||'genero;fechanacimiento_o_constitucion_de_persona_moral;codigo_postal_del_domicilio;localidad_del_domicilio;'
                              ||'estado_del_domicilio;pais_del_domicilio;numero_de_certificados_de_aportacion_ordinaria;'
                              ||'monto_de_certificados_de_aportacion_ordinaria;numero_de_certificados_exedentes_o_voluntarios;'
                              ||'monto_de_certificados_exedentes_o_voluntarios;numero_de_contrato;numero_de_cuenta;'
                              ||'nombre_de_sucursal_que_opera_el_deposito;fecha_de_contratacion;tipo_de_producto;tipo_de_modalidad;'
                              ||'tasa_de_rendimiento_anual;moneda;plazo;fecha_de_vencimiento;saldo_de_la_cuenta_al_inicio_del_periodo;'
                              ||'monto_de_deposito_de_dinero;monto_del_retiro_de_dinero;interes_devengados_no_pagado_en_el_periodo;'
                              ||'saldo_de_la_cuenta_al_final_del_periodo;fecha_del_ultimo_movimiento;tipo_de_apertura_de_cuenta'
                              ||';fecha_ingreso;actividad_economica;clasificacion_riesgo;estatus ;nombre_producto;saldo_promedio;numero_reinversiones'
                              );
    y:=1;


Encabezado:= 'SUBREPORTE;NUMERO DE IDENTIFICACION;TIPO DE SOCIO;' 
             ||'NOMBRE RAZON O DENOMINACION SOCIAL;APELLIDO PATERNO;APELLIDO MATERNO;RFC;CURP;'
             ||'GENERO;FECHA DE NACIMIENTO;CODIGO POSTAL;LOCALIDAD DEL DOMICILIO;ESTADO DEL DOMICILIO;'
             ||'PAIS DEL DOMICILIO;NUMERO DE CERTIFICADOS DE APORTACION ORDINARIA;MONTO DE CERTIFICADO DE APORTACION ORDINARIA;'
             ||'NUMERO DE CERTIFICADOS EXEDENTES O VOLUNTARIOS;MONTO DE CERTIFICADO EXEDENTE O VOLUNTARIOS;NUMERO DE CONTRATO;'
             ||'NUMERO DE CUENTA;NOMBRE DE LA SUCURSAL QUE OPERA EL DEPÃSITO;FECHA DE CONTRATACION;TIPO DE PRODUCTO;TIPO DE MODALIDAD;TASA DE RENDIMIENTO ANUAL;'
             ||'MONEDA;PLAZO;FECHA DE VENCIMIENTO;SALDO DE LA CUENTA AL INICIO DEL PERIODO;MONTO DE DEPOSITO DE DINERO;'
             ||'MONTO DEL RETIRO DE DINERO;INTERES DEVENGADOS NO PAGADOS EN EL PERIODO;SALDO DE LA CUENTA AL FINAL DEL PERIODO;'
             ||'FECHA DEL ULTIMO MOVIMIENTO;TIPO DE APERTURA DE LA CUENTA'
             ||';fecha_ingreso;actividad_economica;clasificacion_riesgo;estatus ;nombre_producto;saldo_promedio;numero_reinversiones';

RAISE NOTICE '|DATOS_REPORTE_COMPROBACION|%',Encabezado;     

for rec in execute query loop
-- Numero de cuenta aplica para todas las cajas excepto Fama
x_numero_cuenta := substr(rec.idorigenp::varchar, 4, 2)||   --para el idorigen tomas los ultimos dos digitos
                    case when substr(rec.idproducto::varchar, 1, 1)='2' then '8'||substr(rec.idproducto::varchar, 3, 1)--cuando producto empiece con 2 le pongo el 8 i toma el tercer digito
                         when substr(rec.idproducto::varchar, 1, 1)='1' then      substr(rec.idproducto::varchar, 2, 2)--cuando el producto esta entre el rango de 100 a 199 toma los dos digitos ultimos
                         when substr(rec.idproducto::varchar, 1, 1)='4' then '4'||substr(rec.idproducto::varchar,3, 1) --cuando empiece con 4 ponemos el 4 asi como tomar el tercer digito
                         when substr(rec.idproducto::varchar, 1, 1)='5' then '5'||substr(rec.idproducto::varchar,3, 1) --cuando empieza con 5 de igualmanera ponemos 5 y ponemos el tercer digito.
                    end ||trim(to_char(rec.idauxiliar,'09999999'));       

raise NOTICE 'x_numero_cuenta %', x_numero_cuenta;

 r.formulario                                          :=rec."FORMULARIO";
 r.numero_de_identificacion                            :=rec."NUMERO_DE_IDENTIFICACION";
 r.tipo_de_socio                                       :=rec."TIPO_DE_SOCIO";
 r.nombre_razon_o_denominacion_social                  :=rec."NOMBRE_RAZON_O_DENOMINACION_SOCIAL";
 r.apellido_paterno_del_socio                          :=rec."APELLIDO_PATERNO_DEL_SOCIO";
 r.apellido_materno_del_socio                          :=rec."APELLIDO_MATERNO_DEL_SOCIO";
 r.rfc_del_socio                                       :=rec."RFC_DEL_SOCIO";
 r.curp_del_acreditado_persona_fisica                  :=rec."CURP_DEL_ACREDITADO_PERSONA_FISICA";
 r.genero                                              :=rec."GENERO";
 r.fechanacimiento_o_constitucion_de_persona_moral     :=rec."FECHA_DE_NACIMIENTO_O_CONSTITUCION_DE_PERSONA_MORAL";
 r.codigo_postal_del_domicilio                         :=rec."CODIGO_POSTAL_DEL_DOMICILIO";
 r.localidad_del_domicilio                             :=rec."LOCALIDAD_DEL_DOMICILIO";
 r.estado_del_domicilio                                :=rec."ESTADO_DEL_DOMICILIO";
 r.pais_del_domicilio                                  :=rec."PAIS_DEL_DOMICILIO";
 r.numero_de_certificados_de_aportacion_ordinaria      :=rec."NUMERO_DE_CERTIFICADOS_DE_APORTACION_ORDINARIA";
 r.monto_de_certificados_de_aportacion_ordinaria       :=rec."MONTO_DE_CERTIFICADO_DE_APORTACION_ORDINARIA";
 r.numero_de_certificados_exedentes_o_voluntarios      :=rec."NUMERO_DE_CERTIFICADOS_EXEDENTES_O_VOLUMTARIOS";
 r.monto_de_certificados_exedentes_o_voluntarios       :=rec."MONTO_DE_CERTIFICADO_EXEDENTES_O_VOLUNTARIOS";
 r.numero_de_contrato                                  :=rec."NUMERO_DE_CONTRATO";
 r.numero_de_cuenta                                    :=rec.idproducto::text;  --------------------------------------------------------------------- Modificado para Fama 13/02/2020  -- fredy
 r.nombre_de_sucursal_que_opera_el_deposito            :=rec."NOMBRE_DE_LA_SUCURSAL_QUE_OPERA_EL_DEPÃSITO";
 r.fecha_de_contratacion                               :=rec."FECHA_DE_CONTRATACION";
 r.tipo_de_producto                                    :=rec."TIPO_DE_PRODUCTO";
 r.tipo_de_modalidad                                   :=rec."TIPO_DE_MODALIDAD";
 r.tasa_de_rendimiento_anual                           :=rec."TASA_DE_RENDIMIENTO_ANUAL";
 r.moneda                                              :=rec."MONEDA";
 r.plazo                                               :=trim(to_char(rec."PLAZO",'0999'));
 r.fecha_de_vencimiento                                :=rec."FECHA_DE_VENCIMIENTO";
 r.saldo_de_la_cuenta_al_inicio_del_periodo            :=rec."SALDO_DE_LA_CUENTA_AL_INICIO_DEL_PERIODO";
 r.monto_de_deposito_de_dinero                         :=rec."MONTO DEL DEPOSITO DE DINERO";
 r.monto_del_retiro_de_dinero                          :=rec."MONTO DEL RETIRO DE DINERO";            
 r.interes_devengados_no_pagado_en_el_periodo          :=trim(to_char(rec."INTERESES_DEVENGADOS_NO_PAGADOS_EN_EL_PERIODO",'099999999999999999.99'));            
 r.saldo_de_la_cuenta_al_final_del_periodo             :=trim(to_char(rec."SALDO_DE_LA_CUENTA_AL_FINAL_DEL_PERIODO",'099999999999999999.99'));     
 r.fecha_del_ultimo_movimiento                         :=rec."FECHA_DE_ULTIMO_MOVIMIENTO";            
 r.tipo_de_apertura_de_cuenta                          :=rec."TIPO_DE_APERTURA_DE_CUENTA"; 
 r.idorigen                                            :=rec.idorigen;
 r.idgrupo                                             :=rec.idgrupo;
 r.idsocio                                             :=rec.idsocio;
----------SE AGREGAN LOS DATOS DE LA CONSULTA DE COLUMNAS EXTRAS PARA PODER VALIDAR LA TABLA
 r.fecha_ingreso                                       :=rec."fecha_ingreso";
 --PNDT VALIDAR LA ACTV ECO
 r.actividad_economica                                 :=rec."actividad_economica";
 r.clasificacion_riesgo                                :=rec."clasificacion_riesgo";
 r.estatus                                             :=rec."estatus";
 r.nombre_producto                                     :=rec."nombre_producto";
 r.saldo_promedio                                      :=rec."saldo_promedio";
 r.numero_reinversiones                                 :=rec."numero_reinversiones";


                                   

insert into regulatorio841 values(
 r.formulario,
 r.numero_de_identificacion,
 r.tipo_de_socio,
 r.nombre_razon_o_denominacion_social,
 r.apellido_paterno_del_socio,
 r.apellido_materno_del_socio, 
 r.rfc_del_socio,
 r.curp_del_acreditado_persona_fisica,
 r.genero,
 r.fechanacimiento_o_constitucion_de_persona_moral, 
 r.codigo_postal_del_domicilio, 
 r.localidad_del_domicilio::bigint, 
 r.estado_del_domicilio,  
 r.pais_del_domicilio,  
 r.numero_de_certificados_de_aportacion_ordinaria,
 r.monto_de_certificados_de_aportacion_ordinaria,
 r.numero_de_certificados_exedentes_o_voluntarios, 
 r.monto_de_certificados_exedentes_o_voluntarios,
 r.numero_de_contrato,
 x_numero_cuenta, 
 r.nombre_de_sucursal_que_opera_el_deposito,  
 r.fecha_de_contratacion,
 r.tipo_de_producto,
 r.tipo_de_modalidad, r.tasa_de_rendimiento_anual, 
 r.moneda,  
 r.plazo, 
 r.fecha_de_vencimiento, 
 r.saldo_de_la_cuenta_al_inicio_del_periodo,
 r.monto_de_deposito_de_dinero,
 r.monto_del_retiro_de_dinero, 
 r.interes_devengados_no_pagado_en_el_periodo,  
 r.saldo_de_la_cuenta_al_final_del_periodo,   
 r.fecha_del_ultimo_movimiento,       
 r.tipo_de_apertura_de_cuenta,
 r.idorigen,
 r.idgrupo,
 r.idsocio,
 ----------SE AGREGAN LOS DATOS DE LA CONSULTA DE COLUMNAS EXTRAS PARA PODER VALIDAR LA TABLA
 r.fecha_ingreso,                                       
 r.actividad_economica,                                 
 r.clasificacion_riesgo,                               
 r.estatus,                                            
 r.nombre_producto,                                     
 r.saldo_promedio,                                      
 r.numero_reinversiones
                                  );


insert into copiar values(y,
 coalesce(r.formulario::text,'')||';'||
 coalesce(r.numero_de_identificacion::text,'')||';'||
 coalesce(r.tipo_de_socio::text,'')||';'||
 coalesce(r.nombre_razon_o_denominacion_social::text,'')||';'||
 coalesce(r.apellido_paterno_del_socio::text,'')||';'||
 coalesce(r.apellido_materno_del_socio::text,'')||';'||  
 coalesce(r.rfc_del_socio::text,'')||';'||  
 coalesce(r.curp_del_acreditado_persona_fisica::text,'')||';'||  
 coalesce(r.genero::text,'')||';'||  
 coalesce(r.fechanacimiento_o_constitucion_de_persona_moral::text,'')||';'||  
 coalesce(r.codigo_postal_del_domicilio::text,'')||';'||  
 coalesce(r.localidad_del_domicilio::text,'')||';'||  
 coalesce(r.estado_del_domicilio::text,'')||';'||  
 coalesce(r.pais_del_domicilio::text,'')||';'||  
 coalesce(r.numero_de_certificados_de_aportacion_ordinaria::text,'')||';'||  
 coalesce(r.monto_de_certificados_de_aportacion_ordinaria::text,'')||';'|| 
 coalesce(r.numero_de_certificados_exedentes_o_voluntarios::text,'')||';'||  
 coalesce(r.monto_de_certificados_exedentes_o_voluntarios::text,'')||';'||  
 coalesce(r.numero_de_contrato::text,'')||';'|| 
 coalesce(x_numero_cuenta::text,'')||';'|| 
 coalesce(r.nombre_de_sucursal_que_opera_el_deposito::text,'')||';'||  
 coalesce(r.fecha_de_contratacion::text,'')||';'||  
 coalesce(r.tipo_de_producto::text,'')||';'||  
 coalesce(r.tipo_de_modalidad::text,'')||';'||  
 coalesce(r.tasa_de_rendimiento_anual::text,'')||';'||  
 coalesce(r.moneda::text,'')||';'||  
 coalesce(r.plazo::text,'')||';'||  
 coalesce(r.fecha_de_vencimiento::text,'')||';'|| 
 coalesce(r.saldo_de_la_cuenta_al_inicio_del_periodo::text,'')||';'||  
 coalesce(r.monto_de_deposito_de_dinero::text,'')||';'||  
 coalesce(r.monto_del_retiro_de_dinero::text,'')||';'||  
 coalesce(r.interes_devengados_no_pagado_en_el_periodo::text,'')||';'||  
 coalesce(r.saldo_de_la_cuenta_al_final_del_periodo::text,'')||';'||   
 coalesce(r.fecha_del_ultimo_movimiento::text,'')||';'||        
 coalesce(r.tipo_de_apertura_de_cuenta::text,'')||';'||
  ----------SE AGREGAN LOS DATOS DE LA CONSULTA DE COLUMNAS EXTRAS PARA PODER VALIDAR LA TABLA
 coalesce(r.fecha_ingreso::text,'')||';'||
 coalesce(r.actividad_economica::text,'')||';'||
 coalesce(r.clasificacion_riesgo::text,'')||';'||
 coalesce(r.estatus::text,'')||';'||
 coalesce(r.nombre_producto::text,'')||';'||
 coalesce(r.saldo_promedio::text,'')||';'||                                                                                                                                                                                        
 coalesce(r.numero_reinversiones::text,'')                                                                                                                                                                                                                              
 );

  y:=y+1;    
return next r;


RAISE NOTICE'|DATOS_REPORTE_COMPROBACION|%',coalesce(r.formulario::text,'')
                                   ||';'||coalesce(r.numero_de_identificacion::text,'')
                                   ||';'||coalesce(r.tipo_de_socio::text,'')
                                   ||';'||coalesce(r.nombre_razon_o_denominacion_social::text,'')
                                   ||';'||coalesce(r.apellido_paterno_del_socio::text,'')
                                   ||';'||coalesce(r.apellido_materno_del_socio::text,'')
                                   ||';'||coalesce(r.rfc_del_socio::text,'')
                                   ||';'||coalesce(r.curp_del_acreditado_persona_fisica::text,'')
                                   ||';'||coalesce(r.genero::text,'')
                                   ||';'||coalesce(r.fechanacimiento_o_constitucion_de_persona_moral::text,'')
                                   ||';'||coalesce(r.codigo_postal_del_domicilio::text,'')
                                   ||';'||coalesce(r.localidad_del_domicilio::text,'')
                                   ||';'||coalesce(r.estado_del_domicilio::text,'')
                                   ||';'||coalesce(r.pais_del_domicilio::text,'')
                                   ||';'||coalesce(r.numero_de_certificados_de_aportacion_ordinaria::text,'')
                                   ||';'||coalesce(r.monto_de_certificados_de_aportacion_ordinaria::text,'')
                                   ||';'||coalesce(r.numero_de_certificados_exedentes_o_voluntarios ::text,'')
                                   ||';'||coalesce(r.monto_de_certificados_exedentes_o_voluntarios::text,'')
                                   ||';'||coalesce(r.numero_de_contrato::text,'')
                                   ||';'||coalesce(x_numero_cuenta::text,'')
                                   ||';'||coalesce(r.nombre_de_sucursal_que_opera_el_deposito::text,'')
                                   ||';'||coalesce(r.fecha_de_contratacion::text,'')
                                   ||';'||coalesce(r.tipo_de_producto::text,'')
                                   ||';'||coalesce(r.tipo_de_modalidad::text,'')
                                   ||';'||coalesce(r.tasa_de_rendimiento_anual::text,'')
                                   ||';'||coalesce(r.moneda::text,'')
                                   ||';'||coalesce(r.plazo ::text,'')
                                   ||';'||coalesce(r.fecha_de_vencimiento::text,'')
                                   ||';'||coalesce(r.saldo_de_la_cuenta_al_inicio_del_periodo::text,'')
                                   ||';'||coalesce(r.monto_de_deposito_de_dinero::text,'')
                                   ||';'||coalesce(r.monto_del_retiro_de_dinero ::text,'')
                                   ||';'||coalesce(r.interes_devengados_no_pagado_en_el_periodo::text,'')
                                   ||';'||coalesce(r.saldo_de_la_cuenta_al_final_del_periodo ::text,'')
                                   ||';'||coalesce(r.fecha_del_ultimo_movimiento::text,'')
                                   ||';'||coalesce(r.tipo_de_apertura_de_cuenta::text,'')
                                   --SE AGREGAR LAS COLUMNAS EXTRAS SOLICITADAS
                                   ||';'||coalesce(r.fecha_ingreso::text,'')
                                   ||';'||coalesce(r.actividad_economica::text,'')
                                   ||';'||coalesce(r.clasificacion_riesgo::text,'')
                                   ||';'||coalesce(r.estatus::text,'')
                                   ||';'||coalesce(r.nombre_producto::text,'')
                                   ||';'||coalesce(r.saldo_promedio::text,'')
                                   ||';'||coalesce(r.numero_reinversiones::text,'')
                                   ;

                                   
                                   
           RAISE NOTICE'|DATOS_REPORTE|%',coalesce(r.formulario::text,'')
                                   ||';'||coalesce(r.numero_de_identificacion::text,'')
                                   ||';'||coalesce(r.tipo_de_socio::text,'')
                                   ||';'||coalesce(r.nombre_razon_o_denominacion_social::text,'')
                                   ||';'||coalesce(r.apellido_paterno_del_socio::text,'')
                                   ||';'||coalesce(r.apellido_materno_del_socio::text,'')
                                   ||';'||coalesce(r.rfc_del_socio::text,'')
                                   ||';'||coalesce(r.curp_del_acreditado_persona_fisica::text,'')
                                   ||';'||coalesce(r.genero::text,'')
                                   ||';'||coalesce(r.fechanacimiento_o_constitucion_de_persona_moral::text,'')
                                   ||';'||coalesce(r.codigo_postal_del_domicilio::text,'')
                                   ||';'||coalesce(r.localidad_del_domicilio::text,'')
                                   ||';'||coalesce(r.estado_del_domicilio::text,'')
                                   ||';'||coalesce(r.pais_del_domicilio::text,'')
                                   ||';'||coalesce(r.numero_de_certificados_de_aportacion_ordinaria::text,'')
                                   ||';'||coalesce(r.monto_de_certificados_de_aportacion_ordinaria::text,'')
                                   ||';'||coalesce(r.numero_de_certificados_exedentes_o_voluntarios ::text,'')
                                   ||';'||coalesce(r.monto_de_certificados_exedentes_o_voluntarios::text,'')
                                   ||';'||coalesce(r.numero_de_contrato::text,'')
                                   ||';'||coalesce(x_numero_cuenta::text,'')
                                   ||';'||coalesce(r.nombre_de_sucursal_que_opera_el_deposito::text,'')
                                   ||';'||coalesce(r.fecha_de_contratacion::text,'')
                                   ||';'||coalesce(r.tipo_de_producto::text,'')
                                   ||';'||coalesce(r.tipo_de_modalidad::text,'')
                                   ||';'||coalesce(r.tasa_de_rendimiento_anual::text,'')
                                   ||';'||coalesce(r.moneda::text,'')
                                   ||';'||coalesce(r.plazo ::text,'')
                                   ||';'||coalesce(r.fecha_de_vencimiento::text,'')
                                   ||';'||coalesce(r.saldo_de_la_cuenta_al_inicio_del_periodo::text,'')
                                   ||';'||coalesce(r.monto_de_deposito_de_dinero::text,'')
                                   ||';'||coalesce(r.monto_del_retiro_de_dinero ::text,'')
                                   ||';'||coalesce(r.interes_devengados_no_pagado_en_el_periodo::text,'')
                                   ||';'||coalesce(r.saldo_de_la_cuenta_al_final_del_periodo ::text,'')
                                   ||';'||coalesce(r.fecha_del_ultimo_movimiento::text,'')
                                   ||';'||coalesce(r.tipo_de_apertura_de_cuenta::text,'')
                                   --SE AGREGAR LAS COLUMNAS EXTRAS SOLICITADAS
                                   ||';'||coalesce(r.fecha_ingreso::text,'')
                                   ||';'||coalesce(r.actividad_economica::text,'')
                                   ||';'||coalesce(r.clasificacion_riesgo::text,'')
                                   ||';'||coalesce(r.estatus::text,'')
                                   ||';'||coalesce(r.nombre_producto::text,'')
                                   ||';'||coalesce(r.saldo_promedio::text,'')
                                   ||';'||coalesce(r.numero_reinversiones::text,'')
                                   ;
                                   
                                   

end loop;


  select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');



  execute 'copy (select fila from copiar order by id) to ''/tmp/reg_841_cnbv_ce_'||fecha||'.csv''  ';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/reg_841_cnbv_se_'||fecha||'.csv''  ';


    
END;
 
$function$
;
