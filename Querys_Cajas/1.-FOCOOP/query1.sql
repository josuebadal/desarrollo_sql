select * from cuentas where activa ='t'
AND idcuenta = '10101010101001';

select * from polizas_d 
where idorigenc=20722
AND periodo='202412'
AND idtipo =1 
AND idpoliza=3;

 SELECT pd.idcuenta,substr(c.nombre,1,33)as nombre,
        pd.cargoabono,pd.monto 
        FROM ((polizas_d pd 
        INNER JOIN origenes o 
        ON (o.idorigen = pd.idorigenc)) 
        INNER JOIN cuentas c 
        ON (c.idcuenta = pd.idcuenta 
        and c.idorigenc = o.matriz)) 
        WHERE pd.idorigenc=20751 
        AND pd.periodo='202412' 
        AND pd.idtipo=1 
        AND pd.idpoliza=1
        AND c.idcuenta = '10101010101001'
        AND pd.cargoabono= 0
        --AND pd.monto>0
        ;

--------------------------VERSION 2 MAS RECIENTA-----------------
SELECT  
        o.nombre       AS nombre_origen,
        o.idorigen,
        u.idusuario,
        u.nombre       AS nombre_usuario,
        pol.fecha,
        pol.idorigenc,
        pol.periodo, 
        pol.idtipo,
        pol.idpoliza,
        SUM(CASE WHEN die.monto_ef > 0 THEN die.monto ELSE 0 END) 
        AS monto_efectivo,
        SUM(CASE WHEN die.monto_ch > 0 THEN die.monto ELSE 0 END) 
        AS monto_cheque
    --die.efectivo_desglose AS efectivo_final 
    FROM polizas pol
        INNER JOIN usuarios u
            ON u.idusuario = pol.idusuario
        INNER JOIN origenes o
            ON o.idorigen = pol.idorigenc
        INNER JOIN detalle_ie die
            ON  die.idorigenc = pol.idorigenc
            AND die.periodo   = pol.periodo 
            AND die.idtipo    = pol.idtipo 
            AND die.idpoliza  = pol.idpoliza
        INNER JOIN polizas_d pold 
            ON  pold.idorigenc = pol.idorigenc
            AND pold.periodo   = pol.periodo 
            AND pold.idtipo    = pol.idtipo 
            AND pold.idpoliza  = pol.idpoliza
    WHERE die.tipomov = 0
        AND die.fecha::date BETWEEN '2024-12-01' 
        AND (SELECT fechatrabajo FROM origenes LIMIT 1)
        AND pold.cargoabono =1
        AND die.esentrada = 't'
        AND u.idusuario <> 999
        --AND die.idtipo=1
    GROUP BY 
        nombre_origen,
        o.idorigen,
        u.idusuario,
        nombre_usuario,
        pol.fecha,
        pol.idorigenc,
        pol.periodo, 
        pol.idtipo,
        pol.idpoliza
        --die.efectivo_desglose
    ORDER BY pol.fecha,o.idorigen DESC 
;



-----------------------version 1----------------------
SELECT  
        o.nombre       AS nombre_origen,
        o.idorigen,
        u.idusuario,
        u.nombre       AS nombre_usuario,
        pol.fecha,
        pol.idorigenc,
        pol.periodo, 
        pol.idtipo,
        pol.idpoliza,
        SUM(CASE WHEN die.monto_ef > 0 THEN die.monto ELSE 0 END) AS monto_efectivo,
        SUM(CASE WHEN die.monto_ch > 0 THEN die.monto ELSE 0 END) AS monto_cheque
    FROM polizas pol
        INNER JOIN usuarios u
            ON u.idusuario = pol.idusuario
        INNER JOIN origenes o
            ON o.idorigen = pol.idorigenc
        INNER JOIN detalle_ie die
            ON  die.idorigenc = pol.idorigenc
            AND die.periodo   = pol.periodo 
            AND die.idtipo    = pol.idtipo 
            AND die.idpoliza  = pol.idpoliza
    WHERE die.tipomov = 0
        AND die.fecha::date BETWEEN '2024-12-01' 
        AND (SELECT fechatrabajo FROM origenes LIMIT 1)
        AND die.esentrada = 't'
        AND u.idusuario <> 999
    GROUP BY 
        nombre_origen,
        o.idorigen,
        u.idusuario,
        nombre_usuario,
        pol.fecha,
        pol.idorigenc,
        pol.periodo, 
        pol.idtipo,
        pol.idpoliza
    ORDER BY pol.fecha,o.idorigen DESC 
;