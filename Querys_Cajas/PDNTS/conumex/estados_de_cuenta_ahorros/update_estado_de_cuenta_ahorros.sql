UPDATE tablas
set tipo = -456
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';

UPDATE tablas
set tipo = 0
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';

UPDATE tablas
set dato2 = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>estado_cuenta_ahorro</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
      .contenedor {
          height: 25cm;
          width: 19cm;
          font-family: Arial, Helvetica, sans-serif;
      }
      .encabezado {
          font-size: 14px;
          text-align: center;
          font-weight: bold;
      }
      .texto_sub {
          text-align: center;
          font-size: 8pt;
      }
      .fondo_celda {
          background-color: #CCC;
      }
      .texto_der {
          text-align: right;
      }
      .texto_top {
          vertical-align: top;
      }
      .formato_texto {
          font-size: 10pt;
      }
      .formato_texto_sub {
          font-size: 11pt;
          text-align: center;
      }
      .borde_total {
          border: 2px solid #000;
      }
      .borde_bajo,  .borde_arriba_abajo, .borde_c, .borde_resumen {
          border-bottom-width: 1px;
          border-bottom-style: solid;
          border-bottom-color: #000;
      }      
      .borde_arriba, .borde_arriba_abajo, .borde_c, .borde_resumen {
          border-top-width: 1px;
          border-top-style: solid;
          border-top-color: #000;
      }
      .borde_der_2  {
          border-right-width: 2px;
          border-right-style: solid;
          border-right-color: #000;
      }
      .borde_izq, .borde_c, .borde_resumen {
          border-left: 1px solid #000;
      }
      .borde_der, .borde_resumen{
          border-right: 1px solid #000;
      }
      .borde_bajo_2 {
          border-bottom-width: 2px;
          border-bottom-style: solid;
          border-bottom-color: #000;
      }      
      .borde {
          border-top-width: 2px;
          border-right-width: 2px;
          border-bottom-width: 2px;
          border-left-width: 2px;
          border-top-style: none;
          border-right-style: none;
          border-bottom-style: solid;
          border-left-style: none;
          border-top-color: #000;
          border-right-color: #000;
          border-bottom-color: #000;
          border-left-color: #000;
      }
      .sub_encabe_tabla {
          text-align: center;
          font-weight: bold;
          text-align: center;
          font-size: 8pt;
          border-bottom-width: 2px;
          border-bottom-style: solid;
          border-bottom-color: #000;
      }  
    </style>
  </head>
  <body>
    <div class="contenedor">
      <table class="borde_total" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <table class="encabezado borde" width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td class="texto_top" width="20%">
                  <center>
                    <img src="/usr/local/saicoop/img_estado_cuenta_ahorros/logo.jpg" alt=""  width="100" height="100" />
                  </center>
                </td>
                <td width="80%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  	<tr><td>ESTADO DE CUENTA</td></tr>
                    <tr>
                      <td class="encabezado"> @@h_l1@@  </td>
                    </tr>
                    <tr>
                      <td class="texto_sub">
                        @@h_l2@@ <br />
                        @@h_l3@@ <br />
                        @@h_l4@@
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="56%"> 
                  <b> Nombre: </b> @@nombre@@ <br />
                  <b> Domicilio: </b> @@domicilio@@ <br />
                  <b> RFC: </b> @@rfc@@ <br />
                  <b> N&uacute;mero de socio: </b> @@cuenta@@ <br />
                  <b> Producto: </b> @@nom_producto@@ 
                </td>
                <td class="texto_top" width="44%">
                  <b> Sucursal: </b> @@sucursal@@ <br />
                  @@domicilio_sucursal@@
                </td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="61%"><b> Saldo inicial:</b></td>
                      <td class="texto_der" width="32%">$ @@saldo_inicial@@</td>
                      <td width="7%">&nbsp;</td>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <tr>
                      <td><b>+ Dep&oacute;sitos</b></td>
                      <td class="texto_der">$ @@depositos_sin_io@@ </td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><b>&nbsp;&nbsp; Intereses generados en el periodo</b></td>
                      <td class="texto_der">$ @@io@@</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="texto_der"><b>total:</b></td>
                      <td class="borde_arriba texto_der">$ @@depositos@@</td>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <tr>
                      <td><b>- Retiros</b></td>
                      <td class="texto_der">$ @@retiros_sin_isr@@ </td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><b>&nbsp;&nbsp; ISR retenido en el per&iacute;odo</b></td>
                      <td class="texto_der">$ @@isr_retenido@@</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><b>&nbsp;&nbsp; Comisiones efectivamente cobradas</b></td>
                      <td class="texto_der">$ 0.00</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="texto_der"><b>total:</b></td>
                      <td class="borde_arriba texto_der">$ @@retiros@@ </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><b> Saldo al @@pf2@@</b></td>
                      <td class="texto_der">$ @@saldo_final@@</td>
                      <td>&nbsp;</td>
                    </tr>
                    <!--
                    <tr>
                      <td><b> IDE retenido en el periodo</b></td>
                      <td class="texto_der">@@ide_retenido@@</td>
                      <td>&nbsp;</td>
                    </tr>
                    -->
                    <!--
                    <tr>
                      <td class=" borde_bajo_2 borde_der_2">&nbsp;</td>
                      <td class="borde_bajo_2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="borde_der_2"><b>D&iacute;as transcurridos</b></td>
                      <td class="texto_der">@@diferencia_periodo@@</td>
                    </tr>
                    -->
                    <tr><td colspan="3">&nbsp;</td></tr>
                  </table>
                </td>
                <td>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="38%"><b>Per&iacute;odo</b></td>
                      <td colspan="2" class="texto_der" width="62%">@@pf1@@ al @@pf2@@</td>
                    </tr>
                    <tr>
                      <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                      <td colspan="2" width="62%"><b> Saldo m&iacute;nimo:</b></td>
                      <td class="texto_der" width="38%">@@saldo_minimo@@</td>
                    </tr>
                    <tr>
                      <td colspan="2"><b>Saldo promedio diario del per&iacute;odo:</b></td>
                      <td class="texto_der">$ @@saldo_promedio@@</td>
                    </tr>
                    <!--<tr>
                      <td colspan="2"><b> Moneda:</b></td>
                      <td class="texto_der">Moneda Nacional</td>
                    </tr>--->
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <tr>
                      <td colspan="3">
                        <table class="borde_c" width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td><b> Moneda:</b></td>
                            <td class="texto_der">Moneda Nacional</td>
                          </tr>
                          <!---<tr>
                            <td width="81%"><b> Tasa de inter&eacute;s Mensual: </b></td>
                            <td class="texto_der" width="19%">@@tasaio_mensual_99.99@@%</td>
                          </tr>--->
                          <tr>
                            <td><b> Tasa de inter&eacute;s fija Anual: </b></td>
                            <td class="texto_der">@@tasaio_anual@@%</td>
                          </tr>
                          <!--
                          <tr>
                            <td><b> Comisiones Efectivamente Cobradas: </b></td>
                            <td class="texto_der">0.00</td>
                          </tr>
                          -->
                          <tr>
                            <td colspan="2">
                              <p align="center">
                                GAT Nominal <font size="3"><b><u>@@gat_nominal_99.99@@ </u>%</b> </font><br>
                                GAT Real <font size="3"><b><u>@@gat_real_99.99@@</u> %</b></font> <br>
                              </p>
                              <p align="center">
                                Antes de impuestos "La GAT real es el rendimiento que obtendr&iacute;a 
                                despu&eacute;s de descontar la inflaci&oacute;n estimada".
                              </p>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="9"><b>Comisiones Efectivamente cobradas 0.00</b></td>
              </tr>
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="9"><b>Impuestos retenidos:</b>
                aplica la retenci&oacute;n ISR anual, por el pago de intereses, sobre el excedente, conforme a lo dispuesto en el art&iacute;culo 24 de la Ley Ingresos de la Federaci&oacute;n</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="9"><b> Movimientos del periodo </b></td>
              </tr>
              <tr align="center">
                <td width="5%" class="sub_encabe_tabla"><b> Num. </b></td>
                <td width="1%" class="sub_encabe_tabla borde_der_2" >&nbsp;</td>
                <td width="16%" class="sub_encabe_tabla borde_der_2"> Fecha </td>
                <td width="15%" class="sub_encabe_tabla borde_der_2"><b> Lugar de pago </b></td>
                <td width="33%" class="sub_encabe_tabla borde_der_2"><b> Concepto </b></td>
                <td width="10%" class="sub_encabe_tabla borde_der_2"><b> Retiro </b></td>
                <td width="10%" class="sub_encabe_tabla borde_der_2"><b> Dep&oacute;sito </b></td>
                <td width="10%" class="sub_encabe_tabla"><b> Saldo </b></td>
              </tr>
              @@detalle_de_movs@@
              <tr>
                <td class="borde_arriba_abajo" colspan="9"><b>Movimientos realizados: </b>@@cont_movs@@</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="8"><b> Detalle de comisiones </b></td>
              </tr>
              <tr align="center">
                <td width="20%" class="borde_bajo borde_der_2"><b> Fecha </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Sucursal </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Concepto </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Cargo </b></td>
                <td width="20%" class="borde_bajo"><b> Abono </b></td>
              </tr>
              <!-- @@detalle_de_movs@@ -->
            </table>
          </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="8"><b> Cargos objetados </b></td>
              </tr>
              <tr align="center">
                <td width="20%" class="borde_bajo borde_der_2"><b> Fecha </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Sucursal </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Concepto </b></td>
                <td width="20%" class="borde_bajo borde_der_2"><b> Cargo </b></td>
                <td width="20%" class="borde_bajo"><b> Abono </b></td>
              </tr>
              <!-- @@detalle_de_movs@@ -->
            </table>
          </td>
        </tr>
        <tr>
          <td class="borde_bajo">&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              
              <tr><th class="borde_arriba_abajo formato_texto_sub"><b>AVISOS</b></th></tr>
              <tr>
                <td>
                  Cooperativa Nuevo M&eacute;xico, S.C. de A.P. de R.L. de C.V. recibe las consultas, reclamaciones o aclaraciones, en su Unidad Especializada de Atenci&oacute;n a Usuarios en la oficina Matriz, con domicilio en Consejo de Administraci&oacute;n #1, M&eacute;xico Nuevo, Atizap&aacute;n de Zaragoza, Estado de M&eacute;xico, C.P. 52966 y por correo electr&oacute;nico a une@conumex.coop o a los tel&eacute;fonos 55 50226-0013 y 55 5026-0014 extensi&oacute;n 123. En el caso de no obtener respuesta satisfactoria, podr&aacute; acudir a la Comisi&oacute;n Nacional para la Defensa de Usuarios de Servicios Financieros. www.condusef.gob.mx; con tel&eacute;fono: 800 999 8080 y 55 5340 0999. 
                </td>
              </tr>
              <!--<tr> 
                <td>
                       1. Cuentas con 90 d&iacute;as naturales a partir de la fecha de impresi&oacute;n del estado de cuenta para objetar el 
                       mismo. Cooperativa Nuevo M&eacute;xico, S.C. de A.P. de R.L.  de C.V. recibe las consultas, reclamaciones o 
                       aclaraciones, en su Unidad Especializada de Atenci&oacute;n a Usuarios, ubicada en la Oficina Matriz, con 
                       domicilio en Consejo de Administraci&oacute;n  #1 M&eacute;xico Nuevo, Atizap&aacute;n de Zaragoza, Estado de M&eacute;xico, C.P. 
                       52966  y por correo electr&oacute;nico a une@conumex.coop o a los tel&eacute;fonos 55 5026-0013 y 55 5026-0014 
                       extensi&oacute;n 123, as&iacute; como en cualquiera de sus sucursales u oficinas. En el caso de no obtener una 
                       respuesta satisfactoria, podr&aacute; acudir a la Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los 
                       Usuarios de Servicios Financieros. (p&aacute;gina de internet: www.conducef.gob.mx  correo electr&oacute;nico:  asesoria@conducef.gob.mx 
                       tel&eacute;fono: 01800-999-80-80).<br><br />
                       2. Producto garantizado por  el FONDO DE PROTECCION por un monto de 25,000 UDIS o su equivalente <br> a la fecha de corte de:<b><u> $@@udi_pesos@@ </u>(@@udi_pesos_letra@@).</b><br><br>
                </td>
              </tr>
              
              <tr>
                <td colspan="6">
                    1.- Cuentas con 90 d&iacute;as naturales a partir de la fecha de impresi&oacute;n del estado de cuenta para 
                        objetar el mismo. <br />
                        Si se presenta esta situaci&oacute;n el procedimiento a seguir, ser&aacute; presentando tu 
                        reclamaci&oacute;n por escrito, o envi&aacute;ndolo por correo electr&oacute;nico al Representante de 
                        la UNE de tu cooperativa. La cual esta ubicada en: <br />
                        Consejo de Administraci&oacute;n No.1, M&eacute;xico Nuevo, Atizap&aacute;n de Zaragoza, Estado de 
                        M&eacute;xico C.P. 52966
                </td>
              </tr>
              <tr>
                <td width="10%"> Tel&eacute;fono:  </td>
                <td width="35%" class="borde_bajo"> (55)50260013 </td>
                <td width="5%"> &nbsp; </td>
                <td width="18%"> Correo electr&oacute;nico:  </td>
                <td width="22%" class="borde_bajo"> une@conumex.com.mx </td>
                <td width="10%"> &nbsp; </td>
              </tr>
              -->
              <tr>
                   <td class="borde_bajo">&nbsp;</td>
              </tr>
                <tr><td>&nbsp;</td></tr>
        <tr>
          <td class="borde_arriba_abajo formato_texto_sub"><b>ACLARACIONES</b></td>
        </tr>
        <tr>
          <td class="borde_total_u reumen">
            EL SOCIO deber&aacute; presentar su solicitud de aclaraci&oacute;n, en un plazo que no exceda de noventa d&iacute;as naturales contados a partir de la fecha de corte, o bien de la operaci&oacute;n o servicio, dirigida a la Unidad Especializada de "LA COOPERATIVA" le acusara de reicibida dicha solicitud de aclaraci&oacute;n, siempre y cuando "EL SOCIO" cumpla con el plazo y t&eacute;rminos establecidos. "LA COOPERATIVA" resolver&aacute; la aclaraci&oacute;n planteada en un t&eacute;rmino no mayor a 45 d&iacute;as naturales, por escrito o por correo electr&oacute;nico que haya proporcionado "EL SOCIO".
          </td>
        </tr>
        <tr>
                   <td class="borde_bajo">&nbsp;</td>
              </tr>
                <tr><td>&nbsp;</td></tr>
            <tr>
          <td class="borde_arriba_abajo formato_texto_sub"><b>GLOSARIO DE ABREVIATURAS</b></td>
        </tr>
        <tr>
          <td class="borde_total_u reumen">
            GAT Ganancia Anual Total <br />
            ISR Impuesto Sobre la Renta <br />
            RFC Registro Federal de Contribuyentes.
          </td>
        </tr>
              <tr>
                   <td class="borde_bajo">&nbsp;</td>
              </tr>
              <tr><td>&nbsp;</td></tr>

      <!--- <tr>
          <td class="borde_total_u reumen borde_arriba_abajo">
            Producto garantizado por el FONDO DE PROTECCION por un monto 25,000 UDIS o su equivalente a la fecha de corte, que es de $ @@udi_pesos@@, (@@udi_sin_conv@@)
          </td>
        </tr>--->
        <tr>
          <td class="borde_total_u reumen borde_arriba_abajo">
            Producto garantizado hasta por 25,000.00 UDIS por el FONDO DE PROTECCION a que hace referencia la Ley de Ahorro y Cr&eacute;dito Popular o la LRASCAP a la fecha de corte.
          </td>
        </tr>

            </table>
          </td>
        </tr>
       <!--- <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="18%"> P&aacute;gina de internet:  </td>
                <td width="32%" class="borde_bajo"> www.conumex.coop </td>
                <td width="50%"> &nbsp; </td>
              </tr>-->
             <!-- <tr>
                <td colspan="3">
                    Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros 
                    (CONDUSEF): Tel&eacute;fono: 01 800 999 8080 y 53400999. P&aacute;gina de internet. 
                    www.condusef.gob.mx. <br />
                    * Descripci&oacute;n de Referencia: Los primeros 2 d&iacute;gitos corresponden a la sucursal, los 
                    siguientes 2 al tipo de p&oacute;liza (01 ingreso, 02 egreso, 03 diario), los &uacute;ltimos 6 
                    d&iacute;gitos corresponden al conscutivo de p&oacute;liza del mes. <br />
                    GAT.- Ganancia Anual Total. <br />
                    ISR.- Impuesto sobre la Renta, se cobra a raz&oacute;n del 0.60% sobre el excedente de cinco salarios 
                    m&iacute;nimos del D.F. elevados al a&ntilde;o. <br />
                    El presente Estado de Cuenta no es un comprobante para efectos fiscales, si requiere comprobante fiscal 
                    debera solicitarlo a la sucursal que le corresponde. <br />
                </td>
              </tr>
            </table>
          </td>
        </tr>-->
        
        <tr>
          <td class="borde_bajo">&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="borde_arriba_abajo formato_texto_sub" colspan="9">
                  <b>REFERENCIA PARA TRANSFERENCIA ELECTRONICA</b>
                </td>
                <tr><td>Banco INBURSA</td></tr>
                <tr><td>Cta. No. 50048837541</td></tr>
                <tr><td>Clave interbancaria 036180500488375411</td></tr>
                <tr><td class="borde_bajo">Titular: Cooperativa nuevo M&eacute;xico S.C. de A.P. de R.L. de C.V.</td></tr>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                 <td>Nota: En caso de extravi&oacute; o perdida de la libreta se cobrar&aacute; $20.00 + IVA Por reposici&oacute;n.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="formato_texto texto_der">
          <td><b> Fecha de impresi&oacute;n @@fecha_impresion@@ </b></td>
        </tr>
      </table>
    </div>
  </body>
</html>'
WHERE idtabla='param' AND idelemento='formato_estado_cuenta_ahorros';