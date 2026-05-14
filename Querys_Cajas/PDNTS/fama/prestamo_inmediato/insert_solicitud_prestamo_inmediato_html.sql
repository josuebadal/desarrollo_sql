update tablas 
set tipo = -456 
where idtabla = 'param' 
and idelemento = 'solicitud_prestamo_html_inmediato';

update tablas 
set tipo = 0 
where idtabla = 'param' 
and idelemento = 'solicitud_prestamo_html_inmediato'; 

/*select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo from tablas 
where idtabla = 'param' 
and idelemento = 'solicitud_prestamo_html_inmediato';*/

UPDATE tablas
set dato2 = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">

.contenedor {
  height: 25cm;
  width: 19cm;
  font-family: Time new roman;
    background-color: #A6D0A6;
}
.contenedor2 {
  height: 25cm;
  width: 17cm;
  font-family: Time new roman;
    background-color: #A6D0A6;       
}
.encabezado {
    font: 1.5em Arial, Helvetica, sans-serif;
    text-align: center;
}
.encabezado2 {
     font: .5em Arial, Helvetica, sans-serif;
}
.normal {
     font: .7em Arial, Helvetica, sans-serif;
}
.ovalado {
  border: .1px solid;
  border-radius: 15px;
  background-color: #2DC066;
  border-color: #2DC066;
   width: 100%;
}
.ovalado_blanco{
  border: .1px solid;
  border-radius: 15px;
  background-color: #ffffff;
  border-color: #2DC066;
   width: 100%;
}
.ovalado_blanco_arriba {
  border: .1px solid;
  border-top-left-radius:1em;
  border-top-right-radius:1em;
  background-color: #ffffff;
  border-color: #2DC066;
  width: 100%;
} 
.ovalado_blanco_abajo {
  border: .1px solid;
  border-bottom-left-radius: 1em;
  border-bottom-right-radius: 1em;
  background-color: #ffffff;
  border-color: #2DC066;
  width: 100%;
}
.raya_abajo { border-bottom: 1px solid #000; }
.raya_abajo_color { border-bottom: 1px solid #2DC066; }
.raya_derecha { border-right: 1.5px solid #2DC066; }
.raya_izquierda { border-left: 1.5px solid #2DC066; }
.raya_arriba { border-top: 1.5px solid #2DC066; }
.socio_codeudor{text-align: center; vertical-align: middle;}
</style>

<body>
<div class="contenedor"><center>
<div class="contenedor2">
<table width="100%">
<table><tr><td>&nbsp;</td></tr></table>
<tr>
<td>
<table width="100%">
<tr>
<tH class= "encabezado" width=75% >SOLICITUD DE PR&Eacute;STAMO INMEDIATO</tH>
<tH width=25%>   <table class="encabezado2 ovalado" ><tr><td colspan="3" > FECHA DE ENTREGA PROGRAMADA</td></tr>  
<tr><td bgcolor="#ffffff" >@@fecha_apertura_dia@@</td><td bgcolor="#ffffff" >@@fecha_apertura_mes@@</td><td bgcolor="#ffffff" >@@fecha_apertura_ano@@</td></tr>   
<tr> <td>DIA</td> <td>MES</td><td>A&Ntilde;O</td></tr>        
</table>  </tH>
</tr>
</table>
 </td>
</tr>
</table>
<table class="ovalado_blanco normal" >  <tr ><td rowspan=2 width=20% ><img src="/usr/local/saicoop/img_solicitud_prestamo/logo.png" width="100" height="70" /></td>
<td width=80% > <table width="100%">    <tr><td width="25%">TIPO DE PR&Eacute;STAMO:</td> <td class="raya_abajo" width="75%">@@nombre_producto@@</td></tr>
                                        <tr><td width="25%">SUCURSAL:</td> <td class="raya_abajo" width="75%">@@nombre_sucursal@@</td></tr>
</table></td></tr></table>




<table class="ovalado_blanco_arriba ovalado_blanco_abajo normal" width="100%">
<tr><td width="40%" ></td><td width="40%"></td><td width="10%"></td> <td width="10%"></td> </tr>
<tr ><td class="raya_abajo_color raya_derecha">NUM SOCIO:@@ogs@@</td><td  COLSPAN=3 class="raya_abajo_color">NOMBRE:@@nombre_completo@@ </td>    </tr>
<tr><td  colspan=4 class="raya_abajo_color">DOMICILIO: @@domicilio_completo@@</td></tr>
<tr><td class="raya_derecha">C.P.: @@domicilio_cp@@ </td> <td COLSPAN=3 >TEL:@@telefono@@ </td>  </tr>
</table>
RELACION DE SALDOS
<table class="ovalado_blanco normal" >
<tr><td width=30%></td><td width=15%></td><td width=55%></td></tr>
<tr>
<td class="raya_abajo_color">PARTE SOCIAL:</td>
<td class="raya_abajo_color raya_derecha">$@@saldo_101@@</td>
<td rowspan="2" class="raya_abajo_color">Se Autoriza por Gerente de sucursal la cantidad de:</br>$@@monto_prestamo@@</td>
<tr>
<td class="raya_abajo_color">AHORRO:</td>
<td class="raya_abajo_color raya_derecha">$@@saldo_110@@</td>
</tr>
<tr>
<td class="raya_abajo_color">CERTIFICADOS ADICIONALES:</td>
<td class="raya_abajo_color raya_derecha">$@@saldo_103@@</td>
</tr>
<tr>

<td class="raya_abajo_color">INVERSION(DPF):</td>
<td class="raya_abajo_color raya_derecha">$@@saldo_dpf@@</td>
<td rowspan="2" class="raya_abajo_color">
  <table width="100%">
    <tr><td width="15%">Nombre</td><td class="raya_abajo" width="35%">&nbsp;</td><td width="15%">Firma:</td><td class="raya_abajo" width="35%">&nbsp;</td></tr> 
  </table>
</td>
<tr>
<td class="raya_abajo_color">TOTAL:</td>
<td class="raya_abajo_color raya_derecha">$@@saldo_total@@</td>
</tr>
<tr>

<td colspan=3 >FINALIDAD: @@finalidad@@</td>

</tr>
<tr><td width="30%"></td><td width="15%"></td><td width="55%"></td></tr>
</table>
<div class="normal">
<p align=justify>
En caso de ser autorizado, las partes convienen que el socio otorga, en caso de incumplimiento de los pagos convenidos, el deposito que tiene en calidad de
ahorro as&iacute; como el certificado de aportaci&oacute;n que sirva de base para pr&eacute;stamo con CAJA FAMA, S.C. DE A.P. DE R.L. DE C.V. cediendo los derechos de los
mismos a la entidad para pago respectivo del adeudo.</p>
</div>
<br /><br /><br /><br />
<table width=100% class="normal">
       
       <tr>
           <td width="30%" class="raya_abajo"></td>
           <td width=5% ></td>
           <td width=30% class="raya_abajo"></td>
           <td width=5%></td>
           <td width=30% class="raya_abajo"></td>
       </tr>
       <tr><td><center>NOMBRE DE QUIEN ENTREGO</center></td>
           <td></td>
           <td><center>FIRMA DE GERENTE</center></td>
           <td></td>
           <td><center>FIRMA (SOCIO)</center></td>
        </tr>
</table>
<br /><br />

  <!--EMPIZA EL CONTENEDOR PARA EL SOCIO Y CODEUDOR-->
  <div>
      <table width="100%" class="ovalado_blanco_arriba ovalado_blanco_abajo normal">

    <!-- TITULO -->
    <tr>
        <th colspan="6" class="raya_abajo_color">PAGARE</th>
    </tr>

    <tr>
        <th colspan="1" class="raya_derecha">LUGAR DE EXPEDICI&Oacute;N</th>
        <th colspan="1" class="raya_derecha">FECHA DE EXPEDICI&Oacute;N</th>
        <th colspan="2" class="raya_derecha">FOLIO</th>
        <th colspan="1" class="raya_derecha">FECHA DE VENCIMIENTO</th>
        <th colspan="1">IMPORTE </th>
    </tr>
    <tr>
        <td class="raya_derecha">@@domicilio_municipio_suc@@ <br /> @@domicilio_estado_suc@@</td>
        <td class="raya_derecha"><center>@@fecha_apertura@@</center></td>
        <td class="raya_derecha" colspan=2><center>@@opa@@</center></td>
        <td class="raya_derecha"><center>@@fecha_vencimiento@@</center></td>
        <td ><center>@@monto_credito@@</center></td>
    </tr>
    <tr>
        <td colspan=6 class="raya_abajo_color raya_arriba"> 
        <p align=justify>Por este pagar&eacute; prometo y me obligo a pagar incondicionalmente a la orden de Caja Fama S.C. de A.P. de R.L. de
        C.V. la Cantidad de: <u>$@@monto_credito@@ ,(@@monto_letra@@).</u>
        Valor recibido en efectivo a mi entera satisfacci&oacute;n este pagar&eacute; esta sujeto a pagarse en:@@meses@@
        abonos mensuales
        de: $<u>@@saldo_2amortizacion@@</u>
        causando inter&eacute;s de:<u>@@tasa_io_anual@@</u>
        % anual sobre saldos insolutos m&aacute;s el:<u>@@tasa_im_anual@@</u>
        % de Inter&eacute;s Moratorio anual por
        los abonos no cubiertos, convengo expresamente que a la falta de pago de 3
        Abonos pactados podr&aacute; darse por
        vencido anticipadamente este pagar&eacute; sin necesidad de requerimiento judicial pudiendo el beneficiario exigir el saldo
        insoluto a esa fecha, el pago se hara en las oficinas de Caja Fama S.C. de A.P. de R.L. de C.V. en Santa Catarina N.l.</p>
    </td>
    </tr>   

    <!-- COLUMNAS GRANDES -->
    <tr>
        <th colspan="3">
            SUSCRIPTOR U OBLIGADO PRINCIPAL
        </th>
        <th colspan="3">
            DATOS DEL CODEUDOR
        </th>
    </tr>
    <tr>
        <th colspan="6">&nbsp;</th>
    </tr>
    <tr>
        <td colspan="3">
        <table width="100%" class="ovalado_blanco normal">
          <tr> <td>&nbsp;</td></tr>
          <tr> <td>NUM DE SOCIO:  @@numero_socio@@ </td></tr>
          <tr> <td>NOMBRE:  @@nombre_completo@@ </td></tr>
          <tr> <td>DIRECCI&Oacute;N:  @@domicilio_completo@@ </td></tr>
          <tr> <td>CIUDAD:  @@domicilio_municipio@@ , @@domicilio_estado@@ </td></tr>
          <tr> <td>&nbsp;</td></tr>
          <tr>
               <th>_________________________</th>
          </tr>
          <tr>
               <th colspan="1">FIRMA</th>
          </tr>
        </table>
        </td>

        <td colspan="3">
        <table width="100%" class="ovalado_blanco_arriba ovalado_blanco_abajo normal">
          <tr> <td>&nbsp;</td></tr>
          <tr> <td>NOMBRE:@@nombre_completo_codeudor@@ </td></tr>
          <tr> <td>DIRECCION: @@domicilio_completo_codeudor@@ </td></tr>
          <tr> <td>CIUDAD:@@domicilio_estado_codeudor@@</td></tr>
          <tr> <td>&nbsp;</td></tr>
          <tr> <td>&nbsp;</td></tr>
          <tr> <td>&nbsp;</td></tr>
          <tr>
               <th>_________________________</th>
          </tr>
          <tr>
               <th colspan="1">FIRMA</th>
          </tr>
        </table>
        </td>
    </tr>
    </table>
  </div>


</div></center>
</div>
</body>
</html>










                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
'
where idtabla = 'param' and idelemento = 'solicitud_prestamo_html_inmediato';
;

