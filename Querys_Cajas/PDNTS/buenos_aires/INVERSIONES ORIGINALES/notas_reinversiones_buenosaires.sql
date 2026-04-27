/* CAJA BUENOS AIRES REQUIERE SABER DE LAS INVERSIONES VIGENTE ENCONTRAR EL PRIMER FOLIO Y LOS SIGUIENTES DATOS

---idsocio
---idproducto
---fecha inversion actual
idpoliza actual
---monto actual
---usuario elaboro actual
---fecha inversion original
idpoliza original
monto original
usuario elaboro original  */

--LOS PRODUCTOS DEL TIPO DPF E INVERAHORROS SON
--200,201,202,203,2002,20102


---LA FUNCION SIEMPRE RECIBE PARAMETROS LOS PUEDES COLOCAR DESDE UN QUERY EN SAICOOP PARA OBTENER SOLO UN DATO EL RESTO SE ASIGNA DENTRO DE LA FUNCION

SELECT numero_reinversionesv3(idorigenp, idproducto, idauxiliar)
FROM auxiliares
WHERE (idorigenp,idproducto,idauxiliar) = (30102,200,98);
;
