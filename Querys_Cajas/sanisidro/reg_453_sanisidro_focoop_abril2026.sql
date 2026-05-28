/*

RETORNO:

        reg_453_con_encabezados_fecha_hoy.csv
        reg_453_sin_encabezados_fecha_hoy.csv

*/

DROP TYPE IF EXISTS tipo_reg_453 CASCADE;
CREATE TYPE tipo_reg_453 AS (
clave_subreporte         text,
 numerosocio                            text                  , 
 per_jur                                numeric               , 
 nombre                                 text                  , 
 appaterno                              text                  , 
 apmaterno                              text                  , 
 rfc                                    text                  , 
 curp                                   character varying(18) , 
 genero                                 numeric               , 
 numerocredito                          text                  , 
 sucursal                               integer, 
 clasificacioncredito                   numeric(12,0)         , 
 productocredito                        text                  , 
 fechaotorgamiento                      numeric               , 
 fecha_vencimiento                      numeric               , 
 modalidad_pago                         numeric               , 
 montooriginal                          numeric(16,2)         , 
 fecha_ultimo_pago_capital              numeric(8,0)          , 
 monto_ultimo_pago_capital              numeric(16,2)         , 
 fecha_de_ultimo_pago_interes           numeric(8,0)          , 
 monto_ultimo_pago_interes              numeric(16,2)         , 
 fecha_ultima_amortizacion_no_cubierta  numeric(8)         , 
 diasmora                               numeric(6,0)          , 
 tipocredito                            character varying(2)  , 
 saldoinsolutocapital                   numeric(16,2)         , 
 interesesvencidos                      numeric(16,2)         , 
 montoim                                numeric(16,2)         , 
 interesesrefinanciados                 numeric(16,2)         , 
 monto_castigo                          numeric(16,2)         , 
 montocondonacion                       numeric(16,2)         , 
 montobonificacion                      numeric(16,2)         , 
 fechacastigo                           numeric(8,0)          , 
 personarelacionada                     numeric               , 
 montodeestimacionespreventivas         numeric(16,2)         , 
 claveprevencion                        integer                  , 
 fecha_sic                              text  ,                 
tipocobranza                           numeric(2), 
 montodegarantialiquida                 numeric(16,2),
 montodegarantiahipotecaria             numeric(16,2)

);

CREATE OR REPLACE FUNCTION reg_453()
RETURNS setof tipo_reg_453 AS $$

DECLARE

fecha_inicial  date;
fecha_Final    date;
r    tipo_reg_453%rowtype;

r_castigos           record;
r_condonaciones      record;
r_ogs_opa            record;
r_entregar           record;
r_final              record;
registros            record;
fechaita                varchar;
y                    integer;

BEGIN

select into fecha_final,fecha_inicial fecha,(01||to_char(fecha,'/mm/yyyy'))::date from(select distinct date(fechatrabajo) as fecha from origenes) as x;




/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::CREACION DE TABLA TEMPORAL CASTIGOS :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

drop table if exists castigos;
create  temp table castigos(
 fecha         date,                  
 idorigen      integer ,              
 idgrupo       integer,              
 idsocio       integer ,              
 idorigenp     integer ,              
 idproducto    integer ,              
 idauxiliar    integer ,              
 idorigenc     integer ,              
 periodo       varchar , 
 idtipo        numeric ,         
 idpoliza      integer ,              
 monto         numeric ,        
 montoio       numeric ,        
 montoiva      numeric ,        
 montoim       numeric ,        
 montoivaim    numeric ,        
 saldoec       numeric ,        
 diasvencidos  integer  ,             
 montovencido  numeric );    

CREATE INDEX cast_ogs  ON castigos (idorigen,idgrupo,idsocio);
CREATE INDEX cast_opa  ON castigos  (idorigenp,idproducto,idauxiliar); 

for r_castigos in

  SELECT date(ad.fecha) fecha, 
           a.idorigen, a.idgrupo, a.idsocio,
           ad.idorigenp, ad.idproducto, ad.idauxiliar, 
           ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, 
           ad.monto, ad.montoio, ad.montoiva, ad.montoim, ad.montoivaim,
           ad.saldoec, ad.diasvencidos, ad.montovencido
      FROM auxiliares_d AS ad 
INNER JOIN auxiliares a USING (idorigenp, idproducto, idauxiliar)
     WHERE (ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza) in( select ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
                                                                    from auxiliares_d ad 
                                                                   where idproducto=60001   
                                                                     and fecha::date between fecha_inicial  and fecha_Final  
                                                                     and cargoabono=0)

