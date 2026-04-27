
SELECT 
    TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'||
    TRIM(TO_CHAR(a.idproducto,'09999'))||'-'||
    TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Cuenta",
    ad.fecha AS "fecha",
    ad.efectivo AS "importe", 
    (SELECT fechatrabajo from origenes order by fechatrabajo desc limit 1) AS "transaccion",
    o.nombre AS "sucursal",
    '' AS "concepto",
    (CASE 
            WHEN ad.efectivo >0 THEN 'Si'
            Else 'No'
                END)AS "monetario",
    ad.monto AS "capital",
    ad.montoio AS "interes", 
    p.curp AS "curp",
    ad.montoim AS "moratorio",
    ad.montoivaim AS "iva_moratorio",
    (CASE 
            WHEN ad.idtipo = 1 THEN 'Ventanilla'
            WHEN ad.idtipo = 2 THEN 'Cheque'
            WHEN ad.idtipo = 3 THEN 'Traspaso'
                END) AS "forma_pago",
    (CASE
            WHEN ad.tipomov  = 0 THEN 'cargo/abono' 
            WHEN ad.tipomov  = 1 THEN 'castigo'
            WHEN ad.tipomov  = 2 THEN 'quita'
            WHEN ad.tipomov  = 3 THEN 'condonacion'
            WHEN ad.tipomov  = 4 THEN 'bonificacion'
            WHEN ad.tipomov  = 5 THEN 'descuento'
            WHEN ad.tipomov  = 6 THEN 'ajuste'
                END) AS "Operacion", 
            
    (CASE 
            WHEN ad.cargoabono = 1 THEN 'Abono'
            WHEN ad.cargoabono = 0 THEN 'Cargo'
                END) AS "tipo",
    p.calle AS "Entre_calle_A",
    '' AS "Entre_calle_B"
    FROM auxiliares a 
            INNER JOIN auxiliares_d ad
                ON a.idorigenp = ad.idorigenp
                AND a.idproducto = ad.idproducto
                AND a.idauxiliar = ad.idauxiliar
            LEFT JOIN origenes o 
                ON ad.idorigenc = o.idorigen
            INNER JOIN personas p 
                ON a.idorigen = p.idorigen 
                AND a.idgrupo = p.idgrupo 
                AND a.idsocio = p.idsocio
    WHERE a.estatus = 2
                AND a.idproducto BETWEEN 30000  AND 39999
                ORDER BY ad.fecha desc 
        ;