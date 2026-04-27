select * from reg_453();

select * 
from v_auxiliares 
where (idorigen,idgrupo,idsocio) = (30101,10,96100) 
and montoautorizado = 34700;


oid                | 3655442203
idorigen           | 30101
idgrupo            | 10
idsocio            | 96100
idorigenp          | 30101
idproducto         | 30312
idauxiliar         | 3625

select * 
from v_auxiliares_d 
where (idorigenp,idproducto,idauxiliar) = (30101,30312,3625);

YA HAY NOTICE DONDE SEÑALAN LA POLIZA 
     RAISE NOTICE 'idorigenc: %', r_castigos.idorigenc;
     RAISE NOTICE 'periodo: %', r_castigos.periodo;
     RAISE NOTICE 'idtipo: %', r_castigos.idtipo;
     RAISE NOTICE 'idpoliza: %', r_castigos.idpoliza;
     RAISE NOTICE 'monto de poliza: %', r_castigos.monto;

------LOS DATOS YA EXISTEN Y SE ESTAN ALMACENANDO PERO NO SE MUESTRAN EN EL REPORTE
    r_castigos.idorigenc,
    r_castigos.periodo,
    r_castigos.idtipo,
    r_castigos.idpoliza,

    r_condonaciones.idorigenc,
    r_condonaciones.periodo,
    r_condonaciones.idtipo,
    r_condonaciones.idpoliza,

    debo ubicar donde esta la asginacion de :
    -numerosocio
    -fechacastigo
    -numerocredito

    WHERE ad.idorigenc = r_castigos.idorigenc AND ad.periodo = r_castigos.periodo AND ad.idtipo = r_castigos.idtipo AND
            ad.idpoliza = r_castigos.idpoliza AND ad.cargoabono = 1 AND pr.tipoproducto = 2 AND ad.saldoec = 0 AND
            ad.tipomov in (1,0)


(select au.idorigenc||'-'||au.periodo||'-'||au.idtipo||'-'||idpoliza from castigos au
                 where (au.idorigen,au.idgrupo,au.idsocio,au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigen,gen.idgrupo,gen.idsocio,gen.idorigenp,gen.idproducto,gen.idauxiliar ) limit 1) as poliza


idorigenc    | 30160
periodo      | 202601
idtipo       | 3
idpoliza     | 18


(select au.idorigenc||'-'||au.periodo||'-'||au.idtipo||'-'||idpoliza from v_auxiliares_d au
                 where (au.idorigenp,au.idproducto,au.idauxiliar) =
                       (gen.idorigenp,gen.idproducto,gen.idauxiliar ) 
                  ORDER BY au.fecha DESC limit 1) as poliza