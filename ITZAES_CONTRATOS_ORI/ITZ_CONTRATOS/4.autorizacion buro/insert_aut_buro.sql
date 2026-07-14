INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,dato4,tipo,dato2)
VALUES ('texto_html_contratos',
'contrato_solicitud_buro',
'Consulta De Buro',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 100',
'rm -rf %s.*',0,
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>AUTORIZACION BURO DE CREDITO</title>

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

.alinear_der {
	text-align: right;
}

.alinear_izq {
	text-align: left;
}
.alinear_just {
	text-align: justify;
}
.color_back{
background-color: #B9B9B9;
}
</style>

</head>
<body onload="seccion()">
 <div class="contenedor">
    <br>
<!--  ENCABEZADO PRINCIPAL ********************************************************************************************* -->
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      
    <tr>
          <td colspan="6" > <div  ><font size="4">
            <BR><br>IMAGEN    </font>  </div> </td>
    </tr>

           <tr>
           <td colspan="6"  class="alinear_der" > <font size="3"><br>M&Eacute;RIDA,YUCAT&Aacute;N a <u> @@dia@@</u> de <u> @@mes@@</u> de 20<u> @@anio@@</u> </font></td>           
            </tr>

            <tr>
           <th colspan="6"   ><font size="3"><br><b>Formato de autorizaci&oacute;n definido para las Entidades Financieras (Reguladas)
            Autorizaci&oacute;n para solicitar Reportes de CR&Eacute;DITO
            Personas F&iacute;sicas / Personas Morales</b></font></th>           
            </tr>

            <tr>
           <td colspan="6"  class="alinear_just"> <font size="3"><br>
          Por este conducto autorizo expresamente a <b> Caja Itzaez S.C. de A.P. de R.L. de C.V., </b> para que por conducto de sus
          funcionarios facultados lleve a cabo Investigaciones, sobre mi comportamiento crediticio o el de la Empresa que
          represento en Trans Union de M&eacute;xico, S. A. SIC y/o Dun & Bradstreet, S.A. SIC
          </font></td>           
            </tr>

            <tr>
           <td colspan="6"  class="alinear_just"> <font size="3"><br>
As&iacute; mismo, declaro que conozco la naturaleza y alcance de la informaci&oacute;n que se solicitar&aacute;, del uso que <b> Caja Itzaez S.C.
de A.P. de R.L. de C.V. </b> har&aacute; de tal informaci&oacute;n y de que &eacute;sta podr&aacute; realizar consultas peri&oacute;dicas sobre mi historial o el
de la empresa que represento, consintiendo que esta autorizaci&oacute;n se encuentre vigente por un per&iacute;odo de 3 a&ntilde;os contados
a partir de su expedici&oacute;n y en todo caso durante el tiempo que se mantenga la relaci&oacute;n jur&iacute;dica.
          
          </font></td>           
            </tr>




            <tr>
           <td colspan="6"  class="alinear_just"> <font size="3"><br>
En caso de que la solicitante sea una Persona Moral, declaro bajo protesta de decir verdad Ser Representante Legal de
la empresa mencionada en esta autorizaci&oacute;n; manifestando que a la fecha de firma de la presente autorizaci&oacute;n los poderes
no me han sido revocados, limitados, ni modificados en forma alguna. <br>
Autorizaci&oacute;n para: <br>      
          </font></td>           
            </tr>
            

          <tr>
           <td colspan="2" > <font size="3"><br>
        <b>  Persona F&iacute;sica (PF)________</b>  
       </font>    
      </td>    
          <td colspan="2" > <font size="3"><br>
        <b>  Persona F&iacute;sica con Actividad Empresarial (PFAE)________</b>  
       </font>    
      </td> 
        <td colspan="2" > <font size="3"><br>
        <b>  Persona Moral (PM)________</b>  
       </font>    
      </td>        
            </tr>

          <tr>
           <td colspan="6" class="alinear_just"> <font size="3"><br>
        Nombre del solicitante (Persona F&iacute;sica o Raz&oacute;n Social de la PersonaMoral):
 
       </font>    
      </td>  
          </tr>

          <tr>
           <td colspan="6" class="borde_bajo"> <br> <br> <br> <br>
      </td>  
          </tr>


                    <tr>
           <td colspan="6" class="alinear_just"> <font size="3"><br>
        Para el caso de Persona Moral, nombre del Representante Legal:
 
       </font>    
      </td>  
          </tr>

          <tr>
           <td colspan="6" class="borde_bajo"> <br> <br> <br> <br>
      </td>  
          </tr>


          <tr>
           <td colspan="1" class="alinear_just"> <font size="3"><br>
        RFC:
 
       </font>    
      </td>  

        <td colspan="5" class="borde_bajo">
        </td>
          </tr>


                    <tr>
           <td colspan="1" class="alinear_just"> <font size="3"><br>
        Domicilio:
 
       </font>    
      </td>  

        <td colspan="2" class="borde_bajo">
        </td>
                   <td colspan="1" class="alinear_just"> <font size="3"><br>
        Colonia:
       </font>    
      </td>  

        <td colspan="2" class="borde_bajo">


        </td>
          </tr>


                              <tr>
           <td colspan="1" class="alinear_just"> <font size="3"><br>
        Municipio:
 
       </font>    
      </td>  

        <td colspan="1" class="borde_bajo">


        </td>
        
                   <td colspan="1" class="alinear_just"> <font size="3"><br>
        Estado:
 
       </font>    
      </td>  

        <td colspan="1" class="borde_bajo">

                             <td colspan="1" class="alinear_just"> <font size="3"><br>
        Codigo postal:
 
       </font>    
      </td>  

        <td colspan="1" class="borde_bajo">


        </td>
          </tr>


                    <tr>
           <td colspan="1" class="alinear_just"> <font size="3"><br>
        Telefono(s):
 
       </font>    
      </td>  

        <td colspan="5" class="borde_bajo">


        </td>
          </tr>

          
            <tr>
    <td colspan="6"  class="alinear_just"> <font size="3"><br>
<b>
    Estoy de acuerdo y acepto que este documento quede bajo propiedad de Caja Itzaez S.C. de A.P. de R.L. de C.V.
y/o Sociedad de Informaci&oacute;n Crediticia consultada para efectos de control <br><br><br> 
y cumplimiento del art&iacute;culo 28, 40 y
dem&aacute;s aplicables de la Ley para Regular a Las Sociedades de Informaci&oacute;n Crediticia; mismo que se&ntilde;ala que
las Sociedades s&oacute;lo podr&aacute;n proporcionar informaci&oacute;n a un Usuario, cuando &eacute;ste cuente con la autorizaci&oacute;n
expresa del Cliente mediante su firma aut&oacute;grafa. <br>  <br> <br> 
</b>    
          </font></td>           
            </tr>


                                <tr>
     <td colspan="1"></td>
     <td colspan="1"></td>
    
           <td colspan="1" class="alinear_der borde_arriba" > <font size="3"><br>
            <center>
        Nombre y firma
        <br>
        <br>
              </center>
       </font>    
      </td>  
        </td>
          </tr>


                      <tr>
           <th colspan="6" class="color_back"><font size="3"><br><b>
          Para uso exclusivo de la Empresa que efect&uacute;a la consulta (Caja Itzaez S.C. de A.P. de R.L. de C.V.)</b></font></th>           
            </tr>


            <tr>
           <td colspan="1" class="color_back"><font size="3"><br>
         
         Fecha de Consulta BC :
          </font></td>   
          <td  colspan="7" class="borde_bajo color_back"></td>        
            </tr>

            <tr>
           <td colspan="1" class="color_back"   ><font size="3"><br>
         
        Folio de Consulta BC :
          </font></td>   
          <td colspan="7" class="borde_bajo color_back">  </td>        
            </tr>
            <tr>
              <td colspan="8" class="color_back"> &nbsp; </td>
            </tr>
           

            
            <tr>
           <th colspan="6"    ><font size="3"><br><b>Calle 43 No. 587 x C-88 Y C-88 a Col. INAL&Aacute;MBRICA C.P.97069 Tel. (999) 207763 (64)</b></font></th>           
            </tr>


            <tr>
    <td colspan="6"  class="alinear_just"> <font size="1"><br>
<b>
    CAJA ITZAEZ S.C. DE A.P. DE R.L. DE C.V.</b> Con domicilio en CALLE 43 n&uacute;mero 587 x 88 y 88 letra A, colonia INAL&Aacute;MBRICA, Ciudad de
M&Eacute;RIDA, YUCAT&Aacute;N, C&oacute;digo Postal 97069, es responsable del uso y protecci&oacute;n de los datos personales proporcionados. Usted tiene derecho
a conocer qu&eacute; datos personales tenemos suyos puede hacer uso de sus Derechos ARCO ponemos a su disposici&oacute;n el Aviso de Privacidad
en http://cajaitzaez.mx/avisoprivacidad.html para m&aacute;s informaci&oacute;n comunicarse con el Lic. Jes&uacute;s Adri&aacute;n Lugo Buendia, quien ha sido
designado para recibir y dar tr&aacute;mite a las solicitudes para el ejercicio de esos derechos mediante el Formato &uacute;nico a los tel&eacute;fonos 9999205240
al correo electr&oacute;nico jlugo@cajaitzaez.mx <br>  <br> <br> 
    
          </font></td>           
            </tr>
 </table>
<BR><BR>
</body>
</div>
</html>
');