/*DELETE FROM tablas WHERE idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_comercial%';
insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial307','CR&Eacute;DITO CONFIANZA','307');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial308','CR&Eacute;DITO ORDINARIO','308');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial309','CR&Eacute;DITO CREDIIMPULSO','309');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial311','CR&Eacute;DITO DE PRODUCCION','311');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial315','CR&Eacute;DITO CREDIFACIL','315');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial317','CR&Eacute;DITO CREDI 9','317');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial319','CR&Eacute;DITO AUTO 9','319');

insert
into   tablas
       (idtabla,idelemento,dato1,dato2)
values ('formato_caratula_prestamo','nombre_comercial320','CR&Eacute;DITO MOTO 9','320');*/

              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento like 'seguro_periodicos%';
              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento  like 'aseguradora_periodicos%';
              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento  like 'clausula_seguro_periodicos%';

             insert into tablas (idtabla,idelemento,dato1,dato2)       
              values ('formato_caratula_prestamo','seguro_periodicos','30705|31505|32301|32311|32321|32401|32605|32615|32703|31704|32803','No aplica');
             insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_periodicos1','31501|33001|33002|33003|31714|31724|32809|32819|30805','No aplica');
              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_periodicos2','30815|30825','No aplica');
            insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_periodicos','30705|31505|32301|32311|32321|32401|32605|32615|32703|31704|32803','NO APLICA');
             insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_periodicos1','31501|33001|33002|33003|31714|31724|32809|32819|30805','NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_periodicos2','30815|30825','NO APLICA');
            insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_periodicos','30705|31505|32301|32311|32321|32401|32605|32615|32703|31704|32803', 'NO APLICA');
            insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_periodicos1','31501|33001|33002|33003|31714|31724|32809|32819|30805', 'NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_periodicos2','30815|30825', 'NO APLICA');

              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento like 'seguro_unico%';
              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento like 'aseguradora_unico%';
              delete from tablas where idtabla='formato_caratula_prestamo'and idelemento like 'clausula_seguro_unico%';

              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_unico','31101|31111|32201|32221|32301|32311|32321|32703|32803','NO APLICA');
              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_unico1','31121|30901|33001|33002|33003|323|31704|31714|31724','NO APLICA');
              insert into tablas (idtabla,idelemento,dato1,dato2)
              values ('formato_caratula_prestamo','seguro_unico2','32809|32819','NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_unico','31101|31111|32201|32221|32301|32311|32321|32703|32803','NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_unico1','31121|30901|33001|33002|33003|323|31704|31714|31724','NO APLICA');
               insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','aseguradora_unico2','32809|32819','NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_unico','31101|31111|32201|32221|32301|32311|32321|32703|32803', 'NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_unico1','31121|30901|33001|33002|33003|323|31704|31714|31724', 'NO APLICA');
              insert into tablas (idtabla,idelemento,dato2,dato1)
              values ('formato_caratula_prestamo','clausula_seguro_unico2','32809|32819', 'NO APLICA');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_331234';
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_nomina'; /*like 'numero_contrato_conducef_331234'*/
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','numero_contrato_conducef_nomina','13161-450-034097/01-00208-0121','33101|33201|33301|33401'); /*like 'numero_contrato_conducef_331234'*/

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_caratula_331234';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','nombre_caratula_331234','CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO SIMPLE','33101|33201|33301|33401');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'seguro_331234';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','seguro_331234','33101|33201|33301|33401','No aplica');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'aseguradora_331234';
  insert into tablas (idtabla,idelemento,dato2,dato1) 
    values ('formato_caratula_prestamo','aseguradora_331234','33101|33201|33301|33401','No aplica');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'clausula_seguro_331234';
  insert into tablas (idtabla,idelemento,dato2,dato1) 
    values ('formato_caratula_prestamo','clausula_seguro_331234','33101|33201|33301|33401', 'No aplica');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_comercial331';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','nombre_comercial331','CR&Eacute;DITO N&Oacute;MINA','33101');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_comercial332';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','nombre_comercial332','CR&Eacute;DITO N&Oacute;MINA','33201');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_comercial333';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','nombre_comercial333','CR&Eacute;DITO N&Oacute;MINA','33301');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_comercial334';
  insert into tablas (idtabla,idelemento,dato1,dato2) 
    values ('formato_caratula_prestamo','nombre_comercial334','CR&Eacute;DITO ORDINARIO','33401');

