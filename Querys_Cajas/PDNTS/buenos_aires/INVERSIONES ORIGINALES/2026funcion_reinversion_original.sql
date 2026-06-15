--DROP FUNCTION public.numero_reinversiones_v11();

CREATE TYPE public.numero_reinversiones_v11 AS (
    idorigen                    text,
    idgrupo                     text,
    idsocio                     text,
    idorigenp                   text,
    idproducto                  text,
    idauxiliar                  text,
    fechaactivacion             text,
    elaboro                     text
    --elaboro         integer,
    --fecha_apertura  date,
    --saldo_actual    numeric,
    --nombreproducto  varchar,
    --num_reinversiones integer
);
/*
idpoliza actual
monto actual
usuario elaboro actual
fecha inversion original
idpoliza original
monto original
usuario elaboro original
*/

CREATE OR REPLACE FUNCTION public.numero_reinversiones_v11()
RETURNS   text as $$ 
DECLARE 
r_rec               record;

BEGIN 

select 


-----   QUERY PARA TRAER LAS INVERSIONES ACTIVAS    -----
SELECT va.idorigen, va.idgrupo, va.idsocio,
       va.idorigenp, va.idproducto, va.idauxiliar, va.fechaactivacion, va.elaboro
FROM v_auxiliares as va
WHERE va.idproducto IN (200,201,202,20) AND va.estatus = 2;

