--select * from sivoz_general();
DROP TYPE IF EXISTS sivozgeneral CASCADE;
CREATE TYPE sivozgeneral AS (
    cuenta                                           VARCHAR(50),
    socio                                            VARCHAR(30),
    nombre                                           VARCHAR(100),
    omisos                                           numeric(3),
    dias_mora                                        numeric(5),
    plaza                                            VARCHAR(50),
    producto                                         VARCHAR(50),
    rfc                                              VARCHAR(20),
    fechasaldo                                       date,
    subcuenta                                        VARCHAR(50),
    estatus                                          VARCHAR(10),
    fecha_desembolso                                 date,
    fecha_cierre                                     date,
    curp                                             VARCHAR(100),
    ciudad                                           VARCHAR(50),
    colonia                                          VARCHAR(100),
    cp                                               numeric(10),
    delegacion                                       VARCHAR(50),
    estado                                           VARCHAR(50),
    calle_A                                          VARCHAR(50),
    calle_B                                          VARCHAR(50),
    referencia                                       VARCHAR(50),
    correo                                           VARCHAR(50),
    telefono1                                        VARCHAR(20),
    tipoTel1                                         VARCHAR(10),
    telefono2                                        VARCHAR(20),
    tipoTel2                                         VARCHAR(10),
    telefono3                                        VARCHAR(20),
    tipoTel3                                         VARCHAR(10),
    telefono4                                        VARCHAR(20),
    tipoTel4                                         VARCHAR(10),
    telefono5                                        VARCHAR(20),
    tipoTel5                                         VARCHAR(10),
    telefono6                                        VARCHAR(20),
    tipoTel6                                         VARCHAR(10),
    capital_vencido                                  numeric(11,2),
    capital_vigente                                  numeric(11,2),
    int_ctas_orden                                   numeric(11,2),
    int_moratorio                                    numeric(11,2),
    int_vencido                                      numeric(11,2),
    int_vigente                                      numeric(11,2),
    iva_ctas_orden                                   numeric(11,2),
    iva_moratorio                                    numeric(11,2),
    iva_vencido                                      numeric(11,2),
    iva_vigente                                      numeric(11,2),
    gastos_cobranza                                  numeric(11,2),
    monto_amortizacion                               numeric(11,2),
    monto_otorgado                                   numeric(11,2),
    periodicidad                                     numeric(6),
    estimacion_capital_cubierto                      numeric(11,2),
    estimacion_capital_expuesto                      numeric(11,2),
    estimacion_interes_cubierto                      numeric(11,2),
    estimacion_interes_expuesto                      numeric(11,2),
    reserva                                          numeric(11,2),
    fecha_prox_amortizacion                          date,
    fecha_ult_pago                                   date,
    saldo_liquidar                                   numeric(11,2),
    saldo_vigente                                    numeric(11,2),
    fecha_ultimo_pago_interes_normal                 date,
    fecha_ultimo_pago_de_interes_moratorio           date,
    fecha_ultimo_pago_a_capital                      date,
    fecha_de_primer_amortizacion_no_cubierta         date,
    fecha_de_otorgamiento                            date,
    fecha_de_nacimiento                              date,
    ahorro_ordinario                                 numeric(11,2),
    cuenta_corriente                                 numeric(11,2),
    ahorro_garantia                                  numeric(11,2),
    creditos_activos                                 numeric(5),
    ---VALIDAR 1ERA AMORTIZACION MARCA ERROR
    primer_amortizacion_vencida                      numeric(11,2),
    plazo                                            numeric(10),
    ingresos                                         numeric(11,2),
    gastos                                           numeric(11,2),
    tel_trabajo                                      VARCHAR(15),
    modalidad_de_pago                                VARCHAR(20),
    situacion_contable                               VARCHAR(20),
    finalidad_credito                                VARCHAR(50),
    donde_trabaja                                    VARCHAR(110),
    ocupacion                                        VARCHAR(50),
    tipo_de_credito                                  VARCHAR(50),
    direccion_del_socio                              VARCHAR(100),
    direccion_trabajo                                VARCHAR(80),
    referencias_de_direccion_de_trabajo              VARCHAR(90)
    --select * from sivoz_general();
    
);
CREATE OR REPLACE FUNCTION sivoz_general()
RETURNS SETOF sivozgeneral
AS $$
DECLARE
r               sivozgeneral%rowtype;
r_rec           record;
y               integer;
Encabezado      text;
fecha           varchar;
BEGIN
DROP TABLE IF EXISTS copiar;
CREATE TEMP TABLE copiar(
    id      integer,
    fila    text
);
y :=0;
Encabezado :=   
    'CUENTA|SOCIO|NOMBRE|OMISOS|DIAS_MORA|PLAZA|PRODUCTO|RFC|FECHA SALDO'||
    '|SUBCUENTA|ESTATUS|FECHA_DESEMBOLSO|FECHA_CIERRE|CURP|CIUDAD|COLONIA'||
    '|CODIGO_POSTAL|DELEGACION|ESTADO|ENTRECALLE_A|ENTRECALLE_B|REFERENCIA'
    '|CORREO|TELEFONO1|TIPOTEL1|TELEFONO2|TIPOTEL2|TELEFONO3|TIPOTEL3'||
    '|TELEFONO4|TIPOTEL4|TELEFONO5|TIPOTEL5|TELEFONO6|TIPOTEL6|CAPITAL VENCIDO'||
    '|CAPITAL_VIGENTE|INT_CNTS_ORDEN|INT_MORATORIO|INT_VENCIDO|INT_VIGENTE'||
    '|IVA_CTAS_ORDEN|IVA_MORATORIO|IVA_VENCIDO|IVA_VIGENTE|GASTOS_COBRANZA'||
    '|MONTO_AMORTIZACION|MONTO_OTORGADO|PERIODICIDAD|ESTIMACION_CAPITAL_CUBIERTO'||
    '|ESTIMACION_CAPITAL_EXPUESTO|ESTIMACION_INTERES_CUBIERTO|ESTIMACION_INTERES_EXPUESTO'||
    '|RESERVA|FECH_PROX_AMORT|FECH_ULT_PAGO|SALDO_LIQUIDAR|SALDO_VIGENTE'||
    '|FECH_ULT_PAG_INT_NOR|FECHA_ULT_PAG_INT_MOR|FECH_ULT_PAG_CAPI|FECH_PRIM_AMOR_NO_CUBIERTA'||
    '|FECH_OTORGAMIENTO|FECH_NACIMIENTO|AHORRO_ORDINARIO|CUENTA_CORRIENTE|AHORRO_GARANTIA'||
    '|CRED_ACT|1ER AMOR VENC|PLAZO|INGRESOS|GASTOS|TEL TRABAJO|MODALIDAD PAGO'||
    '|SITUACION CONTABLE|FINALIDAD CREDITO|DOMICILIO TRABAJO|OCUPACION'||
    '|TIPO DE CREDITO|DIRECCION SOCIO|DIRECCION TRABAJO|REFERENCIAS TRABAJO'
    ;
