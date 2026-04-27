/*SE USARA LA BASE SIG:
mitras30jun25_badal
/home/jjbadal/Proyecto_SAICoop/formatos_saicoop/mitras/estado_cuenta_dpfs_ind

*/
--- MITRAS ---
------------------------------------ Si se requiere el estado por movimiento (historial) se agrega: --------------------------------------------
--delete from tablas where idtabla = 'param' and idelemento = 'edocta_dpfs_por_conceptos';
--insert into tablas (idtabla,idelemento,nombre) values ('param','edocta_dpfs_por_conceptos','Estado por concepto');
------------------------------------------------------------------------------------------------------------------------------------------------
-- delete from tablas where idtabla = 'formato_estado_cuenta_dpfs_ind' and idelemento = 'encabezado';
-- delete from tablas where idtabla = 'formato_estado_cuenta_dpfs_ind' and idelemento = 'pie_de_pagina';
delete from tablas where idtabla = 'formato_estado_cuenta_dpfs_ind' and idelemento = 'registro_detalle';
  /*
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_dpfs_ind','encabezado','Datos del Encabezado de Estado Cuenta de Prestamo',
             'CAJA MITRAS S.C. DE A.P. DE R.L. DE C.V.|AV. RODRIGO GOMEZ 104-B COL. CENTRAL, MONTERREY NUEVO LEON|C.P. 64190, TELEFONOS 83-71-82-26 y 83-71-32-52|RFC CMI950923JP0');
*/     

delete from tablas where idtabla = 'formato_estado_cuenta_dpfs_ind' and idelemento='pie_de_pagina';
insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_dpfs_ind','pie_de_pagina','Datos del Pie de Pagina de Estado Cuenta de Prest',
'1.- Cuentas con 90 dias naturales a partir de la fecha de impresi&oacute;n del estado de cuenta para objetar el mismo. <br />
Si se presenta esta situaci&oacute;n el procedimiento a seguir, sera presentando tu reclamaci&oacute;n por escrito, o envi&aacute;ndolo por correo electr&oacute;nico al Representante de la UNE en esta Caja. Tel&eacute;fono: 01 (81) 83718226 Correo electr&oacute;nico: une.cajamitras@cajamitras.com, educacion@cajamitras.com P&aacute;gina de Internet: www.cajamitras.com.mx <br />
Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF): Tel&eacute;fono: 01 800 999 8080 y 53400999. P&aacute;gina de Internet. www.condusef.gob.mx. <br />
*Descripcion de Referencia: Los primeros 6 digitos corresponden a la sucursal, los siguientes 2 al tipo de p&oacute;liza (01 ingreso, 02 egresos, 03 diario), los ultimos 5 digitos correponden al consecutivo de p&oacute;liza del mes. <br />
GAT. - Ganancia Anual Total. <br />
ISR.- Impuesto sobre la Renta, se cobra a razon del 0.60% sobre el excedente de cinco salarios minimos del D.F. elevados al a&ntilde;o. <br />
<br />
El presente Estado de Cuenta no es un comprobante para efectos fiscales, si requiere comprobante fiscal debera solicitarlo a la sucursal que le corresponde.
');
    




