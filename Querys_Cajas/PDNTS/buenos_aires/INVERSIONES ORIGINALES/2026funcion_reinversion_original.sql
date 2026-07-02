DROP FUNCTION IF EXISTS public.reinversiones_dpf CASCADE;
CREATE OR REPLACE FUNCTION public.reinversiones_dpf()
RETURNS TABLE(
    socio           text,
    opa_act         text,
    saldo_act       numeric,
    fech_act        date,
    elaboro_act     integer,
    poliza_act      text,
    contador        integer,
    opa_ori         text,
    fech_ori        date,
    elaboro_ori     integer,
    poliza_ori      text
)

AS $$
DECLARE 
    r_activa        record;                         -- inversiones actuales
    r_hist          record;                         -- inversiones historicas
    origen_ref      integer;
    prdct_ref       integer;
    auxi_ref        integer;
    idorigenc_v     integer;
    periodo_v       varchar;
    idtipo_v        integer;
    idpoliza_v      integer;
    contador        integer;
    existe_anterior boolean;
    ultimo_origenp    integer;
    ultimo_producto   integer;
    ultimo_auxiliar   integer;

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
    INSERT INTO tmp_reinversiones
    VALUES (
        r_activa.idorigen,
        r_activa.idgrupo,
        r_activa.idsocio,
        r_activa.idorigenp,
        r_activa.idproducto,
        r_activa.idauxiliar,
        r_activa.saldo,
        r_activa.fechaactivacion,
        r_activa.elaboro,
        r_activa.cargoabono,
        r_activa.idorigenc,
        r_activa.periodo,
        r_activa.idtipo,
        r_activa.idpoliza,
        r_activa.tipomov
        );

    --RETURN NEXT r_out;
    END LOOP;

    ----------------------------------------------------------
-- TABLA TEMPORAL HISTORICO
----------------------------------------------------------

DROP TABLE IF EXISTS historico;

CREATE TEMP TABLE historico(
    idorigen           integer,
    idgrupo            integer,
    idsocio            integer,
    idorigenp_act      integer,
    idproducto_act     integer,
    idauxiliar_act     integer,
    idorigenc_act      integer,
    periodo_act        varchar,
    idtipo_act         integer,
    idpoliza_act       integer,
    contador           integer,
    idorigenp_org      integer,
    idproducto_org     integer,
    idauxiliar_org     integer,
    idorigenc_org      integer,
    periodo_org        varchar,
    idtipo_org         integer,
    idpoliza_org       integer
) ON COMMIT PRESERVE ROWS;

    
FOR r_hist IN SELECT * FROM tmp_reinversiones LOOP
    contador := 0;
    origen_ref := r_hist.idorigenp;
    prdct_ref  := r_hist.idproducto;
    auxi_ref   := r_hist.idauxiliar;
    ultimo_origenp  := origen_ref;
    ultimo_producto := prdct_ref;
    ultimo_auxiliar := auxi_ref;
    idorigenc_v := r_hist.idorigenc;
    periodo_v   := r_hist.periodo;
    idtipo_v    := r_hist.idtipo;
    idpoliza_v  := r_hist.idpoliza;
    existe_anterior := true;

    WHILE existe_anterior LOOP
        existe_anterior := false;
        SELECT ad.idorigenp, ad.idproducto, ad.idauxiliar
        INTO origen_ref, prdct_ref, auxi_ref
        FROM v_auxiliares_d ad
        INNER JOIN v_auxiliares a USING(idorigenp,idproducto,idauxiliar)
        WHERE ad.idorigenc=idorigenc_v
          AND ad.periodo=periodo_v
          AND ad.idtipo=idtipo_v
          AND ad.idpoliza=idpoliza_v
          AND ad.cargoabono=0
          AND ad.idproducto IN (200,201,202,203)
          AND a.estatus=3
          AND a.idorigen=r_hist.idorigen
          AND a.idgrupo=r_hist.idgrupo
          AND a.idsocio=r_hist.idsocio;

        IF FOUND THEN
            contador := contador+1;
            ultimo_origenp  := origen_ref;
            ultimo_producto := prdct_ref;
            ultimo_auxiliar := auxi_ref;
            existe_anterior := true;
            SELECT ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
            INTO idorigenc_v, periodo_v, idtipo_v, idpoliza_v
            FROM v_auxiliares a
            INNER JOIN v_auxiliares_d ad
              ON a.idorigenp=ad.idorigenp
             AND a.idproducto=ad.idproducto
             AND a.idauxiliar=ad.idauxiliar
             AND a.fechaactivacion=ad.fecha::date
            WHERE ad.idorigenp=origen_ref
              AND ad.idproducto=prdct_ref
              AND ad.idauxiliar=auxi_ref
              AND ad.cargoabono=1;
        END IF;
    END LOOP;

    -- AJUSTE: ahora siempre se guardan los últimos valores encontrados
    INSERT INTO historico VALUES(
        r_hist.idorigen, 
        r_hist.idgrupo, 
        r_hist.idsocio,
        r_hist.idorigenp, 
        r_hist.idproducto, 
        r_hist.idauxiliar,
        r_hist.idorigenc, 
        r_hist.periodo, 
        r_hist.idtipo, 
        r_hist.idpoliza,
        contador,
        ultimo_origenp,
        ultimo_producto,
        ultimo_auxiliar,   
        idorigenc_v, 
        periodo_v, 
        idtipo_v, 
        idpoliza_v
    );
END LOOP;
RETURN QUERY
    SELECT h.idorigen||'-'|| h.idgrupo||'-'|| h.idsocio as socio,
    h.idorigenp_act||'-'|| h.idproducto_act||'-'|| h.idauxiliar_act as opa_act, 
    a.saldo as saldo_act,
    a.fechaactivacion as fech_act,
    a.elaboro as elaboro_act, 
    h.idorigenc_act||'-'|| h.periodo_act||'-'|| h.idtipo_act||'-'|| h.idpoliza_act as poliza_act,
    h.contador,
    h.idorigenp_org||'-'|| h.idproducto_org||'-'|| h.idauxiliar_org as opa_ori,
    a1.fechaactivacion as fech_ori,
    a1.elaboro as elaboro_ori,
    h.idorigenc_org||'-'|| h.periodo_org||'-'|| h.idtipo_org||'-'|| h.idpoliza_org as poliza_ori
    FROM historico as h
    LEFT join v_auxiliares as a 
    ON a.idorigenp = h.idorigenp_act
    and a.idproducto = h.idproducto_act
    and a.idauxiliar =h.idauxiliar_act
    LEFT JOIN v_auxiliares as a1
    ON a1.idorigenp = h.idorigenp_org
    and a1.idproducto = h.idproducto_org
    and a1.idauxiliar =h.idauxiliar_org
    ;
END;
$$ LANGUAGE plpgsql;