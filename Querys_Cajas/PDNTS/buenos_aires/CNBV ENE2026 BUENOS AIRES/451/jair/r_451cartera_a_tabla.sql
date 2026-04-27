DROP TABLE IF EXISTS regulatorio_451;

select * into regulatorio_451 from ( --  ESTE RENGLON ES PARA PASAR LOS RESULTADOS A UNA TABLA LLAMADA regulatorio_451
SELECT distinct
     '0451' as "CLAVE DEL SUBREPORTE",--------------------------------------------------------------------------------3
      -------------------------------SECCION II UBICACION DEL CREDITO------------------------------------------------------------
     (select idmunicipio from claves_siti_municipios cvm where cvm.idestado=p.idestado and (select UPPER(reemplaza_letras(mn.nombre)) from municipios mn where mn.idmunicipio=p.idmunicipio) = UPPER(reemplaza_letras(cvm.nombre_municipio)) limit 1)
/*coalesce(p.codigopostal::INTEGER, 0)*/ as "MUNICIPIO",---------------------------------------------------------------------4
     (case when upper(e.nombre) like 'AGUA%' THEN 1	
      when upper(e.nombre) like 'BAJA CALIFORNIA NORTE' OR upper(e.nombre) like 'BAJA CALIFORNIA' THEN '2'	
      when upper(e.nombre) like 'BAJA CALIFORNIA SUR' THEN '3'	
      when upper(e.nombre) like 'CAMP%' THEN '4'	
      when upper(e.nombre) like 'COAH%' THEN '5'	
      when upper(e.nombre) like 'COLI%' THEN '6'	
      when upper(e.nombre) like 'CHIA%' THEN '7'	
      when upper(e.nombre) like 'CHIH%' THEN '8'	
      when upper(e.nombre) like 'DIST%' THEN '9'
	  when upper(e.nombre) like 'CIUD%MEX%' THEN '9'
	  when upper(e.nombre) like 'CD%MEX%' THEN '9'	
      when upper(e.nombre) like 'DURA%' THEN '10'	
      when upper(e.nombre) like 'GUAN%' THEN '11'	
      when upper(e.nombre) like 'GUER%' THEN '12'	
      when upper(e.nombre) like 'HIDA%' THEN '13'	
      when upper(e.nombre) like 'JALI%' THEN '14'	
      when upper(e.nombre) like 'MEXI%' THEN '15'
	  when upper(e.nombre) like 'ESTADO%MEX%' THEN '15'
	  when upper(e.nombre) like 'EDO%MEX%' THEN '15'	
      when upper(e.nombre) like 'MICH%' THEN '16'	
      when upper(e.nombre) like 'MORE%' THEN '17'	
      when upper(e.nombre) like 'NAYA%' THEN '18'	
      when upper(e.nombre) like 'NUEV%' THEN '19'	
      when upper(e.nombre) like 'OAXA%' THEN '20'	
      when upper(e.nombre) like 'PUEB%' THEN '21'	
      when upper(e.nombre) like 'QUER%' THEN '22'	
      when upper(e.nombre) like 'QUIN%' THEN '23'	
      when upper(e.nombre) like 'SAN%' THEN '24'	
      when upper(e.nombre) like 'SINA%' THEN '25'	
      when upper(e.nombre) like 'SONO%' THEN '26'	
      when upper(e.nombre) like 'TABA%' THEN '27'	
      when upper(e.nombre) like 'TAMA%' THEN '28'	
      when upper(e.nombre) like 'TLAX%' THEN '29'	
      when upper(e.nombre) like 'VERA%' THEN '30'	
      when upper(e.nombre) like 'YUCA%' THEN '31'	
      when upper(e.nombre) like 'ZACA%' THEN '32'	 END) as "ESTADO",-----------------------------------------------------------5

       -------------------------------SECCION III IDENTIFICADOR DEL ACREDITADO----------------------------------------------------
     TRIM(TRIM(TO_CHAR(cv.idorigen,'099999')) ||TRIM(TO_CHAR(cv.idgrupo,'09')) 
                || TRIM(TO_CHAR(cv.idsocio,'099999')))
                AS "IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD",-------------------------- ---------------------------6
     (case when p.razon_social is null or p.razon_social='' then 1 else 2 end) 
                AS "PERSONALIDAD JURIDICA",--------------------------------------------------------------------------------------7
     UPPER(p.nombre) AS"NOMBRE , RAZON O DENOMINACION SOCIAL DEL SOCIO O SOCAP",--------------------------------------8
     UPPER(p.appaterno) AS"APELLIDO PATERNO DEL SOCIO",---------------------------------------------------------------9
     UPPER(p.apmaterno) AS"APELLIDO MATERNO DEL SOCIO",--------------------------------------------------------------10
     trim(p.rfc) as "RFC DEL ACREDITADO",----------------------------------------------------------------------------11
     trim(p.curp) as "CURP DEL ACREDITADO PERSONA FISICA",-----------------------------------------------------------12
     (CASE WHEN p.sexo =1 then '2' when p.sexo=2 then '1' else '0' end ) AS "GENERO DEL SOCIO O CLIENTE",------------13
       ---------------------------------SECCION IV IDENTIFICADOR DEL CREDITO------------------------------------------------------
      TRIM(TO_CHAR(cv.idorigenp,'099999'))||TRIM(TO_CHAR(cv.idproducto,'09999'))
                 ||TRIM(TO_CHAR(cv.idauxiliar,'09999999')) 
                 AS "IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD",-------------------------------------------------------14
     (select clave_regularorio from claves_regulatorios_sucursales cvr where cvr.idorigen=a.idorigenp limit 1)  as "SUCURSAL QUE OPERA EL CREDITO",-----------15 ult mod 29/04/2020
     (select a.clave from
(SELECT p.idproducto,
                     CASE 
                     WHEN cuentaaplica LIKE '104010101%'   and cv.cartera !='V' THEN '0130105010000'
                     WHEN cuentaaplica LIKE '104010101%'   and cv.cartera  ='V' THEN '0135105010000'
                     WHEN cuentaaplica LIKE '104010102%'   and cv.cartera !='V' THEN '0130105020000' 
                     WHEN cuentaaplica LIKE '104010102%'   and cv.cartera  ='V' THEN '0135105020000' 
                     WHEN cuentaaplica LIKE '104010103%'   and cv.cartera !='V' THEN '0130105040000'
                     WHEN cuentaaplica LIKE '104010103%'   and cv.cartera  ='V' THEN '0135105040000'  
                     WHEN cuentaaplica LIKE '104010104%'   and cv.cartera !='V' THEN '0130105050000'
                     WHEN cuentaaplica LIKE '104010104%'   and cv.cartera  ='V' THEN '0135105050000'   
                     WHEN cuentaaplica LIKE '104010105%'   and cv.cartera !='V' THEN '0130105070000'
                     WHEN cuentaaplica LIKE '104010105%'   and cv.cartera  ='V' THEN '0135105070000'     
                     WHEN cuentaaplica LIKE '104010106%'   and cv.cartera !='V' THEN '0130105060000'
                     WHEN cuentaaplica LIKE '104010106%'   and cv.cartera  ='V' THEN '0135105060000'  
                     WHEN cuentaaplica LIKE '104020101%'   and cv.cartera !='V' THEN '0131101000000'
                     WHEN cuentaaplica LIKE '104020101%'   and cv.cartera  ='V' THEN '0136101000000'  
                     WHEN cuentaaplica LIKE '104020201%'   and cv.cartera !='V' THEN '0131103000000'
                     WHEN cuentaaplica LIKE '104020201%'   and cv.cartera  ='V' THEN '0136103000000'  
                     WHEN cuentaaplica LIKE '104020301%'   and cv.cartera !='V' THEN '0131113000000'
                     WHEN cuentaaplica LIKE '104020301%'   and cv.cartera  ='V' THEN '0136113000000'    
                     WHEN cuentaaplica LIKE '104020401%'   and cv.cartera !='V' THEN '0131105000000'
                     WHEN cuentaaplica LIKE '104020401%'   and cv.cartera  ='V' THEN '0136105000000'    
                     WHEN cuentaaplica LIKE '104020501%'   and cv.cartera !='V' THEN '0131106000000'
                     WHEN cuentaaplica LIKE '104020501%'   and cv.cartera  ='V' THEN '0136106000000'  
                     WHEN cuentaaplica LIKE '104020601%'   and cv.cartera !='V' THEN '0131104000000'
                     WHEN cuentaaplica LIKE '104020601%'   and cv.cartera  ='V' THEN '0136104000000'  
                     WHEN cuentaaplica LIKE '10402070%'    and cv.cartera !='V' THEN '0131190000000'
                     WHEN cuentaaplica LIKE '10402070%'    and cv.cartera  ='V' THEN '0136190000000' 
                     WHEN cuentaaplica LIKE '104030101%'   and cv.cartera !='V' THEN '131601000000'
                     WHEN cuentaaplica LIKE '104030101%'   and cv.cartera  ='V' THEN '136601000000'  
                     WHEN cuentaaplica LIKE '104030201%'   and cv.cartera !='V' THEN '0131602000000'
                     WHEN cuentaaplica LIKE '104030201%'   and cv.cartera  ='V' THEN '0136602000000'
                    else '0000000000000' END AS clave

FROM productos AS p 
WHERE tipoproducto=2 
ORDER BY p.cuentaaplica) as a
where a.idproducto=cv.idproducto limit 1)::numeric
as "CLASIFICACION DEL CREDITO POR DESTINO",-------------------------------------------------------------------16  ult mod 29/04/2020

(select clave_regularorio from claves_regulatorios_productos cvr where cvr.idproducto=a.idproducto limit 1) as "PRODUCTO DE CREDITO",-------------------17  ult mod 29/04/2020
       TO_CHAR(cv.fechaprestamo,'YYYY-MM-DD') as "FECHA DE DISPOSICION DEL CREDITO",--------------------------18   ult mod 29/04/2020

to_char((SELECT max(am.vence) from amortizaciones am where (am.idorigenp,am.idproducto,
am.idauxiliar)=(cv.idorigenp,cv.idproducto,
cv.idauxiliar)),'yyyy-mm-dd') as "FECHA DE VENCIMIENTO DEL CREDITO",-----------------------------------19  ult mod 29/04/2020
	      
(case 
            when a.plazo=1 then 1
else 3 end)
as "MODALIDAD DE PAGO",---------------------------------------------------------------------------------------20   ult mod 29/04/2020
       cv.montoprestado AS "MONTO ORIGINAL DEL CREDITO",------------------------------------------------------21
	   
	   (CASE WHEN a.pagodiafijo = 1 THEN '30' ELSE (CASE WHEN a.periodoabonos <= 0 THEN '30' ELSE a.periodoabonos END) END) "FRECUENCIA DE PAGO DE CAPITAL",---------------------22
  
	   (CASE WHEN a.pagodiafijo = 1 THEN '30' ELSE (CASE WHEN a.periodoabonos <= 0 THEN '30' ELSE a.periodoabonos END) END)"FRECUENCIA DE PAGO DE INTERES",------------------23
     
       round(a.tasaio * 12::numeric,4) as "TASA DE INTERES ORDINARIA",-----------------------------------------------24
            
			coalesce(to_char((select max(date(ad.fecha)) from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3)  and 
ad.monto>0 and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1)
,'yyyy-mm-dd'),'9999-12-31') as "FECHA DEL ULTIMO PAGO DE CAPITAL",---------------------------------------------------------------25
       coalesce((select monto from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3) and ad.monto>0 and
                  (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar)order by fecha
                  desc limit 1)::NUMERIC,0) as "MONTO DEL ULTIMO PAGO DE CAPITAL",----------------------------------------------26
				  
				   coalesce(to_char((select date(ad.fecha) from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3)  and 
ad.montoio>0 and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) order by ad.fecha desc 
limit 1),'yyyy-mm-dd'),'9999-12-31') as "FECHA DEL ULTIMO PAGO DE INTERES",-------------------------------------------------------27   mod 28/05/2020   se quito max porque salen ceros en algunas fechas validas

       coalesce((select montoio from v_auxiliares_d ad where ad.cargoabono=1 and ad.tipomov not in(3) and ad.montoio>0 and
                  (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar)order by fecha 
                  desc limit 1)::NUMERIC,0) as "MONTO DEL ULTIMO PAGO DE INTERES",----------------------------------------------28   mod 28/05/2020 se cambio ad.idtipo por ad.tipomov

