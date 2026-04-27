/*
CAJA MITRS AUDITORIA FOCOOP 28 NOVIEMBRE 2025

Me podrian apoyar para hacer un query que me arroje los siguientes datos por favor:
[Digital en formato XLSX] Base de datos que contenga el detalle de 
eliminaciones, castigos, condonaciones, 
quitas y descuentos de cartera de credito efectuados durante el periodo de del 
1 de enero 2023 al 30 de septiembre de 2025, que contenga las siguientes columnas de datos:
a)         No. de socio
b)         Nombre de Socio
c)         Fecha de Otorgamiento
d)         Fecha de Vencimiento
e)         Modalidad de Pago
f)          Monto Original
g)         Fecha de ultimo pago de capital
h)         Monto de ultimo pago de capital
i)           Fecha de primera amortizacion no cubierta
j)           Dias de mora al momento del castigo
k)         Tipo de credito (normal, renovado, reestructurado)
l)           Situacion del credito (vigente sin pagos vencidos, vigente con pagos vencidos, vencido en tramite administrativo, vencido en litigio)
m)      Tipo de movimiento (eliminacion, castigo, condonacion, quita, descuento)
Saldo insoluto como sigue (incisos “n” a “s”):
n)         Capital Vigente
o)         Capital Vencido
p)         Intereses vigentes
q)         Intereses Vencido
r)          Intereses moratorios
s)         Intereses refinanciados o capitalizados
t)          Tipo de Acreditado 
(0 No relacionado, 1 consejeros y los miembros del Consejo de Vigilancia, 
Gerente, Comite de Credito y funcionarios 2 nivel, 2 Conyuges y personas que tengan parentesco con consejeros 
y los miembros del Consejo de Vigilancia y Comite de Credito)
u)         Fecha de aprobacion por el organo o funcionario competente
v)         Fecha de registro contable del movimiento
w)       Estatus actual
x)         Monto de Garantia liquida
y)         Fecha de consulta de la SIC */

DROP TYPE public.tipo_reg_453_s cascade;
CREATE TYPE public.tipo_reg_453_s AS (
    clave_subreporte text,
    numerosocio text,
    per_jur numeric,
    nombre text,
    appaterno text,
    apmaterno text,
    rfc text,
    curp varchar(18),
    genero numeric,
    numerocredito text,
    sucursal int4,
    clasificacioncredito numeric(12,0),
    productocredito text,
    fechaotorgamiento date,
    fecha_vencimiento date,
    modalidad_pago numeric,
    montooriginal numeric(16,2),
    fecha_ultimo_pago_capital date,
    monto_ultimo_pago_capital numeric(16,2),
    fecha_de_ultimo_pago_interes date,
    monto_ultimo_pago_interes numeric(16,2),
    fecha_primera_amortizacion_no_cubierta date,
    diasmora numeric(6,0),
    tipocredito varchar(2),
    saldoinsolutocapital numeric(16,2),
    interesesvencidos numeric(16,2),
    montoim numeric(16,2),
    interesesrefinanciados numeric(16,2),
    monto_castigo numeric(16,2),
    montocondonacion numeric(16,2),
    fechacastigo date,
    personarelacionada numeric,
    montodeestimacionespreventivas numeric(16,2),
    claveprevencion int4,
    fecha_sic text,
    tipocobranza numeric(2,0),
    montodegarantialiquida numeric(16,2),
    montodegarantiahipotecaria numeric(16,2));

 DROP FUNCTION public.reg_453_s();
CREATE OR REPLACE FUNCTION public.reg_453_s()
 RETURNS SETOF tipo_reg_453_s
 LANGUAGE plpgsql
AS $function$

DECLARE

fecha_inicial  date;
fecha_Final    date;
r    tipo_reg_453_s%rowtype;

r_rec                record;

r_castigos           record;
r_condonaciones      record;
r_ogs_opa            record;
r_entregar           record;
r_final              record;
registros            record;
fechaita                varchar;
y                    integer;
  x_cuenta_castigo text;
  prod_cond_ordinarios integer;
  prod_cond_moratorios integer;
    px1 varchar;

BEGIN

-- select into fecha_final,fecha_inicial fecha,(01||to_char(fecha,'/mm/yyyy'))::date from(select distinct date(fechatrabajo) as fecha from origenes) as x;


  fecha_inicial := date('01-05-2023');
  fecha_Final := date('31-08-2025');




x_cuenta_castigo := (SELECT dato1 FROM tablas WHERE idtabla='claves_reg453' AND idelemento='cuenta_castigo');

  prod_cond_ordinarios := 0; prod_cond_moratorios := 0;

  px1 := (SELECT dato2 FROM tablas WHERE idtabla='claves_reg453' AND idelemento='cuenta_castigo')::varchar;
  if px1 is not NULL and length(px1) > 0 then prod_cond_ordinarios := px1::integer; end if;

  px1 := (SELECT dato3 FROM tablas WHERE idtabla='claves_reg453' AND idelemento='cuenta_castigo')::varchar;
  if px1 is not NULL and length(px1) > 0 then prod_cond_moratorios := px1::integer; end if;

