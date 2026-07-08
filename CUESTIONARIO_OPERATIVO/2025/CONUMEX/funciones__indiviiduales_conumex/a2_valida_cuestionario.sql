/*Se deberan generar los cuestinarios 1 x 1
mediante las siguientes consultas

select * from cuestionario_a1(29037,2025);

select * from cuestionario_a2(12345,2025);

select * from cuestionario_b(12345,2025);

select * from cuestionario_c_2026(12345,2025);

select * from cuestionario_d1(12345,2025);

select * from cuestionario_d2(12345,2025);
*/


*****VALIDAR TABLAS TEMPORALES CREADAS***
tmp_act_y           ---SOLO GUARDA INFOR EN CASO DE HABER ORDENES NACIONALES
tmp_act_x           ---GUARDA LOS SOCIOS QUE APLICAN PARA EL FORMULARIO 16821 datos correctos
tmp_act             ---GUARDA 16820 REGISTROS
temp_peps           ---GUARDA EL LISTADO TOTAL DE SOCIOS PPE PARA UNA COMPARATIVA
tmp_act_peps        ---GUARDA CON UNA BANDERA LOS QUE SI SON PPE
temp_productos      ---GUARDA EL LISTADO DE PRODUCTO QUE APLICA PARA TODOS LOS SOCIOS (insert_prod)
temp_auxi           ---62,333 REGISTROS DEBEN SER 35,872 repite socios porque tienen mas de 1 producto
temp_pfae
temp_remesas

------ VALIDA LOS SOCIOS TOTALES QUE APLICAN  Y SE REPITEN
select * from temp_auxi where idsocio = 25 order by idproducto desc ;

select idorigen, idgrupo, idsocio, count(*) as veces
from temp_auxi
group by idorigen, idgrupo, idsocio
having count(*) > 1;

select *
from temp_auxi
where (idorigen, idgrupo, idsocio) in (
    select idorigen, idgrupo, idsocio
    from temp_auxi
    group by idorigen, idgrupo, idsocio
    having count(*) > 1
)
order by idorigen, idgrupo, idsocio;

----- VISUALIZA INFO PARA VER QUE NO SEAN REPETIDO
select * from temp_auxi where idsocio = 25 order by idorigen desc ;




select sum(numero_clientes_usuarios::numeric) 
from a2_cuestionario_operatividad; 
-[ RECORD 1 ] sum | 62333 

-----CLIENTES UNICOS 
select count(distinct (idorigen, idgrupo, idsocio)) 
from temp_auxi; 
-[ RECORD 1 ] count | 11541

-----CLIENTES + PRODUCTOS
select count(distinct (idorigen, idgrupo, idsocio, idcuestionario))
from temp_auxi;
-[ RECORD 1 ]
count | 25087
