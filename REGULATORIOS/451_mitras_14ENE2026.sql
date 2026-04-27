-- DROP FUNCTION public.reg_451();

CREATE OR REPLACE FUNCTION public.reg_451()
 RETURNS SETOF tipo_reg_451
 LANGUAGE plpgsql
AS $function$

DECLARE
rec record;
r  tipo_reg_451%rowtype;
consulta  text;
r_rec  record;
checa integer;
rev  integer;
y  integer;
fecha  varchar;
BEGIN

execute 'select per_rel ()';     -----ejecucion de funcion de personas relacionadas

/*
SELECT into rev count(*)
  FROM information_schema.tables
 WHERE table_schema='public'
   AND table_name='eprc_tmp2';




if rev=0 then
execute 'SELECT crea_tabla_temporal_eprcc_2 ((SELECT DISTINCT fechatrabajo FROM origenes)::DATE)';
end if;*/

consulta:='SELECT distinct
''0451'' as "CLAVE DEL SUBREPORTE",---  -----------------------------------------------------------------------------3
-------------------------------SECCION II UBICACION DEL CREDITO----------------------------------------------------------
(select idmunicipio from claves_siti_municipios cvm where cvm.idestado=p.idestado and (select UPPER(reemplaza_letras(mn.nombre)) from municipios mn where mn.idmunicipio=p.idmunicipio) = UPPER(reemplaza_letras(cvm.nombre_municipio)) limit 1)
/*coalesce(p.codigopostal::INTEGER, 0)*/ as "MUNICIPIO",---------------------------------------------------------------------4
(case when upper(e.nombre) like ''AGUA%'' THEN ''00001'' 
when upper(e.nombre) like ''BAJA CALIFORNIA NORTE'' OR upper(e.nombre) like ''BAJA CALIFORNIA'' THEN ''00002'' 
when upper(e.nombre) like ''BAJA CALIFORNIA SUR'' THEN ''00003'' 
when upper(e.nombre) like ''CAMP%''       THEN ''00004'' 
when upper(e.nombre) like ''COAH%''       THEN ''00005'' 
when upper(e.nombre) like ''COLI%''       THEN ''00006'' 
when upper(e.nombre) like ''CHIA%''       THEN ''00007'' 
when upper(e.nombre) like ''CHIH%''       THEN ''00008'' 
when upper(e.nombre) like ''DIST%''       THEN ''00009'' 
when upper(e.nombre) like ''CIUD%MEX%''   THEN ''00009''
when upper(e.nombre) like ''CD%MEX%''     THEN ''00009''
when upper(e.nombre) like ''DURA%''       THEN ''00010'' 
when upper(e.nombre) like ''GUAN%''       THEN ''00011'' 
when upper(e.nombre) like ''GUER%''       THEN ''00012'' 
when upper(e.nombre) like ''HIDA%''       THEN ''00013'' 
when upper(e.nombre) like ''JALI%''       THEN ''00014'' 
when upper(e.nombre) like ''MEXI%''       THEN ''00015'' 
when upper(e.nombre) like ''ESTADO%MEX%'' THEN ''00015''
when upper(e.nombre) like ''EDO%MEX%''    THEN ''00015''  
when upper(e.nombre) like ''MICH%''       THEN ''00016'' 
when upper(e.nombre) like ''MORE%''       THEN ''00017'' 
when upper(e.nombre) like ''NAYA%''       THEN ''00018'' 
when upper(e.nombre) like ''NUEV%''       THEN ''00019'' 
when upper(e.nombre) like ''OAXA%''       THEN ''00020'' 
when upper(e.nombre) like ''PUEB%''       THEN ''00021'' 
when upper(e.nombre) like ''QUER%''       THEN ''00022'' 
when upper(e.nombre) like ''QUIN%''       THEN ''00023'' 
when upper(e.nombre) like ''SAN%''        THEN ''00024'' 
when upper(e.nombre) like ''SINA%''       THEN ''00025'' 
when upper(e.nombre) like ''SONO%''       THEN ''00026'' 
when upper(e.nombre) like ''TABA%''       THEN ''00027'' 
when upper(e.nombre) like ''TAMA%''       THEN ''00028'' 
when upper(e.nombre) like ''TLAX%''       THEN ''00029'' 
when upper(e.nombre) like ''VERA%''       THEN ''00030'' 
when upper(e.nombre) like ''YUCA%''       THEN ''00031'' 
when upper(e.nombre) like ''ZACA%''       THEN ''00032''  END) as "ESTADO",-----------------------------------------------------------5
 -------------------------------SECCION III IDENTIFICADOR DEL ACREDITADO----------------------------------------------------
