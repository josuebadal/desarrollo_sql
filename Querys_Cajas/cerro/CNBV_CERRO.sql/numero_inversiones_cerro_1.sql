DROP FUNCTION public.numero_reinversiones_focoop(integer,integer,integer);
-- select * from numero_reinversiones_focoop(20702,00200,00006543);

-- select * from numero_reinversiones_focoop(   31003 ,        200 ,     13267);







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
	from v_auxiliares where 
	(idorigenp,idproducto,idauxiliar)=(	idorigenp_b ,idproducto_b, idauxiliar_b );

-- raise notice  ' socio: %,%,%',v_idorigen, v_idgrupo ,v_idsocio;

-- Buscamos el ogs del socio para tener el historial de inversiones que ha hecho



select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from 
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x
where (idorigenp, idproducto, idauxiliar)=(idorigenp_b ,idproducto_b, idauxiliar_b ) and cargoabono=1 ;

 -- raise notice  'primera poliza: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;

 -- BUSCAMOS LA PRIMERA POLIZA DE LA INVERSION EN DONDE SE DEPOSITO EL CAPITAL
/*
if found then 

	v_contador := 1;

	else 

	v_contador := 0;

end if;
*/



for r_rec in

select * from 

(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x

loop 

select into idorigenp_r ,idproducto_r,idauxiliar_r x.idorigenp,x.idproducto,x.idauxiliar  
from (select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x 
where (idorigenc,periodo,idtipo,idpoliza)=( idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v )  and cargoabono=0;


-- raise notice  'opa pasado : %,%,%',idorigenp_r ,idproducto_r,idauxiliar_r;




select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from  
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201) and a.estatus in (2,3)and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x 
where (idorigenp, idproducto, idauxiliar)=(idorigenp_r ,idproducto_r,idauxiliar_r) and cargoabono=1;

-- raise notice  ' poliza pasada: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;


if found  then

v_contador := v_contador + 1;

-- raise notice  ' vueltas: %,%,%,%',v_contador,idorigenp_r ,idproducto_r,idauxiliar_r ;

--- raise notice  ' poliza: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;

else 

exit;


end if;


end loop;





 -- raise notice  ' vueltas: %,%,%,%',v_contador,idorigenp_b ,idproducto_b,idauxiliar_b ;


return v_contador;




END;
$$ language 'plpgsql';




