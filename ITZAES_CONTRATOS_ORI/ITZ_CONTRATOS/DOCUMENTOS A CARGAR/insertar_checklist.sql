-----POR VEZ PRIMERA SE DEBERA HACER LOS INSERT A LAS SIGUIENTES TABLAS

/*
DELETE FROM tablas
WHERE idtabla = 'lista_contratos'AND idelemento = 'contrato_checklist_creditos'; 
*/

INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato2,tipo) 
VALUES ('lista_contratos','contrato_checklist_creditos','Check List ITZAES','carta','30402',0);

/* 
DELETE FROM tablas
WHERE idtabla = 'texto_html_contratos'AND idelemento = 'contrato_checklist_creditos';
*/

INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,dato4,tipo,dato2)
VALUES ('texto_html_contratos',
'contrato_checklist_creditos',
'Check List ITZAES',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0,
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>CHECKLIST MANUAL</title>
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

.texto_centro {
	font-size: 10pt;
    text-align: center;
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

.color_back{
background-color: #B9B9B9;

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
      <td > imagen<img src="/usr/local/saicoop/img_caratula_prestamos/logo.jpg" alt=""  height="50" /></td>
         
    </tr>


    <tr>

      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td ><center><b>SOCIEDAD COOPERATIVA DE AHORRO Y PR&Eacute;STAMO DE RESPONSABILIDAD LIMITADA DE CAPITAL VARIABLE</b> </center><br /></td>
    </tr>
        <tr>
      <td ><center><b>DEPARTAMENTO DE CREDITO</b> </center><br /></td>
    </tr>
        <tr>
      <td ><center><b>CHECK LIST</b> </center><br /></td>
    </tr>


     
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="borde_completo color_back" colspan="3">
            <center><b>SUCURSAL:</b></center>  
            </td>
            <td class="borde_completo color_back" colspan="3">
            <center><b>FECHA:</b></center>  
            </td>

          </tr>

          <tr>
            <td colspan="3" class="borde_completo texto_centro"> @@@idorigenp|nombre@@@</td>

            <td colspan="3" class="borde_completo texto_centro">@@@fecha_hoy|dd@@@ de @@@fecha_hoy|mm@@@ del @@@fecha_hoy|aaaa@@@</td>
          </tr>


            <tr>
            <td class="borde_completo color_back" >
            <center><b>NOMBRE DEL SOCIO:</b></center>  
            </td>
            <td class="borde_completo color_back" >
            <center><b>NO. SOCIO:</b></center>  
            </td>
                        <td class="borde_completo color_back" >
            <center><b>NO. PTMO:</b></center>  
            </td>
            <td class="borde_completo color_back " colspan="3" >
            <center><b>TIPO DE PRESTAMO:</b></center>  
            </td>

          </tr>
            <tr>
            <td  class="borde_completo texto_centro"> @@@nombre_socio|@@@</td>

            <td  class="borde_completo texto_centro">@@@ogs|@@@</td>
            <td  class="borde_completo texto_centro"> @@@idorigenp|@@@-@@@idproducto|@@@-@@@idauxiliar|@@@</td>

            <td colspan="3"  class="borde_completo texto_centro">@@tipo_prestamo@@</td>
          </tr>

          <table border="0" >



            <tr>
            <td  width="15%">
              DOCTOS DE LA VIALIDAD CREDITICIA
            </td>


            <td width="15%"  >

            </td>
            
            <td width="8%" >
              

            </td>
            <td width="15%">
              HISTORICOS.
            </td>

            <td width="15%" >

            </td>
            <td width="8%" >
              

            </td>


          </tr>
          <tr>
            <td width="">SOLICITUD DE CREDITO </td> 
            <td> &nbsp; </td> 
            <td  class="borde_completo"></td>
           
            <td colspan="2">HISTORIALES DE CREDITO, AHORRO Y AVALADOS(A&Ntilde;O ANTERIOR Y A&Ntilde;O ACTUAL)</td>
            
            <td witdh="10%"  class="borde_completo"></td>
          </tr>
    
          <tr>
            <td>&nbsp;</td> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
           
           
            <td>BURO INTERNO</td>
            <td>&nbsp;</td>
            <td class="borde_completo"></td>
          </tr>

          <tr>
            <td></td> 
            <td></td>
            
            <td>&nbsp;</td>
           
            <td colspan="2">CARTA Y REPORTE DE BURO (EN SU CASO)</td>
            <td class="borde_completo"></td>
           
          </tr>

          <tr>
           
            <td>DOCTOS. DEL SOCIO</td> 
            <td> </td>
           <td></td>
            <td colspan="2">DOCTOS. DEL CREDITO</td>
           
            <td></td>
          </tr>

          <tr>
            <td>IDENTIFICACION</td> 
            <td></td>
            <td class="borde_completo"></td>
           
            <td colspan="2">CONTRATO DE CREDITO</td>
            <td class="borde_completo"></td>
           
          </tr>

            <tr>

            <td>COMPROBANTE DE DOMICILIO</td>
            <td></td> 
            <td class="borde_completo"></td>
            
           
            <td colspan="2">ANEXO DE CONTRATO</td>
            <td class="borde_completo"></td>
            
          </tr>

                      <tr>
            <td>COMPROBANTE DE INGRESOS</td> 
            <td></td>
            <td class="borde_completo"></td>
            
           
            
            <td colspan="2">COPIA DE PAGARE</td>
            <td class="borde_completo"></td>
            
          </tr>

                    <tr>
            <td></td> 
            <td></td>
           <td></td>
            <td colspan="2">COPIA DE FICHA DE ENTREGA DEL CREDITO</td>
            <td class="borde_completo"></td>
          
          </tr>

          <tr>
            <td colspan="6"   ><center><b> <br> OBSERVACIONES ANALISTA DE CREDITO</b> </center> </td>
          </tr>
          <tr>
           <td colspan="6"   class="borde_abajo"> <br><br><br> </td> 
          </tr>

          <tr>
           <td colspan="6"   class="borde_abajo"> <br><br> </td> 
          </tr>
                    <tr>
           <td colspan="6"  class="borde_abajo"> <br><br> </td> 
          </tr>
                    <tr>
           <td colspan="6"   class="borde_abajo"> <br><br> </td> 
          </tr>
                    <tr>
           <td colspan="6"  class="borde_abajo"> <br><br> </td> 
          </tr>
          </table>
        </table>
      </td>
             <br><br>                 
              	
                    <table  width="100%">
					<tr >
                        <td width="10%"  ></td>
                        <th width="35%"  >INTEGRADO Y COTEJADO POR </th>
						<td width="10%"  ></td>
						<tH width="35%"  >Vo. Bo.</tH>
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
						<td ><center>@@@elaboro|@@@ @@@nombre_elaboro|@@@</center></td>
						<td ></td>
                        <td ><center> <!-- Aqui deberia ir el nombre de la analista pero ese dato no lo tenemos de esa manera---></center></td>
                        <td ></td>
					</tr>
					<tr>
						<td ></td>
						<tH >CAJERO</tH>
						<td ></td>
                        <tH >ANALISTA DE CREDITO</tH>
                        <td ></td>
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