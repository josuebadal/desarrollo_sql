--- LEON FRANCO ---
/*
--- insert into tablas (idtabla,idelemento,dato2) values('param','edocta_ahorro_por_conceptos','110|120|130|133');
-------------------------------------------------------------------------------------------------------------------------
delete from tablas where idtabla = 'formato_estado_cuenta_ahorros' and idelemento = 'encabezado';
delete from tablas where idtabla = 'formato_estado_cuenta_ahorros' and idelemento = 'registro_detalle';
delete from tablas where idtabla = 'formato_estado_cuenta_ahorros' and idelemento = 'pie_de_pagina';
delete from tablas where idtabla = 'formato_estado_cuenta_ahorros' and idelemento = 'registro_detalle_comisiones';
-------------------------------------------------------------------------------------------------------------------------
insert into tablas (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_ahorros','encabezado','Datos del Encabezado de Estado Cuenta de Ahorro',
             '<B>CAJA POPULAR LE&Oacute;N FRANCO DE RIOVERDE, SAN LUIS POTOS&Iacute;, SOCIEDAD COOPERATIVA DE AHORRO Y <br> PR&Eacute;STAMO DE RESPONSABILIDAD LIMITADA DE CAPITAL VARIABLE|DOMICILIO: CENTENARIO # 401, COLONIA CENTRO, RIOVERDE, SAN LUIS POTOS&Iacute;, M&Eacute;XICO|C&Oacute;DIGO POSTAL 79610,|RFC: CPL890812331 TELEFONOS: 01 (487) 8725245, 8723753, 8721657.</B>');
insert into tablas (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_ahorros','pie_de_pagina','Datos del Pie de Pagina de Estado Cuenta de Ahorro','');
insert into tablas (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_ahorros','registro_detalle','Formato del registro detalle',
             '<tr>
                <td>@@donde_pago_d@@</td>
                <td>@@fecha_sin_hora@@</td> 
                <td>@@referencia_d@@</td>
                <td>@@concepto_d@@</td>
                <td>@@abonos_d@@</td>
                <td>@@cargos_d@@</td>
                <td>@@saldo_d@@</td>
             </tr>');
*/
update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_estado_cuenta_ahorros';
delete from tablas where idtabla = 'param' and idelemento = 'formato_estado_cuenta_ahorros';
insert into tablas
            (idtabla,idelemento,nombre,dato1,dato3,dato4,dato2,tipo)
     values ('param','formato_estado_cuenta_ahorros','Formato en HTML de Estado de Cuenta de Ahorro',
             'iconv %s -f iso-8859-1 -t utf-8 -o %s.html','gnome-open %s.html; sleep 80','rm -rf %s.*',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
  text-align: center;
  font-size: 10pt;
}
.subencabezado {
  font-size: 9pt;
    text-align: right;
}
.subencabezado1 {
  font-size: 10pt;
    text-align: center;
    font-weight: bold;
}
.texto_resumen {
  font-size: 8pt;
}
.borde_bajo {
  border-bottom-width: 1px;
  border-bottom-style: solid;
  border-bottom-color: #000;
}
.borde_arriba {
  border-top-width: 1px;
  border-top-style: solid;
  border-top-color: #000;
}
.borde_der {
  border-right-width: 1px;
  border-right-style: solid;
  border-right-color: #000;
}
.borde_total {
  border: 1px solid #000;
}
.cen
{
    text-align: center;
}
.der {
    text-align: right;
}
.texto_top {
  vertical-align: top;
}
.jus {
  text-align: justify;
}
.negrita {
    font-weight: bold;
}
</style>
</head>
<body>
<div class="contenedor">
  <table class="texto_resumen" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table class="borde_bajo" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="25%" class="borde_der">
              <center><img src="/usr/local/saicoop/img_estado_cuenta_ahorros/logo.jpg" width="150" height="40"></center>
            </td>
            <td width="75%" class="encabezado">
              <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                <tr>
                  <td>
                    @@h_l1@@ <br />
                    @@h_l2@@ <br />
                    @@h_l3@@ <br />
                    @@h_l4@@ <br /><br />
                  </td>
                </tr>
                <tr>
                  <td class="subencabezado cen">
                    Lugar y fecha de expedici&oacute;n: @@lugar_expedicion@@, @@fecha_impresion@@
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
      <td class="subencabezado1">ESTADO DE CUENTA</td>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr>
            <td width="19%">N&uacute;mero de Cuenta o Socio:</td>
            <td width="27%" class="borde_bajo"><b>@@cuenta@@</b></td>
            <td width="14%">&nbsp;Nombre:</td>
            <td width="42%" class="borde_bajo"><b>@@nombre@@</b></td>
          </tr>
          <tr>
            <td>RFC:</td>
            <td class="borde_bajo"><b>@@rfc@@</b></td>
            <td>&nbsp;Tel&eacute;fono particular:</td>
            <td class="borde_bajo"><b>@@telefono_particular@@</b></td>
          </tr>
          <tr>
            <td>Domicilio:</td>
            <td colspan="3" class="borde_bajo"><b>@@domicilio_codigo_postal@@</b></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><b>CUENTA DE CAPTACI&Oacute;N: @@nom_producto@@</b></td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr>
            <td width="50%">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2" class="borde_arriba borde_bajo cen"><b>Per&iacute;odo</b></td>
                </tr>
                <tr>
                  <td class="cen"><b>Del</b></td>
                  <td class="cen"><b>Al</b></td>
                </tr>
                <tr>
                  <td class="cen"> @@pf1@@ </td>
                  <td class="cen"> @@pf2@@ </td>
                </tr>
                <tr>
                  <td>&nbsp;</td> 
                </tr>
                <tr>
                  <td>SALDO INICIAL:</td>
                  <td class="der"> @@saldo_inicial@@ </td>
                </tr>
                <tr>
                  <td>SALDO FINAL:</td>
                  <td class="der"> @@saldo_final@@ </td>
                </tr>
                <tr>
                  <td>DEP&Oacute;SITO:</td>
                  <td class="der"> @@depositos@@ </td>
                </tr>
                <tr>
                  <td>IMPUESTOS RETENIDOS ISR:</td> 
                  <td class="der"> @@isr_retenido@@ </td> 
                </tr>
                <tr> 
                  <td>COMISIONES COBRADAS:</td> 
                  <td class="der">0.00</td> 
                </tr>
                <tr> 
                  <td>INTER&Eacute;S EN EL PERIODO:</td> 
                  <td class="der"> @@io@@ </td> 
                </tr>
                <tr> 
                  <td>RETIROS:</td> 
                  <td class="der"> @@retiros@@ </td> 
                </tr>
                <tr> 
                  <td colspan="2" class="borde_bajo"></td> 
                </tr>
              </table>              
            </td>
            <td width="3%">&nbsp;</td>
            <td width="47%">
              <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr>
                  <td class="borde_total">
                    <b>
                      <p align=center >
                        <font size="3">TASA DE INTER&Eacute;S ANUAL FIJA:&nbsp;&nbsp;
                        @@tasaio_anual@@ %</font><br>&nbsp;&#8220;Antes de impuestos&#8221;<br /> 

                        <font size=3>GAT NOMINAL &nbsp;&nbsp;
                        <u>@@gat_nominal_99.99@@ </u>%</font>&nbsp;&#8220;Antes de impuestos&#8221;. Para fines informativos y de comparaci&oacute;n.<br />
                        <font size=3>GAT REAL &nbsp;&nbsp;
                        <u>@@gat_real_99.99@@</u>%</font>&nbsp;&#8220;Antes de impuestos&#8221;. Para fines informativos y de comparaci&oacute;n. La GAT REAL es el rendimiento que obtendr&iacute;a despu&eacute;s de descontar la inflaci&oacute;n estimada.<br />
                      </p>
                    </b>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <!--<td VALIGN="TOP"><br /> &#8220;Este producto, devengar&aacute; intereses a partir de 1 peso, sobre saldos promedio diarios&#8221;.<br>El saldo m&iacute;nimo para no generar comisiones es: $0.00</td>-->
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td width="47%">
<!-- SE AGREGO EL LA TABLA COMISIONES EFECTIVAMENTE COBRADAS -->
              <table width="100%" class="borde_total" cellspacing="0" cellpadding="0">
                <tr>
                  <td><b>comisiones efectivamente cobradas:</b></td>
                </tr>
                <tr>
                  <td>
                    <table width="100%" cellspacing="0" cellpadding="5">
                      <tr>
                        <th>Monto</th>
                        <th>Concepto</th>
                        <th>Fecha en que se gener&oacute;</th>
                        <th>Monto Total</th>
                      </tr>
