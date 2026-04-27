--AUDITORIA CNBV 5 DE ENERO 2026


---DEBEREMOS CORRER EL REGULATORIO para obtener la infomo que podamos
--select * from reg_841();
--BASE DE TRABAJO : cerro30nov25_badal841
--Debo sacar 5 socios contenidos en ese regulatorio, agregarlo a una lista sopar, de esa manera me traera todos los datos que requiera

/*
** a.- numero de socio
**b.- nombre
**c.- domicilio
**d.- numeros telefonicos
**e.- email
f.- naturaleza
g.- SON MUCHOS SE PONE AL FINAL
h.- num ref o cuenta o contrato (OPA- contrato na)
i.- sucursal (sucursal de origen del socio o del opa)
j.- nombre sucursal
k.- el saldo mas interes (viene en el reg)
l - m NA
n.- Pedir dato NA
o.- Domicilio NA
p - q NA
*/

WITH reg as(
SELECT 
    TRIM(to_char(s.idorigen,'09999999999999')) ||TRIM(TO_CHAR(s.idgrupo,'09')) ||TRIM(TO_CHAR(s.idsocio,'099999')) AS "ogs_sopar" from sopar as s
    where s.idusuario = 999 AND s.tipo = 'auditoria_cnbv_ene26'
    )
SELECT 
    rg1.numero_de_identificacion as "socio",
    --rg1.nombre_razon_o_denominacion_social ||' '|| apellido_paterno_del_socio || ' '||apellido_materno_del_socio as "nombre",
    nombre_x(p.appaterno,p.apmaterno, p.nombre) as "nombre",
    ps.nombre as "pais", est.nombre as "estado", mun.nombre as "municipio",
    col.nombre as "colonia", rg1.codigo_postal_del_domicilio as "cp",
    p.calle ||', '|| p.numeroext||', '|| p.entrecalles as "domicilio",
    p.telefono  as "celular", p.telefonorecados as "tel_recados",
    p.email as "correo",
    'Act/Pas' as "naturaleza",
    'g' as "tipo_operacion",
    rg1.numero_de_cuenta  as "num_cuenta",
    rg1.nombre_de_sucursal_que_opera_el_deposito as "num_suc",
    'j' as "nom_suc",
    rg1.saldo_de_la_cuenta_al_inicio_del_periodo as "k",
    'ND' as "l",
    'ND' as "m",
    'ND' as "n",
    'ND' as "o",
    'ND' as "p",
    'ND' as "q"
FROM reg as s
INNER JOIN  regulatorio841 as rg1
    ON  rg1.numero_de_identificacion  = s."ogs_sopar"
LEFT JOIN personas as p 
    ON rg1.rfc_del_socio = p.rfc AND rg1.curp_del_acreditado_persona_fisica  = p.curp
LEFT JOIN colonias as col ON p.idcolonia = col.idcolonia
LEFT JOIN municipios as mun ON col.idmunicipio = mun.idmunicipio
LEFT JOIN estados as est ON mun.idestado = est.idestado
LEFT JOIN paises as ps ON est.idpais = ps.idpais 
;  

--select * from regulatorio841 limit 1;



