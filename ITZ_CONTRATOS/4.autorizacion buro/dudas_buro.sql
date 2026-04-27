----- INSERTAR EL LISTADO -----
INSERT INTO tablas (idtabla,idelemento,
nombre,
dato1,dato2,tipo) 
VALUES ('lista_contratos',
        'contrato_solicitud_buro',
        'Consulta De Buro',
        'carta',
        '30402',0)
;

----- BORRAR EL LISTADO -----
DELETE FROM tablas
WHERE idtabla = 'lista_contratos'
AND idelemento = 'contrato_solicitud_buro';

----- INSERT SOLICITUD EN SQL-----
INSERT INTO tablas (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
VALUES ('texto_html_contratos',
'contrato_solicitud_buro',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0,
'CODIGO HTML');

----- BORRAR EL CONTRATO -----
DELETE FROM tablas
WHERE idtabla = 'texto_html_contratos'
AND idelemento = 'contrato_solicitud_buro';