RAISE NOTICE '|GENERACION_REPORTE|%', Encabezado;
RAISE NOTICE '|OBTENIENDO_DATOS|';

INSERT INTO copiar VALUES (0,Encabezado);

FOR r_rec IN

SELECT 
    DISTINCT ON(
    a.idorigenp,a.idproducto,a.idauxiliar)  
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) 
    AS "cuenta",
    TRIM(TO_CHAR(p.idorigen,'099999'))||'-'||
    TRIM(TO_CHAR(p.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(p.idsocio,'099999')) 
    AS "socio",
    nombre_x(p.nombre, p.appaterno, p.apmaterno) 
    AS "nombre",
    cv.omisos AS "omisos",
    cv.dias_mora AS "dias_mora",
    o.nombre AS "plaza",
    pr.nombre AS "producto", 
    COALESCE(p.rfc,'No Registrado') AS "rfc", 
    o.fechatrabajo AS "fechasaldo",
    (CASE 
        WHEN pr.tipofinalidad = 1 THEN 'Consumo'
        WHEN pr.tipofinalidad = 2 THEN 'Comercial'
        WHEN pr.tipofinalidad = 3 THEN 'Vivienda'
        END) AS "subcuenta",
    (CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Vigente'
        END) AS "estatus", 
    a.fechaactivacion AS "fecha_desembolso",
    am.fecha_cierre AS "fecha_cierre",
    COALESCE(p.curp,'No Registrado') AS "curp",
    mun.nombre AS "ciudad",
    col.nombre AS "colonia", 
    col.codigopostal AS "cp",
    ' ' AS "delegacion", 
    es.nombre AS "estado", 
    p.entrecalles  AS "calle_A",
    ' ' AS "calle_B", 
    ' ' AS "referencia", 
    COALESCE(p.email,'No Registrado')AS "correo",
    COALESCE(p.telefono,'No Registrado') AS "telefono1", 
    'Casa' AS "tipoTel1", 
    COALESCE(p.celular,'No Registrado') AS "telefono2", 
    'Celular' AS "tipoTel2",
    COALESCE(p.telefonorecados,'No Registrado') AS "telefono3",
    'Recados' AS "tipoTel3",
    COALESCE(tr.telefono,'No Registrado') AS "telefono4",
    'Trabajo1' AS "tipoTel4",
    COALESCE(tr.telefono2,'No Registrado') AS "telefono5",
    'Trabajo2' AS "tipoTel5",
    ' ' AS "telefono6",
    ' ' AS "tipoTel6",
    (CASE 
        WHEN a.cartera = 'V' THEN a.saldo
        END) AS "capital_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.saldo
        END) AS "capital_vigente",
    a.ieco  AS "int_ctas_orden", 
    a.iecom AS "int_moratorio",
    (CASE 
        WHEN a.cartera = 'V' THEN a.idncm
        END) AS "int_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN a.idnc
        END) AS "int_vigente",
    ROUND((a.ieco * (16.00/100)),2) AS "iva_ctas_orden", 
    ROUND((a.iecom * (16.00/100)),2) AS "iva_moratorio", 
    (CASE 
        WHEN a.cartera = 'V' THEN ROUND(a.idncm * (16.00/100),2)
        END) AS "iva_vencido",
    (CASE 
        WHEN a.cartera != 'V' THEN ROUND(a.idnc* (16.00/100),2)
        END)  AS "iva_vigente",
    0 AS "gastos_cobranza",
    am.monto_amortizacion AS "monto_amortizacion",
    a.montoprestado AS "monto_otorgado",
    (CASE WHEN a.pagodiafijo = 1 THEN 30
        WHEN a.pagodiafijo = 0 THEN a.periodoabonos 
        END ) AS "periodicidad",
    eprc_tmp2.e_parte_cub AS "estimacion_capital_cubierto", 
    eprc_tmp2.e_parte_exp AS "estimacion_capital_expuesto",
    eprc_tmp2.e_parte_cub_i AS "estimacion_interes_cubierto", 
    eprc_tmp2.e_parte_exp_i AS "estimacion_interes_expuesto",
    (eprc_tmp2.e_parte_cub + eprc_tmp2.e_parte_exp +
    eprc_tmp2.e_parte_cub_i + eprc_tmp2.e_parte_exp_i)
    AS "reserva",
    am.fecha_prox_amortizacion AS "fecha_prox_amortizacion",
    a.fechauma AS "fecha_ult_pago",
    ((a.idnc + a.ieco) +((a.idnc + a.ieco)*(16.00/100))+
    (a.idncm + a.iecom) +((a.idncm + a.iecom)*(16.00/100))+ a.saldo) 
     AS "saldo_liquidar",
    a.saldo AS "saldo_vigente",
    adx.fecha_ultimo_pago_interes_normal 
    AS "fecha_ultimo_pago_interes_normal",
    adx.fecha_ultimo_pago_de_interes_moratorio 
    AS "fecha_ultimo_pago_de_interes_moratorio",
    adx.fecha_ultimo_pago_a_capital 
    AS "fecha_ultimo_pago_a_capital",
    am.fecha_de_primer_amortizacion_no_cubierta 
    AS "fecha_de_primer_amortizacion_no_cubierta",
    a.fechaactivacion AS "fecha_de_otorgamiento", 
    p.fechanacimiento AS "fecha_de_nacimiento",
    (select COALESCE(a.saldo,0) 
        from auxiliares a 
        where a.idproducto=110 
            and a.idorigen=p.idorigen 
            and a.idgrupo =p.idgrupo 
            and a.idsocio = p.idsocio 
            order by fechaumi desc 
        limit 1) 
    AS "ahorro_ordinario", 
    (select COALESCE(a.saldo,0) 
        from auxiliares a 
        where a.idproducto=130 
            and a.idorigen=p.idorigen 
            and a.idgrupo =p.idgrupo 
            and a.idsocio = p.idsocio 
            order by fechaumi desc limit 1) 
    AS "cuenta_corriente",
    a.garantia AS "ahorro_garantia",
    (SELECT count(*)
        FROM auxiliares a
            INNER JOIN productos pr
            ON a.idproducto = pr.idproducto 
        WHERE a.idorigen = p.idorigen
            AND a.idgrupo = p.idgrupo
            AND a.idsocio = p.idsocio
            AND a.estatus = 2
            AND pr.tipoproducto = 2
            ) 
    AS "creditos_activos",
    am.primer_amortizacion_vencida
    AS "primer_amortizacion_vencida",
    a.plazo AS "plazo",
    tr.ing_mensual_bruto AS "ingresos",
    tr.deducciones_deudas AS "gastos",
    tr.telefono AS "tel_trabajo",
    (CASE 
        WHEN a.plazo = 1 THEN 'Pago Unico' 
        WHEN a.plazo != 1 THEN 'Pago Periodico' 
        END) AS "modalidad_de_pago",
    (CASE 
        WHEN a.cartera = 'V' THEN 'Vencido'
        WHEN a.cartera !='V' THEN 'Corriente'
        END) AS "situacion_contable", 
    f.descripcion AS "finalidad_credito", 
    tr.nombre AS "donde_trabaja",
    tr.ocupacion AS "ocupacion",
    (CASE 
        WHEN a.tipoprestamo = 0 THEN 'Normal' 
        WHEN a.tipoprestamo IN (1,3) THEN 'Renovado' 
        WHEN a.tipoprestamo IN (2,4) THEN 'Reestructurado'
        END) AS "tipo_de_credito",
    (p.calle ||' '||p.numeroext)  AS "direccion_del_socio",
    (tr.calle ||' '||tr.numero)  AS "direccion_trabajo",
    ' ' AS "referencias_de_direccion_de_trabajo"
