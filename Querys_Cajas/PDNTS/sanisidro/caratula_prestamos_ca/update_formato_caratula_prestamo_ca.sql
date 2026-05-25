--QUITAMOS CANDADO PARA PODER ACTUALIZAR
UPDATE tablas
set tipo = -456
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';

--ACTUALIZAMOS PARAMETRO PARA EDICION
UPDATE tablas
set tipo = 0
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';

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
}
.borde_alto {
  border-top-width: 1px;
  border-top-style: solid;
  border-top-color: #000;
}
.texto_menor {
  font-size: 8pt;
}
.borde_der {
  border-right-width: 1px;
  border-right-style: solid;
  border-right-color: #000;
}
.borde_izq {
  border-left-width: 1px;
  border-left-style: solid;
  border-left-color: #000;

}
</style>
</head>
<body>
<div class="contenedor">
  <table width="100%" border="0" cellspacing="0" cellpadding="2" class="borde_der borde_izq " 
  style="border-top-width: 1px;
  border-top-style: solid; 
  border-top-color: #000;">
    <tr>                                   
      <td colspan="4" class="alinear_der" ><b> Registro de Contratos de Adhesi&oacute;n N&uacute;m: <a id="num_contrato">5021-140-017422/07-01100-0526</a></b></td>
    </tr>
    
    <tr></tr>          
    <tr>
      <td width="18%"><center><img src="/usr/local/saicoop/img_caratula_prestamos/logo.jpg" alt="" width="121" height="130" /></center></td>
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
              cajasanisidrocsi@gmail.com
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
  </table>

  <table class="texto_resumen borde_total" width="100%" border="0" cellspacing="0" cellpadding="2">    
    <tr>
      <td class="borde_bajo" colspan="4"><center><b> CARATULA DE CR&Eacute;DITO</b></center></td>
    </tr>
    <tr>
      <td class="borde_bajo borde_der" width="25%"><center><b> CAT <br>(COSTO ANUAL TOTAL) <br><u>@@cat@@</u> % </b></center><br /></td>
      <td class="borde_bajo borde_der" width="25%"><center><b> TASA DE INTER&Eacute;S ANUAL ORDINARIA Y MORATORIA. </b></center><br /></td>
      <td class="borde_bajo borde_der" width="24%"><center><b> MONTO DEL CR&Eacute;DITO</b></center><br /></td>
      <td class="borde_bajo" width="26%"><center><b> MONTO TOTAL A PAGAR O MINIMO A PAGAR </b></center> <br /></td>
    </tr>
    <tr>
      <td class="borde_bajo borde_der"><center> <b> SIN IVA PARA FINES INFORMATIVOS Y DE COMPARACI&Oacute;N </b></center><br /></td>
      <td class="borde_bajo borde_der"> <b>Tasa de Inter&eacute;s anual Ordinaria Fija: <u>@@io_anual@@</u> % <br>Tasa de inter&eacute;s anual Moratoria Fija: <u>@@im_anual@@</u> %</b></td>
      <td class="borde_bajo borde_der"><center> $ <u>@@monto_prestamo@@</u> <br> Moneda Nacional </center></td>
      <td class="borde_bajo" width="25%"><center> $ <u>@@total@@ </u> <br>Incluye intereses y comisi&oacute;nes </center></td>
    </tr>
    <tr>
      <td class="borde_bajo borde_der" colspan="2">
        <br>
        <center><b> PLAZO DEL CR&Eacute;DITO: </b><br /></center>
        <center><u>@@plazo_y_periocidad@@</u> <br /><br /></center>    
      </td>
      <td class="borde_bajo" colspan="2">
        <b> FECHA L&Iacute;MITE DE PAGO: </b>La primera el d&iacute;a <u>@@dia_de_pago_exacto@@</u>, las posteriores pueden consultarse en la tabla de amortizaciones anexo.<br />
        <b> FECHA DE CORTE:</b>Ultimo d&iacute;a de cada mes &nbsp;&nbsp; <br>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo" colspan="4"><center><b> COMISIONES RELEVANTES </b></center></td>
    </tr>
    <tr>
      <td class="borde_bajo" colspan="4">
        <center><p>&quot;Este producto no genera comisiones&quot;</p></center> 
      </td>
    </tr>

    <tr>
      <td class="borde_bajo" colspan="4">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="15%"><b> ADVERTENCIAS: </b><br /><br /></td>
            <td width="60%" colspan="6">
              <li>Incumplir con tus obligaciones te puede generar comisiones e intereses moratorios.</li>
              <li>Contratar cr&eacute;ditos por arriba de tu capacidad de pago puede afectar tu historial crediticio.</li>
              <li>El avalista, obligado solidario o coacreditado responder&aacute; como obligado principal frente a la Entidad Financiera.</li>
            </td>
          </tr>
          <tr>
            <td colspan="7">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo" colspan="4"><center><b> SEGUROS </b></center>
      </tr>    
    <tr>
      <td class="borde_bajo" colspan="4">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="borde_der" width="34%"> 
              Seguro: ____ (opcional u obligatorio) <br /><br />
              <center> No aplica. </center> <br />
            </td>
            <td class="borde_der" width="33%"> 
              Aseguradora: <br /><br />
              <center> No aplica. </center> <br />
            </td>
            <td class="" width="33%"> 
              Cl&aacute;usula: <br /><br />
              <center> No aplica. </center> <br />
            </td>                                  
          </tr>      
        </table>
      </td>
    </tr>
    <tr>
      <td class="borde_bajo" colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="3"> <center><b> ESTADO DE CUENTA </b></center></td>
        </tr>
        <tr>
          <td width="34%">Enviar a: domicilio ______<br /></td>
          <td width="33%">Consulta: v&iacute;a internet _______</td>
          <td width="33%">Env&iacute;o por correo electr&oacute;nico ________</td>
        </tr>
        <tr>
          <td colspan="3">Disponible en las sucursales <u>&nbsp;&nbsp;&nbsp;&nbsp; X &nbsp;&nbsp;&nbsp;&nbsp;</u></td>
        </tr>     
        <tr>
          <td colspan="3">&nbsp;</td>
        </tr>                     
      </table></td>
    </tr>
    <tr>
      <td class="borde_bajo" colspan="4">
        <b> Aclaraciones y reclamaciones: </b><br />
        Unidad Especializada de Atenci&oacute;n a Usuarios (UNE). <br />
        Domicilio: Calle Ter&aacute;n 503 oriente, Centro,  Morelos, Coahulia, M&eacute;xico. CP 26500 <br />
        Tel&eacute;fono: 862 6240304 y 6240450 Correo electr&oacute;nico: une@cajasanisidro.com.mx<br />
        P&aacute;gina de Internet: www.cajasanisidro.com.mx <br /><br />
      </td>
    </tr>
    <tr>
      <td colspan="4">
        Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF): <br />
        Tel&eacute;fono: 01 800 999 8080 y 53400999. P&aacute;gina de Internet. www.condusef.gob.mx <br />
      </td>
    </tr>
    <tr>
    </tr>    
  </table>
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
'
WHERE idtabla='param' 
AND idelemento='formato_caratula_prestamo_ca';