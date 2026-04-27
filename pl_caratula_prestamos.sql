CREATE OR REPLACE FUNCTION sai_caratula_prestamos (INTEGER, INTEGER, INTEGER)
RETURNS TEXT AS $$
begin
  return sai_caratula_prestamos ($1, $2, $3, 0);
end;
$$ language 'plpgsql';



  -------------------------------------------------------------
  ------------SOCIOS GRUPALES TEOCELO IDPRODUCTO 30202--------
  -------------------------------------------------------------




DROP TYPE IF EXISTS tipo_sai_gpo_socios CASCADE;
CREATE TYPE tipo_sai_gpo_socios AS (
ogs                varchar,
nombre             varchar,
monto_prestado     varchar,
total_pagar    varchar,
firma              varchar
);

CREATE OR REPLACE FUNCTION
sai_gpo_socios (integer,integer,integer)
RETURNS SETOF tipo_sai_gpo_socios AS $$
DECLARE
r   tipo_sai_gpo_socios%rowtype;
p_usuario   integer;
p_tipo   varchar;
r_soc  record;
total_p  varchar;
p_idorigen  integer;
p_idgrupo   integer;
p_idsocio   integer;
BEGIN

  select into  p_idorigen,p_idgrupo,p_idsocio,p_usuario idorigen,idgrupo,idsocio,elaboro from auxiliares 
        where idorigenp=$1 and idproducto=$2 and idauxiliar=$3 and estatus=2;

  select into p_tipo tipo from sopar where idorigen=p_idorigen and idgrupo=p_idgrupo and idsocio=p_idsocio and idusuario=p_usuario;


for r_soc in  select distinct idorigen,idgrupo,idsocio,nombre||' '||appaterno||' '||apmaterno as nombre,idorigenp,idproducto,idauxiliar,montoprestado 
from sopar  s inner join auxiliares a using(idorigen,idgrupo,idsocio)
inner join personas p using(idorigen,idgrupo,idsocio)
where tipo=p_tipo and idproducto=30202   order by idsocio  loop

select into total_p  sai_datos_tabla_amortizaciones(r_soc.idorigenp, r_soc.idproducto,
                                              r_soc.idauxiliar, 'total_suma');

r.ogs       := trim(to_char(r_soc.idorigen,'099999'))||'-'||trim(to_char(r_soc.idgrupo,'09'))||'-'||trim(to_char(r_soc.idsocio,'09999999'));
r.nombre     :=r_soc.nombre;
r.monto_prestado    :=r_soc.montoprestado;
r.total_pagar     :=case when total_p is null or total_p ='' then '0' else total_p end ;
r.firma    :='<br><br><br>FIRMA_____________________________________________<br><br><br>';

return next r;
end loop;





     
END;
 
$$ language 'plpgsql';

--------------------------------------------------------------------------------
-- FUNCIONES PARA IMPRIMIR LA CARATULA DE PRESTAMOS ----------------------------
--------------------------------------------------------------------------------
--drop function if exists sai_caratula_prestamos (INT,INT,INT,int);
CREATE OR REPLACE FUNCTION sai_caratula_prestamos (INT,INT,INT,VARCHAR)
RETURNS TEXT AS $$
DECLARE
  p_idorigenp         alias for $1;
  p_idproducto        alias for $2;
  p_idauxiliar        alias for $3;
  p_formato           alias for $4;

  x_formato           text;
  x_registro_detalle  text;
  x_parte_fija        text;
  x_parte_det         text;
  x_idproducto        text;
  r_datos             record;
  r_detalle           record;
  r_paso              record;
  r_aux               record;
  r_fin               record;
  r_avales            record;
  x_nom_periodo       text;
  x_cont              integer;
  x_fecha             date;
  x_avales_dn         text;
  x_avales_up         text;
  x_avales            text;
  x_avales_firma      text;
  x_codeudor          text;
  x_ogs_codeudor      text;
person  text;

BEGIN
  SELECT INTO x_formato dato2 FROM tablas
  WHERE LOWER(idtabla) = 'param' AND LOWER(idelemento) = p_formato;
  IF NOT FOUND THEN RETURN NULL; END IF;

  SELECT INTO r_datos *
  FROM sai_datos_caratula_prestamos(p_idorigenp,p_idproducto,p_idauxiliar);
  IF NOT FOUND THEN RETURN NULL; END IF;

  select into r_aux *
  from        v_auxiliares
  where       idorigenp = p_idorigenp and idproducto = p_idproducto and
              idauxiliar = p_idauxiliar;

  x_idproducto := p_idproducto::text;

  select into x_fecha date(fechatrabajo) from origenes limit 1;

  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'comisiones_relevantes%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato1,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@comisiones_relevantes@@', r_paso.dato2);
  end if;

  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'clausula_comision%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato1,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@clausula_comision@@', r_paso.dato2);
  end if;
--raise notice '3) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'advertencia_comision%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato1,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@advertencia_comision@@', r_paso.dato2);
  end if;
--raise notice '4) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'seguro%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato1,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@seguro@@', r_paso.dato2);
  end if;
--raise notice '5) x_formato: %', x_formato;
  -- Se modifico para que inserte el dato de la aseguradora que 
  -- se asigno al hacer el contrato (san nicolas)
  select into r_paso *
  from        referenciasp rp
  inner join  tablas t on (t.idelemento = rp.referencia)
  where       rp.tiporeferencia = 13 and
              t.idtabla = 'aseguradoras' and
              rp.idorigenp = p_idorigenp and 
              rp.idproducto = p_idproducto and
              rp.idauxiliar = p_idauxiliar;
  if found then
  --  x_formato := REPLACE(x_formato, '@@aseguradora@@', ('Aseguradora: ' || r_paso.nombre));
    x_formato := REPLACE(x_formato, '@@aseguradora@@', coalesce(r_paso.nombre,'')); -- se le quito el nombre Aseguradora   01/07/2019 fredy
    x_formato := REPLACE(x_formato, '@@direccion_aseguradora@@', (trim(split_part(r_paso.dato2,'|',1))||', '||
                                                                  trim(split_part(r_paso.dato2,'|',2))||', '||
                                                                  trim(split_part(r_paso.dato2,'|',4))||', '||
                                                                  trim(split_part(r_paso.dato2,'|',3))||', '||
                                                                  trim(split_part(r_paso.dato2,'|',5))||', '||
                                                                  trim(split_part(r_paso.dato2,'|',6))||', '
                                                                  ));
  else 
    select into r_paso *
    from        tablas
    where       idtabla = p_formato and
                idelemento like 'aseguradora%' and
                sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
    if found then
      x_formato := REPLACE(x_formato, '@@aseguradora@@', r_paso.dato1);
      x_formato := REPLACE(x_formato, '@@direccion_aseguradora@@', '');
    end if;
  end if;
--raise notice '6) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'clausula_seguro%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@clausula_seguro@@', r_paso.dato1);
  end if;
--raise notice '7) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'tipo_credito%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@tipo_credito@@', r_paso.dato1);
  end if;
  --raise notice '7) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'nombre_caratula%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@nombre_caratula@@', r_paso.dato1);
  end if;

