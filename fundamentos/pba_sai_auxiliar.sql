-- DROP FUNCTION public.sai_auxiliar(int4, int4, int4, date, date, int4, bool, int4);

CREATE OR REPLACE FUNCTION public.sai_auxiliar(integer, integer, integer, date, date, integer, boolean, integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  -- Parametros 
  p_idorigenp  ALIAS FOR $1;
  p_idproducto ALIAS FOR $2;
  p_idauxiliar ALIAS FOR $3;
  p_defecha    ALIAS FOR $4; -- fecha inicial casi no se usa o talvez no se usa
  p_afecha     ALIAS FOR $5;
  p_db         ALIAS FOR $6; -- NO SE USA
  p_actualiza  ALIAS FOR $7; -- NO SE USA
  p_idsucursal ALIAS FOR $8; -- Idorigen actual en la apliacion

  -- Variables
  tp          integer; -- Tipo de producto
  tc          integer; -- Tipo de calculo
  cont        integer;
  suc_act     integer;
  t_iva_io    numeric; -- Tasas de Iva IO
  t_iva_im    numeric; -- Tasas de Iva IM
  iva_esp     numeric;
  sucursales  text;
  calculo     text := NULL;
  rcursor     refcursor;
  raux        record;
  paso_n      numeric;
  paso_n2     numeric;
  x           integer;
begin

  /*----------------------------------------------------------------------------
  :: Solicita el tipo producto, los ivas y valida de que exista el producto
  ----------------------------------------------------------------------------*/
  select into tp,tc,t_iva_io,t_iva_im tipoproducto,tipocalculo,iva,ivaim
    from productos where idproducto = p_idproducto;
  if not found then
    -- Truena sesion
    raise notice 'DESDE sai_auxiliar EL PRODUCTO: %-%-% NO EXISTE',
                 p_idorigenp, p_idproducto, p_idauxiliar;
    raise exception '**';
  end if;

  /*----------------------------------------------------------------------------
  :: Solicita el iva que se maneja en una sucursal fronteriza (10.00 % ej.)
  ----------------------------------------------------------------------------*/
  if (p_idsucursal is NOT NULL and tp = 2) then
    suc_act := p_idsucursal;

    /*Si el iva del producto es CERO, se usa esta tasa (JFPA, 17/ABRIL/2009)*/
    paso_n := 0.0;
    SELECT INTO paso_n iva FROM productos WHERE idproducto = p_idproducto;
    IF NOT FOUND OR paso_n IS NULL THEN
      paso_n := 0;
    END IF;

    IF paso_n > 0 THEN
      select into iva_esp, sucursales text(dato1)::numeric, dato2 
             from tablas
            where idtabla = 'param' and
                  idelemento = 'iva_sucursal_fronteriza';
      if found then
        if (iva_esp is NOT NULL and sucursales is NOT NULL) and
           (iva_esp > 0 and sucursales not like '') then
          for cont in 1..sai_findstr(sucursales,'|')+1 loop
          paso_n := to_number(sai_token(cont,sucursales,'|'),'999999');
            if (to_number(sai_token(cont,sucursales,'|'),'999999') =
                suc_act) then
              t_iva_io := iva_esp;
              t_iva_im := iva_esp;
            end if;
          end loop;
        end if;
      end if;
    ELSE
      t_iva_io := 0;
      t_iva_im := 0;
    END IF;

  end if;

--------------------------------------------------------------------------------
-- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO
--------------------------------------------------------------------------------
  -- Si el folio no existe en AUXILIARES debe buscarlo en AUXILIARES_H ---------
  select into x count(*) from auxiliares
        where auxiliares.idorigenp  = p_idorigenp  and
              auxiliares.idproducto = p_idproducto and
              auxiliares.idauxiliar = p_idauxiliar;
  if not found or x is null then x := 0; end if;

  if x > 0 then
    open rcursor for select * from auxiliares
          where auxiliares.idorigenp  = p_idorigenp  and
                auxiliares.idproducto = p_idproducto and
                auxiliares.idauxiliar = p_idauxiliar;
  else
    open rcursor for select * from auxiliares_h
          where auxiliares_h.idorigenp  = p_idorigenp  and
                auxiliares_h.idproducto = p_idproducto and
                auxiliares_h.idauxiliar = p_idauxiliar;
  end if;
--------------------------------------------------------------------------------
-- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO -- NUEVO
--------------------------------------------------------------------------------

  /*----------------------------------------------------------------------------
  :: Segun el tipo de producto ejecuta una sub funcion el resulta pasa a la
  :: variable calculo
  ----------------------------------------------------------------------------*/
  select into calculo
         
         -- Ahorros
    case when tp = 0 then sai_auxiliar_ah (rcursor,p_defecha,p_afecha,tc,p_db,
                                           p_actualiza)

         -- Dpf
         when tp = 1 then sai_auxiliar_dp (rcursor,p_defecha,p_afecha)

         -- Prestamos
         when tp = 2 then sai_auxiliar_pr (rcursor,p_defecha,p_afecha,tc,
                                           t_iva_io,t_iva_im,p_db,p_actualiza)

         -- Deudores Diversos
         when tp = 4 then sai_auxiliar_dd (rcursor,p_defecha,p_afecha,tc)

         -- Acreedores Diversos
         when tp = 5 then sai_auxiliar_ad (rcursor,p_defecha,p_afecha,tc)

         -- InverAhorros
         when tp = 8 then sai_auxiliar_ia (rcursor,p_defecha,p_afecha,tc)

         -- Contratos
         when tp = 9 then sai_auxiliar_co (rcursor,p_defecha,p_afecha,tc)
         
         -- Contratos
         when tp = 11 then sai_auxiliar_or (rcursor,p_defecha,p_afecha,tc)

    end;

  close rcursor;

  return text(tp) || '|' || calculo;
end;
$function$
;