(case when cv.diasvencidos = 0 then '9999-12-31' 
      else trim(to_char(((select distinct date(fechatrabajo) from origenes limit 1)-cv.diasvencidos), 'yyyy-mm-dd'))
 end) AS "FECHA DE LA PRIMERA AMORTIZACION NO CUBIERTA",------------------------------------------------------------------------------29
 
       coalesce((select  sum(c.montoio+c.montoim) from(select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,
                  ad.idproducto,ad.idauxiliar,ad.fecha::date,ad. monto,ad.montoio,ad. montoim,ad. montoiva from v_auxiliares_d 
                  ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar) where ad.tipomov=3 AND a.estatus=2 and 
                  ad.idproducto between 30000 and 39999 order by fecha) as c where
                  (c.idorigen,c.idgrupo,c.idsocio,c.idorigenp,c.idproducto,c.idauxiliar)=(cv.idorigen,cv.idgrupo,cv.idsocio,
                  cv.idorigenp,cv.idproducto,cv.idauxiliar)),0)as "MONTO DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO",---30
				  
    coalesce(to_char((select  max(fecha) from(select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar,
                  ad.fecha::date,ad. monto,ad.montoio,ad. montoim,ad. montoiva from v_auxiliares_d ad inner join v_auxiliares a 
                  using(idorigenp,idproducto,idauxiliar) where ad.tipomov=3 AND a.estatus=2 and ad.idproducto
                  between 30000 and 39999 order by fecha) as c where (c.idorigen,c.idgrupo,c.idsocio,c.idorigenp,c.idproducto,
                  c.idauxiliar)=(cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) limit 1 )
                  ,'yyyy-mm-dd'),'9999-12-31') as "FECHA DE LA CONDONACION, QUITA, BONIFICACION O DESCUENTO",-----------------------31   mod 29-05-2020  se agrego al final    ,'9999-12-31'
     
       cv.diasvencidos as "DIAS DE MORA (RETRASO)",------------------------------------------------------------------32
	   
		    (case  when cv.idproducto in (30132,30232,30332,30432,30832,31432,31732,31932,32032,33332,34032,34132,34232,35332,
35432,35532,35632,35732,35832,35932,36032,36132,39032) then '04' when a.tipoprestamo=0 then '01' when a.tipoprestamo in(1,3) then '02' when a.tipoprestamo in(2,4) 
then '03' else '02'end)::text as "TIPO DE CREDITO",--------------------------------------------------------------------------------------33 mod 11/12/2020
	
