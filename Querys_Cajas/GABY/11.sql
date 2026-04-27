  SELECT (substr(text(a.idorigen),4)||'-'||a.idgrupo||'-'||trim(to_char(a.idsocio,'09999999')) ) AS socio, '|' as "|",
   (substr(p.nombre||' '||p.appaterno||' '||p.apmaterno,1,30)) AS nsocio,
   (substr(text(a.idorigenp),4)||'-'||trim(to_char(a.idproducto,'09999'))||'-'||trim(to_char(a.idauxiliar,'09999999'))) AS auxiliar, '|' as "|",
   a.tasaio,'|' as "|",
   a.saldo,'|' as "|",
   a.fechaape,'|' as "|",
   date_pli(a.fechaape,int4(a.plazo)) as fechaven,'|' as "|",
   a.elaboro,'|' as "|",
   a.fechaumi,'|' as "|",
   a.plazo,'|' as "|",
   sai_token(2,sai_auxiliar(a.idorigenp,a.idproducto,a.idauxiliar,'01/09/2025'),'|') as io_aldia,'|' as "|",
   a.tipoamortizacion AS tipo_amortizacion,'|' as "|",
   (CASE WHEN (a.estatus = 0) THEN 'CAP' WHEN (a.estatus = 1) THEN 'AUT' WHEN (a.estatus = 2) THEN 'ACT' WHEN (a.estatus = 3) THEN 'PAG' WHEN (a.estatus = 4) THEN 'CAN' END) AS estatus,'|' as "|",
    numero_reinversiones_focoop(a.idorigenp,a.idproducto,a.idauxiliar) as numero_reinversiones
   FROM (auxiliares a INNER JOIN personas p USING (idorigen,idgrupo,idsocio)) WHERE a.idproducto in (200,201) and a.estatus = 2 
   ORDER BY a.idorigen, a.idgrupo, idsocio;