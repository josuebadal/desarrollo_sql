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
             'gnome-open %s.html; sleep 17','rm -rf %s.*',3,
             '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>CARATULA</title>
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
      <td width="30%"><img src="/usr/local/saicoop/img_caratula_prestamos/logo.jpg" alt="" width="190" height="50" /></td>
          <td colspan="1">
        <center><b>

        CAJA ITZAEZ, SC DE AP DE RL DE CV <br>
        C- 43 # 587 X C- 88 Y C- 88 A COLONIA INAL&Aacute;MBRICA C.P. 97069 M&Eacute;RIDA, YUCAT&Aacute;N <br>
    RFC: CIT-980930-7Q7 TEL: 9999206582    
    </b></center>
      </td>
    </tr>


    <tr>

      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><center><b>CARATULA DE CR&Eacute;DITO</b> </center><br /></td>
    </tr>
      <td colspan="2" class="borde_completo">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="4"><b> Nombre comercial del Producto:</b> @@nombre_prestamo@@ </td>
          </tr>
          <tr>
            <td colspan="4" class="borde_abajo"><b>Tipo de Operacion:</b> Activa <br /><br /></td>
          </tr>
          <tr>
            <td width="25%"><center>
              <b><font size=2> CAT (COSTO ANUAL TOTAL) PROMEDIO </font></b><br />
            </center>
            </td>
            
            <td width="25%" class="borde_izq texto_top">
              <center>
              <b><font size=2> TASA DE INTERES ANUAL ORDINARIA Y MORATORIA </font></b><br />
            </center>
            </td>

            <td width="25%" class="borde_izq texto_top"><center>
              <b><font size=2> MONTO O LINEA DE CR&Eacute;DITO: </font></b><br />
            </center>
            </td>

            <td width="25%" class="borde_izq texto_top">
             <center>
              <b><font size=2> MONTO TOTAL A PAGAR O MINIMO A PAGAR<br />
            </center>
            </td>
          </tr>
          <tr>
            <td class=" borde_arriba borde_abajo texto_top"><center> <u>@@cat@@</u> % <br> <b> SIN IVA</b> para fines informativos y de comparacion </center><br /></td>
            <td class=" borde_izq borde_arriba borde_abajo texto_top"><center> Ordinaria fija: <u>@@io_anual@@%</u> % <br> Moratoria fija: <u>@@im_anual@@</u> %</center></center></b></td>
            <td class=" borde_izq  borde_arriba borde_abajo texto_top"><center> &nbsp;@@monto@@ </center></td> 
            <td class=" borde_izq  borde_arriba borde_abajo texto_top"><center> &nbsp; @@total@@   </center></td> 
          </tr>


          <tr>
            <td width="50%" colspan="2" class="texto_top borde_abajo"> 
              <b> PLAZO DEL CREDITO:</b> @@plazo@@ pagos mensuales <br/>
             
            </td>
            <td width="50%" colspan="2" class="borde_izq borde_abajo texto_top">
          <b>  Fecha l&iacute;mite de pago: </b> La primera el <u>@@fecha_vencimiento@@</u>, las posteriores
                pueden consultarse en la tabla de amortizacion ANEXO A.
           <br>
                <b>    Fecha de corte: </b> La primera el <u>@@siguiente_pago@@</u>, las posteriores pueden
                consultarse en la tabla de amortizacion ANEXO A.

            </td>
          </tr>
          <tr>
            <td colspan="4" class="texto_central"> COMISIONES RELEVANTES </td>
          </tr>
          <tr>
            <td colspan="2" class="borde_abajo texto_top">
              <ul>
                <li type="circle">Gastos de Investigacion y/o Formalizacion </li>
                <li type="circle">Recolecci&oacute;n de Pago a Domicilio </li>
                <li type="circle">Reimpresi&oacute;n de Estado de Cuenta</li>
            
              </ul>
            </td>
            <td colspan="2" class="borde_abajo texto_top">
              <ul>
                <li type="none">$ 30 + IVA por unica ocasi&oacute;n</li>
                <li type="none">$ 40 + IVA por evento </li>
                <li type="none">$ 30 + IVA por evento</li>
                
              </ul>
            </td>
          </tr>  
          <tr>
            <td colspan="4"><center> <b> ADVERTENCIA </b> </center></td>
          </tr>
          <tr>
            <td colspan="4" class="borde_abajo"> <br />
                    <ul>
                <li type="circle">Incumplir tus obligaciones te puede generar comisiones e intereses moratorios </li>
                <li type="circle">* Contratar cr&eacute;ditos por arriba de tu capacidad de pago, puede afectar tu historial crediticio. </li>
                <li type="circle">El avalista, obligado solidario o coacreditado respondera como obligado principal frente a la Entidad Financiera</li>
            
              </ul>
            </td>
          </tr>  
          <tr>     
            <td colspan="4" class=" texto_central"> SEGUROS </td>            
              </tr>                           
              <tr>
                <td colspan="4">            
                  <table width="100%" border="0" cellspacing="0" cellpadding="5">
                    <tr>                 
                      <td width="40%" VALIGN="TOP" class="borde_der borde_arriba borde_abajo">                
                        <b>Seguro:</b> 
                        _N/A_ (opcional u obligatorio)
                        De no contratar seguro, la cantidad que no estuviere
                        cubierta ser&aacute; exigible a la sucesi&oacute;n intestada o
                        testamentaria que corresponda.
                        <br /><br />                      
                      </td>   
                      <td width="30%" VALIGN="TOP" class="borde_der borde_arriba borde_abajo">    
                        <b>Aseguradora:</b>
                       
                      </td>                            
                      <td width="30%" VALIGN="TOP" class="borde_arriba borde_abajo">  
                        <b>Cl&aacute;usula:</b>
                       En la Cl&aacute;usula: VIGESIMA del contrato de
                       adhesi&oacute;n se detallan seguros del presente
                       producto.                              
                      </td>                            
                    </tr> 
                      </table> 
                </tr>                           
                                        
                
          <tr>
            <td colspan="4" ><center>
              <b> ESTADO DE CUENTA:<br /> 
              </center>
            </td>
          </tr>
      <tr><td colspan="4" class="borde_abajo">
        <table>
        <tr>
         <td class="alinear_der">Enviar a: domicilio ________</td>
         <td width=10% ></td>
         <td  class="alinear_der">Consulta: v&iacute;a internet _______</td>
         <td width=10%></td>
         <td  class="alinear_der">En sucursal: __________</td>
         </tr>

       </table></td></tr>
          <tr>
            <td colspan="4" class="borde_abajo">
                <center> 
              <b> ACLARACIONES Y RECLAMACIONES: </b>
              </center>
              
