DROP FUNCTION public.numero_reinversiones_focoop(integer,integer,integer);
-- select * from numero_reinversiones_focoop(20703,200,26716);

-- select * from numero_reinversiones_focoop(   31003 ,200 ,13267);







CREATE OR REPLACE FUNCTION public.numero_reinversiones_focoop(integer,integer,integer)
 RETURNS   integer as $$ 

DECLARE


	idorigenp_b				ALIAS FOR $1;
	idproducto_b   			ALIAS FOR $2;
	idauxiliar_b   			ALIAS FOR $3;

	v_contador    			integer;  
	v_contador_vuelta       integer;

	idorigenp_r 						integer;
	idproducto_r 						integer; 
	idauxiliar_r 						integer;


	idorigenc_v 			integer;
  periodo_v 				varchar;
  idtipo_v 					integer;
  idpoliza_v 				integer;

  r_rec                   record;


	v_idorigen  		integer;
	v_idgrupo       integer;
	v_idsocio       integer;



BEGIN 

		v_contador := 0;




	select into v_idorigen, v_idgrupo ,v_idsocio  idorigen, idgrupo, idsocio 
	from auxiliares where 
	(idorigenp,idproducto,idauxiliar)=(	idorigenp_b ,idproducto_b, idauxiliar_b );


/*
drop table if exists tmp_inv_soc;
create temp table tmp_inv_soc as
	(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus=2 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus=3 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio);
create index tmp_auxi_idx on tmp_inv_soc(idorigen,idgrupo,idsocio,idorigenp,idproducto,idauxiliar);


*/

select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from 
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	 where pr.tipoproducto in (0,1,8) and a.estatus=2 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto  
	 where pr.tipoproducto in (0,1,8) and a.estatus=3 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x
where (idorigenp, idproducto, idauxiliar)=(idorigenp_b ,idproducto_b, idauxiliar_b );



for r_rec in

select * from 

(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	 where pr.tipoproducto in (0,1,8) and a.estatus=2 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	 where pr.tipoproducto in (0,1,8) and a.estatus=3 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x





loop 

select into idorigenp_r ,idproducto_r,idauxiliar_r idorigenp,idproducto,idauxiliar  
from (select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	 where pr.tipoproducto in (0,1,8) and a.estatus=2 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	 where pr.tipoproducto in (0,1,8) and a.estatus=3 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x where (idorigenc,periodo,idtipo,idpoliza)=( idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v ) and cargoabono=0;







select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from  
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	where pr.tipoproducto in (0,1,8) and a.estatus=2 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 inner join productos pr on a.idproducto = pr.idproducto 
	where pr.tipoproducto in (0,1,8) and a.estatus=3 and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x 
where (idorigenp, idproducto, idauxiliar)=(idorigenp_r ,idproducto_r,idauxiliar_r) and cargoabono=1;




if found then

v_contador := v_contador + 1;

else 

exit;


end if;











end loop;















 -- raise notice  ' vueltas: %,%,%,%',v_contador,idorigenp_b ,idproducto_b,idauxiliar_b ;





return v_contador;




END;
$$ language 'plpgsql';






/*





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





















*/