insert into tablas
            (idtabla,idelemento,nombre,dato2)
     values ('formato_estado_cuenta_dpfs_ind','registro_detalle','Formato del registro detalle',
'<tr>
          <td class="alin_der"> @@mov_d@@ </td>
          <td> &nbsp;           </td>
          <td> @@fecha_d@@      </td>
          <td> @@donde_pago_d@@ </td>
          <td> @@referencia_d@@ </td>
          <td class="alin_der"> @@concepto_d@@ </td>
          <td class="alin_der"> @@cargos_d@@   </td>
          <td class="alin_der"> @@abonos_d@@   </td>
          <td class="alin_der"> @@saldo_d@@    </td>
        </tr>');

update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_estado_cuenta_dpfs_ind';
delete from tablas where idtabla = 'param' and idelemento = 'formato_estado_cuenta_dpfs_ind';
insert into tablas
            (idtabla,idelemento,nombre,dato1,dato3,dato4,dato2,tipo)
     values ('param','formato_estado_cuenta_dpfs_ind','Formato en HTML de Estado de Cuenta de Dpfs',
             'iconv %s -f iso-8859-1 -t utf-8 -o %s.html','gnome-open %s.html; sleep 7','rm -rf %s.*',
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
.fondo_celda {
}
.encabezado {
  font-size: 14px;
  text-align: center;
  font-weight: bold;
  background-color: #CCC;
}
.borde_total {
  border: 2px solid #000;
}
.borde_arriba_abajo {
  border-top-width: 1px;
  border-bottom-width: 1px;
  border-top-style: solid;
  border-bottom-style: solid;
  border-top-color: #000;
  border-bottom-color: #000;
}
.borde_der {
  border-right-width: 2px;
  border-right-style: solid;
  border-right-color: #000;
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
.borde_resumen {
  border: 1px solid #000;
}
.borde_bajo {
  border-bottom-width: 1px;
  border-bottom-style: solid;
  border-bottom-color: #000;
}
</style>
</head>
<body>
<div class="contenedor">
  <table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="texto_der"><b> Folio: <font color="#FF0000"> @@folprint@@ &nbsp;</font></b></td>
    </tr>
  </table>
  <table class="borde_total" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><table class="encabezado borde" width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr>
          <td class="texto_top" width="14%"><img src="/usr/local/saicoop/img_estado_cuenta_dpfs_ind/logo.jpg" alt="" width="94" height="68" /></td>
          <td width="86%"> 
            @@h_l1@@
          <br />
            @@h_l2@@ <br />
            @@h_l3@@ <br />
            @@h_l4@@ </td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="56%"> 
            <b> Nombre: </b> @@nombre@@ <br />
            <b> Domicilio: </b> @@domicilio@@ <br />
            <b> RFC: </b> @@rfc@@ <br />
            <b> Numero de Cuenta: </b> @@cuenta@@ <br />
            <b> Producto: </b> @@nom_producto@@ </td>
          <td class="texto_top" width="44%">
            <b> Sucursal: </b> @@sucursal@@ <br />
            @@domicilio_sucursal@@
          </td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="53%"><b> Saldo inicial:</b></td>
              <td class="texto_der" width="40%">@@saldo_inicial@@</td>
              <td width="7%">&nbsp;</td>
            </tr>
            <tr>
              <td><b> + Depositos</b></td>
              <td class="texto_der">@@depositos@@</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><b> - Retiros</b></td>
              <td class="texto_der">@@retiros@@</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><b> Saldo al Final del periodo</b></td>
              <td class="texto_der">@@saldo_final@@</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td><b> ISR retenido en el periodo</b></td>
              <td class="texto_der">@@isr_retenido@@</td>
              <td>&nbsp;</td>
            </tr>
            <!--
            <tr>
              <td><b> IDE retenido en el periodo</b></td>
              <td class="texto_der">@@ide_retenido@@</td>
              <td>&nbsp;</td>
            </tr>
            --->

            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td><b> Intereses Pagados en el Periodo: </b></td>
              <td class="texto_der">@@io@@</td>  <!-- montoio falta agregar a la funcion --->
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
          </table></td>
          <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="fondo_celda" width="38%"><b>Periodo</b></td>
              <td class="texto_der fondo_celda" width="62%">@@pf1@@ al @@pf2@@</td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td><b> Saldo minimo:</b></td>
              <td class="texto_der">500.00</td>
              <!-- <td class="texto_der">@@saldo_minimo@@</td> -->
            </tr>
            <tr>
              <td><b> Moneda:</b></td>
              <td class="texto_der">Moneda Nacional</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2"><table class="borde_resumen" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><b> Tasa de interes Anual: </b></td>
                  <td class="texto_der">@@tasaio_anual@@%</td>
                </tr>
                <tr>
                  <td><b> Comisiones Efectivamente Cobradas: </b></td>
                  <td class="texto_der">0.00</td>
                </tr>
                <tr>
                  <td colspan="2"><p align=center >GAT Nominal <font size=3><b><u>@@gat_nominal_99.99@@ </u>%</b> </font><br>
          GAT Real <font size=3><b><u>@@gat_real_99.99@@</u> %</b></font> <br></p>
  <p align=center>Antes de impuestos "La GAT real 
  es el rendimiento que obtendr&iacute;a 
  despu&eacute;s de descontar la inflaci&oacute;n 
 estimada".</p></td>
                </tr>
              </table></td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td><table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="borde_arriba_abajo fondo_celda" colspan="9"><b> Movimientos del periodo </b></td>
        </tr>
        <tr align="center">
          <td width="3%" class="borde_bajo fondo_celda"><b> Num. </b></td>
          <td width="1%" class="borde_bajo borde_der fondo_celda">&nbsp;</td>
          <td width="19%" class="borde_bajo borde_der fondo_celda"><b> Fecha </b></td>
          <td width="18%" class="borde_bajo borde_der fondo_celda"><b> Sucursal de <br /> Deposito o Retiro </b></td>
          <td width="12%" class="borde_bajo borde_der fondo_celda"><b> Referencia </b></td>
          <td width="15%" class="borde_bajo borde_der fondo_celda"><b> Concepto </b></td>
          <td width="11%" class="borde_bajo borde_der fondo_celda"><b> Retiro </b></td>
          <td width="11%" class="borde_bajo borde_der fondo_celda"><b> Depositos </b></td>
          <td width="11%" class="borde_bajo fondo_celda"><b> Saldo </b></td>
        </tr>
        @@detalle_de_movs@@
        <tr>
          <td class="borde_arriba_abajo fondo_celda" colspan="9"><b>Movimientos realizados: </b>@@cont_movs@@</td>
        </tr>
      </table></td>
    </tr>
   <tr>
      <td><table class="formato_texto" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="8"> &nbsp; </td>
        </tr>
        <tr>
          <td class="borde_arriba_abajo" colspan="8"><center><b> Detalle de comisiones </b></center></td>
        </tr>
        <tr align="center">
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Fecha </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Sucursal </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Concepto </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Cargo </b></td>
          <td width="20%" class="borde_bajo fondo_celda"><b> Abono </b></td>
        </tr>
        <tr>
          <td colspan="8"> &nbsp; </td>
        </tr>
        <tr>
          <td class="borde_arriba_abajo" colspan="8"><center><b> Cargos objetados </b></center></td>
        </tr>
        <tr align="center">
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Fecha </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Sucursal </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Concepto </b></td>
          <td width="20%" class="borde_bajo borde_der fondo_celda"><b> Cargo </b></td>
          <td width="20%" class="borde_bajo fondo_celda"><b> Abono </b></td>
        </tr>
        <tr>
          <td colspan="8"> &nbsp; </td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td class="formato_texto">
        <b> @@leyenda_pie_de_pagina@@ </b>
      </td>
    </tr>
    <tr class="formato_texto texto_der">
      <td><b> Fecha de impresi&oacute;n @@fecha_impresion@@ </b></td>
    </tr>
  </table>
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
',3);
