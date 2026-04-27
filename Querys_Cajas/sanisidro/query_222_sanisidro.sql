----- VALIDAR COMO SALEN LAS CUENTAS -----
/*Este query no jala en saicoop pero si en terminal

Para solicitar ayuda con el siguiente Query de Tasas Promedio de Captación que 
al ejecutarlo en la plataforma de SAICoop marca error y en PgAdmin 4 si lo corre.
*/
SELECT a.idproducto, 
sum(a.saldo) AS saldos, 
count(1) AS conteo, 
a.tasaio, 
a.tasaiod, 
p.cuentaaplica
FROM auxiliares AS a
INNER JOIN productos AS p 
ON (a.idproducto = p.idproducto)
WHERE p.tipoproducto IN (0,1,8) 
AND p.cuentaaplica LIKE '201%' 
AND a.saldo > 0
GROUP BY a.idproducto, a.tasaio, a.tasaiod,p.cuentaaplica
ORDER BY a.idproducto;



-------------------------ORIGINAL ABAJO ERROR EN ESPACIOS-----

SELECT a.idproducto, 
sum(a.saldo) AS saldos, 
count(1) AS conteo, 
a.tasaio, 
a.tasaiod
FROM auxiliares AS a 
INNER JOIN productos AS p 
ON (a.idproducto = p.idproducto)
WHERE p.tipoproducto IN (0,1,8) 
AND p.cuentaaplica LIKE '201%' 
AND a.saldo > 0 
GROUP BY a.idproducto, a.tasaio, a.tasaiod 
ORDER BY a.idproducto;