IF (x_cuenta_castigo is null or x_cuenta_castigo = '') or prod_cond_ordinarios = 0 or prod_cond_moratorios = 0
THEN
  IF (x_cuenta_castigo is null or x_cuenta_castigo = '') then
       RAISE NOTICE '  ';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==                   FALTA CONFIGURAR LA TABLA:                   ==';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==   IDTabla = claves_reg453                                      ==';
       RAISE NOTICE '==   IDElemento = cuenta_castigo                                  ==';
       RAISE NOTICE '==   Parametro1 = (iniciales de la cuenta contable de castigos)   ==';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '  ';
       RETURN ;
  end if;

  IF prod_cond_ordinarios = 0 then
       RAISE NOTICE '  ';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==                   FALTA CONFIGURAR LA TABLA:                   ==';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==   IDTabla = claves_reg453                                      ==';
       RAISE NOTICE '==   IDElemento = cuenta_castigo                                  ==';
       RAISE NOTICE '==   Parametro2 = Producto de condonacion de int. ordinarios      ==';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '  ';
       RETURN ;
  end if;

  IF prod_cond_moratorios = 0 then
       RAISE NOTICE '  ';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==                   FALTA CONFIGURAR LA TABLA:                   ==';
       RAISE NOTICE '==                                                                ==';
       RAISE NOTICE '==   IDTabla = claves_reg453                                      ==';
       RAISE NOTICE '==   IDElemento = cuenta_castigo                                  ==';
       RAISE NOTICE '==   Parametro3 = Producto de condonacion de int. moratorios      ==';
       RAISE NOTICE '====================================================================';
       RAISE NOTICE '  ';
       RETURN ;
  end if;

ELSE











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
                                                                   where idproducto=403   
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
                                                                     where idproducto=403  
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

 cartera       varchar, 

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
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad. monto,
              ad.montoio,ad. montoim,ad. montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad. idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm,
        (select cartera from balancecred where (idorigenp,idproducto,idauxiliar)= (ad.idorigenp,ad.idproducto,ad.idauxiliar) and fechacierre <  ad.fecha::date order by fechacierre desc limit 1) as cartera 
        from  auxiliares_d ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
       where ad.tipomov=3  and ad.fecha::date between fecha_inicial  and fecha_Final
         and ad.idproducto between 30000 and 39999 
union
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad. idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad. monto,
              ad.montoio,ad. montoim,ad. montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad. idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm,
     (select cartera from balancecred_h where (idorigenp,idproducto,idauxiliar)= (ad.idorigenp,ad.idproducto,ad.idauxiliar) and fechacierre <  ad.fecha::date order by fechacierre desc limit 1) as cartera 
        from  auxiliares_d_h ad inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
       where ad.tipomov=3  and ad.fecha::date between fecha_inicial  and fecha_Final
         and ad.idproducto between 30000 and 39999 

-- select * from v_balancecred where (idorigenp,idproducto,idauxiliar)=  (20702 ,      34302 ,       6593) and fechacierre <  date('30-09-2024') order by fechacierre desc limit 1; 

loop

