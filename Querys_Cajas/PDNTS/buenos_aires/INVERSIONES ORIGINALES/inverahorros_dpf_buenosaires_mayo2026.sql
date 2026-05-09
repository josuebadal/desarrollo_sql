--DROP FUNCTION numero_reinversiones_v2();
/*
SELECT numero_reinversiones_dpf);
SELECT * FROM tmp_reinversiones_dpf;
SELECT *
FROM tmp_reinversiones_dpf
ORDER BY num_reinversiones DESC;
*/

DROP TYPE IF EXISTS tipo_reinversiones_dpf CASCADE;
CREATE TYPE public.tipo_reinversiones_dpf AS (
    idorigen            integer,
    idgrupo             integer,
    idsocio             integer,
    idorigenp           integer,
    idproducto          integer,
    idauxiliar          integer,
    elaboro             integer,
    fechaactivacion     date,
    saldo_actual        numeric,
    num_reinversiones   integer
);
CREATE OR REPLACE FUNCTION public.numero_reinversiones_dpf()
RETURNS SETOF tipo_reinversiones_dpf
LANGUAGE plpgsql
AS $$

DECLARE
    r_activa            record;                      -- inversiones activas
    r_out               tipo_reinversiones_dpf;      -- fila de salida
    v_reinversiones     integer;

BEGIN
DROP TABLE IF EXISTS tmp_reinversiones_dpf;
CREATE TEMP TABLE tmp_reinversiones_dpf (
    idorigen            integer,
    idgrupo             integer,
    idsocio             integer,
    idorigenp           integer,
    idproducto          integer,
    idauxiliar          integer,
    elaboro             integer,
    fechaactivacion     date,
    saldo_actual        numeric,
    nombreproducto      varchar,
    num_reinversiones   integer
);
    -- Limpieza controlada (opcional)

    FOR r_activa IN
        SELECT
            a.idorigen,a.idgrupo,a.idsocio,                   --OGS
            a.idorigenp,a.idproducto,a.idauxiliar,            --OPA
            ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, --POLIZA
            ad.cargoabono, a.elaboro,
            a.fechaactivacion,
            a.saldo,
            pr.nombre 
        FROM v_auxiliares a
        JOIN productos pr ON pr.idproducto = a.idproducto
        INNER JOIN v_auxiliares_d ad ON a.idorigenp = ad.idorigenp and a.idproducto = ad.idproducto and a.idauxiliar = ad.idauxiliar
              and  a.fechaactivacion = ad.fecha::date   
        WHERE pr.idproducto IN (200,201,202,203,2002,20102)
          AND a.estatus = 2;
    LOOP

        -- Aquí reutilizas tu logica existente (o versión adaptada)
        v_reinversiones :=
        numero_reinversiones(
            r_activa.idorigenp,
            r_activa.idproducto,
            r_activa.idauxiliar
            );
        -- Poblar salida
        r_out.idorigen                  := r_activa.idorigen;
        r_out.idgrupo                   := r_activa.idgrupo;
        r_out.idsocio                   := r_activa.idsocio;
        r_out.idorigenp                 := r_activa.idorigenp;
        r_out.idproducto                := r_activa.idproducto;
        r_out.idauxiliar                := r_activa.idauxiliar;
        r_out.elaboro                   := r_activa.elaboro;
        r_out.fechaactivacion           := r_activa.fechaactivacion;
        r_out.saldo_actual              := r_activa.saldo;
        r_out.nombreproducto            := r_activa.nombre;
        r_out.num_reinversiones         := v_reinversiones;

        -- Guardar en tabla temporal
        INSERT INTO tmp_reinversiones_v2
        VALUES (
            r_out.idorigen,
            r_out.idgrupo,
            r_out.idsocio,
            r_out.idorigenp,
            r_out.idproducto,
            r_out.idauxiliar,
            r_out.elaboro,
            r_out.fechaactivacion,
            r_out.saldo_actual,
            r_out.nombreproducto,
            r_out.num_reinversiones
        );
        -- Retornar fila
        RETURN NEXT r_out;
    END LOOP;
    RETURN;
END;
$$;
