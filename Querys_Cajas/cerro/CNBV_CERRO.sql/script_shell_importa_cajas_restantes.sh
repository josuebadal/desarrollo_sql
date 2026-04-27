#!/bin/bash
# Este script se uso para copiar los saldos de diciembre/21 a marzo/22 para poder
# tener los datos correctos de saldos iniciales en el trimestre
echo "POR FAVOR ESCRIBA EL NOMBRE DE LA BASE DE DATOS DE ORIGEN : "
read base1
echo " "
echo "POR FAVOR ESCRIBA EL NOMBRE DE LA BASE DE DATOS DE DESTINO : "
read base2
echo " "
echo " "

echo "------------------------------------------- TRABAJANDO EN LA BASE ORIGEN:"
echo $base1

psql $base1 -U admin2 -c "drop table if exists tmp_folios_saldo_final_dic21;"

psql $base1 -U admin2 -c "select *
                          into   tmp_folios_saldo_final_dic21
                          from   (select   rp4.idorigenpr as origenp_ah, rp4.idproductor as producto_ah, rp4.idauxiliarr as auxiliar_ah,
                                           0 as g_idorigenp, 0 as g_idproducto, 0 as g_idauxiliar,
                                           0.00 as saldo_inicial, 0.00 as depositos, 0.00 as retiros, (ah.saldo - ah.garantia) as saldo_final,
                                           ah.saldo as saldo_aux, ah.garantia as garantia_aux,
                                           NULL as fecha_vence
                                  from     referenciasp          rp4
                                           inner join auxiliares ah  on ((ah.idorigenp,ah.idproducto,ah.idauxiliar) = (rp4.idorigenpr,rp4.idproductor,rp4.idauxiliarr))
                                  where    rp4.tiporeferencia = 4 and ah.garantia > 0 and ah.estatus = 2
                                  UNION
                                  select   rp4.idorigenpr as origenp_ah, rp4.idproductor as producto_ah, rp4.idauxiliarr as auxiliar_ah,
                                           pr.idorigenp as g_idorigenp, pr.idproducto as g_idproducto, pr.idauxiliar as g_idauxiliar,
                                           0.00 as saldo_inicial, 0.00 as depositos, 0.00 as retiros, pr.garantia as saldo_final,
                                           pr.saldo saldo_aux, pr.garantia garantia_aux,
                                           (select max(vence)
                                            from   amortizaciones
                                            where  (idorigenp,idproducto,idauxiliar) = (pr.idorigenp,pr.idproducto,pr.idauxiliar)) as fecha_vence
                                  from     referenciasp          rp4
                                           inner join auxiliares pr  using(idorigenp,idproducto,idauxiliar)
                                           inner join auxiliares ah  on   ((ah.idorigenp,ah.idproducto,ah.idauxiliar) = (rp4.idorigenpr,rp4.idproductor,rp4.idauxiliarr))
                                  where    pr.estatus = 2 and pr.garantia > 0 and rp4.tiporeferencia = 4
                                  order by origenp_ah, producto_ah, auxiliar_ah) z;"

cant=`psql $base1 -U admin2 -c "select count(*) from tmp_folios_saldo_final_dic21;" -t`

echo "---------------- REGISTROS DE AHORRO Y PRESTAMO A EXPORTAR:"
echo $cant
if [ $cant -eq 0 ]
then
  echo "NO HAY REGISTROS POR EXPORTAR !!!!!"
  exit
fi

psql $base1 -U admin2 -c "copy tmp_folios_saldo_final_dic21 to '/tmp/tmp_folios_saldo_final_dic21.txt' delimiter '|';"

echo " "
echo " "
echo "------------------------------------------ TRABAJANDO EN LA BASE DESTINO:"
echo $base2

psql $base2 -U admin2 -c "drop table if exists tmp_folios_saldo_final;"