union
    SELECT date(ad.fecha) fecha, 
           a.idorigen, a.idgrupo, a.idsocio,
           ad.idorigenp, ad.idproducto, ad.idauxiliar, 
           ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, 
           ad.monto, ad.montoio, ad.montoiva, ad.montoim, ad.montoivaim,
           ad.saldoec, ad.diasvencidos, ad.montovencido
      FROM auxiliares_d_h AS ad 
INNER JOIN auxiliares_h a USING (idorigenp, idproducto, idauxiliar)
      WHERE (ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza) in ( select ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
                                                                      from auxiliares_d ad 
                                                                     where idproducto=60001  
                                                                       and fecha::date between fecha_inicial  and fecha_Final
                                                                       and cargoabono=0)
  

loop
                           

insert into castigos values
( r_castigos.fecha ,               
 r_castigos.idorigen,            
 r_castigos.idgrupo,        
 r_castigos.idsocio ,            
 r_castigos.idorigenp,     
 r_castigos.idproducto ,           
 r_castigos.idauxiliar,              
 r_castigos.idorigenc ,       
 r_castigos.periodo, 
 r_castigos.idtipo,
 r_castigos.idpoliza ,       
 r_castigos.monto ,     
 r_castigos.montoio  ,    
 r_castigos.montoiva ,   
 r_castigos.montoim ,
 r_castigos.montoivaim ,    
 r_castigos.saldoec ,   
 r_castigos.diasvencidos ,       
 r_castigos.montovencido  );

end loop;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::   FIN   DE TABLA TEMPORAL CASTIGOS  :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::CREACION DE TABLA TEMPORAL PRESTAMOS_CONDONACIONES :::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


drop table if exists prestamos_condonaciones;
create temp table prestamos_condonaciones(

 idorigen      integer,               
 idgrupo       integer,               
 idsocio       integer,               
 idorigenp     integer,               
 idproducto    integer,              
 idauxiliar    integer,               
 fecha         date,                  
 cargoabono    numeric(1,0),          
 monto         numeric(12,2),         
 montoio       numeric(12,2),         
 montoim       numeric(12,2),         
 montoiva      numeric(12,2),         
 idorigenc     integer,               
 periodo       character varying(6),  
 idtipo        numeric(1,0),          
 idpoliza      integer,               
 tipomov       numeric(1,0),          
 saldoec       numeric(12,2),         
 transaccion   integer ,              
 montoivaim    numeric(12,2),         
 efectivo      numeric(12,2),         
 diasvencidos  integer ,              
 montovencido  numeric(12,2),         
 ticket        integer,               
 montoidnc     numeric(12,2),         
 montoieco     numeric(12,2), 
 montoidncm     numeric(12,2) 
);     
CREATE INDEX cond_ogs  ON castigos (idorigen,idgrupo,idsocio);
CREATE INDEX cond_opa  ON castigos  (idorigenp,idproducto,idauxiliar);


for r_condonaciones in
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad. idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad. monto,
              ad.montoio,ad. montoim,ad. montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad. idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm
        from  auxiliares_d ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
       where ad.tipomov=3  and ad.fecha::date between fecha_inicial  and fecha_Final
         and ad.idproducto between 30000 and 39999 
union
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad. idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad. monto,
              ad.montoio,ad. montoim,ad. montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad. idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm
        from  auxiliares_d_h ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
       where ad.tipomov=3  and ad.fecha::date between fecha_inicial  and fecha_Final
         and ad.idproducto between 30000 and 39999 



loop

insert into prestamos_condonaciones values
 (r_condonaciones.idorigen ,               
  r_condonaciones.idgrupo ,               
  r_condonaciones.idsocio ,               
  r_condonaciones.idorigenp,               
  r_condonaciones.idproducto ,              
  r_condonaciones.idauxiliar,               
  r_condonaciones.fecha ,                  
  r_condonaciones.cargoabono,          
  r_condonaciones.monto ,         
  r_condonaciones.montoio ,         
  r_condonaciones.montoim ,         
  r_condonaciones.montoiva ,         
  r_condonaciones.idorigenc ,               
  r_condonaciones.periodo ,  
  r_condonaciones.idtipo ,          
  r_condonaciones.idpoliza ,               
  r_condonaciones.tipomov,          
  r_condonaciones.saldoec  ,         
  r_condonaciones.transaccion  ,              
  r_condonaciones.montoivaim ,         
  r_condonaciones.efectivo ,         
  r_condonaciones.diasvencidos  ,              
  r_condonaciones.montovencido,         
  r_condonaciones.ticket ,               
  r_condonaciones.montoidnc ,         
  r_condonaciones.montoieco ,
r_condonaciones.montoidncm );  

