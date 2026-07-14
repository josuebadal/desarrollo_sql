Este anexo debera estar ligado a varios productos de credito

idtabla    | html_contratos
idelemento | ahorro_menor_contrato
dato1      | iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html
dato3      | gnome-open %s.html; sleep 100
dato4      | rm -rf %s.*
dato5      | 

idorigen           | 31001
idgrupo            | 10
idsocio            | 6310
idorigenp          | 31002
idproducto         | 30402
idauxiliar         | 16975

-----PRIMERO QUITAR EL -456 PARA QUE ACEPTE EL 0-----
update tablas set tipo = -456 
where lower(idtabla) like '%texto_html_contratos%' 
and lower(idelemento) like '%contrato_anexo2_creditos%';
-----AQUI YA SE PUEDE REALIZAR EL UPDATE
update tablas set tipo = 0 
where lower(idtabla) like '%texto_html_contratos%' 
and lower(idelemento) like '%contrato_anexo2_creditos%';

las tablas a afectar son:
tablas,
idtabla ='texto_html_contratos'
idtabla = 'lista_contratos'

----- INSERTAR ESTA TABLA PRIMERO -----
INSERT INTO tablas (idtabla,idelemento,
nombre,
dato1,dato2,tipo) 
VALUES ('lista_contratos',
        'contrato_anexoc_creditos',
        'Anexo C ITZAES',
        'carta',
        '30402',0)
;


DELETE FROM tablas
WHERE idtabla = 'texto_html_contratos'
AND idelemento = 'contrato_anexoc_creditos';

SELECT * from tablas
where LOWER(idtabla) LIKE '%texto_html_contratos%'
AND   LOWER(idelemento) LIKE '%contrato_anexo3_creditos%';

INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,dato4,tipo)
VALUES ('texto_html_contratos',
'contrato_anexoc_creditos',
'Anexo C ITZAES',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0);

