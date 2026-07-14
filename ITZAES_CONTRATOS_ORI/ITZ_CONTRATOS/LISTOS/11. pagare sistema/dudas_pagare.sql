-----PAGARE -----
ESTE DOCUMENTO TIENE LA TABLA DE AMORTIZACION
SE USARAN 3 TABLAS  para ajustar las amortizaciones
Que tiene SAN ISIDRO
---EL PAGARE NO TIENE ESTA TABLA 1.-html_contratos
2.-texto_contratos
3.-lista_contratos
4.-numero_paginas_contratos

select * from tablas where idtabla = 'html_contratos';
select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo from tablas where idtabla = 'html_contratos' and lower(idelemento) like '%contrato%' ;

select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo from tablas where idtabla = 'html_contratos' and lower(idelemento) like '%contrato_pfpagatodos%' 
;

select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo,dato2 from tablas where lower(idelemento) like '%contrato_pfpagatodos%' 
;

-----NOTA: EL PAGARE DEBE TENER ACENTOS NO ACUTES, VALIDAR EN EL INSERT

2.-texto_contratos -----AQUI VA EL HTML CREADO
SELECT * FROM tablas WHERE idtabla = 'texto_contratos'
AND idelemento = 'contrato_pfpagatodos'; 

----- BORRAR LA TABLA -----
DELETE FROM tablas where idtabla = 'texto_contratos'
AND idelemento = 'contrato_pfpagatodos'; 

----- INSERTAR LA TABLA -----
INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,tipo)
VALUES ('texto_contratos',
        'contrato_pfpagatodos',
        'PAGARE PAGOS FIJOS',
        'carta',
        '80|98|9|3|0',
        0
);


3.-lista_contratos
SELECT * FROM tablas WHERE idtabla = 'lista_contratos'
AND idelemento = 'contrato_pfpagatodos';

----- INSERTAR LA TABLA -----
INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato2,tipo)
VALUES ('lista_contratos',
        'contrato_pfpagatodos',
        'PAGARE PAGOS FIJOS',
        'carta',
        '30402',
        0);

4.-numero_paginas_contratos
SELECT * FROM tablas WHERE idtabla = 'numero_paginas_contratos'
AND idelemento = 'contrato_pfpagatodos';

----- INSERTAR LA TABLA -----
INSERT INTO tablas (idtabla,idelemento,nombre,dato2,tipo)
VALUES ('numero_paginas_contratos',
        'contrato_pfpagatodos',
        'Pagare De Todos Los Prestamos Con Pagos Fijos',
        'Pagina <num_pagina|> De <paginas|>',
        0);