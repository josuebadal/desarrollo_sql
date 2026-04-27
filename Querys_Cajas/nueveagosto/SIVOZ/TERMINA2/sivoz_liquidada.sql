--select * from sivoz_liquidada();
DROP TYPE IF EXISTS liquidada CASCADE;
CREATE TYPE liquidada AS (
    cuenta                                          VARCHAR(50)
    );
CREATE OR REPLACE FUNCTION sivoz_liquidada()
RETURNS SETOF liquidada
AS $$
DECLARE
r                   liquidada%rowtype;
r_rec               record;
y                   integer;
Encabezado          text;
fecha               varchar;
BEGIN
DROP TABLE IF EXISTS copiar;
CREATE TEMP TABLE copiar (
id                  integer,
fila                text
);
y := 0;
Encabezado := 'LIQUIDADA';
RAISE NOTICE '|GENERACION DE REPORTE |%',Encabezado;
RAISE NOTICE '|OBTENIENDO DATOS|';

INSERT INTO copiar VALUES (0,Encabezado);

FOR r_rec IN 
SELECT
        TRIM(TO_CHAR(ah.idorigenp,'09999'))||'-'||
        TRIM(TO_CHAR(ah.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(ah.idauxiliar,'09999999')) AS "cuenta"
    FROM auxiliares_h ah
        INNER JOIN personas p
            ON p.idorigen = ah.idorigen
            AND p.idgrupo = ah.idgrupo
            AND p.idsocio = ah.idsocio
    WHERE  p.estatus = 't'
            AND ah.estatus = 3
            AND ah.idproducto BETWEEN 30000 AND 39999
            AND p.idgrupo = 10
            ORDER BY ah.fechaumi DESC
LOOP

r.cuenta                      := r_rec."cuenta";

INSERT INTO copiar VALUES (y,
    COALESCE(r.cuenta,'')
    );
y := y+1;

RETURN NEXT r ;
END LOOP;
    SELECT INTO fecha TO_CHAR(CURRENT_DATE, 'dd-mm-yyyy' );
    
    EXECUTE 'copy (select fila from copiar order by id) 
            to ''/tmp/sivoz_liquidada_ce_'||fecha||'.csv''  ';
    
    EXECUTE 'copy (select fila from copiar where id > 0 order by id) 
            to ''/tmp/sivoz_liquidada_se_'||fecha||'.csv''  ';
END; 
$$ LANGUAGE plpgsql;