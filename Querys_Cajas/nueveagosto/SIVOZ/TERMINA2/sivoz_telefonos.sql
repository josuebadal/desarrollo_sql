--select * from sivoz_telefonos();
DROP TYPE IF EXISTS telefonos CASCADE;
CREATE TYPE telefonos AS (
    cuenta                                          VARCHAR(50),
    --s1                                              text,
    telefono                                        VARCHAR(20),
    --s2                                              text,
    tipo1                                           VARCHAR(10),
    --s3                                              text,
    celular                                         VARCHAR(20),
    --s4                                              text,
    tipo2                                           VARCHAR(10),
    --s5                                              text,
    recados                                         VARCHAR(20),
    --s6                                              text,
    tipo3                                           VARCHAR(10),
    --s7                                              text,
    extension                                       VARCHAR(5)
    
);
CREATE OR REPLACE FUNCTION sivoz_telefonos()
RETURNS SETOF telefonos
AS $$
DECLARE
r           telefonos%rowtype;
r_rec       record;
y  integer;
Encabezado  text;
--esta fecha se declara para la generacion del archivo CSV
fecha       varchar;
BEGIN

drop table if exists copiar;
  create temp table copiar(
  id  integer,
  fila   text
  );
--EL ENCABEZADO TIENE QUE IR ANTES DEL BEGIN, ESTO SE MUESTRA EN EL CSV puede tener espacios
y:=0;
Encabezado:= 'CUENTA|TELEFONO|TIPO1|CELULAR|TIPO2|RECADOS|TIPO3|EXTENSION';
RAISE NOTICE '|GENERACION_REPORTE_TELEFONOS|%',Encabezado;
RAISE NOTICE '|OBTENIENDO_DATOS|';
--y :=1;
--SE INSERTA EL ENCABEZADO EN LA TABLA EN LA PRIMERA POSICION DEL ID 
insert into copiar values(0,Encabezado);

for r_rec in 
SELECT 
    DISTINCT ON(a.idorigenp,a.idproducto,a.idauxiliar)
        TRIM(TO_CHAR(a.idorigenp,'099999'))|| '-'||
        TRIM(TO_CHAR(a.idproducto,'09999')) || '-'||
        TRIM(TO_CHAR(a.idauxiliar,'09999999')) 
        AS "cuenta",
        p.telefono AS "telefono",
        p.celular AS "celular",
        p.telefonorecados AS "recados",
        ' ' AS "extension"
    FROM auxiliares a
        INNER JOIN personas p
        ON a.idorigen = p.idorigen AND a.idgrupo = p.idgrupo
        AND a.idsocio = p.idsocio 
    where a.estatus = 2
        AND p.estatus = 't'
        AND a.idproducto between 30000 AND 39999
    --AQUI VA EL QUERY QUE SE DEBE CUMPLIR
loop

r.cuenta                      := r_rec."cuenta";
--r.s1                          := '|';
r.telefono                    := r_rec."telefono";
--r.s2                          := '|';
r.tipo1                        := 'Casa';
--r.s3                          := '|';
r.celular                     := r_rec."celular";
--r.s4                          := '|';
r.tipo2                        := 'Celular';
--r.s5                          := '|';
r.recados                     := r_rec."recados";
--r.s6                          := '|';
r.tipo3                        := 'Recados';
--r.s7                          := '|';
r.extension                   := r_rec."extension";
    

--SIN IMPORTAR LOS 'R.S123' puedo seleccionar que datos guardar en mi CSV concatenado por | 
--ya que la tabla copias lo inserta con el elemento FILA 
insert into copiar values(y,
 coalesce(r.cuenta,' ')     ||'|'||
 coalesce(r.telefono,' ')   ||'|'||
 coalesce(r.tipo1,' ')      ||'|'||
 coalesce(r.celular,' ')    ||'|'||
 coalesce(r.tipo2,' ')      ||'|'||
 coalesce(r.recados,' ')    ||'|'||
 coalesce(r.tipo3,' ')
 );
  y:=y+1;

return next r;
end loop;

  select into fecha to_char(CURRENT_DATE,'dd-mm-yyyy');
  execute 'copy (select fila from copiar order by id) to ''/tmp/sivoz_telefonos_ce_'||fecha||'.csv''  ';
  execute 'copy (select fila from copiar where id > 0 order by id) to ''/tmp/sivoz_telefonos_se_'||fecha||'.csv''  ';
END;
$$ LANGUAGE plpgsql;