from auxiliares a
INNER JOIN personas p 
USING (idorigen,idgrupo,idsocio)
INNER JOIN origenes o
ON a.idorigenp = o.idorigen
INNER JOIN productos pr
ON a.idproducto = pr.idproducto
INNER JOIN colonias col
ON p.idcolonia = col.idcolonia
INNER JOIN municipios mun
ON col.idmunicipio = mun.idmunicipio
INNER JOIN estados es
ON mun.idestado = es.idestado
INNER JOIN finalidades f
ON a.idfinalidad = f.idfinalidad
INNER JOIN trabajo tr
ON p.idorigen = tr.idorigen
AND p.idgrupo = tr.idgrupo
AND p.idsocio = tr.idsocio
INNER JOIN eprc_tmp2
ON a.idorigen= eprc_tmp2.idorigen AND a.idgrupo = eprc_tmp2.idgrupo AND a.idsocio = eprc_tmp2.idsocio
AND a.idorigenp= eprc_tmp2.idorigenp AND a.idproducto = eprc_tmp2.idproducto AND a.idauxiliar = eprc_tmp2.idauxiliar
---LEFT JOIN HACIA AUXILIARES_D
LEFT JOIN (
    SELECT 
    auxd.idorigenp,auxd.idproducto,auxd.idauxiliar,
    MAX(auxd.fecha) 
    FILTER (WHERE auxd.tipomov !=3 AND auxd.cargoabono =1 AND auxd.montoio >0)
    AS fecha_ultimo_pago_interes_normal,
    MAX(auxd.fecha)
    FILTER (WHERE auxd.tipomov !=3 AND auxd.cargoabono =1 AND auxd.montoim >0)
    AS fecha_ultimo_pago_de_interes_moratorio,
    MAX(auxd.fecha) 
    FILTER (WHERE auxd.tipomov !=3 AND auxd.cargoabono =1 AND auxd.monto   >0)
    AS fecha_ultimo_pago_a_capital
    FROM auxiliares_d auxd
    GROUP BY auxd.idorigenp, auxd.idproducto, auxd.idauxiliar
) adx   ON    a.idorigenp = adx.idorigenp
        AND   a.idproducto = adx.idproducto
        AND   a.idauxiliar = adx.idauxiliar
