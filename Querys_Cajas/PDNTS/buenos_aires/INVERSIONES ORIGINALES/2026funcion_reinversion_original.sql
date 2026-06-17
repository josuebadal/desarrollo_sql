DROP FUNCTION IF EXISTS public.reinversiones_dpf CASCADE;
DROP TYPE IF EXISTS public.reinversiones_dpf CASCADE;


CREATE TYPE public.reinversiones_dpf AS (
    idorigen                    text,
    idgrupo                     text,
    idsocio                     text,
    idorigenp                   text,
    idproducto                  text,
    idauxiliar                  text,
    saldo                       text,
    fechaactivacion             text,
    elaboro                     text,
    cargoabono                  text,
    idorigenc                   text,
    periodo                     text,
    idtipo                      text,
    idpoliza                    text,
    tipomov                     text
    --num_reinversiones integer
);

CREATE OR REPLACE FUNCTION public.reinversiones_dpf()
RETURNS SETOF reinversiones_dpf
AS $$
DECLARE 
r_rec                           reinversiones_dpf;

BEGIN 
-----   TABLA TEMPORAL DE INVERSIONES ACTIVAS Y SU POLIZA   -----
CREATE TEMP TABLE tmp_reinversiones (
    idorigen                    integer,
    idgrupo                     integer,
    idsocio                     integer,
    idorigenp                   integer,
    idproducto                  integer,
    idauxiliar                  integer,
    saldo                       numeric(12,2),
    fechaactivacion             varchar,
    elaboro                     integer,
    cargoabono                  integer,
    idorigenc                   integer,
    periodo                     varchar,
    idtipo                      integer,
    idpoliza                    integer,
    tipomov                     integer
);


-----   QUERY PARA TRAER LAS INVERSIONES ACTIVAS    -----
INSERT INTO tmp_reinversiones
SELECT a.idorigen, a.idgrupo, a.idsocio,
       a.idorigenp, a.idproducto, a.idauxiliar, 
       a.saldo, a.fechaactivacion, a.elaboro, ad.cargoabono,
       ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, ad.tipomov
FROM v_auxiliares AS a
INNER JOIN v_auxiliares_d AS ad ON a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto 
AND a.idauxiliar = ad.idauxiliar AND a.fechaactivacion = ad.fecha::date
WHERE a.idproducto IN (200,201,202,203) AND a.estatus = 2
AND ad.cargoabono = 1;



END;
$$ LANGUAGE plpgsql;