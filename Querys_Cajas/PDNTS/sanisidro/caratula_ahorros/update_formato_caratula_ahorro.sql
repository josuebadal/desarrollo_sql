UPDATE tablas
set dato2 = '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
.alinear_top {
  vertical-align: top;
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
.texto_menor {
  font-size: 8pt;
}
.borde_der {
  border-right-width: 1px;
  border-right-style: solid;
  border-right-color: #000;
}


</style>


  <script type="text/javascript">
    window.onload = function seccion() {
      var t_op = document.getElementById("ti_ope");
      var nom_prod = document.getElementById("nom_producto");
      var num_contra = document.getElementById("num_contrato");


      if (@@idproducto@@ == 120 ) {
        t_op.innerHTML = "<td><table><tr><td><center><b>GAT <br> Nominal <br><br> <u>@@gat_nominal_99.99@@</u>%</b></center></td><td ><center><b>GAT <br> Real <br><br> <u>@@gat_real_99.99@@</u>%</b></center> </td></tr></table><center><b>Antes de impuestos</b></center><br><center> <b>&quot;Para fines informativos y de comparaci&oacute;n&quot;</b></center><br><center> <b>La GAT real es el rendimiento que obtendr&iacute;a despu&eacute;s de descontar la inflaci&oacute;n estimada</b></center></td>";
        nom_prod.innerHTML ="Ahorro Menor";
        num_contra.innerHTML="5021-003-010388/03-04812-1122";
      }

      if (@@idproducto@@ == 110){
        t_op.innerHTML ="GAT NOMINAL: <u>@@gat_nominal_99.99@@ </u>%Antes de impuestos “Para fines informativos y de comparaci&oacute;n” <br><br>  GAT REAL: <u>@@gat_real_99.99@@</u>% antes de impuestos <br> <br>La GAT real es el rendimiento que obtendr&iacute;a despu&eacute;s de descontar la inflaci&oacute;n estimada";
        nom_prod.innerHTML ="Ahorro Mayor";
        num_contra.innerHTML="5021-003-008988/10-01065-0526";

      }
      if (@@idproducto@@ == 130){
        t_op.innerHTML ="GAT NOMINAL: <u>@@gat_nominal_99.99@@ </u>%Antes de impuestos “Para fines informativos y de comparaci&oacute;n” <br><br>  GAT REAL: <u>@@gat_real_99.99@@</u>% antes de impuestos <br> <br>La GAT real es el rendimiento que obtendr&iacute;a despu&eacute;s de descontar la inflaci&oacute;n estimada";
        nom_prod.innerHTML ="Ahorro Disponible";
        num_contra.innerHTML="5021-003-012959/08-01066-0526";
      }
    };

  </script>




</head>
<body>
<div class="contenedor">
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
    <tr><td><p align="right"><b> Registro de Contratos de Adhesi&oacute;n N&uacute;mero:  <a id="num_contrato"></a></b></p></td></tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="18%"><center><img src="/usr/local/saicoop/img_caratula_ahorros/logo.jpg" alt="" width="121" height="130" /></center></td>
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
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td> <center> <b>CAR&Aacute;TULA DE DEP&Oacute;SITO</b></center></td>
    </tr>
    <tr>
      <td>
        <table class="borde_total texto_resumen" width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Nombre comercial del Producto: </b> <a id="nom_producto"> @@tipo_ahorro@@</a></td>
          </tr>
          <tr>
            <td><b> Tipo de Operaci&oacute;n: </b> PASIVA </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td class="borde_bajo">
              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                <tr>
                  <td width="25%" class="borde_der borde_bajo"><center><b> TASA DE INTER&Eacute;S ANUAL FIJA </b></center></td>
                  <td width="40%" class="borde_der borde_bajo"><center><b>GANANCIA ANUAL TOTAL NETA GAT</b></center></td>
                  <td width="35%" class="borde_bajo"><center><b> COMISIONES RELEVANTES </b></center></td>
                </tr>
                <tr>
                  <td class="borde_der"><center> @@tasa_io_anual_99.99@@ % <br /> ANTES DE IMPUESTOS </center></td>

                    <td class="borde_der" > <a id="ti_ope">
                  </a>
                  </td>
                  <td>
                    <center>Este producto no genera ninguna comisi&oacute;n.</center>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="50%" class="borde_der"><br /><center><b> MEDIOS DE DISPOSICI&Oacute;N </b></center></td>
                  <td width="50%"><br /><center><b> LUGARES PARA EFECTUAR RETIROS </b></center></td>
                </tr>
                <tr>
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="30%"><center> ___Tarjeta </center><br /></td>
                        <td width="36%"><center> <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>Cheques  </center><br /></td>
                        <td width="34%" class="borde_der"><center> <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>Efectivo </center><br /></td>
                      </tr>
                    </table>
                  </td>
                  <td><center> Ventanilla de la Sucursal <br /><br /></center></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> ESTADO DE CUENTA </b></td>
          </tr>
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="33%"> ___Enviar a domicilio </td>
                  <td width="34%"> ___Consulta v&iacute;a internet </td>
                  <td width="33%"> <u>&nbsp;&nbsp;X&nbsp;&nbsp;</u>A petici&oacute;n del socio en sucursal </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Producto garantizado hasta por 25 mil UDIS por el Fondo de Proteci&oacute;n </b></td>
          </tr>
          <tr>
            <td>Titular Garantizado(s): <u>@@nombre_socio@@</u></td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><b> Aclaraciones y reclamaciones: </b></td>
          </tr>
          <tr>
            <td>
              Unidad Especializada de Atenci&oacute;n  a Usuarios: <br>
              Domicilio: Calle Ter&aacute;n 503 oriente, Centro, Morelos, Coahuila, M&eacute;xico. CP 26500 <br>
              Tel&eacute;fono: (862) 624 0304 y 624 0450 Correo electr&oacute;nico:  une@cajasanisidro.com.mx <br>
              P&aacute;gina de Internet: www.cajasanisidro.com.mx <br>
              Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF):<br>
              Tel&eacute;fono: (55) 53400999. P&aacute;gina de Internet: www.condusef.gob.mx <br>
            </td>
          </tr>
          <tr>
            <td class="borde_bajo">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              El socio autoriza a la Cooperativa a utilizar los datos personales informados para fines de publicidad y promoci&oacute;n de sus productos
            </td>
          </tr>
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="50%"><center> ___SI </center></td>
                <td width="50%"><center> ___NO </center></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>
              <center> _____________________________________ <br />
              Firma </center>
            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
'
WHERE idtabla='param' 
AND idelemento='formato_caratula_ahorro';