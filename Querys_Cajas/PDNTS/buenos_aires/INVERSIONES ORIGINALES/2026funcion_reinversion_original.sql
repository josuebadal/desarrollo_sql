DROP FUNCTION IF EXISTS public.reinversiones_dpf CASCADE;
DROP TYPE IF EXISTS public.reinversiones_dpf CASCADE;
    
CREATE TYPE public.reinversiones_dpf AS (
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
    --num_reinversiones           integer
);

CREATE OR REPLACE FUNCTION public.reinversiones_dpf()
RETURNS SETOF reinversiones_dpf
AS $$
DECLARE 
    r_activa   record;              -- inversiones activas
    r_out      reinversiones_dpf;              -- fila de salida
    v_reinversiones integer;

BEGIN 
-----TABLA TEMPORAL DE INVERSIONES ACTIVAS Y SU POLIZA-----
DROP TABLE IF EXISTS tmp_reinversiones;
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
) ON COMMIT PRESERVE ROWS;

    -----QUERY PARA TRAER LAS INVERSIONES ACTIVAS-----
    FOR r_activa IN
        SELECT a.idorigen, a.idgrupo, a.idsocio,
        a.idorigenp, a.idproducto, a.idauxiliar, 
        a.saldo, a.fechaactivacion, a.elaboro, ad.cargoabono,
        ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, ad.tipomov
        FROM v_auxiliares AS a
        INNER JOIN v_auxiliares_d AS ad ON a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto 
        AND a.idauxiliar = ad.idauxiliar AND a.fechaactivacion = ad.fecha::date
        WHERE a.idproducto IN (200,201,202,203) AND a.estatus = 2
        AND ad.cargoabono = 1
    LOOP

        
        r_out.idorigen                      := r_activa.idorigen;
        r_out.idgrupo                       := r_activa.idgrupo;
        r_out.idsocio                       := r_activa.idsocio;
        r_out.idorigenp                     := r_activa.idorigenp;
        r_out.idproducto                    := r_activa.idproducto;
        r_out.idauxiliar                    := r_activa.idauxiliar;
        r_out.saldo                         := r_activa.saldo;
        r_out.fechaactivacion               := r_activa.fechaactivacion;
        r_out.elaboro                       := r_activa.elaboro;
        r_out.cargoabono                    := r_activa.cargoabono;
        r_out.idorigenc                     := r_activa.idorigenc;
        r_out.periodo                       := r_activa.periodo;
        r_out.idtipo                        := r_activa.idtipo;
        r_out.idpoliza                      := r_activa.idpoliza;
        r_out.tipomov                       := r_activa.tipomov;
        --r_out.num_reinversiones             := v_reinversiones;
        

    INSERT INTO tmp_reinversiones
    VALUES (
        r_out.idorigen,
        r_out.idgrupo,
        r_out.idsocio,
        r_out.idorigenp,
        r_out.idproducto,
        r_out.idauxiliar,
        r_out.saldo,
        r_out.fechaactivacion,
        r_out.elaboro,
        r_out.cargoabono,
        r_out.idorigenc,
        r_out.periodo,
        r_out.idtipo,
        r_out.idpoliza,
        r_out.tipomov);
    RETURN NEXT r_out;
    END LOOP;
    RETURN;
END;
$$ 
LANGUAGE plpgsql;