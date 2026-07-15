      select   insm,
                   sum (monto_operaciones)  as monto_entr_sali,
                   sum (entradas_numero) as num_entr_sali,
                   tipo_oper,
                   max(tipo_clien_usua) as tipo_clien_usua,
                   max(act_eco_pld) as act_eco_pld
                   /*(case when ad.peps=1 then 'PEP'
               else ' '
               end) as espep,*/                   
          from     (select monto_operaciones,
                           numero_operaciones as entradas_numero,
                            ------------------------------------------------- 
                           case when cargoabono = 0
                                then 2
                                when cargoabono = 1
                                then 1
                           end tipo_oper,
                           -------------------------------------------------
                           insm,idorigen,idgrupo,idsocio,act_eco_pld,tipo_clien_usua 
                    from   (select   insm, cargoabono,
                                     count(*) numero_operaciones,
                                     sum(monto_operaciones) monto_operaciones,
                                     idorigen,idgrupo,idsocio,
                                     max(tipo_clien_usua) as tipo_clien_usua,
                                     max(act_eco_pld) as act_eco_pld
                                     --idcuestionario
                            from     (select (case when ad.idtipo = 3 then 8 -- TRASPASO DE FONDOS CON LA CUENTA EJE
                                                   when ad.idtipo = 2 then 2 -- CHEQUE
                                                   when ad.idtipo = 1
                                                   then (case when ad.cargoabono = 1
                                                              then (case when ad.efectivo > 0
                                                                         then 1 -- EFECTIVO
                                                                         else (case when lower(ad.concepto_pol) like '%spei%'
                                                                                    then 6 -- TRANSFERENCIA ELECTRONICA
                                                                                    else 1/*(case when de.monto_tj > 0
                                                                                               then 9 -- PAGARES TARJETA DE CREDITO O DEBITO
                                                                                               when de.monto_ch > 0
                                                                                               then 2 -- CHEQUE
                                                                                               else 1 -- EFECTIVO (por si las dudas)
                                                                                          end)*/
                                                                             end)
                                                                    end)
                                                              else 1 -- EFECTIVO
                                                         end)
                                               end) as insm,
                                             ad.cargoabono,
                                             (ad.monto + ad.montoio + ad.montoim + ad.montoiva + ad.montoivaim) as monto_operaciones,
                                             ad.idorigen,ad.idgrupo, ad.idsocio,
                                                            
                                             (case when ac.peps = 1 then 15
                                              else 1
                                              end) as tipo_clien_usua,
                                             tr.actividad_economica_pld as act_eco_pld
                                             --ad.idcuestionario
                                      from   temp_auxi ad
                                      left join personas p ON ad.idorigen = p.idorigen AND ad.idgrupo = p.idgrupo AND ad.idsocio = p.idsocio
                                      left join trabajo tr ON  ad.idorigen = tr.idorigen AND ad.idgrupo = tr.idgrupo AND ad.idsocio = tr.idsocio AND tr.consecutivo = 1
                                      left join tmp_act_peps ac ON ac.idorigen = p.idorigen AND ac.idgrupo  = p.idgrupo AND ac.idsocio  = p.idsocio
                                             /*left  join detalle_ie   as de  on    ((de.idorigenc,de.periodo,de.idtipo,de.idpoliza,de.ticket) =
                                                                                   (ad.idorigenc,ad.periodo,ad.idtipo,ad.idpoliza,ad.ticket) and 
                                                                                   de.ogs = ad.idorigen||'-'||ad.idgrupo||'-'||ad.idsocio)*/
                                      where  r_prod.idelemento::integer = ad.idcuestionario  
                             

                              UNION all

                             
                                     select (case when ar.idtipo = 3 then 8
                                                  when ar.idtipo=2 then 2
                                                  else 1 
                                            end) as insm,
                                     ar.cargoabono,
                                     (ar.monto+ar.montoiva) as monto_operaciones,
                                     ar.idorigen,ar.idgrupo,ar.idsocio,
                                     --0 as peps
                                     --ar.idcuestionario
                                    '0' as tipo_clien_usua, 
                                    NULL as act_eco_pld
                                     from temp_remesas_b ar
                                     where r_prod.idelemento::integer = ar.idcuestionario 
                                    

                                      ) ax 
                            group by insm, cargoabono, idorigen, idgrupo, idsocio --,peps
                            ) aux
                    ) mont_num 

          group by insm, tipo_oper, idorigen, idgrupo, idsocio,act_eco_pld
          order by insm, tipo_oper;