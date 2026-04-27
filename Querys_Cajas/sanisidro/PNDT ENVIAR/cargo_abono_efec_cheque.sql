SELECT 
    (SELECT SUM(ad1.efectivo) 
    FROM auxiliares_d ad1
    WHERE ad1.cargoabono = 1
        AND ad1.idtipo = 1
        AND ad1.tipomov = 0
        AND ad1.fecha::date BETWEEN '2025-01-01' AND '2025-09-30') AS "Ingresos_Efectivo",
    (SELECT SUM(ad2.monto) 
    FROM auxiliares_d ad2
    WHERE ad2.cargoabono = 0
        AND ad2.idtipo  = 1
        AND ad2.tipomov = 0
        AND ad2.fecha::date BETWEEN '2025-01-01' AND '2025-09-30') AS "Egresos_Efectivo",
    (SELECT SUM(ad3.monto) 
    FROM auxiliares_d ad3
    WHERE ad3.cargoabono = 1
        AND ad3.idtipo =2
        AND ad3.tipomov = 0
        AND ad3.fecha::date BETWEEN '2025-01-01' AND '2025-09-30') AS "Ingresos_Cheque",
    (SELECT SUM(ad4.monto) 
    FROM auxiliares_d ad4
    WHERE ad4.cargoabono = 0
        AND ad4.idtipo =2
        AND ad4.tipomov = 0
        AND ad4.fecha::date BETWEEN '2025-01-01' AND '2025-09-30') AS "Egreso_Cheque";