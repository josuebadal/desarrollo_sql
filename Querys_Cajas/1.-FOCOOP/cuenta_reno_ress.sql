-- DROP FUNCTION public.numero_renovados_reestructurados_focoop(int4, int4, int4);

CREATE OR REPLACE FUNCTION public.numero_renovados_reestructurados_focoop(integer, integer, integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$ 

-- select * from numero_renovados_reestructurados_focoop(20702 ,       30112 ,19); --cuerpo
-- select * from numero_renovados_reestructurados_focoop(	020713,30120,00000051);  --cola corta
-- select * from numero_renovados_reestructurados_focoop(20702 , 30120 , 76 ); cola larga
-- select * from numero_renovados_reestructurados_focoop(20702 , 30112 , 10 ); 
-- select * from numero_renovados_reestructurados_focoop(20702 ,       30109 ,         154) --- cabecita
-- select * from numero_renovados_reestructurados_focoop(20702 ,       30102 ,         4724) --- cabezota


DECLARE


	idorigenp_original 			ALIAS FOR $1;
	idproducto_original   	ALIAS FOR $2;
	idauxiliar_original   	ALIAS FOR $3;

	v_contador    						integer;  

	idorigenp_r 						integer;
	idproducto_r 						integer; 
	idauxiliar_r 						integer;

	idorigenp_i 						integer;
	idproducto_i 						integer; 
	idauxiliar_i 						integer;





	v_idorigen  		integer;
	v_idgrupo       integer;
	v_idsocio       integer;

  r     									integer;

  r_rev         				  record;

  r_rec                   record;

  r_rec_1                 record;
  r_rec_2                 record;

  query_1                 text;
  query_2                 text;

  n_r                       integer;

  i                      integer;



  v_atras     							      integer;
  v_adelante     									integer;


  resultado_f                       varchar;
  posicion_actual                   integer;
  credito_original                  varchar;
  total_r                           integer;


BEGIN 

	v_contador := 0;

	/*

  drop table if exists historial_renovacion_reestructuracion;
  create  temp table historial_renovacion_reestructuracion(
	idorigenp_antes    integer,
	idproducto_antes   integer,
	idauxiliar_antes   integer,
	idorigenp_despues  integer,
	idproducto_despues integer,
	idauxiliar_despues integer,
	tiporeferencia     integer 

	);

*/
  drop table if exists historial_renovacion_reestructuracion_linea;
  create  temp table historial_renovacion_reestructuracion_linea(
  contador           integer,
	idorigenp          integer,
	idproducto         integer,
	idauxiliar         integer


	);


	select into v_idorigen, v_idgrupo ,v_idsocio  idorigen, idgrupo, idsocio 
	from v_auxiliares where 
	(idorigenp,idproducto,idauxiliar)=(	idorigenp_original ,idproducto_original, idauxiliar_original );









  -- raise notice '%',v_idorigen;
  --  raise notice '%',v_idgrupo;
   --   raise notice '%',v_idsocio;


  -------------------------------------------------------------------------------



/*

  for r_rec  in 



 select distinct 
 rf.idorigenpr,rf.idproductor,rf.idauxiliarr,rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia
from v_auxiliares as va
inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen,v_idgrupo,v_idsocio) and va.estatus in (2,3)

/* union 
select distinct rf.idorigenpr,rf.idproductor,rf.idauxiliarr,rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia
from v_auxiliares as va
inner join referenciasp as rf on rf.idorigenp= va.idorigenp and rf.idproducto= va.idproducto and rf.idauxiliar= va.idauxiliar
where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=( v_idorigen,v_idgrupo,v_idsocio) and va.estatus in (2,3)
*/

	loop

	

 insert into historial_renovacion_reestructuracion values
(
 

r_rec.idorigenpr,
r_rec.idproductor, 
r_rec.idauxiliarr,

(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar) ) in (3,2) then r_rec.idorigenp end),

(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar) ) in (3,2) then r_rec.idproducto end),

(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=(r_rec.idorigenp,r_rec.idproducto,r_rec.idauxiliar) ) in (3,2) then r_rec.idauxiliar end),


r_rec.tiporeferencia


);




	end loop;
  
delete from historial_renovacion_reestructuracion
where 
 idorigenp_despues is null or  idproducto_despues is null or idauxiliar_despues is null;

*/










