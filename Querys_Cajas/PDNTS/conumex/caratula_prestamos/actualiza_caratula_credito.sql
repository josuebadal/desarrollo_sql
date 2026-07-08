UPDATE tablas 
set tipo = -456 
WHERE LOWER(idtabla) = 'param' 
AND LOWER(idelemento) = LOWER('formato_caratula_prestamo');

UPDATE tablas 
set dato2 = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <style type="text/css">
    .contenedor {
      height: 25cm;
      width: 19cm;
      font-family: Arial, Helvetica, sans-serif;
    }
    .texto_sub {
      text-align: center;
      font-size: 8pt;
    }
    .texto_central {
      font-size: 10pt;
    }
    .texto_logo {
      font-size: 14pt;
      font-weight: bold;
      text-align: center;
    }
    .encabezado {
      font-size: 10pt;
      font-weight: bold;
      text-align: center;
    }
    .alinear_der {
      text-align: right;
    }
    .borde_inferior_3 {
      border-bottom-width: 1px;
      border-bottom-style: solid;
      border-bottom-color: #000;
    }
    .borde_abajo {
      border-bottom-width: 1px;
      border-bottom-style: solid;
      border-right-color: #000;
      border-bottom-color: #000;
      border-left-color: #000;
      border-top-color: #000;
    }
    .linea_abajo {
      border-bottom-width: 1px;
      border-bottom-style: solid;
      border-bottom-color: #000;
    }
    .borde_izq {
      border-left-width: 1px;
      border-left-style: solid;
      border-left-color: #000;
    }
    .borde_completo {
      border: 1px solid #000;
    }
    .texto_top {
      vertical-align: top;
    }
  </style>
  <script type="text/javascript">
    window.onload = function seccion() {
      var ent = document.getElementById("entre");
      var con = document.getElementById("consu");

      if (@@idproducto@@ == 30902 || @@idproducto@@ == 30912 || @@idproducto@@ == 30922) {
        ent.innerHTML = "Entrega: En sucursal y Servicio Electr&oacute;nico por Internet Conumex M&oacute;vil y en L&iacute;nea";
        con.innerHTML = "Consulta: En sucursal y Servicio Electr&oacute;nico por Internet Conumex M&oacute;vil y en L&iacute;nea";
      }
    };
  </script>