insert into prestamos_condonaciones values
 (r_condonaciones.idorigen ,               
  r_condonaciones.idgrupo ,               
  r_condonaciones.idsocio ,               
  r_condonaciones.idorigenp,               
  r_condonaciones.idproducto ,              
  r_condonaciones.idauxiliar, 

   r_condonaciones.cartera,

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
:::::::::::::::: CREACION DE LA TABLA DE RECUPERACIONES :::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

  drop table if exists prestamos_recuperaciones;
  create temp table prestamos_recuperaciones(
    idorigen    integer,
    idgrupo     integer,
    idsocio     integer,
    idorigenp   integer,
    idproducto  integer,
    idauxiliar  integer,
    fecha       date,
    cargoabono  numeric(1,0),
    monto       numeric(12,2),
    idorigenc   integer,
    periodo     varchar(6),
    idtipo      numeric(1,0),
    idpoliza    integer,
    transaccion integer
  );

  for r_rec in
     select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar,ad.fecha::date,ad.cargoabono,ad.monto,
            ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.transaccion
     from  auxiliares_d ad
           inner join v_auxiliares a using (idorigenp,idproducto,idauxiliar)
           -- inner join castigos using (idorigen,idgrupo,idsocio)
     where ad.idorigenp > 0 and (ad.idproducto = prod_cond_ordinarios or ad.idproducto = prod_cond_moratorios) and
           ad.idauxiliar > 0 and ad.cargoabono = 1
   union
     select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar,ad.fecha::date,ad.cargoabono,ad.monto,
            ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.transaccion
     from  auxiliares_d_h ad
           inner join v_auxiliares a using (idorigenp,idproducto,idauxiliar)
           -- inner join castigos using (idorigen,idgrupo,idsocio)
     where ad.idorigenp > 0 and (ad.idproducto = prod_cond_ordinarios or ad.idproducto = prod_cond_moratorios) and
           ad.idauxiliar > 0 and ad.cargoabono = 1
  loop





    insert into prestamos_recuperaciones values (
      r_rec.idorigen,
      r_rec.idgrupo,
      r_rec.idsocio,
      r_rec.idorigenp,
      r_rec.idproducto,
      r_rec.idauxiliar,
      r_rec.fecha,
      r_rec.cargoabono,
      r_rec.monto,
      r_rec.idorigenc,
      r_rec.periodo,
      r_rec.idtipo,
      r_rec.idpoliza,
     r_rec.transaccion
    );

  end loop;

 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::: FIN DE LA TABLA DE RECUPERACIONES ::::::::::::::::::::::
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
select distinct (TRIM(TO_CHAR(gen.idorigen,'09999999999999'))||trim(to_char(gen.idgrupo,'09'))||
       TRIM(TO_CHAR(gen.idsocio,'099999'))) AS NumeroSocio,
       (case when p.razon_social is null or p.razon_social='' then 1 else 2 end) as per_jur,
       upper(p.appaterno)as appaterno, upper(p.apmaterno) as apmaterno, upper(p.nombre) as nombre, p.rfc,
(CASE WHEN p.sexo =1 then '2' when p.sexo=2 then '1' else '0' end )::numeric as genero,
       p.curp as Curp,
       gen.idorigenp,gen.idproducto,gen.idauxiliar,


      (select clave_regularorio from claves_regulatorios_sucursales where idorigen=gen.idorigenp limit 1) as Sucursal,


(SELECT
            case
            WHEN p.cuentaaplica LIKE '104010101%' and a.cartera!='V' THEN '0130105010000'
            WHEN p.cuentaaplica LIKE '104010102%' and a.cartera!='V' THEN '0130105020000'
            WHEN p.cuentaaplica LIKE '104010103%' and a.cartera!='V' THEN '0130105040000'
            WHEN p.cuentaaplica LIKE '104010104%' and a.cartera!='V' THEN '0130105050000'
            WHEN p.cuentaaplica LIKE '104010105%' and a.cartera!='V' THEN '0130105070000'
            WHEN p.cuentaaplica LIKE '104010106%' and a.cartera!='V' THEN '0130122000000'
            WHEN p.cuentaaplica LIKE '104020101%' and a.cartera!='V' THEN '0131101000000'
            WHEN p.cuentaaplica LIKE '104020201%' and a.cartera!='V' THEN '0131103000000'
            WHEN p.cuentaaplica LIKE '104020301%' and a.cartera!='V' THEN '0131113000000'
            WHEN p.cuentaaplica LIKE '104020401%' and a.cartera!='V' THEN '0131105000000'
            WHEN p.cuentaaplica LIKE '104020501%' and a.cartera!='V' THEN '0131106000000'
            WHEN p.cuentaaplica LIKE '104020601%' and a.cartera!='V' THEN '0131104000000'
            WHEN p.cuentaaplica LIKE '104020701%' and a.cartera!='V' THEN '0131190000000'
            WHEN p.cuentaaplica LIKE '10600010101%' and a.cartera!='V' THEN '0131601000000'
            WHEN p.cuentaaplica LIKE '10600010201%' and a.cartera!='V' THEN '0131602000000'

            WHEN p.cuentaaplica LIKE '104010101%' and a.cartera='V' THEN '0135105010000'
            WHEN p.cuentaaplica LIKE '104010102%' and a.cartera='V' THEN '0135105020000'
            WHEN p.cuentaaplica LIKE '104010103%' and a.cartera='V' THEN '0135105040000'
            WHEN p.cuentaaplica LIKE '104010104%' and a.cartera='V' THEN '0135105050000'
            WHEN p.cuentaaplica LIKE '104010105%' and a.cartera='V' THEN '0135105070000'
            WHEN p.cuentaaplica LIKE '104010106%' and a.cartera='V' THEN '0135122000000'
            WHEN p.cuentaaplica LIKE '104020101%' and a.cartera='V' THEN '0136101000000'
            WHEN p.cuentaaplica LIKE '104020201%' and a.cartera='V' THEN '0136103000000'
            WHEN p.cuentaaplica LIKE '104020301%' and a.cartera='V' THEN '0136113000000'
            WHEN p.cuentaaplica LIKE '104020401%' and a.cartera='V' THEN '0136105000000'
            WHEN p.cuentaaplica LIKE '104020501%' and a.cartera='V' THEN '0136106000000'
            WHEN p.cuentaaplica LIKE '104020601%' and a.cartera='V' THEN '0136104000000'
            WHEN p.cuentaaplica LIKE '104020701%' and a.cartera='V' THEN '0136190000000'
            WHEN p.cuentaaplica LIKE '10600010101%' and a.cartera='V' THEN '0136601000000'
            WHEN p.cuentaaplica LIKE '10600010201%' and a.cartera='V' THEN '0136602000000' END
          from productos p
          inner join v_auxiliares a using(idproducto)
          where p.tipoproducto=2 and p.idproducto=gen.idproducto
          and a.idorigenp=gen.idorigenp and a.idproducto=gen.idproducto and a.idauxiliar=gen.idauxiliar
          ORDER BY p.cuentaaplica) AS Clasificacioncredito,

         (select clave_regularorio from claves_regulatorios_productos cvr where cvr.idproducto=pr.idproducto limit 1)
     as ProductoCredito,

     (select to_char(au.fechaactivacion,'yyyy-mm-dd') from v_auxiliares au
      where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Fechaotorgamiento,


(select au.montoprestado from v_auxiliares au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as MontoOriginal,


(case when(select max(au.diasvencidos) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) is null then
(select max(au.diasvencidos) from castigos  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) else
(select max(au.diasvencidos) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) end )
 as Diasmora,

(select sum(au.saldoec) from prestamos_condonaciones  au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Saldoinsolutocapital,

     (case when ((select sum(au.montoio) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)) -
                coalesce(
                (select sum(monto) from prestamos_recuperaciones pc
                 where pc.idorigen = gen.idorigen and pc.idgrupo = gen.idgrupo and pc.idsocio = gen.idsocio and idorigenp > 0 and
                       pc.idproducto = prod_cond_ordinarios and pc.idauxiliar > 0 and
                       date(pc.fecha) >
                       (select au.fecha from prestamos_condonaciones au
                        where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                              (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
                        order by au.fecha asc limit 1)),0.0) ) < 0
          then 0.0
          else ((select sum(au.montoio) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)) -
                coalesce(
                (select sum(monto) from prestamos_recuperaciones pc
                 where pc.idorigen = gen.idorigen and pc.idgrupo = gen.idgrupo and pc.idsocio = gen.idsocio and idorigenp > 0 and
                       pc.idproducto = prod_cond_ordinarios and pc.idauxiliar > 0 and
                       date(pc.fecha) >
                       (select au.fecha from prestamos_condonaciones au
                        where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                              (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
                        order by au.fecha asc limit 1)),0.0) )
     end)  as Interesesvencidos,



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
               AND c.idproducto = 403)/ (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999),3)
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
               AND c.idproducto = 403 ) end )

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
               AND c.idproducto = 403) as castigo
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
               AND c.idproducto = 403) as castigo
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