<!-- ------------------------- Aqui se va agregar un arroba ------------------- -->                      
                      <tr>
                        <td class="cen">$ 0.00 </td>
                        <td class="cen"> - </td>
                        <td class="cen"> - </td>
                        <td class="cen">$ 0.00 </td>
                      </tr>
<!--  -----------------------      Termina agregado de arroba  ----------------- -->
                    </table>
                  </td>
                </tr> 
                <tr>
                  <td>
                    <table width="100%" cellspacing="0" cellpadding="5">
                      <tr><td>Moneda: <br />Peso Mx.</td></tr>
                      <tr>
                        <td>Saldo m&iacute;nimo</td>
                        <td class="cen">&nbsp;</td><td class="cen">&nbsp;</td><td class="cen">&nbsp;</td>
                        <td class="cen">$1.00</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <p>Este producto no genera comisi&oacute;n.</p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr class="negrita"><center><b>Detalle de Movimientos en M.N.</b></center></tr>
          <tr class="=cen negrita">
            <td><b>Sucursal</b></td>
            <td><b>Fecha</b></td>
            <td><b>Ficha</b></td>
            <td><b>Concepto</b></td>
            <td><b>Dep&oacute;sito</b></td>
            <td><b>Retiro</b></td>
            <td><b>Saldo</b></td>
          </tr>
          @@detalle_de_movs@@
        </table>
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="70%" class="borde_bajo"><b>Saldo a la fecha de corte</b></td>
            <td width="30%" class="der borde_bajo"> $ @@saldo_final@@ </td>
          </tr>
          <tr>
            <td class="borde_bajo"><b>Saldo promedio diario</b></td>
            <td class="der borde_bajo"> $ @@saldo_promedio@@ </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td class="borde_bajo">
        <!--<b>"Operaci&oacute;n realizada en Moneda Nacional" </b><br />-->
        <b>"Inter&eacute;s calculado sobre el saldo promedio mensual"</b><br />
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td class="cen"><b>Cargos Objetados</b></td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="15%"><b>Fecha:</b></td>
            <td width="20%" class="der borde_bajo">&nbsp;</td>
            <td width="5%"><b>Contacto:</b></td>
            <td width="30%" class="borde_bajo">&nbsp;</td>
            <td width="13%"><b>N&uacute;mero de folio:</b></td>
            <td width="17%" class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td><b>Monto del cargo:</b></td>
            <td colspan="5" class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td><b>Observaciones:</b></td>
            <td colspan="5" class="borde_bajo">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr><td class="borde_bajo">&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
     <!-- <td class="cen"><b>Procedimiento y plazo para objetar cargos</b></td> -->
      <td class="cen">Datos de localizaci&oacute;n: Contacto de Unidad Especializada para presentar aclaraci&oacute;n o reclamaci&oacute;n: <br />
        <b>CAJA POPULAR LE&Oacute;N FRANCO DE RIOVERDE, SAN LUIS POTOS&Iacute; SOCIEDAD COOPERATIVA DE AHORRO Y PR&Eacute;STAMO DE RESPONSABILIDAD LIMITADA DE CAPITAL VARIABLE.</b><br /> 
        Recibe consultas, reclamaciones o aclaraciones, en su Unidad Especializada de Atenci&oacute;n a Usuarios ubicada en:
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="75%" class="jus">
              <b>UNIDAD ESPECIALIZADA DE ATENCI&Oacute;N A USUARIOS</b> <br />
              Domicilio: Centenario 401, Colonia Centro, Rioverde, San Luis Potos&iacute;, M&eacute;xico, C&oacute;digo Postal 79610. <br />
              Tel&eacute;fono: (487) 8721657 y lada sin costo 800 8415 808 <br />
              P&aacute;gina de internet: <u>www.cplf.coop</u> <br />
              Correo electr&oacute;nico: <u>une@cplf.coop</u> <br /><br />
            </td>  
          </tr>    
          <tr>    
            <td colspan="2" class="jus">
              As&iacute; como cualquiera de las Sucursales u oficinas de la Caja. En el caso de no obtener respuesta satisfactoria, podr&aacute; acudir a la Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de <br /><br />
            </td>
          </tr>    
          <tr>
            <td width="75%" class="jus">
             <b>Servicios Financieros CONDUSEF</b><br />
              <b>Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF)</b><br />
              Domicilio: Insurgentes Sur # 762, Colonia Del Valle, Delegaci&oacute;n Benito Ju&aacute;rez, Ciudad de M&eacute;xico, 
              C&oacute;digo Postal 03100. <br />
              Tel&eacute;fono: 800 999 8080 y en la Ciudad de M&eacute;xico al 5340 0999. <br />
              P&aacute;gina de internet: <u>www.gob.mx/condusef</u> <br />
              Correo electr&oacute;nico: <u>asesoria@condusef.gob.mx</u> <br /><br />
            </td>
          </tr>
          <tr>
            <td width="75%" class="jus">
              El principal y los intereses de los instrumentos de captaci&oacute;n que no tengan fecha de vencimiento o que teni&eacute;ndola se renueven de forma autom&aacute;tica, as&iacute; como las transferencias no reclamadas que al 31 de diciembre de cada a&ntilde;o no hayan tenido movimiento durante los &uacute;ltimos 10 a&ntilde;os contados a partir de dicha fecha y cuyo importe no sea mayor a 200 (doscientos) d&iacute;as de salario m&iacute;nimo general vigente en el Distrito Federal, prescribir&aacute; a favor del patrimonio de la sociedad cooperativa de ahorro y pr&eacute;stamo.<br><br>
              El producto de ahorro anteriormente descrito se encuentra protegido por el Fideicomiso del Fondo de Supervisi&oacute;n Auxiliar de Sociedades Cooperativas de Ahorro y Pr&eacute;stamo y de Protecci&oacute;n a sus Ahorradores hasta por una cantidad de 25,000 UDIS, equivalente a $ @@udi_pesos@@ pesos en Moneda Nacional por socio ahorrador de Caja Popular Le&oacute;n Franco, lo anterior de conformidad con la ley para Regular las Actividades de las Sociedades Cooperativas de Ahorro y Pr&eacute;stamo. <br /><br /> 
              Opciones para realizar dep&oacute;sitos: <br> 
              1.- VENTANILLA BANCARIA: <br> 
              Puedes realizar dep&oacute;sitos en ventanilla bancaria en  cualquier sucursal Banorte del pa&iacute;s. <br> 
              Estas son las referencias que debes de indicar para realizar tu dep&oacute;sito: <br> 
              *N&uacute;mero de cuenta:  0613054425 <br> 
              *N&uacute;mero de referencia: 63772 <br> 
              *Nombre: Caja Popular Le&oacute;n Franco de Rioverde S.L.P., S.C. de  A.P. de R.L. de C.V. <br> 
              2.- TRANSFERENCIA BANCARIA <br> 
              En el caso de realizar transferencias bancarias, la clabe interbancaria en Banorte  es: 072711006130544252. <br> 
              3.- APLICACI&Oacute;N MOVIL <br> 
              Puedes realizar una transferencia desde tu celular <br> 
              *N&uacute;mero de cuenta: 0613054425. <br> 
              Posterior a realizar cualquiera de los casos,  el socio deber&aacute; comunicarse al Departamento de Contabilidad a los tel&eacute;fonos (487)8723753 y (487)8725245 para confirmar su dep&oacute;sito o transferencia. <br /><br />
              Abreviaturas: <br />
              <b>RFC:</b> Registro Federal de Contribuyentes. <br /> 
              <b>ISR:</b> Impuesto Sobre la Renta. <br />
              <b>UDIS:</b> Unidades de Inversi&oacute;n. <br />
              <b>GAT:</b> Ganancia Anual Total <br />
              <b>SUC:</b> Sucursal <br />
              <b>Peso Mx:</b> Peso Mexicano <br />
              <b>M.N.:</b> Moneda Nacional
            </td>
            <td width="25%" class="cen">
              <img src="/usr/local/saicoop/img_estado_cuenta_dpfs_ind/rfc.jpg" width="115" height="210"> <br /><br />
                <b>Este estado de cuenta no es un comprobante fiscal.</b>
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
