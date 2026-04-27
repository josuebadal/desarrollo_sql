OGS: 010101-10-19257
OPA: 010101-30802-896
POLIZA:010101-10-259
MONTO:100
FECHA:05/01/2026

idorigenc    | 10101
periodo      | 202601
idtipo       | 3
idpoliza     | 284
tipomov      | 0
fecha        | 05/01/2026 16:07:41



idorigenc    | 10101
periodo      | 202601
idtipo       | 1
idpoliza     | 259
tipomov      | 0
fecha        | 05/01/2026 15:58:38

select * from v_auxiliares 
where (idorigenp,idproducto,idauxiliar) = (10101,30802,896);


select * from v_auxiliares_d 
where (idorigenp,idproducto,idauxiliar) = (10101,30802,896)
order by fecha desc;

select * from polizas where (idorigenc,periodo,idtipo,idpoliza) = (10101,'2026101',3,284);

--LOS SPEI LOS HACEN MEDIANTE TRASPASO CON LA CUENTA CONTABLE 

10102010101017


Envió la información solicitada de ejemplo
OGS: 010101-10-19257
OPA: 010101-30802-896
POLIZA:010101-01-259
MONTO:100000
FECHA:05/01/2026

SALMERON GALVAN PATRICIA VICTORIA
OGS: 010101-10-4466
OPA: 010101-110-1392
POLIZA: 010101-01-470
MONTO: 120000
FECHA 09/01/2026

select * from polizas_d where idcuenta = '10102010101017' and referencia LIKE '10101|10|19257@' and periodo = '202601';


select * from polizas 
where idcuenta = '10102010101017' 
and referencia LIKE '10101|10|19257@' 
and periodo = '202601';


10101-202601-1-505

select * from polizas_d where (idorigenc,periodo,idtipo,idpoliza) = (10101,'202601',1,505) 
and idcuenta = '10102010101017';



select * from polizas where (idorigenc,periodo,idtipo,idpoliza) = (010101,'202601',1,470) ;
select * from v_auxiliares_d where (idorigenc,periodo,idtipo,idpoliza) = (010101,'202601',1,470) ;
concepto   | SOC 19257 PTMO SPEI 05/01/2026 ****( SPEI )****