(case when cv.diasvencidos>=0 and  cv.cartera = 'C' then '01' 
      when cv.diasvencidos>=0 and  cv.cartera = 'M' THEN '02' 
      when cv.cartera = 'V' and
           (a.idorigenp,a.idproducto,a.idauxiliar) in
           (select TO_NUMBER(TRIM(SAI_TOKEN(1, titulo, '|'))::TEXT, '999999') AS idorigenp, 
                   TO_NUMBER(TRIM(SAI_TOKEN(2, titulo, '|'))::TEXT, '999999') AS idproducto,
                   TO_NUMBER(TRIM(SAI_TOKEN(3, titulo, '|'))::TEXT, '99999999') AS idauxiliar
                   from historial where tipomensaje=7) THEN '04'
      when cv.cartera='V' and (select tiporeferencia from referenciasp rp where rp.tiporeferencia=3 and rp.idorigenp=cv.idorigenp and rp.idproducto=cv.idproducto and rp.idauxiliar=cv.idauxiliar)is not null then '05' 
      when cv.cartera='V' and (select tiporeferencia from referenciasp rp where rp.tiporeferencia=2 and rp.idorigenp=cv.idorigenp and rp.idproducto=cv.idproducto and rp.idauxiliar=cv.idauxiliar)is not null then '06'
      else '03' END)"SITUACION CONTABLE DEL CREDITO",-------------------------------------------------------------------------34	
	         
       a.saldo as "CAPITAL",-----------------------------------------------------------------------------------------35
       a.idnc as "INTERESES ORDINARIOS",-----------------------------------------------------------------------------36
       a.idncm as "INTERESES MORATORIOS",----------------------------------------------------------------------------37
       a.ieco as "INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE",---------------------------------------------------38
       (a.iecom + a.im)as "INTERESES MORATORIOS VENCIDOS FUERA DE BALANCE",--------------------------------------------------39
       0 "INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS",------------------------------------------------------40
       a.saldo+a.idnc+a.idncm AS "SALDO INSOLUTO DEL CREDITO",-------------------------------------------------------41
       coalesce((case  
             when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias r
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8 and puesto='2')  then 9
          when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias r
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8 and puesto='3')  then 10
           when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias r
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8 and puesto='4')  then 11
           when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias r
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8 and puesto='5') then 12
             when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                    FROM referencias r
              inner join (SELECT  r.idorigen,r.idgrupo,r.idsocio
              FROM sopar s inner join  referencias r 
             USING (idorigen, idgrupo, idsocio)  
             where tipo = 'personas_relacionadas' and r.tiporeferencia in(0, 1, 7, 14, 15,24,25)) s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and seis.refe::numeric =6 then 13
            when (cv.idorigen,cv.idgrupo,cv.idsocio) in
            (select  distinct r.idorigen,r.idgrupo,r.idsocio from(
             SELECT  r.idorigen,r.idgrupo,r.idsocio,r.idorigenr ,r.idgrupor ,r.idsocior ,
                   (CASE WHEN r.tiporeferencia in (0, 1, 7, 14, 15,24,25) then 6 END) as refe
             FROM sopar s inner join  referencias r 
            on(r.idorigenr,r.idgrupor,r.idsocior)=(s.idorigen,s.idgrupo,s.idsocio ) 
            where tipo = 'personas_relacionadas' and r.tiporeferencia in(0, 1, 7, 14, 15,24,25))as r)
             then 6
         when (cv.idorigen,cv.idgrupo,cv.idsocio,cv.idorigenp,cv.idproducto,cv.idauxiliar) 
               in (SELECT r.idorigen,r.idgrupo,r.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias r
               inner join (select * from sopar where tipo like 'personas_relacionadas2') s 
               on(r.idorigenr,r.idgrupor,r.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8  and puesto='7')  then 14
       else s.puesto end ),1)       
                   AS "TIPO DE ACREDITADO RELACIONADO",-------------------------------------------------------------------------42
       (case when pr.tipofinalidad =1 then 1 
                   when pr.tipofinalidad =1 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,idproducto,
                   idauxiliar  from folios_particulares where lista like 'folios_emproblemados') then 2
                   when pr.tipofinalidad =2 then 3 
                   when pr.tipofinalidad =2 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,
                   idproducto,idauxiliar
                   from folios_particulares where lista like 'folios_emproblemados') then 4
                   WHEN pr.tipofinalidad =3 then 8 
                   when pr.tipofinalidad =3 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in 
                  (select idorigenp,idproducto,idauxiliar
                   from folios_particulares where lista like 'folios_emproblemados') then 9 
                   -----
       when (cv.idorigenp,cv.idproducto,cv.idauxiliar) in(SELECT SAI_TOKEN(2,idnota,'|')::integer AS idorigenp,
       SAI_TOKEN(3,idnota,'|')::integer AS idproducto,
       SAI_TOKEN(4,idnota,'|')::integer AS idauxiliar
       FROM notas
       WHERE UPPER(idnota) LIKE 'GAR%' AND SAI_FINDSTR(nota,'|') > 1 AND
       SAI_FINDSTR(nota,'|') < 7 AND TRIM(SAI_TOKEN(4,nota,'|'))<>'' AND
       descripcion IS NOT NULL AND LENGTH(descripcion) > 0
       and TO_NUMBER(REPLACE(descripcion,',','')::TEXT,'999999999999.99')>0) then 8
       when (cv.idorigenp,cv.idproducto,cv.idauxiliar) not in(SELECT SAI_TOKEN(2,idnota,'|')::integer AS idorigenp,
       SAI_TOKEN(3,idnota,'|')::integer AS idproducto,
       SAI_TOKEN(4,idnota,'|')::integer AS idauxiliar
       FROM notas
       WHERE UPPER(idnota) LIKE 'GAR%' AND SAI_FINDSTR(nota,'|') > 1 AND
       SAI_FINDSTR(nota,'|') < 7 AND TRIM(SAI_TOKEN(4,nota,'|'))<>'' AND
       descripcion IS NOT NULL AND LENGTH(descripcion) > 0
       and TO_NUMBER(REPLACE(descripcion,',','')::TEXT,'999999999999.99')>0) and (cv.idorigenp,cv.idproducto,cv.idauxiliar) in (select idorigenp,idproducto,
       idauxiliar  from folios_particulares where lista like 'folios_emproblemados') then 9
       when pr.tipofinalidad =3 and (cv.idorigenp,cv.idproducto,cv.idauxiliar) not in(SELECT SAI_TOKEN(2,idnota,'|')::integer AS idorigenp,
       SAI_TOKEN(3,idnota,'|')::integer AS idproducto,
       SAI_TOKEN(4,idnota,'|')::integer AS idauxiliar
       FROM notas
       WHERE UPPER(idnota) LIKE 'GAR%' AND SAI_FINDSTR(nota,'|') > 1 AND
       SAI_FINDSTR(nota,'|') < 7 AND TRIM(SAI_TOKEN(4,nota,'|'))<>'' AND
       descripcion IS NOT NULL AND LENGTH(descripcion) > 0
       and TO_NUMBER(REPLACE(descripcion,',','')::TEXT,'999999999999.99')>0) then 1 end ) 
                   as "TIPO DE CARTERA PARA FINES DE CALIFICACION",-------------------------------------------------------------43
       0 AS "CALIFICACION DEL DEUDOR",-------------------------------------------------------------------------------44
       0 AS "CALIFICACION PARTE CUBIERTA",---------------------------------------------------------------------------45
	   
	 (case when (cv.diasvencidos = 0)then 1
      when (cv.diasvencidos between 1 and 7)then 4
      when (cv.diasvencidos between 8 and 30) then 15
      when (cv.diasvencidos between 31 and 60)then 30
      when (cv.diasvencidos between 61 and 90)then 50
      when (cv.diasvencidos between 91 and 120)then 75 
      when (cv.diasvencidos between 121 and 180)then 90
      when (cv.diasvencidos > 180) then 100 end)
 AS "CALIFICACION PARTE EXPUESTA",--------------------------------------------------------------------------------------------46
	   
	   round((et.e_parte_cub + et.e_parte_cub_i),2) AS "MONTO DE ESTIMACIONES PARTE CUBIERTA",-----------------------47
       round((et.e_parte_exp + et.e_parte_exp_i),2) AS "MONTO DE ESTIMACIONES PARTE EXPUESTA",-----------------------48
       coalesce((CASE WHEN cv.cartera = 'V' THEN a.idnc+a.idncm END),0)
                   AS "E P A DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA",----------------------------------------------------49
       0 AS "E P A POR RIESGOS OPERATIVOS (SIC)",--------------------------------------------------------------------50       
       0 AS "E P A CNBV",--------------------------------------------------------------------------------------------51  


