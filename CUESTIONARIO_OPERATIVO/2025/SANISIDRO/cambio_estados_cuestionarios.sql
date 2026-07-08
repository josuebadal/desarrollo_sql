/*
\i cambio_estados_cuestionarios.sql 
select tabla_estados_para_cuestionarios();
select * from estados_cuestionario order by idestado;
*/

create or replace function tabla_estados_para_cuestionarios()
returns varchar as $$
declare
  p_caja integer;
begin

  p_caja := 0;
  select into p_caja idorigen
  from origenes where matriz = 0;
  if not found or p_caja is NULL then
    return 'HAY UN ERROR EN LA TABLA origenes';
  end if;

  drop table if exists estados_cuestionario;


  -- BUENOS AIRES
  if p_caja = 30100 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- CAPITAL ACTIVO
  if p_caja = 20100 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- CERRO
  if p_caja = 30400 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- FAMA
  if p_caja = 30500 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- LEON FRANCO
  if p_caja = 13500 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,5);
    insert into estados_cuestionario values (6,6);
    insert into estados_cuestionario values (7,7);
    insert into estados_cuestionario values (8,8);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- MITRAS
  if p_caja = 30300 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- NUEVE AGOSTO
  if p_caja = 10400 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- NUEVO MEXICO
  if p_caja = 10100 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- SAGRADA
  if p_caja = 20700 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,5);
    insert into estados_cuestionario values (6,6);
    insert into estados_cuestionario values (7,7);
    insert into estados_cuestionario values (8,8);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;


  -- SAN ISIDRO
  if p_caja = 31000 then
    create table estados_cuestionario (idestado integer, idestado_c integer);
    insert into estados_cuestionario values (1,1);
    insert into estados_cuestionario values (2,2);
    insert into estados_cuestionario values (3,3);
    insert into estados_cuestionario values (4,4);
    insert into estados_cuestionario values (5,7);
    insert into estados_cuestionario values (6,8);
    insert into estados_cuestionario values (7,5);
    insert into estados_cuestionario values (8,6);
    insert into estados_cuestionario values (9,9);
    insert into estados_cuestionario values (10,10);
    insert into estados_cuestionario values (11,11);
    insert into estados_cuestionario values (12,12);
    insert into estados_cuestionario values (13,13);
    insert into estados_cuestionario values (14,14);
    insert into estados_cuestionario values (15,15);
    insert into estados_cuestionario values (16,16);
    insert into estados_cuestionario values (17,17);
    insert into estados_cuestionario values (18,18);
    insert into estados_cuestionario values (19,19);
    insert into estados_cuestionario values (20,20);
    insert into estados_cuestionario values (21,21);
    insert into estados_cuestionario values (22,22);
    insert into estados_cuestionario values (23,23);
    insert into estados_cuestionario values (24,24);
    insert into estados_cuestionario values (25,25);
    insert into estados_cuestionario values (26,26);
    insert into estados_cuestionario values (27,27);
    insert into estados_cuestionario values (28,28);
    insert into estados_cuestionario values (29,29);
    insert into estados_cuestionario values (30,30);
    insert into estados_cuestionario values (31,31);
    insert into estados_cuestionario values (32,32);
  end if;

  return 'SE DIO DE ALTA DE MANERA CORRECTA LA TABLA COMPARATIVA DE ESTADOS PARA LOS CUESTIONARIOS.';
end;
$$ language 'plpgsql';