end loop;

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::: FIN DE TABLA TEMPORAL PRESTAMOS_CONDONACIONES ::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::CREACION DE TABLA TEMPORAL OGS_OPA ::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists ogs_opa;
create temp table ogs_opa(                
 idorigen      integer,              
 idgrupo       integer,              
 idsocio       integer,              
 idorigenp     integer,              
 idproducto    integer,              
 idauxiliar    integer) ;  
CREATE INDEX general_ogs  ON castigos (idorigen,idgrupo,idsocio);
CREATE INDEX general_opa  ON castigos  (idorigenp,idproducto,idauxiliar);

for r_ogs_opa in

     select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar 
       from (select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar 
               from castigos 
              where idproducto in(select idproducto from productos where tipoproducto=2)
      union
             select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar 
               from prestamos_condonaciones) as a 
loop

insert into ogs_opa values
(r_ogs_opa.idorigen,             
 r_ogs_opa.idgrupo,              
 r_ogs_opa.idsocio,              
 r_ogs_opa.idorigenp,             
 r_ogs_opa.idproducto,             
 r_ogs_opa.idauxiliar);

end loop;

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::FIN DE TABLA TEMPORAL OGS_OPA :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::CREACION DE TABLA TEMPORAL FINAL ::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists final;
create temp table final( 
 numerosocio                     text ,  
 per_jur                         numeric,                
 nombre                          text , 
 appaterno                       text ,  
 apmaterno                       text ,  
 rfc                             text,                 
 curp                            character varying(18) , 
genero                           numeric,
 idorigenp                       integer ,               
 idproducto                      integer ,               
 idauxiliar                      integer ,               
 sucursal                        character varying(50)  ,
 clasificacioncredito            character varying(50) , 
 productocredito                 text,                  
 fechaotorgamiento               date,                   
 montooriginal                   numeric(16,2),         
 diasmora                        integer,               
 saldoinsolutocapital            numeric(12,2) ,         
 interesesvencidos               numeric(16,2) ,               
 montoim                         numeric(16,2) ,               
 interesesrefinanciados          text ,                  
 monto_castigo                   numeric(16,2) ,               
 montocondonacion                numeric(16,2) ,               
 fechacastigo                    date,                   
 personarelacionada              numeric ,                  
 montodeestimacionespreventivas  numeric(16,2) ,               
 montodegarantialiquida          numeric(16,2) ,               
 fecha_sic                       text ,                  
 tipocobranza                    numeric ); 
CREATE INDEX final_ogs  ON castigos (idorigen,idgrupo,idsocio);
CREATE INDEX final_opa  ON castigos  (idorigenp,idproducto,idauxiliar);



for r_final in
select distinct (TRIM(TO_CHAR(gen.idorigen,'099999'))||gen.idgrupo||
       TRIM(TO_CHAR(gen.idsocio,'09999999'))) AS NumeroSocio,
       (case when p.razon_social is null or p.razon_social='' then 1 else 2 end) as per_jur,
       upper(p.appaterno)as appaterno, upper(p.apmaterno) as apmaterno, upper(p.nombre) as nombre, p.rfc,
(CASE WHEN p.sexo =1 then '2' when p.sexo=2 then '1' else '0' end )::numeric as genero,
       p.curp as Curp,
       gen.idorigenp,gen.idproducto,gen.idauxiliar,
       gen.idorigenp::varchar as Sucursal,
       (select a.clave from
      (SELECT p.idproducto, p.nombre, p.cuentaaplica, (SELECT nombre FROM cuentas WHERE idcuenta=p.cuentaaplica) AS cuenta,
       CASE WHEN cuentaaplica LIKE '104010101%' THEN '130105010000'
            WHEN cuentaaplica LIKE '104010102%' THEN '130105020000'
            WHEN cuentaaplica LIKE '104010103%' THEN '130105040000'
            WHEN cuentaaplica LIKE '104010104%' THEN '130105050000'
            WHEN cuentaaplica LIKE '104010105%' THEN '130105070000'
            WHEN cuentaaplica LIKE '104010106%' THEN '130122000000'
            WHEN cuentaaplica LIKE '104020101%' THEN '131101000000'
            WHEN cuentaaplica LIKE '104020201%' THEN '131103000000'
            WHEN cuentaaplica LIKE '104020301%' THEN '131113000000'
            WHEN cuentaaplica LIKE '104020401%' THEN '131105000000'
            WHEN cuentaaplica LIKE '104020501%' THEN '131106000000'
            WHEN cuentaaplica LIKE '104020601%' THEN '131104000000'
            WHEN cuentaaplica LIKE '104020701%' THEN '131190000000'
            WHEN cuentaaplica LIKE '10600010101%' THEN '131601000000'
            WHEN cuentaaplica LIKE '10600010201%' THEN '131602000000' END AS clave
       FROM productos AS p WHERE tipoproducto=2 ORDER BY p.cuentaaplica) as a
      where a.idproducto=gen.idproducto) AS Clasificacioncredito,
       upper(pr.nombre) as ProductoCredito,