(case 
when (select br.fecha from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST('90 day' AS INTERVAL)))) and cv.fechaprestamo
and br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio and br.idorigenp=cv.idorigenp and br.idproducto=cv.idproducto and br.idauxiliar=cv.idauxiliar 
ORDER BY br.fecha desc limit 1 ) is not null
then 
(select to_char(br.fecha,'YYYY-MM-DD') from revision_buro br where  br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST('90 day' AS INTERVAL)))) and cv.fechaprestamo and 
br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio and br.idorigenp=cv.idorigenp and br.idproducto=cv.idproducto and br.idauxiliar=cv.idauxiliar 
ORDER BY br.fecha desc limit 1)

when (select br.fecha from revision_buro br where (br.idorigenp,br.idproducto,br.idauxiliar)=(cv.idorigenp,cv.idproducto,cv.idauxiliar) ORDER BY br.fecha desc limit 1) is null
and 
(select br.fecha from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST('90 day' AS INTERVAL)))) and cv.fechaprestamo
and (br.idorigen,br.idgrupo,br.idsocio)=(cv.idorigen,cv.idgrupo,cv.idsocio) ORDER BY br.fecha desc limit 1 ) is not null
then
(select to_char(br.fecha,'YYYY-MM-DD') from revision_buro br where br.fecha between (select date((CAST((cv.fechaprestamo) AS DATE) - CAST('90 day' AS INTERVAL)))) and cv.fechaprestamo and
br.idorigen=cv.idorigen and br.idgrupo=cv.idgrupo and br.idsocio=cv.idsocio ORDER BY br.fecha desc limit 1 )

