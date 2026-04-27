--- CAPITAL ACTIVO ---
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'registro_detalle';
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','registro_detalle','Formato del registro detalle',
'     <tr class="al_der">                                                 
       <td width="33" align="left">@@mov_d@@</td>                        
       <td width="60" align="left">@@fecha_d@@</td>                      
       <td width="45" align="left">@@referencia_d@@</td>                 
       <td width="76">@@cargos_d@@</td>                                  
       <td width="75">@@abonos_d@@</td>                                  
       <td width="75">@@saldo_d@@</td>                                   
       <td width="60">@@montoio_d@@</td>                                 
       <td width="60">@@descuento_io_t@@</td>
       <td width="60">@@montoim_d@@</td>
       <!-- <td width="60">@@monto_comision_d@@</td> -->                 
       <td width="75">@@monto_vencido_d@@</td>                           
       <td width="75">@@monto_pagado_d@@</td>                            
     </tr>                                                               
     <tr class="al_der">                                                 
       <td width="33">&nbsp;</td>                                        
       <td colspan="4" align="left"><b>Pago en: @@donde_pago_d@@</b></td>
       <td width="75">iva --&gt;</td>                                    
       <td width="60">@@montoivaio_d@@</td>
       <td width="60">@@iva_descuento_io_t@@</td>                              
       <td width="60">@@montoivaim_d@@</td>                              
       <!-- <td width="60">&nbsp;</td> -->                               
       <td width="75">&nbsp;</td>                                        
       <td width="75">&nbsp;</td>                                        
     </tr>                                                               
');

