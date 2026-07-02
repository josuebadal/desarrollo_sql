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
--reinversion     | 2


--Validar las inversiones anterior en auxiliares_d , la poliza original sale con la fecha de activacion
select * from v_auxiliares_d where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

--Valdidar quien esta en referenciasp 
--No existe datos en referenciasp lo debe traer de otr amanera
select * from referenciasp where (idorigenp,idproducto,idauxiliar) = (30146,202,124);

-----MANERA DE CORRER LA FUNCION 
SELECT * FROM reinversiones_dpf();
SELECT * FROM historico;

--- 1.- DE LA INVERSION ACTIVA DE DONDE NACIO   
select ad.idorigenp,ad.idproducto,ad.idauxiliar,ad.cargoabono
        ,ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,
        a.idorigen,a.idgrupo,a.idsocio
from v_auxiliares_d as ad
inner join v_auxiliares as a using (idorigenp,idproducto,idauxiliar) 
where idorigenc = 30101
and   periodo   = '202605'
and idtipo      = 3
and idpoliza    = 564
and cargoabono  = 0 --retiro
and idproducto in (200,201,202,203)
and a.estatus = 3
and a.idorigen = 30101
and a.idgrupo  = 10
and a.idsocio  = 260372; 
----------------------------------------
-----2.- EL CREDITO ANTERIOR EN QUE POLIZA NACIO

SELECT  a.idorigen, a.idgrupo, a.idsocio,
        a.idorigenp, a.idproducto, a.idauxiliar, 
        a.saldo, a.fechaactivacion, a.elaboro, ad.cargoabono,
        ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, ad.tipomov
FROM v_auxiliares AS a
        INNER JOIN v_auxiliares_d AS ad ON a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto 
        AND a.idauxiliar = ad.idauxiliar AND a.fechaactivacion = ad.fecha::date
where ad.idorigenp = 30101
and ad.idproducto  = 200
and ad.idauxiliar  = 44376
AND ad.cargoabono = 1;

-------------------------------------------
-----3.- EL CREDITO ANTERIOR EN QUE POLIZA NACIO
select ad.idorigenp,ad.idproducto,ad.idauxiliar,ad.cargoabono
        ,ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,
        a.idorigen,a.idgrupo,a.idsocio
from v_auxiliares_d as ad
inner join v_auxiliares as a using (idorigenp,idproducto,idauxiliar) 
where idorigenc = 30101
and   periodo   = '202605'
and idtipo      = 3
and idpoliza    = 26
and cargoabono  = 0 --retiro
and idproducto in (200,201,202,203)
and a.estatus = 3
and a.idorigen = 30101
and a.idgrupo  = 10
and a.idsocio  = 260372; 
-------------------------------------------
SELECT  a.idorigen, a.idgrupo, a.idsocio,
        a.idorigenp, a.idproducto, a.idauxiliar, 
        a.saldo, a.fechaactivacion, a.elaboro, ad.cargoabono,
        ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza, ad.tipomov
FROM v_auxiliares AS a
        INNER JOIN v_auxiliares_d AS ad ON a.idorigenp = ad.idorigenp AND a.idproducto = ad.idproducto 
        AND a.idauxiliar = ad.idauxiliar AND a.fechaactivacion = ad.fecha::date
where ad.idorigenp = 30101
and ad.idproducto  = 200
and ad.idauxiliar  = 44308
AND ad.cargoabono = 1;
-----------------------------------------------
select ad.idorigenp,ad.idproducto,ad.idauxiliar,ad.cargoabono
        ,ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,
        a.idorigen,a.idgrupo,a.idsocio
from v_auxiliares_d as ad
inner join v_auxiliares as a using (idorigenp,idproducto,idauxiliar) 
where idorigenc = 30101
and   periodo   = '202604'
and idtipo      = 3
and idpoliza    = 37
and cargoabono  = 0 --retiro
and idproducto in (200,201,202,203)
and a.estatus = 3
and a.idorigen = 30101
and a.idgrupo  = 10
and a.idsocio  = 260372; 

--ESTA ES LA ULTIMA POLIZA YA NO HAY MAS DESPUES DE ELLA


--idsocio
--idproducto
--fecha inversion actual
--idpoliza actual
--monto actual
--usuario elaboro actual
fecha inversion original
idpoliza original
monto original
usuario elaboro original


CREATE TEMP TABLE historico(
    idorigen           integer,
    idgrupo            integer,
    idsocio            integer,
    idorigenp_act      integer,
    idproducto_act     integer,
    idauxiliar_act     integer,
    idorigenc_act      integer,
    periodo_act        varchar,
    idtipo_act         integer,
    idpoliza_act       integer,
    contador           integer,
    idorigenp_org      integer,
    idproducto_org     integer,
    idauxiliar_org     integer,
    idorigenc_org      integer,
    periodo_org        varchar,
    idtipo_org         integer,
    idpoliza_org       integer