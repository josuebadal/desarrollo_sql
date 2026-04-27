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


Buen día

Este formato se genera en el proceso de apertura de un producto a un socio. 
Como ejemplo se tomo el OGS: 30502-10-227270, 
se le aperturó el producto   30302
con un monto de $5,000, con un número de pagos de 24. 

El sistema nos solicita capturar garantía, poseteriormente nos genera la tabla de amortización de manera automática. Seguidamente nos arroja una ventana de pregunta para imprimir analisis de credito, en donde e elige "FORMATO B", se adjunta SS al respecto.
Así mismo se adjunta pdf de analisis de credito generado en prueba y se adjunta .xls con los campos que se requieren actualizar.

Quedamos atentos a sus comentarios.