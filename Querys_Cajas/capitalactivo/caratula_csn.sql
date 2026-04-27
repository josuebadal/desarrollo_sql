--- SAN NICOLAS ---
/*
---:::::::::: SOLO POR PRIMERA VEZ ::::::::::::::::::::
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'tipo_credito%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'comisiones_relevantes%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'advertencia_comision%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'seguro%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'aseguradora%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'clausula_seguro%';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef%';
--delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'clausula_comision%';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_301','Cr&eacute;dito simple con garantias reales.','301');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_301','301',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_301','301',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_301','301',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_301','301','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_301','301', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_301','2045-138-8009399/03-00433-0313','301');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_307','Cr&eacute;dito simple con garantias prendaria.','307');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_307','307',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_307','307',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_307','307',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_307','307','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_307','307', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_307','2045-138-8009399/03-00433-0313','307');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_326','Cr&eacute;dito simple con garantias prendaria.','326');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_326','326',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_326','326',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_326','326',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_326','326','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_326','326', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_326','2045-138-8009399/03-00433-0313','326');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_327','Cr&eacute;dito simple con garantias prendaria.','327');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_327','327',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_327','327',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_327','327',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_327','327','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_327','327', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_327','2045-138-8009399/03-00433-0313','327');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_330','Cr&eacute;dito simple sin garant&iacute;as.','330');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_330','330',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_330','330',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_330','330',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_330','330','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_330','330',
             '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_330','2045-138-8009399/03-00433-0313','330');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_331','Cr&eacute;dito simple con o sin garant&iacute;as reales.','331');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_331','331',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_331','331',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_331','331',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_331','331','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_331','331', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_331','2045-138-8009399/03-00433-0313','331');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_332','Cr&eacute;dito simple con o sin garant&iacute;as reales.','332');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_332','332',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Cr&eacute;dito sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_332','332',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_332','332',
             '<b>Seguro de cr&eacute;dito:</b> Gratuito con cobertura de hasta $500,000.00 Para cr&eacute;ditos mayores a $500,00.00 el socio de manera obligada contratar&aacute;
              un seguro por la diferencia entre la cobertura gratuita y el cr&eacute;dito. <br />
              <b>Seguro de Da&ntilde;os:</b> Obligatorio con cobertura seg&uacute;n valor comercial de la vivienda (Gastos por parte del socio). <br />
              <b>Plazo del Seguro: </b> Vigencia del Cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_332','332','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_332','332', '1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_332','2045-138-8009399/03-00433-0313','332');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_334','Cr&eacute;dito simple con o sin garant&iacute;as reales.','334');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_334','334',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura </b> <u>&nbsp;&nbsp; 0 % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                        (Capital, inter&eacute;s y seguro) <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    11% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    21% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_334','334',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_334','334',
             'Seguro de vida, incluido en la mensualidad del cr&eacute;dito, con un factor de .355 de cada mil. < br />
              Seguro de da&ntilde;os, incluido en la mensualidad del cr&eacute;dito con factor de .45 de cada mil.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_334','334','Seguro de vida, HIR <br /> Seguro de da&ntilde;os, Banorte Generali');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_334','334',
             'Vig&eacute;sima Tercera - Seguro de Da&ntilde;os. <br /> Vig&eacute;sima Cuarta - Seguro de vida.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_334','2045-138-008298/02-14676-1211','334');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_337','','337');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_337','337',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura </b> <u>&nbsp;&nbsp; 1.5 % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_337','337',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_337','337',
             'Gratuito con cobertura de hasta $500,00.00 Para cr&eacute;ditos mayores a $500,00 el socio de manera obligada contratar&aacute; un seguro por la diferencia 
              entre la cobertura gratuita y el cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_337','337','');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_337','337','');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_337','2045-439-011555/01-18720-0113','337');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_339','Cr&eacute;dito simple sin garant&iacute;as','339');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_339','339',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura: </b> <u>&nbsp;&nbsp; 1.5 % &nbsp;&nbsp;</u> <br />
                    <b> Pago tardia (mora): </b>  24% <br />
                        Anaul sobre saldo vencido. <br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_339','339',
             '1.- El co-acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_339','339',
             'Gratuito con cobertura de hasta $500,00.00 Para cr&eacute;ditos mayores a $500,00 el socio de manera obligada contratar&aacute; un seguro por la diferencia 
              entre la cobertura gratuita y el cr&eacute;dito');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_339','339','HYR Compa&ntilde;ia de Seguros SA de CV');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_339','339','1a Protecci&eacute;n de ahorradores');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_339','2045-439-011555/01-18720-0113','339');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- ANTES ---

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_01','Cr&eacute;dito simple con garantias reales e hipotecarias.','31202');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_01','31202',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> CR&Eacute;DITO sin ahorro </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> <br />
                    <b> Sobre el importe del CR&Eacute;DITO. <br /><br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    11% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    21% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_01','31202',
             '1.- El co- acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_01','31202',
             '<b> 1.- Seguro de Daños:</b> Obligatorio con cobertura  por  valor destructible del inmueble (Gastos por parte del socio) <br />
              <b> 2.- Seguro de Vida: /b> Obligatorio, gratuito hasta por un importe de CR&Eacute;DITO de $500,000.00 (quinientos mil pesos 00/100 moneda nacional). <br />
              Para CR&Eacute;DITOs mayores a $500,001 (quinientos mil un pesos 00/100 moneda nacional), el socio de manera obligatoria contratará un seguro 
              por la diferencia entre la cobertura gratuita y el importe del CR&Eacute;DITO. Cobertura fallecimiento por cualquier causa, invalidez total y 
              permanente hasta por el saldo insoluto del CR&Eacute;DITO y accesorios al momento de que ocurra el siniestro. <br />
              <b> Plazos de los Seguros:</b> Vigencia del CR&Eacute;DITO. <br />
              En caso de que LA PARTE ACREDITADA no contrate los seguros aludidos en esta sección LA PARTE ACREDITANTE podrá contratarlos a nombre y 
              cuenta de la primera.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_01','31202','-- PREDEFINIDA EN TABLAS --');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_01','31202',
             '1).- CLAUSULA: DECIMA NOVENA. <br /><br />
              2).- CLAUSULA: VIGESIMA.');

insert into tablas (idtabla,idelemento,dato1,dato2,dato3)
     values ('formato_caratula_prestamo','numero_contrato_conducef_01','2045-138-009399/05-05744-0513','31202','Personal Con Garantia Prendaria');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_comision_01','31202','---');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_02','Cr&eacute;dito simple con garant&iacute;a hipotecaria','33474');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_02','33474',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura </b> <u>&nbsp;&nbsp; @@prc_comision@@ % &nbsp;&nbsp;</u> sobre el importe de la apertura del cr&eacute;dito.
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido <br />
                    11% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                    21% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_02','33474',
             '1.- El co- acreditado responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_02','33474', 
             '1).- Seguro de da&ntilde;os, obligatorio, incluido en la mensualidad del cr&eacute;dito con factor de $ .35 de cada mil. Cobertura 
                   por el valor destructible del inmueble.
              2).- Seguro de vida, obligatorio, incluido en la mensualidad del cr&eacute;dito, con un factor de $ .45 de cada mil. Cobertura por 
                   fallecimiento por cualquier causa, invalidez total y permanente hasta por el saldo insoluto del cr&eacute;dito y accesorios,  
                   al momento de que ocurra el siniestro. <br />
              Plazos de los Seguros: Vigencia del Cr&eacute;dito. <br />
              En caso de que LA PARTE ACREDITADA no contrate los seguros aludidos en esta secci&oacute;n LA PARTE ACREDITANTE podr&aacute; contratarlos 
              a nombre y cuenta de la primera.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_02','33474','-- PREDEFINIDA EN TABLAS --');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_02','33474',
             '1).- DECIMA SEPTIMA. <br /><br />
              2).- DECIMA OCTAVA.');

insert into tablas (idtabla,idelemento,dato1,dato2,dato3)
     values ('formato_caratula_prestamo','numero_contrato_conducef_02','2045-138-008298/05-00761-0513','33474','');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_comision_02','33474','');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_03','Cr&eacute;dito al Auto','33746|34146');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_03','33746|34146',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura 1.5% </b> <br /><br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    Cobranza: 1% del saldo vencido, m&aacute;s el 10% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as y el 20% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante. <br /><br />
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_03','33746|34146',
             '1.- El aval responder&aacute; como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicol&aacute;s S.C. de A.P. de R.L. de C.V. <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br />
              3.- Contratar cr&eacute;ditos por arriba de tu capacidad de pagos te puede afectar tu historial crediticio. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_03','33746|34146', 'Seguro de Autom&oacute;vil con cobertura amplia, obligatorio y con cargo al Socio.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_03','33746|34146','ABA SEGUROS S.A. DE C.V.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_03', 'DECIMA PRIMERA','33746|34146');

insert into tablas (idtabla,idelemento,dato1,dato2,dato3)
     values ('formato_caratula_prestamo','numero_contrato_conducef_03','RECA 2045-139-018045/01-05399-0914','33746|34146','Personal Con Garantia Prendaria');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_04','Simple  sin  garant&iacute;a','32944');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_04','32944',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="25%">
                    <b> Apertura 2.5% </b> <br /><br />
                  </td>
                  <td width="75%" class="izq_der_borde">
                    <b>Cobranza:</b><br />  
                              1% del saldo vencido. <br /> 
                              11% para cr&eacute;ditos con mora entre 90 y 547 d&iacute;as. <br />
                              21% para cr&eacute;ditos con mora de 548 d&iacute;as en adelante. <br /><br />
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_04','32944', 
             '1.- "Incumplir tus obligaciones te puede generar comisiones e intereses moratorios".  <br />
              2.- "Contratar cr&eacute;ditos por arriba de tu capacidad de pagos te puede afectar tu historial crediticio". <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_04','32944', 'NO APLICA');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_04','32944','NO APLICA');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_04', '32944', 'NO APLICA');

insert into tablas (idtabla,idelemento,dato1,dato2,dato3)
     values ('formato_caratula_prestamo','numero_contrato_conducef_04','RECA 2045-439-011555/02-00668-0413','32944','CREDINOMINA');
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','tipo_credito_341','CONSUMO','34146|33746');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo35244','comisiones_relevantes_35244','35244',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="50%">
                   <u>$@@monto_comision@@</u> Que corresponde a la comisi&oacute;n por Apertura de cr&eacute;dito: 2.5% sobre el importe del cr&eacute;dito al momento de su 

apertura.
                  </td>
                </tr>
              </table>');




insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_337-341','337|341',
             '<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="50%">
                   <u>$@@monto_comision337-341@@</u> Que corresponde a la comisi&oacute;n por Apertura de cr&eacute;dito: 2 % sobre el importe del cr&eacute;dito al momento de su 

apertura.
                  </td>
                </tr>
              </table>');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','advertencia_comision_341','34146|33746', 
             '1.- El aval respondera como obligado principal en caso de que el socio no cumpla con sus obligaciones ante Caja San Nicolas.  <br />
              2.- No olvide cumplir en tiempo y forma con sus pagos, el atraso en los mismos puede generar comisiones e intereses moratorios. <br /><br />');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','seguro_341','34146|33746', 'Gratuito con cobertura de hasta $500,000.00. Para creditos mayores a 500,000 el socio de 
              manera obligada contratara un seguro por la diferencia entre la cobertura gratuita y el credito.');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','aseguradora_341','34146|33746','GRUPO NACIONAL PROVINCIAL');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_341', '34146|33746', 'Decima Primera');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','clausula_seguro_34875', 'Decima Septima', '34875|34874|34975|34974');

insert into tablas (idtabla,idelemento,dato1,dato2,dato3)
     values ('formato_caratula_prestamo','numero_contrato_conducef_341','RECA 2045-139-018045/01-05399-0914','34146|33746','Autocreditos');

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','nombre_comercial01','prueba de nombre comercial','32644');

MANEJO DE JAVACRSIPT EN FORMATO HTML

insert into tablas (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','comisiones_relevantes_0','301|327|338|330|331|307|329|332|352',
             '<script>function ppdj() document.getElementById(''prestamo337'').innerHTML = @@monto@@ *.025; </script>
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="texto_top">
                  <td  width="50%">
                       <u>$<label id="prestamo337"></label></u> Que corresponde a la comisi&oacute;n por Apertura de cr&eacute;dito: 
                                          2.5 % sobre el importe del cr&eacute;dito al momento de su apertura.
                  </td>
                </tr>
              </table>');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/


update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_caratula_prestamo';
delete from tablas where idtabla = 'param' and idelemento = 'formato_caratula_prestamo';
INSERT INTO tablas
            (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
     VALUES ('param','formato_caratula_prestamo',
             'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
             'gnome-open %s.html; sleep 7','rm -rf %s.*',3,
             '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.contenedor {
  height: 25cm;
  width: 19.5cm;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 10pt;
}
.marco_borde {
  border: 1px solid #000;
}
.encabezado {
  font-size: 20px;
  font-weight: bold;
  color: #000;
}
.texto_top {
  vertical-align: top;
}
.tipodeletra {
  font-family: Arial, Helvetica, sans-serif;
  font-size: 14px;
}
.borde_bajo {
  border-bottom-width: 1px;
  border-bottom-style: solid;
  border-bottom-color: #000;
}
.izq_der_borde {
  border-right-width: 1px;
  border-left-width: 1px;
  border-right-style: solid;
  border-left-style: solid;
  border-right-color: #000;
  border-left-color: #000;
}
.izq_borde {
  border-left-width: 1px;
  border-left-style: solid;
  border-left-color: #000;
}
.borde_completo {
  border: 1px solid #000;
}
</style>
</head>
<body onload="ppdj()">
<div class="contenedor">
  <table class="tipodeletra" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="borde_completo">
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
   <tr>
      <td width="100%" height="20%"><center><br><img src="/usr/local/saicoop/img_caratula_ahorros/logo_nuevo.jpg" alt="" width="400" height="50" /><br><br></center></td>
      <!--<td class="encabezado" width="82%">
        <b> CAJA SAN NICOLAS S.C. de A.P. de R.L. de C.V. <br />
        AV. REPUBLICA MEXICANA # 401 COLONIA LAS PUENTES 2DO. SECTOR. <br />
        SAN NICOLAS DE LOS GARZA, NUEVO LEON. CODIGO POSTAL 66460 <br />
        TELEFONOS 83-05-6900 O 01-800-224-2020 <br />
        RFC. CSN950904LU6 .</b>
      </td>-->
    </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo"><center><b> CARATULA DE CREDITO </b></center></td>
    </tr>
    <tr>
      <td class="borde_bajo izq_der_borde"> 
        <b> Nombre comercial del Producto: </b> @@nombre_comercial@@ <br />
        <b> Tipo de operacion: </b> Activa
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="texto_top" align="center">
          <td class="borde_bajo izq_der_borde" width="25%">
            <b> <font size=4 >CAT </font> <br>(Costo Anual Total) </b>
          </td>
          <td class="borde_bajo" width="25%">
            <b> TASA DE INTERES ANUAL ORDINARIA Y MORATORIA </b>
          </td>
          <td class="borde_bajo izq_borde" width="25%"> 
            <b> MONTO O LINEA DE  CR&Eacute;DITO </b>
          </td>
          <td class="borde_bajo izq_der_borde" width="25%">
            <b> MONTO TOTAL A PAGAR O MINIMO A PAGAR</b>
          </td>
        </tr>
        <tr class="texto_top" align="center">
          <td class="borde_bajo izq_der_borde">
           <b> <font size=4 >&nbsp;&nbsp;&nbsp; <b> @@cat1@@  &nbsp;&nbsp;&nbsp;%<br />
            SIN IVA Para fines informativos y de comparaci&oacute;n <font>  </td>
          <td  class="borde_bajo">
            <b>Ordinaria &nbsp;&nbsp;&nbsp;  @@io_anual@@  &nbsp;&nbsp;&nbsp;%  Fija</b> 
            <b>Moratoria &nbsp;&nbsp;&nbsp;  @@im_anual@@  &nbsp;&nbsp;&nbsp;%  Fija</b> 
          </td>
          <td class="borde_bajo izq_borde">
            $ &nbsp;&nbsp;&nbsp; @@monto@@ &nbsp;&nbsp;&nbsp; 
          </td>
          <td class="borde_bajo izq_der_borde">
            $ &nbsp;&nbsp;&nbsp; @@total@@ &nbsp;&nbsp;&nbsp; 
          </td>
        </tr>
        <tr class="texto_top">
          <td class="borde_bajo izq_borde">
            <b> PLAZO DEL CR&Eacute;DITO: </b> <br /> <u>&nbsp;&nbsp; @@meses@@ &nbsp;&nbsp;</u> meses 
          </td>
          <td class="borde_bajo izq_der_borde" colspan="3"> 
            <b> Fecha l&iacute;mite de pago: </b> El d&iacute;a <u>&nbsp;&nbsp; @@dia@@ &nbsp;&nbsp;</u> de cada mes <br />
            Fecha  de corte: <u>&nbsp;&nbsp; @@siguiente_pago@@ &nbsp;&nbsp;</u>, para las subsecuentes fechas de corte consultar el plan de amortizaci&oacute;n de pagos, anexo al contrato. 
          </td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td class="borde_bajo izq_der_borde" align="center">
        <b> COMISIONES RELEVANTES </b>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo izq_der_borde">
        @@comisiones_relevantes@@
      </td>
    </tr>
    <tr>
      <td class="borde_bajo izq_der_borde" align="center">
        <b> ADVERTENCIAS </b>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo izq_der_borde">
        @@advertencia_comision@@
      </td>
    </tr>
    <tr>
      <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <center><b> SEGUROS </b></center>
          </td>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="60%" class="texto_top">  @@seguro@@ </td>
                <td width="20%" class="izq_borde texto_top"><b>Aseguradora:</b> <br /> @@aseguradora@@ </td>
                <td width="20%" class="izq_borde texto_top"><b>Cl&aacute;usulas:</b> <br /> @@clausula_seguro@@ </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <center><b> ESTADO DE CUENTA </b></center>
          </td>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="24%"> Entrega en: sucursales  </td>
                <td width="5%" class="alinear_der"><u> &nbsp;&nbsp; x &nbsp;&nbsp; </u></td>
                <td width="5%">&nbsp;</td>
                <td width="20%"> Consulta: v&iacute;a Internet </td>
                <td width="5%" class="alinear_der"><u> &nbsp;&nbsp; x &nbsp;&nbsp; </u></td>
                <td width="5%">&nbsp;</td>
                <td width="26%"> Env&iacute;o por correo electr&oacute;nico: </td>
                <td width="10%" class="alinear_der"><u> &nbsp;No Aplica&nbsp; </u></td>
              </tr>
          
            </table>
          </td>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <b> Aclaraciones y reclamaciones <br />
            Unidad Especializada de Atenci&oacute;n a Usuarios: </b> Unidad Especializada de  Atenci&oacute;n de Consultas y Reclamaciones <br />
            <b> Domicilio: </b> Edificio  Corporativo, Av. Rep&uacute;blica Mexicana No. 401 Col Las Puentes Segundo Sector, San  Nicol&aacute;s de los Garza, Nuevo Le&oacute;n. C.P. 66460<br />
            <b> Tel&eacute;fono: </b> 01(81) 83056900 Ext. 451 &nbsp;&nbsp;&nbsp; <b> Correo electr&oacute;nico: </b> csn@csn.coop <br />
            <b> P&aacute;gina de Internet: </b>  www.csn.coop 
          </td>
        </tr>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <b> Registro de contratos de adhesi&oacute;n N&uacute;mero: @@numero_contrato_condusef@@ </b><br />
            Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF): <br />
            Tel&eacute;fono: 01 800 999 8080 y 53400999. P&aacute;gina de Internet. www.condusef.gob.mx 
          </td>
        </tr>
      </table>
      </td>
    </tr>
  </table>
</div>
</body>
</html>

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
');