-----------------------------------------------------------------------------------------------------------------------
delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'numero_contrato_conducef_hipoteca';
insert into tablas (idtabla,idelemento,dato1,dato2)
  values ('formato_caratula_prestamo','numero_contrato_conducef_hipoteca','13161-138-034125/01-00257-0121','32703,32803');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'nombre_caratula_hipoteca';
insert into tablas (idtabla,idelemento,dato1,dato2)
  values ('formato_caratula_prestamo','nombre_caratula_hipoteca','CAR&Aacute;TULA DE CR&Eacute;DITO HIPOTECARIO','32703,32803');

update tablas set dato1 = '30705|31505|32301|32311|32321|32401|32605|32615|31704' where idtabla = 'formato_caratula_prestamo' and idelemento = 'seguro_periodicos';
update tablas set dato1 = '31101|31111|32201|32221|32301|32311|32321' where idtabla = 'formato_caratula_prestamo' and idelemento = 'seguro_unico';

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'seguro_hipoteca';
insert into tablas (idtabla,idelemento,dato1,dato2)
  values ('formato_caratula_prestamo','seguro_hipoteca','32703,32803','Seguro de da&ntilde;os a la vivienda');

update tablas set dato2 = '30705|31505|32301|32311|32321|32401|32605|32615|31704' where idtabla = 'formato_caratula_prestamo' and idelemento = 'clausula_seguro_periodicos';
update tablas set dato2 = '31101|31111|32201|32221|32301|32311|32321' where idtabla = 'formato_caratula_prestamo' and idelemento = 'clausula_seguro_unico';

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento like 'clausula_seguro_hipoteca';
insert into tablas (idtabla,idelemento,dato2,dato1)
  values ('formato_caratula_prestamo','clausula_seguro_hipoteca','32703,32803', 'Cuarta');

delete from tablas where idtabla = 'formato_caratula_prestamo' and idelemento = 'nombre_comercial32803' and dato2 = '32803';
insert into tablas (idtabla,idelemento,dato2,dato1)
  values ('formato_caratula_prestamo','nombre_comercial32803','32803', 'CR&Eacute;DITO HIPOTECA 9.1');

update tablas set dato1 = 'CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO SIMPLE' where idtabla='formato_caratula_prestamo' and idelemento='nombre_caratula_universal';
update tablas set dato1 = 'CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO AUTOMOTRIZ' where idtabla='formato_caratula_prestamo' and idelemento='nombre_caratula_auto';
update tablas set dato1 = 'CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO MOTO9' where idtabla='formato_caratula_prestamo' and idelemento='nombre_caratula_moto';



update tablas set tipo = -456 where idtabla = 'param' and idelemento = 'formato_caratula_prestamo';
delete from tablas
where       idtabla = 'param' and idelemento = 'formato_caratula_prestamo';


