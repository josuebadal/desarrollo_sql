UPDATE tablas 
set dato2 = '#CENTRO# #N# COMPROBANTE DE CLABE INTERBANCARIA #|N# #|CENTRO#

#N#Sucursal: #|N# <idorigenp|> <nombre_sucursal.sql|>
#N#Fecha de entrega: #|N# <dia_de_hoy|dd> del mes de <dia_de_hoy|ml> del <fecha_hoy_anio.sql|>.

#N#I. SECCI&Oacute;N DATOS GENERALES DEL SOCIO.#|N#

#N#Nombre Completo:#|N# <nombre_socio|>

#N#N&uacute;mero Del Socio:#|N# <ogs|o-g-s>

#N#Tipo De Pr&eacute;stamo:  #|N# <nombreprod|>

#N#Folio Del Pr&eacute;stamo:  #|N# <idorigenp|>-<idproducto|>-<idauxiliar|>

#N#II. SECCI&Oacute;N DATOS PARA REALIZAR PAGOS V&Iacute;A TRANSFERENCIA.#|N#

#N#Iinstitucion Bancaria Receptora:#|N#

#N#CLABE Interbancaria (18 Digitos):#|N# <clabe_interbancaria.sql|>

#N#Concepto De Pago (Si Aplica):#|N#

#N#AVISO IMPORTANTE #|N#

El Socio/Cliente declara haber recibido correctamente la CLABE interbancaria antes descrita y reconoce que:
I.- Es su responsabilidad verificar que los datos de la cuenta sean capturados correctamente al momento de realizar la transferencia.

II.-La Cooperativa no se hace responsable por pagos enviados a cuentas distintas, errores de captura, transferencias realizadas con datos incorrectos o pagos no identificables.

III.- Se le invita a comunicarse con la sucursal correspondiente para confirmar la correcta recepción y aplicación de su pago una vez realizada la transferencia.

IV.- Las transferencias podr&aacute;n realizarse de lunes a domingo en un horario de 8:00 a.m. a 8:00 p.m. En caso de que el pago se efect&uacute;e fuera del horario establecido, este podr&aacute; aplicarse hasta el d&iacute;a siguiente, en consecuencia, cualquier inter&eacute;s adicional que se genere por dicha situacion deber&aacute; ser cubierto por el socio.

#N#Confirmacion De Recibido#|N#

Declaro que he recibido la información necesaria para realizar mis pagos mediante transferencia bancaria y que conozco las condiciones antes mencionadas.


#CENTRO##N#"EL SOCIO"#|N#


_________________________
<nombre_socio|>
Nombre y firma.
#|CENTRO#
                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
'
where idtabla = 'texto_contratos' 
and idelemento = 'contrato_cuenta_clabe';