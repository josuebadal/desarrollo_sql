-----DATOS QUE OCUPO PARA VALIDAR EL FORMATO EN ENERO ----- 
igdorigen           | 31004
idgrupo            | 10
idsocio            | 4851
idorigenp          | 31004
idproducto         | 31602
idauxiliar         | 2898


-----DATOS QUE OCUPO PARA VALIDAR EL FORMATO EN DICIEMBRE ----- 
idorigenp  | 31002
idgrupo    | 10
idsocio    | 5086
idorigenp  | 31002
idproducto | 30102
idauxiliar | 2242

SELECT idtabla,idelemento,dato1,dato3,dato4,dato5,tipo FROM tablas 
WHERE (LOWER(idtabla)='texto_contratos' 
OR LOWER(idtabla)='texto_html_contratos') 
AND idelemento='contrato_anexo2_creditos';

idtabla    | texto_html_contratos
idelemento | contrato_anexo2_creditos
dato1      | iconv %s -f iso-8859-1 -t utf-8 -o %s.html
dato3      | gnome-open %s.html; sleep 100
dato4      | rm -rf %s.*
dato5      | 
tipo       | 3

-----EL TIPO ES 3 POR LO CUAL NO DEJA EDITAR SE DEBE APLICAR UN UPDATE A ESE TIPO CON EL -456
update tablas 
set tipo = -456 
where idtabla = 'texto_html_contratos' 
and idelemento = 'contrato_anexo2_creditos';


update tablas 
set tipo = 3 
where idtabla = 'texto_html_contratos' 
and idelemento = 'contrato_anexo2_creditos';




