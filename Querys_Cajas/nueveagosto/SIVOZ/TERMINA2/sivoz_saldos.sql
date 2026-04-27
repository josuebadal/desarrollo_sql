--select * from sivoz_saldos();
--DROP FUNCTION IF EXISTS sivoz_saldos();
DROP TYPE IF EXISTS sivoz_saldos CASCADE;

CREATE TYPE sivoz_saldos AS (
    cuenta                          VARCHAR(50),
    s1                              text,
    fecha                           date,
    s2                              text,
    saldo                           numeric(11,4),
    s3                              text,
    omisos                          numeric(10),
    s4                              text,
    dias_mora                       numeric(10),
    s5                              text,
    capital_vencido                 numeric(11,4),
    s6                              text,
    capital_vigente                 numeric(11,4),
    s7                              text,
    int_ctas_orden                  numeric(11,4),
    s8                              text,
    int_moratorio                   numeric(11,4),
    s9                              text,
    int_transitorio                 numeric(11,4),
    s10                              text,
    int_vencido                     numeric(11,4),
    s11                              text,
    int_vigente                     numeric(11,4),
    s12                              text,
    iva_ctas_orden                  numeric(11,4), 
    s13                              text,
    iva_moratorio                   numeric(11,4),
    s14                              text,
    iva_transitorio                 numeric(11,4),
    s15                              text,
    iva_vencido                     numeric(11,4),
    s16                              text,
    iva_vigente                     numeric(11,4),
    s17                              text,
    gastos_cobranza                 numeric(11,4),
    s18                              text,
    monto_amortizacion              numeric(11,4),
    s19                              text,
    monto_otorgado                  numeric(11,4),
    s20                              text,
    periodicidad                    numeric(10),
    s21                              text,
    reserva                         numeric(11,4),
    s22                              text,
    fecha_prox_amortizacion         date,
    s23                              text,
    fecha_ult_pago                  date,
    s24                              text,
    saldo_liquidar                  numeric(11,4),
    s25                              text,
    saldo_vigente                   numeric(11,4)
);
CREATE OR REPLACE FUNCTION sivoz_saldos()
RETURNS SETOF sivoz_saldos
AS $$
DECLARE
r           sivoz_saldos%rowtype;
r_rec       record;
y           integer;
Encabezado  text;
fecha       varchar;

BEGIN
DROP TABLE IF EXISTS copiar;
CREATE TEMP TABLE copiar (
    id          integer,
    fila        text
    );
    y:= 0;
    Encabezado:= 'CUENTA|FECHA|SALDO|OMISOS|DIAS MORA|CAPITAL VENCIDO'||
    '|CAPITAL VIGENTE|INTERES CUENTAS EN ORDEN|INTERES MORATORIO'||
    '|INTERES TRANSITORIO|INTERES VENCIDO|INTERES VIGENTE'||
    '|IVA CUENTAS EN ORDEN|IVA MORATORIO|IVA TRANSITORIO|IVA VENCIDO'||
    '|IVA VIGENTE|GASTOS DE COBRANZA|MONTO DE AMORTIZACION|MONTO OTORGADO'||
    '|PERIODICIDAD|RESERVA|FECHA PROXIMA AMORTIZACION'||
    '|FECHA ULTIMO PAGO|SALDO A LIQUIDAR|SALDO VIGENTE';
    
    RAISE NOTICE '|GENERACION DEL REPORTE SALDOS|%',Encabezado;
    RAISE NOTICE '|OBTENIENDO_DATOS|';

    INSERT INTO copiar VALUES (0,Encabezado);
