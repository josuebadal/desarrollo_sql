/*CAJA FAMA  
Buen dia Ingeniero,
Nos puede apoyar con un reporte donde podamos revisar la activad laboral de los socios que tenemos en Cartera morosa y vencida y los salarios registrados en sistema, para asi poder clasificar mejor la situacion de nuestros socios. 
Como le comente, de momento estamos interesados especificamente en los socios que son taxistas (taxi propio o en renta, con concesion a nombre propio o en renta), y conductores de aplicacion (Uber, Didi, Rappi, etc., tanto transporte como comida).
La informacion que me interesa es la siguiente:*/

--NOTA: LA FUNCION nombre_x no esta cargada en CAPITAL ACTIVO
DROP TYPE IF EXISTS 2do_ejer CASCADE;
CREATE TYPE 2do_ejer AS (
cuenta                                          VARCHAR(50)
);

CREATE OR REPLACE FUNCTION ejer2()
RETURN SETOF ejer2
AS $$
DECLARE
query               text; 
r                   ejer2%rowtype;
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

SELECT DISTINCT ON(p.idorigen,p.idgrupo,p.idsocio, aux.idorigenp,aux.idproducto,aux.idauxiliar)
TRIM(TO_CHAR(p.idorigen, '099999'))|| '-' ||TRIM(TO_CHAR(p.idgrupo, '09'))|| '-' ||TRIM(TO_CHAR(p.idsocio, '099999')) AS OGS,
nombre_x(p.nombre, p.appaterno, p.apmaterno) AS "NOMBRE",
EXTRACT(YEARS FROM AGE((select date(fechatrabajo) from origenes limit 1) ,fechanacimiento )) as Edad,
TRIM(TO_CHAR(aux.idorigenp, '099999'))|| '-' ||TRIM(TO_CHAR(aux.idproducto, '09999'))|| '-' ||TRIM(TO_CHAR(aux.idauxiliar, '09999999'))AS OPA,
org.nombre AS Sucursal,
aux.montoprestado,
aux.fechaactivacion,
aux.saldo,
aux.cartera,
soceco.ingresosordinarios ,
tbj.puesto,
p.calle || '-' || p.numeroext|| '-' || p.numeroint || '-' || col.nombre || '-' || p.entrecalles AS Direccion
FROM auxiliares aux
JOIN personas p 
USING (idorigen,idgrupo,idsocio)
INNER JOIN colonias col ON col.idcolonia = p.idcolonia
INNER JOIN productos pdt ON pdt.idproducto = aux.idproducto
INNER JOIN origenes org ON org.idorigen = aux.idorigenp
INNER JOIN trabajo tbj ON tbj.idorigen = p.idorigen
AND tbj.idgrupo = p.idgrupo
AND tbj.idsocio = p.idsocio
INNER JOIN socioeconomicos soceco ON p.idorigen = soceco.idorigen
AND p.idgrupo = soceco.idgrupo
AND p.idsocio = soceco.idsocio
WHERE p.estatus = 't'
AND aux.estatus = 2
AND pdt.tipoproducto = 2
AND (UPPER(aux.cartera) = 'M' OR UPPER(aux.cartera) = 'V')
AND (LOWER(tbj.puesto) like '% uber %' 
OR LOWER(tbj.puesto) like '%didi%'
OR LOWER(tbj.puesto) like '%rappi%'  
OR LOWER(tbj.puesto) like '%taxi%' )
order by p.idorigen, p.idgrupo, p.idsocio
;

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

--    EXECUTE 'copy (select fila from copiar order by id)
--            to ''/tmp/sivoz_amortizaciones_ce_'||fecha||'.csv'' ';

--    EXECUTE 'copy (select fila from copiar where id > 0 order by id)
--            to ''/tmp/sivoz_amortizaciones_se_'||fecha||'.csv'' ';
END;
$$ LANGUAGE plpgsql;