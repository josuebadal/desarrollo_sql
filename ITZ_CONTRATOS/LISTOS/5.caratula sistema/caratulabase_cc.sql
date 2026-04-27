--- CAPITAL ACTIVO ---

/* ::: SOLO POR PRIMERA VEZ :::
delete from tablas
where       idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_%';
insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_01','2269-139-004460/02-16923-0812','31302');
insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_02','269-140-004464/05-13168-07-11','30102|30502|31102');
insert into tablas 
            (idtabla,idelemento,dato1,dato2)
     values ('formato_caratula_prestamo','numero_contrato_conducef_03','2269-435-004459/02-13186-0811','30402|31602|30602|31002|31502|31202|33202|30302|31212');
*/
update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_caratula_prestamo';
delete from tablas
where       idtabla = 'param' and idelemento = 'formato_caratula_prestamo';
INSERT INTO tablas
            (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
     VALUES ('param','formato_caratula_prestamo',
             'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
             'gnome-open %s.html; sleep 17','rm -rf %s.*',0,
             '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>CARATULA DE CREDITO</title>
    <style type="text/css">
      @media print {
        h1 {
          page-break-before: always;
        }
      }
      .contenedor {
        height: 25cm;
        width: 19cm;
        font-family: Arial, Helvetica, sans-serif;
        font-size: 10pt;
      }
      .marco_borde {
        border: 1px solid #000;
      }
      .sombreado {
        background-color: #D6D6D6;
      }
      .borde_completo {
        border: 1px solid #000;
      }
      .negrita {
        font-weight: bold;
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
        order-left-color: #000;
    }
      .izq_borde {
        border-left-width: 1px;
        border-left-style: solid;
        border-left-color: #000;
}
      .izq {
        text-align: left;
      }
      .centro {
        text-align: center;
      }
      .der {
        text-align: right;
      }
      .top_texto {
        vertical-align: top;
      }
      .encabezado {
        font-size: 16pt;
        text-align: center;
        vertical-align: bottom;
        font-weight: bold;
        background-color: #FFFFFF;
        color: #000;
      }
      .justificado {
        text-align: justify;
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
      .texto {
        font-size: 12px;
      }
      .alinear_abajo {
        vertical-align: bottom;
      }
      .texto_chico {
        font-size: 9pt;
      }
      thead {
        display: table-header-group;
      }
      tfoot {
        display: table-footer-grupo;
      }
    </style>
  </head>
  <body>
    <div class="contenedor">
      <table class="texto_resumen" border="1" cellspacing="0" cellpadding="1">
        <thead>
          <tr align="right">
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="50%" height="100"><center> <img src="/usr/local/saicoop/img_caratula_prestamos/logo.jpg" width="236" height="114" /></center></td>
                  <td width="50%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr><td>&nbsp;</td></tr>
                      <tr class="der top_texto"><td><b> DC-CA1025 </b></td></tr>
                      <tr><td class="encabezado"> CAR&Aacute;TULA DE CREDITO </td></tr>
                      <tr><td> Folio: @@numero_opa@@ </td></tr>                    
                      <tr>
                        <td height="60" class="alinear_abajo centro negrita" style="font-size: 12pt;">
                          <!-- <img src="/usr/local/saicoop/img_caratula_prestamos/slogan.jpg" width="449" height="32" /> -->
                          <!-- Capital Activo SA de CV SFP -->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </thead>      
        <tbody>
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <!--<tr><td>&nbsp;</td></tr>
                <tr><td>Nombre del cliente1: @@nombre_socio@@ </td></tr>
                <tr><td>N&uacute;mero de cliente: @@numero_socio@@ </td></tr>
                -->
                <tr><td><b>Nombre comercial del Producto:</b> <!--@@nombre_prestamo@@--> </td></tr>
                <tr><td><b>Tipo de Operaci&oacute;n:</b> 
                Activa
                <!--@@tipo_credito_de_limite_credito@@--> </td></tr>
                <!--<tr><td>&nbsp;</td></tr> -->
              </table>
            </td>
          </tr>


        <!---SE AGREGA LA NUEVA TABLA PARA LA CARATULA BASADA EN LA DE CSN -->
        <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="top_texto " align="center">
          <td class="borde_bajo" width="25%">
            <b> <font size=3 >CAT </font> <br>(Costo Anual Total) </b>
          </td>
          <td class="borde_bajo izq_borde" width="25%">
            <b> TASA DE INTERES ANUAL ORDINARIA Y MORATORIA </b>
          </td>
          <td class="borde_bajo izq_borde" width="25%"> 
            <b> MONTO O LINEA DE  CR&Eacute;DITO </b>
          </td>
          <td class="borde_bajo izq_borde" width="25%">
            <b> MONTO TOTAL A PAGAR O MINIMO A PAGAR</b>
          </td>
        </tr>
        <tr class="texto_top" align="center">
          <td class="borde_bajo ">
           <b> <font size=3 >&nbsp;&nbsp;&nbsp; <b> @@cat1@@  &nbsp;&nbsp;&nbsp;%<br />
            SIN IVA Para fines informativos y de comparaci&oacute;n <font>  </td>
          <td class="borde_bajo izq_borde">
        <table width="90%" border="0" cellpadding="1" cellspacing="0">
            <tr>
      <td><b>&nbsp;&nbsp;&nbsp;<!---SE AGREGA PARA DARLE ESPACIO A LAS CELDAS --> &nbsp;&nbsp;&nbsp;</b></td>
    
    </tr>
    <tr>
      <td class="centro borde_completo sombreado"><b><font size=1> TASA DE INTER&Eacute;S ORDINARIA FIJA</font></b></td>
    </tr>
    <tr>
      <td class="borde_completo top_texto" align="center">
      <b> @@io_anual@@%</b></td>
    </tr>
    <td><b>&nbsp;&nbsp;&nbsp;<!---SE AGREGA PARA DARLE ESPACIO A LAS CELDAS --> &nbsp;&nbsp;&nbsp;</b></td>
    
    <tr>
      <td class="centro borde_completo sombreado"><b><font size=1>TASA DE INTER&Eacute;S MORATORIA FIJA </font></b></td>
    </tr>
    <tr>
      <td class=" borde_completo top_texto" align="center">
      <b> @@im_anual@@%</b></td>
    </tr>
    <td><b>&nbsp;&nbsp;&nbsp;<!---SE AGREGA PARA DARLE ESPACIO A LAS CELDAS --> &nbsp;&nbsp;&nbsp;</b></td>
    
  </table>
</td>
          
          <td class="borde_bajo izq_borde">
            $ &nbsp;&nbsp;&nbsp; @@monto@@ &nbsp;&nbsp;&nbsp; 
          </td>
          <td class="borde_bajo izq_borde">
            $ &nbsp;&nbsp;&nbsp; @@total@@ &nbsp;&nbsp;&nbsp; 
          </td>
        </tr>
        <tr class="texto_top">
          <td >
            <b> PLAZO DEL CR&Eacute;DITO: </b> <br /> <u>&nbsp;&nbsp; @@meses@@ &nbsp;&nbsp;</u> meses 
          </td>
          <td class="izq_borde" colspan="3"> 
            <b> Fecha l&iacute;mite de pago: </b> @@fecha_vencimiento@@ &nbsp;&nbsp;</u> <br />
            Fecha  de corte: <u>&nbsp;&nbsp; @@siguiente_pago@@ &nbsp;&nbsp;</u>, para las siguientes fechas de corte consultar el documento adjunto. 
          </td>
        </tr>
      </table>
     </td>
    </tr>
    <tr>
      <td align="center">
        <b> COMISIONES RELEVANTES </b>
      </td>
    </tr>
    <tr>
      <td >
        Apertura:  @@comision_apertura@@ % 
        <br />
        Incluye IVA
        <br /> 
        Para m&aacute;s informaci&oacute;n sobre la comisi&oacute;n consulte la Cl&aacute;usula Quinta del contrato 
      <br />
      </td>
    </tr>
    <tr>
      <td align="center">
        <b> ADVERTENCIAS </b>
      </td>
    </tr>
    <tr>
      <td >
        &quot;Incumplir tus obligaciones te puede generar comisiones e intereses moratorios&quot;<br />
                    &quot;Contratar cr&eacute;ditos por arriba de tu capacidad de pago puede afectar tu historial crediticio&quot;<br />
                    &quot;El avalista, obligado solidario o coacreditado responder&aacute; como obligado principal frente a la Entidad Financiera&quot;<br />
                    &quot;En caso de incumplimiento por parte de EL ACREDITADO Y GARANTE HIPOTECARIO respecto de lo estipulado en la cl&aacute;usula D&Eacute;CIMA CUARTA "SEGUROS", la PARTE ACREDITANTE queda facultado para contratar a nombre de EL ACREDITADO Y GARANTE HIPOTECARIO el seguro correspondiente y a pagar por su cuenta los gastos y primas que cause dicho seguro&quot;.<br />
        <br />
      </td>
    </tr>
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
                <td width="30%" class="texto_top">Seguro: obligatorio <br></td>
                <td width="30%" class="izq_borde texto_top"><b>Aseguradora:</b> <br /> Aseguradora: HDI Seguros, S.A. de C.V.
                o aseguradora de la parte acreditada <br></td>
                <td width="30%" class="izq_borde top_texto"><b>Cl&aacute;usula:</b> <br /> D&Eacute;CIMA CUARTA DENOMINADA  "SEGUROS" <br></td>
              </tr>
            </table>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <center><b> ESTADO DE CUENTA </b></center>
          </td>
        </tr>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="borde_bajo izq_der_borde">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="24%"> Enviar a: domicilio  </td>
                <td width="5%" class="alinear_der"><u> &nbsp;&nbsp;  &nbsp;&nbsp; </u></td>
                <td width="5%">&nbsp;</td>
                <td width="20%"> Consulta: v&iacute;a Internet </td>
                <td width="5%" class="alinear_der"><u> &nbsp;&nbsp;  &nbsp;&nbsp; </u></td>
                <td width="5%">&nbsp;</td>
                <td width="26%"> En sucursal: </td>
                <td width="10%" class="alinear_der"><u> &nbsp; x &nbsp; </u></td>
              </tr>
            </table>
        </tr>
        <tr>
          <td class="borde_bajo izq_der_borde" colspan="3">
            <b> Aclaraciones y reclamaciones <br />
            Unidad Especializada de Atenci&oacute;n a Usuarios: </b> 
            <br />
            <b> Domicilio:</b>  Blvd. Solidaridad y Luis Donaldo Colosio, Edificio "B", Piso 3, Local 3, Colonia Villa Sat&eacute;lite, C.P. 83200, Hermosillo, Sonora. 
            <br />
            <b> Tel&eacute;fono: </b> 
            (662) 260 11 48. &nbsp;&nbsp;&nbsp; 
            <b> Correo electr&oacute;nico: </b> info@capitalactivo.com.mx <br />
            <b> P&aacute;gina de Internet: </b>  www.capitalactivo.com.mx 
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
<html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
');