/*
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'encabezado';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'pie_de_pagina';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'registro_detalle';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'registro_detalle_2';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'registro_detalle_encab';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'registro_detalle_2_encab';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'comisiones_cob_cargos_obj';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'comisiones_cob_cargos_obj_deta';
delete from tablas where idtabla = 'formato_estado_cuenta_prestamo' and idelemento = 'advertencias_recomendaciones';
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','encabezado','Datos del Encabezado de Estado Cuenta de Prestamo',
             '');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','pie_de_pagina','Datos del Pie de Pagina de Estado Cuenta de Prest',
             '');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','registro_detalle','Formato del registro detalle',
'    <tr class="al_der">
      <td width="33" align="left">@@mov_d@@</td>
      <td width="60" align="left">@@fecha_d@@</td>
      <td width="45" align="left">@@referencia_d@@</td>
      <td width="76">@@cargos_d@@</td>
      <td width="75">@@abonos_d@@</td>
      <td width="75">@@saldo_d@@</td>
      <td width="60">@@montoio_d@@</td>
      <td width="60">@@montoim_d@@</td>
      <!-- <td width="60">@@monto_comision_d@@</td> -->
      <td width="75">@@monto_vencido_d@@</td>
      <td width="75">@@monto_pagado_d@@</td>
    </tr>
    <tr class="al_der">
      <td width="33">&nbsp;</td>
      <td colspan="4" align="left"><b>Pago en: @@donde_pago_d@@</b></td>
      <td width="75">iva --&gt;</td>
      <td width="60">@@montoivaio_d@@</td>
      <td width="60">@@montoivaim_d@@</td>
      <!-- <td width="60">&nbsp;</td> -->
      <td width="75">&nbsp;</td>
      <td width="75">&nbsp;</td>
    </tr>
');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','registro_detalle_encab','Formato del Encabezado del registro detalle',' ');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','registro_detalle_2_encab','Formato del Encabezado del registro detalle',' ');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','registro_detalle_2','Formato del registro detalle',' ');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','comisiones_cob_cargos_obj','Formato post registro detalle',' ');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','comisiones_cob_cargos_obj_deta',
             'Detalle de comisiones_cob_cargos_obj','');
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_prestamo','advertencias_recomendaciones','Formato parte de pie de pagina',' ');
*/     
--insert into tablas
--            (idtabla,idelemento,dato2)
--     values ('param','edocta_prestamo_por_conceptos','30302');
update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_estado_cuenta_prestamo';
delete from tablas where idtabla = 'param' and idelemento = 'formato_estado_cuenta_prestamo';
insert into tablas
            (idtabla,idelemento,nombre,dato1,dato3,dato4,dato2,tipo)
     values ('param','formato_estado_cuenta_prestamo','Formato en XML de Estado de Cuenta de Prestamos',
             'iconv %s -f iso-8859-1 -t utf-8 -o %s.html','gnome-open %s.html; sleep 17','rm -rf %s.*',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Estado de cuenta prestamos</title>
    <style type="text/css">
      .contenedor {
        height: 25cm;
        width: 19cm;
        font-family: Arial, Helvetica, sans-serif;
      }
      .encabezado {
        text-align: center;
        font-size: 12pt;
        border-bottom-width: 1pt;
        border-top-style: none;
        border-right-style: none;
        border-bottom-style: solid;
        border-left-style: none;
        border-top-color: #000;
        border-right-color: #000;
        border-bottom-color: #000;
        border-left-color: #000;
      }
      th {            
         font-size: 11pt; 
         text-align: center;                              
         vertical-align: bottom;                          
         font-weight: bold;                               
         background-color: #19348F;                       
         color: #FFF;     
      }        
      .sombreado {
        background-color: #D6D6D6;
      }
      .borde_resumen {
        border-right-width: 1pt;
        border-bottom-width: 1pt;
        border-left-width: 1pt;
        border-right-style: solid;
        border-bottom-style: solid;
        border-left-style: solid;
        border-right-color: #000;
        border-bottom-color: #000;
        border-left-color: #000;
      }
      .al_der {
        text-align: right;
      }
      .cent {
        text-align: center;
      }
      .reumen {
        font-size: 10pt;
      }
      .negrita {
        font-weight: bold;
      }
      .sin_negrita {
        font-weight: normal;
      }
      .top {
        vertical-align: top;
      }
      .bordes {
        border: 1pt solid #000;
      }
      .alinear_abajo {
        vertical-align: bottom;
      }
      .raya_baja {
        border-bottom-style: none;
        border-top-width: 2px;
        border-top-style: solid;
        border-top-color: #D52645;
      }
      .texto_pie {
        font-weight: bold;
        color: #18318B;
        text-align: center;
      }
      .texto_chico {
        font-size: 7pt;
      }
      .justificado {
        text-align: justify;
      }
      .texto_detalle {
        font-size: 8pt;
      }
    </style>
    <script type="text/javascript">
      window.onload=function seccion(){
        var inio=document.getElementById("iomen");
        var ind=document.getElementById("iod");

        if(@@sobreprecio@@>0){
          inio.innerHTML="2";
          ind.innerHTML="24";
        }
      }; 
    </script>
  </head>
  <body>
    <div class="contenedor">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td >
                  <table class="bordes" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="35%"><img src="/usr/local/saicoop/img_estado_cuenta_prestamos/logo.jpg" width="236" height="114" /></td>
                        <td width="65%" class="alinear_abajo cent negrita">
                          <!-- <center><img src="/usr/local/saicoop/img_estado_cuenta_prestamos/slogan.jpg" width="449" height="32" /></center> -->
                          Capital Activo S.A. de C.V. , S.F.P.
                        </td>
                      </tr>
                      <tr><td colspan="2">&nbsp;</td></tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td>
                  <table class="reumen sin_negrita" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="60%">
                        <b> Nombre: </b> @@nombre@@ <br />
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="top" width="15%"><b> Domicilio: </b></td>
                            <td width="85%"> @@domicilio@@ </td>
                          </tr>
                        </table>
                        <b> RFC: </b>@@rfc@@<br />
                        <b> Numero de Cuenta: </b>@@cuenta@@
                      </td>
                      <td width="36%" class="top sin_negrita"> 
                        <b> Sucursal: </b>@@sucursal@@<br />
                        @@domicilio_sucursal@@
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr><td colspan="2">&nbsp;</td></tr>
              <tr>
                <td width="50%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td>
                        <table class="reumen" width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td colspan="2" class="sin_negrita"> <b> Producto: </b>@@nom_producto@@</td>
                          </tr>
                          <tr>
                            <td colspan="2" class="sin_negrita"><b> Folio: </b>@@folio@@</td>
                          </tr>
                          <tr> <!-- se agrego -->
                            <td width="73%"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td><b>Monto de la Operacion:</b></td>
                                  <td class="al_der">@@monto_operacion@@</td>
                                </tr>
                                <tr>
                                  <td><b>Saldo Inicial:</b></td>
                                  <td class="al_der">@@saldo_inicial@@</td>
                                </tr>
                                <tr>
                                  <td><b>Saldo a la Fecha de Corte:</b></td>
                                  <td class="al_der">@@saldo_fecha_corte@@</td>
                                </tr>
                                <tr>
                                  <td><b>Saldo Insoluto:</b></td>
                                  <td class="al_der">@@saldo_fecha_corte@@</td>
                                </tr>
                                <tr>
                                  <td><b>Total a liquidar:</b></td>
                                  <td class="al_der">@@saldo_insoluto@@</td>
                                </tr>
                                <tr class="sombreado">
                                  <td><b>Monto a Pagar en el periodo:</b></td>
                                  <td class="al_der">@@monto_a_pagar@@</td>
                                </tr>
                                <tr>
                                  <td><b>Intereses Ordinarios:</b></td>
                                  <td class="al_der">@@io@@</td>
                                </tr>
                                <tr>
                                  <td><b>Intereses Ordinarios cobrados con anticipacion:</b></td>
                                  <td class="al_der">@@interes_factoraje@@</td>
                                </tr>
                                <tr>
                                  <td><b>Descuento IO:</b></td>
                                  <td class="al_der">@@descuento_io@@</td>
                                </tr> 
                                <tr>
                                  <td><b>IVA de Intereses Ordinarios:</b></td>
                                  <td class="al_der">@@iva_io@@</td>
                                </tr>
                                <tr>
                                  <td><b>IVA Descuento IO:</b></td>
                                  <td class="al_der">@@iva_descuento_io@@</td>
                                </tr>
                                <!--<tr>
                                  <td><b>Intereses Moratorios:</b></td>
                                  <td class="al_der">@@im@@</td>
                                </tr>-->
                                <!--<tr>
                                  <td><b>IVA de Intereses Moratorios:</b></td>
                                  <td class="al_der">@@iva_im@@</td>
                                </tr>-->
                                <tr>
                                  <td><b>Comision por gastos de Apertura:</b></td>
                                  <td class="al_der">@@monto_apertura@@</td>
                                </tr>
                                <tr>
                                  <td><b>IVA por gastos de Apertura:</b></td>
                                  <td class="al_der">@@monto_apertura_iva@@</td>
                                </tr>
                                <tr>
                                  <td><b>Monto total de gastos de Apertura:</b></td>
                                  <td class="al_der">@@monto_apertura_mas_iva@@</td>
                                </tr>
                              </table>
                            </td>
                            <td width="5%">&nbsp;</td>
                          </tr>
                        </table>
                      </td>
                      <td width="50%">
                        <table class="reumen" width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td>
                              <table class="bordes sombreado" width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td width="50%"><b> Fecha de la Operacion: </b></td>
                                  <td width="50%" align="right" class="sin_negrita">@@f_operacion@@</td>
                                </tr>
                                <tr>
                                  <td><b> Periodo: </b></td>
                                  <td align="right" class="sin_negrita">@@pf1@@ al @@pf2@@</td>
                                </tr>
                                <tr>
                                  <td><b> Dias Vencidos: </b></td>
                                  <td align="right" class="sin_negrita">@@dv@@</td>
                                </tr>
                                <tr>
                                  <td><b> Fecha de Corte: </b></td>
                                  <td align="right" class="sin_negrita">@@fecha_corte@@</td>
                                </tr>
                                <tr>
                                  <td><b> Fecha limite de pago: </b></td>
                                  <td align="right" class="sin_negrita">@@f_lim_pago@@</td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr><td>&nbsp;</td></tr>
                          <tr>
                            <td>
                              <table class="bordes" width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td>
                                    <b>Tasa de inter&eacute;s ordinaria fija: <a id="iomen">@@tasaio_mensual@@</a>%</b> mensual y
                                    <b>@@tasaio_anual@@%</b> anual "la tasa se aplicar&aacute; sobre el saldo insoluto"<br />
                                   <!--- <b>Tasa de inter&eacute;s ordinaria con descuento: <a id="iod">@@tasaio_descuento@@</a>%</b><br>-->
                                    <b>Tasa de Inter&eacute;s moratorio: @@tasaim_mensual@@%</b> mensual y 
                                    <b>@@tasaim_anual@@%</b> anual. "tasa fija, sobre saldos insolutos". <br />
                                    CAT: @@cat@@% "promedio sin I.V.A. para fines informativos y de comparaci&oacute;n". <br />
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <!--- Se procede a comentar TIPO DE CAMBIO a solicitud de capital activo
                            <td class="al_der"><b> Tipo de Cambio M.N. </b></td>-->
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>    
          </td>
        </tr>
        <tr>
          <td>
            <table class="texto_detalle" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="sombreado"><b> Movimientos del periodo </b></td>
              </tr>
              <tr>
                <td>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr class="sombreado al_der">
                      <td width="3%" align="left">N&ordm;</td>
                      <td width="17%" align="left">&nbsp; Fecha</td>
                      <td width="8%" align="left">No. Recibo</td>
                      <td width="8%">Cargo</td>
                      <td width="8%">Abono</td>
                      <td width="10%">Saldo</td>
                      <td width="9%">Ordinario <br /> IVA</td>
                      <td width="8%">Descuento <br /> IO</td> 
                      <td width="9%">Moratorio <br /> IVA</td>
                      <!-- <td width="60">Comision <br /> Cobranza</td> -->
                      <td width="10%">Saldo <br /> Vencido</td>
                      <td width="10%">Monto <br /> Pagado</td>
                    </tr>
                    @@detalle_de_movs@@
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="reumen">
          <td>
            <b> Pagos realizados: @@mens_pagadas@@ de @@mens_totales@@ </b>
            <br /><br />
          </td>
        </tr>
        <tr>           
          <td>         
            <table class="reumen" width="100%" border="0" cellspacing="0" cellpadding="0">                              
              <tr>     
                <th colspan="3">RESUMEN DE CARGOS OBJETADOS POR EL CLIENTE</th>                    
              </tr>    
              <tr class="cent">                      
                <td width="15%" class="borde_bajo">FECHA</td>                          
                <td width="15%" class="borde_bajo">IMPORTE</td>                        
                <td width="70%" class="borde_bajo">DESCRIPCION</td>                    
              </tr>    
              <tr height="40px">             
                <td colspan="3">Sin Movimientos</td>              
              </tr>
              <tr><td colspan="3">&nbsp;</td></tr>         
            </table>     
          </td>          
        </tr> 
        <tr>
          <td colspan="3">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="85%" class="texto_chico justificado">
<!--              COMISI&Oacute;N NACIONAL PARA LA PROTECCI&Oacute;N Y DEFENSA DE LOS USUARIOS DE SERVICIOS FINANCIEROS (CONDUSEF) <br />
                  En caso de dudas, quejas, reclamaciones o consultar informaci&oacute;n sobre las comisiones para fines informativos y de comparaci&oacute;n podr&aacute; 
                  acudir a la CONDUSEF con domicilio en Insurgentes Sur No 762, Colonia del Valle, Delegaci&oacute;n Benito Ju&aacute;rez, C&oacute;digo Postal 03100, 
                  M&eacute;xico Distrito Federal. 
                  Correo electr&oacute;nico webmaster@condusef.gob.mx Tel&eacute;fono 018009998080 y 53400999 o consultar la p&aacute;gina en Internet www.condusef.gob.mx <br /> 
-->
                  Capital Activo SA de CV SFP recibe las consultas, reclamaciones o aclaraciones, en su Unidad Especializada de Atenci&oacute;n a Usuarios, 
                  ubicada en Blvd. Solidaridad y L.D Colosio Edificio &#8220;B&#8221; tercer Piso, local 3 Col. Villa Sat&eacute;lite C.P.83200 y por correo electr&oacute;nico 
                  info@capitalactivo.com.mx o tel&eacute;fono (662) 2601148, as&iacute; como en cualquiera de sus sucursales u oficinas. En el caso de no 
                  obtener una respuesta Satisfactoria, podr&aacute; acudir a la Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los 
                  Usuarios de Servicios Financieros, www.condusef.gob.mx, tel&eacute;fonos: 01800 9998080 y 555340 0999 <br />

                  Advertencias: <br />
                  * Los intereses y comisiones de &eacute;ste periodo aparecer&aacute;n reflejados en los movimientos de su pr&oacute;ximo Estado de Cuenta. <br />
                  * En caso de que la fecha l&iacute;mite corresponda a un d&iacute;a inh&aacute;bil, el pago podr&aacute; efectuarse el d&iacute;a h&aacute;bil siguiente, sin cargo adicional alguno.<br />
                  * Incumplir con tus obligaciones te puede generar comisione e intereses. El avalista u obligado solidario o coacreditado responder&aacute; como 
                    obligado principal frente a la entidad financiera. <br /><br />
                  <center><b> AGRADECEMOS NOS COMUNIQUE SUS RECLAMACIONES EN UN PLAZO DE 90 DIAS DE LO CONTRARIO CONSIDERAREMOS SU CONFORMIDAD </b></center><br />
                </td>
                <td width="15%" class="top_texto der"><center><img src="/usr/local/saicoop/img_estado_cuenta_prestamos/rfc.jpg" width="79" height="137" /></center></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="texto_chico"> 
            I.V.A.- Impuesto al valor Agregado. <br />
            C.A.T.- Costo Anual Total. <br />
            Costo Anual Remanente. No aplica.<br />
            Tipo de Cambio: M.N .- Moneda Nacional
          </td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="reumen">
              <tr>
                <td width="80%" class="alinear_abajo raya_baja negrita">Sello Digital del CFDI :</td>
              </tr>
              <tr>
                <td width="80%" class="alinear_abajo">@@sello_del_emisor@@</td>
              </tr>
              <tr>
                <td width="80%" class="alinear_abajo negrita">Sello digital del SAT :</td>
              </tr>
              <tr>
                <td width="80%" class="alinear_abajo">@@sello_digital_sat@@</td>
              </tr>
              <tr>
                <td width="80%" class="alinear_abajo negrita">Cadena original del complemento de certificacion digital del SAT :</td>
              </tr>
              <tr>
                <td width="80%" class="alinear_abajo">@@cadena_original_complemento_certificacion_sat@@</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table class="reumen" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="3" class="raya_baja"> &nbsp; </td>
              </tr> <!--
              <tr>
                <td width="10%"><center><img src="/usr/local/saicoop/img_estado_cuenta_prestamos/CNBV.jpg" width="82" height="84" /></center></td>
                <td width="80%" class="alinear_abajo">Supervisada por la Comision Nacional Bancaria y de Valores. <br />
                                                      Regulada por la Ley de Ahorro y Credito Popular. <br /><br /></td>
                <td width="10%"><center><img src="/usr/local/saicoop/img_estado_cuenta_prestamos/UHCP.jpg" width="85" height="85" /></center></td>
              </tr> -->
              <tr>
                <td colspan="3">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="6%">&nbsp;</td>
                      <td width="88%" class="texto_pie">Blvd. Solidaridad y L D. Colosio &quot;B&quot;, Tercer piso, local 3 Hermosillo, 
                                                                  Sonora C.P. 83200</td>
                      <td width="6%">&nbsp;</td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td class="texto_pie">Tel: (662) 260 1148 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; www.capitalactivo.com.mx  
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RFC: CAC0708177N8 </td>
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </div>
  </body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
',3);