select into v_atras 1 from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes) = (idorigenp_original ,idproducto_original,idauxiliar_original);


/*
	select into v_atras 1 
	from historial_renovacion_reestructuracion 
	where (idorigenp_antes,idproducto_antes,idauxiliar_antes) = (idorigenp_original ,idproducto_original,idauxiliar_original);
*/


select into v_adelante 1 from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_despues,idproducto_despues,idauxiliar_despues) = (idorigenp_original ,idproducto_original,idauxiliar_original);






	/*
	select into v_adelante 1 
	from historial_renovacion_reestructuracion 
	where (idorigenp_despues,idproducto_despues,idauxiliar_despues) = (idorigenp_original ,idproducto_original,idauxiliar_original);
  */




--	raise notice 'atras %',v_atras;
 --  raise notice 'adelante %',v_adelante;
























	if (v_atras is null and v_adelante = 1) or (v_atras = 1 and v_adelante = 1)  then   ------ nos dieron la cola 

 
 -- raise notice 'cola o cuerpo';
 

insert into historial_renovacion_reestructuracion_linea values (1,idorigenp_original ,idproducto_original,idauxiliar_original); --?

 v_contador := 1;

for r_rec_1
in 

	select * from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)






loop

if exists (	select 1 from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) )   )


then

v_contador := v_contador + 1;

-- select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes from historial_renovacion_reestructuracion where (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));
select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) );   






insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);

end if; 


end loop;




/*

if exists (select 1 from historial_renovacion_reestructuracion 
	where (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) ))
then 
v_contador := v_contador + 1;

select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes from historial_renovacion_reestructuracion where (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));

insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);

end if; 


end loop;

*/
----------------- ya tenemos el inicio


select into idorigenp_i ,idproducto_i ,idauxiliar_i  idorigenp,idproducto,idauxiliar 
from historial_renovacion_reestructuracion_linea order by contador desc;






delete from historial_renovacion_reestructuracion_linea;
	




	select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues  from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes) =  (idorigenp_i ,idproducto_i ,idauxiliar_i);





/*
select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues 
		from historial_renovacion_reestructuracion where 
		(idorigenp_antes,idproducto_antes,idauxiliar_antes) =  (idorigenp_i ,idproducto_i ,idauxiliar_i);
	*/




		insert into historial_renovacion_reestructuracion_linea values (1,idorigenp_i ,idproducto_i ,idauxiliar_i);

		
		 v_contador := 1;
		
		for r_rec_2
		in 

			select * from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)

		
		loop


		if exists (	select 1 from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) )   )

then 
		
	v_contador := v_contador + 1;


	select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues  from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes) =  ((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));






		
	--	select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues from historial_renovacion_reestructuracion where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));
		
		insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);
		
		end if; 
		
		
		
		end loop;

		/*
		if exists (select 1 from historial_renovacion_reestructuracion 
			where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) ))
		then 
		v_contador := v_contador + 1;
		
		select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues from historial_renovacion_reestructuracion where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));
		
		insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);
		
		end if; 
		
		
		
		end loop;
*/



else 

v_contador := 1;

end if;

























	if v_atras = 1 and v_adelante is null then   ------ nos dieron la cabeza 


 -- raise notice 'cabeza';



		insert into historial_renovacion_reestructuracion_linea values (1,idorigenp_original ,idproducto_original,idauxiliar_original); 
		

		/*
		select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues 
		from historial_renovacion_reestructuracion where 
		(idorigenp_antes,idproducto_antes,idauxiliar_antes) =  (idorigenp_original ,idproducto_original,idauxiliar_original);
		*/

	select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues  from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes) =  (idorigenp_original ,idproducto_original,idauxiliar_original);




		insert into historial_renovacion_reestructuracion_linea values (2,idorigenp_r ,idproducto_r ,idauxiliar_r);
		
		
		 v_contador := 2;
		
		for r_rec_1
		in select * from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null)

		
		loop
		
		if exists (select 1 from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and
(idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) ))
		
		then 
		v_contador := v_contador + 1;
		
	--	select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues from historial_renovacion_reestructuracion where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));
		

		select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues from (

	 select distinct 
	 rf.idorigenpr as idorigenp_antes,rf.idproductor as idproducto_antes,rf.idauxiliarr as idauxiliar_antes,   ---antes
	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idorigenp end) as idorigenp_despues,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idproducto end) as idproducto_despues  ,

	(case when (select estatus from v_auxiliares where (idorigenp,idproducto,idauxiliar)=( rf.idorigenp,rf.idproducto,rf.idauxiliar) ) in (3,2) then rf.idauxiliar end) as idauxiliar_despues
	               
	-- rf.idorigenp,rf.idproducto,rf.idauxiliar,rf.tiporeferencia     --renovar
	from v_auxiliares as va
	inner join referenciasp as rf on rf.idorigenpr= va.idorigenp and rf.idproductor= va.idproducto and rf.idauxiliarr= va.idauxiliar 
	where  rf.tiporeferencia in (2,3) and (va.idorigen,va.idgrupo,va.idsocio)=(v_idorigen, v_idgrupo ,v_idsocio) and va.estatus in (2,3)

) as x where (idorigenp_despues is not null or idproducto_despues is not null or idauxiliar_despues is not null) and (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));





		insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);
		
		end if; 
		
		
		
		end loop;









	else 

  v_contador := 1;

  end if;

























