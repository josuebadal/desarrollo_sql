--select * from sivoz_amortizaciones();
DROP TYPE IF EXISTS sivoz_amortizaciones CASCADE;
CREATE TYPE sivoz_amortizaciones AS (
    cuenta                                          VARCHAR(50),
    fecha                                           date,
    estatus                                         VARCHAR(20),
    capital                                         numeric(11,4),
    capital_pagado                                  numeric(11,4),
    fecha_pago_capital                              date,
    interes                                         numeric(11,4),
    interes_pagado                                  numeric(11,4),
    fecha_pago_interes                              date,
    iva_interes                                     numeric(11,4),
    iva_interes_pagado                              numeric(11,4),
    interes_moratorio                               numeric(11,4),
    interes_moratorio_pagado                        numeric(11,4),
    iva_moratorio                                   numeric(11,4),
    iva_moratorio_pagado                            numeric(11,4)

);
CREATE OR REPLACE FUNCTION sivoz_amortizaciones()
RETURNS SETOF sivoz_amortizaciones
AS $$
DECLARE 
r                   sivoz_amortizaciones%rowtype;
r_rec               record;
y                   integer;
Encabezado          text;
fecha               varchar;
BEGIN
DROP TABLE IF EXISTS copiar;
CREATE TEMP TABLE copiar(
    id              integer,
    fila            text
);
y :=0;
Encabezado := 'CUENTA';
RAISE NOTICE '|GENERACION DE REPORTE |%',Encabezado;
RAISE NOTICE '|OBTENIENDO DATOS|';

INSERT INTO copiar VALUES (0,Encabezado);

FOR r_rec IN 
SELECT 
        TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
        TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "cuenta",
        am.vence AS "fecha",
        am.idamortizacion,
        (CASE 
            WHEN am.todopag = 't' 
                AND am.atiempo = 't' 
                AND am.abonopag > 0 THEN 'VIGENTE'
            WHEN am.todopag = 't'
                AND am.atiempo != 't'
                AND am.diasvencidos >0
                AND am.abonopag >0 
                AND am.abono >0 THEN 'VENCIDO'
            WHEN am.todopag = 't'
                AND am.abonopag > 0 THEN 'PAGADO'
            WHEN am.todopag !='t'
                AND am.atiempo !='t'
                AND am.abonopag = 0
                AND am.diasvencidos IS  NULL THEN  'VIGENTE'
                ELSE 'PAGADO'
                END) AS "estatus",
        am.abono AS "capital",
        am.abonopag AS "capital_pagado",
        '01-01-1900' AS "fecha_pago_capital",
        am.io AS "interes",
        am.iopag "interes_pagado",
        '01-01-1900' AS "fecha_pago_interes",
        0 AS "iva_interes",
        0 AS "iva_interes_pagado",
        0 AS "interes_moratorio",
        0 AS "interes_moratorio_pagado",
        0 AS "iva_moratorio",
        0 AS "iva_moratorio_pagado" 
    FROM auxiliares a
        INNER JOIN amortizaciones am 
            ON a.idorigenp = am.idorigenp
            AND a.idproducto = am.idproducto
            AND a.idauxiliar = am.idauxiliar
    WHERE a.estatus = 2
        AND a.idproducto BETWEEN 30000 AND 39999
    ORDER BY a.fechaape,a.idorigenp,a.idproducto,a.idauxiliar,am.idamortizacion
LOOP

r.cuenta                            :=r_rec."cuenta";
r.fecha                             :=r_rec."fecha";
r.estatus                           :=r_rec."estatus";
r.capital                           :=r_rec."capital";
r.capital_pagado                    :=r_rec."capital_pagado";
r.fecha_pago_capital                :=r_rec."fecha_pago_capital";
r.interes                           :=r_rec."interes";
r.interes_pagado                    :=r_rec."interes_pagado";
r.fecha_pago_interes                :=r_rec."fecha_pago_interes";
r.iva_interes                       :=r_rec."iva_interes";
r.iva_interes_pagado                :=r_rec."iva_interes_pagado";
r.interes_moratorio                 :=r_rec."interes_moratorio";
r.interes_moratorio_pagado          :=r_rec."interes_moratorio_pagado";
r.iva_moratorio                     :=r_rec."iva_moratorio";
r.iva_moratorio_pagado              :=r_rec."iva_moratorio_pagado";

INSERT INTO copiar VALUES (y,
        COALESCE(r.cuenta,'')                   ||'|'||
        COALESCE(r.fecha,'01-01-1900')          ||'|'||
        COALESCE(r.estatus,'NA')                ||'|'||
        COALESCE(r.capital,0)                   ||'|'||
        COALESCE(r.capital_pagado,0)            ||'|'||
        COALESCE(r.fecha_pago_capital,'01-01-1900')||'|'||
        COALESCE(r.interes,0)                   ||'|'||
        COALESCE(r.interes_pagado,0)            ||'|'||
        COALESCE(r.fecha_pago_interes,'01-01-1900')||'|'||
        COALESCE(r.iva_interes,0)               ||'|'||
        COALESCE(r.iva_interes_pagado,0)        ||'|'||
        COALESCE(r.interes_moratorio,0)         ||'|'||
        COALESCE(r.interes_moratorio_pagado,0)  ||'|'||
        COALESCE(r.iva_moratorio,0)             ||'|'||
        COALESCE(r.iva_moratorio_pagado,0)
        );
y := y+1;

RETURN NEXT r;
END LOOP;
    SELECT INTO fecha TO_CHAR(CURRENT_DATE,'DD-MM-YYYY');

    EXECUTE 'copy (select fila from copiar order by id)
            to ''/tmp/sivoz_amortizaciones_ce_'||fecha||'.csv'' ';

    EXECUTE 'copy (select fila from copiar where id > 0 order by id)
            to ''/tmp/sivoz_amortizaciones_se_'||fecha||'.csv'' ';
END;
$$ LANGUAGE plpgsql;