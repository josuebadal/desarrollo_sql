-----EJECUTAR REGULATORIO
select reg_453();

-----VALIDAR CASTIGOS
select * from castigos;

-----VALIDAR CONDONACIONES
SELECT * FROM prestamos_condonaciones;

-----VALIDAR OGS OPA
select * from ogs_opa;

-----VALIDAR LA TABLA FINAL
select * from final;

-----VALIDAR TABLA PARA REPORTE
select * from castigos_cnbv_reporte;


-----INCISOS QUE HACEN FALTA
i) Fecha de primera amortización no cubierta
l) Situación del crédito (vigente sin pagos vencidos, vigente con pagos vencidos, vencido en trámite administrativo, vencido en litigio)
m) Tipo de movimiento (eliminación, condonación, quita, descuento)
n) Saldo insoluto como sigue: (incisos "n" a "s")
o) Capital Vigente
p) Capital Vencido
q) Intereses vigente
r) Intereses vencido
s) Intereses moratorio
t) Intereses refinanciados o capitalizados
u) Tipo de Acreditado (0 No Relacionado, 1 Consejero y los miembros del Consejo de Vigilancia y Comité de Credito)
x) Status actual

------------ TODAS LAS COLUMNAS
Las columnas para la base son:
i) Fecha de primera amortización no cubierta
l) Situación del crédito (vigente sin pagos vencidos, vigente con pagos vencidos, vencido en trámite administrativo, vencido en litigio)
m) Tipo de movimiento (eliminación, condonación, quita, descuento)
o) Capital Vigente
p) Capital Vencido
q) Intereses vigente
u) Tipo de Acreditado (0 No Relacionado, 1 Consejero y los miembros del Consejo de Vigilancia y Comité de Credito)
x) Status actual
