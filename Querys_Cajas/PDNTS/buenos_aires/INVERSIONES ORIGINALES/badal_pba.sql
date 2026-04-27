--DROP FUNCTION numero_reinversiones_v2();
/*
SELECT numero_reinversiones_v2();
SELECT * FROM tmp_reinversiones_v2;
SELECT *
FROM tmp_reinversiones_v2
ORDER BY num_reinversiones DESC;
*/

DROP TYPE IF EXISTS tipo_reinversion_v2 CASCADE;
CREATE TYPE public.tipo_reinversion_v2 AS (
    idorigen        integer,
    idgrupo         integer,
    idsocio         integer,

    idorigenp       integer,
    idproducto      integer,
    idauxiliar      integer,
    elaboro         integer,
    fechaactivacion  date,
    saldo_actual    numeric,
    nombreproducto        varchar,

    num_reinversiones integer
);
CREATE OR REPLACE FUNCTION public.numero_reinversiones_v2()
RETURNS SETOF tipo_reinversion_v2
LANGUAGE plpgsql
AS $$

DECLARE
    r_activa   record;              -- inversiones activas
    r_out      tipo_reinversion_v2; -- fila de salida

    v_reinversiones integer;

BEGIN
DROP TABLE IF EXISTS tmp_reinversiones_v2;
CREATE TEMP TABLE tmp_reinversiones_v2 (
    idorigen        integer,
    idgrupo         integer,
    idsocio         integer,
    
    idorigenp       integer,
    idproducto      integer,
    idauxiliar      integer,
    elaboro         integer,
    fechaactivacion  date,
    saldo_actual    numeric,
    nombreproducto        varchar,

    num_reinversiones integer
) ON COMMIT PRESERVE ROWS;
    -- Limpieza controlada (opcional)

    FOR r_activa IN
        SELECT
            a.idorigen,
            a.idgrupo,
            a.idsocio,
            a.idorigenp,
            a.idproducto,
            a.idauxiliar,
            a.elaboro,
            a.fechaactivacion,
            a.saldo,
            pr.nombre
        FROM v_auxiliares a
        JOIN productos pr ON pr.idproducto = a.idproducto
        INNER JOIN (select * from v_auxiliaresd) 
        WHERE pr.tipoproducto IN (1,8)
          AND a.estatus = 2
    LOOP

        -- Aquí reutilizas tu logica existente (o versión adaptada)
        v_reinversiones :=
            numero_reinversiones(
                r_activa.idorigenp,
                r_activa.idproducto,
                r_activa.idauxiliar
            );
        -- Poblar salida
        r_out.idorigen          := r_activa.idorigen;
        r_out.idgrupo           := r_activa.idgrupo;
        r_out.idsocio           := r_activa.idsocio;
        r_out.idorigenp         := r_activa.idorigenp;
        r_out.idproducto        := r_activa.idproducto;
        r_out.idauxiliar        := r_activa.idauxiliar;
        r_out.elaboro                   := r_activa.elaboro;
        r_out.fechaactivacion    := r_activa.fechaactivacion;
        r_out.saldo_actual      := r_activa.saldo;
        r_out.nombreproducto          := r_activa.nombre;
        r_out.num_reinversiones := v_reinversiones;

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