FOR r_rec in
    SELECT DISTINCT ON(
    a.idorigenp,a.idproducto,a.idauxiliar)  
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "cuenta",
    o.fechatrabajo AS "fecha",
    cv.montovencido AS "saldo",
    cv.abonosvencidos AS "omisos",
    cv.diasvencidos AS "dias_mora",
    (CASE 
        WHEN a.cartera = 'V' THEN a.saldo
        END) AS "capital_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.saldo
        END) AS "capital_vigente",
    a.ieco  AS "int_ctas_orden", 
    a.iecom AS "int_moratorio",
    0 AS "int_transitorio",
    (CASE 
        WHEN a.cartera = 'V' THEN a.idncm
        END) AS "int_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.idnc
        END) AS "int_vigente",
    ROUND((a.ieco * (16.00/100)),2) AS "iva_ctas_orden", 
    ROUND((a.iecom * (16.00/100)),2) AS "iva_moratorio",
    0 AS "iva_transitorio",
    (CASE 
        WHEN a.cartera = 'V' THEN ROUND(a.idncm * (16.00/100),2)
        END) AS "iva_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN ROUND(a.idnc* (16.00/100),2)
        END)  AS "iva_vigente",
    0.00 AS "gastos_cobranza",
    (SELECT ROUND(am.abono +(a.idnc + (a.idnc * (16.00/100)) ),2) 
        from amortizaciones am
        WHERE am.atiempo = 'f'
            AND am.todopag = 'f'
            AND a.idorigenp = am.idorigenp
            AND a.idproducto= am.idproducto
            AND a.idauxiliar= am.idauxiliar
        ORDER BY am.vence DESC limit 1) AS "monto_amortizacion",
    a.montoprestado AS "monto_otorgado",
    (CASE WHEN a.pagodiafijo = 1 THEN '30'
        WHEN a.pagodiafijo = 0 THEN a.periodoabonos 
        END ) AS "periodicidad",
    (eprc_tmp2.e_parte_cub + eprc_tmp2.e_parte_exp +
    eprc_tmp2.e_parte_cub_i + eprc_tmp2.e_parte_exp_i)
    AS "reserva",
    (SELECT MIN(am.vence)
        FROM amortizaciones am
            WHERE 
                am.todopag = 'f'
                AND am.atiempo = 'f'
                AND am.idorigenp = a.idorigenp
                AND am.idproducto = a.idproducto
                AND am.idauxiliar = a.idauxiliar
                ) AS "fecha_prox_amortizacion",
    a.fechauma AS "fecha_ult_pago",
    (CASE 
        WHEN a.cartera = 'V' 
            THEN (SELECT 
            (cv.saldo + cv.io + cv.im))
        WHEN a.cartera != 'V'
            THEN (SELECT 
            (cv.saldo + cv.io + cv.im))
        END)
    AS "saldo_liquidar",
    a.saldo AS "saldo_vigente"
    from auxiliares a
    INNER JOIN personas p 
    USING (idorigen,idgrupo,idsocio)
    INNER JOIN carteravencida cv
        ON a.idorigenp = cv.idorigenp 
        AND a.idproducto = cv.idproducto
        AND a.idauxiliar = cv.idauxiliar
    INNER JOIN origenes o
        ON a.idorigenp = o.idorigen
    INNER JOIN productos pr
        ON a.idproducto = pr.idproducto
    INNER JOIN amortizaciones am
        ON a.idorigenp = am.idorigenp
        AND a.idproducto = am.idproducto
        AND a.idauxiliar = am.idauxiliar
    INNER JOIN eprc_tmp2
        ON a.idorigen= eprc_tmp2.idorigen AND a.idgrupo = eprc_tmp2.idgrupo 
        AND a.idsocio = eprc_tmp2.idsocio
        AND a.idorigenp= eprc_tmp2.idorigenp AND a.idproducto = eprc_tmp2.idproducto 
        AND a.idauxiliar = eprc_tmp2.idauxiliar
    WHERE p.estatus = 't'
        AND a.estatus = 2
        AND a.idproducto BETWEEN 30000 AND 39999
    ORDER BY a.idorigenp,a.idproducto,a.idauxiliar DESC 
