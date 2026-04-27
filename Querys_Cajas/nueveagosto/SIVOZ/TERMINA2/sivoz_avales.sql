--select * from sivoz_avales();
DROP TYPE IF EXISTS avales CASCADE;
CREATE TYPE avales AS (
    cuenta                                          VARCHAR(50),
    s1                                              text,
    nombre                                          VARCHAR(100),
    s2                                              text,    
    calle                                           VARCHAR(80),
    s3                                              text,
    colonia                                         VARCHAR(80),
    s4                                              text,
    ciudad                                          VARCHAR(50),
    s5                                              text,
    cp                                              VARCHAR(10),
    s6                                              text,
    delegacion                                      VARCHAR(50),
    s7                                              text,
    estado                                          VARCHAR(30),
    s8                                              text,
    relacion                                        VARCHAR(20),
    s9                                              text,
    curp                                            VARCHAR(20),
    s10                                              text,
    socio                                           VARCHAR(30),
    s11                                              text,
    tipo                                            VARCHAR(20),
    s12                                              text,
    telefono1                                       VARCHAR(20),
    s13                                              text,
    telefono2                                       VARCHAR(20),
    s14                                              text,
    telefono3                                       VARCHAR(20),
    s15                                              text,
    calle_a                                         VARCHAR(50),
    s16                                              text,
    calle_b                                         VARCHAR(20)
);
CREATE OR REPLACE FUNCTION sivoz_avales()
RETURNS SETOF avales
AS $$
DECLARE
r           avales%rowtype;
r_rec       record;
y  integer;
Encabezado  text;
fecha       varchar;
BEGIN
drop table if exists copiar;
  create temp table copiar(
  id  integer,
  fila   text
  );
y:=0;
Encabezado:= 'CUENTA|NOMBRE|CALLE|COLONIA|CIUDAD|CP|DELEGACION|'||
              'ESTADO|RELACION|CURP|SOCIO|TIPO|TELEFONO1|'||
              'TELEFONO2|TELEFONO3|CALLE_A|CALLE_B';
RAISE NOTICE '|GENERACION_REPORTE_AVALES|%',Encabezado;
RAISE NOTICE '|OBTENIENDO_DATOS|';
insert into copiar values(0,Encabezado);

