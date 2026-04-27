--select * from sivoz_cc();
DROP TYPE IF EXISTS cc CASCADE;
--CREA DE NUEVO EL TYPE EN CASO DE HABER MODIFICACION 'cc' debe ir en 3 lugares
--1.-CREATE TYPE cc 
--2.-RETURNS SETOF cc
--3.-r  cc%rowtype;
--NOTA: Para la generacion del reporte en saicoop si ocupo los S1 como separadores
--En los encabezados es diferente, Se creo el type acorde a los alias de la subconsulta
CREATE TYPE cc AS (
    socio                                          VARCHAR(30),
    s1                                             text,
    cuenta                                         VARCHAR(30),
    s2                                             text,
    nombre                                         VARCHAR(100),
    s3                                             text,
    estatus                                        VARCHAR(10),
    s4                                             text,
    saldo_disponible                               numeric(14,2),
    s5                                             text,
    saldo_retenido                                 numeric(14,2),
    s6                                             text,
    saldo_sbc                                      numeric(14,2),
    s7                                             text,
    saldo_total                                    numeric(14,2),
    s8                                             text,
    interes_dia                                    numeric(14,2)
);
CREATE OR REPLACE FUNCTION sivoz_cc()
RETURNS SETOF cc
AS $$
DECLARE
r  cc%rowtype;
r_rec  record;
y  integer;
Encabezado  text;
fecha       varchar;
BEGIN

drop table if exists copiar;
  create temp table copiar(
  id  integer,
  fila   text
  );
--EL ENCABEZADO TIENE QUE IR ANTES DEL BEGIN, ESTO SE MUESTRA EN EL CSV puede tener espacios
y:=0;
Encabezado:= 'SOCIO|CUENTA|NOMBRE|ESTATUS|SALDO DISPONIBLE|' 
             ||'SALDO RETENIDO|SALDO SBC|SALDO TOTAL|INTERES DIA';
RAISE NOTICE '|GENERACION_REPORTE|%',Encabezado;
RAISE NOTICE '|OBTENIENDO_DATOS|';
--SE INSERTA EL ENCABEZADO EN LA TABLA EN LA PRIMERA POSICION DEL ID 
insert into copiar values(0,Encabezado);
    
for r_rec in 
select 
    TRIM(TO_CHAR(a.idorigen,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idgrupo,'09'))||'-'||
    TRIM(TO_CHAR(a.idsocio,'099999')) 
    AS "ogs",
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) 
    AS "cuenta",
    pr.nombre AS "nombre",
    'NA' AS "estatus",
    (a.saldo - a.garantia) AS "saldo_disponible",
    a.garantia AS "saldo_retenido",
    (select a1.saldo 
      from auxiliares a1
      where a1.idorigen = a.idorigen
        and a1.idgrupo = a.idgrupo
        and a1.idsocio = a.idsocio
        and a1.idproducto = 101
      limit 1) AS "saldo_sbc",
    a.saldo AS "saldo_total",
    0.00 AS "interes_dia"
  from  auxiliares a
    LEFT JOIN personas p 
      using(idorigen,idgrupo,idsocio)
    LEFT JOIN productos pr
      ON a.idproducto = pr.idproducto
  where  a.estatus=2
      AND     p.idgrupo = 10 
      AND     p.estatus = 't'
      AND     a.idproducto IN (110,130,11208,11222,101)
  ORDER BY p.idorigen, p.idgrupo, p.idsocio
loop
---AQUI DEFINE QUE DATOS VOY A GUARDAR Y EN DONDE
---TODO LO GUARDA EN 'R' para mostrar info pero previamente fue almacenado en el FOR 
-- A traves del 'R_REC.ALIAS'
--ESTO SIRVE PARA GENERAR EL REPORTE EN SAICOOP 
r.socio                       := r_rec."ogs";
r.s1                          := '|';
r.cuenta                      := r_rec."cuenta";
r.s2                          := '|';
r.nombre                      := r_rec."nombre";
r.s3                          := '|';
r.estatus                     := r_rec."estatus";
r.s4                          := '|';
r.saldo_disponible            := r_rec."saldo_disponible";
r.s5                          := '|';
r.saldo_retenido              := r_rec."saldo_retenido";
r.s6                          := '|';
r.saldo_sbc                   := r_rec."saldo_sbc";
r.s7                          := '|';
r.saldo_total                 := r_rec."saldo_total";
r.s8                          := '|';
r.interes_dia                 := r_rec."interes_dia";
--SIN IMPORTAR LOS 'R.S123' puedo seleccionar que datos guardar en mi CSV concatenado por | ya que la tabla copias lo inserta con el elemento FILA 
insert into copiar values(y,
 coalesce(r.socio::text,'') ||'|'||
 coalesce(r.cuenta::text,'') ||'|'||
 coalesce(r.nombre::text,'') ||'|'||
 coalesce(r.estatus::text,'') ||'|'||
 COALESCE(r.saldo_disponible, 0.00) ||'|'||
 COALESCE(r.saldo_retenido, 0.00) ||'|'||
 COALESCE(r.saldo_sbc, 0.00) ||'|'||
 COALESCE(r.saldo_total, 0.00) ||'|'||
 COALESCE(r.interes_dia, 0.00)  
 );
  y:=y+1;

return next r;
end loop;

  select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
  execute 'copy (select fila from copiar order by id) to ''/tmp/sivoz_cc_ce_'||fecha||'.csv''  ';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_cc_se_'||fecha||'.csv''  ';
END;
$$ LANGUAGE plpgsql;
