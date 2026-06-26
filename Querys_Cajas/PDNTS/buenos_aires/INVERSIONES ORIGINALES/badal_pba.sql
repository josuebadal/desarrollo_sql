DROP FUNCTION public.numero_reinversiones(integer,integer,integer);
-- select * from numero_reinversiones(20702,00200,00006543);

-- select * from numero_reinversiones(31003 ,200 ,13267);

CREATE OR REPLACE FUNCTION public.numero_reinversiones(integer,integer,integer)
 RETURNS   integer as $$ 

DECLARE
---SE DECLARAN LOS PARAMETROS QUE RECIBE LA FUNCION
	op1				ALIAS FOR $1;
	op2   			ALIAS FOR $2;
	op3   			ALIAS FOR $3;
---SE DECLARA EL CONTADOR Y CUANTAS VUELTAS DA PARA SACAR EL TOTAL DE REINVERSIONES QUE HA TENIDO
	v_contador    			integer;  
	v_contador_vuelta       integer;
---SE DECLARA LA REFERENCIA DE PRODUCTOS PARA VALIDAR QUE SEA REINVERSION
	origen_ref 			integer;
	prdct_ref 			integer; 
	auxi_ref 			integer;
---SE DECLARA Y GUARDAN LAS POLIZAS PARA RELACIONAR LA INVERSION
	idorigenc_v 			integer;
  	periodo_v 				varchar;
  	idtipo_v 				integer;
  	idpoliza_v 				integer;
--- SE DECLARA EL RECORD
  	r_rec                   record;
---SE GUARDAN LOS PARAMETROS RECIBIDOS POR LA FUNCION
	v_idorigen  			integer;
	v_idgrupo       		integer;
	v_idsocio       		integer;

BEGIN 

		v_contador := 0;

	select into v_idorigen, v_idgrupo ,v_idsocio  idorigen, idgrupo, idsocio 
	from v_auxiliares where 
	(idorigenp,idproducto,idauxiliar)=(	op1 ,op2, op3 );

--raise notice  ' socio: %,%,%',v_idorigen, v_idgrupo ,v_idsocio;

-- Buscamos el ogs del socio para tener el historial de inversiones que ha hecho



select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from 
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen = v_idorigen and a.idgrupo = v_idgrupo and a.idsocio = v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x
where (idorigenp, idproducto, idauxiliar)=(op1 ,op2, op3 ) and cargoabono=1 ;

raise notice  'primera poliza: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;

 -- BUSCAMOS LA PRIMERA POLIZA DE LA INVERSION EN DONDE SE DEPOSITO EL CAPITAL
/*
if found then 

	v_contador := 1;

	else 

	v_contador := 0;

end if;
*/

---------------------------CHECK POINT BADAL ----------------------------
for r_rec in
select * from 
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x

loop 

select into origen_ref ,prdct_ref,auxi_ref x.idorigenp,x.idproducto,x.idauxiliar  
from (select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x 
where (idorigenc,periodo,idtipo,idpoliza)=( idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v )  and cargoabono=0;


raise notice  'opa pasado : %,%,%',origen_ref ,prdct_ref,auxi_ref;
select into idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v idorigenc,periodo,idtipo,idpoliza 
from  
(select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d ad
	 inner join auxiliares a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3) and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio
	 union all
	 select a.idorigen, a.idgrupo, a.idsocio, ad.idorigenp, ad.idproducto, ad.idauxiliar,  ad.cargoabono,  ad.idorigenc, ad.periodo, ad.idtipo, ad.idpoliza
	 from auxiliares_d_h ad
	 inner join auxiliares_h a using (idorigenp,idproducto,idauxiliar)
	 where a.idproducto in (200,201,202,203,2002,20102) and a.estatus in (2,3)and a.idorigen=v_idorigen and a.idgrupo=v_idgrupo and a.idsocio=v_idsocio) as x 
where (idorigenp, idproducto, idauxiliar)=(origen_ref ,prdct_ref,auxi_ref) and cargoabono=1;

raise notice  ' poliza pasada: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;


if found  then
v_contador := v_contador + 1;
-- raise notice  ' vueltas: %,%,%,%',v_contador,origen_ref ,prdct_ref,auxi_ref ;

---raise notice  ' poliza: %,%,%,%',idorigenc_v ,periodo_v ,idtipo_v ,idpoliza_v;
else 
exit;
end if;
end loop;
--raise notice  ' vueltas: %,%,%,%',v_contador,op1 ,op2,op3 ;
return v_contador;
END;
$$ language 'plpgsql';