---LEFT JOIN HACIA CARTERA VENCIDA
LEFT JOIN (
    SELECT 
    cv1.idorigenp,cv1.idproducto,cv1.idauxiliar,
    cv1.abonosvencidos::integer AS omisos,
    cv1.diasvencidos AS dias_mora
    --SUM(cv1.saldo + cv1.io + cv1.im) AS saldo_liquidar
    FROM carteravencida cv1
    GROUP BY cv1.idorigenp,cv1.idproducto,cv1.idauxiliar,cv1.abonosvencidos,
    cv1.diasvencidos,cv1.saldo, cv1.io , cv1.im
) cv   ON     a.idorigenp   = cv.idorigenp
        AND   a.idproducto  = cv.idproducto
        AND   a.idauxiliar  = cv.idauxiliar
---LEFT JOIN HACIA AMORTIZACIONES
LEFT JOIN (
    SELECT 
    am1.idorigenp,am1.idproducto,am1.idauxiliar,
    MAX(am1.vence) 
    FILTER (WHERE am1.todopag = 'f' AND am1.atiempo = 'f')
    AS fecha_cierre,
    SUM(am1.abono + am1.io)
    FILTER (WHERE am1.atiempo = 'f' AND am1.todopag = 'f')
    AS monto_amortizacion,
    MIN(am1.vence)
    FILTER (WHERE am1.atiempo = 'f' AND am1.todopag = 'f')
    AS fecha_prox_amortizacion,
    MAX(am1.vence)
    FILTER (WHERE am1.atiempo = 'f' AND am1.todopag = 't')
    AS fecha_de_primer_amortizacion_no_cubierta,
    SUM(am1.abono + am1.io)
    FILTER (WHERE am1.atiempo = 'f' AND am1.todopag = 'f')
    AS primer_amortizacion_vencida
    FROM amortizaciones am1
    GROUP BY am1.idorigenp,am1.idproducto,am1.idauxiliar
) am   ON     a.idorigenp   = am.idorigenp
        AND   a.idproducto  = am.idproducto
        AND   a.idauxiliar  = am.idauxiliar
