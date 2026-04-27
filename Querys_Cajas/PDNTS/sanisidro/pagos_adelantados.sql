/*
Pagos adelantados. que contenga los siguientes datos: 
 --No. de socio, 
 --nombre socio, 
 --numero de credito, 
 --fecha de entrega, 
 --fecha vencimiento, 
 --fecha ultimo pago, 
 --saldo vigente, 
 --interes vigente, 
 fecha proximo pago, 
 numero de abonos adelantados, 
 monto pago adelantado.
 
 Los pagos adelantados se realizan mediante un traspaso y una configuracion de Abonos programados
 */



select a.idorigen||'-'||a.idgrupo||'-'||a.idsocio ogs,
nombre_x(p.appaterno,p.apmaterno,p.nombre) as nombre,
a.idorigenp||'-'||a.idproducto||'-'||a.idauxiliar as opa,
a.fechaactivacion as f_entrega, am.vence as f_vence, a.fechauma as f_ult_mov, a.saldo as saldo_act,
a.io as io_vig, a.im as im_vig, COALESCE(split_part(rf.referencia, '|', 1), '0.00') as monto_adelantado
from v_auxiliares as a
inner join personas as p ON p.idorigen = a.idorigen and p.idgrupo = a.idgrupo and p.idsocio = a.idsocio
LEFT JOIN (
    SELECT idorigenp, idproducto, idauxiliar,MAX(vence) AS vence
    FROM amortizaciones
    GROUP BY idorigenp, idproducto, idauxiliar
          ) am  ON a.idorigenp = am.idorigenp AND a.idproducto = am.idproducto AND a.idauxiliar = am.idauxiliar 
LEFT JOIN referenciasp as rf on rf.idorigenpr = a.idorigenp and rf.idproductor = a.idproducto and rf.idauxiliarr = a.idauxiliar 
and rf.tiporeferencia = 7
where a.estatus = 2 and a.idproducto between  30000 and 39999;


--QUERY PARA PAGOS PROGRAMADOS NO EFECTUADOS
select * from referenciasp where tiporeferencia = 7;
select * from amortizaciones where (idorigenp,idproducto,idauxiliar) = (31002,30102,2278);


/* NOTAS 
El producto donde se guarda el dinero para adelantos es 
-[ RECORD 1 ]----------+------------------
idproducto             | 114
nombre                 | Pagos programados
idorigen               | 31001
cuentaaplica           | 20101020101008

POLIZAS_D 
select * from polizas_d where idcuenta = '20101020101008' and periodo = '202602';
 idorigenc | periodo | idtipo | idpoliza | folio |    idcuenta    | cargoabono |  monto  | idorigenp | idproducto | idauxiliar | referencia | idorigena | concepto_mov 
-----------+---------+--------+----------+-------+----------------+------------+---------+-----------+------------+------------+------------+-----------+--------------
     31001 | 202602  |      3 |      297 |     2 | 20101020101008 |          1 |   15.20 |     31001 |        114 |        101 |            |           | 
     31001 | 202602  |      3 |      119 |     2 | 20101020101008 |          1 |   52.25 |     31001 |        114 |        108 |            |           | 
     31001 | 202602  |      3 |      120 |     2 | 20101020101008 |          1 |  193.07 |     31001 |        114 |        109 |            |           | 
     31001 | 202602  |      3 |      395 |     5 | 20101020101008 |          0 |  871.26 |           |            |            |            |           | 
     31001 | 202602  |      3 |      591 |     5 | 20101020101008 |          0 | 2095.56 |           |            |            |            |           | 
*/