</head>
<body>
  <div class="contenedor">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%"><center><img src="/usr/local/saicoop/img_caratula_ahorros/logo.jpg" alt="" width="100" height="100" /></center></td>
            <td width="80%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="texto_logo">
                  Cooperativa Nuevo M&eacute;xico, S.C. de A.P. de R.L. de C.V.
                </td>
              </tr>
              <tr>
                <td class="texto_sub">
                  Consejo de Administraci&oacute;n L 1 M F Z 2 No. 1, <br />
                  Col. M&eacute;xico Nuevo, Atizap&aacute;n de Zaragoza, Estado de M&eacute;xico CP. 52966 <br />
                  Tel: 55 50260013 Y 55 50260014<br />
                  R.F.C. NME970326TW1
                </td>
              </tr>
            </table></td>
          </tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr><td colspan="2">&nbsp;</td></tr>
        </table></td>
      </tr>
      <tr>
        <td colspan="2" class="borde_completo"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="30%"> Nombre comercial del Producto: </td>
                <td width="1%">&nbsp;  </td>
                <td width="69%"> @@nombre_prestamo@@ </td>
              </tr>
              <tr>
                <td >Tipo de Operacion: </td>
                <td >&nbsp; </td>
                <td > Activa</td>
              </tr>
              <tr><td colspan="4" class="borde_abajo">&nbsp;</td></tr>
              <tr>
                <td colspan="4"><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="30%" class="linea_abajo"> <center><b><font size=4> CAT </font> <br /> <font size=3> (COSTO ANUAL TOTAL) </font> </b></center></td>
                    <td width="25%" class="borde_izq linea_abajo"><center><b> TASAS DE INTERES FIJA ANUAL </b></center></td>
                    <td width="21%" class="borde_izq linea_abajo"><center><b> MONTO DE CREDITO </b></center></td>
                    <td width="24%" class="borde_izq linea_abajo"><center><b> MONTO TOTAL A <br/> PAGAR </b></center></td>
                  </tr>
                  <tr>
                    <td><center><font size=4><b> @@cat@@% </b></font></center></td>
                    <td class="borde_izq"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="50%" class="alinear_der">ORDINARIA:<b><u>@@io_anual@@%</u></b> FIJA<BR>MORATORIA:<b><u>@@im_anual@@%</u></b> FIJA</td>
                        <td width="50%" > &nbsp;  </td>
                      </tr>
                    </table></td>
                    <td class="borde_izq"><center> $ @@monto_credito_formato@@ </center></td>
                    <td class="borde_izq"><center> $ @@monto_pagar@@ </center></td>
                  </tr>
                  <tr>
                    <td><b><center> SIN IVA PARA <br /> FINES INFORMATIVOS <br/> Y DE COMPARACION </center></b></td>
                    <td class="borde_izq">&nbsp;  </td>
                    <td class="borde_izq">&nbsp;  </td>
                    <td class="borde_izq">&nbsp;  </td>
                  </tr>
                  <tr>
                    <td class="borde_abajo">&nbsp;  </td>
                    <td class="borde_abajo borde_izq">&nbsp;  </td>
                    <td class="borde_abajo borde_izq">&nbsp;  </td>
                    <td class="borde_abajo borde_izq">&nbsp;  </td>
                  </tr>
                  <tr>
                    <td colspan="4"><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="30%" class="texto_top borde_abajo"> <b> PLAZO DEL CREDITO: <br/> @@plazo@@ meses </b> </td>
                        <td width="70%" class="borde_izq borde_abajo">
                          <b> FECHA LIMITE DE PAGO:
                            &nbsp;&nbsp;&nbsp;
                            @@siguiente_pago@@,
                          </b>&nbsp;&nbsp;&nbsp;&nbsp;
                          para las subsecuentes fecha <br/>
                          limite de pago consulte el plan de amortizaci&oacute;n de pagos,
                          anexo al contrato <br/>
                          <b> FECHA DE CORTE:
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            @@siguiente_pago@@,
                          </b>&nbsp;&nbsp;&nbsp;&nbsp;
                          para las subsecuentes fechas de <br/>
                          corte consulte el plan de amortizaci&oacute;n de pagos,
                          anexo al contrato
                        </td>
                      </tr>
                      <tr>
                        <td colspan="5"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td colspan="2" class="encabezado borde_abajo"> COMISIONES RELEVANTES </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              @@comisiones_relevantes@@
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2" class="encabezado borde_abajo"> ADVERTENCIAS </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              @@advertencia_comision@@<br />
                            </td>
                          </tr>
                          <tr>
                            <td class="borde_abajo">&nbsp; </td>
                            <td class="borde_abajo">&nbsp; </td>
                          </tr>
                          <tr>
                            <td colspan="2" class="encabezado borde_abajo"> <b> SEGUROS </b> </td>
                          </tr>
                          <tr>
                            <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="40%"><center><b> SEGURO: </b></center></td>
                                <td width="30%" class="borde_izq"><center><b> ASEGURADORA: </b></center></td>
                                <td width="30%" class="borde_izq"><center><b> CLAUSULA DEL CONTRATO: </b></center></td>
                              </tr>
                              <tr>
                                <td class="borde_abajo"><center> @@seguro@@ </center></td>
                                <td class="borde_izq borde_abajo"><center> @@aseguradora@@ </center></td>
                                <td class="borde_izq borde_abajo"><center> @@clausula_seguro@@ </center></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td colspan="2" class="encabezado borde_abajo"> <b> ESTADO DE CUENTA </b> </td>
                          </tr>
                          <tr>
                            <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="12%"> &nbsp; </td>
                                <td class="alinear_der" width="22%"> <input type="checkbox" checked><a id="entre">Entrega: En sucursal.</a></td>
                                <td width="12%">&nbsp;</td>
                                <td width="12%">&nbsp;</td>
                                <td class="alinear_der" width="22%"> <input type="checkbox" checked><a id="consu">Consulta: En sucursal.</a></td>
                                <td width="6%">&nbsp;</td>
                                <td width="12%">&nbsp;</td>
                              </tr>
                              <tr>
                                <td colspan="8" class="borde_abajo">&nbsp;</td>
                              </tr>
                              <tr>
                                <td colspan="8"><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td colspan="4"> <b> ACLARACIONES Y RECLAMACIONES: </b> </td>
                                  </tr>
                                  <tr>
                                    <td colspan="4"> Unidad Especializada de Atenci&oacute;n de Consultas y Reclamaciones (UNE): </td>
                                  </tr>
                                  <tr>
                                    <td colspan="4"> Domicilio: Consejo de Administraci&oacute;n No. 1, M&eacute;xico Nuevo, Atizap&aacute;n de Zaragoza, Estado de M&eacute;xico C.P. 52966</td>
                                  </tr>
                                  <tr>
                                    <td><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="18%"> Tel&eacute;fono:</td>
                                        <td width="25%"> (55)50260013  ext:123</td>
                                        <td width="25%"> Correo  electr&oacute;nico: </td>
                                        <td width="30%"> une@conumex.coop </td>
                                      </tr>
                                      <tr>
                                        <td> P&aacute;gina de internet:</td>
                                        <td colspan="3"> www.conumex.coop </td>
                                      </tr>
                                      <tr>
                                        <td class="borde_abajo">&nbsp; </td>
                                        <td colspan="3" class="borde_abajo">&nbsp; </td>
                                      </tr>
                                      <tr>
                                        <td colspan="4"><table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td colspan="2"> <b> REGISTRO DE CONTRATOS DE  ADHESI&Oacute;N N&Uacute;MERO: @@numero_contrato_condusef@@ </b> </td>
                                          </tr>
                                          <tr>
                                            <td colspan="2"> Comisi&oacute;n Nacional para la Protecci&oacute;n y  Defensa de los Usuarios de Servicios Financieros (CONDUSEF) </td>
                                          </tr>
                                          <tr>
                                            <td width="40%"> Tel&eacute;fono: 800 999 8080  y  (55)53400999. </td>
                                            <td width="60%"> P&aacute;gina de internet:  www.condusef.gob.mx </td>
                                          </tr>
                                          <tr><td colspan="2">&nbsp;</td></tr>
                                        </table></td>
                                      </tr>
                                    </table></td>
                                  </tr>
                                </table></td>
                              </tr>
                            </table></td>
                          </tr>
                        </table></td>
                      </tr>
                    </table></td>
                  </tr>
                </table></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table>
  </div>
</body>
</html>
' 
WHERE LOWER(idtabla) = 'param' 
AND LOWER(idelemento) = LOWER('formato_caratula_prestamo');

UPDATE tablas 
set tipo = 3 
WHERE LOWER(idtabla) = 'param' 
AND LOWER(idelemento) = LOWER('formato_caratula_prestamo');