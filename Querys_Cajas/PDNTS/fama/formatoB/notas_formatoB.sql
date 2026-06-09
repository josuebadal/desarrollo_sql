select   idtabla,idelemento,
case 
    when nombre is NULL or trim(nombre) = '' then idelemento 
    else nombre end as nombre, dato1, dato2, dato3, dato4 
    from     tablas 
    where    idtabla = 'param' 
    and idelemento like 'formato_analisis_credito_%' 
    order by idtabla, idelemento


select   idtabla,idelemento,
case 
    when nombre is NULL or trim(nombre) = '' then idelemento 
    else nombre end as nombre,dato1,dato3,dato4 
    from     tablas 
    where    idtabla = 'param' 
    and idelemento like 'formato_analisis_credito_%' 
    order by idtabla, idelemento limit    1 offset   1
   SELECT sai_formato_analisis_credito(30550,30302,3,'formato_analisis_credito_b')


select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo from     tablas 
    where    idtabla = 'param' 
    and idelemento like 'formato_analisis_credito_b' 
    order by idtabla, idelemento;


idtabla    | param
idelemento | formato_analisis_credito_b
nombre     | FORMATO B
dato1      | iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html
dato3      | gnome-open %s.html; sleep 15
dato4      | rm -rf %s.*
dato5      | 
tipo       | 3

select dato2 from     tablas 
    where    idtabla = 'param' 
    and idelemento like 'formato_analisis_credito_b' 
    order by idtabla, idelemento;

UPDATE tablas
SET tipo = -456
where    idtabla = 'param' 
and idelemento like 'formato_analisis_credito_b' ;

UPDATE tablas
SET tipo = 0
where    idtabla = 'param' 
and idelemento like 'formato_analisis_credito_b' ;


Como ejemplo se tomo el OGS: 30502-10-227270, 
se le aperturó el producto   30302
con un monto de $5,000 
con un número de pagos de 24.

DATOS para el cambio que dicen
OGS 30512 - 10 - 1540
OPA 30302 - 18331

INGRESO DECLARADO
monto =  83,266.64
id =     "monto_mensual"
clave =  @@ing_men_sueldo_neto@@

IMPORTE A CONSIDERAR
monto =  28,407.87
id =     "considera_importe"  //este dato estaba vacio  se le asigna un ID Para calculos futuros
clave =  @@considera_importe@@

SUMA DE GASTOS 
monto =  $32,000.00
id =     "efectivo"
clave =  @@suma_gastos@@

EFECTIVO DISPONIBLE
monto =  51266.64 
id =     "resultado_monto"
clave =  //no posee una porque hace el calculo en JS