WHERE p.estatus = 't'
    AND p.idgrupo = 10
    AND a.idproducto BETWEEN 30000 AND 39999
    AND a.estatus = 2
LOOP 

r.cuenta                      := r_rec."cuenta";
r.socio                       := r_rec."socio";
r.nombre                      := r_rec."nombre";
r.omisos                      := r_rec."omisos";
r.dias_mora                   := r_rec."dias_mora";
r.plaza                       := r_rec."plaza";
r.producto                    := r_rec."producto";
r.rfc                         := r_rec."rfc";
r.fechasaldo                  := r_rec."fechasaldo";
r.subcuenta                   := r_rec."subcuenta";
r.estatus                     := r_rec."estatus";
r.fecha_desembolso            := r_rec."fecha_desembolso";
r.fecha_cierre                := r_rec."fecha_cierre";
r.curp                        := r_rec."curp";
r.ciudad                      := r_rec."ciudad";
r.colonia                     := r_rec."colonia";
r.cp                          := r_rec."cp";
r.delegacion                  := r_rec."delegacion";
r.estado                      := r_rec."estado";
r.calle_A                     := r_rec."calle_A";
r.calle_B                     := r_rec."calle_B";
r.referencia                  := r_rec."referencia";
r.correo                      := r_rec."correo";
r.telefono1                   := r_rec."telefono1";
r.tipoTel1                    := r_rec."tipoTel1";
r.telefono2                   := r_rec."telefono2";
r.tipoTel2                    := r_rec."tipoTel2";
r.telefono3                   := r_rec."telefono3";
r.tipoTel3                    := r_rec."tipoTel3";
r.telefono4                   := r_rec."telefono4";
r.tipoTel4                    := r_rec."tipoTel4";
r.telefono5                   := r_rec."telefono5";
r.tipoTel5                    := r_rec."tipoTel5";
r.telefono6                   := r_rec."telefono6";
r.tipoTel6                    := r_rec."tipoTel6";
r.capital_vencido             := r_rec."capital_vencido";
r.capital_vigente             := r_rec."capital_vigente";
r.int_ctas_orden              := r_rec."int_ctas_orden";
r.int_moratorio               := r_rec."int_moratorio";
r.int_vencido                 := r_rec."int_vencido";
r.int_vigente                 := r_rec."int_vigente";
r.iva_ctas_orden              := r_rec."iva_ctas_orden";
r.iva_moratorio               := r_rec."iva_moratorio";
r.iva_vencido                 := r_rec."iva_vencido";
r.iva_vigente                 := r_rec."iva_vigente";
r.gastos_cobranza             := r_rec."gastos_cobranza";
r.monto_amortizacion          := r_rec."monto_amortizacion";
r.monto_otorgado              := r_rec."monto_otorgado";
r.periodicidad                := r_rec."periodicidad";
r.estimacion_capital_cubierto := r_rec."estimacion_capital_cubierto";
r.estimacion_capital_expuesto := r_rec."estimacion_capital_expuesto";
r.estimacion_interes_cubierto := r_rec."estimacion_interes_cubierto";
r.estimacion_interes_expuesto := r_rec."estimacion_interes_expuesto";
r.reserva                     := r_rec."reserva";
r.fecha_prox_amortizacion     := r_rec."fecha_prox_amortizacion";
r.fecha_ult_pago              := r_rec."fecha_ult_pago";
r.saldo_liquidar              := r_rec."saldo_liquidar";
r.saldo_vigente               := r_rec."saldo_vigente";
r.fecha_ultimo_pago_interes_normal  := r_rec."fecha_ultimo_pago_interes_normal";
r.fecha_ultimo_pago_de_interes_moratorio := r_rec."fecha_ultimo_pago_de_interes_moratorio";
r.fecha_ultimo_pago_a_capital := r_rec."fecha_ultimo_pago_a_capital";
r.fecha_de_primer_amortizacion_no_cubierta := r_rec."fecha_de_primer_amortizacion_no_cubierta";
r.fecha_de_otorgamiento       := r_rec."fecha_de_otorgamiento";
r.fecha_de_nacimiento         := r_rec."fecha_de_nacimiento";
r.ahorro_ordinario            := r_rec."ahorro_ordinario";
r.cuenta_corriente            := r_rec."cuenta_corriente";
r.ahorro_garantia             := r_rec."ahorro_garantia";
r.creditos_activos            := r_rec."creditos_activos";
r.primer_amortizacion_vencida := r_rec."primer_amortizacion_vencida";
r.plazo                       := r_rec."plazo";
r.ingresos                    := r_rec."ingresos";
r.gastos                      := r_rec."gastos";
r.tel_trabajo                 := r_rec."tel_trabajo";
r.modalidad_de_pago           := r_rec."modalidad_de_pago";
r.situacion_contable          := r_rec."situacion_contable";
r.finalidad_credito           := r_rec."finalidad_credito";
r.donde_trabaja               := r_rec."donde_trabaja";
r.ocupacion                   := r_rec."ocupacion";
r.tipo_de_credito             := r_rec."tipo_de_credito";
r.direccion_del_socio         := r_rec."direccion_del_socio";
r.direccion_trabajo           := r_rec."direccion_trabajo";
r.referencias_de_direccion_de_trabajo := r_rec."referencias_de_direccion_de_trabajo";