INSERT INTO tablas
            (idtabla,idelemento,dato1,dato3,dato4,tipo,dato2)
     VALUES ('param','formato_caratula_prestamo',
             'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
             'gnome-open %s.html; sleep 12','rm -rf %s.*',3,
             '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">                                                                                                                                                                                    
       <html xmlns="http://www.w3.org/1999/xhtml">
        <head>                                    
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />                  
            <style type="text/css">               
              .contenedor {                       
                height: 25cm;                     
                width: 19cm;                      
                font-family: Arial, Helvetica, sans-serif;                                       
                font-size: 8pt;border: 1px solid #000;                                           
              }                                   
              .encabezado {                       
                font-size: 10pt;                  
                text-align: right;                
                font-weight:bold;                 
              }                                   
              .alinear_der {                      
                text-align: right;                
              }                                   
              .alinear_izq {                      
                text-align: left;                 
              }                                   
              .borde_total {                      
                border: 1px solid #000;           
              }                                   
              .borde_bajo {                       
                border-bottom-width: 1px;         
                border-bottom-style: solid;       
                order-bottom-color: #000;         
              }                                   
              .borde_der {                        
                border-right-width: 1px;          
                border-right-style: solid;        
                border-right-color: #000;         
              }                                   
              .alinear_top {                      
                vertical-align: top;              
              }                                   
              .alinear_center {                   
                text-align: center;               
              }                                   
              .alinear_left {                     
                text-align: left;                 
              }                                   
              .texto_central {                    
                font-size: 10pt;                  
              }                                   
              .texto_logo {                       
                font-size: 12pt;                  
                font-weight: bold;                
                text-align: left;                 
              }                                   
              .alinear_der {                      
                text-align: right;                
              }                                   
              .borde_inferior_3 {                 
                border-bottom-width: 1px;         
                border-bottom-style: solid;       
                border-bottom-color: #000;        
              }                                   
              .borde_abajo {                      
                border-bottom-width: 1px;         
                border-bottom-style: solid;       
                border-right-color: #000;         
                border-bottom-color: #000;        
                border-left-color: #000;          
                border-top-color: #000;           
              }                                   
              .linea_abajo {                      
                border-bottom-width: 1px;         
                border-bottom-style: solid;       
                border-bottom-color: #000;        
              }                                   
              .borde_izq {                        
                border-left-width: 1px;           
                border-left-style: solid;         
                border-left-color: #000;          
              }                                   
              .borde_completo {                   
                border: 1px solid #000;           
              }                                   
              .texto_top {                        
                vertical-align: top;              
              }                                   
               .negritas_12 {                     
                font-weight: bold;                
                font-size: 12pt;                  
              }                                   
                                                  
             </style>                             
            <script type="text/javascript">       
                                                  
                window.onload = function seccion() {                                             
                var Fecha_limite_pago = document.getElementById("Fecha_limite_pago");            
                var Fecha_corte = document.getElementById("Fecha_corte");                        
                var comisiones=document.getElementById("comisiones");                            
                var advertencia=document.getElementById("advertencia");                          
                var plazo=document.getElementById("plaz");                                       
                                                  
                                                  
                if (@@idproducto@@ == 32005) {    
                Fecha_corte.innerHTML =  " @@siguiente_pago_dia@@ ";                             
                Fecha_corte.innerHTML = " ultimo de cada mes calendario.";                       
                Fecha_limite_pago.innerHTML = " @@siguiente_pago_dia@@ de cada mes.";            
                }                                 
                                                  
                if(@@idproducto@@==32102 || @@idproducto@@==31902) {                             
                 var t1=document.getElementById("txt1");                                         
                 var t2=document.getElementById("txt2");                                         
                 t1.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                         
                 Fecha_corte.innerHTML=" @@siguiente_pago@@";                                    
                 t2.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                         
                 comisiones.innerHTML ="ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";        
                   advertencia.innerHTML="Advertencia: En caso de no contratar el seguro de auto se cancelarÃ\u0083Â¡ el crÃ\u0083Â©dito.";                                                                                                                                                                         
                 }                                
                                                  
               if((@@idproducto@@==32301 || @@idproducto@@==32201 || @@idproducto@@==32221 || @@idproducto@@==32311 || @@idproducto@@==32321 || @@idproducto@@==32703 ||
                   @@idproducto@@==31714 || @@idproducto@@==31704 || @@idproducto@@==31724 || @@idproducto@@==32809 || @@idproducto@@==32819 || @@idproducto@@==31101 ||
                   @@idproducto@@==31111 || @@idproducto@@==31121 || @@idproducto@@==30901 || @@idproducto@@==33001 || @@idproducto@@==33002 || @@idproducto@@==33003 ||
                   @@idproducto@@==32803) && @@plazo@@==1){                                      
                  var sg=document.getElementById("segob");                                       
                 Fecha_corte.innerHTML=" @@siguiente_pago@@";                                    
                 comisiones.innerHTML ="ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";        
                 sg.innerHTML="@@seguro@@";       
                 advertencia.innerHTML=" ";       
               }/*Pagos unicos*/                  
               else if(                           
                 @@idproducto@@==32301 || @@idproducto@@==32311 || @@idproducto@@==32321 || @@idproducto@@==32401 || @@idproducto@@==32605 || @@idproducto@@==32615 || @@idproducto@@==32703 ||
                 @@idproducto@@==31704 || @@idproducto@@==31714 || @@idproducto@@==31724 || @@idproducto@@==32809 || @@idproducto@@==30825 || @@idproducto@@==30705 || @@idproducto@@==31505 ||
                 @@idproducto@@==31501 || @@idproducto@@==33001 || @@idproducto@@==33002 || @@idproducto@@==33003 || @@idproducto@@==32803 || @@idproducto@@==32819){                                                                                                                                               
                 var t1=document.getElementById("txt1");                                         
                 var t2=document.getElementById("txt2");                                         
                 var sg=document.getElementById("segob");                                        
                 Fecha_corte.innerHTML=" @@siguiente_pago@@";                                    
                 t1.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                         
                 t2.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                         
                 comisiones.innerHTML ="ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";        
                 sg.innerHTML="@@seguro@@";       
                                                  
               }/*Pagos periodicos*/              
                                                  
               if (@@idproducto@@==33101 || @@idproducto@@==33201 || @@idproducto@@==33301 || @@idproducto@@==33401) {                                                                                                                                                                                              
                 var t1=document.getElementById("txt1");                                         
                 var t2=document.getElementById("txt2");                                         
                 var t3=document.getElementById("sele");                                         
                 var t4=document.getElementById("adv3");                                         
                 var tasa=document.getElementById("tasa");                                       
                                                  
                 Fecha_corte.innerHTML = " @@siguiente_pago@@";                                  
                 t1.innerHTML = " y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                       
                 t2.innerHTML = " y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                                                                                                                                                                                                       
                 comisiones.innerHTML = "ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";       
                 plazo.innerHTML = "semanas";     
                 t3.innerHTML = " ";              
                 t4.innerHTML = " ";              
                 tasa.innerHTML="<b>Sin IVA para fines Informativos y de comparacion. @@cat1@@%</b>";                                                                                                                                                                                                               
               }                                  
                                                  
               if (@@idproducto@@==32201 || @@idproducto@@==32221 || @@idproducto@@==32301 || @@idproducto@@==32311 || @@idproducto@@==32401) {                                                                                                                                                                     
                 var t3=document.getElementById("sele");                                         
                                                  
                 t3.innerHTML = " ";              
               }                                  
       //1-MODIFICACION DANIEL              
                   if(@@idproducto@@==30805 || @@idproducto@@ == 30815 ||  @@idproducto@@==30825){
                   var t1=document.getElementById("txt1");                                       
                   var t2=document.getElementById("txt2");                                       
                   var sg=document.getElementById("segob");                                      
                   var tasa=document.getElementById("tasa");                                     
                   var creditos=document.getElementById("creditos");                             
                   var calle=document.getElementById("calle");                                   
                   var lopez=document.getElementById("lopez");                                   
                   var nombre=document.getElementById("nombre");                                 
                   var juarez=document.getElementById("juarez");                                 
                   var limite=document.getElementById("limite");                                 
                   var t3=document.getElementById("sele");                                       
                   var respondera =document.getElementById("respondera");                        
                                                  
                   Fecha_corte.innerHTML=" @@siguiente_pago@@";                                  
                   t1.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                   
                   t2.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";
                   creditos.innerHTML="cr&eacute;ditos";                                         
                   calle.innerHTML="Ju&aacute;rez N&uacute;mero";                              
                   lopez.innerHTML="L&oacute;pez";
                   nombre.innerHTML="CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO SIMPLE";     
                   t3.innerHTML = " ";            
                   respondera.innerHTML="responder&aacute;";                                                                                                              
                   comisiones.innerHTML ="ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";      
                   juarez.innerHTML ="JU&Aacute;REZ N&#186";                                     
                   limite.innerHTML ="L&iacute;mite";                                            
                   sg.innerHTML="@@seguro@@";     
                   tasa.innerHTML="<b>Sin IVA para fines Informativos y de comparaci&oacute;n. </b> @@cat1@@%";
                                   
                 }     
            //2-MODIFICACION DANIEL 21/03/2023
                 if(@@idproducto@@==30705 || @@idproducto@@==32005 || @@idproducto@@==32015 || @@idproducto@@==32025 || @@idproducto@@==33001 || @@idproducto@@==33002 ||
                    @@idproducto@@==33003 || @@idproducto@@==33012 || @@idproducto@@==33011 || @@idproducto@@==33013){
                   var tasa1=document.getElementById("tasa1");
                   var t1=document.getElementById("txt1");                                       
                   var t2=document.getElementById("txt2");                                       
                   var sg=document.getElementById("segob");                                      
                   var creditos=document.getElementById("creditos");                             
                   var calle=document.getElementById("calle");                                   
                   var lopez=document.getElementById("lopez");                                   
                   var nombre=document.getElementById("nombre");                                 
                   var juarez=document.getElementById("juarez");                                 
                   var limite=document.getElementById("limite");                                 
                   var t3=document.getElementById("sele");                                       
                   var respondera =document.getElementById("respondera");                        
                                                  
                   Fecha_corte.innerHTML=" @@siguiente_pago@@";                                  
                   t1.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";                   
                   t2.innerHTML=" y las fechas subsecuentes se encuentran en el reporte de pagos de socios anexo.";
                   creditos.innerHTML="cr&eacute;ditos";                                         
                   calle.innerHTML="Ju&aacute;rez N&uacute;mero";                              
                   lopez.innerHTML="L&oacute;pez";
                   nombre.innerHTML="CAR&Aacute;TULA DEL CONTRATO DE CR&Eacute;DITO SIMPLE";     
                   t3.innerHTML = " ";            
                   respondera.innerHTML="responder&aacute;";                                                                                                              
                   comisiones.innerHTML ="ESTE PRODUCTO NO GENERA NINGUNA COMISI&Oacute;N";      
                   juarez.innerHTML ="JU&Aacute;REZ N&#186";                                     
                   limite.innerHTML ="L&iacute;mite";                                            
                   sg.innerHTML="@@seguro@@";     

                  tasa1.innerHTML="<b><strong>@@cat1@@%<strong></b>";

                 }
            //2-FIN

       //1-FIN                                    
                                                  
               if (@@idproducto@@==33201) { plazo.innerHTML = "catorcenas"; }                    
               if (@@idproducto@@==33301) { plazo.innerHTML = "quincenas"; }                     
               if (@@idproducto@@==33401) { plazo.innerHTML = "meses"; }                         
             };                                   
          </script>                               
       </head>                                    
       <body>                                     
        <div class="contenedor">                  
          <table width="100%" border="0" cellspacing="0" cellpadding="0">                        
            <tr>                                  
              <td width="30%" class="borde_bajo"> 
                <center>                          
                <img src="/usr/local/saicoop/imagenes/logo_9agosto.png" width="170" height="90" alt="logo" />                                                                                                                                                                                                       
                </center>                         
              </td>                               
              <td colspan="2" class="encabezado borde_bajo">                                     
               <p align="left">                   
               CAJA POPULAR 9 DE AGOSTO SALAMANCA <br> S.C. DE A.P. DE R.L. DE C.V.<br>          
               CALLE <a id="juarez">JU&Aacute;REZ No.</a> 408, ZONA CENTRO, SALAMANCA, GUANAJUATO. RFC: CPN890928HV0<br>                                                                                                                                                                                                   
               </p>                               
               RECA @@numero_contrato_condusef@@  
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="3" class="borde_abajo alinear_center encabezado" height="10px">       
              <a id="nombre">@@nombre_caratula@@</a>                                             
              </td>                               
            </tr>                                 
          </table>                                
          <table class="texto_central" width="100%" border="0" cellspacing="0" cellpadding="0">  
            <tr>                                  
              <td colspan="4">                    
                <b>Nombre comercial del Producto:</b> &nbsp; @@nombre_comercial@@ <br />         
                <b>Tipo de Operaci&oacute;n:</b> ACTIVA                                          
              </td>                               
            </tr>                                 
              <!--                                
              <tr>                                
              <td><b>Tipo de Cr&eacute;dito:</b> </td>                                           
              <td colspan="3">&nbsp; @@tipo_credito@@ </td>                                      
              </tr>                               
              -->                                 
            <tr>                                  
              <td colspan="4" class="borde_abajo">&nbsp;</td>                                    
            </tr>                                 
            <tr>                                  
              <td width="30%" class="linea_abajo">
                <center><b> CAT <br/>(COSTO ANUAL TOTAL) </b></center>                           
              </td>                               
              <td width="25%" class="borde_izq linea_abajo">                                     
                <center><b> TASA DE INTER&Eacute;S ANUAL FIJA </b></center>                      
              </td>                               
              <td width="21%" class="borde_izq linea_abajo">                                     
                <center><b> MONTO O L&Iacute;NEA DE CR&Eacute;DITO </b></center>                 
              </td>                               
              <td width="24%" class="borde_izq linea_abajo">                                     
                <center><b> MONTO TOTAL A PAGAR O M&Iacute;NIMO A PAGAR</b></center>             
              </td>                               
            </tr>                                 
            <tr>                                  
              <td ><b> Sin IVA para fines Informativos y de comparaci&oacute;n. </b> <a id="tasa1"><strong>@@cat1@@%</strong></a> </td>                                                                                                                                                                                                              
              <td class="borde_izq">              
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                  
            <tr>                                  
              <td width="50%" class="alinear_izq negritas_12">                                   
                <b class="texto_central">Ordinaria: </b>@@io_anual@@ %  <br />                   
                <b class="texto_central"> Moratoria: </b>@@im_anual@@ %                          
              </td>                               
            </tr>                                 
                </table>                          
              </td>                               
              <td class="borde_izq"><center> $ @@monto_credito_formato@@ </center></td>          
              <td class="borde_izq "><center> $ @@monto_pagar@@ </center></td>                   
            </tr>                                 
            <tr>                                  
              <td class="borde_abajo">&nbsp;  </td>                                              
              <td class="borde_abajo borde_izq">&nbsp;  </td>                                    
              <td class="borde_abajo borde_izq">&nbsp;  </td>                                    
              <td class="borde_abajo borde_izq">&nbsp;  </td>                                    
            </tr>                                 
            <tr>                                  
              <td width="30%" class="texto_top borde_abajo">                                     
                <b> PLAZO DEL CR&Eacute;DITO: <br/> @@9ago_plazo@@ <a id="plaz">@@9ago_termino_plazo@@</a> </b>                                                                                                                                                                                                     
              </td>                               
              <td colspan="3" class="borde_izq borde_abajo">                                     
                <b> Fecha <a id="limite">L&iacute;mite</a> de Pago:</b><a id="Fecha_limite_pago"> @@siguiente_pago@@</a><a id="txt1"> </a><br/>                                                                                                                                                                            
                <b> Fecha de Corte:</b><a id="Fecha_corte"> 30 de cada mes calendario</a><a id="txt2"> </a>                                                                                                                                                                                                         
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="alinear_center encabezado borde_abajo"> COMISIONES RELEVANTES </td>                                                                                                                                                                                                            
            </tr>                                 
            <tr>                                  
              <td id="comisiones" colspan="4" class="borde_abajo">                               
                <center>                          
                  <ul>                            
                    <table width="90%">           
                      <tr>                        
                        <td width="50%"><li>Apertura:&nbsp;&nbsp; No Aplica</li></td>            
                        <td width="50%">          
                          <li>Reposici&oacute;n de tarjeta:&nbsp;&nbsp; No Aplica</li>           
                        </td>                     
                      </tr>                       
                      <tr>                        
                        <td><li>Anualidad:&nbsp;&nbsp; No Aplica</li></td>                       
                        <td><li>Reclamaci&oacute;n Improcedente:&nbsp;&nbsp; No Aplica</li></td> 
                      </tr>                       
                      <tr>                        
                        <td><li>Prepago:&nbsp;&nbsp; No Aplica</li></td>                         
              <!--  <td><li>Cobranza:&nbsp;&nbsp; No Aplica</li></td> -->                        
                      </tr>                       
                      <tr>                        
                        <td><li>Pago Tard&iacute;o (Mora):&nbsp;&nbsp;36 % Anual</li></td>       
                        <td>&nbsp;</td>           
                      </tr>                       
                    </table>                      
                  </ul>                           
              </center>                           
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="alinear_center encabezado borde_abajo"> ADVERTENCIAS </td>  
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="borde_abajo">
              "Incumplir tus obligaciones te puede generar comisiones e intereses moratorios".   
                <br />                            
                "Contratar <a id="creditos">creditos</a> por arriba de tu capacidad de pago puede afectar tu historial                                                                                                                                                                                              
                crediticio".                      
                <br />                            
                <a id="adv3">"El avalista, obligado solidario o coacreditado <a id="respondera">responder&aacute;</a> como obligado principal                                                                                                                                                                              
                frente a la Entidad Financiera".</a>                                             
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="alinear_center encabezado borde_abajo"> <b> SEGUROS </b> </td>                                                                                                                                                                                                                 
            </tr>                                 
            <tr>                                  
              <td colspan="4">                    
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                  
                  <tr>                            
                    <td width="35%" class="borde_abajo" style="vertical-align: text-top;">       
                      <b>SEGURO:</b><a id="segob"> @@seguro@@ </a> <a id="sele"></a>
                    </td>                         
                    <td width="30%" class="borde_izq borde_abajo">                               
                      <b>ASEGURADORA:</b> @@aseguradora@@                                        
                    </td>                         
                    <td width="30%" class="borde_izq borde_abajo" style="vertical-align: text-top;">                                                                                                                                                                                                                
                      <b>CL&Aacute;USULA:</b> @@clausula_seguro@@<a id="advertencia"></a></td>   
                  </tr>                           
               </table>                           
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="alinear_center encabezado borde_abajo"><b>ESTADO DE CUENTA</b></td>                                                                                                                                                                                                            
            </tr>                                 
            <tr>                                  
              <td width="20%" class="alinear_der borde_abajo"> Entregar En sucursal &nbsp; </td> 
              <td width="6%" class="borde_abajo"> <input type="checkbox"  checked disabled> </td>
              <td colspan="2" class="borde_abajo">&nbsp; </td>                                   
              <!--                                
              <td width="20%" class="alinear_der borde_abajo"> Envio por Mensajeria &nbsp; </td> 
              <td width="6%" class="borde_abajo"> <input type="checkbox" disabled> </td> -->     
            </tr>                                 
            <tr>                                  
              <!-- ACLARACIONES Y RECLAMACIONES -->                                              
              <td colspan="4"> <b> Aclaraciones y reclamaciones: </b> </td>                      
            </tr>                                 
            <tr>                                  
              <td colspan="4"> Unidad Especializada de Atenci&oacute;n a Usuarios: </td>         
            </tr>                                 
            <tr>                                  
              <td colspan="4"> Domicilio:Calle <a id="calle">Ju&aacute;rez N&uacute;mero</a> 408, Col. Zona Centro en Salamanca,Guanajuato.</td>                                                                                                                                                                                  
            </tr>                                 
            <tr>                                  
              <td width="42%" colspan="2"> Tel&eacute;fono: 464-647-17-10 y 464-647-1096 ext. 127</td>                                                                                                                                                                                                              
              <td width="18%"> Correo  electr&oacute;nico: </td>                                 
              <td width="40%"> une@9deagosto.com</td>                                            
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="borde_abajo">  <br>                                         
              <center>Horario de Atenci&oacute;n: Lunes a viernes 9:00 am A 5:00 pm y S&aacute;bados de  9:00 am A 2:00 pm                                                                                                                                                                                          
              <br />                              
              P&aacute;gina de Internet: www.9deagosto.com</td> </center>                        
            </tr>                                 
            <tr>                                  
              <!-- REGISTRO DE CONTRATOS DE ADHESION NUM -->                                     
              <td colspan="4">                    
                <b>Registro de Contrato de Adhesi&oacute;n N&uacute;mero: @@numero_contrato_condusef@@ </b>                                                                                                                                                                                                         
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4">                    
                Comisi&oacute;n Nacional para la Protecci&oacute;n y  Defensa de los Usuarios de Servicios                                                                                                                                                                                                          
                Financieros (CONDUSEF):           
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="2" class="borde_abajo">
                Lada sin costo: 800 999 8080<br />  En el Distrito Federal: 55 53 40 09 99.      
              </td>                               
              <td colspan="2" class="borde_abajo">
                P&aacute;gina de internet:  www.condusef.gob.mx                                  
              </td>                               
            </tr>                                 
            <tr>                                  
              <td colspan="4" class="borde_abajo">&nbsp; </td>                                   
            </tr>                                 
            <tr>                                  
              <td colspan="4">&nbsp;</td>         
            </tr>                                 
            <tr>                                  
              <td colspan="4">                    
               <table width="100%" border="0" cellspacing="8" cellpadding="3">                   
                <tr>                              
                  <td colspan="3"><center>La Caja Popular</center></td>                          
                        <td colspan="3">     <center> @@nombre_socio@@ </center> </td>           
                </tr>                             
                <tr>                              
                  <td width="10%">&nbsp;</td>     
                    <th width="30%" height="10px" class="borde_bajo">                            
                      <img src="/usr/local/saicoop/imagenes/firmaapoderado.bmp" width="60" height="50" />                                                                                                                                                                                                           
                    </th>                         
                  <td width="10%">&nbsp;</td>     
                  <td width="10%">&nbsp;</td>     
                    <th width="30%" height="10px" class="borde_bajo">&nbsp;</th>                 
                      <td width="10%">&nbsp;</td> 
                </tr>                             
                <tr>                              
                  <td colspan="3">                
                    <center>C.P Manuel Ortiz <a id="lopez">L&oacute;pez</a><br />                       
                      Nombre y Firma del Representante Legal.                                    
                    </center>                     
                  </td>                           
                  <td colspan="3">                
                    <center>Nombre y firma de El Acreditado</center> </td>                       
                  </td>                           
                </tr>                             
              </table>                            
              </td>                               
              </tr>                               
              </table>                            
              </div>                              
       </body>                                    
       </html>      
                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
');
