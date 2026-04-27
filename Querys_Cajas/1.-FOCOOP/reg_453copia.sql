-- DROP FUNCTION public.reg_453();

CREATE OR REPLACE FUNCTION public.reg_453()
 RETURNS SETOF tipo_reg_453
 LANGUAGE plpgsql
AS $function$
DECLARE

  --p_delimitador    ALIAS FOR $1;
  fecha_inicial    date;
  fecha_Final      date;
  x_cuenta_castigo text;
  r                tipo_reg_453%rowtype;
  r_total          record;
  r_auxi           record;
  r_castigos       record;
  r_condonaciones  record;
  r_ogs_opa        record;
  r_entregar       record;
  r_final          record;
  registros        record;
  r_rec            record;
  fechita        varchar;
  x_monto        numeric;
  x_diferencia   numeric;

  x integer;

  px1 varchar;

  prod_cond_ordinarios integer;
  prod_cond_moratorios integer;
BEGIN

  select into fecha_final, fecha_inicial
              fecha, (01||to_char(fecha,'/mm/yyyy'))::date
  from (select distinct date(fechatrabajo) as fecha from origenes) as xyz;

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
    fecha              date,
    idorigen           integer,
    idgrupo            integer,
    idsocio            integer,
    idorigenp          integer,
    idproducto         integer,
    idauxiliar         integer,
    idorigenc          integer,
    periodo            varchar,
    idtipo             numeric,
    idpoliza           integer,
    monto              numeric,
    montoio            numeric,
    montoiva           numeric,
    montoim            numeric,
    montoivaim         numeric,
    saldoec            numeric,
    diasvencidos       integer,
    montovencido       numeric,
    monto_poliza       numeric,
    monto_real_castigo numeric);
  CREATE INDEX cast_ogs  ON castigos (idorigen,idgrupo,idsocio);
  CREATE INDEX cast_opa  ON castigos  (idorigenp,idproducto,idauxiliar);


  FOR r_castigos IN
    SELECT SUM(monto) as monto, idorigenc, periodo, idtipo, idpoliza from polizas_d
    WHERE idcuenta LIKE x_cuenta_castigo||'%' AND cargoabono = 0 AND periodo::integer = to_char(fecha_final,'yyyymm')::integer
    GROUP BY idorigenc, periodo, idtipo, idpoliza
  LOOP

     RAISE NOTICE 'idorigenc: %', r_castigos.idorigenc;
     RAISE NOTICE 'periodo: %', r_castigos.periodo;
     RAISE NOTICE 'idtipo: %', r_castigos.idtipo;
     RAISE NOTICE 'idpoliza: %', r_castigos.idpoliza;
     RAISE NOTICE 'monto de poliza: %', r_castigos.monto;

    --  x_contador := 0;
    --//Total de auxiliares por poliza
    SELECT INTO r_total
                SUM(monto) as monto, SUM(montoio) as montoio, SUM(montoim) as montoim, SUM(montoiva) as montoiva,
                SUM(montoivaim) as montoivaim, COUNT(*) as numero_registros, MAX(monto) as max_monto
    FROM v_auxiliares_d ad
         INNER JOIN productos pr USING(idproducto)
    WHERE ad.idorigenc = r_castigos.idorigenc AND ad.periodo = r_castigos.periodo AND ad.idtipo = r_castigos.idtipo AND
          ad.idpoliza = r_castigos.idpoliza AND ad.cargoabono = 1 AND pr.tipoproducto = 2 AND ad.saldoec = 0 AND
          ad.tipomov in (0,1);

    x_diferencia := r_total.monto - r_castigos.monto;

    RAISE NOTICE 'monto de auxiliares: %', r_total.monto;
    RAISE NOTICE 'monto con interes de auxiliares: %', (r_total.monto + r_total.montoio + r_total.montoim + r_total.montoiva + r_total.montoivaim);
    RAISE NOTICE 'Diferencia: %', x_diferencia;
    RAISE NOTICE '-----------';
    RAISE NOTICE 'monto_maximo: %', r_total.max_monto;

    FOR r_auxi IN
      SELECT date(ad.fecha) as fecha, a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,
             ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, ad.monto, ad.montoio, ad.montoiva, ad.montoim,
             ad.montoivaim, ad.saldoec, ad.diasvencidos, ad.montovencido
      FROM v_auxiliares_d ad
           INNER JOIN v_auxiliares a using(idorigenp,idproducto,idauxiliar)
           INNER JOIN productos pr USING(idproducto)
      WHERE ad.idorigenc = r_castigos.idorigenc AND ad.periodo = r_castigos.periodo AND ad.idtipo = r_castigos.idtipo AND
            ad.idpoliza = r_castigos.idpoliza AND ad.cargoabono = 1 AND pr.tipoproducto = 2 AND ad.saldoec = 0 AND
            ad.tipomov in (1,0)
      ORDER BY ad.monto desc

    LOOP
      --  x_contador := x_contador + 1;
      IF (r_castigos.monto = r_total.monto) THEN
        x_monto := r_auxi.monto; x_diferencia := 0;
      ELSIF (r_castigos.monto < r_total.monto AND x_diferencia > 0) THEN
           -- THEN x_monto := ROUND((r_auxi.monto - ((x_diferencia/r_total.monto)* r_auxi.monto)),2);
           x_monto := ROUND((r_auxi.monto - ((x_diferencia * r_auxi.monto)/r_total.monto)),2);
         ELSIF (r_castigos.monto = (r_total.monto + r_total.montoio)) THEN
              x_monto := (r_auxi.monto + r_auxi.montoio); x_diferencia := 0;
            ELSIF (r_castigos.monto = (r_total.monto + r_total.montoio + r_total.montoiva)) THEN
                 x_monto := (r_auxi.monto + r_auxi.montoio + r_auxi.montoiva); x_diferencia := 0;
               ELSIF (r_castigos.monto =
                      (r_total.monto + r_total.montoio + r_total.montoiva + r_total.montoim + r_total.montoivaim)) THEN
                  x_monto := (r_auxi.monto + r_auxi.montoio + r_auxi.montoiva + r_auxi.montoim + r_auxi.montoivaim); x_diferencia := 0;
              --// En caso de que el monto de la cuenta contable sea menor que el monto de auxiliares

       /* ELSIF (r_castigos.monto < r_total.monto AND x_diferencia > 0)
              THEN
                 raise notice 'monto de polizas es menor al monto total:' ;
                  IF (r_total.max_monto > (x_diferencia * 2))
                     THEN
                         IF (r_auxi.monto = r_total.max_monto)
                            THEN
                                x_monto := r_auxi.monto - x_diferencia;
                                x_diferencia := 0;
                         ELSE
                             x_monto := r_auxi.monto;
                         END IF;
                  ELSE
                      IF (x_diferencia >= r_auxi.monto)
                         THEN
                             x_monto := (r_auxi.monto/2);
                             x_diferencia = x_diferencia - x_monto;
                      ELSE
                          x_monto := (r_auxi.monto - x_diferencia);
                          x_diferencia = 0;
                      END IF;
                  END IF;*/

      ELSE
        x_monto := r_auxi.monto;
      END IF;

      RAISE NOTICE '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>< monto de auxiliares: %', r_auxi.monto;
      RAISE NOTICE '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>< monto: %', x_monto;
      RAISE NOTICE 'Diferencia: %', x_diferencia;
    


      INSERT INTO castigos VALUES
        (r_auxi.fecha,
         r_auxi.idorigen,
         r_auxi.idgrupo,
         r_auxi.idsocio,
         r_auxi.idorigenp,
         r_auxi.idproducto,
         r_auxi.idauxiliar,
         r_castigos.idorigenc,
         r_castigos.periodo,
         r_castigos.idtipo,
         r_castigos.idpoliza,
         ROUND(x_monto,2),
         r_auxi.monto,
         x_diferencia,
         0,
         0,
         r_auxi.saldoec,
         r_auxi.diasvencidos,
         r_auxi.montovencido,
         r_castigos.monto,
         0.0);
    END LOOP;
  END LOOP;
    
  /*FIN DE fsdff*/
  CREATE INDEX castigos_ogs  ON castigos (idorigen,idgrupo,idsocio);
  CREATE INDEX castigos_opa  ON castigos  (idorigenp,idproducto,idauxiliar);

  -- EN EL CAMPO monto DE LA TABLA ANTERIOR ESTA CUANTO SE CASTIGO REALMENTE A
  -- CADA PRESTAMO, SIN CONSIDERAR RETIROS DE AHORROS U OTROS FOLIOS DE
  -- CAPTACION DEL SOCIO
  for r_castigos in
    select distinct idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar, sum(monto) as monto_c
    from castigos
    group by idorigen, idgrupo, idsocio, idorigenp, idproducto, idauxiliar
  loop
    update castigos set monto_real_castigo = r_castigos.monto_c
    where idorigen = r_castigos.idorigen and idgrupo = r_castigos.idgrupo and idsocio = r_castigos.idsocio and
          idorigenp = r_castigos.idorigenp and idproducto = r_castigos.idproducto and idauxiliar = r_castigos.idauxiliar;
  end loop;

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::   FIN   DE TABLA TEMPORAL CASTIGOS  :::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::CREACION DE TABLA TEMPORAL PRESTAMOS_CONDONACIONES :::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

