/*CAJA FAMA SOLICITA LO SIGUIENTE 

Esperando que se encuentren de lo mejor me comunico con la finalidad de solicitar su apoyo con la modificacion de la estimacion al 100% del siguiente Socio:
OGS: 30502-11-225389
OPA: 30502-30112-00000172 

para cambiar el EPRC al 100 se debera afectar el OPA en la tabla de referenciasp  los siguientes parametros
*/

-----UBICAMOS EL CREDITO
select * from referenciasp 
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172)
AND (idorigenpr,idproductor,idauxiliarr) = (30502,30303,2046);

-----OBTENEMOS DATOS
-[ RECORD 1 ]--+------
idorigenp      | 30502
idproducto     | 30112
idauxiliar     | 172
tiporeferencia | 2
referencia     | 0|C
idorigenpr     | 30502
idproductor    | 30303
idauxiliarr    | 2046

-----REALIZAMOS LA MODIFICACION
UPDATE referenciasp 
set tiporeferencia = 14,
    referencia = '100',
    idorigenpr   = null,
    idproductor = null,
    idauxiliarr = null
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172)
AND (idorigenpr,idproductor,idauxiliarr) = (30502,30303,2046);

/* REALIZAR UN INSERT PARA EL OTRO SOCIO */
INSERT INTO  referenciasp (idorigenp,idproducto,idauxiliar,tiporeferencia,
referencia,idorigenpr,idproductor,idauxiliarr)
VALUES (30501,30102,4558,14,'100',null,null,null);

select * from referenciasp 
where (idorigenp,idproducto,idauxiliar) = (30501,30102,4558);

select * from eprc_tmp2  
where (idorigen,idgrupo,idsocio) = (30502,11,226260);

prc1          | 100.0000
prc2          | 100.0000



/* SE REALIZO MODIFCACION EN FAMA ESTO ES PARA REGRESAR A LOS DATOS  ORIGNALES
UPDATE referenciasp 
set tiporeferencia = 14,
    referencia = '100'
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172)
AND (idorigenpr,idproductor,idauxiliarr) = (30502,30303,2046);

--- se regresaron a los parametros originales para validacion
UPDATE referenciasp 
set tiporeferencia = 2,
    referencia = '0|C',
    idorigenpr = 30502,
    idproductor = 30303,
    idauxiliarr = 2046
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172);
*/

-----VALIDAMOS EL UPDATE
select * from referenciasp 
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172);

-----CORREMOS LA TABLA DE PERC DE NUEVO
select crea_tabla_temporal_eprcc_2('31/12/2025');

-----CORREMOS EL REGULATORIO
select reg_451();

-----VALIDAMOS QUE SALGA 100 EN EL REGULATORIO
select cal_parte_expuesta from regulatorio451 
where identificador::numeric = 3050211225389;

select cal_parte_expuesta from regulatorio451 
where identificador::numeric = 3050111226260;

-----EL DATO QUE SE NECESITA ESTA EN ESTA TABLA
select * from eprc_tmp2 
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172);

prc1          | 100.0000
prc2          | 100.0000

--NOTA: ESTA TABLA SE GENERA DENTRO DEL REGULATORIO PERO PORQUE HAY UN CASE QUE VALIDA LOS DIAS VENCIDOS Y ACORDE A ELLOS LES PONE EL PORCENTAJE???
----- CASE PARA FAMA ----- YA ESTA LISTO
CASE
    WHEN EXISTS (SELECT 1 FROM referenciasp rfp
            WHERE rfp.idorigenp   = a.idorigenp
            AND rfp.idproducto  = a.idproducto
            AND rfp.idauxiliar  = a.idauxiliar
            AND rfp.tiporeferencia = 14
            AND rfp.referencia     = '100'
    ) THEN 100
    WHEN cv.diasvencidos = 0 THEN 1
    WHEN cv.diasvencidos BETWEEN 1 AND 7 THEN 4
    WHEN cv.diasvencidos BETWEEN 8 AND 30 THEN 15
    WHEN cv.diasvencidos BETWEEN 31 AND 60 THEN 30
    WHEN cv.diasvencidos BETWEEN 61 AND 90 THEN 50
    WHEN cv.diasvencidos BETWEEN 91 AND 120 THEN 75
    WHEN cv.diasvencidos BETWEEN 121 AND 180 THEN 90
    WHEN cv.diasvencidos > 180 THEN 100
END AS "CALIFICACION PARTE EXPUESTA",



----- CASE PARA MITRAS -----

-----EN EL DATO EPRC_2_CAJAS 
    -- EXISTE ALGUNA ESTIMACION ADICIONAL (COMO EN EL CASO DE MITRAS) ??? ------
    prc_extra := 0;
    select into prc_extra (case when referencia is null or referencia = ''
                                then '0' else referencia end)::integer
    from referenciasp
    where idorigenp = r_datos.idorigenp and idproducto = r_datos.idproducto and
          idauxiliar = r_datos.idauxiliar and tiporeferencia = 14 limit 1;
    if not found or prc_extra is null then prc_extra := 0; end if;
    if prc_extra > 0 then
      if prc_extra >= 100 then
        t_prc1 := 100; t_prc2 := 100;
      else
        t_prc1 := t_prc1 + prc_extra;
        t_prc2 := t_prc2 + prc_extra;
        if t_prc1 > 100 then t_prc1 := 100; end if;
        if t_prc2 > 100 then t_prc2 := 100; end if;
      end if;
    end if;

-----


LEFT JOIN eprc_tmp2 et USING (idorigenp, idproducto, idauxiliar)

select * from eprc_tmp2 
where (idorigenp,idproducto,idauxiliar) = (30502,30112,172);

(CASE
    WHEN EXISTS (SELECT 1 FROM referenciasp rfp
            WHERE rfp.idorigenp   = a.idorigenp
            AND rfp.idproducto  = a.idproducto
            AND rfp.idauxiliar  = a.idauxiliar
            AND rfp.tiporeferencia = 14
            AND rfp.referencia     = '100'
    ) THEN 100
    WHEN EXISTS (SELECT 1 FROM referenciasp rfp
            WHERE rfp.idorigenp   = a.idorigenp
            AND rfp.idproducto  = a.idproducto
            AND rfp.idauxiliar  = a.idauxiliar
            AND rfp.tiporeferencia = 14
            AND cv.diasvencidos BETWEEN 1 AND 7
    ) THEN 4 + rfp.referencia::integer

    )


    WHEN cv.diasvencidos = 0 THEN 1
    WHEN cv.diasvencidos BETWEEN 1 AND 7 THEN 4
    WHEN cv.diasvencidos BETWEEN 8 AND 30 THEN 15
    WHEN cv.diasvencidos BETWEEN 31 AND 60 THEN 30
    WHEN cv.diasvencidos BETWEEN 61 AND 90 THEN 50
    WHEN cv.diasvencidos BETWEEN 91 AND 120 THEN 75
    WHEN cv.diasvencidos BETWEEN 121 AND 180 THEN 90
    WHEN cv.diasvencidos > 180 THEN 100
END AS "CALIFICACION PARTE EXPUESTA",