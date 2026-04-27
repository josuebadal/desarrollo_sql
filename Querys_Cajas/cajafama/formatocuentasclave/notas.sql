----------SOCIO PARA PRUEBAS
idorigen           | 30512
idgrupo            | 10
idsocio            | 988
idorigenp          | 30501
idproducto         | 30112
idauxiliar         | 108


----------DATOS DEL FORMATO EN CSN-------
--Todo traido desde TABLAS
idtabla    | html_contratos
idelemento | ahorro_141_activa
nombre     | 
dato1      | iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html
dato3      | gnome-open %s.html; sleep 15
dato4      | rm -rf %s.*
dato5      | 
tipo       | 0


-------BUSCAMOS SOLO EL DATO 2 DE LO ANTERIOR
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.contenedor {
	height: 26.5cm;
	width: 19cm;
	font-family: courier;
	font-size: 12pt;
}
.borde_bajo {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #000;
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
.pos_abajo {
	vertical-align: bottom;
}
.top_texto {
	vertical-align: top;
}
.justificado {
	text-align: justify;
}
.texto {
	font-size: 12pt;
}
.alinear_abajo {
	vertical-align: bottom;
}
thead {
	display: table-header-group;
}
tfoot {
	display: table-footer-grupo;
}
</style>
</head>
<body style="text-align: justify;">
<div class="contenedor">
  <table class="texto" border="0" cellspacing="0" cellpadding="0">
    <thead>
      <tr align="right">
        <td> 
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="35%"><img src="/usr/local/saicoop/img/logo_csn_2.jpg" width="472" height="72" /></td>
              <td width="65%" class="izq"></td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
          </table>
        </td>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>
          <table class="texto" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
@@@@AQUI VA EL TEXTO DEL CONTRATO@@@@
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </tbody>
  </table> 
</div>
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

---------------------CON TODO Y LOS ESPACIO------

--------------BUSCAMOS EN TABLAS -TEXTO CONTRATOS
select idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo from tablas where idtabla = 'texto_contratos' and idelemento = 'ahorro_141_activa';

idtabla    | texto_contratos
idelemento | ahorro_141_activa
nombre     | HOJA ACTIVACION DE PRODUCTO V010916
dato1      | carta
dato3      | 77|100|9|2|2
dato4      | 
dato5      | 
tipo       | 0

-------BUSCAMOS SOLO EL DATO 2 DE LO ANTERIOR


#CENTRO##N#HOJA DE ACTIVACI&Oacute;N DEL PRODUCTO#|N#
#N#"CSN M&Oacute;VIL"#|N##|CENTRO#

#N#I. SECCI&Oacute;N DATOS GENERALES DEL SOCIO.#|N#

#N#ALTA DE CSN M&Oacute;VIL.#|N#

#N#CURP DEL SOCIO:#|N# <curp|>

#N#NOMBRE DEL SOCIO:#|N#  <nombre_socio|>

#N#N&Uacute;MERO DEL SOCIO:#|N#  <ogs|o-g-s>

#N#CORREO ELECTR&Oacute;NICO:#|N#  <email|>

#N#TEL&Eacute;FONO DE CASA: #|N# <telefono1|>

#N#TEL&Eacute;FONO DE CELULAR: #|N# <num_celular.sql|> 

#N#N&Uacute;MERO DE USUARIO: #|N# <alias_banca_movil.sql|>

#N#FECHA DE NACIMIENTO:#|N#  <fechanacimiento|dd> del mes  <fechanacimiento|ml>  <fechanacimiento|aaaa> 

#N#RFC DEL SOCIO:#|N#  <rfc|>

#N#CLABE INTERBANCARIA:#|N# <clabe_interbancaria.sql|>

#N#C&Oacute;DIGO POSTAL:#|N#  <direccion|codigopostal>

#N#DOMICILIO: #|N# <direccion|callecolonia>  <direccion|munest>

#N#II. CUENTAS "CSN M&Oacute;VIL".#|N#
#N#N&Uacute;MERO DE CUENTA: #|N#NO Aplica.


#N#III. COMISIONES.#|N#
#N#COMISI&Oacute;N:#|N# Este Producto no genera ninguna comision.


#N#IV. PLAZO O VIGENCIA DEL CONTRATO.#|N#
#N#PLAZO:#|N#Indefinido.
#N#FECHA DE SUSCRIPCI&Oacute;N: #|N# <fechaapertura|>

#N#V. L&Iacute;MITES DE MONTO Y FRECUENCIA DEL SERVICIO.#|N#
#N#L&Iacute;MITE DE MONTO:#|N# El monto m&iacute;nimo es de $0.01 pesos mexicanos por operaci&oacute;n ya sea de env&iacute;o o recepci&oacute;n; Monto m&aacute;ximo de SPEI de entrada $200,000.00 pesos mexicanos diarios en una o varias operaciones; Monto m&aacute;ximo para retiros por SPEI de salida $20,000.00 pesos mexicanos por d&iacute;a en varias operaciones que en lo individual no deban exceder del equivalente en Moneda Nacional a 1500 UDIS y el l&iacute;mite de retiros acumulados en el mes ser&aacute; de $100,000.00 pesos mexicanos.
Las cuentas establecidas para menores de edad contar&aacute;n con las siguientes restricciones; no se podr&aacute;n recibir transferencias de m&aacute;s de $20,000.00 pesos mexicanos mensuales, as&iacute; como tampoco se podr&aacute; recibir m&aacute;s de 5,000 pesos mexicanos diarios y el saldo m&aacute;ximo acumulado permitido en este tipo de cuentas, es de $100,000.00 pesos mexicanos. Adicional a lo anterior, las cuentas de menores de edad cuyo tutor designado no sea socio de CSN, estar&aacute;n limitadas a un saldo m&aacute;ximo acumulado permitido hasta por el equivalente en Moneda Nacional a 1,500 UDIS.

#N#Frecuencia del Servicio:#|N# Ilimitado.










                
#N#VI. LUGAR Y FECHA DE FIRMA.#|N#
San Nicol&aacute;s de los Garza, Nuevo Le&oacute;n el d&iacute;a <dia_de_hoy|dd> del mes de <dia_de_hoy|ml> del <fecha_hoy_anio.sql|>.


#N#"CSN"#|N#
   

_______________________
 <gerente_sucursal|>
Nombre y firma



#N#"EL SOCIO"#|N#


_________________________
 <nombre_socio|>
Nombre, firma y huella

Datos de inscripci&oacute;n en el Registro de Contratos de Adhesi&oacute;n de la CONDUSEF.
#N#Contrato de Ahorro Mayor#|N#:  2045-003-001306/
#N#Tarjeta de D&eacute;bito CSN#|N#: 2045-003-019814/
#N#CSN M&oacute;vil#|N#: 2045-433-026574/
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

--------------BUSCAMOS EN TABLAS -LISTA CONTRATOS
idtabla    | lista_contratos
idelemento | ahorro_141_activa
nombre     | HOJA ACTIVACION DE PRODUCTO V010916
dato1      | carta
dato2      | 141
dato3      | 
dato4      | 
dato5      | 
tipo       | 0


select   clabe from     ws_siscoop_clabe_interbancaria where    (idorigenp,idproducto,idauxiliar) in (30513,30112,68) and asignada and activa order by fecha_hora desc limit 1
Message: ------------------------>> CAMPO : nombre_socio, FORMATO : 
Message: PAGINAS : 2
Message: comando: iconv /tmp/164150425~ -f ISO-8859-1 -t UTF-8 -o /tmp/164150425~.html
Message: comando: gnome-open /tmp/164150425~.html; sleep 15
Safe Browsing server returned a 400 during update:request url = https://safebrowsing.googleapis.com/v4/threatListUpdates:fetch?$ct=application/x-protobuf&key=AIzaSyBPGXa4AYD4FC3HJK7LnIKxm4fDusVuuco&$httpMethod=POST, payload = ChUKE25hdmNsaWVudC1hdXRvLWZmb3gaJwgFEAIaGwoNCAUQBhgBIgMwMDEwARDV6x4aAhgEn0FRjiICIAIoARonCAEQAhobCg0IARAGGAEiAzAwMTABEMqRFBoCGAQDfA96IgIgAigBGicIAxACGhsKDQgDEAYYASIDMDAxMAEQuYoUGgIYBFpYno0iAiACKAEaJwgHEAIaGwoNCAcQBhgBIgMwMDEwARDChhQaAhgET-lliSICIAIoARolCAkQAhoZCg0ICRAGGAEiAzAwMTABECQaAhgE2QsWPSICIAIoAQ==
Message: activa_tiempo_borrar_edocta_caratula...
DEBUG_DB: Function:
   select dato1 from tablas where idtabla = 'tiempo_borrar_edocta_caratula' and idelemento::integer = 30513
Message: comando: rm -rf /tmp/164150425~.*

insert into   campos_formatos (idformato,pagina,campo,nom_campo,fila,columna,longitud,alineacion,tipo,observaciones)
values (86,
1,
'clabe_interbancaria.sql',
'clabe_interbancaria.sql',
18,10,5,'D','*',
  'select   clabe from     ws_siscoop_clabe_interbancaria
   where (idorigenp,idproducto,idauxiliar) = (select idorigenp, idproducto, idauxiliar from auxiliares
   where idorigenp = <idorigenp> and idproducto = <idproducto> and idauxiliar = <idauxiliar> and asignada and activa
   order by fecha_hora desc limit 1');

select   clabe from     ws_siscoop_clabe_interbancaria
   where (idorigenp,idproducto,idauxiliar) = (select idorigenp, idproducto, idauxiliar from auxiliares
   where idorigen = 30513 and idgrupo = 10 and idsocio = <idsocio> and asignada and activa
   order by fecha_hora desc limit 1);



DELETE FROM campos_formatos 
WHERE campo = 'clabe_interbancaria.sql'
AND nom_campo = 'clabe_interbancaria.sql';


select idtabla,idelemento 
from tablas where idtabla = 'texto_contratos' 
order by idelemento;

Delete from tablas  
WHERE idtabla = 'texto_contratos' 
and idelemento= 'contrato_cuenta_clabe'
;