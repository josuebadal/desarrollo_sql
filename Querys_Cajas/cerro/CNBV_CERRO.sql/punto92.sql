WITH emp as(
    select sp.idorigen, sp.idgrupo, sp.idsocio, sp.idusuario, sp.tipo, sp.departamento, sp.puesto, p.appaterno, p.apmaterno, p.nombre, p.fechaingreso as "ing_emp" 
    from sopar as sp 
    inner join personas p ON sp.idorigen = p.idorigen AND sp.idgrupo = p.idgrupo AND sp.idsocio = p.idsocio
    where tipo = 'diryemp' AND sp.idgrupo = 70
),
empsoc as (
    -----LLAMA TODOS LOS OPA DEL GRUPO 10 QUE SE RELACIONO CON NOMBRE DE EMPLEADOS
    SELECT va.idorigen, va.idgrupo, va.idsocio,p1.appaterno, p1.apmaterno, p1.nombre ,va.idorigenp, va.idproducto, va.idauxiliar,
    -----LLAMA A TODOS LOS OGS DEL GRUPO 70 EN LA LISTA SOPAR
    emp.idorigen  AS emp_idorigen,emp.idgrupo   AS emp_idgrupo, emp.idsocio   AS emp_idsocio,emp.ing_emp 
    from personas p1
    INNER JOIN emp on emp.appaterno = p1.appaterno AND emp.apmaterno = p1.apmaterno AND emp.nombre = p1.nombre
    INNER JOIN v_auxiliares as va ON va.idorigen = p1.idorigen AND va.idgrupo = p1.idgrupo AND va.idsocio = p1.idsocio
    WHERE p1.idgrupo = 10 and p1.estatus = 't'
)
SELECT e.emp_idorigen||'-'||e.emp_idgrupo||'-'||e.emp_idsocio AS "num_empl",
e.idorigen||'-'|| e.idgrupo||'-'|| e.idauxiliar as "ogs",nombre_x(e.appaterno,e.apmaterno,e.nombre) as "nombre",e.ing_emp as "ing_empl",
(CASE 
        WHEN vd.cargoabono = 1 THEN 'abono'
        WHEN vd.cargoabono = 0 THEN 'cargo' ELSE 'ND'
END) as ""
FROM v_auxiliares_d as vd 
INNER JOIN empsoc as e on e.idorigenp = vd.idorigenp AND e.idproducto = vd.idproducto AND e.idauxiliar = vd.idauxiliar  
limit 10  
;






/*
a) numero de la cuenta o subcuenta 
--SE REFIERE A LA CUENTA CONTABLE?
--SE PUSO EL OGS DEL EMPLEADO
b) ogs
--SE PUSO OGS DEL GRUPO 10 QUE COINCIDE CON EL NOMBRE
c) nombre del socio
-- nombre del socio mayor 
d) concepto descripcion del origen o naturaleza de la partida
-- se agrega cargoabono (validar en caso de ser otro dato)
e) numero de referencia del contrato --SE REFIERE AL OPA?
f) fecha de operacion
g) saldo
h) monto de la estimacion por irrecuperabilidad --CORRER EL EPERC 
i) tipo de poder legal --SE REFIERE AL PUSTO?
j) fecha de ingreso "DD-MM-YYYY" --INGRESO A LA COPERATIVA O COMO EMPLEADO
k) fecha del nombramiento del cargo actual
l) fecha de separacion
m) tipo de separacion
n) numero de referencia del contrato que acredita la operacion
o) fecha de la operacion o contratacion
p) monto del adeudo original
q) saldo insoluto
r) monto de la estimacion por irrecuperabilidad

---Solo aplicable a directivos o funcionarios de primer nivel empleados o ex empleados
---EL GRUPO DE EMPLEADOS ES EL 70
*/