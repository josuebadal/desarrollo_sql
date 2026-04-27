/* DATOS PARA PRUEBA
idorigen | 30501
idgrupo  | 10
idsocio  | 117049
PRODUCTO 101
certificado_101
formato_certificados*/

       idtabla       |          idelemento          
---------------------+------------------------------




   SELECT idtabla,idelemento FROM tablas WHERE UPPER(idtabla) LIKE UPPER('%certificado%') OR UPPER(idelemento) LIKE UPPER('%certificado%') GROUP BY idtabla,idelemento ORDER BY idtabla,idelemento

   SELECT idtabla,idelemento FROM tablas WHERE UPPER(idtabla) LIKE UPPER('%certificado%') OR UPPER(idelemento) LIKE UPPER('%certificado%') GROUP BY idtabla,idelemento ORDER BY idtabla,idelemento

   SELECT dato1 FROM tablas WHERE LOWER(idtabla)='formato_certificado' AND LOWER(idelemento)='producto_para_certificado'

   SELECT * FROM requisitos WHERE idrequisito = 710


   SELECT m.nombre FROM origenes o INNER JOIN municipios m USING(idmunicipio) WHERE o.idorigen = 30550 

   SELECT REPLACE(dato2,'|',',') FROM tablas WHERE LOWER(idtabla)='formato_certificado' AND LOWER(idelemento)='producto_para_certificado'

   select count(*) from tablas where lower(idtabla) = 'formato_certificado' and lower(idelemento) = 'grabar_numero_de_folio' and dato1 = '1'

   select sai_bitacora_accesos_entrada ('OP253',999)

   SELECT p.*,INT4(EXTRACT(YEAR FROM AGE(p.fechanacimiento))) AS edad,c.nombre AS c_nom,m.nombre AS m_nom,e.nombre AS e_nom,m.idmunicipio AS m_id FROM personas AS p INNER JOIN colonias c ON p.idcolonia = c.idcolonia INNER JOIN municipios m ON c.idmunicipio = m.idmunicipio INNER JOIN estados e ON m.idestado = e.idestado WHERE p.idorigen = 30501 AND p.idgrupo = 10 AND p.idsocio = 117049 

   SELECT appaterno,apmaterno,personas.nombre,calle,estatus,numeroext,numeroint,colonias.nombre as colonia,colonias.codigopostal,entrecalles,municipios.nombre as municipio,estados.nombre as estado,razon_social,categoria, nivel_riesgo, fechanacimiento, int4(extract(year from age(fechanacimiento))) as edad, email,celular,telefono,telefonorecados,curp,rfc FROM   personas, colonias, municipios, estados WHERE  idorigen=30501 AND idgrupo=10 AND idsocio=117049 AND colonias.idcolonia=personas.idcolonia AND municipios.idmunicipio=colonias.idmunicipio AND estados.idestado=municipios.idestado
DEBUG_DB: Function:
   select sai_obliga_exista_datos_personales (30501,10,117049)
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'aviso_cumplimiento_edad' limit  1
DEBUG_DB: Query:
   select case when (72 - dato1::integer) >= 0 then '                    * * * * *   A V I S O   * * * * *

LA PERSONA HA REBASADO LA EDAD MAXIMA PERMITIDA DE '||dato1||' A?S PARA ESTE GRUPO (10)
SEGUN SU FECHA DE NACIMENTO ESTABLECIDA, TIENE 72 A?S DE EDAD' when (72 - dato1::integer) = -1 and (date(date('31/12/1953')+(dato1||' years')::interval)-date('31/03/2026')) <= dato3::integer then case when dato2 is NULL or trim(dato2) = '' then 'LA PERSONA ESTA A PUNTO DE REBASAR LA EDAD MAXIMA PERMITIDA DE '||dato1||' A?S PARA ESTE GRUPO (10)

                         >>>>>>>>>>  SOLO FALTAN '||(date(date('31/12/1953')+(dato1||' years')::interval)-date('31/03/2026'))::text||' DIAS  <<<<<<<<<<' else replace(replace(replace(replace(upper(dato2),upper('$dias$'),(date(date('31/12/1953')+(dato1||' years')::interval)-date('31/03/2026'))::text),upper('$grupo$'),'10'),upper('$edad$'),'72'),upper('$edadmax$'),dato1) end else NULL end as mensaje from   tablas where  idtabla = 'aviso_cumplimiento_edad' and idelemento::integer = 10 and (72 - dato1::integer) >= -1 
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'listas_personas_bloq_forzoso' and case when dato1 is not NULL and dato1 = '1' then 1 else 0 end = 1
DEBUG_DB: Query:
   select s.*, p.nombre, p.appaterno, p.apmaterno, p.fechanacimiento, p.rfc, p.curp from   sopar as s inner join personas as p using(idorigen,idgrupo,idsocio) where  s.tipo = 'lista_personas_bloqueadas_cnbv' and (p.nombre,p.appaterno,p.apmaterno) = ('BERTHA','CARMONA','HERRERA') limit  1
