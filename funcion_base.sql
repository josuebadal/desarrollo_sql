/*CAJA FAMA  
Buen dia Ingeniero,
Nos puede apoyar con un reporte donde podamos revisar la activad laboral de los socios que tenemos en Cartera morosa y vencida y los salarios registrados en sistema, para asi poder clasificar mejor la situacion de nuestros socios. 
Como le comente, de momento estamos interesados especificamente en los socios que son taxistas (taxi propio o en renta, con concesion a nombre propio o en renta), y conductores de aplicacion (Uber, Didi, Rappi, etc., tanto transporte como comida).
La informacion que me interesa es la siguiente:*/

--NOTA: LA FUNCION nombre_x no esta cargada en CAPITAL ACTIVO

----- SIEMPRE BORRAMOS EL TYPE EN CASCADA PARA EVITAR AFECTACIONES
DROP TYPE IF EXISTS 2do_ejer CASCADE;
-----CREAMOS EL TYPE,TODO LO QUE ALMACENARA, SE LLAMA MEDIANTE ejer2%rowtype, NOTA EL TYPE SUELE HACERSE POR SEPARADO PERO POR ESTA OCASION LO INCLUIMOS AQUI
CREATE TYPE 2do_ejer AS (
cuenta                                          VARCHAR(50)
);

-----CREACION LA FUNCION EN ESTE CASO NO RECIBE PARAMETROS
CREATE OR REPLACE FUNCTION ejer2()
RETURN SETOF ejer2
AS $$
-----DECLARAMOS LO NECESARIO PARA EL PROCESO Y ALMACENAR DATOS
DECLARE
------DECLARAMOS QUERY PERO NO SE USO ESTA FUNCION ES ESTATICA NO ES QUERY DINAMICO COMO EL REG 841
query               text;
----- r guardara todo lo que deseamos pero al ser ROWTYPE solo guardara la info que este declara ahi 
r                   ejer2%rowtype;
----- record se declara porque hace todo el recorrido de mi query y ahi guarda los datos
r_rec               record;
----- se clara 'y' que sirve como id en la tabla final
y                   integer;
----- se declara encabezado que se usara en el archivo a generar
Encabezado          text;
----- se declara la fecha ya que se manda a llamar al generar el formato final y excute
fecha               varchar;

----- INICIA LA FUNCION Y ACABO LA DECLARACION DE VARIABLES
BEGIN
----- BORRAMOS LA TABLA EN CASO DE EXISTIR PARA TENER UN MEJOR CONTROL AL EJECUTAR EL PROCESO
DROP TABLE IF EXISTS copiar;
----- SE CREA LA TABLA TEMPORAL EN DONDE ALMACENARA TODO LO TRAIDO DE MI QUERY ESTATICO
CREATE TEMP TABLE copiar(
----- SE DECLARA ID PARA LA TABLA PERO EN EL INSERT SE INSERTA 'y' YA QUE VA INCREMENTANDO
    id              integer,
----- TODOS LOS DATOS DEL QUERY SE GUARDAN EN UNA SOLA FILA PARA ELLO SE DEBE PONER PIPAS O PUNTO Y COMA PARA FILTRAR INFO AL FINAL
    fila            text
);
----- SE ASIGNA LO NECESARIO A LA VARIABLES ANTES DE ENTRAR AL PRIMER LOOP EN 
-----SE ASIGNA EL DATO A 'y' QUE SERA NUESTRO ID EN LA TABLA
y :=0;
----- SE ASIGNA EL PRIMER ENCABEZADO QUE MOSTRARA EL DOCUMENTO FINAL HACER SEPARACION POR PIPA 
Encabezado := 'CUENTA';
----- SON RAISE SIMPLE EN LA TERMINAL PARA VALIDAR QUE ESTE CORRIENDO NO SE MUESTRAN LOS DATOS QUE EXTRAE
RAISE NOTICE '|GENERACION DE REPORTE |%',Encabezado;
RAISE NOTICE '|OBTENIENDO DATOS|';
----- SE INSERTA LOS PRIMEROS DATOS EN LA TABLA CUANDO LLEVAN ENCABEZADOS
INSERT INTO copiar VALUES (0,Encabezado);

----- INICIA NUESTRO PRIMER CICLO PARA OBTENER LOS DATOS, AQUI VA EL QUERY ESTATICO
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
----- TERMINA EL QUERY
----- INICIA EL PRIMER LOOP DE ASGINACION LO QUE SE GUARDO EN REC CON LOS ALIAS DECLARADOS EN EL QUERY SON GUARDADOS EN LOS 'r' DECLARADOS EN EL TYPE
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

----- SE REALIZA EL INSERT EN LA TABLA CON UN COALESCE PARA CONTROLAR DATOS FALTANTES CONCATENADOS CON UNA PIPA PARA FILTRAR INFORMACION AL TENER EL DOCUMENTO GENERADO
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
-----INCREMENTAMOS 'y' EN 1 PARA TENER NUESTRO INDICE EN EL DOCUMENTO FINAL
y := y+1;
-----CADA CUELTA QUE DE EL LOOP RETORNA UNA 'r' 
RETURN NEXT r;
-----FINALIZA EL LOOP
END LOOP;

-----INSERTAMOS LA FECHA DE LA MAQUINA QUE APARECERA EN LOS DOCUMENTOS
    SELECT INTO fecha TO_CHAR(CURRENT_DATE,'DD-MM-YYYY');

EXECUTE 'copy (select fila from copiar order by id) -- to ''/tmp/mov_sup_mes_ce_'||fecha||'.csv'' ';

EXECUTE 'copy (select fila from copiar where id > 0 order by id) -- to ''/tmp/mov_sup_mes_se_'||fecha||'.csv'' ';
END;
$$ LANGUAGE plpgsql;