-------------se le agrego a sanicolas nombre comercial del producto asolis--------------
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'nombre_comercial'||substring(x_idproducto from 1 for 3)||'%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@nombre_comercial@@', r_paso.dato1);
  else
    x_formato := REPLACE(x_formato, '@@nombre_comercial@@', '********** Falta en Tablas*************');
  end if;

-------------se le agrego a fama para variable en linea de estado de cuenta asolis--------------
  if ( substring(p_idorigenp::text from 1 for 3) = '305' ) then
    select into r_paso *
    from        tablas
    where       idtabla = p_formato and
                idelemento like 'edo_cta_'||substring(x_idproducto from 1 for 3)||'%' and
                sai_texto1_like_texto2(x_idproducto,NULL,dato1,'|') > 0;
    if found then
      x_formato := REPLACE(x_formato, '@@edo_cta@@', r_paso.dato2);
    else
      x_formato := REPLACE(x_formato, '@@edo_cta@@', '********** Falta en Tablas*************');
    end if;
  end if;
--raise notice '8) x_formato: %', x_formato;
----- se le agrego a capital activo para mostrar el numero de condusef dependiento del tipo de credito y tipo de contrato (en base a la linea de credito)  ---------- fredy   13/03/2019
/*
  select into r_paso *
    from tablas 
   where idtabla = p_formato
      and idelemento like 'numero_contrato_conducef_%'
      and r_datos.tipo_credito_linea_credito = trim(dato3) --- aqui se guarda el tipo_credito
      and r_datos.tipo_contrato = trim(dato4); -- aqui se guarda el tipo_contrato
*/
-- Ultima modificacion fredy 15/05/2019
   select into r_paso *
     from tablas 
    where idtabla = p_formato
      and idelemento like 'numero_contrato_conducef_%'
      and r_datos.tipo_credito_linea_credito = trim(dato3) --- aqui se guarda el tipo_credito
      and r_datos.tipo_contrato = trim(dato4) -- aqui se guarda el tipo_contrato
      and dato4 is not null and dato4 <> '';      

      /*
      and sai_texto1_like_texto2(r_datos.tipo_credito_linea_credito,NULL,dato3,'|') > 0  -- aqui se guarda el tipo_credito
      and sai_texto1_like_texto2(r_datos.tipo_contrato,NULL,dato4,'|') > 0; -- aqui se guarda el tipo_contrato
      */
----------------------------------------------------------------------------------------------------------------------------------------
  if found then
        x_formato := REPLACE(x_formato,'@@numero_contrato_condusef@@', r_paso.dato1);
  else  
                   select into r_paso *
                   from        tablas
                   where       idtabla = p_formato and
                               idelemento like 'numero_contrato_conducef%' and
                               sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
                   if found then
                     x_formato := REPLACE(x_formato, '@@numero_contrato_condusef@@', r_paso.dato1);
                   else
                     x_formato := REPLACE(x_formato, '@@numero_contrato_condusef@@', '********** f a l t a *************');
                   end if;
  end if;
/*
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'numero_contrato_condusef' */
--raise notice '9) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'fecha_registro_conducef%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@fecha_registro_conducef@@', r_paso.dato1);
  else
    x_formato := REPLACE(x_formato, '@@fecha_registro_conducef@@', '********** f a l t a *************');
  end if;

  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'tipo_dpf%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@tipo_dpf@@', r_paso.dato1);
  else
    x_formato := REPLACE(x_formato, '@@tipo_dpf@@', '********** f a l t a *************');
  end if;   ------Se agrego para Cerro Teresa fecha de modif: 06/12/2021

--raise notice '10) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@fecha_ec@@', replace((select sai_fecha_mes_con_letra(x_fecha)),'/',' '));

  x_nom_periodo := sai_token(2,(select sai_fecha_mes_con_letra(x_fecha)),'/')||' '||
                   sai_token(3,(select sai_fecha_mes_con_letra(x_fecha)),'/');
  x_formato := REPLACE(x_formato, '@@mes_anio_ec@@', x_nom_periodo);

  x_formato := REPLACE(x_formato, '@@nombre_socio@@', r_datos.nombre_socio);
  x_formato := REPLACE(x_formato, '@@domicilio_socio@@', r_datos.domicilio_socio);
  x_formato := REPLACE(x_formato, '@@rfc_socio@@', r_datos.rfc_socio);
--raise notice '10) x_formato: %', x_formato;

  x_formato := REPLACE(x_formato, '@@nombre_producto@@', r_datos.nombre_producto);
  x_formato := REPLACE(x_formato, '@@nombre_producto_may@@', r_datos.nombre_producto_mayusculas);
  x_formato := REPLACE(x_formato, '@@nombre_prestamo@@', r_datos.nombre_producto);
  x_formato := REPLACE(x_formato, '@@comision_apertura@@', r_datos.comision_apertura::TEXT);
  x_formato := REPLACE(x_formato, '@@prc_comision@@', to_char(r_datos.prc_comision::numeric,'9.99') );
--raise notice '11) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@nombre_sucursal@@', r_datos.nombre_sucursal);
  x_formato := REPLACE(x_formato, '@@numero_ogs@@', r_datos.ogs);
  x_formato := REPLACE(x_formato, '@@numero_socio@@', sai_token(3,r_datos.ogs,'-'));
--raise notice '12) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@numero_opa@@', r_datos.opa);
  x_formato := REPLACE(x_formato, '@@ahorro110@@',r_datos.ahorro110);
  x_formato := REPLACE(x_formato, '@@monto_ahorro110_en_letras@@', sai_importe_en_letras(sai_numero_sin_formato(r_datos.ahorro110)::numeric,1));

  x_formato := REPLACE(x_formato, '@@numero_auxiliar@@', sai_token(3,r_datos.opa,'-'));
  x_formato := REPLACE(x_formato, '@@cat@@', r_datos.cat);
  x_formato := REPLACE(x_formato, '@@cat1@@', r_datos.cat1);
  x_formato := REPLACE(x_formato, '@@io@@', r_datos.io);
--raise notice '13) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@im@@', r_datos.im);
  x_formato := REPLACE(x_formato, '@@iod@@', r_datos.iod);
  x_formato := REPLACE(x_formato, '@@io_anual@@', r_datos.io_anual);
  x_formato := REPLACE(x_formato, '@@im_anual@@', r_datos.im_anual);
  x_formato := REPLACE(x_formato, '@@iod_anual@@', r_datos.iod_anual);