drop table if exists prestamos_condonaciones;
create temp table prestamos_condonaciones (
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
  transaccion   integer,
  montoivaim    numeric(12,2),
  efectivo      numeric(12,2),
  diasvencidos  integer,
  montovencido  numeric(12,2),
  ticket        integer,
  montoidnc     numeric(12,2),
  montoieco     numeric(12,2),
  montoidncm    numeric(12,2)
);

CREATE INDEX cond_ogs ON prestamos_condonaciones (idorigen,idgrupo,idsocio);
CREATE INDEX cond_opa ON prestamos_condonaciones (idorigenp,idproducto,idauxiliar);

 
for r_condonaciones in
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad.monto,
              ad.montoio,ad.montoim,ad.montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm
        from  auxiliares_d ad
              inner join v_auxiliares a using (idorigenp,idproducto,idauxiliar)
            --  inner join castigos using (idorigenp,idproducto,idauxiliar)
       where ad.tipomov = 3 and ad.idorigenp > 0 and
             ad.idproducto in (select idproducto from productos where tipoproducto = 2) and ad.idauxiliar > 0 and
             date(ad.fecha) between fecha_inicial and fecha_final
            /* (a.idorigenp,a.idproducto,a.idauxiliar) in
             (select distinct idorigenp,idproducto,idauxiliar from castigos) */
    union
       select a.idorigen,a.idgrupo,a.idsocio,ad.idorigenp,ad.idproducto,ad.idauxiliar, ad.fecha::date,ad.cargoabono,ad.monto,
              ad.montoio,ad.montoim,ad.montoiva,ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.tipomov,ad.saldoec,ad.transaccion,
              ad.montoivaim ,ad.efectivo,ad.diasvencidos,ad.montovencido,ad.ticket ,ad.montoidnc,ad.montoieco,ad.montoidncm
        from  auxiliares_d_h ad
              inner join v_auxiliares a using (idorigenp,idproducto,idauxiliar)
             -- inner join castigos using (idorigenp,idproducto,idauxiliar)
       where ad.tipomov = 3 and ad.idorigenp > 0 and
             ad.idproducto in (select idproducto from productos where tipoproducto = 2) and ad.idauxiliar > 0 and
             date(ad.fecha) between fecha_inicial and fecha_final
          


