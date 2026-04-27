/*Creditos con garantia hipotecaria y prendaria*/

SELECT TRIM(p.nombre ||' '|| p.appaterno ||' '|| p.apmaterno) AS "Nombre de Socio",
       '|' AS "|", TRIM(TRIM(TO_CHAR(cv.idorigen,'099999')) ||'-'|| TRIM(TO_CHAR(cv.idgrupo,'09')) ||'-'|| TRIM(TO_CHAR(cv.idsocio,'099999'))) AS "Numero de Socio",
       '|' AS "|", TRIM(TO_CHAR(a.idorigenp,'099999')) ||'-'|| TRIM(TO_CHAR(a.idproducto,'09999')) ||'-'|| TRIM(TO_CHAR(a.idauxiliar,'09999999')) AS "Numero prestamo",
       '|' AS "|", UPPER(o.nombre) AS "Nombre Sucursal",
       '|' AS "|", (SELECT descripcion FROM finalidades WHERE idfinalidad = pr.tipofinalidad LIMIT 1) AS "Clasificacion del credito",
       '|' AS "|", pr.nombre AS "Producto de credito",
       '|' AS "|", (case when plazo = 1
                         then 'Pago unico de principal e interes al vencimiento'
                         else (case when a.tipoprestamo=5 and a.plazo<=18
                                    then 'Pago unico de capital y pago periodico de interes'
                                    when a.tipoprestamo=5 and a.plazo>=19
                                    then 'Pago periodico en capital y pago periodico e interes'
                                    else 'Pago periodico en capital y pago periodico e interes'
                               end)
                    end) AS "Modalidad de pago",
       '|' AS "|", a.fechaactivacion AS "Fecha de Otorgamiento",
       '|' AS "|", cv.montoprestado AS "Monto original",
       '|' AS "|", DATE(CASE WHEN a.pagodiafijo = 1
                             THEN (DATE(a.fechaactivacion + int4(a.periodoabonos)) + TEXT(a.plazo || ' month')::INTERVAL)
                             ELSE (a.fechaactivacion + int4(a.plazo * a.periodoabonos))
                        END) AS "Fecha de Vencimiento",
       '|' AS "|", TRIM(TO_CHAR(a.tasaio * 12,'99.9999')) AS "Tasa ordinaria anual",
       '|' AS "|", TRIM(TO_CHAR(a.tasaim * 12,'99.9999')) AS "Tasa moratoria anual",
       '|' AS "|", ROUND(CASE WHEN ((a.pagodiafijo = 1) OR (a.periodoabonos IN (30, 31)))
                              THEN a.plazo
                              ELSE ((a.periodoabonos*a.plazo)/30)
                         END) AS "Plazo del credito",
       '|' AS "|", a.periodoabonos AS "Frecuencia de Pagos capital",
       '|' AS "|", a.periodoabonos AS "Frecuencia de Pagos intereses",
       '|' AS "|", cv.diasvencidos AS "Dias de Mora",
       '|' AS "|", (CASE WHEN (cv.cartera = 'C' OR cv.cartera = 'M') THEN cv.saldo END) AS "Capital Vigente",
       '|' AS "|", (CASE WHEN (cv.cartera = 'V') THEN cv.saldo END) AS "Capital Vencido",
       '|' AS "|", (CASE WHEN (cv.cartera = 'C' OR cv.cartera = 'M') THEN a.idnc+a.idncm END) AS "Intereses Vigentes",
       '|' AS "|", (CASE WHEN (cv.cartera = 'V') THEN a.idnc+a.idncm END) AS "Intereses Vencido",
       '|' AS "|", a.ieco AS "Intereses devengados no cobrados cuentas de orden",
       '|' AS "|", (SELECT DATE(ad.fecha) FROM auxiliares_d ad
                    WHERE ad.idorigenp = a.idorigenp AND ad.idproducto = a.idproducto AND ad.idauxiliar = a.idauxiliar AND
                          ad.cargoabono = 1 AND ad.monto > 0
                    ORDER BY ad.fecha DESC
                    LIMIT 1) AS "Fecha del Ultimo Pago de Capital",
       '|' AS "|", (SELECT monto FROM auxiliares_d ad
                    WHERE ad.idorigenp = a.idorigenp AND ad.idproducto = a.idproducto AND ad.idauxiliar = a.idauxiliar AND
                          ad.cargoabono=1 AND ad.monto > 0
                    ORDER BY ad.fecha DESC
                    LIMIT 1) AS "Ultimo Pago de Capital",
       '|' AS "|", (SELECT DATE(ad.fecha) FROM auxiliares_d ad
                    WHERE ad.idorigenp = a.idorigenp AND ad.idproducto = a.idproducto AND ad.idauxiliar = a.idauxiliar AND
                          ad.cargoabono = 1 AND (ad.montoio+ad.montoiva) > 0
                    ORDER BY ad.fecha DESC
                    LIMIT 1) AS "Fecha del Ultimo Pago de Intereses",
       '|' AS "|", (SELECT (ad.montoio + ad.montoiva) FROM auxiliares_d ad
                    WHERE ad.idorigenp = a.idorigenp AND ad.idproducto = a.idproducto AND ad.idauxiliar = a.idauxiliar AND
                          ad.cargoabono = 1 AND (ad.montoio+ad.montoiva) > 0
                    ORDER BY ad.fecha DESC LIMIT 1) AS "Ultimo Pago de Intereses",
       '|' AS "|", (CASE a.tipoprestamo
                        WHEN 0 THEN 'Normal'
                        WHEN 1 THEN 'Renovado (seps)'
                        WHEN 2 THEN 'Reestructurado (seps)'
                        WHEN 3 THEN 'Renovado (ceps)'
                        WHEN 4 THEN 'Reestructurado (ceps)'
                        ELSE 'Desconocido'
                  END)AS "Tipo de credito",
       '|' AS "|", (CASE WHEN (a.tipoprestamo > 0 AND a.tipoprestamo < 5)
                         THEN (CASE WHEN (SELECT rp.idauxiliar FROM referenciasp rp
                                          WHERE rp.tiporeferencia IN (2,3) AND TRIM(SAI_TOKEN (2, rp.referencia, '|')) = 'V' AND
                                                rp.idorigenp = a.idorigenp AND rp.idproducto = a.idproducto AND
                                                rp.idauxiliar = a.idauxiliar) > 0
                                    THEN 'Si'
                                    ELSE 'No'
                               END)
                         ELSE 'No'
                    END) AS "Credito emproblemado",
       '|' AS "|", (CASE WHEN (cv.cartera = 'C' OR cv.cartera = 'M') THEN 'Vigente' ELSE 'Vencido' END)
                   AS "Clasificacion contable",
       '|' AS "|", 'NO DATO' AS "CARGO DEL ACREDITADO PARTE RELACIONADA",
       '|' AS "|", a.garantia AS "Monto garantia liquida",
       '|' AS "|", TRIM(TO_CHAR(rp.idorigenpr,'099999'))||'-'||TRIM(TO_CHAR(rp.idproductor,'09999'))||'-'||
                   TRIM(TO_CHAR(rp.idauxiliarr,'09999999')) AS "Cuenta, garanta liquida",
       '|' AS "|", COALESCE(pre.monto, 0) AS "Monto de garanta prendaria",
       '|' AS "|", COALESCE(hip.monto, 0) AS "Monto de garantia hipotecaria",
       '|' AS "|", et.e_parte_cub AS "EPRC contable para parte cubierta",
       '|' AS "|", et.e_parte_exp AS "EPRC contable para parte expuesta",
