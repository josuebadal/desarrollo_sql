1. Existen dos formulas matematicas en la pagina 2 
para calcular el saldo insoluto y el pago fijo, 
no es posible replicar las formulas en diseño en html, 
se pondria como imagen o representar las formulas de manera mas 
simplificada para se adapte al diseño en html?

-----favor de validar generando los documentos con lo siguiente
OPA:  31004-30402-9963
OGS:  31004-10-4747
FECHA DE TRABAJO : 31-10-2025


------DATOS CAPTURADOS ANTERIOR MENTE -----
INSERT INTO tablas (idtabla,idelemento,
nombre,
dato1,dato2,tipo) 
VALUES ('lista_contratos',
        'contrato_creditos',
        'Contrato De Creditos',
        'carta',
        '30402',0)
;

select idtabla,idelemento from tablas
where idtabla = 'lista_contratos';

select idtabla,idelemento from tablas
where idtabla = 'texto_html_contratos';


DELETE FROM tablas
WHERE idtabla = 'lista_contratos'
AND idelemento = 'contrato_creditos';

DELETE FROM tablas
WHERE idtabla = 'texto_html_contratos'
AND idelemento = 'contrato_creditos';