psql $base2 -U admin2 -c "select *
                          into   tmp_folios_saldo_final
                          from   (select   rp4.idorigenpr as origenp_ah, rp4.idproductor as producto_ah, rp4.idauxiliarr as auxiliar_ah,
                                           0 as g_idorigenp, 0 as g_idproducto, 0 as g_idauxiliar,
                                           0.00 as saldo_inicial, 0.00 as depositos, 0.00 as retiros, (ah.saldo - ah.garantia) as saldo_final,
                                           ah.saldo as saldo_aux, ah.garantia as garantia_aux,
                                           NULL as fecha_vence
                                  from     referenciasp          rp4
                                           inner join auxiliares ah  on ((ah.idorigenp,ah.idproducto,ah.idauxiliar) = (rp4.idorigenpr,rp4.idproductor,rp4.idauxiliarr))
                                  where    rp4.tiporeferencia = 4 and ah.garantia > 0 and ah.estatus = 2
                                  UNION
                                  select   rp4.idorigenpr as origenp_ah, rp4.idproductor as producto_ah, rp4.idauxiliarr as auxiliar_ah,
                                           pr.idorigenp as g_idorigenp, pr.idproducto as g_idproducto, pr.idauxiliar as g_idauxiliar,
                                           0.00 as saldo_inicial, 0.00 as depositos, 0.00 as retiros, pr.garantia as saldo_final,
                                           pr.saldo as saldo_aux, pr.garantia as garantia_aux,
                                           (select max(vence)
                                            from   amortizaciones
                                            where  (idorigenp,idproducto,idauxiliar) = (pr.idorigenp,pr.idproducto,pr.idauxiliar)) as fecha_vence
                                  from     referenciasp          rp4
                                           inner join auxiliares pr  using(idorigenp,idproducto,idauxiliar)
                                           inner join auxiliares ah  on   ((ah.idorigenp,ah.idproducto,ah.idauxiliar) = (rp4.idorigenpr,rp4.idproductor,rp4.idauxiliarr))
                                  where    pr.estatus = 2 and pr.garantia > 0 and rp4.tiporeferencia = 4
                                  order by origenp_ah, producto_ah, auxiliar_ah) z;"

psql $base2 -U admin2 -c "drop table if exists tmp_folios_saldo_final_dic21;"
psql $base2 -U admin2 -c "create table tmp_folios_saldo_final_dic21(like tmp_folios_saldo_final);"
psql $base2 -U admin2 -c "copy tmp_folios_saldo_final_dic21 from '/tmp/tmp_folios_saldo_final_dic21.txt' delimiter '|';"

#-- Depura registros que ya no existen en este periodo ----
psql $base2 -U admin2 -c "with   tmp_dep
                            as   (select tm.*
                                  from   tmp_folios_saldo_final tm
                                         inner join auxiliares a on (origenp_ah,producto_ah,auxiliar_ah) = (a.idorigenp,a.idproducto,a.idauxiliar)
                                  where  a.estatus > 2 and tm.g_idorigenp > 0)
                          delete
                          from   tmp_folios_saldo_final tm
                          where  exists(select *
                                        from   tmp_dep
                                        where  (origenp_ah,producto_ah,auxiliar_ah) = (tm.origenp_ah,tm.producto_ah,tm.auxiliar_ah));"
#-- Calcula saldo_inicia y depositos y retiros ----
psql $base2 -U admin2 -c "update tmp_folios_saldo_final x1
                          set    saldo_inicial = x2.saldo_final
                          from   (select *
                                  from   tmp_folios_saldo_final_dic21) x2
                          where  x1.origenp_ah = x2.origenp_ah and x1.producto_ah = x2.producto_ah and x1.auxiliar_ah = x2.auxiliar_ah and
                                 x1.g_idorigenp = x2.g_idorigenp and x1.g_idproducto = x2.g_idproducto and x1.g_idauxiliar = x2.g_idauxiliar;"

psql $base2 -U admin2 -c "update tmp_folios_saldo_final x1
                          set    depositos = case when saldo_final > saldo_inicial then saldo_final   - saldo_inicial else 0.00 end,
                                 retiros   = case when saldo_final < saldo_inicial then saldo_inicial - saldo_final   else 0.00 end
                          where  saldo_final != saldo_inicial;"

echo " "
echo "-------------------- SE TERMINO LA EXPORTACION DE DATOS ENTRE AMBAS BASES"
echo " "