/*

if v_atras = 1 and v_adelante = 1  then   ------ nos dieron el cuerpo 

-- raise notice 'cuerpo';
 

insert into historial_renovacion_reestructuracion_linea values (1,idorigenp_original ,idproducto_original,idauxiliar_original); --?

 v_contador := 1;

for r_rec_1
in select * from historial_renovacion_reestructuracion 

loop

if exists (select 1 from historial_renovacion_reestructuracion 
	where (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) ))
then 
v_contador := v_contador + 1;

select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_antes,idproducto_antes,idauxiliar_antes from historial_renovacion_reestructuracion where (idorigenp_despues,idproducto_despues,idauxiliar_despues)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));

insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);

end if; 


end loop;


----------------- ya tenemos el inicio



select into idorigenp_i ,idproducto_i ,idauxiliar_i  idorigenp,idproducto,idauxiliar 
from historial_renovacion_reestructuracion_linea order by contador desc;


delete from historial_renovacion_reestructuracion_linea;




select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues 
		from historial_renovacion_reestructuracion where 
		(idorigenp_antes,idproducto_antes,idauxiliar_antes) =  (idorigenp_i ,idproducto_i ,idauxiliar_i);
		
		insert into historial_renovacion_reestructuracion_linea values (1,idorigenp_i ,idproducto_i ,idauxiliar_i);
		
		
		 v_contador := 1;
		
		for r_rec_2
		in select * from historial_renovacion_reestructuracion 
		
		loop
		
		if exists (select 1 from historial_renovacion_reestructuracion 
			where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1) ))
		then 
		v_contador := v_contador + 1;
		
		select into idorigenp_r ,idproducto_r ,idauxiliar_r  idorigenp_despues,idproducto_despues,idauxiliar_despues from historial_renovacion_reestructuracion where (idorigenp_antes,idproducto_antes,idauxiliar_antes)=((select idorigenp from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idproducto from historial_renovacion_reestructuracion_linea order by contador desc limit 1),(select idauxiliar from historial_renovacion_reestructuracion_linea order by contador desc limit 1));
		
		insert into historial_renovacion_reestructuracion_linea values (v_contador,idorigenp_r ,idproducto_r ,idauxiliar_r);
		
		end if; 
		
		
		
		end loop;




else 

v_contador := 1;

end if;

*/









if exists (select 1 from  historial_renovacion_reestructuracion_linea where (idorigenp,idproducto,idauxiliar )=(idorigenp_original ,idproducto_original, idauxiliar_original )  ) 
then 

select into credito_original TRIM(TO_CHAR(idorigenp, '099999')) || '-' || TRIM(TO_CHAR(idproducto, '09999')) || '-' || TRIM(TO_CHAR(idauxiliar , '09999999')) from historial_renovacion_reestructuracion_linea where contador =1;

select into posicion_actual contador-1 from historial_renovacion_reestructuracion_linea where (idorigenp,idproducto,idauxiliar )=(idorigenp_original ,idproducto_original, idauxiliar_original );

select into total_r max(contador)-1 from historial_renovacion_reestructuracion_linea;



resultado_f := posicion_actual::varchar  || '|' || credito_original::varchar || '|' || total_r::varchar;

else 

resultado_f := '0|0|0';

end if;



delete from historial_renovacion_reestructuracion;





return resultado_f;



END;
$function$
;