else '9999-12-31' end) as "FECHA DE LA CONSULTA SIC",---------------------------------------------------------------------------------------------------52 
	   
	 
       (case when a.cartera='C' and to_char(a.fechaactivacion,'yyyymm') in(select distinct to_char(fechatrabajo,'yyyymm') 
                   from origenes) then '10000'
                 when et.diasvencidos=0 then '10001'
                 when et.diasvencidos between 1 and 29 then '10002'
                 when et.diasvencidos between 30 and 59 then '10003'
                 when et.diasvencidos between 60 and 89 then '10004'
                 when et.diasvencidos between 90 and 119 then '10005'
                 when et.diasvencidos between 120 and 149 then '10006'
                 when et.diasvencidos between 150 and 365 then '10007'
                 when et.diasvencidos > 365 then '10008'
                 when et.diasvencidos > 365 and a.saldo=a.montoprestado then '10009'
 end)  AS "CLAVE DE PREVENCION",------------------------------------------------------------------------------------------------53   
       coalesce(et.garantia,0) AS "GARANTIA LIQUIDA",----------------------------------------------------------------54  
       coalesce(hip.garantia,0) AS "GARANTIA HIPOTECARIA",------------------------------------------------------------55 




---------------------------COLUMNAS EXTRAS PARA LA CNBV ---------------------------------
a.idorigen,a.idgrupo,a.idsocio,a.idorigenp,a.idproducto,a.idauxiliar,