--       '|' AS "|", (CASE WHEN cv.cartera != 'C' THEN a.idnc END) AS "EPRC contable x intereses de CaVe",
       '|' AS "|", (CASE WHEN cv.cartera = 'V' THEN a.idnc ELSE 0.00 END) AS "EPRC contable x intereses de CaVe",
       '|' AS "|", (SELECT MIN(vence) FROM amortizaciones am
                    WHERE am.idorigenp = a.idorigenp AND am.idproducto = a.idproducto AND am.idauxiliar = a.idauxiliar AND
                          todopag = FALSE AND DATE(vence) <= (SELECT DISTINCT fechatrabajo FROM origenes)::DATE)
                   AS "Primera amortizacion no cubierta",
       '|' AS "|", a.im AS "Intereses moratorios",
       '|' AS "|", (SELECT SUM(vad.montoio)
                    FROM (SELECT idorigenpr AS idorigenp, idproductor AS idproducto, idauxiliarr AS idauxiliar
                          FROM referenciasp rp
                          WHERE rp.idorigenp = cv.idorigenp AND rp.idproducto = cv.idproducto AND rp.idauxiliar = cv.idauxiliar) rp
                         INNER JOIN (SELECT idorigenp, idproducto, idauxiliar, montoio, saldoec
                                     FROM auxiliares_d ad1
                                     WHERE ad1.idorigenp = cv.idorigenp AND ad1.idproducto = cv.idproducto AND
                                           ad1.idauxiliar = cv.idauxiliar
                                     UNION
                                     SELECT idorigenp, idproducto, idauxiliar, montoio, saldoec
                                     FROM auxiliares_d_h ad2
                                     WHERE ad2.idorigenp = cv.idorigenp AND ad2.idproducto = cv.idproducto AND
                                           ad2.idauxiliar = cv.idauxiliar) vad
                               USING (idorigenp, idproducto, idauxiliar)
                    WHERE vad.saldoec = 0) AS "Intereses refinanciados o capitalizados",
       '|' AS "|", p.rfc AS "RFC",
       '|' AS "|", p.curp AS "CURP",
       '|' AS "|", (CASE WHEN a.tipoprestamo IN (1, 3) THEN fechaactivacion END) AS "Fecha en que se renovo por ultima vez",
       '|' AS "|", (CASE WHEN a.tipoprestamo IN (2, 4) THEN fechaactivacion END) AS "Fecha en que se reestructuro por ultima vez",
       '|' AS "|", SAI_TOKEN (2, (CASE WHEN a.tipoprestamo IN (2, 4)
                                       THEN (CASE WHEN conteo_renovado_reestructurado(a.idorigenp, a.idproducto, a.idauxiliar, '0|0') = '0|0'
                                                  THEN '0|1'
                                                  ELSE conteo_renovado_reestructurado(a.idorigenp, a.idproducto, a.idauxiliar, '0|0')
                                             END)
                                  END ), '|') AS "Renovaciones que ha tenido",
       '|' AS "|", SAI_TOKEN (1, (CASE WHEN a.tipoprestamo IN (1, 3)
                                       THEN (CASE WHEN conteo_renovado_reestructurado(a.idorigenp, a.idproducto, a.idauxiliar,'0|0') = '0|0'
                                                  THEN '1|0'
                                                  ELSE conteo_renovado_reestructurado(a.idorigenp, a.idproducto, a.idauxiliar,'0|0')
                                             END)
                                  END), '|') AS "Reestructuras que ha tenido",
       '|' AS "|", cv.diasvencidos AS "Dias de Mora",
       '|' AS "|", 'NO DATO' AS "Crditos otorgados a partes relacionadas",
       '|' AS "|", 'NO DATO' AS "Monto de la estimacion preventiva"
