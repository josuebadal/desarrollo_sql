/*INSERT INTO tablas (idtabla,idelemento,nombre,
dato1,dato3,dato4,tipo,dato2) 
VALUES ('param',
        'solicitud_prestamo_html',
        'Formato Solicitud De Credito',
        'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
        'gnome-open %s.html; sleep 7',
        'rm -rf %s.*',0,
        'CODIGO HTML
        ');

-----POR PRIMERA VEZ DE USA DELETE
DELETE FROM tablas
WHERE idtabla = 'param'
AND idelemento = 'solicitud_prestamo_html'
AND tipo = 0;
-- Verifica que quedo
SELECT *
FROM tablas
WHERE idtabla = 'param'
AND idelemento = 'solicitud_prestamo_html';
ROLLBACK;
*/

INSERT INTO tablas (idtabla,idelemento,nombre,dato2,dato5,tipo) 
VALUES ('param',
        'productos_sol_prestamo_html',
        'Ligar Productos a Solicitud',
        '30402',0,0
        );


INSERT INTO tablas (idtabla,idelemento,nombre,
dato1,dato3,dato4,tipo,dato2) 
VALUES ('param',
        'solicitud_prestamo_html',
        'Formato Solicitud De Credito',
        'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
        'gnome-open %s.html; sleep 7',
        'rm -rf %s.*',
        0,
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>SOLICITUD SISTEMA</title>

<style type="text/css">

.contenedor {
  height: 23cm;
  width: 19cm;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 10px;
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
</style>
</head>
<body onload="seccion()">
 <div class="contenedor">
    <br>
<!--  ENCABEZADO PRINCIPAL ********************************************************************************************* -->
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
          <th width="30%" rowspan="3"><center><img src="/usr/local/saicoop/img_solicitud_ingreso/logo.png" alt="" width="150"/>
          </center></th>
          <th width="70%"> <div  ><font size="2">
            CAJA ITZAEZ, SC DE AP DE RL DE CV<BR><br>
                    @@fecha_hoy@@</font>  </div> </th>
        </tr>
           <tr>
           <th class="borde_arriba" ><center><br>SOLICITUD DE PRESTAMO CONSUMO CARTERA VIGENTE FINALIDAD:</center></th>
           
           <tr>
 <th >

 </th> 
      </tr>
      </tr>
 </table>
<br><br>
  <table width="100%" >
         <tr>
             <td>Socio:</td><td class="borde_bajo_color">@@ogs@@</td>
             <td>Fecha actual: </td><td class="borde_bajo_color">@@@ogs|@@@</td>
            <td>Fecha programada: </td><td class="borde_bajo_color">@@fecha_ape@@</td>
             <td>Solicitud:</td><td class="borde_bajo_color">@@opa@@</td>
            </tr>
  </table>
<br><br>
<!-------   DATOS GENERALES DEL SOCIO  ------->
<table width="100%" >
<tr>
<th colspan="4" width="100%" class="borde_arriba">GENERALES DEL SOCIO</tH>
</tr>

<tr>
<td width="20%">NOMBRE(s):&nbsp;</td>
<td width="30%">&nbsp; @@nombre_completo@@</td>
<td width="20%">EDAD: &nbsp;</td>
<td width="30%">&nbsp;@@EDAD@@ </td>
</tr>

<tr>
<td width="20%">RFC:&nbsp;</td>
<td width="30%">&nbsp; @@rfc@@</td>
<td width="20%">DOMICILIO: &nbsp;</td>
<td width="30%">&nbsp;@@domicilio_calle@@ </td>
</tr>

<tr>
<td width="20%">CRUZAMIENTOS:&nbsp;</td>
<td width="30%">&nbsp; @@domicilio_entrecalles@@</td>
<td width="20%">COLONIA: &nbsp;</td>
<td width="30%">&nbsp;@@domicilio_colonia@@ </td>
</tr>
<tr>
<td width="20%">SECTOR:&nbsp;</td>
<td width="30%">&nbsp; NA</td>
<td width="20%">CP: &nbsp;</td>
<td width="30%">&nbsp;@@domicilio_cp@@ </td>
</tr>

<tr>
<td width="20%">CIUDAD:&nbsp;</td>
<td width="30%">&nbsp; @@domicilio_municipio@@</td>
<td width="20%">ESTADO: &nbsp;</td>
<td width="30%">&nbsp;@@domicilio_estado@@ </td>
</tr>

<tr>
<td width="20%">TELEFONO(s):&nbsp;</td>
<td width="30%">&nbsp; @@telefono@@</td>
<td width="20%">EDO. CIVIL: &nbsp;</td>
<td width="30%">&nbsp;@@estado_civil@@ </td>
</tr>

<tr>
<td width="20%">REG. MATRIMONIAL:&nbsp;</td>
<td width="30%">&nbsp; @@regimen_matrimonial@@</td>
<td width="20%">EDO. CASA: &nbsp;</td>
<td width="30%">&nbsp;@@estatus_vivienda@@</td>
</tr>

<tr>
<td width="20%">RESIDENCIA:&nbsp;</td>
<td width="30%">&nbsp; @@antiguedad_vivienda@@</td>
<td width="20%">OCUPACION: &nbsp;</td>
<td width="30%">&nbsp;@@trabajo1_ocupacion@@ </td>
</tr>
</table>
<BR><BR>

<!--   SALDO DEL SOCIO  -->
 <table width="100%" >
<tr>
<th colspan="4" width="100%" class="borde_arriba">SALDO DEL SOCIO</tH>
</tr>

<tr>
<td>SERVICIO&nbsp;</td>
<td>SALDO &nbsp;</td>
</tr>

<tr>
<td></td>
<td>$</td>
</tr>
</table>
<BR><BR>


<!--   FORMA DE PAGO  -->
<table width="100%"  >
<tr>
<th colspan="6" width="100%" class="borde_arriba">FORMA DE PAGO</tH>
</tr>

<tr>
<td>Tipo de pr&eacute;stamo&nbsp;</td>
</tr>

<tr>
<td >Cantidad solicitada:&nbsp;$&nbsp; </td>
<td >&nbsp; @@monto@@</td>
<td >Tasa de interes: &nbsp;%&nbsp;</td>
<td >&nbsp;@@tasa_io@@ </td>
<td >A pagar en: &nbsp;</td>
<td >&nbsp;@@meses@@ </td>
</tr>

<tr>
<td >De:&nbsp;$&nbsp; </td>
<td >&nbsp; @@monto_prestamo_letra@@</td>
<td >Forma de pago: </td>
<td >&nbsp;@@forma_de_pago@@ </td>
<td >En los dias &nbsp;</td>
<td >&nbsp;@@fecha_vencimiento@@ </td>
</tr>

<tr>
<td colspan="1">Observaciones:&nbsp;</td>
<td colspan="5">&nbsp;</td>
</tr>
</table>
<BR><BR>


<!--   INFORMACION ECONOMICA -->
 <table width="100%"  >
<tr>
<th colspan="4" width="100%" class="borde_arriba">INFORMACI&Oacute;N ECON&Oacute;MICA</th>
</tr>

<tr>
<td width="20%">FECHA DE INSCRIPCION A LA CAJA:&nbsp;</td>
<td width="30%">&nbsp; @@fecha_ingreso@@</td>
<td width="20%">No. DEPENDIENTES ECONOMICOS: &nbsp;</td>
<td width="30%">&nbsp;@@dependientes@@ </td>
</tr>

<tr>
<td width="20%">INGRESO ORDINARIO:&nbsp;</td>
<td width="30%">&nbsp; @@total_ingresos@@ &nbsp;&nbsp;$</td>
<td width="20%">INGRESO FAMILIAR: &nbsp;</td>
<td width="30%">&nbsp;@@FAMILIAR@@ &nbsp;&nbsp;$ </td>



<tr>
<td colspan="1" >EGRESO ORDINARIO:&nbsp;</td>
<td colspan="1">@@total_gastos@@&nbsp;&nbsp;$</td>
</tr>

</table>



<BR><BR>
<!--   GARANTIAS EN HABERES DEL SOCIO  -->
 <table width="100%"  >
<tr>
<th colspan="5" width="100%" class="borde_arriba">GARANT&Iacute;AS EN HABERES DEL SOCIO</tH>
</tr>

<tr>
<td colspan="5">1.- Hago constatar y aprobar la toma de mis haberes como garant&iacute;a de no cumplir con el pago de este pr&eacute;stamo.</td>
</tr>

<tr>
<td colspan="5">2.- Declaro que todos los datos son correctos y autorizo a la caja popular CAJA ITZAEZ, SC DE AP DE RL DE CV que los compruebe a su entera satisfacci&oacute;n
y doy mi conformidad para que tambi&eacute;n conserve la presente solicitud. <br><br><br><br></td>

</tr>

<tr>

  <tr>
             <td width="10">&nbsp;</td>
             <td width="20">&nbsp;</td>
             <td width="40" class="borde_bajo">&nbsp;</td>
             <td width="20" >&nbsp;</td>
             <td width="10">&nbsp;</td>
  </tr>
    <tr>
             <td width="10">&nbsp;</td>
             <td width="20">&nbsp;</td>
             <th width="40">FIRMA DEL SOLICITANTE</th>
             <td width="20" >&nbsp;</td>
             <td width="10">&nbsp;</td>
  </tr>


</tr>

</table>





<br>
<br>

<!--   RESOLUCION DEL COMITE DE CREDITO  -->
<table width="100%"  >
<tr>
<th colspan="7" width="100%" class="borde_arriba">RESOLUCI&oacute;N DEL COMIT&eacute; DE CR&Eacute;DITO</tH>
</tr>

<tr>
<td >OFICIAL DE PR&Eacute;STAMOS:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@oficial@@@</td>
<td >&nbsp;</td>
<td >RESOLUCI&Oacute;N: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@resolucion@@ </td>
</tr>


<tr>
<td >CANTIDAD:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@CANTIDAD@@@</td>
<td >&nbsp;</td>

<td >CIUDAD: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@CIUDAD@@ </td>
</tr>

<tr>
<td >ESTADO:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@ESTADO@@@</td>
<td >&nbsp;</td>

<td >FECHA RESOLUCI&oacute;N: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@fecha_resolucion@@ </td>
</tr>

<tr>
<td >COMIT&Eacute;:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@comite@@@</td>
<td >&nbsp;</td>

<td >A&Ntilde;O: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@ANO@@ </td>
</tr>

<tr>
<td >FECHA DE ENTREGA:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@oF_ENTREGA@@@</td>
<td >&nbsp;</td>
<td >ACTA N: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@ACTA_NUM@@ </td>
</tr>

<tr>
<td >OFICIAL DE PR&Eacute;STAMOS:&nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp; @@@oficial@@@</td>
<td >&nbsp;</td>
<td >RESOLUCI&Oacute;N: &nbsp;</td>
<td colspan="2" class="borde_bajo" >&nbsp;@@resolucion@@ </td>
</tr>
<tr>
<td >CONDICIONES:&nbsp;</td>
<td colspan="6" class="borde_bajo" >&nbsp; @@@condiciones@@@ </td>
</tr>

  <tr>
             <td class="borde_bajo" > <br><br><br><br>&nbsp;</td>
             <td >&nbsp;</td>
             <td  class="borde_bajo">&nbsp;</td>
             <td  >&nbsp;</td>
             <td class="borde_bajo" >&nbsp;</td>
            <td  >&nbsp;</td>
             <td class="borde_bajo" >&nbsp;</td>
  </tr>
    <tr>
             <th >Oficial de prestamos</td>
             <td >&nbsp;</td>
             <th >Presidente</th>
             <td  >&nbsp;</td>
             <th >Vicepresidente</td>
             <td  >&nbsp;</td>
             <th >Secretario</td>
  </tr>



</table>

<BR><BR>
<!--  REFERENCIAS  -->
 <table width="100%"   >
<tr>
<th colspan="4" width="100%" class="borde_arriba">REFERENCIAS</tH>
</tr>
<tr>
<td><u>PERSONALES </u></td>
</tr>
<tr>
<td >NOMBRE(s):&nbsp;</td>
<td >&nbsp; @@@nombre_referencia@@@</td>
<td >PARENTESCO: &nbsp;</td>
<td >&nbsp;@@PARENTESCO_REFERENCIA@@ </td>
</tr>
<tr>
<td >DOMICILIO:&nbsp;</td>
<td >&nbsp; @@@DOMICILIO_REFERENCIA@@@</td>
<td >TEL(S): &nbsp;</td>
<td >&nbsp;@@TELEFONO_REFERENCIA@@ </td>
</tr>
<tr>
<td >COLONIA:&nbsp;</td>
<td >&nbsp; @@@COLONIA_REFERENCIA@@@</td>
<td >SECTOR: &nbsp;</td>
<td >&nbsp;@@SECTOR_REFERENCIA@@ </td>
</tr>




</table>




<BR><BR>
<!--  ADICIONALES  -->
 <table width="100%"   >
<tr>
<th colspan="4" width="100%" class="borde_arriba">ADICIONALES</tH>
</tr>

<tr>
<td >Fecha de ingreso:&nbsp;</td>
<td >&nbsp; @@@fecha_ingreso_referencia@@@</td>
</tr>

<tr>
<td >Antiguedad del socio en la caja popular:&nbsp;</td>
<td >&nbsp; @@@antiguedad_referencia@@@</td>
</tr>

<tr>
<td >Expediente completo</td>
<td >&nbsp; @@@expediente@@@</td>
</tr>

<tr>
<td >Asistencia a la asamblea:</td>
<td >&nbsp; @@@Asistencia@@@</td>
</tr>


<tr>
<td >Calificaci&oacute;n de asistencia a asambleas</td>
<td >&nbsp; @@@calificacion_asistencia@@@</td>
</tr>


<tr>
<td >Monto solicitado en UDIS:&nbsp;</td>
<td >&nbsp; @@@monto_udis@@@</td>
<td >Valor UDI a la fecha: &nbsp;</td>
<td >&nbsp;@@valor_udis@@ </td>
</tr>

</table>

</body>

<script>
        function seccion() {
var foto= document.getElementById("propios");   if (@@@pt_origen_recursos_propios.sql|@@@==0)
      {foto.src="/usr/local/saicoop/img_solicitud_ingreso/no_checado.png"; foto.width=15; foto.height=15 } 
      else {foto.src="/usr/local/saicoop/img_solicitud_ingreso/checado.png"; foto.width=15; foto.height=15}

var foto= document.getElementById("terceros");  if (@@@pt_origen_recursos_tercero.sql|@@@==0) 
      {foto.src="/usr/local/saicoop/img_solicitud_ingreso/no_checado.png"; foto.width=15; foto.height=15 } 
      else {foto.src="/usr/local/saicoop/img_solicitud_ingreso/checado.png"; foto.width=15; foto.height=15} 
            }
</script>
</html>        ');        