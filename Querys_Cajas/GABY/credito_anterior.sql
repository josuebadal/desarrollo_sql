/*Base de datos de los acreditados vigentes que contenga, al menos las siguientes columnas:
Numero de socio
Nombre del socio
Fecha del otorgamiento del credito actual
Hora de otorgamiento del credito actual.
Numero del credito actual
Monto otorgado del credito actual
Fecha de liquidacion del credito inmediato anterior.
Hora de liquidacion del credito inmediato anterior.
Monto del ultimo pago de capital del credito inmediato anterior.
Numero del credito anterior.*/

WITH CreditoAnterior AS (
    SELECT 
        va.idorigen, 
        va.idgrupo, 
        va.idsocio, 
        va.montoprestado,
        TRIM(TO_CHAR(va.idorigen, '099999')) || '-' || TRIM(TO_CHAR(va.idgrupo, '09')) || '-' || TRIM(TO_CHAR(va.idsocio, '099999')) AS "Numero de Socio",
        nombre_x(per.nombre, per.appaterno, per.apmaterno) AS "Nombre del Socio",
        TO_CHAR(ad.fecha, 'YYYY-MM-dd')"fecha_otorgamiento_credito_actual",
        TO_CHAR(ad.fecha, 'HH24:MI:SS') AS "hora_otorgamiento_credito_actual",
        va.idorigenp,
        va.idproducto,
        va.idauxiliar,
        (SELECT TRIM(TO_CHAR(a.idorigenp, '099999')) || '-' || TRIM(TO_CHAR(a.idproducto, '09999')) || '-' || TRIM(TO_CHAR(a.idauxiliar, '09999999')) 
         FROM auxiliares AS a
         WHERE a.estatus = 3  
           AND a.idorigen = va.idorigen  
           AND a.idgrupo = va.idgrupo 
           AND a.idsocio = va.idsocio 
           AND a.idproducto BETWEEN 30000 AND 39999 
         ORDER BY a.fechaactivacion DESC  
         LIMIT 1) AS "Numero de credito anterior"
    FROM auxiliares AS va 
    INNER JOIN personas AS per USING(idorigen, idgrupo, idsocio)
    INNER JOIN auxiliares_d AS ad USING(idorigenp, idproducto, idauxiliar) 
    WHERE va.saldo > 0 
      AND va.idproducto BETWEEN 30000 AND 39999 
      AND va.estatus = 2
)
SELECT distinct on(ca.idorigenp,ca.idproducto,ca.idauxiliar)
    ca."Numero de Socio",
    ca."Nombre del Socio",
    ca."fecha_otorgamiento_credito_actual",
    ca."hora_otorgamiento_credito_actual",
    ca.idorigenp,
    ca.idproducto,
    ca.idauxiliar,
    ca.montoprestado,
    (SELECT TO_CHAR(ad1.fecha, 'YYYY-MM-dd')  
     FROM auxiliares_d ad1
  WHERE ad1.idorigenp = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 1 FOR 6) AS INTEGER)
       AND ad1.idproducto = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 8 FOR 5) AS INTEGER)
       AND ad1.idauxiliar = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 14 FOR 8) AS INTEGER)
       order by fecha desc limit 1
    ) AS "Fecha liquidacion credito anterior",
       (SELECT TO_CHAR(ad1.fecha, 'HH24:MI:SS') 
     FROM auxiliares_d ad1
  WHERE ad1.idorigenp = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 1 FOR 6) AS INTEGER)
       AND ad1.idproducto = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 8 FOR 5) AS INTEGER)
       AND ad1.idauxiliar = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 14 FOR 8) AS INTEGER)
       order by fecha desc limit 1
    ) AS "Hora liquidacion credito anterior",
    (SELECT ad1.monto 
     FROM auxiliares_d ad1
       WHERE ad1.idorigenp = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 1 FOR 6) AS INTEGER)
       AND ad1.idproducto = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 8 FOR 5) AS INTEGER)
       AND ad1.idauxiliar = CAST(SUBSTRING(ca."Numero de credito anterior" FROM 14 FOR 8) AS INTEGER)
       order by fecha desc limit 1
    ) AS "Monto del ultimo pago credito anterior",
    ca."Numero de credito anterior"
FROM CreditoAnterior as ca
ORDER BY ca.idorigenp,ca.idproducto,ca.idauxiliar DESC;