loop

    insert into prestamos_condonaciones values
    (r_condonaciones.idorigen,
     r_condonaciones.idgrupo,
     r_condonaciones.idsocio,
     r_condonaciones.idorigenp,
     r_condonaciones.idproducto,
     r_condonaciones.idauxiliar,
     r_condonaciones.fecha,
     r_condonaciones.cargoabono,
     r_condonaciones.monto,
     r_condonaciones.montoio,
     r_condonaciones.montoim,
     r_condonaciones.montoiva,
     r_condonaciones.idorigenc,
     r_condonaciones.periodo,
     r_condonaciones.idtipo,
     r_condonaciones.idpoliza,
     r_condonaciones.tipomov,
     r_condonaciones.saldoec,
     r_condonaciones.transaccion,
     r_condonaciones.montoivaim,
     r_condonaciones.efectivo,
     r_condonaciones.diasvencidos,
     r_condonaciones.montovencido,
     r_condonaciones.ticket,
     r_condonaciones.montoidnc,
     r_condonaciones.montoieco,
     r_condonaciones.montoidncm);
   

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
 idauxiliar    integer);
CREATE INDEX general_ogs ON ogs_opa (idorigen,idgrupo,idsocio);
CREATE INDEX general_opa ON ogs_opa (idorigenp,idproducto,idauxiliar);

for r_ogs_opa in /*=========*/

   /*  select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
       from (select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
               from castigos
              where idproducto in(select idproducto from productos where tipoproducto=2)
      union
             select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
               from prestamos_condonaciones ) as a
*/
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from castigos
    where idproducto in (select idproducto from productos where tipoproducto = 2)
    
    union all
    
    select distinct idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar
    from prestamos_condonaciones
    where idproducto in (select idproducto from productos where tipoproducto = 2)


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
 numerosocio                     text,
 per_jur                         numeric,
 nombre                          text,
 appaterno                       text,
 apmaterno                       text,
 rfc                             text,
 curp                            character varying(18),
 genero                           numeric,
 idorigenp                       integer,
 idproducto                      integer,
 idauxiliar                      integer,
 sucursal                        character varying(50),
 clasificacioncredito            text,
 productocredito                 text,
 fechaotorgamiento               date,
 montooriginal                   numeric(16,2),
 diasmora                        integer,
 saldoinsolutocapital            numeric(12,2),
 interesesvencidos               numeric(16,2),
 montoim                         numeric(16,2),
 interesesrefinanciados          text,
 monto_castigo                   numeric(16,2),
 montocondonacion_quita_bonificacion               numeric(16,2),
 fechacastigo                    text,
 personarelacionada              numeric,
 montodeestimacionespreventivas  numeric(16,2),
 montodegarantialiquida          numeric(16,2),
 fecha_sic                       text,
 tipocobranza                    text);
-- CREATE INDEX final_ogs  ON final (idorigen,idgrupo,idsocio);
CREATE INDEX final_opa  ON final (idorigenp,idproducto,idauxiliar);



for r_final in
select distinct (TRIM(TO_CHAR(gen.idorigen,'09999999999999'))||trim(to_char(gen.idgrupo,'09'))||
       TRIM(TO_CHAR(gen.idsocio,'099999'))) AS NumeroSocio,
       (case when p.razon_social is null or p.razon_social='' then 1 else 2 end) as per_jur,
       (case when p.razon_social !='' then '0' else upper(p.appaterno) end)as appaterno,
       (case when p.razon_social !='' then 'NO APLICA' else upper(p.apmaterno) end)as apmaterno,
       upper(p.nombre) as nombre, p.rfc,
       (case WHEN p.sexo =1 then '2' when p.sexo=2 then '1' else '0' end)::numeric as genero,
       trim(case when p.curp is not null then p.curp else '0' end) as Curp,
       gen.idorigenp,gen.idproducto,gen.idauxiliar,gen.idorigenp::varchar,
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

