/*reporte especial de la cartera de credito vigente de la Sociedad, con los siguientes datos:
--Origen Apertura, 
--Origen Socio, 
--Numero de Socio, 
--Nombre, 
--Producto, 
--Domicilio,
--Colonia, 
--Municipio, 
--Numero de Contrato, 
--Monto prestado, 
--Fecha de activacion,
Fecha de Vencimiento, 
--Tasa, 
--Plazo, 
Avales, 
Garantia hipotecaria o prendaria, 
Al cierre del mes de Febrero del presente ano, la finalidad de la peticion*/

select 
a.idorigenp as origen_apertura,
a.idorigen  as origen_socio,
a.idsocio   as numero_socio,
nombre_x(p.appaterno,p.apmaterno,p.nombre) as nombre_socio,
a.idproducto as producto, col.nombre as colonia, 
COALESCE(NULLIF(TRIM(p.calle), ''), 'nd') as calle, 
COALESCE(NULLIF(TRIM(p.numeroext), ''), 'nd') as num_ext,
COALESCE(NULLIF(TRIM(p.numeroint), ''), 'nd') as num_int,
COALESCE(NULLIF(TRIM(p.entrecalles), ''), 'nd') as entrecalles, 
col.nombre as colonia, mun.nombre as municipio,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar as folio_producto,
a.montoprestado as mnt_prstd, a.fechaactivacion as f_activa,
a.tasaio as tasa_io, a.tasaim as tasa_im, a.plazo as plazo, a.garantia
from auxiliares as a 
inner join personas as p on a.idorigen = p.idorigen and a.idgrupo = p.idgrupo and a.idsocio = p.idsocio
inner join colonias as col on col.idcolonia = p.idcolonia
inner join municipios as mun on col.idmunicipio = mun.idmunicipio
inner join productos as pr on a.idproducto = pr.idproducto
where a.estatus = 2 --esatus activo
and pr.tipoproducto = 2 --tipo credito
;