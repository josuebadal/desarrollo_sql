
select * from tablas where idtabla = 'procesos_masivos' order by idelemento::integer;

update tablas t
set    idelemento = x.new_id
from   (select   idtabla,idelemento,(idelemento::integer + 1) as new_id
        from     tablas
        where    idtabla = 'procesos_masivos' and idelemento::integer > 3
        order by idelemento::integer desc) as x
where  t.idtabla = x.idtabla and t.idelemento = x.idelemento;


insert
into  tablas
      (idtabla,idelemento,nombre,dato1,dato2,dato5,tipo)
values ('procesos_masivos','4','Abono adelantado a interes','1','select sai_abono_adelantado_a_interes($idusuario)','1',2);


