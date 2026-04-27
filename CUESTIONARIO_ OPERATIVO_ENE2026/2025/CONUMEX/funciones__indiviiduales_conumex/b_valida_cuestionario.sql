---EL NUMERO DE SOCIOS A LOS QUE APLICA EL CUESTIONARIO B
--SON 16820

/*Se deberan generar los cuestinarios 1 x 1
mediante las siguientes consultas

select * from cuestionario_b(12345,2025);

select * from cuestionario_c_2026(12345,2025);

select * from cuestionario_d1(12345,2025);

select * from cuestionario_d2(12345,2025);
*/

SELECT SUM(b.numero_operaciones::numeric) as numero_opera_b, SUM(b.monto_operaciones::numeric) as montos_b  
FROM b_cuestionario_operatividad as b;

-[ RECORD 1 ]--+----------
numero_opera_b | 174556
montos_b       | 684505926


SELECT  SUM(c.numero_operaciones_entrada_salida::INTEGER) as numero_opera_c, SUM(c.monto_de_operaciones_de_entrada_salida::INTEGER) as montos_c
FROM cuestionario_operatividad_c as c;
-[ RECORD 1 ]--+----------
numero_opera_c | 174556
montos_c       | 684505926


CUESTIONARIO D1 
numero_opera_d   174556
montos_d         684505926

----- SI CUADRAN