FROM carteravencida cv
     INNER JOIN personas p USING (idorigen, idgrupo, idsocio)
     INNER JOIN auxiliares a USING (idorigenp, idproducto, idauxiliar)
     INNER JOIN origenes o ON (a.idorigenp = o.idorigen)
     INNER JOIN eprc_ultimos_calculos et USING (idorigenp, idproducto, idauxiliar)
     INNER JOIN productos pr ON (cv.idproducto = pr.idproducto)
     INNER JOIN vcolonias vc ON (p.idcolonia = vc.idcolonia)
     INNER JOIN municipios m ON (vc.idmunicipio = m.idmunicipio)
     LEFT JOIN (SELECT idorigenp,idproducto,idauxiliar,idorigenpr,idproductor,idauxiliarr
                FROM referenciasp
                WHERE tiporeferencia = 4) rp
               ON (a.idorigenp = rp.idorigenp AND a.idproducto = rp.idproducto AND a.idauxiliar = rp.idauxiliar)
     LEFT JOIN (SELECT  idorigenp,idproducto,idauxiliar, SUM(monto) as monto FROM  garantias_hipotecarias  where es_prendaria = 't' GROUP BY idorigenp,idproducto,idauxiliar ) pre ON a.idorigenp = pre.idorigenp AND a.idproducto = pre.idproducto AND a.idauxiliar = pre.idauxiliar
     LEFT JOIN (SELECT idorigenp,idproducto,idauxiliar, SUM(monto) as monto FROM garantias_hipotecarias where es_prendaria = 'f' GROUP  BY idorigenp,idproducto,idauxiliar) hip ON a.idorigenp = hip.idorigenp AND a.idproducto = hip.idproducto AND a.idauxiliar = hip.idauxiliar
WHERE fechacalculo  = (SELECT DISTINCT DATE(fechatrabajo) FROM origenes) and 
      a.idproducto between 30000 and 39999 and a.estatus=2 
ORDER BY a.idorigen, a.idgrupo, a.idsocio, a.idorigenp, a.idproducto, a.idauxiliar;

