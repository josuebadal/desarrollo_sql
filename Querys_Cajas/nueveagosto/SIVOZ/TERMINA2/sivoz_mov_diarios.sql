--select * from sivoz_mov_diarios();
DROP TYPE IF EXISTS mov_diarios CASCADE;
CREATE TYPE mov_diarios AS (
    cuenta                                          VARCHAR(50),
    fecha                                           date,
    importe                                         numeric(11,4),
    transaccion                                     VARCHAR(15),
    --sucursal piden 30 pero queda corto se aumenta a 50
    sucursal                                        VARCHAR(50),
    concepto                                        VARCHAR(50),
    --PEDIA SMALLINT(1)
    monetario                                       VARCHAR(2),
    capital                                         numeric(11,4),
    interes                                         numeric(11,4),
    --PIDE LA CURP EN DOUBLE(11,4) SE PUSO VARCHAR 20
    curp                                            VARCHAR(20),
    moratorio                                       numeric(11,4),
    iva_moratorio                                   numeric(11,4),
    forma_pago                                      VARCHAR(50),
    operacion                                       varchar(50),
    tipo                                            varchar(10),
    calle_A                                         varchar(50)
    );

CREATE OR REPLACE FUNCTION sivoz_mov_diarios()
RETURNS SETOF mov_diarios
AS $$
DECLARE 
r               mov_diarios%rowtype;
r_rec           record;
y               integer;
Encabezado      text;
fecha           varchar;

BEGIN
DROP TABLE IF EXISTS copiar;
CREATE TEMP TABLE copiar(
id              integer,
fila            text
);
y := 0;
Encabezado :=   'CUENTA|FECHA|IMPORTE|TRANSACCION|SUCURSAL|CONCEPTO'||
                '|MONETARIO|CAPITAL|INTERES|CURP|MORATORIO|IVA MORATORIO'||
                '|FORMA DE PAGO|OPERACION|TIPO| ENTRE CALLE A';
RAISE NOTICE '|GENERACION DE REPORTE |%',Encabezado;
RAISE NOTICE '|OBTENIENDO DATOS|';

INSERT INTO copiar VALUES (0,Encabezado);

FOR r_rec IN 

SELECT 
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "cuenta",
    ad.fecha AS "fecha",
    ad.efectivo AS "importe", 
    (SELECT TO_CHAR(fechatrabajo, 'DD-MM-YYYY') from origenes order by fechatrabajo desc limit 1) 
    AS "transaccion",
    o.nombre AS "sucursal",
    ' ' AS "concepto",
    (CASE 
            WHEN ad.efectivo >0 THEN 'Si'
            Else 'No'
                END)AS "monetario",
    ad.monto AS "capital",
    ad.montoio AS "interes", 
    p.curp AS "curp",
    ad.montoim AS "moratorio",
    ad.montoivaim AS "iva_moratorio",
    (CASE 
            WHEN ad.idtipo = 1 THEN 'Ventanilla'
            WHEN ad.idtipo = 2 THEN 'Cheque'
            WHEN ad.idtipo = 3 THEN 'Traspaso'
                END) AS "forma_pago",
    (CASE
            WHEN ad.tipomov  = 0 THEN 'cargo/abono' 
            WHEN ad.tipomov  = 1 THEN 'castigo'
            WHEN ad.tipomov  = 2 THEN 'quita'
            WHEN ad.tipomov  = 3 THEN 'condonacion'
            WHEN ad.tipomov  = 4 THEN 'bonificacion'
            WHEN ad.tipomov  = 5 THEN 'descuento'
            WHEN ad.tipomov  = 6 THEN 'ajuste'
                END) AS "operacion", 
            
    (CASE 
            WHEN ad.cargoabono = 1 THEN 'Abono'
            WHEN ad.cargoabono = 0 THEN 'Cargo'
                END) AS "tipo",
    p.calle AS "calle_A",
    ' ' AS "calle_B"
    FROM auxiliares a 
            INNER JOIN auxiliares_d ad
                ON a.idorigenp = ad.idorigenp
                AND a.idproducto = ad.idproducto
                AND a.idauxiliar = ad.idauxiliar
            LEFT JOIN origenes o 
                ON ad.idorigenc = o.idorigen
            INNER JOIN personas p 
                ON a.idorigen = p.idorigen 
                AND a.idgrupo = p.idgrupo 
                AND a.idsocio = p.idsocio
    WHERE a.estatus = 2
                AND a.idproducto BETWEEN 30000  AND 39999
                ORDER BY ad.fecha desc 
LOOP

r.cuenta                      := r_rec."cuenta";
r.fecha                       := r_rec."fecha";
r.importe                     := r_rec."importe";
r.transaccion                 := r_rec."transaccion";
r.sucursal                    := r_rec."sucursal";
r.concepto                    := r_rec."concepto";
r.monetario                   := r_rec."monetario";
r.capital                     := r_rec."capital";
r.interes                     := r_rec."interes";
r.curp                        := r_rec."curp";
r.moratorio                   := r_rec."moratorio";
r.iva_moratorio               := r_rec."iva_moratorio";
r.forma_pago                  := r_rec."forma_pago";
r.operacion                   := r_rec."operacion";
r.tipo                        := r_rec."tipo";
r.calle_A                     := r_rec."calle_A";

INSERT INTO copiar VALUES (y,
    COALESCE(r.cuenta,'')                               ||'|'||
    COALESCE(r.fecha,'01-01-1900')                      ||'|'||
    COALESCE(r.importe,0)                               ||'|'||
    COALESCE(r.transaccion,'No Registrado')             ||'|'||
    COALESCE(r.sucursal,'No Registrado')                ||'|'||
    COALESCE(r.concepto,' ')                            ||'|'||
    COALESCE(r.monetario,' ')                           ||'|'||
    COALESCE(r.capital,0)                               ||'|'||
    COALESCE(r.interes,0)                               ||'|'||
    COALESCE(r.curp,'No Capturado')                     ||'|'||
    COALESCE(r.moratorio,0)                             ||'|'||
    COALESCE(r.iva_moratorio,0)                         ||'|'||
    COALESCE(r.forma_pago,'No Registrado')              ||'|'||
    COALESCE(r.operacion,'No Registrado')               ||'|'||
    COALESCE(r.tipo,'No Registrado')                    ||'|'||
    COALESCE(r.calle_A,'No Registrado')                 
    );
y := y+1;

RETURN NEXT r ;
END LOOP;
    SELECT INTO fecha TO_CHAR(CURRENT_DATE, 'dd-mm-yyyy' );
    EXECUTE 'copy (select fila from copiar order by id) to ''/tmp/sivoz_mov_diarios_ce_'||fecha||'.csv''  ';
    EXECUTE 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_mov_diarios_se_'||fecha||'.csv''  ';
END; 
$$ LANGUAGE plpgsql;