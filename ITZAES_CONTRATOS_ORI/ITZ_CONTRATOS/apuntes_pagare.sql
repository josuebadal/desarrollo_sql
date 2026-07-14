Buenas tardes, ya se encuentran cargados en la base 
itzaes_formatos los siguientes archivos:
1.-Anexo A 
2.-Anexo B 
3.-Anexo C 
4.-Anexo D 
5.-CheckList
6.-Caratula de prestamos

favor de validar generando los documentos con lo siguiente
OPA:  31004-30402-9963
OGS:  31004-10-4747
FECHA DE TRABAJO : 31-10-2025

/*Validar la ruta para poner imagenes en los contratos*/

<td width="18%">
<img src="/usr/local/saicoop/img/logo_csn_2.jpg" 
width="425" height="65" />
</td>

DELETE FROM tablas WHERE idtabla = 'lista_pagares' AND idelemento = 'pagare_general_2';
DELETE FROM tablas WHERE idtabla = 'texto_html_pagares' AND idelemento = 'pagare_general_2';

/*    PARA IMPRIMIR SOLO EN ORIGENES 
delete from tablas where idtabla='origenes_pagares' and idelemento='pagare_general_2';
INSERT INTO tablas(idtabla,idelemento,dato2) VALUES ('origenes_pagares','pagare_general_2','30502');
*/

INSERT INTO tablas VALUES ('lista_pagares','pagare_general_2','LINEA DE CREDITO EXCLUSIVA','carta',
'33602',
NULL,NULL,NULL,0);

DELETE FROM tablas WHERE idtabla = 'texto_html_pagares' AND idelemento = 'pagare_unico';
INSERT INTO tablas VALUES ('texto_html_pagares','pagare_unico','PAGARE UNICO',
'iconv %s -f iso-8859-1 -t utf-8 -o %s.html',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">');

--raise notice '7) x_formato: %', x_formato;
  select into r_paso *
  from        tablas
  where       idtabla = p_formato and
              idelemento like 'tipo_credito%' and
              sai_texto1_like_texto2(x_idproducto,NULL,dato2,'|') > 0;
  if found then
    x_formato := REPLACE(x_formato, '@@tipo_credito@@', r_paso.dato1);
  end if;

@@finalidad@@






------------------------------------------------------------
--LOS DATOS QUE OCUPO DE TODOS LOS CONTRATOS ESTAN EN LOS 
--PL_DOCUMENTO
--pl_caratula_prestamos.sql


--INSERT PARA LAS CARATULAS DE CREDITO
/*============================================================================================================
                                                        NOMBRE DE CARATULA
============================================================================================================*/
       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_caratula_30502';

              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','nombre_caratula_30502','CARATULA DE CONTRATO DE CREDITO AUTOMOTRIZ','30502');

/*============================================================================================================
                                                        TIPO DE CREDITO
============================================================================================================*/
       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'tipo_credito_30502';

              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','tipo_credito_30502','Credito Simple con Garantia Prendaria.','30502');

/*============================================================================================================
                                                       SEGURO
============================================================================================================*/

       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'seguro_30502';

              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_30502','30502','Automotriz');

/*============================================================================================================
                                                       ASEGURADORA
============================================================================================================*/

       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'aseguradora_30502';

              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_30502','30502','Varia conforme costo y conveniencia del socio');

/*============================================================================================================
                                                       CLAUSULA SEGURO
============================================================================================================*/

       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'clausula_seguro_30502';

              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_30502','30502', 'Vigesima Tercera del Contrato.');

/*============================================================================================================
                                                       NUMERO CONTRATO CONDUCEF RECA
============================================================================================================*/


       delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_30502';

              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','numero_contrato_conducef_30502',' 0000-000-000000/00-00000-0000 ','30502');



/*============================================================================================================
                             LISTA DE VARIABLES QUE SE CONFIGURAN EN TABLAS PARA LA CARATULA DE PRESTAMOS
============================================================================================================


                                                                                       
variable(caratula)             idtabla                     idelemento                      parametro1         parametr2

 ---------------------------------------------------------------------------------------------------------------------  

@@seguro@@                   formato_caratula_prestamo   seguro_xx                          prod|prod          texto
@@aseguradora@@              formato_caratula_prestamo   aseguradora_xx                     texto              prod|prod    
@@clausula_seguro@@          formato_caratula_prestamo   clausula_seguro_xx                 texto              prod|prod  
@@tipo_credito@@             formato_caratula_prestamo   tipo_credito_xx                    texto              prod|prod
@@nombre_caratula@@          formato_caratula_prestamo   nombre_caratula_xx                 texto              prod|prod
@@numero_contrato_condusef@@ formato_caratula_prestamo   numero_contrato_conducef_xx        texto              prod|prod   
*/

 <num_plastico_tdd.sql|> 
numero_de_reca_p


--LINEAS 23256 
--Archivo: f4contratostxt.c
reca_recortado_p  **recortado 23306
numero_de_reca_p  ** deberia ser completo 23253


<numero_de_reca_p|||D>
<reca_recortado_p|||D>