-- (SELECT upper(REPLACE(pr.nombre,'-',' ')))
     (select clave_regularorio from claves_regulatorios_productos cvr where cvr.idproducto=pr.idproducto limit 1)
     as ProductoCredito,
     (select to_char(au.fechaactivacion,'yyyy-mm-dd') from v_auxiliares au
      where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Fechaotorgamiento,
     (select au.montoprestado from v_auxiliares au
      where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as MontoOriginal,

     (case when (select max(au.diasvencidos) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) is NULL
           then (select max(au.diasvencidos) from castigos au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1)
           else (select max(au.diasvencidos) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1)
      end) as Diasmora,

   (select monto from v_auxiliares_d ad 
    where ad.idorigenp=gen.idorigenp and ad.idproducto=gen.idproducto and ad.idauxiliar=gen.idauxiliar 
    order by ad.fecha desc limit 1) as capital,

/*     (select cst.monto_real_castigo from castigos cst
      where (cst.idorigen,cst.idgrupo,cst.idsocio,cst.idorigenp,cst.idproducto,cst.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
      order by cst.idorigen, cst.idgrupo, cst.idsocio, cst.idorigenp, cst.idproducto, cst.idauxiliar limit 1) as capital,*/

-- (select max(au.montoidnc) from prestamos_condonaciones au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as intereses_ordinarios,
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
     end) as intereses_ordinarios,
---------dfsfjdlsjfsdlkfjsdkfjdslkf---
-- (select max(au.montoim) from prestamos_condonaciones au where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar)=(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as intereses_moratorios,
     (case when ((select sum(au.montoim) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)) -
                coalesce(
                (select sum(monto) from prestamos_recuperaciones pc
                 where pc.idorigen = gen.idorigen and pc.idgrupo = gen.idgrupo and pc.idsocio = gen.idsocio and idorigenp > 0 and
                       pc.idproducto = prod_cond_moratorios and pc.idauxiliar > 0 and
                       date(pc.fecha) >
                       (select au.fecha from prestamos_condonaciones au
                        where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                              (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
                        order by au.fecha asc limit 1)),0.0) ) < 0
          then 0.0
          else ((select sum(au.montoim) from prestamos_condonaciones au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)) -
                coalesce(
                (select sum(monto) from prestamos_recuperaciones pc
                 where pc.idorigen = gen.idorigen and pc.idgrupo = gen.idgrupo and pc.idsocio = gen.idsocio and idorigenp > 0 and
                       pc.idproducto = prod_cond_moratorios and pc.idauxiliar > 0 and
                       date(pc.fecha) >
                       (select au.fecha from prestamos_condonaciones au
                        where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                              (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
                        order by au.fecha asc limit 1)),0.0) )
     end) as intereses_moratorios,

     '0' as Interesesrefinanciados,

   (select monto from v_auxiliares_d ad 
    where ad.idorigenp=gen.idorigenp and ad.idproducto=gen.idproducto and ad.idauxiliar=gen.idauxiliar 
    order by ad.fecha desc limit 1) as Monto_castigo,

/*     (select cst.monto_real_castigo from castigos cst
      where (cst.idorigen,cst.idgrupo,cst.idsocio,cst.idorigenp,cst.idproducto,cst.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
      order by cst.idorigen, cst.idgrupo, cst.idsocio, cst.idorigenp, cst.idproducto, cst.idauxiliar limit 1) as Monto_castigo,*/

     (select sum(au.montoio+au.montoim) from prestamos_condonaciones au
      where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as Montocondonacion,

/* to_char((select fecha from castigos c2 where
(c2.idorigen,c2.idgrupo,c2.idsocio,c2.idorigenp,c2.idproducto,c2.idauxiliar)=
(gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar )),'yyyymmdd')*/
(select to_char(fechauma,'YYYY-MM-DD') from v_auxiliares va where va.idorigenp=gen.idorigenp and va.idproducto=gen.idproducto and va.idauxiliar=gen.idauxiliar)as fechacastigo,----------------------------------------Fecha de castigo

 (case when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor,
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=2 then 9
          when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor,
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=3 then 10
           when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor,
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=4 then 11
           when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor,
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas') s
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=5 then 12
             when (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
               in (SELECT re.idorigen,re.idgrupo,re.idsocio,
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
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
                          TRIM(SAI_TOKEN(2, referencia, '|'))::integer idorigenpr,
                          TRIM(SAI_TOKEN(3, referencia, '|'))::integer idproductor,
                          TRIM(SAI_TOKEN(4, referencia, '|'))::integer idauxiliarr
                     FROM referencias re
               inner join (select * from sopar where tipo like 'personas_relacionadas2') s
               on(re.idorigenr,re.idgrupor,re.idsocior )=(s.idorigen,s.idgrupo,s.idsocio )
            where tiporeferencia=8) and s.puesto=7 then 14
            when  s.puesto is not null then s.puesto
            when  seis.refe is not null then seis.refe  else 1 end )  as personarelacionada,------------Personas Relacionadas
/*
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
*/

      case when(select cst.monto_real_castigo from castigos cst
      where (cst.idorigen,cst.idgrupo,cst.idsocio,cst.idorigenp,cst.idproducto,cst.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
      order by cst.idorigen, cst.idgrupo, cst.idsocio, cst.idorigenp, cst.idproducto, cst.idauxiliar limit 1)>0
            then  
            (select cst.monto_real_castigo from castigos cst
      where (cst.idorigen,cst.idgrupo,cst.idsocio,cst.idorigenp,cst.idproducto,cst.idauxiliar) =
            (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar)
      order by cst.idorigen, cst.idgrupo, cst.idsocio, cst.idorigenp, cst.idproducto, cst.idauxiliar limit 1)
          else r_condonaciones.monto end as montodeestimacionespreventivas,

/*(select sum(c.monto) from castigos c where (c.idorigen,c.idgrupo,c.idsocio)=(gen.idorigen,gen.idgrupo,gen.idsocio ) and c.idproducto in(select idproducto from productos where tipoproducto in (0,1,8)))*/
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
LEFT JOIN (SELECT  re.idorigen,re.idgrupo,re.idsocio,re.idorigenr ,re.idgrupor ,re.idsocior,
                   (CASE WHEN re.tiporeferencia in (0, 1, 7, 14, 15,24,25) then 6 END) as refe
             FROM sopar s inner join  referencias re
            on(re.idorigenr,re.idgrupor,re.idsocior)=(s.idorigen,s.idgrupo,s.idsocio)
            where tipo = 'personas_relacionadas' and tiporeferencia in(0, 1, 7, 14, 15,24,25))seis
           ON (seis.idorigen,seis.idgrupo,seis.idsocio)=(gen.idorigen,gen.idgrupo,gen.idsocio)
inner join productos pr using(idproducto)
order by NumeroSocio  loop

IF(r_final.montocondonacion >0)
THEN
insert into final values(
 r_final.numerosocio,
 r_final.per_jur,
 r_final.nombre,
 r_final.appaterno,
 r_final.apmaterno,
r_final.rfc,
 r_final.curp,
 r_final.genero,
 r_final.idorigenp,
 r_final.idproducto,
 r_final.idauxiliar,
 r_final.sucursal,
 r_final.clasificacioncredito,
 r_final.productocredito,
 r_final.fechaotorgamiento::date,
 r_final.montooriginal,
 r_final.diasmora,
 r_final.capital,
 r_final.intereses_ordinarios,
 r_final.intereses_moratorios,
 r_final.interesesrefinanciados,
 r_final.monto_castigo,
 r_final.montocondonacion,
 r_final.fechacastigo,
 (case when r_final.personarelacionada is null then 0 else r_final.personarelacionada end ),
 r_final.montodeestimacionespreventivas,
 r_final.montodegarantialiquida,
 r_final.fecha_sic,
 r_final.tipocobranza  );
END IF;
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
 numerosocio                            text,
per_jur                                 numeric,
 nombre                                 text,
 appaterno                              text,
apmaterno                               text,
rfc                                     text,
 curp                                   character varying(18),
genero                                  numeric,
numerocredito                          text,
sucursal                               integer,
clasificacioncredito                   text,
productocredito                        text,
fechaotorgamiento                      text,
fecha_vencimiento                      text,
modalidad_pago                         numeric,
montooriginal                          text,
fecha_ultimo_pago_capital              text,
monto_ultimo_pago_capital              text,
fecha_de_ultimo_pago_interes           text,
monto_ultimo_pago_interes              text,
fecha_primera_amortizacion_no_cubierta text,
diasmora                               text,
tipocredito                            varchar(2),
saldoinsolutocapital                   text,
interesesvencidos                      text,
montoim                                text,
interesesrefinanciados                 text,
monto_castigo                          text,
montocondonacion_quita_bonificacion    text,

fechacastigo                           text,
personarelacionada                     text,
montodeestimacionespreventivas         text,
claveprevencion                        integer,
fecha_sic                              text,
tipocobranza                           text,
montodegarantialiquida                 text,
montodegarantiahipotecaria             text
);

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
 (TRIM(TO_CHAR(f.idorigenp,'099999999'))||trim(to_char(f.idproducto,'09999'))||TRIM(TO_CHAR(f.idauxiliar,'09999999'))) AS NumeroCredito,
 f.sucursal,
 f.clasificacioncredito,
 f.productocredito,
 f.fechaotorgamiento,







/*
coalesce((case when (select vcred.fechacierre from v_balancecred vcred  where vcred.idorigenp=a.idorigenp and vcred.idproducto=a.idproducto and vcred.idauxiliar=a.idauxiliar and vcred.cartera='V' and vcred.carteraant != 'V' order by vcred.fechacierre desc limit 1) is not null

then
(select to_char(vcred.fechacierre,'yyyymmdd') from v_balancecred vcred  where vcred.idorigenp=a.idorigenp and vcred.idproducto=a.idproducto and vcred.idauxiliar=a.idauxiliar and vcred.cartera='V' and vcred.carteraant != 'V' order by vcred.fechacierre desc limit 1)::numeric
else(
(case when (select to_char(vcred.fechacierre,'yyyymmdd') from v_balancecred vcred  where vcred.idorigenp=a.idorigenp and vcred.idproducto=a.idproducto and vcred.idauxiliar=a.idauxiliar order by vcred.fechacierre limit 1)::numeric
>
(select to_char(am.vence,'yyyymmdd') from v_amortizaciones am where am.idorigenp=a.idorigenp and am.idproducto=a.idproducto and am.idauxiliar=a.idauxiliar order by am.vence desc limit 1)::numeric

then
(select to_char(vcred.fechacierre,'yyyymmdd') from v_balancecred vcred  where vcred.idorigenp=a.idorigenp and vcred.idproducto=a.idproducto and vcred.idauxiliar=a.idauxiliar order by vcred.fechacierre limit 1)::numeric

else
*/
coalesce((select to_char(am.vence,'yyyy-mm-dd') from v_amortizaciones am where am.idorigenp=a.idorigenp and am.idproducto=a.idproducto and am.idauxiliar=a.idauxiliar order by am.vence desc limit 1)::text, '9999-12-31') /*Termina mi else*/

-- end),'19000101')
 as fecha_vencimiento,




  (CASE WHEN a.plazo=1  THEN 1
        ELSE 3 END)as Modalidad_pago,--------------------Modalidad de pago

  f.montooriginal,

/*  COALESCE((select am.vence from v_amortizaciones am where am.abonopag>0 and am.idorigenp=a.idorigenp and am.idproducto=a.idproducto and      am.idauxiliar=a.idauxiliar order by am.vence desc limit 1 )*/
COALESCE(
(case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select date(ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<=date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1)else
  (select date (ad.fecha) from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)<date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end),'9999-12-31')
  fecha_ultimo_pago_capital,


/*
 (case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto > 0 and date(ad.fecha)< f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) else
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto > 0 and date(ad.fecha) < f.fechacastigo
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end ) as
  monto_ultimo_pago_capital,*/


/**/
(case when  f.monto_castigo=0 or  f.monto_castigo is null then
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) else
  (select ad.monto from v_auxiliares_d ad  where ad.cargoabono=1 and ad.monto>0 and date(ad.fecha) < date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) end )as
  monto_ultimo_pago_capital,



   COALESCE((select date(max(ad.fecha)) from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar)),'9999-12-31')fecha_de_ultimo_pago_interes,

/*
  COALESCE((select am.vence from v_amortizaciones am where am.abonopag>0 and am.idorigenp=a.idorigenp and am.idproducto=a.idproducto and      am.idauxiliar=a.idauxiliar order by am.vence desc limit 1 ),'19000101')fecha_de_ultimo_pago_interes,*/
 (select ad.montoio + ad.montoim from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1)as Monto_ultimo_pago_interes,

/*
  (select ad.montoio + ad.montoim from v_auxiliares_d ad  where ad.cargoabono=1 and date(ad.fecha)< date(f.fechacastigo)
  and (ad.idorigenp,ad.idproducto,ad.idauxiliar)=(f.idorigenp,f.idproducto,f.idauxiliar) order by ad.fecha desc limit 1) Monto_ultimo_pago_interes,*/

coalesce(trim(to_char((select am.vence from amortizaciones_h am where am.idorigenp=f.idorigenp and am.idproducto = f.idproducto
AND am.idauxiliar = f.idauxiliar and am.diasvencidos>0
union
select am.vence from amortizaciones am where am.idorigenp=f.idorigenp and am.idproducto = f.idproducto
AND am.idauxiliar = f.idauxiliar  and am.diasvencidos>0
order by  vence limit 1),'yyyy-mm-dd')),'9999-12-31') as fecha_primera_amortizacion_no_cubierta,-------Primera Amortizacion no cubierta
  (case when a.tipoprestamo=0 then 1 when a.tipoprestamo in(1,3) then 2 when a.tipoprestamo in(2,4) then 3 end)::numeric as tipocredito,-----Tipo de Credito
 f.diasmora,
 f.saldoinsolutocapital,
 f.interesesvencidos,
 f.montoim,
 f.interesesrefinanciados,
 f.monto_castigo,
 f.montocondonacion_quita_bonificacion,
 f.fechacastigo,
 f.personarelacionada,
 f.montodeestimacionespreventivas,
 f.montodeGarantiaLiquida,
 10009 as clave,----Clave



/*

 COALESCE(TO_CHAR((select rb.fecha from revision_buro rb where ((TRIM(TO_CHAR(rb.idorigen,'099999'))||rb.idgrupo||
       TRIM(TO_CHAR(rb.idsocio,'09999999'))))=
                  (f.numerosocio) and rb.fecha<= f.fechaotorgamiento order by fecha desc limit 1),'YYYYMMDD')::INTEGER,0) 
as fecha_sic,



(case when (select br.fecha from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio and
                    br.idorigenp=a.idorigenp and br.idproducto=a.idproducto and br.idauxiliar=a.idauxiliar ORDER BY br.fecha desc limit 1 ) is not null
             then (select trim(to_char(br.fecha,'YYYYMMDD')) from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio and
                    br.idorigenp=a.idorigenp and br.idproducto=a.idproducto and br.idauxiliar=a.idauxiliar ORDER BY br.fecha desc limit 1)
        when (select br.fecha from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio and a.fechaactivacion
              between a.fechaactivacion-30 and a.fechaactivacion ORDER BY br.fecha desc limit 1) is not null
             then (select trim(to_char(br.fecha,'YYYYMMDD')) from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio and a.fechaactivacion
              between a.fechaactivacion-30 and a.fechaactivacion ORDER BY br.fecha desc limit 1)
        when ((select dato1 from tablas where  idelemento=(select  distinct to_char(date(date(fechatrabajo)-'1 MONTH'::interval)::date,'YYYYMM') from origenes))::numeric * 1000) >= a.montoprestado
             then '00000002'
        when (a.garantia=a.saldo)then '00000003'

        when(select dato5 from tablas where idtabla='param' and idelemento='reporte_regulatorios') is not null and
              (select trim(to_char(date(dato5),'YYYYMMDD')) from tablas where idtabla='param' and idelemento='reporte_regulatorios')::numeric > trim(to_char(a.fechaactivacion,'YYYYMMDD'))::numeric
              then '00000005'

             else '00000000' end)as fecha_sic,---------------------------------------------------------------------Fecha de consulta a la sic

COALESCE(TO_CHAR((select rb.fecha from revision_buro rb where rb.idorigen=a.idorigen and rb.idgrupo=a.idgrupo and rb.idsocio=a.idsocio LIMIT 1),'YYYYMMDD')::INTEGER,0)as fecha_sic,
*/

case when((select br.fecha from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio order by br.fecha desc limit 1) <= date(date(a.fechaactivacion)-'30 day'::interval)
and (select br.fecha from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio order by br.fecha desc limit 1) >= a.fechaactivacion)
then
(select trim(to_char(br.fecha,'YYYY-MM-DD')) from revision_buro br where br.idorigen=a.idorigen and br.idgrupo=a.idgrupo and br.idsocio=a.idsocio order by br.fecha desc limit 1)

else '9999-12-31' end as fecha_sic,

f.tipocobranza


from final f inner join v_auxiliares a using(idorigenp,idproducto,idauxiliar)
loop


insert into castigos_cnbv_reporte values(
'0453',
r_entregar.numerosocio,
r_entregar.per_jur,
r_entregar.nombre,
r_entregar.appaterno,
(case when r_entregar.apmaterno is null then 'ND' else r_entregar.apmaterno end),
r_entregar.rfc,
 r_entregar. curp,
 r_entregar.genero,
r_entregar.numerocredito,
 r_entregar.sucursal::integer,
 r_entregar.clasificacioncredito,
 r_entregar.productocredito,
 to_char(r_entregar.fechaotorgamiento,'yyyy-mm-dd'),
 r_entregar.fecha_vencimiento,
 r_entregar.modalidad_pago,

 trim(to_char(round(r_entregar.montooriginal),'099999999999999999.99')),
 to_char(r_entregar.fecha_ultimo_pago_capital ,'yyyy-mm-dd')::text,
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')) is null then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_capital),'099999999999999999.99')end),
 (case when to_char(r_entregar.fecha_de_ultimo_pago_interes,'yyyy-mm-dd') IS NULL then '00000000' else to_char(r_entregar.fecha_de_ultimo_pago_interes,'yyyy-mm-dd') end),
 (case when trim(to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99'))IS NULL then '000000000000000000000' else to_char(round(r_entregar.monto_ultimo_pago_interes),'099999999999999999.99') end),
 r_entregar.fecha_primera_amortizacion_no_cubierta,
 trim(to_char(r_entregar.diasmora::numeric ,'000999')),
 trim(to_char(r_entregar.tipocredito,'09')),
  (case when trim(to_char(round(r_entregar.saldoinsolutocapital),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.saldoinsolutocapital,'099999999999999999.99')) end),
  (case when  trim(to_char(round(r_entregar.interesesvencidos),'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.interesesvencidos,'099999999999999999.99')) end),
  (case when  trim(to_char(round(r_entregar.montoim),'099999999999999999.99'))is null then '000000000000000000000' else trim(to_char(r_entregar.montoim,'099999999999999999.99')) end),
               trim(to_char(r_entregar.interesesrefinanciados::numeric,'099999999999999999.99')),
  (case when trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.monto_castigo,'099999999999999999.99')) end),
 (case when  trim(to_char(r_entregar.montocondonacion_quita_bonificacion,'099999999999999999.99')) is null then '000000000000000000000' else trim(to_char(r_entregar.montocondonacion_quita_bonificacion,'099999999999999999.99')) end),
 ---'000000000'--bonifacion tenia cero


 (case when r_entregar.fechacastigo IS NOT NULL then r_entregar.fechacastigo ELSE '00000000' END),



 trim(to_char(r_entregar.personarelacionada,'09')),


/* (case when (round(r_entregar.montodeestimacionespreventivas*-1))::text like '-%'
            then trim(to_char(round(r_entregar.montodeestimacionespreventivas*-1),'099999999999999999.99'))
           else trim(to_char(round(r_entregar.montodeestimacionespreventivas*-1),'099999999999999999.99'))end), */


/*-------------------------------------------------------[se cambio operacion *-1]----------------------------------------------------------*/
 (case when (select sai_findstr(((r_entregar.montodeestimacionespreventivas + r_entregar.montoim )/**-1*/)::text,'-'))>0
  then
  trim(to_char((r_entregar.montodeestimacionespreventivas + r_entregar.montoim )/**-1*/,'09999999999999999.99'))
  else trim(to_char((r_entregar.montodeestimacionespreventivas + r_entregar.montoim )/**-1*/,'099999999999999999.99')) end),



r_entregar.clave,
r_entregar.fecha_sic,
 r_entregar.tipocobranza,
 (case when r_entregar.montodegarantialiquida is null then '000000000000000000.00' else trim(to_char(r_entregar.montodegarantialiquida,'099999999999999999.99')) end),
 '000000000000000000.00'
);
end loop;
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::FIN DE TABLA TEMPORAL ENTREGAR ::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

RAISE NOTICE  '|DATOS_REPORTE_COMPROBACION|SUBREPORTE;IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD;PERSONALIDAD JURIDICA;NOMBRE;PRIMER APELLIDO DEL SOCIO;SEGUNDO APELLIDO DEL SOCIO;RFC DEL ACREDITADO;CURP DEL ACREDITADO;GENERO DEL SOCIO O CLIENTE;IDENTIFICADOR DEL CREDITO ASIGNADO POR LA SOCIEDAD;SUCURSAL QUE OPERA EL CREDITO;CLASIFICACION DEL CREDITO POR DESTINO;PRODUCTO DE CREDITO;FECHA DE DISPOSICION DEL CREDITO;FECHA DE VENCIMIENTO DEL CREDITO;MODALIDAD DE PAGO;MONTO ORIGINAL DEL CREDITO;FECHA DEL ULTIMO PAGO A CAPITAL;MONTO DEL ULTIMO PAGO DE CAPITAL;FECHA DEL ULTIMO PAGO DE INTERESES;MONTO DEL ULTIMO PAGO DE INTERESES;FECHA DE LA PRIMERA AMORTIZACION NO CUBIERTA;DIAS DE MORA;TIPO DE CREDITO;CAPITAL;INTERESES ORDINARIOS;INTERESES MORATORIOS;INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS;MONTO DEL CASTIGO;MONTO DE LA CONDONACION QUITA;FECHA DE CASTIGO;TIPO DE ACREDITADO RELACIONADO;ESTIMACIONES PREVENTIVAS TOTALES;CLAVE DE PREVENCION;FECHA DE CONSULTA A LA SIC;TIPO DE COBRANZA;GARANTIA LIQUIDA;GARANTIA HIPOTECARIA';

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
 r.fecha_primera_amortizacion_no_cubierta :=registros.fecha_primera_amortizacion_no_cubierta;
 r.diasmora                               :=registros.diasmora;
 r.tipocredito                            :=registros.tipocredito;
 r.saldoinsolutocapital                   :=registros.saldoinsolutocapital;
 r.interesesvencidos                      :=registros.interesesvencidos;
 r.montoim                                :=registros.montoim;
 r.interesesrefinanciados                 :=registros.interesesrefinanciados;
 r.monto_castigo                          :=registros.monto_castigo;
 r.montocondonacion_quita_bonificacion    :=registros.montocondonacion_quita_bonificacion;
 r.fechacastigo                           :=registros.fechacastigo;
 r.personarelacionada                     :=registros.personarelacionada;
 r.montodeestimacionespreventivas         :=registros.montodeestimacionespreventivas;
 r.claveprevencion                        :=registros.claveprevencion;
 r.fecha_sic                              :=registros.fecha_sic ;
 r.tipocobranza                           :=registros.tipocobranza ;
 r.montodegarantialiquida                 :=registros.montodegarantialiquida;
 r.montodegarantiahipotecaria             :=registros.montodegarantiahipotecaria;

return next r;



                RAISE NOTICE'|DATOS_REPORTE|%',     coalesce(registros.clave_subreporte::text,'')
                                                  ||';'||coalesce(registros.numerosocio::text,'')
                                                  ||';'||coalesce(registros.per_jur::text,'')
                                                  ||';'||coalesce(registros.nombre,'')
                                                  ||';'||coalesce(registros.appaterno,'')
                                                  ||';'||coalesce(registros.apmaterno,'')
                                                  ||';'||coalesce(registros.rfc,'')
                                                  ||';'||coalesce(registros.curp,'')
                                                  ||';'||coalesce(registros.genero::text,'')
                                                  ||';'||coalesce(registros.numerocredito::text,'')
                                                  ||';'||coalesce(registros.sucursal::text,'')
                                                  ||';'||coalesce(registros.clasificacioncredito::text,'')
                                                  ||';'||coalesce(registros.productocredito,'')
                                                  ||';'||coalesce(registros.fechaotorgamiento::text,'')
                                                  ||';'||coalesce(registros.fecha_vencimiento::text,'')
                                                  ||';'||coalesce(registros.modalidad_pago::text,'')
                                                  ||';'||coalesce(registros.montooriginal::text,'')
                                                  ||';'||coalesce(registros.fecha_ultimo_pago_capital::text,'')
                                                  ||';'||coalesce(registros.monto_ultimo_pago_capital::text,'')
                                                  ||';'||coalesce(registros.fecha_de_ultimo_pago_interes::text,'')
                                                  ||';'||coalesce(registros.monto_ultimo_pago_interes::text,'')
                                                  ||';'||coalesce(registros.fecha_primera_amortizacion_no_cubierta::text,'')
                                                  ||';'||coalesce(registros.diasmora::text,'')
                                                  ||';'||coalesce(registros.tipocredito,'')
                                                  ||';'||coalesce(registros.saldoinsolutocapital::text,'')
                                                  ||';'||coalesce(registros.interesesvencidos::text,'')
                                                  ||';'||coalesce(registros.montoim::text,'')
                                                  ||';'||coalesce(registros.interesesrefinanciados::text,'')
                                                  ||';'||coalesce(registros.monto_castigo::text,'')
                                                  ||';'||coalesce(registros.montocondonacion_quita_bonificacion::text,'')
                                                  ||';'||coalesce(registros.fechacastigo::text,'')
                                                  ||';'||coalesce(registros.personarelacionada::text,'')
                                                  ||';'||coalesce(registros.Montodeestimacionespreventivas::text,'')
                                                  ||';'||coalesce(registros.claveprevencion::text,'')
                                                  ||';'||coalesce(registros.fecha_sic::text,'')
                                                  ||';'||coalesce(registros.tipocobranza::text,'')
                                                  ||';'||coalesce(registros.montodegarantialiquida::text,'')
                                                  ||';'||coalesce(registros.montodegarantiahipotecaria::text,'');


                RAISE NOTICE'|DATOS_REPORTE_COMPROBACION|%',coalesce(registros.clave_subreporte::text,'')
                                                  ||';'||coalesce(registros.numerosocio::text,'')
                                                  ||';'||coalesce(registros.per_jur::text,'')
                                                  ||';'||coalesce(registros.nombre,'')
                                                  ||';'||coalesce(registros.appaterno,'')
                                                  ||';'||coalesce(registros.apmaterno,'')
                                                  ||';'||coalesce(registros.rfc,'')
                                                  ||';'||coalesce(registros.curp,'')
                                                  ||';'||coalesce(registros.genero::text,'')
                                                  ||';'||coalesce(registros.numerocredito::text,'')
                                                  ||';'||coalesce(registros.sucursal::text,'')
                                                  ||';'||coalesce(registros.clasificacioncredito::text,'')
                                                  ||';'||coalesce(registros.productocredito,'')
                                                  ||';'||coalesce(registros.fechaotorgamiento::text,'')
                                                  ||';'||coalesce(registros.fecha_vencimiento::text,'')
                                                  ||';'||coalesce(registros.modalidad_pago::text,'')
                                                  ||';'||coalesce(registros.montooriginal::text,'')
                                                  ||';'||coalesce(registros.fecha_ultimo_pago_capital::text,'')
                                                  ||';'||coalesce(registros.monto_ultimo_pago_capital::text,'')
                                                  ||';'||coalesce(registros.fecha_de_ultimo_pago_interes::text,'')
                                                  ||';'||coalesce(registros.monto_ultimo_pago_interes::text,'')
                                                  ||';'||coalesce(registros.fecha_primera_amortizacion_no_cubierta::text,'')
                                                  ||';'||coalesce(registros.diasmora::text,'')
                                                  ||';'||coalesce(registros.tipocredito,'')
                                                  ||';'||coalesce(registros.saldoinsolutocapital::text,'')
                                                  ||';'||coalesce(registros.interesesvencidos::text,'')
                                                  ||';'||coalesce(registros.montoim::text,'')
                                                  ||';'||coalesce(registros.interesesrefinanciados::text,'')
                                                  ||';'||coalesce(registros.monto_castigo::text,'')
                                                  ||';'||coalesce(registros.montocondonacion_quita_bonificacion::text,'')
                                                  ||';'||coalesce(registros.fechacastigo::text,'')
                                                  ||';'||coalesce(registros.personarelacionada::text,'')
                                                  ||';'||coalesce(registros.Montodeestimacionespreventivas::text,'')
                                                  ||';'||coalesce(registros.claveprevencion::text,'')
                                                  ||';'||coalesce(registros.fecha_sic::text,'')
                                                  ||';'||coalesce(registros.tipocobranza::text,'')
                                                  ||';'||coalesce(registros.montodegarantialiquida::text,'')
                                                  ||';'||coalesce(registros.montodegarantiahipotecaria::text,'');
end loop;


select into fechita to_char(CURRENT_DATE,'dd|mm|yyyy');

  execute 'copy (select * from castigos_cnbv_reporte) to ''/tmp/reg_453_cuentas_con_encabezados_'||fechita||'.csv'' with csv HEADER DELIMITER '';'' NULL '' '' ';
  execute 'copy (select * from castigos_cnbv_reporte) to ''/tmp/reg_453_cuentas_sin_encabezados_'||fechita||'.csv'' with csv DELIMITER '';''  ';

END IF;

END;

$function$
;