LOOP
    r.cuenta                   := r_rec."cuenta";
    r.s1                       := '|';
    r.fecha                    := r_rec."fecha";
    r.s2                       := '|';
    r.saldo                    := r_rec."saldo";
    r.s3                       := '|';
    r.omisos                   := r_rec."omisos";
    r.s4                       := '|';
    r.dias_mora                := r_rec."dias_mora";
    r.s5                       := '|';
    r.capital_vencido          := r_rec."capital_vencido";
    r.s6                       := '|';
    r.capital_vigente          := r_rec."capital_vigente";
    r.s7                       := '|';
    r.int_ctas_orden           := r_rec."int_ctas_orden";
    r.s8                       := '|';
    r.int_moratorio            := r_rec."int_moratorio";
    r.s9                       := '|';
    r.int_transitorio          := r_rec."int_transitorio";
    r.s10                       := '|';
    r.int_vencido              := r_rec."int_vencido";
    r.s11                       := '|';
    r.int_vigente              := r_rec."int_vigente";
    r.s12                       := '|';
    r.iva_ctas_orden           := r_rec."iva_ctas_orden";
    r.s13                       := '|';
    r.iva_moratorio            := r_rec."iva_moratorio";
    r.s14                       := '|';
    r.iva_transitorio          := r_rec."iva_transitorio";
    r.s15                       := '|';
    r.iva_vencido              := r_rec."iva_vencido";
    r.s16                       := '|';
    r.iva_vigente              := r_rec."iva_vigente";
    r.s17                       := '|';
    r.gastos_cobranza          := r_rec."gastos_cobranza";
    r.s18                       := '|';
    r.monto_amortizacion       := r_rec."monto_amortizacion";
    r.s19                       := '|';
    r.monto_otorgado           := r_rec."monto_otorgado";
    r.s20                       := '|';
    r.periodicidad             := r_rec."periodicidad";
    r.s21                       := '|';
    r.reserva                  := r_rec."reserva";
    r.s22                       := '|';
    r.fecha_prox_amortizacion  := r_rec."fecha_prox_amortizacion";
    r.s23                       := '|';
    r.fecha_ult_pago           := r_rec."fecha_ult_pago";
    r.s24                       := '|';
    r.saldo_liquidar           := r_rec."saldo_liquidar";
    r.s25                       := '|';
    r.saldo_vigente            := r_rec."saldo_vigente";



    INSERT INTO copiar VALUES (y,
        COALESCE(NULLIF(r.cuenta,''),'')        || '|' ||
        COALESCE(TO_CHAR(r.fecha,'DD-MM-YYYY'),'01-01-1900')|| '|' ||
        COALESCE(r.saldo,0)                     || '|' ||
        COALESCE(r.omisos,0)                    || '|' ||
        COALESCE(r.dias_mora,0)                 || '|' ||
        COALESCE(r.capital_vencido,0)           || '|' ||
        COALESCE(r.capital_vigente,0)           || '|' ||
        COALESCE(r.int_ctas_orden,0)            || '|' ||
        COALESCE(r.int_moratorio,0)             || '|' ||
        COALESCE(r.int_transitorio,0)           || '|' ||
        COALESCE(r.int_vencido,0)               || '|' ||
        COALESCE(r.int_vigente,0)               || '|' ||
        COALESCE(r.iva_ctas_orden,0)            || '|' ||
        COALESCE(r.iva_moratorio,0)             || '|' ||
        COALESCE(r.iva_transitorio,0)           || '|' ||
        COALESCE(r.iva_vencido,0)               || '|' ||
        COALESCE(r.iva_vigente,0)               || '|' ||
        COALESCE(r.gastos_cobranza,0)           || '|' ||
        COALESCE(r.monto_amortizacion,0)        || '|' ||
        COALESCE(r.monto_otorgado,0)            || '|' ||
        COALESCE(r.periodicidad,0)              || '|' ||
        COALESCE(r.reserva,0)                   || '|' ||
        COALESCE(TO_CHAR(r.fecha_prox_amortizacion,'DD-MM-YYYY'),'01-01-1900')|| '|' ||
        COALESCE(TO_CHAR(r.fecha_ult_pago,'DD-MM-YYYY'),'01-01-1900')|| '|' ||
        COALESCE(r.saldo_liquidar,0)            || '|' ||
        COALESCE(r.saldo_vigente,0)
    );
    y:= y+1;

    RETURN NEXT r;
END LOOP;

    SELECT INTO fecha to_char(CURRENT_DATE, 'dd-mm-yyyy');
    EXECUTE 'copy (select fila from copiar order by id) to ''/tmp/sivoz_saldos_ce_'||fecha|| '.csv'' ';
    EXECUTE 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_saldos_se_' ||fecha||'.csv'' ';
    END;
    $$ LANGUAGE plpgsql;