--nombre_x(p.appaterno,p.apmaterno,p.nombre) as nombre,

0 as institucion_tercero,     -------------------A) NOMBRE COMPLETO de la empresa 
0 as act_eco_tercero,         -------------------B) ACTIVIDAD ECONOMICA de la empresa 
(CASE 
      WHEN acte.idrecursivo BETWEEN 1     AND 67      THEN 'Agricola'
      WHEN acte.idrecursivo BETWEEN 68    AND 134     THEN 'Explotacion,Energia y Construccion'
      WHEN acte.idrecursivo BETWEEN 135   AND 260     THEN 'Comercio'
      WHEN acte.idrecursivo BETWEEN 261   AND 662     THEN 'Servicios'
      ELSE 'sin clasificacion' 
END  ) as "act_eco_socio",    -------------------C) ACT ECO DEL ACREDITADO
coalesce(grc2.idorigen||'-'||grc2.idgrupo||'-'||grc2.idsocio,'Sin OGS') as ogs_riesgo_comun,     -------------------D) OGS QUE CONFORMA EL RIESGO COMUN (PNDT VALIDAR)
coalesce(grc2.nombre_grupo,'Sin Grupo') as grupo_rc,

tr.ing_mensual_bruto as ing_declarados, ---------E) INGRESOS DECLARADOS POR EL SOCIO
tr.ing_mensual_neto as ing_comprobados, ---------F) INGRESOS COMPROBADOS POR EL SOCIO 

