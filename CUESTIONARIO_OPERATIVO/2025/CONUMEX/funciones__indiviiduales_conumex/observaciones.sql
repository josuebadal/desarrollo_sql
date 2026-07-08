A1
Solo salen 6 de 20 peps
R: Se envia el listado de PPE 

A2
En ACTIVIDAD ECONOMICA filtrando por el 15 pep corresponde a los 6 peps del 
A1(4 actividades económicas), falta cuadrarlo con los peps faltante en el cuestionario A1.
Sigue apareciendo 62,333 en lugar de 35,872 
“NUMERO DE CLIENTES O USUARIOS ACTIVOS AL CIERRE”

B
En el campo “TIPO CLIENTE O USUARIO” Falta actualizar al tipo de cliente 15 Cliente: Persona Física Nacional Pep
Para que coincida con los 20 del a1, en el cuestionario b salen 94 actividades económicas.

/*C
En la columna “TIPO DE CLIENTE O USUARIO” están apareciendo los datos 3,5 y 19, cuando solo deben de aparecer los datos 1 y 15

R:Se envio el 30-03 */

D
El cuestionario D debe de cuadrar con el B y C
 
D1.-

En tipo de Canal utilizado, falta agregar Banca Móvil (app) y Banca por internet

Datos para validar los cargos y abonos para el tipo de canal 2, transferencias
30/12/2025
10101-202512-3-2424
ABONO
2005.05
10101-30812-829
10101-10-3905
30/12/2025
10101-202512-3-2425
CARGO
40000
10101-110-11281
10101-10-3905

-------------------------------------------------------------------------------------------------------------
select a.idusuario As Clave_usuario,
(TRIM(TO_CHAR(au.idorigen,'099999'))||'-' || au.idgrupo||'-'||TRIM(TO_CHAR(au.idsocio,'09999999'))) AS numero_socio,
(TRIM(TO_CHAR(au.idorigenp,'099999'))||'-'|| TRIM(TO_CHAR(au.idproducto,'09999'))||'-'||
TRIM(TO_CHAR(au.idauxiliar,'09999999'))) AS folio,
a.fecha,a.hora,

(case 
when a.cargo>0 and a.abono=0 then 'Deposito' 
when a.cargo=0 and a.abono>0 then 'Retiro' end) as "Tipo Movimiento",
(a.cargo+a.abono) as "Monto Total Operacion"
from(select to_char(ad.fecha,'dd/mm/yyyy') as fecha,
to_char(ad.fecha,'HH24:mi.ss') as hora,
ad.idorigenp,ad.idproducto,ad.idauxiliar,
(ad.monto+ad.montoio+ad.montoim) cargo,0.00 as abono,p.idusuario

from auxiliares_d ad 
inner join polizas p using(idorigenc,periodo,idtipo,idpoliza)
where ad.cargoabono=1
and ad.fecha between @@Fecha Inicial Depositos|f|01/01/2018@@ and @@Fecha Final Depositos|f|06/01/2018@@ 

union

select to_char(ad.fecha,'dd/mm/yyyy') as fecha,
to_char(ad.fecha,'HH24:mi.ss') as hora,
ad.idorigenp,ad.idproducto,ad.idauxiliar,0.00 as cargo,
(ad.monto+ad.montoio+ad.montoim) as abono,p.idusuario

from auxiliares_d ad 
inner join polizas p using(idorigenc,periodo,idtipo,idpoliza)

where ad.cargoabono=0
and ad.fecha between @@Fecha Inicial Retiros |f|01/01/2018@@ and @@Fecha Final Retiros|f|06/01/2018@@ )as a
inner join auxiliares au using(idorigenp,idproducto,idauxiliar)
ORDER BY a.fecha, a.hora;



select ppe.*, tr.actividad_economica_pld 
from tmp_act_peps as ppe 
inner join trabajo as tr using (idorigen,idgrupo,idsocio)
where (idorigen,idgrupo,idsocio) = (10102,10,3152);


select idproducto,count(*) conteo
from (
 
select   distinct a.idorigen,a.idgrupo,a.idsocio,a.idproducto
from     auxiliares a
where    estatus = 2 and saldo > 0 and
         idproducto in (
         100,101,130,131,116,
         30102,30112,30122,30302,30312,30602,30612,30622,30702,30712,30802,30812,30822,30902,30912,31202,31212,31402,31412,31422,31602,31612,
         31702,31802,31812,31902,31912,31922,32002,32012,32022,32202,32212,32222,32302,32312,32402,32412,
         140,141,200,201,202,203,
         110,120,112)
 
) z
group by idproducto
order by idproducto;



SELECT sum( monto_operaciones) from (

SELECT ad.idorigenp, ad.idproducto, ad.idauxiliar,ad.tipomov,
round((ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim),0) as monto_operaciones, 'cargo' as cargo
from v_auxiliares_d as ad
where idproducto in (
         100,101,130,131,116,
         30102,30112,30122,30302,30312,30602,30612,30622,30702,30712,30802,30812,30822,30902,30912,31202,31212,31402,31412,31422,31602,31612,
         31702,31802,31812,31902,31912,31922,32002,32012,32022,32202,32212,32222,32302,32312,32402,32412,
         140,141,200,201,202,203,
         110,120,112)
AND ad.cargoabono = 0
AND ad.idtipo in (1,2,3)
AND ad.periodo::integer between 202501 AND 202512

UNION ALL 

SELECT ad.idorigenp, ad.idproducto, ad.idauxiliar,ad.tipomov,
round((ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim),0) as monto_operaciones, 'abono' as abono
from v_auxiliares_d as ad
where idproducto in (
         100,101,130,131,116,
         30102,30112,30122,30302,30312,30602,30612,30622,30702,30712,30802,30812,30822,30902,30912,31202,31212,31402,31412,31422,31602,31612,
         31702,31802,31812,31902,31912,31922,32002,32012,32022,32202,32212,32222,32302,32312,32402,32412,
         140,141,200,201,202,203,
         110,120,112)
AND ad.cargoabono = 1
AND ad.idtipo in (1,2,3)
AND ad.periodo::integer between 202501 AND 202512
 ) as x ;



SELECT count(*),sum(monto_operaciones)  from (SELECT ad.idorigenp, ad.idproducto, ad.idauxiliar,ad.tipomov,
round((ad.monto+ad.montoio+ad.montoim+ad.montoiva+ad.montoivaim),0) as monto_operaciones, 'cargo' as cargo
from v_auxiliares_d as ad
where idproducto in (
         100,101,130,131,116,
         30102,30112,30122,30302,30312,30602,30612,30622,30702,30712,30802,30812,30822,30902,30912,31202,31212,31402,31412,31422,31602,31612,
         31702,31802,31812,31902,31912,31922,32002,32012,32022,32202,32212,32222,32302,32312,32402,32412,
         140,141,200,201,202,203,
         110,120,112)
AND ad.cargoabono = 0
AND ad.idtipo in (1,2,3)
AND ad.periodo::integer between 202501 AND 202512
) as y;