--- estimacionespreventivas

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
               AND c.idproducto = 403 )/ (select count(*) from castigos c3 where (c3.idorigen,c3.idgrupo,c3.idsocio,c3.idorigenc, c3.periodo, c3.idtipo, c3.idpoliza)=(c1.idorigen,c1.idgrupo,c1.idsocio,c1.idorigenc, c1.periodo, c1.idtipo, c1.idpoliza) and c3.idproducto >= 30000 AND c3.idproducto <= 39999),3)
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
               AND c.idproducto = 403 ) end )

 as castigo
FROM castigos AS c1 WHERE c1.idproducto >= 30000 AND c1.idproducto <= 39999 )as a where a.castigo is not null or a.castigo <> 0)  c2  where (c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar )),0) 
 

 as Montodeestimacionespreventivas,
-- select * from castigos where (idorigenp,idproducto,idauxiliar)=(20702,34302,00006593);

-- select * from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(20702,34302,00006593);

-- select monto_castigo,montocondonacion,montodeestimacionespreventivas, (saldoinsolutocapital::numeric + interesesvencidos::numeric + montoim::numeric  ) - montodegarantialiquida::numeric as estimacion_preventiva from castigos_cnbv_reporte_focoop_s



 (select split_part(referencia,'|',1) from referenciasp rp where rp.idorigenp=gen.idorigenp and rp.idproducto=gen.idproducto and rp.idauxiliar=gen.idauxiliar and rp.tiporeferencia=4 limit 1)::numeric
 as MontodeGarantiaLiquida,


'' as fecha_sic,
(case when
           p.idgrupo = (select dato1 from tablas where idtabla='regulatorio453' and idelemento='tipo_cobranza')::numeric
           then '06'
      when p.idgrupo = (select dato2 from tablas where idtabla='regulatorio453' and idelemento='tipo_cobranza')::numeric
           then '03'
      when p.idgrupo = (select dato3 from tablas where idtabla='regulatorio453' and idelemento='tipo_cobranza')::numeric
           then '02'
 else '03' end)  as TipoCobranza

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
 r_final.fechaotorgamiento::date, 
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
 r_final.tipocobranza::numeric );

