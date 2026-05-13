CREATE OR REPLACE FUNCTION public.mensajes_masivos_sopar(text, text, text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

DECLARE

  lista                ALIAS FOR $1;
  titulo               ALIAS FOR $2;
  aviso                ALIAS FOR $3;
  r_soc                 RECORD;
 
BEGIN


  ----------------------------------------------------------------
  --- SACA A TODOS LOS SOCIOS QUE SE LES VA A INSERTAR MENSAJE ---
  ----------------------------------------------------------------
  FOR r_soc IN
    SELECT idorigen, idgrupo, idsocio
      FROM sopar
     WHERE tipo = lista 

  LOOP

  ----------------------------
  --- INSERTA LOS MENSAJES ---
  ----------------------------
  INSERT INTO historial VALUES (r_soc.idorigen, r_soc.idgrupo, r_soc.idsocio, (SELECT DISTINCT fechatrabajo FROM origenes), titulo,
                                aviso,0,'f',999);

  END LOOP;
  
  RETURN 1;
END;
 $function$
CREATE OR REPLACE FUNCTION public.mensajes_masivos_sopar(text, text, text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

DECLARE

  lista                ALIAS FOR $1;
  titulo               ALIAS FOR $2;
  aviso                ALIAS FOR $3;
  r_soc                 RECORD;
 
BEGIN


  ----------------------------------------------------------------
  --- SACA A TODOS LOS SOCIOS QUE SE LES VA A INSERTAR MENSAJE ---
  ----------------------------------------------------------------
  FOR r_soc IN
    SELECT idorigen, idgrupo, idsocio
      FROM sopar
     WHERE tipo = lista 

  LOOP

  ----------------------------
  --- INSERTA LOS MENSAJES ---
  ----------------------------
  INSERT INTO historial VALUES (r_soc.idorigen, r_soc.idgrupo, r_soc.idsocio, (SELECT DISTINCT fechatrabajo FROM origenes), titulo,
                                aviso,0,'f',999);

  END LOOP;
  
  RETURN 1;
END;
 $function$
