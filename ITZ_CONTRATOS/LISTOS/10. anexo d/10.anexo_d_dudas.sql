Este anexo debera estar ligado a varios productos de credito

idtabla    | html_contratos
idelemento | ahorro_menor_contrato
dato1      | iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html
dato3      | gnome-open %s.html; sleep 100
dato4      | rm -rf %s.*
dato5      | 

-----PRIMERO QUITAR EL -456 PARA QUE ACEPTE EL 0-----
update tablas set tipo = -456 
where lower(idtabla) like '%texto_html_contratos%' 
and lower(idelemento) like '%contrato_anexo2_creditos%';
-----AQUI YA SE PUEDE REALIZAR EL UPDATE
update tablas set tipo = 0 
where lower(idtabla) like '%texto_html_contratos%' 
and lower(idelemento) like '%contrato_anexo2_creditos%';

INSERTAR EL CONTRATO EN HTML en 
idtabla    | texto_html_contratos
idelemento | contrato_anexo4_creditos

select * from auxiliares
where idproducto between 30000 and 39999
and estatus = 2
order by fechaactivacion desc limit 10;

idorigen           | 31001
idgrupo            | 10
idsocio            | 6310
idorigenp          | 31002
idproducto         | 30402
idauxiliar         | 16975

INSERT INTO tablas (idtabla,idelemento,
nombre,
dato1,dato2,tipo) 
VALUES ('lista_contratos',
        'contrato_anexod_creditos',
        'Anexo D ITZAES',
        'carta',
        '30402',0)
;

DELETE FROM tablas
WHERE idtabla = 'texto_html_contratos'
AND idelemento = 'contrato_anexod_creditos';

INSERT INTO tablas (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
VALUES ('texto_html_contratos',
'contrato_anexod_creditos',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0,
'CODIGO HTML');