end loop;

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::FIN DE TABLA TEMPORAL FINAL :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::CREACION DE TABLA TEMPORAL ENTREGAR ::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists castigos_cnbv_reporte_focoop_s;
create table castigos_cnbv_reporte_focoop_s( 
clave_subreporte                                text,
"|1"                                               text,
numerosocio                                     text , 
"|2"                                               varchar, 
per_jur                                         text,
"|3"                                               varchar,                
nombre                                          text ,
"|4"                                               varchar,  
appaterno                                       text ,
"|5"                                               varchar, 
apmaterno                                       text,
"|6"                                               varchar,  
rfc                                             text,
"|7"                                               varchar,             
curp                                            character varying(18) ,
"|8"                                               varchar, 
genero                                          numeric,
"|9"                                               varchar,
numerocredito                                   text , 
"|10"                                               varchar,                 
sucursal                                         integer,
"|11"                                               varchar,  
clasificacioncredito                            text, 
"|12"                                               varchar,
productocredito                                 text ,  
"|13"                                               varchar,                
fechaotorgamiento                               text ,  
"|14"                                               varchar,                
fecha_vencimiento                               text , 
"|15"                                               varchar,                 
modalidad_pago                                  text,   
"|16"                                               varchar,               
montooriginal                                   text,   
"|17"                                               varchar,       
fecha_ultimo_pago_capital                       text ,  
"|18"                                               varchar,                
monto_ultimo_pago_capital                       text,   
"|19"                                               varchar,       
fecha_de_ultimo_pago_interes                    text ,  
"|20"                                               varchar,                
monto_ultimo_pago_interes                       text ,  
"|21"                                               varchar,            
fecha_primera_amortizacion_no_cubierta          text,   
"|22"                                               varchar,               
diasmora                                        text, 
"|23"                                               varchar,
tipocredito                                     text,   
"|24"                                               varchar,           
saldoinsolutocapital                            text ,  
"|25"                                               varchar,       
interesesvencidos                               text ,  
"|26"                                               varchar,             
montoim                                         text,   
"|27"                                               varchar,            
interesesrefinanciados                          text,   
"|28"                                               varchar,               
monto_castigo                                   text,   
"|29"                                               varchar,           
montocondonacion                                text,   
"|30"                                               varchar,        
fechacastigo                                    text,   
"|31"                                               varchar,               
personarelacionada                              numeric, 
"|32"                                               varchar,                  
montodeestimacionespreventivas                  text, 
"|33"                                               varchar,
claveprevencion                                 text,   
"|34"                                               varchar,                       
fecha_sic                                       text,   
"|35"                                               varchar,              
tipocobranza                                    text, 
"|36"                                               varchar,
montodegarantialiquida                          text,
"|37"                                               varchar,
montodegarantiahipotecaria                      text,
"|38"                                               varchar,
nombre_administrativo_funcionario_autorizo      text, 
"|39"                                               varchar,
cargo_administrativo_funcionario_autorizo       text, 
"|40"                                               varchar,
fecha_recuperacion                              text,
"|41"                                               varchar,
monto_recuperado                                text,
"|42"                                               varchar,
convenio_adeudo                                 text, 
"|43"                                               varchar,
tipo_recuperacion                               text,
"|44"                                               varchar,
tipo_adjudicacion                               text


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
 (TRIM(TO_CHAR(f.idorigenp,'099999999'))||trim(to_char(f.idproducto,'09999'))||TRIM(TO_CHAR(f.idauxiliar,'09999999')))  AS NumeroCredito,
 f.sucursal,
 f.clasificacioncredito ,
 f.productocredito ,
 f.fechaotorgamiento ,

coalesce((select to_char(am.vence,'yyyy-mm-dd') from v_amortizaciones am where am.idorigenp=a.idorigenp and am.idproducto=a.idproducto and am.idauxiliar=a.idauxiliar order by am.vence desc limit 1)::text, '9999-12-31')
 as fecha_vencimiento,

    (CASE WHEN a.plazo=1  THEN 1
        ELSE 3 END)as Modalidad_pago,--------------------Modalidad de pago


 f.montooriginal ,
COALESCE(
(case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select date(ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<=date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1)else
  (select date (ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end),'9999-12-31')
  fecha_ultimo_pago_capital,


  (case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<= f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) else
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha) < f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end ) as
  monto_ultimo_pago_capital,

   COALESCE((select date(max(ad.fecha)) from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar)),'9999-12-31')fecha_de_ultimo_pago_interes,

 (select ad.montoio + ad.montoim from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1)as Monto_ultimo_pago_interes,