(TRIM(TO_CHAR(cv.idorigen,''09999999999999''))||TRIM(TO_CHAR(cv.idgrupo,''09''))||TRIM(TO_CHAR(cv.idsocio,''099999'')))
AS "IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD",-------------------------- ---------------------------6
(case when p.razon_social is null or p.razon_social='''' then 1 else 2 end) 
AS "PERSONALIDAD JURIDICA",--------------------------------------------------------------------------------------7
UPPER(p.nombre) AS"NOMBRE , RAZON O DENOMINACION SOCIAL DEL SOCIO O SOCAP",--------------------------------------8
UPPER(p.appaterno) AS"APELLIDO PATERNO DEL SOCIO",---------------------------------------------------------------9
(CASE WHEN p.apmaterno ='''' or p.apmaterno is null then ''NO APLICA'' else upper(p.apmaterno)end) AS "APELLIDO MATERNO DEL SOCIO",--------------------------------------------------------------10
trim(p.rfc) as "RFC DEL ACREDITADO",----------------------------------------------------------------------------11
trim(case when p.curp is not null then p.curp else ''0'' end) as "CURP DEL ACREDITADO PERSONA FISICA",-----------------------------------------------------------12

(CASE WHEN p.sexo =1 then ''2'' when p.sexo=2 then ''1'' else ''0'' end ) AS "GENERO DEL SOCIO O CLIENTE",------13

 ---------------------------------SECCION IV IDENTIFICADOR DEL CREDITO---------------------------------------------
TRIM(TO_CHAR(cv.idorigenp,''99999''))||TRIM(TO_CHAR(cv.idproducto,''99999''))
||TRIM(TO_CHAR(cv.idauxiliar,''099999999999'')) 
AS "IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD",----------------------------------------------------14
(select clave_regularorio from claves_regulatorios_sucursales cvr where cvr.idorigen=a.idorigenp limit 1)  as "SUCURSAL QUE OPERA EL CREDITO",------------------------------------------------------------15
(select a.clave from
(SELECT p.idproducto,
                     CASE 
                     WHEN cuentaaplica LIKE ''104010101%''   and cv.cartera !=''V'' THEN ''0130105010000''
                     WHEN cuentaaplica LIKE ''104010101%''   and cv.cartera  =''V'' THEN ''0135105010000''
                     
                     WHEN cuentaaplica LIKE ''104010102%''   and cv.cartera !=''V'' THEN ''0130105020000'' 
                     WHEN cuentaaplica LIKE ''104010102%''   and cv.cartera  =''V'' THEN ''0135105020000'' 

                     WHEN cuentaaplica LIKE ''104010103%''   and cv.cartera !=''V'' THEN ''0130105040000''
                     WHEN cuentaaplica LIKE ''104010103%''   and cv.cartera  =''V'' THEN ''0135105040000''  

                     WHEN cuentaaplica LIKE ''104010104%''   and cv.cartera !=''V'' THEN ''0130105050000''
                     WHEN cuentaaplica LIKE ''104010104%''   and cv.cartera  =''V'' THEN ''0135105050000''   

                     WHEN cuentaaplica LIKE ''104010105%''   and cv.cartera !=''V'' THEN ''0130105070000''
                     WHEN cuentaaplica LIKE ''104010105%''   and cv.cartera  =''V'' THEN ''0135105070000''     

                     WHEN cuentaaplica LIKE ''104010106%''   and cv.cartera !=''V'' THEN ''0130105060000''
                     WHEN cuentaaplica LIKE ''104010106%''   and cv.cartera  =''V'' THEN ''0135105060000''  

                     WHEN cuentaaplica LIKE ''104020101%''   and cv.cartera !=''V'' THEN ''0131101000000''
                     WHEN cuentaaplica LIKE ''104020101%''   and cv.cartera  =''V'' THEN ''0136101000000''   

                     WHEN cuentaaplica LIKE ''104020201%''   and cv.cartera !=''V'' THEN ''0131103000000''
                     WHEN cuentaaplica LIKE ''104020201%''   and cv.cartera  =''V'' THEN ''0136103000000''  

                     WHEN cuentaaplica LIKE ''104020301%''   and cv.cartera !=''V'' THEN ''0131113000000''
                     WHEN cuentaaplica LIKE ''104020301%''   and cv.cartera  =''V'' THEN ''0136113000000''    

                     WHEN cuentaaplica LIKE ''104020401%''   and cv.cartera !=''V'' THEN ''0131105000000''
                     WHEN cuentaaplica LIKE ''104020401%''   and cv.cartera  =''V'' THEN ''0136105000000''    

                     WHEN cuentaaplica LIKE ''104020501%''   and cv.cartera !=''V'' THEN ''0131106000000''
                     WHEN cuentaaplica LIKE ''104020501%''   and cv.cartera  =''V'' THEN ''0136106000000''   

                     WHEN cuentaaplica LIKE ''104020601%''   and cv.cartera !=''V'' THEN ''0131104000000''
                     WHEN cuentaaplica LIKE ''104020601%''   and cv.cartera  =''V'' THEN ''0136104000000''  

                     WHEN cuentaaplica LIKE ''10402070%''    and cv.cartera !=''V'' THEN ''0131190000000''
                     WHEN cuentaaplica LIKE ''10402070%''    and cv.cartera  =''V'' THEN ''0136190000000'' 

                     WHEN cuentaaplica LIKE ''104030101%''   and cv.cartera !=''V'' THEN ''131601000000''
                     WHEN cuentaaplica LIKE ''104030101%''   and cv.cartera  =''V'' THEN ''136601000000''  

                     WHEN cuentaaplica LIKE ''104030201%''   and cv.cartera !=''V'' THEN ''0131602000000''
                     WHEN cuentaaplica LIKE ''104030201%''   and cv.cartera  =''V'' THEN ''0136602000000''
                     
                    else ''0000000000000'' END AS clave
FROM productos AS p WHERE tipoproducto=2 ORDER BY p.cuentaaplica) as a
where a.idproducto=cv.idproducto limit 1)::numeric
as "CLASIFICACION DEL CREDITO POR DESTINO",-------------------------------------------------------------------16
(select clave_regularorio from claves_regulatorios_productos cvr where cvr.idproducto=a.idproducto limit 1) as "PRODUCTO DE CREDITO",---------------------------------------------------------------------------17

TO_CHAR(cv.fechaprestamo,''YYYY-MM-DD'') as "FECHA DE DISPOSICION DEL CREDITO",--------------------------18

to_char((SELECT max(am.vence) from amortizaciones am where (am.idorigenp,am.idproducto,
am.idauxiliar)=(cv.idorigenp,cv.idproducto,
cv.idauxiliar)),''yyyy-mm-dd'') as "FECHA DE VENCIMIENTO DEL CREDITO",-----------------------------------19

(case 
when a.plazo=1 then 1
else 3 end)
as "MODALIDAD DE PAGO",---------------------------------------------------------------------------------------20

cv.montoprestado AS "MONTO ORIGINAL DEL CREDITO",------------------------------------------------------21
(CASE WHEN a.pagodiafijo = 1 THEN ''30'' ELSE (CASE WHEN a.periodoabonos <= 0 THEN ''30'' ELSE a.periodoabonos END) END) "FRECUENCIA DE PAGO DE CAPITAL",---------------------22


(CASE WHEN a.pagodiafijo = 1 THEN ''30'' ELSE (CASE WHEN a.periodoabonos <= 0 THEN ''30'' ELSE a.periodoabonos END) END)"FRECUENCIA DE PAGO DE INTERES",------------------------------------23
round(a.tasaio * 12::numeric,4) as "TASA DE INTERES ORDINARIA",-----------------------------------------------------------------24


coalesce(to_char((select max(date(ad.fecha)) from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3)  and 
ad.monto>0 and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1)
,''yyyy-mm-dd''),''9999-12-31'') as "FECHA DEL ULTIMO PAGO DE CAPITAL",---------------------------------------------------------------25

coalesce((select monto from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3) and ad.monto>0 and
(ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar)order by fecha
desc limit 1)::NUMERIC,0) as "MONTO DEL ULTIMO PAGO DE CAPITAL",----------------------------------------------------------------26

 coalesce(to_char((select max(date(ad.fecha)) from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3)  and 
ad.montoio>0 and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) 
limit 1),''yyyy-mm-dd''),''9999-12-31'') as "FECHA DEL ULTIMO PAGO DE INTERES",-------------------------------------------------------27

coalesce((select montoio from v_auxiliares_d ad where ad.cargoabono=1 and  ad.tipomov not in(3) and ad.montoio>0 and
(ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar)order by fecha 
desc limit 1)::NUMERIC,0) as "MONTO DEL ULTIMO PAGO DE INTERES",----------------------------------------------------------------28

/*(case when coalesce(to_char((select max(date(ad.fecha)) from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3)  and 
ad.monto>0 and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1)
,''yyyymmdd''),''0'')::integer =0  and  cv.diasvencidos>=0 and  cv.cartera = ''C'' 

     then ''19000101'' 
else
coalesce(to_char((SELECT MIN(vence) FROM amortizaciones am WHERE am.idorigenp = a.idorigenp AND am.idproducto = a.idproducto 
AND am.idauxiliar = a.idauxiliar AND am.todopag = ''f'' AND DATE(vence) <= 
(SELECT DISTINCT fechatrabajo FROM origenes)::DATE),''yyyymmdd'')::numeric,0)
end
)*/

(case when cv.diasvencidos = 0 then ''9999-12-31'' 
      else trim(to_char(((select distinct date(fechatrabajo) from origenes limit 1)-cv.diasvencidos), ''yyyy-mm-dd''))
 end)

AS "FECHA DE LA PRIMERA AMORTIZACION NO CUBIERTA",------------------------------------------------------------------------------29


coalesce((select  sum(c.montoio+c.montoim) from(select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,
ad.idproducto,ad.idauxiliar,ad.fecha::date,ad. monto,ad.montoio,ad. montoim,ad. montoiva from v_auxiliares_d 
ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar) where ad.tipomov=3 AND a.estatus in(2,3) and 
ad.idproducto between 30000 and 39999 and ad.periodo::integer=(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer
 from origenes) ) as c where
(c.idorigen,c.idgrupo,c.idsocio,c.idorigenp,c.idproducto,c.idauxiliar)=(cv.idorigen,cv.idgrupo,cv.idsocio,
cv.idorigenp,cv.idproducto,cv.idauxiliar)),0)as "MONTO DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO",---------------------30