DEBUG_DB: Query:
   select case when dato1 is NULL or dato1 = '' then '0' else dato1 end as dato1, case when dato2 is NULL or dato2 = '' then '0' else dato2 end as dato2, case when dato3 is NULL or dato3 = '' then '0' else dato3 end as dato3, case when dato4 is NULL or dato4 = '' then '0' else dato4 end as dato4 from   tablas where  idtabla = 'param' and idelemento = 'verificacion_datos_personales' 

DEBUG_DB: Query:
   select    case when date('31/03/2026') >= (date(fecha) + 180) then 1 else 0 end as actualizar_ya,date('31/03/2026') - date(fecha) as dias_desde from      verificacion_datos_personales where     idorigen = 30501 and idgrupo = 10 and idsocio = 117049 order by  fecha desc limit     1

   SELECT p.*,INT4(EXTRACT(YEAR FROM AGE(p.fechanacimiento))) AS edad,c.nombre AS c_nom,m.nombre AS m_nom,e.nombre AS e_nom,m.idmunicipio AS m_id FROM personas AS p INNER JOIN colonias c ON p.idcolonia = c.idcolonia INNER JOIN municipios m ON c.idmunicipio = m.idmunicipio INNER JOIN estados e ON m.idestado = e.idestado WHERE p.idorigen = 30501 AND p.idgrupo = 10 AND p.idsocio = 117049 
   
DEBUG_DB: Function:
   SELECT descripcion FROM catalogo_menus WHERE opcion = 1 AND LOWER(menu) = 'estadocivil'
Message: valida_ogs_categoria...
DEBUG_DB: Query:
   select * from   tablas where  idtabla = 'nivel_riesgo_lavado' and idelemento = '1' and trim(dato5) = '1'
DEBUG_DB: Query:
   select * from   sopar where  idusuario = 999 and lower(tipo) like 'cuentas_asignadas_a_despacho_externo' and idorigen = 30501 and idgrupo = 10 and idsocio = 117049


   (SELECT idproducto,idorigenp,idauxiliar,fechaape,saldo,io,(saldo + io)::numeric, estatus FROM auxiliares WHERE idorigen=30501 AND idgrupo=10 AND idsocio=117049 AND idproducto IN (101,103) AND estatus=2) UNION (SELECT idproducto,idorigenp,idauxiliar,fechaape,saldo,io,(saldo + io)::numeric, estatus FROM auxiliares_ext WHERE idorigen=30501 AND idgrupo=10 AND idsocio=117049 AND idproducto IN (101,103) AND estatus=2) ORDER BY fechaape DESC, idproducto,idorigenp,idauxiliar DESC LIMIT 30


   SELECT * FROM auxiliares WHERE idorigen=30501 AND idgrupo=10 AND idsocio=117049 AND idorigenp=30501 AND idproducto=101 AND idauxiliar=7032 AND estatus=2
Message: FORMATO DEVUELTO : certificado_101
Message: --> LINEAS POR PAGINA : 59
Message: Forma : certificado_101
Message: sai_forma_end...
Message: comando: (null)
Message: Comando de impresion : (null)
Message: Formato : certificado_101
Message: Imagen de la pagina 1 : /home/sistemas/Proyecto_SAICoop/SAICoop/glade/abcdef

