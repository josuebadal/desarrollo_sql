INSERT INTO tablas (idtabla,idelemento,nombre,dato1,dato3,tipo,dato2)
VALUES ('texto_contratos',
        'contrato_pfpagatodos',
        'PAGARE PAGOS FIJOS',
        'carta',
        '80|98|9|3|0',
        0,
        '
                             P      A      G      A      R      E


PRESTAMO:<idorigenp|>-<idproducto|NULL>-<idauxiliar|NULL>     SOCIO:<ogs|o-g-s>  
FECHA DE VENCIMIENTO: <amort_fecha_ultimo|dd> de mes <amort_fecha_ultimo|ml>  de <amort_fecha_ultimo|aaaa>   
IMPORTE: <montosolicitado|>
       
Por este pagare, reconozco(cemos) y me obligo(amos) a pagar incondicionalmente, en la fecha de su vencimiento, en esta cuidad o en la ciudad de Merida, Yucatan, a eleccion del tenedor, a la orden de CAJA ITZAEZ, SOCIEDAD COOPERATIVA DE AHORRO Y PRESTAMO DE RESPONSABILIDAD LIMITADA DE CAPITAL VARIABLE, la cantidad de: $<montosolicitado|> <montosolicitado|letra> valor que he(mos) recibido en efectivo a mi (nuestra) entera satisfaccion.

Dicha cantidad devengara un interes ordinario a una tasa del <tasaio_anual.sql|>%,  <tasaio_anual|letra> anual, que se causara en forma mensual, que se pagara junto con el abono mensual a capital y los pagos deberan realizarse conforme al siguiente plan de pagos:

<amortizaciones|idamortizacion,vence,saldo_insoluto,io,iva,abono,total>


De no pagarse en las fechas establecidas, se causara un interes moratorio a una tasa del <tasaio_anual.sql|>% anual sobre el importe de cada abono a capital mensual vencido y no pagado.
De igual forma me(nos) obligo(amos) a pagar el impuesto al Valor Agregado (IVA) que se genere por los intereses ordinarios y moratorios.
Todos los abonos a capital mensual, estan sujetos a la condicion de que, al no pagarse tres abonos a su vencimiento, seran exigibles todos los que sigan, dandose por vencido anticipadamente el plazo y podra exigirse el total adeudado.
Los intereses se calcularan dividiendo la tasa de interes aplicable entre trescientos sesenta dias, multiplicando el resultado asi obtenido por el numero de dias efectivamente transcurridos por el saldo insoluto.
Merida, Yucatan ,a <fecha_hoy|dd>  de <fecha_hoy|ml>  del <fecha_hoy|aaaa>

NOMBRE Y FIRMA DEL DEUDOR


___________________________________

NOMBRE: <nombre_socio|>
RFC: <curp_rfc|NULL>
DOMICILIO: <direccion|> <direccion|colonia> <direccion|municipio>
TELEFONO: <telefono|NULL>


'
);