INSERT INTO copiar VALUES (y,
    COALESCE(r.cuenta,'NR')                      ||'|'||
    COALESCE(r.socio,'NR')                       ||'|'||
    COALESCE(r.nombre,'NR')                      ||'|'||
    COALESCE(r.omisos,0)                         ||'|'||
    COALESCE(r.dias_mora,0)                      ||'|'||
    COALESCE(r.plaza,'NR')                       ||'|'||
    COALESCE(r.producto,'NR')                    ||'|'||
    COALESCE(r.rfc,'NR')                         ||'|'||
    COALESCE(r.fechasaldo,'01-01-1900')          ||'|'||
    COALESCE(r.subcuenta,'NR')                   ||'|'||
    COALESCE(r.estatus,'NR')                     ||'|'||
    COALESCE(r.fecha_desembolso,'01-01-1900')    ||'|'||
    COALESCE(r.fecha_cierre,'01-01-1900')        ||'|'||
    COALESCE(r.curp,'NR')                        ||'|'||
    COALESCE(r.ciudad,'NR')                      ||'|'||
    COALESCE(r.colonia,'NR')                     ||'|'||
    COALESCE(r.cp,0)                             ||'|'||
    COALESCE(r.delegacion,'NR')                  ||'|'||
    COALESCE(r.estado,'NR')                      ||'|'||
    COALESCE(r.calle_A,'NR')                     ||'|'||
    COALESCE(r.calle_B,'NR')                     ||'|'||
    COALESCE(r.referencia,'NR')                  ||'|'||
    COALESCE(r.correo,'NR')                      ||'|'||
    COALESCE(r.telefono1,'NR')                   ||'|'||
    COALESCE(r.tipoTel1,'NR')                    ||'|'||                         
    COALESCE(r.telefono2,'NR')                   ||'|'||
    COALESCE(r.tipoTel2,'NR')                    ||'|'||                         
    COALESCE(r.telefono3,'NR')                   ||'|'||
    COALESCE(r.tipoTel3,'NR')                    ||'|'||                         
    COALESCE(r.telefono4,'NR')                   ||'|'||
    COALESCE(r.tipoTel4,'NR')                    ||'|'||                         
    COALESCE(r.telefono5,'NR')                   ||'|'||
    COALESCE(r.tipoTel5,'NR')                    ||'|'||                         
    COALESCE(r.telefono6,'NR')                   ||'|'||
    COALESCE(r.tipoTel6,'NR')                    ||'|'||
    COALESCE(r.capital_vencido,0)                ||'|'||
    COALESCE(r.capital_vigente,0)                ||'|'||
    COALESCE(r.int_ctas_orden,0)                 ||'|'||
    COALESCE(r.int_moratorio,0)                  ||'|'||
    COALESCE(r.int_vencido,0)                    ||'|'||
    COALESCE(r.int_vigente,0)                    ||'|'||
    COALESCE(r.iva_ctas_orden,0)                 ||'|'||
    COALESCE(r.iva_moratorio,0)                  ||'|'||
    COALESCE(r.iva_vencido,0)                    ||'|'||
    COALESCE(r.iva_vigente,0)                    ||'|'||
    COALESCE(r.gastos_cobranza,0)                ||'|'||
    COALESCE(r.monto_amortizacion,0)             ||'|'||
    COALESCE(r.monto_otorgado,0)                 ||'|'||
    COALESCE(r.periodicidad,0)                   ||'|'||
    COALESCE(r.estimacion_capital_cubierto,0)    ||'|'||
    COALESCE(r.estimacion_capital_expuesto,0)    ||'|'||
    COALESCE(r.estimacion_interes_cubierto,0)    ||'|'||
    COALESCE(r.estimacion_interes_expuesto,0)    ||'|'||
    COALESCE(r.reserva,0)                        ||'|'||
    COALESCE(r.fecha_prox_amortizacion,'01-01-1900') ||'|'||
    COALESCE(r.fecha_ult_pago,'01-01-1900')      ||'|'||
    COALESCE(r.saldo_liquidar,0)                 ||'|'||
    COALESCE(r.saldo_vigente,0)                  ||'|'||
    COALESCE(r.fecha_ultimo_pago_interes_normal,'01-01-1900') ||'|'||
    COALESCE(r.fecha_ultimo_pago_de_interes_moratorio,'01-01-1900') ||'|'||
    COALESCE(r.fecha_ultimo_pago_a_capital,'01-01-1900')    ||'|'||
    COALESCE(r.fecha_de_primer_amortizacion_no_cubierta,'01-01-1900')   ||'|'||
    COALESCE(r.fecha_de_otorgamiento,'01-01-1900') ||'|'||
    COALESCE(r.fecha_de_nacimiento,'01-01-1900') ||'|'||
    COALESCE(r.ahorro_ordinario,0)               ||'|'||
    COALESCE(r.cuenta_corriente,0)               ||'|'||
    COALESCE(r.ahorro_garantia,0)                ||'|'||
    COALESCE(r.creditos_activos,0)               ||'|'||
    COALESCE(r.primer_amortizacion_vencida,0)    ||'|'||
    COALESCE(r.plazo,0)                          ||'|'||
    COALESCE(r.ingresos,0)                       ||'|'||
    COALESCE(r.gastos,0)                         ||'|'||
    COALESCE(r.tel_trabajo,' ')                  ||'|'||   
    COALESCE(r.modalidad_de_pago,' ')            ||'|'||
    COALESCE(r.situacion_contable,' ')           ||'|'||
    COALESCE(r.finalidad_credito,' ')            ||'|'||
    COALESCE(r.donde_trabaja,' ')                ||'|'||
    COALESCE(r.ocupacion,' ')                    ||'|'||
    COALESCE(r.tipo_de_credito,' ')              ||'|'||
    COALESCE(r.direccion_del_socio,' ')          ||'|'||
    COALESCE(r.direccion_trabajo,' ')            ||'|'||
    COALESCE(r.referencias_de_direccion_de_trabajo,' ')
    );
--select * from sivoz_general();
y := y+1;
RETURN NEXT r;
END LOOP;

    select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
    execute 'copy (select fila from copiar order by id) to ''/tmp/sivoz_general_ce_'||fecha||'.csv'' ';
    execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_general_se_'||fecha||'.csv'' ';

END;
$$ LANGUAGE plpgsql;