(select descripcion from catalogo_menus as cm2 where cm2.menu = 'frecuencia_ingresos' and tr.frecuencia_ingresos = cm2.opcion
limit 1)  as frec_ing,                  ---------G) PERIODICIDAD DE LOS INGRESOS DEL SOCIO 

(select descripcion from catalogo_menus as cm1 where cm1.menu = 'forma_comprobar_ing' and tr.forma_comprobar_ing = cm1.opcion
limit 1) as forma_comprobar,             ---------H) DOCUMENTO PARA ACREDITAR INGRESOS

(select nombre_x(nombre,appaterno,apmaterno) from personas 
where idorigen = r1.idorigenr and idgrupo = r1.idgrupor and idsocio = r1.idsocior) 
as nombre_aval_codeudor,                   -------I) NOMBRE DEL AVAL U OBLIGADO SOLIDARIO

r1.idorigenr||'-'||r1.idgrupor||'-'||r1.idsocior 
as ogs_aval_codeudor                    --------J) OGS AVAL U OBLIGADO SOLIDARIO 
















FROM carteravencida cv 
INNER JOIN vpersonas p ON cv.idorigen = p.idorigen and  cv.idgrupo = p.idgrupo and cv.idsocio = p.idsocio
inner join estados e using(idestado)
INNER JOIN municipios m using(idmunicipio)
LEFT JOIN trabajo tr ON tr.idorigen = p.idorigen and tr.idgrupo = p.idgrupo and tr.idsocio = p.idsocio AND tr.consecutivo = 1
LEFT JOIN actividades_economicas acte on tr.actividad_economica =  acte.id_actividad
LEFT JOIN grupos_riesgo_comun grc2 
ON grc2.nombre_grupo = ( 'GRC'||TRIM(TO_CHAR(cv.idorigen,'099999'))||TRIM(TO_CHAR(cv.idgrupo,'09'))||TRIM(TO_CHAR(cv.idsocio,'09999999')) ) 
AND grc2.idsocio <> cv.idsocio
LEFT JOIN 
(select r1.idorigen,r1.idgrupo,r1.idsocio,r1.idorigenr,r1.idgrupor,r1.idsocior from referencias as r1 where r1.tiporeferencia in (8,35)) r1 
            on cv.idorigen = r1.idorigen and cv.idgrupo = r1.idgrupo and cv.idsocio = r1.idsocio