-------------QUERY 1 
select  
        trim(to_char(a.idorigen,'099999'))||'-'||a.idgrupo||'-'||
        trim(to_char(a.idsocio,'099999')) as numerosocio,
        trim(to_char(a.idorigenp,'099999'))||'-'||trim(to_char(a.idproducto,'09999'))||'-'||trim(to_char(a.idauxiliar,'09999999')) as numerocredito,
        pr.nombre as "nom_prod",
        nombre_x(p.appaterno, p.apmaterno,p.nombre) as nombre,
        p.fechaingreso as "fechaingreso",
             /*case p.tipo_idoficial
                  when 1 then 'INE/IFE'
                  when 2 then 'Pasaporte'
                  else 'Ninguno'
             end as  "Identificacion Oficial",*/
             (select descripcion from catalogo_menus
              where menu = 'nacionalidad' and opcion = p.nacionalidad) as "Nacionalidad",
             p.fechanacimiento as "fecha_nac",
            -----  CAMPOS PLD Y PEPS
            coalesce((select (select pld.descripcion from actividades_economicas_pld pld
                    where pld.id_actividad = t.actividad_economica_pld)
                    from trabajo t
                    where (t.idorigen,t.idgrupo,t.idsocio) = (p.idorigen,p.idgrupo,p.idsocio)
                    order by t.consecutivo desc limit 1 ), '0') as "ocupacion",
      ----------------  TERMINA NIVEL
             coalesce(t.ing_mensual_neto,0) as "ingresos",
             e.nombre as "Estado",
             m.nombre as "Municipio",
             c.nombre as "Colonia",
            coalesce(p.calle,'Sin calle') as "Calle", 
             coalesce(p.numeroext,'Sin Numero') as "Num Ext",
             coalesce(p.numeroint,'Sin Numero') as "Num Int",
             ad1.monto as "monto",
             to_char(ad1.fecha, 'DD-MM-YYYY HH24:MI:SS') as "Fecha Mov",
             ord.nombre as sucursal,
             ad1.idorigenc||'-'||ad1.periodo||'-'||ad1.idtipo||'-'||ad1.idpoliza as "poliza",
             (CASE 
                  WHEN pol.concepto LIKE '%****( SPEI%' THEN 'SPEI'
                  ELSE 'EFECTIVO'
                  END) as "tipo_mov"
             --0::numeric as "Suma"
      from v_auxiliares_d as ad1
           inner join v_auxiliares a using (idorigenp, idproducto, idauxiliar)
           inner join productos pr on ad1.idproducto = pr.idproducto
           inner join personas p on a.idorigen=p.idorigen and a.idgrupo=p.idgrupo and a.idsocio=p.idsocio
           inner join origenes ord on ad1.idorigenc = ord.idorigen
           inner join colonias c on p.idcolonia = c.idcolonia
           inner join municipios m on c.idmunicipio = m.idmunicipio
           inner join estados e on m.idestado=e.idestado
           inner join trabajo t on t.idorigen = p.idorigen AND t.idgrupo = p.idgrupo AND t.idsocio = p.idsocio AND consecutivo = 1
           LEFT JOIN polizas as pol on ad1.idorigenc = pol.idorigenc AND ad1.periodo = pol.periodo AND ad1.idtipo = pol.idtipo AND ad1.idpoliza = pol.idpoliza
           inner join (select au.idorigen, au.idgrupo, au.idsocio,
                            --ad1.idorigenp, ad1.idproducto, ad1.idauxiliar,
                              sum (ad.monto ) as monto
                       from v_auxiliares_d as ad
                            inner join v_auxiliares as au
                            on au.idorigenp=ad.idorigenp and au.idproducto = ad.idproducto and
                               au.idauxiliar = ad.idauxiliar
                            inner join productos pr on au.idproducto = pr.idproducto
                       where periodo::integer between 202601 and 202601 and
                             pr.tipoproducto = 2 and ad.cargoabono = 0
                       group by au.idorigen, au.idgrupo, au.idsocio
                              --ad.idorigenp, ad.idproducto, ad.idauxiliar
                       having sum (ad.monto ) > 15000
                      ) as grupi on p.idorigen=grupi.idorigen and p.idgrupo=grupi.idgrupo and p.idsocio = grupi.idsocio
      where ad1.periodo::integer between 202601 and 202601 and
            pr.tipoproducto = 2  and ad1.cargoabono = 1 and ad1.monto <> 0
      order by numerosocio, nombre desc;



      --------------------------------------------------------------
      --------------------------------------------------------------
      --------------------------------------------------------------
      --CONSULTA 2 DESPUES DEL UNION

      select  
        trim(to_char(a.idorigen,'099999'))||'-'||a.idgrupo||'-'||
        trim(to_char(a.idsocio,'099999')) as numerosocio,
        trim(to_char(a.idorigenp,'099999'))||'-'||trim(to_char(a.idproducto,'09999'))||'-'||trim(to_char(a.idauxiliar,'09999999')) as numerocredito,
        pr.nombre as "nom_prod",
        nombre_x(p.appaterno, p.apmaterno,p.nombre) as nombre,
        p.fechaingreso as "fechaingreso",
             /*case p.tipo_idoficial
                  when 1 then 'INE/IFE'
                  when 2 then 'Pasaporte'
                  else 'Ninguno'
             end as  "Identificacion Oficial",*/
             (select descripcion from catalogo_menus
              where menu = 'nacionalidad' and opcion = p.nacionalidad) as "Nacionalidad",
             p.fechanacimiento as "fecha_nac",
            -----  CAMPOS PLD Y PEPS
            coalesce((select (select pld.descripcion from actividades_economicas_pld pld
                    where pld.id_actividad = t.actividad_economica_pld)
                    from trabajo t
                    where (t.idorigen,t.idgrupo,t.idsocio) = (p.idorigen,p.idgrupo,p.idsocio)
                    order by t.consecutivo desc limit 1 ), '0') as "ocupacion",
      ----------------  TERMINA NIVEL
             coalesce(t.ing_mensual_neto,0) as "ingresos",
             e.nombre as "Estado",
             m.nombre as "Municipio",
             c.nombre as "Colonia",
            coalesce(p.calle,'Sin calle') as "Calle", 
             coalesce(p.numeroext,'Sin Numero') as "Num Ext",
             coalesce(p.numeroint,'Sin Numero') as "Num Int",
             ad1.monto as "monto",
             to_char(ad1.fecha, 'DD-MM-YYYY HH24:MI:SS') as "Fecha Mov",
             ord.nombre as sucursal,
             ad1.idorigenc||'-'||ad1.periodo||'-'||ad1.idtipo||'-'||ad1.idpoliza as "poliza",
             (CASE 
                  WHEN pol.concepto LIKE '%****( SPEI%' THEN 'SPEI'
                  ELSE 'EFECTIVO'
                  END) as "tipo_mov"
             --0::numeric as "Suma"
      from v_auxiliares_d as ad1
           inner join v_auxiliares a using (idorigenp, idproducto, idauxiliar)
           inner join productos pr on ad1.idproducto = pr.idproducto
           inner join personas p on a.idorigen=p.idorigen and a.idgrupo=p.idgrupo and a.idsocio=p.idsocio
           inner join origenes ord on ad1.idorigenc = ord.idorigen
           inner join colonias c on p.idcolonia = c.idcolonia
           inner join municipios m on c.idmunicipio = m.idmunicipio
           inner join estados e on m.idestado=e.idestado
           inner join trabajo t on t.idorigen = p.idorigen AND t.idgrupo = p.idgrupo AND t.idsocio = p.idsocio AND consecutivo = 1
           LEFT JOIN polizas as pol on ad1.idorigenc = pol.idorigenc AND ad1.periodo = pol.periodo AND ad1.idtipo = pol.idtipo AND ad1.idpoliza = pol.idpoliza
           inner join (select au.idorigen, au.idgrupo, au.idsocio,
                            --ad1.idorigenp, ad1.idproducto, ad1.idauxiliar,
                              sum (ad.monto ) as monto
                       from v_auxiliares_d as ad
                            inner join v_auxiliares as au
                            on au.idorigenp=ad.idorigenp and au.idproducto = ad.idproducto and
                               au.idauxiliar = ad.idauxiliar
                            inner join productos pr on au.idproducto = pr.idproducto
                       where periodo::integer between 202601 and 202601 and
                             pr.tipoproducto = 2 and ad.cargoabono = 0
                       group by au.idorigen, au.idgrupo, au.idsocio
                              --ad.idorigenp, ad.idproducto, ad.idauxiliar
                       having sum (ad.monto ) > 150000
                      ) as grupi on p.idorigen=grupi.idorigen and p.idgrupo=grupi.idgrupo and p.idsocio = grupi.idsocio
      where ad1.periodo::integer between 202601 and 202601 and
            pr.tipoproducto = 2  and ad1.cargoabono = 1 and ad1.monto <> 0
      ORDER BY a.idorigen,a.idgrupo,a.idsocio DESC


select * from referenciasp where (idorigenp,idproducto,idauxiliar) = (30513,33612,23);


idorigenp      | 30513
idproducto     | 33612
idauxiliar     | 23
tiporeferencia | 2
referencia     | 0|C
idorigenpr     | 30513
idproductor    | 33612
idauxiliarr    | 22