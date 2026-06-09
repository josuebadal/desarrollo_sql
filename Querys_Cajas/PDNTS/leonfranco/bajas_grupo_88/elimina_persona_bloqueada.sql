-- DROP FUNCTION public.elimina_persona_bloqueada(int4, int4, int4);

CREATE OR REPLACE FUNCTION public.elimina_persona_bloqueada(integer, integer, integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
  p_idorigen alias for $1;
  p_idgrupo  alias for $2;
  p_idsocio  alias for $3;

  x integer;

  dato varchar;
begin

  x := 0;
  select into x count(*)
  from sopar
  where idorigen = p_idorigen and idgrupo = p_idgrupo and idsocio = p_idsocio and
        lower(tipo) = 'lista_personas_bloqueadas_cnbv';
  if not found or x is NULL then x := 0; end if;

  if x = 0 then
    dato := 'LA PERSONA '||trim(to_char(p_idorigen,'099999'))||'-'||
                           trim(to_char(p_idgrupo,'09'))||'-'||
                           trim(to_char(p_idsocio,'09999999'))||
            ' NO ESTA EN LA LISTA DE BLOQUEADOS POR LA CNBV';
    return dato;
  end if;

  delete from sopar
  where idorigen = p_idorigen and idgrupo = p_idgrupo and idsocio = p_idsocio and
        lower(tipo) = 'lista_personas_bloqueadas_cnbv';

  x := 0;
  select into x count(*)
  from sopar
  where idorigen = p_idorigen and idgrupo = p_idgrupo and idsocio = p_idsocio and
        lower(tipo) = 'lista_personas_bloqueadas_cnbv';
  if not found or x is NULL then x := 0; end if;

  if x > 0 then
    dato := 'NO SE PUDO BORRAR A LA PERSONA '||trim(to_char(p_idorigen,'099999'))||'-'||
            trim(to_char(p_idgrupo,'09'))||'-'||trim(to_char(p_idsocio,'09999999'))||
            ' DE LA LISTA DE BLOQUEADOS POR LA CNBV';
  else
    dato := 'LA PERSONA '||trim(to_char(p_idorigen,'099999'))||'-'||trim(to_char(p_idgrupo,'09'))||'-'||
            trim(to_char(p_idsocio,'09999999'))||' SE ELIMINO DE LA LISTA DE BLOQUEADOS POR LA CNBV';
  end if;

  return dato;
end;
$function$
;