coalesce(trim(to_char((select am.vence from amortizaciones_h am where am.idorigenp=f.idorigenp and am.idproducto = f.idproducto
AND am.idauxiliar = f.idauxiliar and am.diasvencidos>0
union
select am.vence from amortizaciones am where am.idorigenp=f.idorigenp and am.idproducto = f.idproducto
AND am.idauxiliar = f.idauxiliar  and am.diasvencidos>0
order by  vence limit 1),'yyyy-mm-dd')),'9999-12-31') as fecha_primera_amortizacion_no_cubierta,




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
 COALESCE(TO_CHAR((select rb.fecha from revision_buro rb where 
         rb.idorigen=SUBSTRING(f.numerosocio, 1, 14)::integer and rb.idgrupo=SUBSTRING(f.numerosocio, 15, 2)::integer and rb.idsocio=SUBSTRING(f.numerosocio, 17, 6)::integer 
                  and 

                  rb.fecha<= f.fechaotorgamiento order by fecha desc limit 1),'YYYY-MM-DD'),'9999-12-31')as fecha_sic,
 





 f.tipocobranza  
from final f inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)  
/*where (case when f.monto_castigo is null then 0 else f.monto_castigo end ) > 0
or (case when f.montocondonacion is null then 0 else f.montocondonacion end ) > 0 */
loop

if 
(r_entregar.monto_castigo::numeric > 0 and (r_entregar.montocondonacion::numeric = 0 or r_entregar.montocondonacion is null ))
or 
((r_entregar.monto_castigo::numeric = 0 or r_entregar.monto_castigo is null)  and r_entregar.montocondonacion::numeric > 0 )

then


insert into castigos_cnbv_reporte_focoop_s values(
'0453',
'|',
 r_entregar.numerosocio ,
 '|',
r_entregar.per_jur,   
 '|',             
 r_entregar.nombre,
 '|',
 r_entregar.appaterno,
 '|',
  r_entregar.apmaterno, 
 '|',
r_entregar.rfc,        
 '|',
 r_entregar. curp ,
 '|',
 r_entregar.genero,
 '|',
 r_entregar.numerocredito ,          
 '|',
 r_entregar.sucursal::integer ,
 '|',
 r_entregar.clasificacioncredito::numeric ,
 '|',
 r_entregar.productocredito,       
'|',
to_char(r_entregar.fechaotorgamiento::date,'yyyy-mm-dd'),               
'|',
to_char(r_entregar.fecha_vencimiento::date,'yyyy-mm-dd'),           
 '|',
 r_entregar.modalidad_pago ,              
 '|',
 to_char(round(r_entregar.montooriginal),'099999999999999999.99'),       
'|',
to_char(r_entregar.fecha_ultimo_pago_capital::date,'yyyy-mm-dd'),           
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')) is null then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')end),         
'|',
 to_char(r_entregar.fecha_de_ultimo_pago_interes::date,'yyyy-mm-dd'),        
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99'))IS NULL then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99') end),          
'|',
 to_char(r_entregar.fecha_primera_amortizacion_no_cubierta::date,'yyyy-mm-dd'),            
'|',
 r_entregar.diasmora::numeric , 
'|',
 r_entregar.tipocredito, 
 '|',
 (case when trim(to_char(round(r_entregar.saldoinsolutocapital),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.saldoinsolutocapital,'099999999999999999.99')) end),     
 '|',
 (case when  trim(to_char(round(r_entregar.interesesvencidos),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.interesesvencidos,'099999999999999999.99')) end),              
 '|',
 (case when  trim(to_char(round(r_entregar.montoim),'099999999999999999.99'))is null then '000000000000000000000' else trim(to_char(r_entregar.montoim,'099999999999999999.99')) end),         
 '|',
 trim(to_char(r_entregar.interesesrefinanciados::numeric,'099999999999999999.99')),             
 '|',
 (case when trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) end),         
 '|',
 (case when  trim(to_char(r_entregar.montocondonacion,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.montocondonacion,'099999999999999999.99')) end),           
 '|',
 to_char(r_entregar.fechacastigo::date,'yyyy-mm-dd'),                
 '|',
 r_entregar.personarelacionada,               
 '|',



(case 
    when r_entregar.monto_castigo::numeric > 0 and (r_entregar.montocondonacion::numeric = 0 or r_entregar.montocondonacion is null )
    then 
    to_char(r_entregar.monto_castigo,'099999999999999999.99')
    when (r_entregar.monto_castigo::numeric = 0 or r_entregar.monto_castigo is null)  and r_entregar.montocondonacion::numeric > 0 
    then 
        (case  
            when (select cartera from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer ) limit 1  ) = 'V'  
            then  (select to_char (sum(montoidnc),'099999999999999999.99') from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer) and cartera='V')
            else  (select  to_char(sum(montoio)  ,'099999999999999999.99') from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer) and cartera != 'V' )

        end)

end),
-- r_entregar.numerocredito

--  SUBSTRING(r_entregar.numerocredito , 1, 9)::integer

--  SUBSTRING(r_entregar.numerocredito , 10, 5)::integer

--  SUBSTRING(r_entregar.numerocredito , 15, 8)::integer
 /*
     20746 ,      30302 ,          3
     20746 |      30302 |          3
     20746 ,      30702 ,          8
     20746 |      30702 |          8
*/