--raise notice '14) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@monto@@', r_datos.monto_prestamo);

  x_formato := REPLACE(x_formato, '@@monto_comision@@',  to_char(r_datos.monto_prestamo::numeric*.025,'999,999,999.99') );
  x_formato := REPLACE(x_formato, '@@monto_comision337-341@@',  to_char(r_datos.monto_prestamo::numeric*.02,'999,999,999.99') );

  x_formato := REPLACE(x_formato, '@@monto_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_prestamo)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_prestamo@@', r_datos.monto_prestamo);
  x_formato := REPLACE(x_formato, '@@monto_prestamo_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_prestamo)::numeric,1));
--raise notice '15) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@monto_credito@@', r_datos.monto_prestamo);
  x_formato := REPLACE(x_formato,'@@monto_credito_formato@@', to_char(r_datos.monto_prestamo::numeric,'999,999,999.99') );
  x_formato := REPLACE(x_formato, '@@monto_credito_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_prestamo)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_credito_en_letras_minusculas@@',
                       lower(sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_prestamo)::numeric,1)));
  --- LEON FRANCO --------------------------------------------------------------
  x_formato := REPLACE(x_formato, '@@limite_credito@@', r_datos.limite_credito);
  x_formato := REPLACE(x_formato, '@@limite_credito_forma@@', to_char(r_datos.limite_credito::numeric,'999,999,999.99'));
  x_formato := REPLACE(x_formato, '@@limite_credito_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.limite_credito)::numeric,1));
  x_formato := REPLACE(x_formato, '@@limite_credito_en_letras_minusculas@@',
                       lower(sai_importe_en_letras(sai_numero_sin_formato(r_datos.limite_credito)::numeric,1)));

  x_formato := REPLACE(x_formato,'@@plazo_mes_limite_credito@@', r_datos.plazo_mes_limite_credito);
  x_formato := REPLACE(x_formato, '@@monto_autorizado@@', r_datos.monto_autorizado);
  x_formato := REPLACE(x_formato, '@@monto_autorizado_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_autorizado)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_autorizado_en_letras_minusculas@@',
                       lower(sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_autorizado)::numeric,1)));
  -------------------------------------------------------------------------------

  --- NUEVE DE AGOSTO  (Se obtine el numero de producto)-------------------------
  x_formato := REPLACE(x_formato,'@@idproducto@@', x_idproducto);
  -------------------------------------------------------------------------------

  x_formato := replace(x_formato,'@@monto_grupal@@',r_datos.monto_grupal);
  x_formato := REPLACE(x_formato, '@@monto_grupal_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.monto_grupal)::numeric,1));
  x_formato := replace(x_formato,'@@total_grupal@@',r_datos.total_grupal);
  x_formato := REPLACE(x_formato, '@@total_grupal_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_grupal)::numeric,1));

  -- total_a_pagar: Tiene descuento por la tasaiod, según la formación de la tabla de amortización
  x_formato := REPLACE(x_formato, '@@total@@', r_datos.total_a_pagar);
  x_formato := REPLACE(x_formato, '@@total_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_pagar@@',    r_datos.total_a_pagar);
  x_formato := REPLACE(x_formato, '@@monto_pagar_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_pagar_en_letras_minusculas@@',
                       lower(sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar)::numeric,1)));

  -- total_a_pagar_sd: Sin descuento, tasaio normal
  x_formato := REPLACE(x_formato, '@@total_sd@@', r_datos.total_a_pagar_sd);
  x_formato := REPLACE(x_formato, '@@total_sd_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar_sd)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_pagar_sd@@', r_datos.total_a_pagar_sd);
  x_formato := REPLACE(x_formato, '@@monto_pagar_sd_en_letras@@',
                       sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar_sd)::numeric,1));
  x_formato := REPLACE(x_formato, '@@monto_pagar_sd_en_letras_minusculas@@',
                       lower(sai_importe_en_letras(sai_numero_sin_formato(r_datos.total_a_pagar_sd)::numeric,1)));

--raise notice '16b) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@meses@@', r_datos.plazo_meses);
--raise notice '16c) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@plazo@@', r_datos.plazo_meses);

  if r_aux.plazo > 1 then
    x_formato := REPLACE(x_formato, '@@9ago_plazo@@', r_datos.plazo_meses::text);
    x_formato := REPLACE(x_formato, '@@9ago_termino_plazo@@', 'meses');
  else
    x_formato := REPLACE(x_formato, '@@9ago_plazo@@', r_aux.periodoabonos::text);
    x_formato := REPLACE(x_formato, '@@9ago_termino_plazo@@', 'd&iacute;as');
  end if;

--raise notice '16d) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@plazo_y_periocidad@@', r_datos.plazo_y_periocidad);

  x_formato := REPLACE(x_formato, '@@periocidad_letra@@', r_datos.periocidad_letra);
--raise notice '16e) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@periocidad@@', r_datos.periocidad);
--raise notice '17) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@dia@@', r_datos.dia_pago);
  x_formato := REPLACE(x_formato, '@@fecha_ape@@', r_datos.fecha_apertura);
  --x_formato := REPLACE(x_formato, '@@estatus_prestamo@@', r_datos.estatus_prestamo);
  x_formato := REPLACE(x_formato, '@@fecha_vencimiento@@', r_datos.fecha_vencimiento);
--raise notice '18) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@beneficiario@@', coalesce(r_datos.nombre_beneficiario, ''));
--raise notice '18a) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@dia_de_pago_exacto@@', coalesce(r_datos.dia_de_pago_exacto, ''));
-- se agrego este campo para fama mediante la funcion sai_dia_de_pago_exacto_pdf1(INTEGER, INTEGER, INTEGER)     23/09/2019  fredy
--raise notice '18b) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@siguiente_pago@@', coalesce(r_datos.sig_pago, ''));
--raise notice '18c) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@siguiente_pago_dia@@',
                       case when r_datos.sig_pago is not NULL then to_char(r_datos.sig_pago::date,'dd')
                            else ''
                       end);
--raise notice '18d) x_formato: %', x_formato;
-----se anexo un dia antes de su fecha de pago por peticion teocelo--asolis-------
  x_formato := REPLACE(x_formato, '@@siguiente_pago_corte@@',
                       case when r_datos.sig_pago is not NULL then to_char(r_datos.sig_pago::date-1,'dd/mm/yyyy')
                            else ''
                       end);
--raise notice '18e) x_formato: %', x_formato;
  x_formato := REPLACE(x_formato, '@@cant_sig_pago@@', coalesce(r_datos.cant_sig_pago, ''));
--raise notice '18f) x_formato: %', x_formato;
  ----anexada a peticion de capital activo------
--  x_formato := REPLACE(x_formato, '@@limite_credito@@', r_datos.limite_credito);
  x_formato := REPLACE(x_formato, '@@tipo_credito_de_limite_credito@@', r_datos.tipo_credito_de_limite_de_credito);
--raise notice 'a) x_formato: %', x_formato;

  select into r_fin *
  from        finalidades
  where       idfinalidad = r_aux.idfinalidad;

  x_formato := REPLACE(x_formato, '@@fecha_emision@@', date(now())::text);
  x_formato := REPLACE(x_formato, '@@finalidad@@', r_fin.descripcion);
