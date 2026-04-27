
 SELECT pol.idorigenc,pol.periodo,pol.idtipo,pol.idpoliza,
        pol.fecha,pol.idusuario,u.nombre,
        pd.idcuenta,substr(c.nombre,1,33)as nombre,
        pd.cargoabono,pd.monto 
        FROM ((polizas_d pd 
        INNER JOIN origenes o 
        ON (o.idorigen = pd.idorigenc)) 
        INNER JOIN cuentas c 
        ON (c.idcuenta = pd.idcuenta 
        and c.idorigenc = o.matriz)) 
        INNER JOIN polizas pol
        ON (pd.idorigenc= pol.idorigenc
        AND pd.periodo = pol.periodo
        AND pd.idtipo = pol.idtipo
        AND pd.idpoliza = pol.idpoliza)
        INNER JOIN usuarios u
        ON (u.idusuario = pol.idusuario)
        WHERE pd.idtipo=1 
        AND pol.fecha >=((select distinct date(o.fechatrabajo) from origenes o limit 1) - INTERVAL '1 year')
        AND (c.idcuenta = '10101010101001' OR c.idcuenta ='60901010601001')
        AND pd.cargoabono= 0
        ORDER BY pol.fecha DESC;