Unidad Especializada de Atenci&oacute;n a Usuarios: CAJA ITZAEZ SC DE AP DE RL DE CV, recibe las consultas, reclamaciones o aclaraciones, en su
Unidad Especializada de Atenci&oacute;n a Usuarios en un plazo de 90 d&iacute;as posterior al corte del mismo, de conformidad con lo estipulado en el
procedimiento se&ntilde;alado en el art&iacute;culo 23 de la Ley para la Transparencia y Ordenamiento de los Servicios Financieros, en un horario de 9:00 a 17:00
horas, as&iacute; como en cualquiera de sus sucursales u oficinas.
Domicilio: Calle 43 # 587 x 88 y 88-A Colonia Inalambrica C.P. 97069 M&eacute;rida Yucat&aacute;n. Tel&eacute;fono: 999-920-52-40.
Correo electr&oacute;nico: aclara_itzaez@cajaitzaez.mx P&aacute;gina de internet: www.cajaitzaez.mx.
            </td>
          </tr>
          <tr>
            <td colspan="4"> 
              <b> Registro de Contratos de Adhesi&oacute;n N&uacute;m: 4933-439-032364/04-04344-1022	      </b> <br />
              
              Comision Nacional para la Proteccion y Defensa de los Usuarios de Servicios Financieros (CONDUSEF)<br />
             <tr><td colspan="4" >
Tel&eacute;fono: 55 53 40 09 99. P&aacute;gina de internet: www.condusef.gob.mx; correo electr&oacute;nico: asesoria@condusef.gob.mxx
</td></tr>

            </td>
          </tr>



          
        </table>
      </td>


            <tr>     
            <td colspan="4" class="borde_abajo borde_der borde_izq texto_central"> DE CONFORMIDAD: </td>            
              </tr>                           
              		<tr>
				<td colspan="5">
                    <table class="borde_completo" width="100%">
					<tr >
                        <td width="10%"  ></td>
                        <th width="35%"  >CAJA ITZAEZ, SC DE AP DE RL DE CV </th>
						<td width="10%"  ></td>
						<tH width="35%"  >"EL ACREDITADO"</tH>
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
						<td ><center>@@representante_legal@@</center></td>
						<td ></td>
                        <td ><center>@@nombre_socio@@ <br> @@numero_ogs@@</center></td>
                        <td ></td>
					</tr>
					<tr>
						<td ></td>
						<tH >Representante legal</tH>
						<td ></td>
                        <tH >Nombre y n&uacute;mero de socio</tH>
                        <td ></td>
					</tr>
          <tr><td colspan="5">&nbsp;</td></tr>          
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

