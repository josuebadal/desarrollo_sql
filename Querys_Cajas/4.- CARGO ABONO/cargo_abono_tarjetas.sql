/*
BUENOS AIRES
Solicitado por : JAIR
FECHA: 04-DICIEMBRE-2025
Obtener un query para consultar la cantidad y monto 
de los pagos realizados por 
ventanilla con tarjeta de debito o credito.
quedo al pendiente.
En la tabla detalle_ie en el elemento montotj se puede validar que el pago fue realizado por medio de tarjeta
NECESITO VALIDAR QUE PRODUCTO Y QUE MONTOS SE PAGARON EN ESTE MOVIMIENTO

opa       | 030109-00110-00025218
fecha     | 01/02/2025 10:01:07.402787 CST
poliza    | 030109-202502-1-000001
monto_tar | 2491.70
monto_ef  | 0.00
monto_ch  | 0.00
ticket    | 2

select * from v_auxiliares_d 
where (idorigenc,periodo,idtipo,idpoliza) = (30109,'202502',1,1)
and ticket = 2;

select * from detalle_ie 
where (idorigenc,periodo,idtipo,idpoliza) = (30109,'202502',1,1)
and ticket = 2;


*/


SELECT
TRIM(TO_CHAR(die.idorigenc,'099999'))||'-'||TRIM(die.periodo)||'-'||TRIM(TO_CHAR(die.idtipo,'0'))||'-'||TRIM(TO_CHAR(die.idpoliza,'099999')) as "poliza",die.consecutivo as "ticket",
TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||TRIM(TO_CHAR(ad.idauxiliar,'09999999')) as "opa",
ad.monto, ad.montoio,ad.montoim,ad.montoiva,
ad.fecha,
die.monto_tj as "monto_tar"
--,die.monto_ef, die.monto_ch
--,ad.*
FROM detalle_ie as die
INNER JOIN v_auxiliares_d as ad
ON ad.idorigenc = die.idorigenc
AND ad.periodo = die.periodo
AND ad.idtipo = die.idtipo
AND ad.idpoliza = die.idpoliza
AND ad.ticket = die.consecutivo
WHERE  die.monto_tj > 0
AND ad.idtipo = 1 AND ad.tipomov = 0
AND die.periodo BETWEEN '202502'  
AND '202502'  
ORDER BY ad.fecha ASC
;




--AND die.periodo::numeric BETWEEN @@Periodo ini:|c|202502@@  
--AND @@Periodo fin:|c|202502@@  
/*
SELECT
TRIM(TO_CHAR(die.idorigenc,'099999'))||'-'||TRIM(die.periodo)||'-'||TRIM(TO_CHAR(die.idtipo,'0'))||'-'||TRIM(TO_CHAR(die.idpoliza,'099999')) as "poliza",die.consecutivo as "ticket",
TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||TRIM(TO_CHAR(ad.idauxiliar,'09999999')) as "opa",
ad.monto, ad.montoio,ad.montoim,ad.montoiva,
ad.fecha,
die.monto_tj as "monto_tar"
--,die.monto_ef, die.monto_ch
--,ad.*
FROM detalle_ie as die
INNER JOIN v_auxiliares_d as ad
ON ad.idorigenc = die.idorigenc
AND ad.periodo = die.periodo
AND ad.idtipo = die.idtipo
AND ad.idpoliza = die.idpoliza
AND ad.ticket = die.consecutivo
WHERE  die.monto_tj > 0
AND ad.idtipo = 1 AND ad.tipomov = 0
AND die.periodo BETWEEN @@Periodo ini:|c|202502@@  
AND @@Periodo fin:|c|202502@@  
ORDER BY ad.fecha ASC
;

*/