case when(to_char((select  max(fecha) from(select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar,
ad.fecha::date,ad. monto,ad.montoio,ad. montoim,ad. montoiva from v_auxiliares_d ad 
                                                       inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
    where ad.tipomov=3 AND a.estatus in (2,3) and ad.idproducto
   between 30000 and 39999 and ad.periodo::integer=(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes))
 as c where (c.idorigen,c.idgrupo,c.idsocio,c.idorigenp,c.idproducto,
c.idauxiliar)=(cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1 )
,''yyyymmdd'')::numeric) is not null
 
 then
to_char((select  max(fecha) from(select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar,
ad.fecha::date,ad. monto,ad.montoio,ad. montoim,ad. montoiva from v_auxiliares_d ad 
                                                       inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
    where ad.tipomov=3 AND a.estatus in (2,3) and ad.idproducto
   between 30000 and 39999 and ad.periodo::integer=(select distinct to_char(date(fechatrabajo),''yyyymm'')::integer from origenes))
 as c where (c.idorigen,c.idgrupo,c.idsocio,c.idorigenp,c.idproducto,
c.idauxiliar)=(cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1 )
,''yyyy-mm-dd'')

else ''9999-12-31'' end as "FECHA DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO",------------------------------------------31

cv.diasvencidos as "DIAS DE MORA (RETRASO)",------------------------------------------------------------------------------------32

(case when a.tipoprestamo=0 then ''01'' when a.tipoprestamo in(1,3) then ''02'' when a.tipoprestamo in(2,4) then ''03'' 
when a.tipoprestamo=5 then ''04'' end)::text as "TIPO DE CREDITO",-------------------------------------------------------------------33

(case when cv.diasvencidos=0 and  cv.cartera = ''C'' then ''01'' 
      when cv.diasvencidos>0 and (cv.cartera=''C'' or cv.cartera=''M'') THEN ''02'' 
      when cv.cartera = ''V'' and
           (a.idorigenp,a.idproducto,a.idauxiliar) in
           (select TO_NUMBER(TRIM(SAI_TOKEN(1, titulo, ''|''))::TEXT, ''999999'') AS idorigenp, 
                   TO_NUMBER(TRIM(SAI_TOKEN(2, titulo, ''|''))::TEXT, ''999999'') AS idproducto,
                   TO_NUMBER(TRIM(SAI_TOKEN(3, titulo, ''|''))::TEXT, ''99999999'') AS idauxiliar
                   from historial where tipomensaje=7) THEN ''04''
      when cv.cartera=''V'' and (select tiporeferencia from referenciasp rp where rp.tiporeferencia=3 and rp.idorigenp=cv.idorigenp and rp.idproducto=cv.idproducto and rp.idauxiliar=cv.idauxiliar)is not null then ''05'' 
      when cv.cartera=''V'' and (select tiporeferencia from referenciasp rp where rp.tiporeferencia=2 and rp.idorigenp=cv.idorigenp and rp.idproducto=cv.idproducto and rp.idauxiliar=cv.idauxiliar)is not null then ''06''
      else ''03'' END)"SITUACION CONTABLE DEL CREDITO",-------------------------------------------------------------------------34
a.saldo as "CAPITAL",-----------------------------------------------------------------------------------------------------------35
a.idnc as "INTERESES ORDINARIOS",-----------------------------------------------------------------------------------------------36
a.idncm as "INTERESES MORATORIOS",----------------------------------------------------------------------------------------------37
trim(to_char(a.ieco,''099999999999999999.99'')) as "INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE",---------------------------------------------------------------------38
trim(to_char((a.iecom + a.im),''099999999999999999.99'')) as "INTERESES MORATORIOS VENCIDOS FUERA DE BALANCE",-----------------------------------------------------------39
''000000000000000000.00'' "INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS",------------------------------------------------------------------------40
a.saldo+a.idnc+a.idncm AS "SALDO INSOLUTO DEL CREDITO",-------------------------------------------------------------------------41
coalesce((select (case when z.idorigenp=0 and z.idproducto=0 and z.idauxiliar=0 then catalogo 
         when z.idorigenp=cv.idorigenp and z.idproducto=cv.idproducto and z.idauxiliar=cv.idauxiliar then catalogo else 1 end) 
    from relacionadas_tabla z where (z.idorigen,z.idgrupo,z.idsocio)=(cv.idorigen,cv.idgrupo,cv.idsocio) order by catalogo asc limit 1 ),1)
AS "TIPO DE ACREDITADO RELACIONADO",--------------------------------------------------------------------------------------------42

(case when pr.tipofinalidad = 1 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,idproducto, idauxiliar  
                                                                                     from eprc_tmp2 where emproblemado =''SI'') then 2
      when pr.tipofinalidad = 1 then 1 
      when pr.tipofinalidad = 2 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,idproducto,idauxiliar
                                                                                     from eprc_tmp2 where emproblemado =''SI'') then 4
      when pr.tipofinalidad = 2 then 3 
-----para tipo vivienda y estan con garantia valida y estan emproblemados
      when pr.tipofinalidad =3 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in(select SAI_TOKEN(2,idnota,''|'')::integer as idorigenp,
                                                                                         SAI_TOKEN(3,idnota,''|'')::integer as idproducto,
                                                                                         SAI_TOKEN(4,idnota,''|'')::integer as idauxiliar
                                                                                    from notas
                                                                                   where UPPER(idnota) like ''GAR%'' and SAI_FINDSTR(nota,''|'') > 1 
                                                                                     and SAI_FINDSTR(nota,''|'') < 7 and TRIM(SAI_TOKEN(4,nota,''|''))<>'''' 
                                                                                     and descripcion is not null and LENGTH(descripcion) > 0
                                                                                     and TO_NUMBER(REPLACE(descripcion,'','','''')::TEXT,''999999999999.99'')>0
                                                                                  union
                                                                                  select idorigenp, idproducto, idauxiliar
                                                                                    from garantias_hipotecarias
                                                                                   where es_prendaria = FALSE
                                                                                     and usuario_valido > 0
                                                                                 ) 
       and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,idproducto,idauxiliar  
                                                            from eprc_tmp2 
                                                           where emproblemado =''SI'') then 9      
 -----para tipo vivienda y estan con garantia valida
      when pr.tipofinalidad =3 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in(select SAI_TOKEN(2,idnota,''|'')::integer as idorigenp,
                                                                                         SAI_TOKEN(3,idnota,''|'')::integer as idproducto,
                                                                                         SAI_TOKEN(4,idnota,''|'')::integer as idauxiliar
                                                                                    from notas
                                                                                   where UPPER(idnota) like ''GAR%'' and SAI_FINDSTR(nota,''|'') > 1 
                                                                                     and SAI_FINDSTR(nota,''|'') < 7 and TRIM(SAI_TOKEN(4,nota,''|''))<>'''' 
                                                                                     and descripcion is not null and LENGTH(descripcion) > 0
                                                                                     and TO_NUMBER(REPLACE(descripcion,'','','''')::TEXT,''999999999999.99'')>0
                                                                                  union
                                                                                  select idorigenp, idproducto, idauxiliar
                                                                                    from garantias_hipotecarias
                                                                                   where es_prendaria = FALSE
                                                                                     and usuario_valido > 0)  then 8
