--Sacar las inerversiones activas
idorigen        | 30101
idgrupo         | 10
idsocio         | 260372
idorigenp       | 30101
idproducto      | 200
idauxiliar      | 44445
saldo           | 29477.77
fechaactivacion | 31/05/2026
elaboro         | 999
cargoabono      | 1
idorigenc       | 30101
periodo         | 202605
idtipo          | 3
idpoliza        | 564
tipomov         | 0
reinversion     | 2


--Validar las inversiones anterior en auxiliares_d , la poliza original sale con la fecha de activacion
select * from v_auxiliares_d where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

--Valdidar quien esta en referenciasp 
--No existe datos en referenciasp lo debe traer de otr amanera
select * from referenciasp where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

-----MANERA DE CORRER LA FUNCION 
SELECT * FROM reinversiones_dpf();

select * 
from v_auxiliares_d as ad 
INNER JOIN v_auxiliares as a
ON ad.idorigenp =30101
AND ad.idproducto = 200
and ad.idauxiliar = 44445
where idorigenc = 30101
and   periodo   = '202605'
and idtipo      = 3
and idpoliza    = 564; 