(select au.fechaactivacion from v_auxiliares au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Fechaotorgamiento,
(select au.montoprestado from v_auxiliares au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as MontoOriginal,


(case when(select max(au.diasvencidos) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) is null then
(select max(au.diasvencidos) from castigos  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) else
(select max(au.diasvencidos) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) end )
 as Diasmora,

(select sum(au.saldoec) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Saldoinsolutocapital,
(select max(au.montoidnc) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Interesesvencidos,
(select max(au.montoim) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as montoim,
'0' as Interesesrefinanciados,

 COALESCE((select SUM(c2.castigo) from (select a.idorigen,a.idgrupo, a.idsocio, 
           a.idorigenp, a.idproducto, a.idauxiliar, a.castigo
from(SELECT c1.idorigen, c1.idgrupo, c1.idsocio, 
           c1.idorigenp, c1.idproducto, c1.idauxiliar, 
           c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza, c1.monto,
(case when (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999)>1 then 
           round((SELECT (c.monto)
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001)/ (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999),3)
else
(SELECT (c.monto)
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001 ) end )

 as castigo
      FROM castigos AS c1 WHERE c1.idproducto >= 30000 AND c1.idproducto <= 39999 )as a where a.castigo is not null)  c2  where (c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar )),0)   as Monto_castigo,






(select sum(au.montoio+au.montoim) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Montocondonacion,


(case when(select max(c2.fecha) from (select a.fecha,a.idorigen,a.idgrupo, a.idsocio, 
           a.idorigenp, a.idproducto, a.idauxiliar, castigo
from(SELECT c1.fecha,c1.idorigen, c1.idgrupo, c1.idsocio, 
           c1.idorigenp, c1.idproducto, c1.idauxiliar, 
           c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza, c1.monto,
           (SELECT c.monto 
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001) as castigo
      FROM castigos AS c1 WHERE c1.idproducto >= 30000 AND c1.idproducto <= 39999)as a where a.castigo is not null)  c2 where (c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ))is null then
(select max(au.fecha) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1)  else
(select max(c2.fecha) from (select a.fecha,a.idorigen,a.idgrupo, a.idsocio, 
           a.idorigenp, a.idproducto, a.idauxiliar, castigo
from(SELECT c1.fecha,c1.idorigen, c1.idgrupo, c1.idsocio, 
           c1.idorigenp, c1.idproducto, c1.idauxiliar, 
           c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza, c1.monto,
           (SELECT c.monto 
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001) as castigo
      FROM castigos AS c1 WHERE c1.idproducto >= 30000 AND c1.idproducto <= 39999)as a where a.castigo is not null)  c2 where (c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar )) end )
 as fechacastigo,


       (case when s.puesto is null then seis.refe::numeric 
             when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=2 then 9
          when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=3 then 10
           when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=4 then 11
           when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=5 then 12
             when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                    FROM referencias re
              inner join (SELECT  re1.idorigen,re1.idgrupo,re1.idsocio
              FROM sopar s inner join  referencias re1 
             USING (idorigen, idgrupo, idsocio)  
             where tipo = 'personas_relacionadas' and re1.tiporeferencia in(0, 1, 7, 14, 15,24,25)) s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and seis.refe::numeric =6 then 13
         when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar) 
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr ,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor, 
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas2') s 
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=7 then 14
       else s.puesto end )  as personarelacionada,


 COALESCE((select SUM(au.montoidnc) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1),0) +
 COALESCE((select SUM(c2.castigo) from (select a.idorigen,a.idgrupo, a.idsocio, 
           a.idorigenp, a.idproducto, a.idauxiliar, a.castigo
from(SELECT c1.idorigen, c1.idgrupo, c1.idsocio, 
           c1.idorigenp, c1.idproducto, c1.idauxiliar, 
           c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza, c1.monto,
(case when (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999)>1 then 
           round((SELECT (c.monto)
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001 )/ (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999),3)
else
(SELECT (c.monto)
              FROM castigos AS c
             WHERE c.idorigenc = c1.idorigenc 
               AND c.periodo = c1.periodo
               AND c.idtipo = c1.idtipo
               AND c.idpoliza = c1.idpoliza
               AND c.idorigen = c1.idorigen
               AND c.idgrupo = c1.idgrupo
               AND c.idsocio = c1.idsocio
               AND c.idproducto = 60001 ) end )

 as castigo


      FROM castigos AS c1 WHERE c1.idproducto >= 30000 AND c1.idproducto <= 39999 )as a where a.castigo is not null)  c2  where (c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar )),0) 
 as Montodeestimacionespreventivas,

(select sum(c.monto) from castigos  c where (c.idorigen,c.idgrupo,c.idsocio)=(gen.idorigen,gen.idgrupo,gen.idsocio ) and c.idproducto in(select idproducto from productos where tipoproducto in (0,1,8))) as MontodeGarantiaLiquida,
'' as fecha_sic,
2 as TipoCobranza

from ogs_opa gen
inner join vpersonas p using(idorigen,idgrupo,idsocio)
LEFT JOIN (select idorigen,idgrupo,idsocio,puesto::numeric from sopar where tipo like 'personas_relacionadas%') s 
           using(idorigen,idgrupo,idsocio)
LEFT JOIN (SELECT  re.idorigen,re.idgrupo,re.idsocio,re.idorigenr ,re.idgrupor ,re.idsocior ,
                   (CASE WHEN re.tiporeferencia in (0, 1, 7, 14, 15,24,25) then 6 END) as refe
             FROM sopar s inner join  referencias re 
            on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio ) 
            where tipo = 'personas_relacionadas' and tiporeferencia in(0, 1, 7, 14, 15,24,25)) seis 
           ON (seis.idorigen,seis.idgrupo,seis.idsocio)=(gen.idorigen,gen.idgrupo,gen.idsocio)
inner join productos pr using(idproducto) 
order by NumeroSocio  loop  
          
insert into final values(
 r_final.numerosocio,  
 r_final.per_jur,               
 r_final.nombre , 
 r_final.appaterno,
 r_final.apmaterno, 
r_final.rfc,          
 r_final.curp ,
 r_final.genero ,
 r_final.idorigenp ,             
 r_final.idproducto,            
 r_final.idauxiliar,             
 r_final.sucursal,
 r_final.clasificacioncredito ,
 r_final.productocredito ,        
 r_final.fechaotorgamiento, 
 r_final.montooriginal,
 r_final.diasmora ,      
 r_final.saldoinsolutocapital ,       
 r_final.interesesvencidos ,      
 r_final.montoim ,      
 r_final.interesesrefinanciados ,           
 r_final.monto_castigo ,            
 r_final.montocondonacion ,             
 r_final.fechacastigo ,               
 (case when r_final.personarelacionada is null then 1 else r_final.personarelacionada end ) ,               
 r_final.montodeestimacionespreventivas,             
 r_final.montodegarantialiquida,            
 r_final.fecha_sic ,        
 r_final.tipocobranza  );

end loop;

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::FIN DE TABLA TEMPORAL FINAL :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::CREACION DE TABLA TEMPORAL ENTREGAR ::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists castigos_cnbv_reporte;
create temp table castigos_cnbv_reporte( 
clave_subreporte    text,
 numerosocio                            text ,  
per_jur                                 numeric,                
 nombre                                 text ,  
 appaterno                              text , 
apmaterno                               text,  
rfc                                     text,             
 curp                                   character varying(18) , 
genero                                  numeric,
 numerocredito                          text ,                  
 sucursal                               integer,  
 clasificacioncredito                   numeric(12), 
 productocredito                        text ,                  
 fechaotorgamiento                      numeric ,                  
 fecha_vencimiento                      numeric ,                  
 modalidad_pago                         numeric,                  
 montooriginal                          numeric(16,2),          
 fecha_ultimo_pago_capital              numeric(8) ,                  
 monto_ultimo_pago_capital              numeric(16,2),          
 fecha_de_ultimo_pago_interes           numeric(8) ,                  
 monto_ultimo_pago_interes              numeric(16,2) ,              
 fecha_ultima_amortizacion_no_cubierta  numeric(16) ,                  
 diasmora                               numeric(6) , 
tipocredito                             varchar(2),              
 saldoinsolutocapital                   numeric(16,2) ,         
 interesesvencidos                      numeric(16,2) ,               
 montoim                                numeric(16,2),               
 interesesrefinanciados                 numeric(16,2),                  
 monto_castigo                          numeric(16,2),              
 montocondonacion                       numeric(16,2),  
  montobonificacion                      numeric(16,2),              
 fechacastigo                           numeric(8),                  
 personarelacionada                     numeric  ,                 
 montodeestimacionespreventivas         numeric(16,2), 
claveprevencion                         integer,                          
 fecha_sic                              text,                 
 tipocobranza                           numeric(2), 
 montodegarantialiquida                 numeric(16,2),
 montodegarantiahipotecaria             numeric(16,2)
);  


---PARA TABLA CONCATENADA
  drop table if exists copiar;
  create temp table copiar(
  id  integer,
  fila   text
  );

    y:=0;
   insert into copiar values(y,'clave_subreporte;numerosocio;per_jur;nombre;appaterno;apmaterno;rfc;curp;genero;numerocredito;sucursal;clasificacioncredito;productocredito;fechaotorgamiento;fecha_vencimiento;modalidad_pago;montooriginal;fecha_ultimo_pago_capital;monto_ultimo_pago_capital;fecha_de_ultimo_pago_interes;monto_ultimo_pago_interes;fecha_ultima_amortizacion_no_cubierta;diasmora;tipocredito;saldoinsolutocapital;interesesvencidos;montoim;interesesrefinanciados;monto_castigo;montocondonacion;montobonificacion;fechacastigo;personarelacionada;montodeestimacionespreventivas;claveprevencion;fecha_sic;tipocobranza;montodegarantialiquida;montodegarantiahipotecaria');
    y:=1;


for r_entregar in
select distinct 
 f.numerosocio,
 f.per_jur,
 f.nombre,
 f.appaterno,
 f.apmaterno,
 f.rfc,
 f.curp,
 f.genero,
   (TRIM(TO_CHAR(f.idorigenp,'099999'))||f.idproducto||TRIM(TO_CHAR(f.idauxiliar,'09999999'))) AS NumeroCredito,
 f.sucursal,
 f.clasificacioncredito ,
 f.productocredito ,
 f.fechaotorgamiento ,
   (case when (select max(am.vence) from amortizaciones_h am where (am.idorigenp,am.idproducto,am.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar)) is null then
 f.fechaotorgamiento+a.plazo::integer else (select max(am.vence) from amortizaciones_h am where (am.idorigenp,am.idproducto,am.idauxiliar)= 
  (f.idorigenp,f.idproducto,f.idauxiliar)) end) as fecha_vencimiento,
  (CASE WHEN plazo = 1 THEN 1 ELSE 6 END)  AS Modalidad_pago,
 f.montooriginal ,
  (case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select date(ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<=f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1)else
  (select date(ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end)
  fecha_ultimo_pago_capital,


  (case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<= f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) else
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha) < f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end ) as
  monto_ultimo_pago_capital,
  (select date(max(ad.fecha)) from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) ) fecha_de_ultimo_pago_interes,
  (select ad.montoio + ad.montoim from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) Monto_ultimo_pago_interes,
 f.fechacastigo-  f.diasmora as fecha_ultima_amortizacion_no_cubierta,
  (case when a.tipoprestamo=0 then 1 when a.tipoprestamo in(1,3) then 2 when a.tipoprestamo in(2,4) then 3 end)::numeric as tipocredito,
 f.diasmora ,
 f.saldoinsolutocapital ,
 f.interesesvencidos ,
 f.montoim ,
 f.interesesrefinanciados ,
 f.monto_castigo ,
 f.montocondonacion  ,
 f.fechacastigo ,
 f.personarelacionada ,
 f.Montodeestimacionespreventivas ,
 f.MontodeGarantiaLiquida ,
 10009 as clave,
 COALESCE(TO_CHAR((select rb.fecha from revision_buro rb where ((TRIM(TO_CHAR(rb.idorigen,'099999'))||rb.idgrupo||
       TRIM(TO_CHAR(rb.idsocio,'09999999'))))=
                  (f.numerosocio) and rb.fecha<= f.fechaotorgamiento order by fecha desc limit 1),'YYYYMMDD')::INTEGER,0)as fecha_sic,
 f.tipocobranza  
from final f inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)  
/*where (case when f.monto_castigo is null then 0 else f.monto_castigo end ) > 0
or (case when f.montocondonacion is null then 0 else f.montocondonacion end ) > 0 */
loop



insert into castigos_cnbv_reporte values(
'0453',
r_entregar.numerosocio ,
r_entregar.per_jur,                
r_entregar.nombre,
r_entregar.appaterno,
r_entregar.apmaterno, 
r_entregar.rfc,        
r_entregar. curp ,
r_entregar.genero,
r_entregar.numerocredito ,          
r_entregar.sucursal::integer ,
r_entregar.clasificacioncredito::numeric ,
r_entregar.productocredito,       
to_char(r_entregar.fechaotorgamiento,'yyyymmdd')::numeric,               
to_char(r_entregar.fecha_vencimiento ,'yyyymmdd')::numeric,             
r_entregar.modalidad_pago ,              
round(r_entregar.montooriginal) ,       
to_char(r_entregar.fecha_ultimo_pago_capital ,'yyyymmdd')::numeric,           
round(r_entregar.monto_ultimo_pago_capital),          
to_char(r_entregar.fecha_de_ultimo_pago_interes,'yyyymmdd')::numeric,         
round(r_entregar.monto_ultimo_pago_interes),           
to_char(r_entregar.fecha_ultima_amortizacion_no_cubierta,'yyyymmdd')::numeric,              
r_entregar.diasmora::numeric , 
r_entregar.tipocredito, 
  (case when r_entregar.saldoinsolutocapital is null then 0 else round(r_entregar.saldoinsolutocapital) end),      
  (case when round(r_entregar.interesesvencidos) is null then 0 else round(r_entregar.interesesvencidos) end),               
  (case when round(r_entregar.montoim)is null then 0 else round(r_entregar.montoim) end),           
r_entregar.interesesrefinanciados::numeric ,                
  (case when r_entregar.monto_castigo is null then  0 else r_entregar.monto_castigo end),            
  (case when r_entregar.montocondonacion is null then  0 else r_entregar.montocondonacion end), 0,             
to_char(r_entregar.fechacastigo,'yyyymmdd')::numeric,                
r_entregar.personarelacionada,               
round(r_entregar.montodeestimacionespreventivas*-1), 
r_entregar.clave,                        
r_entregar.fecha_sic,                 
r_entregar.tipocobranza ,
  (case when r_entregar.montodegarantialiquida is null then 0 else r_entregar.montodegarantialiquida end) , 
  0  
); 


insert into copiar values(y,
'453'||';'||
 coalesce(r_entregar.numerosocio::text,'')||';'||
 coalesce(r_entregar.per_jur::text,'')||';'||                
 coalesce(r_entregar.nombre::text,'')||';'||
 coalesce(r_entregar.appaterno::text,'')||';'||
 coalesce(r_entregar.apmaterno::text,'')||';'|| 
 coalesce(r_entregar.rfc::text,'')||';'||        
 coalesce(r_entregar.curp::text,'')||';'||
 coalesce(r_entregar.genero::text,'')||';'||
 coalesce(r_entregar.numerocredito::text,'')||';'||          
 coalesce(r_entregar.sucursal::integer::text,'')||';'||
 coalesce(r_entregar.clasificacioncredito::numeric::text,'')||';'||
 coalesce(r_entregar.productocredito::text,'')||';'||      
 coalesce(to_char(r_entregar.fechaotorgamiento,'yyyymmdd')::numeric::text,'')||';'||               
 coalesce(to_char(r_entregar.fecha_vencimiento ,'yyyymmdd')::numeric::text,'')||';'||             
 coalesce(r_entregar.modalidad_pago::text,'')||';'||             
 coalesce(round(r_entregar.montooriginal)::text,'')||';'||       
 coalesce(to_char(r_entregar.fecha_ultimo_pago_capital ,'yyyymmdd')::numeric::text,'')||';'||           
 coalesce(round(r_entregar.monto_ultimo_pago_capital)::text,'')||';'||          
 coalesce(to_char(r_entregar.fecha_de_ultimo_pago_interes,'yyyymmdd')::numeric::text,'')||';'||         
 coalesce(round(r_entregar.monto_ultimo_pago_interes)::text,'')||';'||           
 coalesce(to_char(r_entregar.fecha_ultima_amortizacion_no_cubierta,'yyyymmdd')::numeric::text,'')||';'||              
 coalesce(r_entregar.diasmora::numeric::text,'')||';'||
 coalesce(r_entregar.tipocredito::text,'')||';'|| 
 coalesce((case when r_entregar.saldoinsolutocapital is null then 0 else round(r_entregar.saldoinsolutocapital) end)::text,'')||';'||      
 coalesce((case when round(r_entregar.interesesvencidos) is null then 0 else round(r_entregar.interesesvencidos) end)::text,'')||';'||               
 coalesce((case when round(r_entregar.montoim)is null then 0 else round(r_entregar.montoim) end)::text,'')||';'||           
 coalesce(r_entregar.interesesrefinanciados::numeric::text,'')||';'||               
 coalesce((case when r_entregar.monto_castigo is null then  0 else r_entregar.monto_castigo end)::text,'')||';'||            
 coalesce((case when r_entregar.montocondonacion is null then  0 else r_entregar.montocondonacion end)::text,'')||';'||
  '0'||';'||            
 coalesce(to_char(r_entregar.fechacastigo,'yyyymmdd')::numeric::text,'')||';'||                
 coalesce(r_entregar.personarelacionada::text,'')||';'||               
 coalesce(round(r_entregar.montodeestimacionespreventivas*-1)::text,'')||';'|| 
 coalesce(r_entregar.clave::text,'')||';'||                        
 coalesce(r_entregar.fecha_sic::text,'')||';'||                 
 coalesce(r_entregar.tipocobranza::text,'')||';'||
 coalesce((case when r_entregar.montodegarantialiquida is null then 0 else r_entregar.montodegarantialiquida end)::text,'')||';'||
  '0'   
); 

 y:=y+1;


end loop;
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::FIN DE TABLA TEMPORAL ENTREGAR ::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/





for registros in select * from castigos_cnbv_reporte loop
 r.clave_subreporte                       :=registros.clave_subreporte;
 r.numerosocio                            :=registros.numerosocio;
 r.per_jur                                :=registros.per_jur; 
 r.nombre                                 :=registros.nombre; 
 r.appaterno                              :=registros.appaterno;
 r.apmaterno                              :=registros.apmaterno;
 r.rfc                                    :=registros.rfc;
 r.curp                                   :=registros.curp;
 r.genero                                 :=registros.genero;
 r.numerocredito                          :=registros.numerocredito; 
 r.sucursal                               :=registros.sucursal;
 r.clasificacioncredito                   :=registros.clasificacioncredito; 
 r.productocredito                        :=registros.productocredito;
 r.fechaotorgamiento                      :=registros.fechaotorgamiento ; 
 r.fecha_vencimiento                      :=registros.fecha_vencimiento ;
 r.modalidad_pago                         :=registros.modalidad_pago; 
 r.montooriginal                          :=registros.montooriginal;
 r.fecha_ultimo_pago_capital              :=registros.fecha_ultimo_pago_capital;
 r.monto_ultimo_pago_capital              :=registros.monto_ultimo_pago_capital;
 r.fecha_de_ultimo_pago_interes           :=registros.fecha_de_ultimo_pago_interes;
 r.monto_ultimo_pago_interes              :=registros.monto_ultimo_pago_interes;
 r.fecha_ultima_amortizacion_no_cubierta  :=registros.fecha_ultima_amortizacion_no_cubierta;
 r.diasmora                               :=registros.diasmora; 
 r.tipocredito                            :=registros.tipocredito; 
 r.saldoinsolutocapital                   :=registros.saldoinsolutocapital; 
 r.interesesvencidos                      :=registros.interesesvencidos;
 r.montoim                                :=registros.montoim; 
 r.interesesrefinanciados                 :=registros.interesesrefinanciados;
 r.monto_castigo                          :=registros.monto_castigo; 
 r.montocondonacion                       :=registros.montocondonacion; 
 r.montobonificacion                      :=registros.montobonificacion;
 r.fechacastigo                           :=registros.fechacastigo;
 r.personarelacionada                     :=registros.personarelacionada;
 r.montodeestimacionespreventivas         :=registros.montodeestimacionespreventivas;
 r.claveprevencion                        :=registros.claveprevencion;
 r.fecha_sic                              :=registros.fecha_sic ;
r.tipocobranza                            :=registros.tipocobranza ;
 r.montodegarantialiquida                 :=registros.montodegarantialiquida  ;
 r.montodegarantiahipotecaria             :=registros.montodegarantiahipotecaria ;
return next r;
 
end loop;



 select into fechaita to_char(CURRENT_DATE,'dd|mm|yyyy');

  execute 'copy (select fila from copiar order by id) to ''/tmp/reg_453_con_encabezados_'||fechaita||'.csv''  ';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/reg_453_sin_encabezados_'||fechaita||'.csv''  ';

END;
 
$$ language 'plpgsql';