---------------------------------------------------PERSONAS RELACIONADAS---------------------------------------------------------
LEFT JOIN (select idorigen,idgrupo,idsocio,puesto::numeric from sopar where tipo like 'personas_relacionadas%') s 
           ON cv.idorigen = s.idorigen and cv.idgrupo = s.idgrupo and cv.idsocio = s.idsocio
LEFT JOIN (SELECT  r.idorigen,r.idgrupo,r.idsocio,r.idorigenr ,r.idgrupor ,r.idsocior ,
                   (CASE WHEN r.tiporeferencia in (0, 1, 7, 14, 15,24,25) then 6 END) as refe
             FROM sopar s inner join  referencias r 
            on(r.idorigen,r.idgrupo,r.idsocio )=(s.idorigen,s.idgrupo,s.idsocio ) 
            where tipo like 'personas_relacionadas%' and r.tiporeferencia in(0, 1, 7, 14, 15,24,25)) seis 
           ON (seis.idorigenr,seis.idgrupor,seis.idsocior)=(cv.idorigen,cv.idgrupo,cv.idsocio)
------------------------------------------------------AUXILIARES------------------------------------------------------------------
INNER JOIN (select * from auxiliares ) a ON  cv.idorigenp = a.idorigenp AND cv.idproducto = a.idproducto AND cv.idauxiliar = a.idauxiliar
----------------------------------------------------------EPRC--------------------------------------------------------------------
LEFT JOIN eprc_tmp2 et on a.idorigenp = et.idorigenp and a.idproducto = et.idproducto and a.idauxiliar = et.idauxiliar
-------------------------------------------------------PRODUCTOS------------------------------------------------------------------
INNER JOIN productos pr on a.idproducto = pr.idproducto
--------------------------------------------------GARAMTIAS HIPOTECARIAS----------------------------------------------------------
LEFT JOIN (SELECT TO_NUMBER(TRIM(SAI_TOKEN(2, idnota, '|'))::TEXT, '999999') AS idorigenp, 
                  TO_NUMBER(TRIM(SAI_TOKEN(3, idnota, '|'))::TEXT, '999999') AS idproducto,
                  TO_NUMBER(TRIM(SAI_TOKEN(4, idnota, '|'))::TEXT, '99999999') AS idauxiliar,
                  SUM(TO_NUMBER((CASE WHEN (REPLACE(descripcion,',','') > '0') THEN (REPLACE(descripcion,',','')) ELSE '0' END),'999999999999.99')) AS garantia
           FROM notas 
           WHERE UPPER(idnota) LIKE 'GAR%%' 
             AND SAI_FINDSTR(nota, '|') > 1
             AND SAI_FINDSTR(nota, '|') <= 7   --AND SAI_FINDSTR(nota, '|') < 7
            -- AND TRIM(SAI_TOKEN(4, nota, '|')) <> ''
        GROUP BY idorigenp, idproducto, idauxiliar
         UNION
         SELECT idorigenp, idproducto, idauxiliar, SUM(monto) AS garantia
         FROM garantias_hipotecarias
         --WHERE es_prendaria = false
         GROUP BY idorigenp, idproducto, idauxiliar) AS hip 
	ON (hip.idorigenp = cv.idorigenp
	AND hip.idproducto = cv.idproducto
	AND hip.idauxiliar = cv.idauxiliar)
	where cv.saldo>0
)
as x;
