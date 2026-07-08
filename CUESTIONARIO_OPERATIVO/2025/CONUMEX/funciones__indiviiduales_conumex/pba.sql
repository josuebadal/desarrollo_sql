  drop table if exists temp_auxi;
  create temp table temp_auxi as 
  (  select a.idorigen,a.idgrupo,a.idsocio,ad.*, te.idcuestionario, po.concepto as concepto_pol
     from   auxiliares_d ad 
            inner join auxiliares     a  using (idorigenp,idproducto,idauxiliar)
            inner join temp_productos te using (idproducto)
            inner join tmp_act        ta using (idorigen, idgrupo, idsocio)
            inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
     where  ad.tipomov = 0 and ad.idtipo in (1,2,3) and
            ad.periodo:: integer between p_inicial and p_final

     UNION ALL 

     select a.idorigen,a.idgrupo,a.idsocio,ad.*, te.idcuestionario, po.concepto as concepto_pol
     from   auxiliares_d_h ad 
            inner join auxiliares_h     a  using (idorigenp,idproducto,idauxiliar)
            inner join temp_productos te using (idproducto)
            inner join tmp_act        ta using (idorigen, idgrupo, idsocio)
            inner join polizas        po using (idorigenc,periodo,idtipo,idpoliza)
     where  ad.tipomov = 0 and ad.idtipo in (1,2,3) and
            ad.periodo:: integer between p_inicial and p_final
  );
  create index index_temp_auxi on temp_auxi (idorigenp,idproducto,idauxiliar);
