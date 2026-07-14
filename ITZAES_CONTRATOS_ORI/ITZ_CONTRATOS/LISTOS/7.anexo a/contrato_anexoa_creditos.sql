INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,dato4,tipo,dato2)
VALUES ('texto_html_contratos',
'contrato_anexoa_creditos',
'Anexo A ITZAES',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0,
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ANEXO A</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
@page {
  size: 8.5in 11in;
}
.contenedor {
	height: 23.0cm;
	width: 18cm;
}
.texto_central {
	font-size: 8pt;
    text-align: center;
    font-weight: bold;
}
.borde_abajo {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-right-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
	border-top-color: #000;
}

.borde_arriba {
	border-top-width: 1px;
	border-top-style: solid;
	
	border-top-color: #000;

}
.borde_izq {
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #000;
}

.borde_der {
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #000;
}

.borde_completo {
	border: 1px solid #000;
}
.texto_top {
	vertical-align: top;
}
.texto_resumen {
	font-size: 8pt;
}
.alinear_der {
	text-align: right;
}
.alinear_izq {
	text-align: left;
}
.alinear_just {
	text-align: justify;
}
td.imagen {
        background-image:url("/usr/local/saicoop/img_caratula_ahorros/firma.jpg");
        background-position: center center; 
        background-repeat:no-repeat;
}
</style>
</head>
<body>
<div class="contenedor">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="texto_resumen">



    <tr>

      <td colspan="7">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="7"><center><b>ANEXO "A"</b> </center><br /></td>
    </tr>
        <tr>
      <td colspan="7"><center><b>TABLA DE AMORTIZACION</b> </center><br /></td>
    </tr>


      <td colspan="2" >
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="7"> Consiste en la tabla de amortizaci&oacute;n que forma parte integrante del contrato de apertura de CR&Eacute;DITO simple de fecha <u>@@@fecha_activacion|dd@@@</u> de <u>@@@fecha_activacion|mm@@@</u> del <u>@@@fecha_activacion|aaaa@@@</u> ,
celebrado entre la sociedad cooperativa que se indica en la car&aacute;tula adjunta al contrato, a quien en lo sucesivo se le denominara la "CAJA
ACREDITANTE" y de la otra parte, el "SOCIO ACREDITADO" identificado en la caratula. </td>
          </tr>

        
          <tr>
<th class="borde_completo" colspan="2"> N&Uacute;MERO DE CREDITO</th>
<th class="borde_completo" colspan="2">SOCIO</th>
<th class="borde_completo" colspan="2"> FECHA DE VENCIMIENTO</th>
<th class="borde_completo"> IMPORTE</th>

</tr>


          <tr class = "texto_central">
<td colspan="2" class="borde_completo">@@@idorigenp|@@@-@@@idproducto|@@@-@@@idauxiliar|@@@&nbsp; </td>
<td colspan="2" class="borde_completo"> @@@ogs|@@@&nbsp;</td>
<td colspan="2"  class="borde_completo"> @@@fecha_ven|@@@ </td>
<td class="borde_completo"> @@@importe|@@@ </td>

</tr>
<tr>
<th colspan="7">
  CONDICIONES GENERALES
</th>

</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">1. MONTO DEL CR&Eacute;DITO DISPUESTO.</th>
  <td colspan="4" class="borde_completo">  @@@importe|@@@</td>
</tr>
 <tr>
  <th colspan="3" class="borde_completo alinear_izq">2. CUENTA DE DISPOSICI&Oacute;N Y PAGO</th>
  <td colspan="4" class="borde_completo">Cheque, Transferencia y/o Efectivo </td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">3. INICIO DE VIGENCIA.</th>
  <td colspan="4" class="borde_completo">  @@@fecha_activacion|@@@</td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">4. LUGAR DE PAGO.</th>
  <td colspan="4" class="borde_completo">Unidad Especializada o en sucursal</td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">5. TASA DE INTER&Eacute;S ORDINARIA ANUAL.</th>
  <td colspan="4" class="borde_completo">  @@@tasaio_anual|@@@ @@@simbolo_porcentaje|@@@</td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">6. TASA DE INTER&Eacute;S MORATORIA ANUAL.</th>
  <td colspan="4" class="borde_completo">  @@@tasaim_anual|@@@  @@@simbolo_porcentaje|@@@</td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">7. EL CAT (COSTO ANUAL TOTAL) DE ESTA OPERACI&Oacute;N PARA FINES
INFORMATIVOS Y DE COMPARACI&Oacute;N EXCLUSIVAMENTE SIN IVA:</th>
  <td colspan="4" class="borde_completo">  @@@cat1|@@@ @@@simbolo_porcentaje|@@@</td>
</tr>
<tr>
  <th colspan="3" class="borde_completo alinear_izq">8. MONTO TOTAL A PAGAR</th>
  <td colspan="4" class="borde_completo">  @@@amort_total_suma@@@ 
  </td>
</tr>                     
           <tr>
<!-- TABLA DE AMORTIZACION COMENTABA PARA AJUSTAR EL TAMANO
<th class="borde_completo"> No de Pago</th>
<th class="borde_completo">Fecha L&iacute;mite De Pago</th>
<th class="borde_completo"> Capital</th>
<th class="borde_completo"> inter&eacute;s </th>
<th class="borde_completo">I.V.A. </th>
<th class="borde_completo"> Monto de pago</th>
<th class="borde_completo"> Saldo INSOLUTO </th>

<tr>
<td class="texto_justificado_pagos">
@@@amortizaciones|idamortizacion,corte,abono,saldo_inicial,iod,ivacd,total_cd@@@
</td>
</tr>
               <tr>
<th colspan="1" class="borde_completo"> @@@amortizaciones|idamortizacion,corte,abono,saldo_inicial,iod,ivacd,total_cd@@@ </th>
</tr> 
-->
<th colspan="7">    <br>
                9.- TABLA AMORTIZACI&Oacute;N</th>

 <tr>
<th class="borde_completo"> No de Pago</th>
<th class="borde_completo">Fecha L&iacute;mite De Pago</th>
<th class="borde_completo"> Capital</th>
<th class="borde_completo"> inter&eacute;s </th>
<th class="borde_completo">I.V.A. </th>
<th class="borde_completo"> Monto de pago</th>
<th class="borde_completo"> Saldo INSOLUTO </th>

</tr>  
          <tr>
<td class="borde_completo"><center>1 </center></td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>

</tr>         

<tr>
<td class="borde_completo"> <center>2</center> </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
</tr>

<tr>
<td class="borde_completo"> <center>3</center> </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
</tr>  

<tr>
<td class="borde_completo"> <center>4</center> </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
</tr>  


<tr>
<td colspan="2" class="borde_completo"> <b>Sumas</b> </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp;</td>
<td class="borde_completo">&nbsp; </td>
<td class="borde_completo">&nbsp; </td>
</tr> 


<tr>
  <td colspan="7" class="alinear_just">
    <br><br>
En caso de que la fecha l&iacute;mite de pago establecida en la tabla de amortizacion sea un d&iacute;a inh&aacute;bil, el "SOCIO ACREDITADO", realizar&aacute; sus pagos
el d&iacute;a h&aacute;bil inmediato posterior conforme a lo estipulado en el Contrato. 
<br><br> 
</td>
</tr>

<tr>
  <td colspan="7" class="alinear_just">
Los t&eacute;rminos y condiciones del Contrato de Apertura de CR&Eacute;DITO Simple son, en este acto, incorporados y forman parte del presente documento,
como si dichos t&eacute;rminos y condiciones estuviesen totalmente previstos y reproducidos a la letra en el presente documento. <br>
<br><br>  
</td>
</tr>

<tr>
  <td colspan="7" class="alinear_just borde_abajo">
Le&iacute;do el presente documento consistente en la tabla de amortizaci&oacute;n por las partes y sabedoras de su valor, alcance y consecuencias legales, se
manifestaron conformes con su contenido, lo ratifican y lo firman para constancia en la ciudad de M&Eacute;RIDA, YUCAT&Aacute;N a @@@fecha_hoy|dd@@@ de @@@fecha_hoy|mm@@@ del @@@fecha_hoy|aaaa@@@
entreg&aacute;ndose en este acto una copia original a cada una de las partes.
<br><br>  
</td>
</tr>
        </table>
      </td>

            <tr>     
           
              </tr>                           
              		<tr>
				<td colspan="7">
                    <table  width="100%">
					<tr >
                        <td width="10%"  ></td>
                        <th width="35%"> <br>LA CAJA ACREDITANTE</th>
						<td width="10%"  ></td>
						<tH width="35%"  ><br> EL SOCIO ACREDITADO</tH>
						<td width="10%"  ></td>
					</tr>

					<tr><td colspan="5">&nbsp;</td></tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr><td colspan="5">&nbsp;</td></tr>       

					<tr>
						<td ></td>
						<td  class="borde_abajo"></td>
						<td ></td>
                        <td  class="borde_abajo"></td>
                        <td ></td>
					</tr>
					<tr>
						<td ></td>
						<td ><center>@@@nombre_elaboro|@@@</center></td>
						<td ></td>
                        <td ><center>@@@nombre_socio|@@@</center></td>
                        <td ></td>
					</tr>
					<tr>
						<td ></td>
						<tH >REPRESENTANTE LEGAL <br><br><br></tH>
						<td ></td>
                        <tH >NOMBRE DEL SOCIO <br><br><br></tH>
                        
					</tr>

          <tr>
            <td colspan="7" class="borde_completo alinear_just">
              
              El presente contrato se encuentra en el Registro de Contratos de Adhesi&oacute;n (RECA), ante la Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los
Usuarios de Servicios Financieros (CONDUSEF), bajo el n&uacute;mero _4933-439-032364/04-04344-1022_ con fecha 20 de octubre del 2022. El cual
podr&aacute; ser consultado a trav&eacute;s de la P&aacute;gina web www.condusef.gob.mx.
            </td>
          </tr>
                    
				</table>
                </td>
			</tr>
                      </table>
                      </td> 
                </tr>        
    </tr>
  </table>
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
');