--raise notice 'b) x_formato: %', x_formato;
  x_cont := 0;
  x_avales_up := '';
  x_avales_dn := '';
  x_avales_firma := '';
  for r_avales in
             select      text(idorigenr)||'-'||text(idgrupor)||'-'||text(idsocior) as ogs_aval,
                         nombre||' '||appaterno||' '||apmaterno as nombre_aval,
                         (case when calle is NULL or calle = '' then 'SIN CALLE' else calle end)||' #'||
                         coalesce(numeroext,'ND')||
                         (case when numeroint is NULL or numeroint = '' then '' else '-'||numeroint end)||', '||colonia||
                         ', CP '||coalesce(codigopostal,'0')||', '||municipio||', '||estado as domicilio_aval
             from        referencias as r
             inner join  vpersonas as p
             on          (p.idorigen = r.idorigenr and p.idgrupo = r.idgrupor and p.idsocio  = r.idsocior)
             where       r.idorigen = r_aux.idorigen and r.idgrupo = r_aux.idgrupo and r.idsocio = r_aux.idsocio and
                         tiporeferencia = 8 and
                         sai_token(2,referencia,'|')::integer = p_idorigenp and
                         sai_token(3,referencia,'|')::integer = p_idproducto and
                         sai_token(4,referencia,'|')::integer = p_idauxiliar
             order by    sai_token(1,referencia,'|')::integer 
  loop
    x_cont := x_cont + 1;
    x_avales_up := x_avales_up||(case when x_cont > 1 then ', ' else '' end)||r_avales.ogs_aval||' '||r_avales.nombre_aval;
    x_avales_dn := x_avales_dn||'</b>SOCIO <b>'||r_avales.ogs_aval||' '||r_avales.nombre_aval||E'\012'||
                   'Domicilio: '||
                   (case when r_avales.domicilio_aval is NULL or r_avales.domicilio_aval = ''
                        then '** SIN DOMICILIO **'
                        else r_avales.domicilio_aval
                    end)||'<br />'||E'\012';
    x_avales_firma := x_avales_firma||(case when x_cont > 1 then ', ' else '' end)||r_avales.nombre_aval;
  end loop;
  if x_cont = 0 then
    x_avales_up := '** NO CUENTA CON DEUDOR SOLIDARIO **';
    x_avales_dn := x_avales_up; 
  end if;
  --- Leon franco avales ------
  if x_cont = 0 then
    x_avales := '** NO CUENTA CON AVALES **'; 
  ELSE
    x_avales := x_avales_up;
  end if;
  -----------------------------
  if x_avales_up is NULL then
    x_avales_up := '¡¡¡ ERRORES DE DATOS EN EL DEUDOR SOLIDARIO !!!';
  end if;
  if x_avales_dn is NULL then
    x_avales_dn := '¡¡¡ ERRORES DE DATOS EN EL DEUDOR SOLIDARIO !!!';
  end if;

  x_formato := REPLACE(x_formato, '@@teocelo_avales_arriba@@',x_avales_up);
  x_formato := REPLACE(x_formato, '@@teocelo_avales_abajo@@',x_avales_dn);

  --- Leon franco avales ------
  x_formato := REPLACE(x_formato, '@@avales@@',x_avales);
  x_formato := REPLACE(x_formato, '@@aval1@@',sai_token(1,x_avales_firma,','));
  x_formato := REPLACE(x_formato, '@@aval2@@',sai_token(2,x_avales_firma,','));
  x_formato := REPLACE(x_formato, '@@aval3@@',sai_token(3,x_avales_firma,','));
  -----------------------------

--- Se agrego para Leon franco - Si el origen no inicia con 135 no obtiene el coodeudor ---
  IF (substr(p_idorigenp::TEXT, 1, 3) = '135') THEN 
    select into x_ogs_codeudor, x_codeudor
               TRIM(TO_CHAR((sai_token(1, descripcion,'|')::INTEGER),'099999'))||'-'||
               TRIM(TO_CHAR((sai_token(2, descripcion,'|')::INTEGER),'09'))||'-'||
               TRIM(TO_CHAR((sai_token(3, descripcion,'|')::INTEGER),'09999999')),
               (CASE WHEN nota != null
                     THEN nota
                     ELSE (SELECT (nombre ||' '|| appaterno ||' '|| apmaterno) AS nombre
                           FROM personas
                           WHERE idorigen = sai_token(1, descripcion,'|')::INTEGER AND
                                 idgrupo = sai_token(2, descripcion,'|')::INTEGER AND
                                 idsocio = sai_token(3, descripcion,'|')::INTEGER)
                END)
    from notas
    where idnota like 'C|'||sai_token(1,r_datos.opa,'-')||'|'||sai_token(2,r_datos.opa,'-')||'|'||sai_token(3,r_datos.opa,'-');

    IF NOT FOUND OR x_codeudor IS NULL THEN 
      x_codeudor := ''; 
      x_ogs_codeudor = '** NO CUENTA CON CODEUDOR **'; 
    END IF;

    x_formato := REPLACE(x_formato, '@@numero_ogs_codeudor@@', x_ogs_codeudor);
    x_formato := REPLACE(x_formato, '@@nombre_codeudor@@', x_codeudor);

  END IF;

-------------------------------------------------------------------------------------------
--- Se agrego para teocelo - Si el origen no inicia con 102 no obtiene el detalle de persona grupales ---
  IF (substr(p_idorigenp::TEXT, 1, 3) = '102') THEN 
    select into person
                array_to_string(array(select ogs||'      '||rpad(nombre,50)||'     '||firma 
    from sai_gpo_socios(p_idorigenp,p_idproducto, p_idauxiliar) ), ' ') ;

    x_formato := REPLACE(x_formato, '@@detalle_de_personas@@', person);
  end if;

  RETURN x_formato;
END;
$$ LANGUAGE 'plpgsql';

DROP TYPE IF EXISTS tipo_sai_caratula_prestamos CASCADE;
CREATE TYPE tipo_sai_caratula_prestamos AS (
nombre_socio        VARCHAR,
domicilio_socio     VARCHAR,
rfc_socio           VARCHAR,
nombre_producto     VARCHAR,
nombre_producto_mayusculas   VARCHAR,
comision_apertura  NUMERIC,
nombre_sucursal     VARCHAR,
tipo_credito        VARCHAR,     -- *** YA NO SE USA, DESPUES QUITAR *** --
ogs                 VARCHAR,
opa                 VARCHAR,
ahorro110           varchar,
cat                 VARCHAR,
cat1                VARCHAR,
fecha_apertura      VARCHAR,
-- estatus_prestamo    VARCHAR,
io                  VARCHAR,
im                  VARCHAR,
iod                 VARCHAR,
io_anual            VARCHAR,
im_anual            VARCHAR,
iod_anual           VARCHAR,
monto_prestamo      VARCHAR,
monto_prestamo_l    VARCHAR,
monto_autorizado    VARCHAR,
total_a_pagar       VARCHAR,
total_a_pagar_sd    VARCHAR,
total_a_pagar_l     VARCHAR,
monto_grupal        VARCHAR,
total_grupal        VARCHAR,
plazo_meses         VARCHAR,
plazo_y_periocidad  VARCHAR,
periocidad_letra    VARCHAR,
periocidad          VARCHAR,
dia_pago            VARCHAR,
nombre_beneficiario VARCHAR,
fecha_vencimiento   VARCHAR,
dia_de_pago_exacto  VARCHAR,
sig_pago            VARCHAR,
cant_sig_pago       VARCHAR,
prc_comision        VARCHAR,
numero_contrato_condusef          VARCHAR,
tipo_credito_de_limite_de_credito VARCHAR, -- *** YA NO SE USA, DESPUES QUITAR *** --
limite_credito     VARCHAR,
plazo_mes_limite_credito VARCHAR,
tipo_contrato             VARCHAR,
tipo_credito_linea_credito VARCHAR
); 

