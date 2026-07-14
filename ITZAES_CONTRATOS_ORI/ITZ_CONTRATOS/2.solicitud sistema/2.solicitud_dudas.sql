favor de validar generando los documentos con lo siguiente
OPA:  31004-30402-9963
OGS:  31004-10-4747

-----SE DEBE CREAR ESTOS ELEMENTOS EN CASO DE NO EXISTIR
select * from tablas where idtabla = 'param'
AND idelemento= 'productos_sol_prestamo_html'
order by idelemento desc;

idtabla    | param
idelemento | productos_sol_prestamo_html
nombre     | 
dato1      | 
dato2      | 30102|30112|30122|30202|30212|30222|31802|31812|31822|32602|32612|32702|32712|32802|30402
dato3      | 
dato4      | 
dato5      | 0
tipo       | 0

INSERT INTO tablas (idtabla,idelemento,nombre,dato2,dato5,tipo) 
VALUES ('param',
        'productos_sol_prestamo_html',
        'Ligar Productos a Solicitud',
        '30402',0,0
        );






select idtabla,idelemento from tablas where  LOWER(idelemento) LIKE'%html%'
order by idelemento desc;

select * from tablas where idtabla = 'param' and idelemento = 'solicitud_prestamo_html';


SELECT idtabla,idelemento,nombre,dato1,dato3,dato4,dato5,tipo  FROM tablas where idelemento = 'solicitud_prestamo_html';

-----DONDE ESTA EL HTML?
dtabla    | param
idelemento | solicitud_prestamo_html

idtabla    | param
idelemento | solicitud_prestamo_html
-[ RECORD 2 ]---------------------------
idtabla    | param
idelemento | querys_en_html
-[ RECORD 3 ]---------------------------
idtabla    | param
idelemento | productos_sol_prestamo_html

-----PODER EDITAR EL HTML DE LA SOLICITUD DE CREDITOS SE PONE -456 para poder hacer UPDATE
update tablas 
set tipo = -456 
where lower(idtabla) 
like 'param' 
and lower(idelemento) like '%solicitud_prestamo_html%';

-----SE REALIZA UPDATE CON EL PARAMETRO DESEADO
update tablas 
set tipo = 0 
where lower(idtabla) 
like 'param' 
and lower(idelemento) like '%solicitud_prestamo_html%';

idtabla    | param
idelemento | solicitud_prestamo_html
dato1      | iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html
dato3      | gnome-open %s.html; sleep 7
dato4      | rm -rf %s.*
dato5      | 0

INSERT INTO tablas (idtabla,idelemento,nombre,
dato1,dato3,dato4,tipo) 
VALUES ('param',
        'solicitud_prestamo_html',
        'Formato Solicitud De Credito',
        'iconv %s -f ISO-8859-1 -t UTF-8 -o %s.html',
        'gnome-open %s.html; sleep 7',
        'rm -rf %s.*',0)
;
















DEBUG_DB: Function:
   SELECT COUNT(*) FROM v_auxiliares WHERE idorigenp=31002 AND idproducto=30402 AND idauxiliar=16975
DEBUG_DB: Function:
   SELECT COUNT(*) FROM tablas WHERE LOWER(idtabla)='param' AND LOWER(idelemento)='productos_sol_prestamo_html' AND dato2 LIKE '%30402%'
Message: activa_desactiva_widgets_solprestamo
Message: Forma : solprestamo_30402
DEBUG_DB: Function:
   SELECT DATE(DATE(DATE('31/10/2025') + INT4(0)) + '10 MONTH'::INTERVAL)
DEBUG_DB: Query:
   select p.*, p.estadocivil as edocivil, c.nombre as c_nombre, m.nombre as m_nombre,e.nombre as e_nombre,p.estatus as p_est,int4(extract(year from age(p.fechanacimiento))) as edad,(case when p.fechaciudad is NOT NULL then text(extract(year from AGE(p.fechaciudad))) else '' end) as tiempociudad from personas p inner join colonias c on(c.idcolonia=p.idcolonia) inner join municipios m on(m.idmunicipio=c.idmunicipio) inner join estados e on(e.idestado=m.idestado) where p.idorigen = 31001 and p.idgrupo = 10 and p.idsocio = 3190 
DEBUG_DB: Query:
   select p.*, p.estadocivil as edocivil, c.nombre as c_nombre, m.nombre as m_nombre,e.nombre as e_nombre,p.estatus as p_est,int4(extract(year from age(p.fechanacimiento))) as edad,(case when p.fechaciudad is NOT NULL then text(extract(year from AGE(p.fechaciudad))) else '' end) as tiempociudad from personas p inner join colonias c on(c.idcolonia=p.idcolonia) inner join municipios m on(m.idmunicipio=c.idmunicipio) inner join estados e on(e.idestado=m.idestado) where p.idorigen = 31001 and p.idgrupo = 10 and p.idsocio = 5328 
DEBUG_DB: Query:
   SELECT idorigenr,idgrupor,idsocior,tiporeferencia FROM referencias WHERE idorigen=31001 AND idgrupo=10 AND idsocio=6310 AND tiporeferencia IN (6,7,9,11,12,13,14,15,16,17,18,19,20,21)
DEBUG_DB: Query:
   select p.*, p.estadocivil AS edocivil, c.nombre AS c_nombre,m.nombre AS m_nombre,e.nombre AS e_nombre,p.estatus AS p_est,int4(extract(year from age(p.fechanacimiento))) AS edad,(case when p.fechaciudad is NOT NULL then text(extract(year from age(p.fechaciudad))) else '' end) as tiempociudad from personas p inner join colonias as c on(c.idcolonia=p.idcolonia) inner join municipios as m on (m.idmunicipio=c.idmunicipio) inner join estados as e on (e.idestado=m.idestado) where p.idorigen = 31001 and p.idgrupo = 10 and p.idsocio = 5328
DEBUG_DB: Function:
   SELECT TRIM(to_char(idorigenp,'099999'))||'-'||TRIM(to_char(idproducto,'09999'))||'-'||TRIM(to_char(idauxiliar,'09999999')) FROM auxiliares WHERE idorigenp = 31002 AND idauxiliar = 16975 AND idproducto =30402
Message: sai_forma_end...
Message: comando: (null)
Message: Comando de impresion : (null)
Message: Formato : solprestamo_30402
Message: Imagen de la pagina 1 : /home/jjbadal/Proyecto_SAICoop/SAICoop/glade/abcdef
Message: Imagen de la pagina 2 : /home/jjbadal/Proyecto_SAICoop/SAICoop/glade/abcdef