-----para tipo vivienda y no estan con garantia valida(se va a consumo)
      when pr.tipofinalidad =3 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) not in(select SAI_TOKEN(2,idnota,''|'')::integer as idorigenp,
                                                                                            SAI_TOKEN(3,idnota,''|'')::integer as idproducto,
                                                                                            SAI_TOKEN(4,idnota,''|'')::integer as idauxiliar
                                                                                       from notas
                                                                                      where UPPER(idnota) like ''GAR%'' and SAI_FINDSTR(nota,''|'') > 1 
                                                                                        and SAI_FINDSTR(nota,''|'') < 7 and TRIM(SAI_TOKEN(4,nota,''|''))<>'''' 
                                                                                        and descripcion is not null and LENGTH(descripcion) > 0
                                                                                        and TO_NUMBER(REPLACE(descripcion,'','','''')::TEXT,''999999999999.99'')>0
                                                                                     union
                                                                                     select idorigenp, idproducto, idauxiliar
                                                                                       from garantias_hipotecarias
                                                                                      where es_prendaria = FALSE
                                                                                        and usuario_valido > 0)  then 1 end )  
as "TIPO DE CARTERA PARA FINES DE CALIFICACION",-------------------------------------------------------------------------------43
''000000000000000000.00'' AS "CALIFICACION DEL DEUDOR",------------------------------------------------------------------------------------------------44


 /*(case when (case when et.parte_cub = 0 then 0.00 else round((et.e_parte_cub/et.parte_cub)*100.0,2) end)>0 
              then (case when et.parte_cub = 0 then 0.00 else round((et.e_parte_cub/et.parte_cub)*100.0,2) end)
              else 
              (case when et.parte_cub_i = 0 then 0.00 else round((et.e_parte_cub_i/et.parte_cub_i)*100.0,2) end)
              end)*/


1 AS "CALIFICACION PARTE CUBIERTA",--------------------------------------------------------------------------------------------45

/*(case when (case when et.parte_exp = 0 then 0.00 else round((et.e_parte_exp/et.parte_exp)*100.0,2) end)>0 
              then (case when et.parte_exp = 0 then 0.00 else round((et.e_parte_exp/et.parte_exp)*100.0,2) end)
              else 
              (case when et.parte_cub_i = 0 then 0.00 else round((et.e_parte_cub_i/et.parte_cub_i)*100.0,2) end)
              end)*/

(case when (cv.diasvencidos = 0)then 1
      when (cv.diasvencidos between 1 and 7)then 4
      when (cv.diasvencidos between 8 and 30) then 15
      when (cv.diasvencidos between 31 and 60)then 30
      when (cv.diasvencidos between 61 and 90)then 50
      when (cv.diasvencidos between 91 and 120)then 75 
      when (cv.diasvencidos between 121 and 180)then 90
      when (cv.diasvencidos > 180) then 100 end)
 AS "CALIFICACION PARTE EXPUESTA",--------------------------------------------------------------------------------------------46


round((et.e_parte_cub + et.e_parte_cub_i),2) AS "MONTO DE ESTIMACIONES PARTE CUBIERTA",----------------------------------------47
round((et.e_parte_exp + et.e_parte_exp_i),2) AS "MONTO DE ESTIMACIONES PARTE EXPUESTA",----------------------------------------48
coalesce((CASE WHEN cv.cartera = ''V'' THEN a.idnc+a.idncm END),0)
AS "E P A DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA",----------------------------------------------------------------------49
''000000000000000000.00'' AS "E P A POR RIESGOS OPERATIVOS (SIC)",------------------------------------------------------------------50 
''000000000000000000.00'' AS "E P A CNBV",------------------------------------------------------------------------------------------51  







(case 
when (select br.fecha from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST(''90 day'' AS INTERVAL)))) and cv.fechaprestamo
and br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio and br.idorigenp=cv.idorigenp and br.idproducto=cv.idproducto and br.idauxiliar=cv.idauxiliar 
ORDER BY br.fecha desc limit 1 ) is not null
then 
(select to_char(br.fecha,''YYYY-MM-DD'') from revision_buro br where  br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST(''90 day'' AS INTERVAL)))) and cv.fechaprestamo and 
br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio and br.idorigenp=cv.idorigenp and br.idproducto=cv.idproducto and br.idauxiliar=cv.idauxiliar 
ORDER BY br.fecha desc limit 1)

when (select br.fecha from revision_buro br where (br.idorigenp,br.idproducto,br.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) ORDER BY br.fecha desc limit 1) is null
and 
(select br.fecha from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST(''90 day'' AS INTERVAL)))) and cv.fechaprestamo
and (br.idorigen,br.idgrupo,br.idsocio)=(cv.idorigen,cv.idgrupo,cv.idsocio) ORDER BY br.fecha desc limit 1 ) is not null
then
(select to_char(br.fecha,''YYYY-MM-DD'') from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST(''90 day'' AS INTERVAL)))) and cv.fechaprestamo and
br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio ORDER BY br.fecha desc limit 1 )

else ''9999-12-31''
end)

/*
when(select br.fecha from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio order by br.fecha desc limit 1) between date(date(cv.fechaprestamo)-''30 day''::interval) and cv.fechaprestamo
then (select trim(to_char(br.fecha,''YYYYMMDD'')) from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio order by br.fecha desc limit 1)

when ((select dato1 from tablas where  idelemento=(select  distinct to_char(date(date(fechatrabajo)-''1 MONTH''::interval)::date,''YYYYMM'') from origenes))::numeric * 1000) >= a.montoprestado
then ''00000002''

when (a.garantia=a.saldo)then ''00000003''

when (select dato5 from tablas where idtabla=''param'' and idelemento=''reporte_regulatorios'') is not null and 
(select trim(to_char(date(dato5),''YYYYMMDD'')) from tablas where idtabla=''param'' and idelemento=''reporte_regulatorios'')::numeric 
>
trim(to_char(a.fechaactivacion,''YYYYMMDD''))::numeric

then ''00000005''

else ''9999-12-31''*/ as "FECHA DE LA CONSULTA SIC",---------------------------------------------------------------------------------------------------52 



(case when a.cartera=''C'' and to_char(a.fechaactivacion,''yyyymm'') in(select distinct to_char(fechatrabajo,''yyyymm'') 
from origenes) then ''10000''
when cv.diasvencidos=0 then ''10001''
when cv.diasvencidos between 1 and 29 then ''10002''
when cv.diasvencidos between 30 and 59 then ''10003''
when cv.diasvencidos between 60 and 89 then ''10004''
when cv.diasvencidos between 90 and 119 then ''10005''
when cv.diasvencidos between 120 and 149 then ''10006''
when cv.diasvencidos between 150 and 365 then ''10007''
when cv.diasvencidos > 365 then ''10008''
when cv.diasvencidos > 365 and a.saldo=a.montoprestado then ''10009''
end)  AS "CLAVE DE PREVENCION",------------------------------------------------------------------------------------------------53   
coalesce(et.garantia,0) AS "GARANTIA LIQUIDA",---------------------------------------------------------------------------------54  
coalesce(hip.garantia,0) AS "GARANTIA HIPOTECARIA"-----------------------------------------------------------------------------55  
FROM (select * from carteravencida ) cv 
INNER JOIN vpersonas p USING (idorigen, idgrupo, idsocio)
inner join estados e using(idestado)
INNER JOIN municipios m using(idmunicipio) 
---------------------------------------------------PERSONAS RELACIONADAS---------------------------------------------------------
LEFT JOIN (select idorigen,idgrupo,idsocio,puesto::numeric from sopar where tipo like ''personas_relacionadas%'') s 
 using(idorigen,idgrupo,idsocio)