-- select SUBSTRING('0000207273070300000039', 1, 9)::integer;

-- select SUBSTRING('0000207273070300000039', 10, 5)::integer;

-- select SUBSTRING('0000207273070300000039', 15, 8)::integer;




'|',
r_entregar.clave,                        
'|',
to_char(r_entregar.fecha_sic::date,'yyyy-mm-dd'),                 
 '|',
 r_entregar.tipocobranza::varchar ,
'|',
(case when r_entregar.montodegarantialiquida is null then '000000000000000000.00' else trim(to_char(r_entregar.montodegarantialiquida,'099999999999999999.99')) end),
 '|',
 '000000000000000000.00',
 '|',
 'ND',
 '|',
 'ND',
  '|',
  (select coalesce(to_char(max(fecha),'YYYY-MM-DD'),'ND') from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
'|',
(select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
 '|',
 'ND',
  '|',
  ( case when  (select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)) = 0 then 'ND'  else 'En efectivo' end),
  '|',
   'ND'

); 
-- CASTIGO
elsif r_entregar.monto_castigo::numeric > 0 and r_entregar.montocondonacion::numeric > 0
then 
insert into castigos_cnbv_reporte_focoop_s values
(
'0453',
'|',
 r_entregar.numerosocio ,
 '|',
r_entregar.per_jur,   
 '|',             
 r_entregar.nombre,
 '|',
 r_entregar.appaterno,
 '|',
  r_entregar.apmaterno, 
 '|',
r_entregar.rfc,        
 '|',
 r_entregar. curp ,
 '|',
 r_entregar.genero,
 '|',
 r_entregar.numerocredito ,          
 '|',
 r_entregar.sucursal::integer ,
 '|',
 r_entregar.clasificacioncredito::numeric ,
 '|',
 r_entregar.productocredito,       
'|',
to_char(r_entregar.fechaotorgamiento::date,'yyyy-mm-dd'),               
'|',
to_char(r_entregar.fecha_vencimiento::date,'yyyy-mm-dd'),           
 '|',
 r_entregar.modalidad_pago ,              
 '|',
 to_char(round(r_entregar.montooriginal),'099999999999999999.99'),       
'|',
to_char(r_entregar.fecha_ultimo_pago_capital::date,'yyyy-mm-dd'),           
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')) is null then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')end),         
'|',
 to_char(r_entregar.fecha_de_ultimo_pago_interes::date,'yyyy-mm-dd'),        
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99'))IS NULL then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99') end),          
'|',
 to_char(r_entregar.fecha_primera_amortizacion_no_cubierta::date,'yyyy-mm-dd'),            
'|',
 r_entregar.diasmora::numeric , 
'|',
 r_entregar.tipocredito, 
 '|',
 (case when trim(to_char(round(r_entregar.saldoinsolutocapital),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.saldoinsolutocapital,'099999999999999999.99')) end),     
 '|',
 (case when  trim(to_char(round(r_entregar.interesesvencidos),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.interesesvencidos,'099999999999999999.99')) end),              
 '|',
 (case when  trim(to_char(round(r_entregar.montoim),'099999999999999999.99'))is null then '000000000000000000000' else trim(to_char(r_entregar.montoim,'099999999999999999.99')) end),         
 '|',
 trim(to_char(r_entregar.interesesrefinanciados::numeric,'099999999999999999.99')),             
 '|',
 (case when trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) end),         
 '|',
 '000000000000000000000',           
 '|',
 to_char(r_entregar.fechacastigo::date,'yyyy-mm-dd'),                
 '|',
 r_entregar.personarelacionada,               
 '|',

 trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')),

'|',
r_entregar.clave,                        
'|',
to_char(r_entregar.fecha_sic::date,'yyyy-mm-dd'),                 
 '|',
 r_entregar.tipocobranza::varchar ,
'|',
(case when r_entregar.montodegarantialiquida is null then '000000000000000000.00' else trim(to_char(r_entregar.montodegarantialiquida,'099999999999999999.99')) end),
 '|',
 '000000000000000000.00',
 '|',
 'ND',
 '|',
 'ND',
  '|',
  (select coalesce(to_char(max(fecha),'YYYY-MM-DD'),'ND') from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
'|',
(select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
 '|',
 'ND',
  '|',
  ( case when  (select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)) = 0 then 'ND'  else 'En efectivo' end),
  '|',
   'ND'

); 