for r_rec in 
SELECT DISTINCT ON
        (a.idorigenp, a.idproducto, a.idauxiliar)
        TRIM(TO_CHAR(a.idorigenp,'099999'))||'-'||
        TRIM(TO_CHAR(a.idproducto,'099999'))||'-'||
        TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "cuenta",
        TRIM(p.nombre||' '||p.appaterno||' '||p.apmaterno) AS "nombre",
        (SELECT p.calle
            from personas p where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "calle",
        (SELECT col.nombre
            from colonias col
            INNER JOIN personas p1
            ON p1.idcolonia = col.idcolonia
            where p1.idorigen=rf.idorigen 
            and p1.idgrupo =rf.idgrupo and p1.idsocio = rf.idsocio
            and p1.idcolonia = col.idcolonia)
        AS "colonia",
        (SELECT mun.nombre
            from municipios mun
            INNER JOIN colonias col 
            on mun.idmunicipio=col.idmunicipio
            INNER JOIN personas p2
            ON p2.idcolonia = col.idcolonia
            where p2.idorigen=rf.idorigen 
            and p2.idgrupo =rf.idgrupo and p2.idsocio = rf.idsocio
            and p2.idcolonia = col.idcolonia)
        AS "ciudad",
        (SELECT col.codigopostal
            from colonias col
            INNER JOIN personas p1
            ON p1.idcolonia = col.idcolonia
            where p1.idorigen=rf.idorigen 
            and p1.idgrupo =rf.idgrupo and p1.idsocio = rf.idsocio
            and p1.idcolonia = col.idcolonia)
        AS "cp",
        'NA' AS "delegacion",
        (SELECT est.nombre
            from estados est
            INNER JOIN municipios mun 
            on est.idestado =mun.idestado
            INNER JOIN colonias col 
            on mun.idmunicipio=col.idmunicipio
            INNER JOIN personas p3
            ON p3.idcolonia = col.idcolonia
            where p3.idorigen=rf.idorigen 
            and p3.idgrupo =rf.idgrupo and p3.idsocio = rf.idsocio
            and p3.idcolonia = col.idcolonia)
        AS "estado",
        (select descripcion from catalogo_menus cat
              where menu = 'referenciap' 
              and opcion = rf.tiporeferencia
              AND rf.tiporeferencia in (8,0,1,6,7,9,11,12,13,14,15,16,21)) 
              as "relacion",
        (SELECT p.curp
            from personas p where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "curp",
        TRIM(TO_CHAR(rf.idorigen,'099999'))||'-'||
        trim(to_char(rf.idgrupo,'09'))||'-'||
        trim(TO_CHAR(rf.idsocio,'099999')) AS "socio",
        (CASE 
            WHEN rf.tiporeferencia = 8  THEN 'Aval'
            WHEN rf.tiporeferencia != 8 THEN 'Referencia' 
            END) AS "tipo",
        (SELECT p.telefono
            from personas p where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "telefono1",
        (SELECT p.celular
            from personas p where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "telefono2",
        (SELECT p.telefonorecados
            from personas p 
            where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "telefono3",
        (SELECT p.entrecalles
            from personas p where p.idorigen=rf.idorigen 
            and p.idgrupo =rf.idgrupo and p.idsocio = rf.idsocio)
        AS "calle_a",
        '' AS "calle_b" 
      FROM referencias rf
            INNER JOIN personas p ON (p.idorigen = rf.idorigenr 
                AND p.idgrupo = rf.idgrupor 
                AND p.idsocio = rf.idsocior)
            INNER JOIN v_auxiliares a 
                  ON (split_part(rf.referencia,'|',2) = TRIM(TO_CHAR(a.idorigenp,'099999'))
                  AND split_part(rf.referencia,'|',3) = TRIM(TO_CHAR(a.idproducto,'09999'))
                  AND split_part(rf.referencia,'|',4) = TRIM(TO_CHAR(a.idauxiliar,'09999999')))
            RIGHT JOIN catalogo_menus cat
            ON menu = 'referenciap'
      WHERE rf.tiporeferencia in (8) 
            AND p.estatus = 't'
            AND a.estatus= 2
      ORDER BY a.idorigenp, a.idproducto, a.idauxiliar DESC
loop

r.cuenta                      := r_rec."cuenta";
r.s1                          := '|';
r.nombre                      := r_rec."nombre";
r.s2                          := '|';
r.calle                       := r_rec."calle";
r.s3                          := '|';
r.colonia                     := r_rec."colonia";
r.s4                          := '|';
r.ciudad                      := r_rec."ciudad";
r.s5                          := '|';
r.cp                          := r_rec."cp";
r.s6                          := '|';
r.delegacion                  := r_rec."delegacion";
r.s7                          := '|';
r.estado                      := r_rec."estado";
r.s8                          := '|';
r.relacion                    := r_rec."relacion";
r.s9                          := '|';
r.curp                        := r_rec."curp";
r.s10                          := '|';
r.socio                       := r_rec."socio";
r.s11                          := '|';
r.tipo                        := r_rec."tipo";
r.s12                          := '|';
r.telefono1                   := r_rec."telefono1";
r.s13                          := '|';
r.telefono2                   := r_rec."telefono2";
r.s14                          := '|';
r.telefono3                   := r_rec."telefono3";
r.s15                          := '|';
r.calle_a                     := r_rec."calle_a";
r.s16                          := '|';
r.calle_b                     := r_rec."calle_b";

insert into copiar values(y,
    COALESCE(NULLIF(r.cuenta,''),'')    || '|' ||
    COALESCE(NULLIF(r.nombre,''),'')    || '|' ||
    COALESCE(NULLIF(r.calle,''),'')     || '|' ||
    COALESCE(NULLIF(r.colonia,''),'')   || '|' ||
    COALESCE(NULLIF(r.ciudad,''),'')    || '|' ||
    COALESCE(NULLIF(r.cp,''),'')        || '|' ||
    COALESCE(NULLIF(r.delegacion,''),'')|| '|' ||
    COALESCE(NULLIF(r.estado,''),'')    || '|' ||
    COALESCE(NULLIF(r.relacion,''),'')  || '|' ||
    COALESCE(NULLIF(r.curp,''),'')      || '|' ||
    COALESCE(NULLIF(r.socio,''),'')     || '|' ||
    COALESCE(NULLIF(r.tipo,''),'')      || '|' ||
    COALESCE(NULLIF(r.telefono1,''),'') || '|' ||
    COALESCE(NULLIF(r.telefono2,''),'') || '|' ||
    COALESCE(NULLIF(r.telefono3,''),'') || '|' ||
    COALESCE(NULLIF(r.calle_a,''),'')   || '|' ||
    COALESCE(NULLIF(r.calle_b,''),'')
);
  y:=y+1;

return next r;
end loop;

  select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
  execute 'copy (select fila from copiar order by id) to ''/tmp/sivoz_avales_ce_'||fecha||'.csv''  ';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_avales_se_'||fecha||'.csv''  ';
END;
$$ LANGUAGE plpgsql;