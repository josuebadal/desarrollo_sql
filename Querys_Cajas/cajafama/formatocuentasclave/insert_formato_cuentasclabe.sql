---------------------------------
-----ULTIMA MOD: 7-Abril-2026
----- JJBADAL
----- NOTAS: Se creo el formato 7-Abril-2026 
---------------------------------
INSERT INTO tablas  
(idtabla,idelemento,nombre,dato1,dato3,tipo) 
VALUES (
'texto_contratos',
'contrato_cuenta_clabe',
'COMPROBANTE DE CLABE INTERBANCARIA',
'carta',
'80|100|11|2|2',0 );



-----INSERT LISTA_CONTRATOS-----
INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato2,tipo)
VALUES (
'lista_contratos',
'contrato_cuenta_clabe',
'COMPROBANTE DE CUENTA INTERBANCARIA',
'carta',
'30112',0
);


-----INSERT CUENTA_CLABE-----
insert
into   campos_formatos
       (idformato,pagina,campo,nom_campo,fila,columna,longitud,alineacion,tipo,observaciones)
values (86,1,'clabe_interbancaria.sql','clabe_interbancaria.sql',18,10,5,'D','*',
        'select   clabe
         from     ws_siscoop_clabe_interbancaria
         where    (idorigenp,idproducto,idauxiliar) = (<idorigenp>,<idproducto>,<idauxiliar>) 
         and asignada and activa '
        'order by fecha_hora desc limit 1');

-----INSERT NOMBRE ORIGEN-----
insert
into   campos_formatos
       (idformato,pagina,campo,nom_campo,fila,columna,longitud,alineacion,tipo,observaciones)
values (86,1,'nombre_sucursal.sql','nombre_sucursal.sql',18,10,100,'D','*',
        'select   o.nombre
         from     origenes as o
         where    o.idorigen = <idorigenp>
         limit 1
        ');

-----INSERT HTML_CONTRATOS-----
INSERT INTO tablas (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
VALUES (
'html_contratos',
'contrato_cuenta_clabe',
'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
'gnome-open %s.html; sleep 15',
'rm -rf %s.*',0,
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">                                                                                                                   
                                                                                                                                                                                                                                              
                                        
  <html xmlns="http://www.w3.org/1999/xhtml">                                                                                                                                                                                                                                
  <head>                                                                                                                                                                                                                                     
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />                                                                                                                                                                      
  <style type="text/css">                                                                                                                                                                                                                    
  .contenedor {                                                                                                                                                                                                                              
          height: 26.5cm;                                                                                                                                                                                                                    
          width: 19cm;                                                                                                                                                                                                                       
          font-family: courier;                                                                                                                                                                                                              
          font-size: 11pt;                                                                                                                                                                                                                   
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
                <td width="35%"><img src="/usr/local/saicoop/img/logo.jpg" width="120" height="65" /></td>                                                                                                                                   
                <td width="65%" class="izq">&nbsp;</td>                                                                                                                                                                                      
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
                                                                                                                                                                                                                                              
                                        
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
                                       
');



------HTML DEL FORMATO PARA ACTUALIZACION-----
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