LEFT JOIN (SELECT  r.idorigen,r.idgrupo,r.idsocio,r.idorigenr ,r.idgrupor ,r.idsocior ,
 (CASE WHEN r.tiporeferencia in (0, 1, 7, 14, 15,24,25) then 6 END) as refe
 FROM sopar s inner join  referencias r 
on(r.idorigen,r.idgrupo,r.idsocio )=(s.idorigen,s.idgrupo,s.idsocio ) 
where tipo like ''personas_relacionadas%'' and r.tiporeferencia in(0, 1, 7, 14, 15,24,25)) seis 
 ON (seis.idorigenr,seis.idgrupor,seis.idsocior)=(cv.idorigen,cv.idgrupo,cv.idsocio)
------------------------------------------------------AUXILIARES------------------------------------------------------------------
INNER JOIN (select * from auxiliares ) a USING (idorigenp, idproducto, idauxiliar)
----------------------------------------------------------EPRC--------------------------------------------------------------------
LEFT JOIN eprc_tmp2 et USING (idorigenp, idproducto, idauxiliar)
-------------------------------------------------------PRODUCTOS------------------------------------------------------------------
INNER JOIN productos pr using(idproducto)
--------------------------------------------------GARANTIAS HIPOTECARIAS----------------------------------------------------------
LEFT JOIN (SELECT idorigenp, idproducto, idauxiliar, SUM(garantia) AS garantia
             FROM (SELECT TO_NUMBER(TRIM(SAI_TOKEN(2, idnota, ''|''))::TEXT, ''999999'') AS idorigenp, 
                          TO_NUMBER(TRIM(SAI_TOKEN(3, idnota, ''|''))::TEXT, ''999999'') AS idproducto,
                          TO_NUMBER(TRIM(SAI_TOKEN(4, idnota, ''|''))::TEXT, ''99999999'') AS idauxiliar,
                          SUM(TO_NUMBER((CASE WHEN (REPLACE(descripcion,'','','''') > ''0'') THEN (REPLACE(descripcion,'','','''')) 
                                            ELSE ''0'' END),''999999999999.99'')) AS garantia
                     FROM notas 
                    WHERE UPPER(idnota) LIKE ''GAR%%'' 
                      AND SAI_FINDSTR(nota, ''|'') > 1
                      AND SAI_FINDSTR(nota, ''|'') < 7 
                      AND TRIM(SAI_TOKEN(4, nota, ''|'')) <> ''''
                    GROUP BY idorigenp, idproducto, idauxiliar
           UNION
           SELECT idorigenp, idproducto, idauxiliar, monto AS garantia
             FROM garantias_hipotecarias
            WHERE es_prendaria = FALSE
              AND usuario_valido > 0) AS f
            GROUP BY idorigenp, idproducto, idauxiliar) AS hip 
ON (hip.idorigenp = cv.idorigenp
AND hip.idproducto = cv.idproducto
AND hip.idauxiliar = cv.idauxiliar)
where cv.saldo>0
';
     
     DROP TABLE IF EXISTS regulatorio451;
     create table regulatorio451 (
 clave_subreporte                         text, 
 municipio                                text, 
 estado                                   text,   
 identificador                            text,
 personalidad_juridica                    integer,   
 nombre                                   text,
 apaterno                                 text, 
 amaterno                                 text,
 rfc                                      text,
 curp                                     text,
 genero                                   text,
 credito                                  text,
 sucursal                                 text,   
 clasificacion_destino                    text,   
 producto_credito                         character varying(60), 
 fecha_disposicion                        text,   
 fecha_vencimiento                        text,   
 modalidad_pago                           integer,   
 monto_original                           text,   
 frecuencia_pago_capital                  text,   
 frecuencia_pago_interes                  text,   
 tasa_io                                  text,   
 fecha_ultimo_pago_capital                text,   
 monto_ultimo_pago_capital                text,   
 fecha_ultimo_pago_interes                text,   
 monto_ultimo_pago_interes                text,   
 fecha_primara_amortizacion_no_cubierta   text,   
 monto_condonacion                        text,   
 fecha_condonacion                        text,   
 dias_mora                                text,   
 tipo_credito                             text,   
 situacion_contable                       text,
 capital                                  text,   
 io                                       text,   
 im                                       text,   
 io_vencido_fuera_valance                 text,   
 im_vencido_fuera_valance                 text,   
 interes_refinanciado                     text,  
 saldo_insoluto                           text,   
 acreditado_relacionado                   text,   
 cartera_fines_calificacion               text,   
 calificacion_deudor                      text,   
 cal_parte_cubierta                       text,   
 cal_parte_expuesta                       text,   
 monto_estimacion_parte_cubierta          text,   
 monto_estimacion_parte_expuesta          text,   
 e_p_a_interes_devengado_cartera_vencida  text,   
 e_p_a_riesgos_oparativos_sic             text,   
 e_p_a_cnbv                               text,   
 fecha_consulta_sic                       text,   
 clave_prevencion                         text,
 garantia_liquida                         text,   
 garantia_hipotecaria                     text   
);


drop table if exists copiar;
create temp table copiar(
id  integer,
fila   text
);

y:=0;


 insert into copiar values(y,'CLAVE DEL SUBREPORTE;MUNICIPIO;ESTADO;IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD;PERSONALIDAD JURIDICA;NOMBRE , RAZON O DENOMINACION SOCIAL DEL SOCIO O SOCAP;APELLIDO PAT
ERNO DEL SOCIO;APELLIDO MATERNO DEL SOCIO;RFC DEL ACREDITADO;CURP DEL ACREDITADO PERSONA FISICA;GENERO DEL SOCIO O CLIENTE;IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD;SUCURSAL QUE OPERA EL CREDITO;CLASIFI
CACION DEL CREDITO POR DESTINO;PRODUCTO DE CREDITO;FECHA DE DISPOSICION DEL CREDITO;FECHA DE VENCIMIENTO DEL CREDITO;MODALIDAD DE PAGO;MONTO ORIGINAL DEL CREDITO;FRECUENCIA DE PAGO DE CAPITAL;FRECUENCIA DE PAGO 
DE INTERES;TASA DE INTERES ORDINARIA;FECHA DEL ULTIMO PAGO DE CAPITAL;MONTO DEL ULTIMO PAGO DE CAPITAL;FECHA DEL ULTIMO PAGO DE INTERES;MONTO DEL ULTIMO PAGO DE INTERES;FECHA DE LA PRIMERA AMORTIZACION NO CUBIER
TA;MONTO DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO;FECHA DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO;DIAS DE MORA (RETRASO);TIPO DE CREDITO;SITUACION CONTABLE DEL CREDITO;CAPITAL;INTERESES ORDINA
RIOS;INTERESES MORATORIOS;INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE;INTERESES MORATORIOS VENCIDOS FUERA DE BALANCE;INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS;SALDO INSOLUTO DEL CREDITO;TIPO DE ACRE
DITADO RELACIONADO;TIPO DE CARTERA PARA FINES DE CALIFICACION;CALIFICACION DEL DEUDOR;CALIFICACION PARTE CUBIERTA;CALIFICACION PARTE EXPUESTA;MONTO DE ESTIMACIONES PARTE CUBIERTA;MONTO DE ESTIMACIONES PARTE EXPU
ESTA;E P A DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA;E P A POR RIESGOS OPERATIVOS (SIC);E P A CNBV;FECHA DE LA CONSULTA SIC;CLAVE DE PREVENCION;GARANTIA LIQUIDA;GARANTIA HIPOTECARIA');
  y:=1;


RAISE NOTICE  '|DATOS_REPORTE_COMPROBACION|CLAVE DEL SUBREPORTE;MUNICIPIO;ESTADO;IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD;PERSONALIDAD JURIDICA;NOMBRE , RAZON O DENOMINACION SOCIAL DEL SOCIO O SOCAP;APELLIDO PATERNO DEL SOCIO;APELLIDO MATERNO DEL SOCIO;RFC DEL ACREDITADO;CURP DEL ACREDITADO PERSONA FISICA;GENERO DEL SOCIO O CLIENTE;IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD;SUCURSAL QUE OPERA EL CREDITO;CLASIFICACION DEL CREDITO POR DESTINO;PRODUCTO DE CREDITO;FECHA DE DISPOSICION DEL CREDITO;FECHA DE VENCIMIENTO DEL CREDITO;MODALIDAD DE PAGO;MONTO ORIGINAL DEL CREDITO;FRECUENCIA DE PAGO DE CAPITAL;FRECUENCIA DE PAGO DE INTERES;TASA DE INTERES ORDINARIA;FECHA DEL ULTIMO PAGO DE CAPITAL;MONTO DEL ULTIMO PAGO DE CAPITAL;FECHA DEL ULTIMO PAGO DE INTERES;MONTO DEL ULTIMO PAGO DE INTERES;FECHA DE LA PRIMERA AMORTIZACION NO CUBIERTA;MONTO DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO;FECHA DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO;DIAS DE MORA (RETRASO);TIPO DE CREDITO;SITUACION CONTABLE DEL CREDITO;CAPITAL;INTERESES ORDINARIOS;INTERESES MORATORIOS;INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE;INTERESES MORATORIOS VENCIDOS FUERA DE BALANCE;INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS;SALDO INSOLUTO DEL CREDITO;TIPO DE ACREDITADO RELACIONADO;TIPO DE CARTERA PARA FINES DE CALIFICACION;CALIFICACION DEL DEUDOR;CALIFICACION PARTE CUBIERTA;CALIFICACION PARTE EXPUESTA;MONTO DE ESTIMACIONES PARTE CUBIERTA;MONTO DE ESTIMACIONES PARTE EXPUESTA;E P A DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA;E P A POR RIESGOS OPERATIVOS (SIC);E P A CNBV;FECHA DE LA CONSULTA SIC;CLAVE DE PREVENCION;GARANTIA LIQUIDA;GARANTIA HIPOTECARIA';

 

 for r_rec in execute consulta loop

 r.clave_subreporte                        :=r_rec."CLAVE DEL SUBREPORTE";
 r.municipio                               :=TRIM(TO_CHAR(r_rec."MUNICIPIO",'09999')); 
 r.estado                                  :=r_rec."ESTADO";
 r.identificador                           :=r_rec."IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD";
 r.personalidad_juridica                   :=r_rec."PERSONALIDAD JURIDICA"; 
 r.nombre                                  :=r_rec."NOMBRE , RAZON O DENOMINACION SOCIAL DEL SOCIO O SOCAP";
 r.apaterno                                :=r_rec."APELLIDO PATERNO DEL SOCIO"; 
 r.amaterno                                :=r_rec."APELLIDO MATERNO DEL SOCIO"; 
 r.rfc                                     :=r_rec."RFC DEL ACREDITADO"; 
 r.curp                                    :=r_rec."CURP DEL ACREDITADO PERSONA FISICA"; 
 r.genero                                  :=r_rec."GENERO DEL SOCIO O CLIENTE"; 
 r.credito                                 :=r_rec."IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD";
 r.sucursal                                :=r_rec."SUCURSAL QUE OPERA EL CREDITO"; 
 r.clasificacion_destino                   :=trim(to_char(r_rec."CLASIFICACION DEL CREDITO POR DESTINO",'0099999999999'));
 r.producto_credito                        :=upper(r_rec."PRODUCTO DE CREDITO"); 
 r.fecha_disposicion                       :=r_rec."FECHA DE DISPOSICION DEL CREDITO"; 
 r.fecha_vencimiento                       :=r_rec."FECHA DE VENCIMIENTO DEL CREDITO"; 
 r.modalidad_pago                          :=r_rec."MODALIDAD DE PAGO"; 
 r.monto_original                          :=trim(to_char(r_rec."MONTO ORIGINAL DEL CREDITO",'099999999999999999.99'));
 r.frecuencia_pago_capital                 :=trim(to_char(r_rec."FRECUENCIA DE PAGO DE CAPITAL",'0999')); 
 r.frecuencia_pago_interes                 :=trim(to_char(r_rec."FRECUENCIA DE PAGO DE INTERES",'0999'));
 r.tasa_io                                 :=trim(to_char(r_rec."TASA DE INTERES ORDINARIA",'09999.9999')); 
 r.fecha_ultimo_pago_capital               :=r_rec."FECHA DEL ULTIMO PAGO DE CAPITAL";
 r.monto_ultimo_pago_capital               :=trim(to_char(r_rec."MONTO DEL ULTIMO PAGO DE CAPITAL",'099999999999999999.99')); 
 r.fecha_ultimo_pago_interes               :=r_rec."FECHA DEL ULTIMO PAGO DE INTERES";
 r.monto_ultimo_pago_interes               :=trim(to_char(r_rec."MONTO DEL ULTIMO PAGO DE INTERES",'099999999999999999.99')); 
 r.fecha_primara_amortizacion_no_cubierta  :=r_rec."FECHA DE LA PRIMERA AMORTIZACION NO CUBIERTA";
 r.monto_condonacion                       :=trim(to_Char(r_rec."MONTO DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO",'099999999999999999.99'));
 r.fecha_condonacion                       :=r_rec."FECHA DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO";
 r.dias_mora                               :=trim(to_char(r_rec."DIAS DE MORA (RETRASO)",'099999')); 
 r.tipo_credito                            :=r_rec."TIPO DE CREDITO"; 
 r.situacion_contable                      :=r_rec."SITUACION CONTABLE DEL CREDITO"; 
 r.capital                                 :=trim(to_char(r_rec."CAPITAL",'099999999999999999.99')); 
 r.io                                      :=trim(to_char(r_rec."INTERESES ORDINARIOS",'099999999999999999.99')); 
 r.im                                      :=trim(to_char(r_rec."INTERESES MORATORIOS",'099999999999999999.99')); 
 r.io_vencido_fuera_valance                :=r_rec."INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE";
 r.im_vencido_fuera_valance                :=r_rec."INTERESES MORATORIOS VENCIDOS FUERA DE BALANCE";
 r.interes_refinanciado                    :=r_rec."INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS";
 r.saldo_insoluto                          :=trim(to_char(r_rec."SALDO INSOLUTO DEL CREDITO",'099999999999999999.99')); 
 r.acreditado_relacionado                  :=trim(to_char(r_rec."TIPO DE ACREDITADO RELACIONADO",'09')); 
 r.cartera_fines_calificacion              :=trim(to_char(r_rec."TIPO DE CARTERA PARA FINES DE CALIFICACION",'09'));
 r.calificacion_deudor                     :=r_rec."CALIFICACION DEL DEUDOR"; 
 r.cal_parte_cubierta                      :=trim(to_char(r_rec."CALIFICACION PARTE CUBIERTA",'0999.99')); 
 r.cal_parte_expuesta                      :=trim(to_char(r_rec."CALIFICACION PARTE EXPUESTA",'0999.99')); 
 r.monto_estimacion_parte_cubierta         :=trim(to_char(r_rec."MONTO DE ESTIMACIONES PARTE CUBIERTA",'099999999999999999.99'));
 r.monto_estimacion_parte_expuesta         :=trim(to_char(r_rec."MONTO DE ESTIMACIONES PARTE EXPUESTA",'099999999999999999.99')); 
 r.e_p_a_interes_devengado_cartera_vencida :=trim(to_char(r_rec."E P A DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA",'099999999999999999.99'));
 r.e_p_a_riesgos_oparativos_SIC            :=r_rec."E P A POR RIESGOS OPERATIVOS (SIC)"; 
 r.e_p_a_cnbv                              :=r_rec."E P A CNBV";
 r.fecha_consulta_sic                      :=r_rec."FECHA DE LA CONSULTA SIC"; 
 r.clave_prevencion                        :=r_rec."CLAVE DE PREVENCION"; 
 r.garantia_liquida                        :=trim(to_char(r_rec."GARANTIA LIQUIDA",'099999999999999999.99'));
 r.garantia_hipotecaria                    :=trim(to_char(r_rec."GARANTIA HIPOTECARIA",'099999999999999999.99'));   

  insert into regulatorio451 values(
  r.clave_subreporte,
  r.municipio::numeric,
  r.estado,
  r.identificador,
  r.personalidad_juridica,
  r.nombre,
  r.apaterno,
  r.amaterno,
  r.rfc,
  r.curp,
  r.genero,
  r.credito,
  r.sucursal,
  r.clasificacion_destino,
  r.producto_credito,
  r.fecha_disposicion,
  r.fecha_vencimiento,
  r.modalidad_pago,
  r.monto_original,
  r.frecuencia_pago_capital,
  r.frecuencia_pago_interes,
  r.tasa_io,  
  r.fecha_ultimo_pago_capital,
  r.monto_ultimo_pago_capital,
  r.fecha_ultimo_pago_interes,
  r.monto_ultimo_pago_interes,  
  r.fecha_primara_amortizacion_no_cubierta,
  r.monto_condonacion,
  r.fecha_condonacion,
  r.dias_mora,
  r.tipo_credito,
  r.situacion_contable,
  r.capital,
  r.io,
  r.im,
  r.io_vencido_fuera_valance,
  r.im_vencido_fuera_valance,
  r.interes_refinanciado,
  r.saldo_insoluto,
  r.acreditado_relacionado,
  r.cartera_fines_calificacion,
  r.calificacion_deudor,
  r.cal_parte_cubierta,
  r.cal_parte_expuesta,
  r.monto_estimacion_parte_cubierta,
  r.monto_estimacion_parte_expuesta,
  r.e_p_a_interes_devengado_cartera_vencida,
  r.e_p_a_riesgos_oparativos_SIC,
  r.e_p_a_cnbv,
  r.fecha_consulta_sic,  
  r.clave_prevencion,
  r.garantia_liquida,
  r.garantia_hipotecaria
  );
   
  RAISE NOTICE '|DATOS_REPORTE_COMPROBACION|%',
  coalesce(r.clave_subreporte::text,'')
  ||';'||coalesce(r.municipio::text,'')
  ||';'||coalesce(r.estado::text,'')
  ||';'||coalesce(r.identificador::text,'')
  ||';'||coalesce(r.personalidad_juridica::text,'')
  ||';'||coalesce(r.nombre::text,'')
  ||';'||coalesce(r.apaterno::text,'')
  ||';'||coalesce(r.amaterno::text,'')
  ||';'||coalesce(r.rfc::text,'')
  ||';'||coalesce(r.curp::text,'')
  ||';'||coalesce(r.genero::text,'')
  ||';'||coalesce(r.credito::text,'')
  ||';'||coalesce(r.sucursal::text,'')
  ||';'||coalesce(r.clasificacion_destino::text,'')
  ||';'||coalesce(r.producto_credito::text,'')
  ||';'||coalesce(r.fecha_disposicion::text,'')
  ||';'||coalesce(r.fecha_vencimiento::text,'')
  ||';'||coalesce(r.modalidad_pago::text,'')
  ||';'||coalesce(r.monto_original::text,'')
  ||';'||coalesce(r.frecuencia_pago_capital::text,'')
  ||';'||coalesce(r.frecuencia_pago_interes::text,'')
  ||';'||coalesce(r.tasa_io::text,'')
  ||';'||coalesce(r.fecha_ultimo_pago_capital::text,'')
  ||';'||coalesce(r.monto_ultimo_pago_capital::text,'')
  ||';'||coalesce(r.fecha_ultimo_pago_interes::text,'')
  ||';'||coalesce(r.monto_ultimo_pago_interes ::text,'')
  ||';'||coalesce(r.fecha_primara_amortizacion_no_cubierta::text,'')
  ||';'||coalesce(r.monto_condonacion::text,'')
  ||';'||coalesce(r.fecha_condonacion::text,'')
  ||';'||coalesce(r.dias_mora::text,'')
  ||';'||coalesce(r.tipo_credito::text,'')
  ||';'||coalesce(r.situacion_contable::text,'')
  ||';'||coalesce(r.capital::text,'')
  ||';'||coalesce(r.io::text,'')
  ||';'||coalesce(r.im::text,'')
  ||';'||coalesce(r.io_vencido_fuera_valance::text,'')
  ||';'||coalesce(r.im_vencido_fuera_valance::text,'')
  ||';'||coalesce(r.interes_refinanciado::text,'')
  ||';'||coalesce(r.saldo_insoluto::text,'')
  ||';'||coalesce(r.acreditado_relacionado::text,'')
  ||';'||coalesce(r.cartera_fines_calificacion::text,'')
  ||';'||coalesce(r.calificacion_deudor::text,'')
  ||';'||coalesce(r.cal_parte_cubierta::text,'')
  ||';'||coalesce(r.cal_parte_expuesta ::text,'')
  ||';'||coalesce(r.monto_estimacion_parte_cubierta::text,'')
  ||';'||coalesce(r.monto_estimacion_parte_expuesta::text,'')
  ||';'||coalesce(r.e_p_a_interes_devengado_cartera_vencida::text,'')
  ||';'||coalesce(r.e_p_a_riesgos_oparativos_SIC::text,'')
  ||';'||coalesce(r.e_p_a_cnbv::text,'')
  ||';'||coalesce(r.fecha_consulta_sic::text,'')
  ||';'||coalesce(r.clave_prevencion::text,'')
  ||';'||coalesce(r.garantia_liquida::text,'')
  ||';'||coalesce(r.garantia_hipotecaria::text,'');


   RAISE NOTICE '|DATOS_REPORTE|%',
  coalesce(r.clave_subreporte::text,'')
  ||';'||coalesce(r.municipio::text,'')
  ||';'||coalesce(r.estado::text,'')
  ||';'||coalesce(r.identificador::text,'')
  ||';'||coalesce(r.personalidad_juridica::text,'')
  ||';'||coalesce(r.nombre::text,'')
  ||';'||coalesce(r.apaterno::text,'')
  ||';'||coalesce(r.amaterno::text,'')
  ||';'||coalesce(r.rfc::text,'')
  ||';'||coalesce(r.curp::text,'')
  ||';'||coalesce(r.genero::text,'')
  ||';'||coalesce(r.credito::text,'')
  ||';'||coalesce(r.sucursal::text,'')
  ||';'||coalesce(r.clasificacion_destino::text,'')
  ||';'||coalesce(r.producto_credito::text,'')
  ||';'||coalesce(r.fecha_disposicion::text,'')
  ||';'||coalesce(r.fecha_vencimiento::text,'')
  ||';'||coalesce(r.modalidad_pago::text,'')
  ||';'||coalesce(r.monto_original::text,'')
  ||';'||coalesce(r.frecuencia_pago_capital::text,'')
  ||';'||coalesce(r.frecuencia_pago_interes::text,'')
  ||';'||coalesce(r.tasa_io::text,'')
  ||';'||coalesce(r.fecha_ultimo_pago_capital::text,'')
  ||';'||coalesce(r.monto_ultimo_pago_capital::text,'')
  ||';'||coalesce(r.fecha_ultimo_pago_interes::text,'')
  ||';'||coalesce(r.monto_ultimo_pago_interes ::text,'')
  ||';'||coalesce(r.fecha_primara_amortizacion_no_cubierta::text,'')
  ||';'||coalesce(r.monto_condonacion::text,'')
  ||';'||coalesce(r.fecha_condonacion::text,'')
  ||';'||coalesce(r.dias_mora::text,'')
  ||';'||coalesce(r.tipo_credito::text,'')
  ||';'||coalesce(r.situacion_contable::text,'')
  ||';'||coalesce(r.capital::text,'')
  ||';'||coalesce(r.io::text,'')
  ||';'||coalesce(r.im::text,'')
  ||';'||coalesce(r.io_vencido_fuera_valance::text,'')
  ||';'||coalesce(r.im_vencido_fuera_valance::text,'')
  ||';'||coalesce(r.interes_refinanciado::text,'')
  ||';'||coalesce(r.saldo_insoluto::text,'')
  ||';'||coalesce(r.acreditado_relacionado::text,'')
  ||';'||coalesce(r.cartera_fines_calificacion::text,'')
  ||';'||coalesce(r.calificacion_deudor::text,'')
  ||';'||coalesce(r.cal_parte_cubierta::text,'')
  ||';'||coalesce(r.cal_parte_expuesta ::text,'')
  ||';'||coalesce(r.monto_estimacion_parte_cubierta::text,'')
  ||';'||coalesce(r.monto_estimacion_parte_expuesta::text,'')
  ||';'||coalesce(r.e_p_a_interes_devengado_cartera_vencida::text,'')
  ||';'||coalesce(r.e_p_a_riesgos_oparativos_SIC::text,'')
  ||';'||coalesce(r.e_p_a_cnbv::text,'')
  ||';'||coalesce(r.fecha_consulta_sic::text,'')
  ||';'||coalesce(r.clave_prevencion::text,'')
  ||';'||coalesce(r.garantia_liquida::text,'')
  ||';'||coalesce(r.garantia_hipotecaria::text,'');
  
  




  insert into copiar values(y,
  coalesce(r.clave_subreporte::text,'')                        ||';'||
  coalesce(r.municipio::text,'')                               ||';'||
  coalesce(r.estado::text,'')                                  ||';'||
  coalesce(r.identificador::text,'')                           ||';'||
  coalesce(r.personalidad_juridica::text,'')                   ||';'||  
  coalesce(r.nombre::text,'')                                  ||';'||
  coalesce(r.apaterno::text,'')                                ||';'||
  coalesce(r.amaterno::text,'')                                ||';'||
  coalesce(r.rfc::text,'')                                     ||';'||
  coalesce(r.curp::text,'')                                    ||';'||
  coalesce(r.genero::text,'')                                  ||';'||   
  coalesce(r.credito::text,'')                                 ||';'||
  coalesce(r.sucursal::text,'')                                ||';'||
  coalesce(r.clasificacion_destino::text,'')                   ||';'||
  coalesce(r.producto_credito::text,'')                        ||';'||
  coalesce(r.fecha_disposicion::text,'')                       ||';'||   
  coalesce(r.fecha_vencimiento::text,'')                       ||';'||
  coalesce(r.modalidad_pago::text,'')                          ||';'||
  coalesce(r.monto_original::text,'')                          ||';'||
  coalesce(r.frecuencia_pago_capital::text,'')                 ||';'||
  coalesce(r.frecuencia_pago_interes::text,'')                 ||';'||
  coalesce(r.tasa_io::text,'')                                 ||';'||   
  coalesce(r.fecha_ultimo_pago_capital::text,'')               ||';'||
  coalesce(r.monto_ultimo_pago_capital::text,'')               ||';'|| 
  coalesce(r.fecha_ultimo_pago_interes::text,'')               ||';'||
  coalesce(r.monto_ultimo_pago_interes::text,'')               ||';'||   
  coalesce(r.fecha_primara_amortizacion_no_cubierta::text,'')  ||';'||
  coalesce(r.monto_condonacion::text,'')                       ||';'||
  coalesce(r.fecha_condonacion::text,'')                       ||';'||
  coalesce(r.dias_mora::text,'')                               ||';'||
  coalesce(r.tipo_credito::text,'')                            ||';'||
  coalesce(r.situacion_contable::text,'')                      ||';'|| 
  coalesce(r.capital::text,'')                                 ||';'||
  coalesce(r.io::text,'')                                      ||';'||
  coalesce(r.im::text,'')                                      ||';'||
  coalesce(r.io_vencido_fuera_valance::text,'')                ||';'||
  coalesce(r.im_vencido_fuera_valance::text,'')                ||';'||
  coalesce(r.interes_refinanciado::text,'')                    ||';'||
  coalesce(r.saldo_insoluto::text,'')                          ||';'||
  coalesce(r.acreditado_relacionado::text,'')                  ||';'||
  coalesce(r.cartera_fines_calificacion::text,'')              ||';'||
  coalesce(r.calificacion_deudor::text,'')                     ||';'||
  coalesce(r.cal_parte_cubierta::text,'')                      ||';'||
  coalesce(r.cal_parte_expuesta::text,'')                      ||';'||
  coalesce(r.monto_estimacion_parte_cubierta::text,'')         ||';'||
  coalesce(r.monto_estimacion_parte_expuesta::text,'')         ||';'|| 
  coalesce(r.e_p_a_interes_devengado_cartera_vencida::text,'') ||';'||
  coalesce(r.e_p_a_riesgos_oparativos_SIC::text,'')            ||';'|| 
  coalesce(r.e_p_a_cnbv::text,'')                              ||';'||
  coalesce(r.fecha_consulta_sic::text,'')                      ||';'||   
  coalesce(r.clave_prevencion::text,'')                        ||';'|| 
  coalesce(r.garantia_liquida::text,'')                        ||';'|| 
  coalesce(r.garantia_hipotecaria::text,'')
  );

  y:=y+1;


 return next r;
 end loop;

select into fecha to_char(CURRENT_DATE,'dd|mm|yyyy');

execute 'copy (select fila from copiar order by id) to ''/tmp/reg_451_con_encabezados_'||fecha||'.csv''  ';
execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/reg_451_sin_encabezados_'||fecha||'.csv''  ';



END;
 
$function$
;