/*------------------------------------------------------------------------------
-- ESTA TABLA SE USA EN LA SIGUIENTE FUNCION, PERO COMO SOLO SE USA EN ---------
-- ALGUNAS CAJAS, DEJE AQUI ESTE PARTE DEL CODIGO (JFPA, 18/JUNIO/2012) --------
--------------------------------------------------------------------------------
create table csn_conducef (
 id               integer not null,
 nombre_comercial text,
 tipo_credito     text,
 aseguradora      text,
 clausula         text,
 idproductos      text,
 seguro_vida      text,
 seguro_dano      text,
 primary key (id));
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/


CREATE OR REPLACE FUNCTION sai_datos_caratula_prestamos(INTEGER,INTEGER,INTEGER)
RETURNS SETOF tipo_sai_caratula_prestamos AS $$
DECLARE
  p_idorigenp   ALIAS FOR $1;
  p_idproducto  ALIAS FOR $2;
  p_idauxiliar  ALIAS FOR $3;

  r             tipo_sai_caratula_prestamos%ROWTYPE;
  nombre_prod   VARCHAR;
  comision_ape  NUMERIC;
  tipo_cred     VARCHAR;
  prc_cat       NUMERIC;
  cat_txt       VARCHAR;
  r_aux         RECORD;
  total_p       NUMERIC;
  total_p_sd    NUMERIC;
  nombre_b      VARCHAR;
  fecha_v       DATE;
  dia           INTEGER;
  dia_sem       VARCHAR;
  mes           INTEGER;
  nom_mes       VARCHAR;

  w integer;
  x integer;
  y integer;
  z integer;

  px1 varchar;

  x_entidad integer;
  x_plural  varchar;

  x_cve_tipo_credito_de_limite_de_credito  integer;
  x_cve_tipo_contrato_de_limite_de_credito integer;
  x_limite_credito                         varchar;
  x_plazo_mes_limite_credito               varchar;

  p_monto_grupal VARCHAR;
  p_total_grupal VARCHAR;
BEGIN
/*
  SELECT INTO r_aux
         idorigen,idgrupo,idsocio,fechaape,fechaactivacion,saldo,tasaio,estatus,
         periodoabonos,pagodiafijo,plazo,
         (CASE WHEN estatus < 2 THEN montosolicitado ELSE montoprestado END) AS
         monto_prestamo,
         (CASE WHEN estatus < 2 THEN fechaape ELSE fechaactivacion END) AS
         fecha_prestamo,
         (SELECT nombre FROM productos WHERE idproducto=p_idproducto) AS nom_prod,
         (SELECT tipo_credito FROM csn_conducef
          WHERE idproductos LIKE '%'||TEXT(p_idproducto)||'%') AS tipocred,
         (CASE WHEN pagodiafijo = 1
               THEN ((CASE WHEN estatus < 2 THEN fechaape
                           ELSE fechaactivacion END) + periodoabonos::INTEGER)
               ELSE (CASE WHEN estatus < 2 THEN fechaape
                           ELSE fechaactivacion END) END) AS diapago
  FROM v_auxiliares
  WHERE idorigenp = p_idorigenp AND idproducto = p_idproducto AND
        idauxiliar = p_idauxiliar;
*/
  SELECT INTO r_aux
         TRIM(TO_CHAR(va.idorigen,'099999'))||'-'||TRIM(TO_CHAR(va.idgrupo,'09'))||'-'||TRIM(TO_CHAR(va.idsocio,'09999999')) AS ogs,
         (case when (select a.saldo from auxiliares as a
                     where (a.idorigen,a.idgrupo,a.idsocio)=(va.idorigen,va.idgrupo,va.idsocio) and a.idproducto=110  AND
                           a.estatus=2 and a.saldo>0 limit 1) is null
               then 0.00
               else (select a.saldo from auxiliares as a
                     where (a.idorigen,a.idgrupo,a.idsocio)=(va.idorigen,va.idgrupo,va.idsocio) and a.idproducto=110 AND
                           a.estatus=2 and a.saldo>0 limit 1)
          end) as ahorro110,
         UPPER(vp.nombre||' '||vp.appaterno||' '||vp.apmaterno) AS nom_socio,
         case when calle is NULL or calle = '' then 'SIN CALLE' else calle end||' #'||coalesce(numeroext,'ND')||
         case when numeroint is NULL or numeroint = '' then '' else '-'||numeroint end||', '||colonia||', '||municipio||
         ', '||estado||', '||coalesce(codigopostal,'0')||' Telefono:'||telefono as domicilio,
         rfc, va.idorigenp, va.idproducto, va.idauxiliar, va.idorigen, va.idgrupo, va.idsocio, va.fechaape, va.fechaactivacion,
         va.saldo, va.tasaio, va.tasaiod, va.tasaim, va.estatus, va.periodoabonos, va.tasa_cat_gat,
         va.plazo,va.montosolicitado,va.montoprestado,va.pagodiafijo,TRIM(TO_CHAR(va.idproducto,'09999')) as num_prod,
         TRIM(TO_CHAR(va.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(va.idproducto,'09999'))||'-'||TRIM(TO_CHAR(va.idauxiliar,'09999999')) AS opa,
         va.idproducto, (SELECT nombre FROM productos WHERE idproducto=p_idproducto) AS nom_prod,
         ((SELECT coalesce(comision_apertura,0.00) FROM productos WHERE idproducto=p_idproducto)::NUMERIC * 100) AS com_ape,
         coalesce(va.prc_comision,0.00) AS prc_com, (SELECT nombre FROM origenes WHERE idorigen=p_idorigenp) AS nom_suc,
         (CASE WHEN va.estatus < 2 THEN va.montosolicitado ELSE va.montoprestado END) AS monto_prestamo,
         --- LEON FRANCO ------------------ Gera
         va.montoautorizado AS monto_autorizado,
         ---------------------------------------
         (CASE WHEN va.estatus < 2 THEN va.fechaape ELSE va.fechaactivacion END) AS fecha_prestamo,
         (CASE WHEN va.pagodiafijo = 1
               THEN ((CASE WHEN va.estatus < 2 THEN va.fechaape ELSE va.fechaactivacion END) + va.periodoabonos::INTEGER)
               ELSE (CASE WHEN va.estatus < 2 THEN va.fechaape ELSE va.fechaactivacion END)
          END) AS diapago,
         (select sai_dia_de_pago_exacto_pdf1(va.idorigenp, va.idproducto, va.idauxiliar))::TEXT AS dia_de_pago_exacto,
         (SELECT vence FROM amortizaciones WHERE idorigenp = p_idorigenp AND idproducto = p_idproducto AND
               idauxiliar = p_idauxiliar AND idamortizacion = 1) AS siguiente_pago,
         (SELECT abono+io FROM amortizaciones WHERE idorigenp = p_idorigenp AND idproducto = p_idproducto AND
               idauxiliar = p_idauxiliar AND idamortizacion = 1) AS cantidad_siguiente_pago
    FROM v_auxiliares va 
   INNER JOIN vpersonas vp USING (idorigen,idgrupo,idsocio)
   WHERE va.idorigenp = p_idorigenp AND va.idproducto = p_idproducto AND va.idauxiliar = p_idauxiliar;

  IF NOT FOUND THEN
    r.nombre_socio    := ''; r.nombre_producto := '';
    r.nombre_sucursal := ''; r.tipo_credito    := '';
    r.comision_apertura := 0.00;
    r.prc_comision := '';

    r.ogs := ''; r.opa := ''; r.cat := '';r.ahorro110 :='' ;
    r.io  := ''; r.im  := ''; r.iod := '';

    r.io_anual := ''; r.im_anual := ''; r.iod_anual := '';

    r.monto_prestamo   := ''; r.total_a_pagar   := ''; r.total_a_pagar_sd   := '';
    r.monto_prestamo_l := ''; r.total_a_pagar_l := '';

    r.monto_autorizado   := '';

    r.plazo_meses := ''; r.plazo_y_periocidad := ''; r.dia_pago := '';
    r.fecha_apertura  := '';
   -- r.estatus_prestamo := '';

    r.nombre_beneficiario := '';
    r.domicilio_socio := ''; r.rfc_socio := '';
    r.tipo_credito_de_limite_de_credito = '*************';
    r.plazo_mes_limite_credito := '';
    r.tipo_contrato := '';
    r.tipo_credito_linea_credito := '';
    r.dia_de_pago_exacto := '';

    RETURN NEXT r;
  END IF;

  nombre_prod := (CASE WHEN r_aux.nom_prod IS NULL THEN '' ELSE r_aux.nom_prod END);

  comision_ape := r_aux.com_ape;
  r.prc_comision := r_aux.prc_com;

  x := 0; prc_cat := 0.0;
  SELECT INTO x COUNT(*) FROM amortizaciones
  WHERE idorigenp = p_idorigenp AND idproducto = p_idproducto AND idauxiliar = p_idauxiliar;
  IF NOT FOUND OR x IS NULL THEN x := 0; END IF;

  IF x = 0 THEN
    cat_txt := ''; total_p := NULL; total_p_sd := NULL;
  ELSE
    prc_cat := r_aux.tasa_cat_gat;
    if prc_cat is NULL or prc_cat <= 0.0 then
      prc_cat := calculo_cat_contratotxt3(p_idorigenp,p_idproducto,p_idauxiliar, FALSE);
    end if;

    cat_txt := case when prc_cat is NULL then '' else TRIM(TO_CHAR(prc_cat,'9999.99999')) end;

    total_p    := sai_datos_tabla_amortizaciones(p_idorigenp, p_idproducto, p_idauxiliar, 'total_suma');
    total_p_sd := sai_datos_tabla_amortizaciones(p_idorigenp, p_idproducto, p_idauxiliar, 'total_suma_sindesc');
  END IF;

  nombre_b := NULL;
  SELECT INTO nombre_b UPPER(p.nombre||' '||p.appaterno||' '||p.apmaterno)
  FROM personas p INNER JOIN referencias rs
       ON (p.idorigen=rs.idorigenr AND p.idgrupo=rs.idgrupor AND
           p.idsocio=rs.idsocior)
  WHERE rs.idorigen = r_aux.idorigen AND rs.idgrupo = r_aux.idgrupo AND
        rs.idsocio = r_aux.idsocio AND rs.tiporeferencia = 2;
  IF NOT FOUND OR nombre_b IS NULL THEN nombre_b := ''; END IF;

  fecha_v := NULL;
  IF r_aux.pagodiafijo = 0 THEN
    fecha_v := r_aux.fechaape + (r_aux.plazo*r_aux.periodoabonos)::INTEGER;
  ELSE
    IF r_aux.estatus = 2 THEN
      fecha_v := DATE(DATE(DATE(r_aux.fechaape) + INT4(r_aux.periodoabonos)) +
                           (TEXT(r_aux.plazo)||' MONTHS')::INTERVAL);
    ELSE
      fecha_v := DATE(DATE(r_aux.fechaactivacion) +
                           (TEXT(r_aux.plazo)||' MONTHS')::INTERVAL -
                           '1 MONTH'::INTERVAL);
    END IF;
  END IF;

  dia := 0;
  IF fecha_v IS NOT NULL THEN
    dia := EXTRACT(DOW FROM fecha_v);
    dia_sem :=
        CASE WHEN dia = 0 THEN 'DOMINGO'
             WHEN dia = 1 THEN 'LUNES'
             WHEN dia = 2 THEN 'MARTES'
             WHEN dia = 3 THEN 'MIERCOLES'
             WHEN dia = 4 THEN 'JUEVES'
             WHEN dia = 5 THEN 'VIERNES'
             WHEN dia = 6 THEN 'SABADO'
             ELSE '' END;
    mes := (TRIM(TO_CHAR(fecha_v, 'MM')))::INTEGER;
    nom_mes :=
        CASE WHEN mes = 1  THEN 'ENERO'
             WHEN mes = 2  THEN 'FEBRERO'
             WHEN mes = 3  THEN 'MARZO'
             WHEN mes = 4  THEN 'ABRIL'
             WHEN mes = 5  THEN 'MAYO'
             WHEN mes = 6  THEN 'JUNIO'
             WHEN mes = 7  THEN 'JULIO'
             WHEN mes = 8  THEN 'AGOSTO'
             WHEN mes = 9  THEN 'SEPTIEMBRE'
             WHEN mes = 10 THEN 'OCTUBRE'
             WHEN mes = 11 THEN 'NOVIEMBRE'
             WHEN mes = 12 THEN 'DICIEMBRE'
             ELSE '' END;
    dia := (TRIM(TO_CHAR(fecha_v, 'DD')))::INTEGER;
  END IF;

--- Se agrego para teocelo - Si el origen no inicia con 102 no obtiene monto grupal y total grupal---
  p_total_grupal  := '0'; p_monto_grupal := '0';
  IF (substr(p_idorigenp::TEXT, 1, 3) = '102') THEN 
    select into p_monto_grupal sum(monto_prestado::numeric)
    from sai_gpo_socios(r_aux.idorigenp,r_aux.idproducto,r_aux.idauxiliar);
    IF NOT FOUND OR p_total_grupal  IS NULL THEN p_total_grupal  := '0'; END IF;

    select into p_total_grupal sum(total_pagar::numeric)
    from sai_gpo_socios(r_aux.idorigenp,r_aux.idproducto,r_aux.idauxiliar);
    IF NOT FOUND OR p_monto_grupal IS NULL THEN p_monto_grupal := '0'; END IF;
  end if;

  r.nombre_socio     := (CASE WHEN r_aux.nom_socio IS NULL THEN '' ELSE UPPER(r_aux.nom_socio) END);
  r.domicilio_socio  := r_aux.domicilio;
  r.rfc_socio        := r_aux.rfc;

  r.nombre_producto := nombre_prod;
  r.nombre_producto_mayusculas := upper(nombre_prod);
  r.comision_apertura := comision_ape;
  r.prc_comision := r_aux.prc_com;

  r.nombre_sucursal  := (CASE WHEN r_aux.nom_suc IS NULL THEN '' ELSE UPPER(r_aux.nom_suc) END);
  r.ogs              := (CASE WHEN r_aux.ogs IS NULL THEN '' ELSE UPPER(r_aux.ogs) END);
  r.opa              := (CASE WHEN r_aux.opa IS NULL THEN '' ELSE UPPER(r_aux.opa) END);
  r.ahorro110        :=TRIM(TO_CHAR(r_aux.ahorro110,'99,999,999.99'));
  r.cat              := (CASE WHEN prc_cat IS NULL THEN '0.00' ELSE TRIM(TO_CHAR(prc_cat,'9999.99')) END);
  r.cat1             := (CASE WHEN prc_cat IS NULL THEN '0.00' ELSE TRIM(TO_CHAR(prc_cat,'9999.9')) END);
  r.fecha_apertura   := (CASE WHEN r_aux.fechaape IS NULL THEN '' ELSE TRIM(TO_CHAR(r_aux.fechaape,'DD/MM/YYYY')) END);
  /*
  r.estatus_prestamo := (CASE WHEN r_aux.estatus = 0 THEN 'C A P T U R A D O' 
                              WHEN r_aux.estatus = 1 THEN 'A U T O R I Z A D O'
                              WHEN r_aux.estatus = 2 THEN 'A C T I V O' 
                              WHEN r_aux.estatus = 3 THEN 'P A G A D O'
                              WHEN r_aux.estatus = 4 THEN 'C A N C E L A D O'
                         ELSE '' END);
  */
  r.io               := TRIM(TO_CHAR(r_aux.tasaio,'999.99'));
  r.im               := TRIM(TO_CHAR(r_aux.tasaim,'999.99'));
  r.iod              := TRIM(TO_CHAR(r_aux.tasaiod,'999.99'));
  r.io_anual         := TRIM(TO_CHAR(r_aux.tasaio*12,'999.99'));
  r.im_anual         := TRIM(TO_CHAR(r_aux.tasaim*12,'999.99'));
  r.iod_anual        := TRIM(TO_CHAR(r_aux.tasaiod*12,'999.99'));
  r.monto_prestamo   := TRIM(TO_CHAR(r_aux.monto_prestamo,'99999999.99'));
  r.monto_prestamo_l := '';
  r.monto_autorizado := TRIM(TO_CHAR(r_aux.monto_autorizado,'99,999,999.99'));
  r.total_a_pagar    := (CASE WHEN total_p IS NULL THEN '0.00' ELSE TRIM(TO_CHAR(total_p,'99,999,999.99')) END);
  r.total_a_pagar_sd := (CASE WHEN total_p_sd IS NULL THEN '0.00' ELSE TRIM(TO_CHAR(total_p_sd,'99,999,999.99')) END);
  r.total_a_pagar_l  := '';
  r.plazo_meses      := TRIM(TO_CHAR(r_aux.plazo, '999'));

  IF (substr(p_idorigenp::TEXT, 1, 3) = '310') THEN 
      x_plural := (case when r_aux.periodoabonos = 30 or r_aux.periodoabonos = 31
                         then (case when r_aux.plazo > 1 then 's' else '' end)
                    else (case when r_aux.plazo > 1 and r_aux.pagodiafijo=1 then 'es'
                               when r_aux.plazo > 1 then 's' 
                                ----Se agrego esta parte para san isidro porque aparecia mess y deberia ser meses 
                           else '' 
                           end)      ----Modif. por Teresa fecha: 19/04/2022.
                  end);
      else
        x_plural :=  (case when r_aux.periodoabonos = 30 or r_aux.periodoabonos = 31
                           then (case when r_aux.plazo > 1 
                                      then 'es' 
                                  else '' 
                                end)
                      else (case when r_aux.plazo > 1 then 's' else '' end)
                      end);
  end IF;

  r.plazo_y_periocidad := r.plazo_meses||' '||
                          case when r_aux.pagodiafijo = 1 then 'Mes'||x_plural
                               when r_aux.pagodiafijo = 2 then 'Quincena'||x_plural
                               else case when r_aux.periodoabonos = 7  then 'Semana'||x_plural
                                         when r_aux.periodoabonos = 15 then 'Quincena'||x_plural
                                         when r_aux.periodoabonos = 14 then 'Catorcena'||x_plural
                                         when r_aux.periodoabonos = 30 or r_aux.periodoabonos = 31
                                                                       then 'Mese'||x_plural
                                         when r_aux.periodoabonos = 360 or r_aux.periodoabonos = 365
                                                                       then 'Año'||x_plural  
                                         else 'Pago'||x_plural||' Cada '||r_aux.periodoabonos::text||' dias'
                                    end
                          end;

    r.periocidad_letra := (case when r_aux.pagodiafijo = 1 then 'Mes'
                                when r_aux.pagodiafijo = 2 then 'Quincena'
                                else (case when r_aux.periodoabonos = 7 then 'Semana'
                                         when r_aux.periodoabonos = 15  then 'Quincena'
                                         when r_aux.periodoabonos = 14  then 'Catorcena'
                                         when r_aux.periodoabonos = 30 or r_aux.periodoabonos = 31   then 'Mes'
                                         when r_aux.periodoabonos = 360 or r_aux.periodoabonos = 365 then 'Año'
                                         else 'Pago Cada '||r_aux.periodoabonos::text||' dias'
                                    end)
                           end);

  r.periocidad := case when r_aux.pagodiafijo = 1
                       then 'Cada Dia '||dia::text||' del Mes'
                       else 'Cada '||r_aux.periodoabonos::text||' Dias'
                  end;

  r.dia_pago            := TRIM(TO_CHAR(r_aux.diapago, 'DD'));
  r.nombre_beneficiario := nombre_b;
  r.fecha_vencimiento   :=  (CASE WHEN fecha_v IS NULL THEN ''
                                ELSE dia_sem||', '||(TRIM(TO_CHAR(fecha_v,'DD')))||
                            ' DE '||nom_mes||' DEL '||
                            (TRIM(TO_CHAR(fecha_v,'YYYY'))) END);
  r.dia_de_pago_exacto := r_aux.dia_de_pago_exacto;
  r.sig_pago           := r_aux.siguiente_pago;
  r.cant_sig_pago      := trim(to_char(r_aux.cantidad_siguiente_pago,
                                     '999,999,999.99'));

  r.monto_grupal :=coalesce(p_monto_grupal,'0');
  r.total_grupal :=coalesce(p_total_grupal,'0');

  -- corregido por jgmb
    --r.limite_credito   :=r_lim.limite;
    
/* anexado a peticion de capital activo  
   solis*/
/*
  select into r_lim 
   limite,idorigen,idgrupo,idsocio,idproducto from limite_de_credito
  where idorigen = r_aux.idorigen
    AND idgrupo=r_aux.idgrupo
    AND idsocio=r_aux.idsocio
    AND idproducto = r_aux.idproducto;
*/
    ---------------------------

  -- En el caso de CAPITAL ACTIVO, en la apertura del prestamo se les da opcion
  -- de asignar una linea de credito en particular, por lo que primero se debe
  -- buscar si tiene una linea asignada (JFPA, 04/NOVIEMBRE/2022)

  -- Inicializo en 0, '', '*' por si no tiene linea de credito
  r.limite_credito := '0.00';
  r.tipo_credito_de_limite_de_credito := '*************';
  r.plazo_mes_limite_credito := '0';
  r.tipo_contrato := '';
  r.tipo_credito_linea_credito := '';

  x := 0;
  select into x count(*) from referenciasp
  where idorigenp = r_aux.idorigenp and idproducto = r_aux.idproducto and idauxiliar = r_aux.idauxiliar and
        tiporeferencia = 21;
  if not found or x is NULL then x := 0; end if;

  if x > 0 then
    w := 0; x := 0; y := 0; z := 0;

    select into px1 referencia from referenciasp
    where idorigenp = r_aux.idorigenp and idproducto = r_aux.idproducto and idauxiliar = r_aux.idauxiliar and
          tiporeferencia = 21;
    if found and px1 is not NULL then
      w := sai_token(1, px1, '|')::integer; -- IDPRODUCTO
      x := sai_token(2, px1, '|')::integer; -- TIPO DE CREDITO
      y := sai_token(3, px1, '|')::integer; -- TIPO DE CONTRATO
      z := sai_token(4, px1, '|')::integer; -- CONVENIO MODIFICATORIO

      select into x_cve_tipo_credito_de_limite_de_credito, x_limite_credito,
                  x_plazo_mes_limite_credito,
                  x_cve_tipo_contrato_de_limite_de_credito ---- se agrego x_plazo_mes_limite_credito
                                                           ---- para capital activo 13/03/2019 fredy
                  tipo_credito, trim(replace(coalesce(limite,'0'),',','')),  
                  (((EXTRACT(year FROM (AGE(DATE(fechalimite),date(fechacontrato)))))::INTEGER * 12) +
                   (EXTRACT(month FROM (AGE(DATE(fechalimite),date(fechacontrato)))))::INTEGER) as plazo_mes,
                  tipo_contrato
      from  limite_de_credito 
      where idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio and
            (idproducto = r_aux.idproducto or idproducto = w) and tipo_credito = x and tipo_contrato = y and
            convenio_mod = z
      order by fechalimite desc limit 1;
      if found and x_cve_tipo_credito_de_limite_de_credito is not NULL and x_limite_credito is not NULL then
        r.limite_credito := x_limite_credito;
        r.tipo_credito_de_limite_de_credito := 
          case when x_cve_tipo_credito_de_limite_de_credito = 1 then 'Simple'
               when x_cve_tipo_credito_de_limite_de_credito = 2 then 'Revolvente'
               else '*************'
          end;
        r.plazo_mes_limite_credito := (case when x_plazo_mes_limite_credito is null then '---' 
                                            else x_plazo_mes_limite_credito::text end);
        r.tipo_credito_linea_credito := x_cve_tipo_credito_de_limite_de_credito::text;
        r.tipo_contrato := x_cve_tipo_contrato_de_limite_de_credito::text;
      end if;
    end if;

  else

    select into x_cve_tipo_credito_de_limite_de_credito, x_limite_credito,
                x_plazo_mes_limite_credito,
                x_cve_tipo_contrato_de_limite_de_credito ---- se agrego x_plazo_mes_limite_credito
                                                         ---- para capital activo 13/03/2019 fredy
                tipo_credito, trim(replace(coalesce(limite,'0'),',','')),  
                (((EXTRACT(year FROM (AGE(DATE(fechalimite),date(fechacontrato)))))::INTEGER * 12) +
                 (EXTRACT(month FROM (AGE(DATE(fechalimite),date(fechacontrato)))))::INTEGER) as plazo_mes,
                tipo_contrato
    from  limite_de_credito 
    where idorigen = r_aux.idorigen and idgrupo = r_aux.idgrupo and idsocio = r_aux.idsocio and
           (idproducto = r_aux.idproducto or idproducto = 39999)
    order by fechalimite desc limit 1;
    if found and x_cve_tipo_credito_de_limite_de_credito is not NULL and x_limite_credito is not NULL then
      r.limite_credito := x_limite_credito;
      r.tipo_credito_de_limite_de_credito := 
        case when x_cve_tipo_credito_de_limite_de_credito = 1 then 'Simple'
             when x_cve_tipo_credito_de_limite_de_credito = 2 then 'Revolvente'
             else '*************'
        end;
      r.plazo_mes_limite_credito := (case when x_plazo_mes_limite_credito is null then '---' 
                                          else x_plazo_mes_limite_credito::text end);
      r.tipo_credito_linea_credito := x_cve_tipo_credito_de_limite_de_credito::text;
      r.tipo_contrato := x_cve_tipo_contrato_de_limite_de_credito::text;
    end if;

  end if;

  -------------------------------------------------------------
/*  ***** SE CANCELA AQUI EN ESTA FUNCION,
    ***** AHORA SE MANDO A LA FUNCION PRINCIPAL: sai_caratula_prestamos

  select into r.numero_contrato_condusef coalesce(dato1,'')
  from tablas 
  where idtabla = p_formato 
    and idelemento like 'numero_contrato_conducef_%' 
    and sai_texto1_like_texto2(p_idproducto::text,NULL,dato2,'|') > 0;
  if not found then
    r.numero_contrato_condusef := '';
  end if;


*/
  r.numero_contrato_condusef := '';
  r.tipo_credito := '';

  -------------------------------------------------------------
/*  ***** SE CANCELA AQUI EN ESTA FUNCION,
    ***** AHORA SE MANDO A LA FUNCION PRINCIPAL: sai_caratula_prestamos
  select into r.tipo_credito coalesce(dato1,'')
  from tablas 
  where idtabla = p_formato 
    and idelemento like 'tipo_credito_%' 
    and sai_texto1_like_texto2(p_idproducto::text,NULL,dato2,'|') > 0;
  if not found then
    r.tipo_credito := '';
  end if;
*/
  -------------------------------------------------------------
  select into x_entidad matriz
  from        origenes
  where       idorigen = p_idorigenp;
  if found then
    if x_entidad = 30200 then    -- //...(Caja San Nicolas)
      SELECT into r.tipo_credito tipo_credito
      FROM  csn_conducef  -- //... tabla propia de ellos (CSN)
      WHERE sai_texto1_like_texto2(p_idproducto::text,NULL,idproductos,',') > 0;
      if not found then r.tipo_credito := '*** No Definido ***'; end if;
    end if;
  end if;
  -------------------------------------------------------------

  RETURN NEXT r;
END;
$$ LANGUAGE 'plpgsql';

