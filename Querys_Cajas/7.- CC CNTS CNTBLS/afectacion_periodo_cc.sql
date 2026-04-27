/*
CAJA BUENOS AIRES 26 NOVIEMBRE 2025
una consulta para obtener el total de movimientos que componen el 
saldo en el "debe" y el "haber" de una cuenta dentro de un periodo mensual.

Por ejemplo, adjunto imagen de la balanza de comprobacion
 a detalle en donde se muestra el acumulado de cada cuenta 
 por mes en el "debe" y en el "haber" y se nesesita la integracion de 
 movimientos que componen a estos saldos mensuales para proporcionarlos a los 
 auditores externos que nos estan auditando actualmente.

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
        ORDER BY pol.fecha DESC; */

-----PRIMER AVANCE -----
SELECT  pd.idcuenta as "Cuenta", c.nombre, 
        pd.idorigenc, pd.periodo, pd.idtipo, 
        pd.idpoliza, pd.folio, pd.cargoabono,
        pd.monto
        FROM polizas_d pd
        INNER JOIN cuentas c 
        ON pd.idcuenta = c.idcuenta
        WHERE pd.periodo::numeric = 202505
        AND c.idcuenta::numeric = 40104020201001
        ORDER BY pd.cargoabono --desc 
        ;


-----VERSION DE SAICOOP 
SELECT  pd.idcuenta as "Cuenta", 
        '|' as "|",
        c.nombre,
        '|' as "|",
        pd.idorigenc||'-'|| pd.periodo ||'-'|| pd.idtipo ||'-'||pd.idpoliza as poliza, 
        '|' as "|",
        pd.folio, 
        '|' as "|",
        (CASE 
                WHEN pd.cargoabono = 1 THEN 'Abono'
                ELSE 'Cargo'
                END) as "cargoabono",
        '|' as "|",
        pd.monto
        FROM polizas_d pd
        INNER JOIN cuentas c 
        ON pd.idcuenta = c.idcuenta
        WHERE pd.periodo::numeric BETWEEN @@Periodo ini:|e|202502@@  
        AND  @@Periodo fin:|e|202502@@ 
        AND c.idcuenta::numeric IN (
        40104020201001,40104020201002,40104020401001,40104020401002,40104030101001,40102030101001,40103010101001,40501010101001,50101010101002,60801010101001,60801010101002,60601010101001
        )
        ORDER BY c.idcuenta,pd.cargoabono DESC 
        ;



-----PRUEBAS PARA VER SALDOS VERSION  2-----
SELECT  pd.idcuenta as "Cuenta", '|' as "|",
        c.nombre,'|' as "|",
        pd.idorigenc||'-'|| pd.periodo ||'-'|| pd.idtipo ||'-'||pd.idpoliza as poliza, '|' as "|",
        pd.folio, '|' as "|",
        (CASE 
                WHEN pd.cargoabono = 1 THEN 'Abono'
                ELSE 'Cargo'
                END) as "cargoabono", 
        ad.monto as "monto_mov",
        TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
        TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(ad.idauxiliar,'09999999')) as "OPA",
        ad.fecha as "fecha_mov"
        FROM auxiliares_d ad
        INNER JOIN  polizas_d pd
        ON      pd.idorigenc = ad.idorigenc
        AND     pd.periodo =   ad.periodo
        AND     pd.idtipo =    ad.idtipo
        AND     pd.idpoliza =  ad.idpoliza
        INNER JOIN cuentas c 
        ON pd.idcuenta = c.idcuenta
        WHERE pd.periodo::numeric BETWEEN 202502 
        AND  202502 
        AND c.idcuenta::numeric IN (
        40104020201001,40104020201002,40104020401001,40104020401002,40104030101001,40102030101001,40103010101001,40501010101001,50101010101002,60801010101001,60801010101002,60601010101001
        )
        ORDER BY c.idcuenta ASC; 


----- VALIDACION EN SAICOOP VERSION 2-----
SELECT  pd.idcuenta as "Cuenta", '|' as "|",
        c.nombre,'|' as "|",
        pd.idorigenc||'-'|| pd.periodo ||'-'|| pd.idtipo ||'-'||pd.idpoliza as poliza, '|' as "|",
        pd.folio, '|' as "|",
        (CASE 
                WHEN pd.cargoabono = 1 THEN 'Abono'
                ELSE 'Cargo'
                END) as "cargoabono", '|' as "|",
        ad.monto as "monto_mov",'|' as "|",
        TRIM(TO_CHAR(ad.idorigenp,'099999'))||'-'||
        TRIM(TO_CHAR(ad.idproducto,'09999'))||'-'||
        TRIM(TO_CHAR(ad.idauxiliar,'09999999')) as "OPA",'|' as "|",
        ad.fecha as "fecha_mov"
        FROM auxiliares_d ad
        INNER JOIN  polizas_d pd
        ON      pd.idorigenc = ad.idorigenc
        AND     pd.periodo =   ad.periodo
        AND     pd.idtipo =    ad.idtipo
        AND     pd.idpoliza =  ad.idpoliza
        INNER JOIN cuentas c 
        ON pd.idcuenta = c.idcuenta
        WHERE pd.periodo::numeric BETWEEN @@Periodo ini:|e|202502@@  
        AND  @@Periodo fin:|e|202502@@ 
        AND c.idcuenta::numeric IN (
        40104020201001,40104020201002,40104020401001,40104020401002,40104030101001,40102030101001,40103010101001,40501010101001,50101010101002,60801010101001,60801010101002,60601010101001
        )
        ORDER BY c.idcuenta ASC; 