-- CONDONACION
insert into castigos_cnbv_reporte_focoop_s values
(
'0453',
'|',
 r_entregar.numerosocio ,
 '|',
r_entregar.per_jur,   
 '|',             
 r_entregar.nombre,
 '|',
 r_entregar.appaterno,
 '|',
  r_entregar.apmaterno, 
 '|',
r_entregar.rfc,        
 '|',
 r_entregar. curp ,
 '|',
 r_entregar.genero,
 '|',
 r_entregar.numerocredito ,          
 '|',
 r_entregar.sucursal::integer ,
 '|',
 r_entregar.clasificacioncredito::numeric ,
 '|',
 r_entregar.productocredito,       
'|',
to_char(r_entregar.fechaotorgamiento::date,'yyyy-mm-dd'),               
'|',
to_char(r_entregar.fecha_vencimiento::date,'yyyy-mm-dd'),           
 '|',
 r_entregar.modalidad_pago ,              
 '|',
 to_char(round(r_entregar.montooriginal),'099999999999999999.99'),       
'|',
to_char(r_entregar.fecha_ultimo_pago_capital::date,'yyyy-mm-dd'),           
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')) is null then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')end),         
'|',
 to_char(r_entregar.fecha_de_ultimo_pago_interes::date,'yyyy-mm-dd'),        
'|',
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99'))IS NULL then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99') end),          
'|',
 to_char(r_entregar.fecha_primera_amortizacion_no_cubierta::date,'yyyy-mm-dd'),            
'|',
 r_entregar.diasmora::numeric , 
'|',
 r_entregar.tipocredito, 
 '|',
 (case when trim(to_char(round(r_entregar.saldoinsolutocapital),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.saldoinsolutocapital,'099999999999999999.99')) end),     
 '|',
 (case when  trim(to_char(round(r_entregar.interesesvencidos),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.interesesvencidos,'099999999999999999.99')) end),              
 '|',
 (case when  trim(to_char(round(r_entregar.montoim),'099999999999999999.99'))is null then '000000000000000000000' else trim(to_char(r_entregar.montoim,'099999999999999999.99')) end),         
 '|',
 trim(to_char(r_entregar.interesesrefinanciados::numeric,'099999999999999999.99')),             
 '|',
 '000000000000000000000',         
 '|',
 (case when  trim(to_char(r_entregar.montocondonacion,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.montocondonacion,'099999999999999999.99')) end),          
 '|',
 to_char(r_entregar.fechacastigo::date,'yyyy-mm-dd'),                
 '|',
 r_entregar.personarelacionada,               
 '|',

(case  
            when (select cartera from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer ) limit 1  ) = 'V'  
            then  (select to_char (sum(montoidnc),'099999999999999999.99') from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer) and cartera='V')
            else  (select  to_char(sum(montoio)  ,'099999999999999999.99') from prestamos_condonaciones where (idorigenp,idproducto,idauxiliar)=(SUBSTRING(r_entregar.numerocredito , 1, 9)::integer,SUBSTRING(r_entregar.numerocredito , 10, 5)::integer,SUBSTRING(r_entregar.numerocredito , 15, 8)::integer) and cartera != 'V' )

    end),

'|',
r_entregar.clave,                        
'|',
to_char(r_entregar.fecha_sic::date,'yyyy-mm-dd'),                 
 '|',
 r_entregar.tipocobranza::varchar ,
'|',
(case when r_entregar.montodegarantialiquida is null then '000000000000000000.00' else trim(to_char(r_entregar.montodegarantialiquida,'099999999999999999.99')) end),
 '|',
 '000000000000000000.00',
 '|',
 'ND',
 '|',
 'ND',
  '|',
  (select coalesce(to_char(max(fecha),'YYYY-MM-DD'),'ND') from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
'|',
(select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)),
 '|',
 'ND',
  '|',
  ( case when  (select coalesce(sum(monto),0) from servicios_d where idorigen = substr(r_entregar.numerosocio,1,6)::integer and idgrupo = substr(r_entregar.numerosocio,7,2)::integer and idsocio= substr(r_entregar.numerosocio,9,8)::integer and idproducto in (538, 539 , 561)) = 0 then 'ND'  else 'En efectivo' end),
  '|',
   'ND'

); 


end if;
-- select substr(r_entregar.numerosocio,1,6)::integer;     '0207021000006998'
-- select substr(r_entregar.numerosocio,7,2)::integer;     '0207021000006998'
-- select substr(r_entregar.numerosocio,9,8)::integer;     '0207021000006998'



 y:=y+1;


end loop;
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::FIN DE TABLA TEMPORAL ENTREGAR ::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/





for registros in select * from castigos_cnbv_reporte_focoop_s loop
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
 r.fecha_primera_amortizacion_no_cubierta :=registros.fecha_primera_amortizacion_no_cubierta;
 r.diasmora                               :=registros.diasmora; 
 r.tipocredito                            :=registros.tipocredito; 
 r.saldoinsolutocapital                   :=registros.saldoinsolutocapital; 
 r.interesesvencidos                      :=registros.interesesvencidos;
 r.montoim                                :=registros.montoim; 
 r.interesesrefinanciados                 :=registros.interesesrefinanciados;
 r.monto_castigo                          :=registros.monto_castigo; 
 r.montocondonacion                       :=registros.montocondonacion; 

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

END IF;

END;

 
$function$
;


