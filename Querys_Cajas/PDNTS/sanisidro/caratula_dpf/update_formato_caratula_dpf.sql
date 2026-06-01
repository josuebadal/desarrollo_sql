--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';

--ACTALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';

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
.encabezado {
	font-size: 24pt;
	font-family: Georgia, "Times New Roman", Times, serif;
	text-decoration: underline;
	color: #093;
}
.encabezado_2 {
	font-size: 10pt;
	font-family: Georgia, "Times New Roman", Times, serif;
	text-decoration: underline;
	color: #093;
}
.alinear_top {
	vertical-align: top;	
}
.texto_resumen {
	font-size: 10pt;
}
.alinear_der {
	text-align: right;
}
.borde_total {
	border: 1px solid #000;
}
.borde_bajo {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #000;
}
.texto_menor {
	font-size: 8pt;
}
.borde_der {
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #000;
}
</style>
</head>
<body>
<div class="contenedor">
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr><td><p align="right"><b> Registro de Contratos de Adhesi&oacute;n N&uacute;mero: </b>  @@numero_contrato_condusef@@ </p></td></tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="18%"><center><img src="/usr/local/saicoop/img_caratula_dpf/logo.jpg" alt="" width="121" height="130" /></center></td>
            <td width="2%">&nbsp;</td>
            <td width="80%">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="encabezado">
                    Caja San Isidro <br />
                    S.C. de A.P. de R.L. de C.V. <br />
                  </td>
                </tr>
                <tr>
                  <td class="encabezado_2">
                    Ter&aacute;n 503 oriente Colonia Centro CP 26500 Morelos, Coahuila. <br />
                    Tel. (862) 62 40 450 y 62 40 304 <br />
                    cajasanisidro@gmail.com
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table class="borde_total texto_resumen" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Nombre comercial del Producto: </b> @@tipo_dpf@@ </td>
          </tr>
          <tr>
            <td><b> Tipo de Operaci&oacute;n: </b> PASIVA </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>          
          <tr>
            <td class="borde_bajo">
              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                <tr>
                  <td width="25%" class="borde_der borde_bajo"><center><b> TASA DE INTER&Eacute;S FIJA </b></center></td>
                  <td width="25%" class="borde_der borde_bajo"><center><b>GANANCIA ANUAL TOTAL NETA <span style="font-size:18px"> GAT </span></b></center></td>
                  <td width="50%" class="borde_bajo"><center><b> COMISIONES RELEVANTES </b></center></td>
                </tr>
                <tr>
                  <td class="borde_der"><center> @@tasa_io_anual_99.99@@ % <br /> anual </center></td>
                  <td class="borde_der"><center><font size=5>@@gat_nominal_99.99@@%</font><br>
        Antes de impuestos para 
        fines informativos y de 
        comparaci￳n.</center></td>
                  <td> 
                    ___Manejo de cuenta <br />
                    ___Transferencia interbancaria <br />
                    ___Retiro en efectivo <br />
                    ___Consulta de saldo v&iacute;a internet <br />
                    ___Consulta de saldos en sucursales <br />
                    <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>Reposici&oacute;n  de libreta $10.00 pesos por robo o extrav&iacute;o <br /><br />
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="50%" class="borde_der"><br /><center><b> MEDIOS DE DISPOSICI&Oacute;N </b></center></td>
                  <td width="50%"><br /><center><b> LUGARES PARA EFECTUAR RETIROS </b></center></td>
                </tr>
                <tr>
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="30%"><center> ___Tarjeta </center><br /></td>
                        <td width="36%"><center> ___Chequera </center><br /></td>
                        <td width="34%" class="borde_der"><center> <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>Efectivo </center><br /></td>
                      </tr>
                    </table>
                  </td>
                  <td><center> Ventanilla de la Cooperativa <br /><br /></center></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> ESTADO DE CUENTA </b></td>
          </tr>
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="33%"> ___Enviar a domicilio </td>
                  <td width="34%"> ___Consulta v&iacute;a internet </td>
                  <td width="33%"> <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>A petici&oacute;n del socio en sucursal </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Producto garantizado hasta por 25 mil UDIS por el Fondo de Proteci&oacute;n </b></td>
          </tr>
          <tr>
            <td>Titular Garantizado(s): @@nombre_socio@@ </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Aclaraciones y reclamaciones: </b></td>
          </tr>
          <tr>
            <td>
              Unidad Especializada de Atenci&oacute;n a Usuarios: Lic. Rosaura Paola Zertuche de Hoyos <br />
              Domicilio: Calle Ter&aacute;n 503 oriente, Centro,  Morelos, Coahulia, M&eacute;xico. CP 26500 <br />
              Tel&eacute;fono: (862) 624 0304 y 624 0450 Correo electr&oacute;nico: cajasanisidro@gmail.com  <br />
              P&aacute;gina de Internet: www.cajasanisidro.com.mx <br />
              Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF): <br />
              Tel&eacute;fono: 01 800 999 8080 y (55) 53400999. P&aacute;gina de Internet: www.condusef.gob.mx
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              El socio autoriza a la Cooperativa a utilizar los datos personales informados para fines de publicidad y promoci&oacute;n de sus productos
            </td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="50%"><center> ___SI </center></td>
                <td width="50%"><center> ___NO </center></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td> 
              <center> _____________________________________ <br />
              Firma </center>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
'
WHERE idtabla='param' 
AND idelemento='formato_caratula_dpf';
